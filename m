Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE250E7E63F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 26 Sep 2023 14:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbjIZOxj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIZOxj (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 26 Sep 2023 10:53:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CFAE6
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:53:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-53447d0241eso3479998a12.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695740011; x=1696344811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7XcufRT/6krzC/xvEcvh3gsNxGo6wGLO2DchJZj+b8=;
        b=ktAjt5u6ypPng7a8t5/XL8IYhlrLIcSIeVnasjmy7+SblDeOEmXhznGtpggvW6wWab
         YbD1tuBlCMW/slLer/Y+SgjZE/2GEDW45nxJT0Vd5kdfJYADtPf3M2bzirjCxWgdF/7j
         Dj5YjPQPptcCBp7a750DjK1Z4sgBMd+8rOsPiAvnkjaMPCOI9V0t3LF1VP7s7HsOtt24
         jmx/BaZq0jSH8iahLJaCJZQDkVT5kRttZUn8pBdjLexBJRhfan8uR4ACvo4+Meqjo4Kq
         LFMSIhT8pnvd0gUHN47ufAetaBTArncYHEopAiPXTX8Jtd4QekK8NCLV6IIfdDY6yaTk
         Aznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695740011; x=1696344811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7XcufRT/6krzC/xvEcvh3gsNxGo6wGLO2DchJZj+b8=;
        b=MmjTyRDLBIV/XsqSEc481CEaLyarxpi44Q0SSRKPVvauCkEQCw2yZNyDa3SckY0R1e
         6fyCsGlK/iGuMWRIJT12XY8jWoJIUJnATUHmAVttNG5QkMOxkqrONTe3DcPkdLYuSaP6
         +DVgZDxxLJV5ZPcd8bsOY0CZpBdraSO8Oe+x2pDTjGdlFDPzMvyrc5cOH7Vf9g6cNCEB
         HRFd51kf0WfDK3N6spFD2EIaV9Yskqnav99Aa1AF0EM1/RZdeN6/GHmL2XW+KdPYLBPa
         3b4NXUvV3KLf5Ts7nffE1lGOGby0lSClWYkSfO4RZF8NxQyvcKRh2zLSPQ0D3Jeozi3J
         O7qg==
X-Gm-Message-State: AOJu0YyzXqv3gT7EypE+djU1n24fqSmfYvWg9qVz+Lo3Mgf7t/1zgeNh
        5kbk0dezeCnvlmqTJY99lNbV+Q==
X-Google-Smtp-Source: AGHT+IH3mOWgi7O3Y3V6x5wQ0fsn29xCb67WKtJtaW28mYZs3uELvluEmCEXEMJ3H16d6CfEYbk8mQ==
X-Received: by 2002:a05:6402:4444:b0:533:d81b:36d5 with SMTP id o4-20020a056402444400b00533d81b36d5mr7502410edb.15.1695740011050;
        Tue, 26 Sep 2023 07:53:31 -0700 (PDT)
Received: from localhost (h3221.n1.ips.mtn.co.ug. [41.210.178.33])
        by smtp.gmail.com with ESMTPSA id d15-20020aa7d68f000000b005333922efb0sm6877621edr.78.2023.09.26.07.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 07:53:30 -0700 (PDT)
Date:   Tue, 26 Sep 2023 17:53:27 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: no checking for bch2_seek_pagecache_hole()
Message-ID: <5fb857fc-ccac-4d45-a605-d00699e96fc3@kadam.mountain>
References: <50693705-a6ea-4cd6-b41b-d0c2324ecfd2@moroto.mountain>
 <20230920023116.556mhm6qdjtu2crv@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920023116.556mhm6qdjtu2crv@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 10:31:16PM -0400, Kent Overstreet wrote:
> On Fri, Sep 15, 2023 at 03:57:56PM +0300, Dan Carpenter wrote:
> > Hello Kent Overstreet,
> > 
> > The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> > (linux-next), leads to the following Smatch static checker warning:
> > 
> > 	fs/bcachefs/fs-io.c:1013 bch2_seek_hole()
> > 	warn: error code type promoted to positive: 'next_hole'
> > 
> > fs/bcachefs/fs-io.c
> >     977 static loff_t bch2_seek_hole(struct file *file, u64 offset)
> >     978 {
> >     979         struct bch_inode_info *inode = file_bch_inode(file);
> >     980         struct bch_fs *c = inode->v.i_sb->s_fs_info;
> >     981         struct btree_trans *trans;
> >     982         struct btree_iter iter;
> >     983         struct bkey_s_c k;
> >     984         subvol_inum inum = inode_inum(inode);
> >     985         u64 isize, next_hole = MAX_LFS_FILESIZE;
> >     986         u32 snapshot;
> >     987         int ret;
> >     988 
> >     989         isize = i_size_read(&inode->v);
> >     990         if (offset >= isize)
> >     991                 return -ENXIO;
> >     992 
> >     993         trans = bch2_trans_get(c);
> >     994 retry:
> >     995         bch2_trans_begin(trans);
> >     996 
> >     997         ret = bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot);
> >     998         if (ret)
> >     999                 goto err;
> >     1000 
> >     1001         for_each_btree_key_norestart(trans, iter, BTREE_ID_extents,
> >     1002                            SPOS(inode->v.i_ino, offset >> 9, snapshot),
> >     1003                            BTREE_ITER_SLOTS, k, ret) {
> >     1004                 if (k.k->p.inode != inode->v.i_ino) {
> >     1005                         next_hole = bch2_seek_pagecache_hole(&inode->v,
> >     1006                                         offset, MAX_LFS_FILESIZE, 0, false);
> >     1007                         break;
> >     1008                 } else if (!bkey_extent_is_data(k.k)) {
> >     1009                         next_hole = bch2_seek_pagecache_hole(&inode->v,
> >     1010                                         max(offset, bkey_start_offset(k.k) << 9),
> >     1011                                         k.k->p.offset << 9, 0, false);
> >     1012 
> > 
> > bch2_seek_pagecache_hole returns llof_t.  Negatives on error.  This code
> > has no error checking?
> 
> It doesn't return an error.

It looks to the untrained eye that folio_hole_offset() can return
-ENOENT.  And __filemap_get_folio() can definitely return -ENOMEM.

regards,
dan carpenter
