Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87895EDE99E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 10:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbjINKNP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjINKNP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 06:13:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCD1BE3
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 03:13:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-313e742a787so498844f8f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 03:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694686389; x=1695291189; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fz2RmmuMOWJ+XaDFM9256Vz7dKbR72dD4o7Ampb7YhY=;
        b=yyC0SIp0FIgt2AWTlguTSmQMwL/iAPT9/v+166xhCweE6s31mxu4eCd7QFxBwkYy76
         jHbBuYHjckEI36AwjOqTIN5auzYmFnRoN7/nyrm5NL/hk3RdibyFnaMNhnLwgGN/ljMW
         t5VXy4Sh1f3QElDhLwEEbWY9dot0TxBMnTI2jy+7MBpQ6bLmD2BEO0Y9KGrhS/vUZICC
         QIOOxhPGpWw1fah6ONzwAcbsKibxm1Bu8irc277j5qdhxlNOYuaCYBVk7INhhUqr3h+R
         BP+ENSqODlu4zKoQcH0M+KkyL/ljVPrpyoH4jdc8UeQbuR4UMyqu0AKezoPGKkD6LBtV
         jt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694686389; x=1695291189;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fz2RmmuMOWJ+XaDFM9256Vz7dKbR72dD4o7Ampb7YhY=;
        b=M3jafRcldnLMM5WGpVI3rXpK39v1izzePAR7tqoGS8N8NdqqlmstFrcPncpPAOMzu4
         FR9TRB/Oz9GWnoZt/cnFpjM8g/hHlf+Eu6Lzz8YhKyZJqi6mN5nxoKXV7OxTcu3ShiYL
         cmml0Kbw9pYn7ZjA4A3rJ+sEJHn6nvb24gSft8ZLZSFBJWw/wpL2FDDbqLczusW4Uiji
         hsRiseLCE1esnRLEY6eILpZluXFroU3Whr5cIiO3Yc38Te/CmToFHNRZx8vXPBLZWaKV
         egHxy7MzjpfJmSddZO9Akl6Ha8ACM49h1u1snT/we/Nd3TCFJigvSpRjR5nJ2uxMCdQH
         Nh+A==
X-Gm-Message-State: AOJu0YxhwP+kIdcbx5FHJJOcnDQ1ApEllAoHLJyx1M6N4s1r2e9tmHNI
        LRbH60DRSqOHkVh1UTpptle1sDss0h7vMk3/5LU=
X-Google-Smtp-Source: AGHT+IG99gR/QM5Vjqi/gNoY7LqN9sAd8b2JArcMPESUxocaDFNJYs1RSLS82XOfc7tL9+S8HgVntA==
X-Received: by 2002:adf:de0e:0:b0:314:2f3e:dca5 with SMTP id b14-20020adfde0e000000b003142f3edca5mr1117352wrm.28.1694686389493;
        Thu, 14 Sep 2023 03:13:09 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q2-20020adff782000000b00317f70240afsm1352331wrp.27.2023.09.14.03.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 03:13:08 -0700 (PDT)
Date:   Thu, 14 Sep 2023 13:13:05 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@linux.dev
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Fix bch2_check_discard_freespace_key()
Message-ID: <a7450ee4-6cfc-4c36-a203-dccc21e0f0a5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 6489d817f5e2: "bcachefs: Fix
bch2_check_discard_freespace_key()" from Jun 18, 2023 (linux-next),
leads to the following Smatch static checker warning:

	fs/bcachefs/alloc_background.c:1295 bch2_check_discard_freespace_key()
	error: uninitialized symbol 'ret'.

fs/bcachefs/alloc_background.c
    1281 static int bch2_check_discard_freespace_key(struct btree_trans *trans,
    1282                                             struct btree_iter *iter,
    1283                                             struct bpos end)
    1284 {
    1285         if (!btree_id_is_extents(iter->btree_id)) {
    1286                 return __bch2_check_discard_freespace_key(trans, iter);
    1287         } else {
    1288                 int ret;
    1289 
    1290                 while (!bkey_eq(iter->pos, end) &&

What about if bkey_eq() is at the end on the first iteration through the
loop?

    1291                        !(ret = btree_trans_too_many_iters(trans) ?:
    1292                                __bch2_check_discard_freespace_key(trans, iter)))
    1293                         bch2_btree_iter_set_pos(iter, bpos_nosnap_successor(iter->pos));
    1294 
--> 1295                 return ret;
    1296         }
    1297 }

regards,
dan carpenter
