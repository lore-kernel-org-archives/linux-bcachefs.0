Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86665EE6457
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjIOM6H (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbjIOM6H (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:58:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36EA1FE0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:58:01 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31ff2ce9d4cso581731f8f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782680; x=1695387480; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j4a9QBXIkkHg4D/a/mcMVFDLel+C4hLxswjF2087j9M=;
        b=wMhoN4q2r9ADTH1tHWXOaW/kWlwIv5iEmdwG+zXZ+wgMhOALg+J/EZwWo1w0m/scyY
         PCpS/NnNa+U01pnRCC9WcjXNgayCnnwoG7qH7u+aF85gLQ6RRJ23n3c5898r4Sk5IMZd
         AWfo4Lymosb/QXH5iKdanZULTH8AgiT+8AWN/GH0MaBUls7iB5kygRD+rk+QYxiyN3EY
         vslAdAjMdW1H+B+/KRra2v0MlUHSEPMp7wCxkb5rzcmHVRNzjOug4CSxoNzMtM3aGtyA
         BJE4ueLFb1oo7/RRMES1L+wTde332S7AQ9uI3qiUbgZNKwCH5Yz5M7AMXVTXb7yn+tnm
         sOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782680; x=1695387480;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4a9QBXIkkHg4D/a/mcMVFDLel+C4hLxswjF2087j9M=;
        b=jtTi8eclPDua/8EhFr/a/WrMKED73Kbd0paB3H45AxBP7Y2DaX+4syPgKHMq/BuM2b
         G4orKdY6aTot3Uw8NYyf5avoMWMghZVcrfXRCIE7rj9xQ6kHbPdEzgTH/I+Xcse+bHH7
         e0VB4GQdQ8QVRXfjLYRtTXBBgPHoI9neKu1GbWZ9C4QwTpsB6f7IPrloGDtncL2jMty7
         Qk5T5fHIJs3HEr4BvJZWVjWS3HjD5Z65+EvEHS+1+vBt/7W4E6fViB1Y5T/PHABugwXu
         icnqQ0P22cBixsW2wBCoctpMcXgedMVyhEtjiJbHIEzPFyX/EGwfyaCRZV0yx8inOC1a
         tDxg==
X-Gm-Message-State: AOJu0YyR8aZV7NSS/GYk5xFOd3ndk2mk5K3STAhAbCiE8AXy7zZFvxMw
        AlRXoSNn/q4n8QlyNZo2jCt2fYiZ3w2wEfXP3FE=
X-Google-Smtp-Source: AGHT+IH+U+idwNuE0H3NYH7zVlWUYHaXDmlGzu3kwnwnUnidfjkQNc1Emo9KDCpDqhC+sza/+gc2yg==
X-Received: by 2002:adf:e7d2:0:b0:317:4cf8:35f9 with SMTP id e18-20020adfe7d2000000b003174cf835f9mr1320379wrn.16.1694782680208;
        Fri, 15 Sep 2023 05:58:00 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m18-20020a5d4a12000000b0031f65cdd271sm4369162wrq.100.2023.09.15.05.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:57:59 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:57:56 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: no checking for bch2_seek_pagecache_hole()
Message-ID: <50693705-a6ea-4cd6-b41b-d0c2324ecfd2@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/fs-io.c:1013 bch2_seek_hole()
	warn: error code type promoted to positive: 'next_hole'

fs/bcachefs/fs-io.c
    977 static loff_t bch2_seek_hole(struct file *file, u64 offset)
    978 {
    979         struct bch_inode_info *inode = file_bch_inode(file);
    980         struct bch_fs *c = inode->v.i_sb->s_fs_info;
    981         struct btree_trans *trans;
    982         struct btree_iter iter;
    983         struct bkey_s_c k;
    984         subvol_inum inum = inode_inum(inode);
    985         u64 isize, next_hole = MAX_LFS_FILESIZE;
    986         u32 snapshot;
    987         int ret;
    988 
    989         isize = i_size_read(&inode->v);
    990         if (offset >= isize)
    991                 return -ENXIO;
    992 
    993         trans = bch2_trans_get(c);
    994 retry:
    995         bch2_trans_begin(trans);
    996 
    997         ret = bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot);
    998         if (ret)
    999                 goto err;
    1000 
    1001         for_each_btree_key_norestart(trans, iter, BTREE_ID_extents,
    1002                            SPOS(inode->v.i_ino, offset >> 9, snapshot),
    1003                            BTREE_ITER_SLOTS, k, ret) {
    1004                 if (k.k->p.inode != inode->v.i_ino) {
    1005                         next_hole = bch2_seek_pagecache_hole(&inode->v,
    1006                                         offset, MAX_LFS_FILESIZE, 0, false);
    1007                         break;
    1008                 } else if (!bkey_extent_is_data(k.k)) {
    1009                         next_hole = bch2_seek_pagecache_hole(&inode->v,
    1010                                         max(offset, bkey_start_offset(k.k) << 9),
    1011                                         k.k->p.offset << 9, 0, false);
    1012 

bch2_seek_pagecache_hole returns llof_t.  Negatives on error.  This code
has no error checking?

--> 1013                         if (next_hole < k.k->p.offset << 9)
    1014                                 break;
    1015                 } else {
    1016                         offset = max(offset, bkey_start_offset(k.k) << 9);
    1017                 }
    1018         }
    1019         bch2_trans_iter_exit(trans, &iter);
    1020 err:
    1021         if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
    1022                 goto retry;
    1023 
    1024         bch2_trans_put(trans);
    1025         if (ret)
    1026                 return ret;
    1027 
    1028         if (next_hole > isize)
    1029                 next_hole = isize;
    1030 
    1031         return vfs_setpos(file, next_hole, MAX_LFS_FILESIZE);
    1032 }

regards,
dan carpenter
