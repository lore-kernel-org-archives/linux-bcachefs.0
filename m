Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B997CE79A8
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 02:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjITCb3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 22:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjITCb1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 22:31:27 -0400
Received: from out-228.mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3368C5
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 19:31:21 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695177079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tZvDvXAkrzpJMLuZJw+BEn86dl4+vnBt3HB+ZB9qSRM=;
        b=Fy8tkYLX+bJk5Jd+LT892Ak0ZKxCFuWSztcz/VsglgrQUVCuvoYmqUyPgFg33NawZQxGFs
        gUyUW0ajWKff8LjYL+wCcgC+6L160U2DgcctraoSxZzJ+aMWPQZOzBMEJmvMK+3mykW3Hj
        kjirO2p/22unM4dXbsvn4hbmKjZYUtw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: no checking for bch2_seek_pagecache_hole()
Message-ID: <20230920023116.556mhm6qdjtu2crv@moria.home.lan>
References: <50693705-a6ea-4cd6-b41b-d0c2324ecfd2@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50693705-a6ea-4cd6-b41b-d0c2324ecfd2@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:57:56PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/fs-io.c:1013 bch2_seek_hole()
> 	warn: error code type promoted to positive: 'next_hole'
> 
> fs/bcachefs/fs-io.c
>     977 static loff_t bch2_seek_hole(struct file *file, u64 offset)
>     978 {
>     979         struct bch_inode_info *inode = file_bch_inode(file);
>     980         struct bch_fs *c = inode->v.i_sb->s_fs_info;
>     981         struct btree_trans *trans;
>     982         struct btree_iter iter;
>     983         struct bkey_s_c k;
>     984         subvol_inum inum = inode_inum(inode);
>     985         u64 isize, next_hole = MAX_LFS_FILESIZE;
>     986         u32 snapshot;
>     987         int ret;
>     988 
>     989         isize = i_size_read(&inode->v);
>     990         if (offset >= isize)
>     991                 return -ENXIO;
>     992 
>     993         trans = bch2_trans_get(c);
>     994 retry:
>     995         bch2_trans_begin(trans);
>     996 
>     997         ret = bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot);
>     998         if (ret)
>     999                 goto err;
>     1000 
>     1001         for_each_btree_key_norestart(trans, iter, BTREE_ID_extents,
>     1002                            SPOS(inode->v.i_ino, offset >> 9, snapshot),
>     1003                            BTREE_ITER_SLOTS, k, ret) {
>     1004                 if (k.k->p.inode != inode->v.i_ino) {
>     1005                         next_hole = bch2_seek_pagecache_hole(&inode->v,
>     1006                                         offset, MAX_LFS_FILESIZE, 0, false);
>     1007                         break;
>     1008                 } else if (!bkey_extent_is_data(k.k)) {
>     1009                         next_hole = bch2_seek_pagecache_hole(&inode->v,
>     1010                                         max(offset, bkey_start_offset(k.k) << 9),
>     1011                                         k.k->p.offset << 9, 0, false);
>     1012 
> 
> bch2_seek_pagecache_hole returns llof_t.  Negatives on error.  This code
> has no error checking?

It doesn't return an error.
