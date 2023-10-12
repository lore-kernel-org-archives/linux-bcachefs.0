Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BFBCDB46E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 12 Oct 2023 09:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbjJLJn4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 12 Oct 2023 05:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbjJLJnx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 12 Oct 2023 05:43:53 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F28BA
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Oct 2023 02:43:51 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-405361bba99so7670045e9.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Oct 2023 02:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697103830; x=1697708630; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80KQwHZS2L1cgtTUnBG228r6in8Wi1eyN85GmoX3ijA=;
        b=W213C1KrExZsh85k5F8anPC5bU3NRAdSnrGWb5o59TrFvxDhb/w+qOtOyYOEsZmwJN
         q3+fm+r/WD2Lo52IUta2rEmNhp4CoYS2rCoFHcoJU1x4Ew2okU3rF/68RpJPxZrA7IDC
         RaIb5K9O9bVRXYPcKGwfQzrXCi4WH5ZGIWJS8M3RW9K3w8ATngXcuTgfVe9Y7skaJUQi
         gWXlwsGp7P9bkGuc2DLl7Z+9baSCcd4ZInZwa3CjlF+F6668W31zSJ/c53yLcokl4YIS
         e458uYlHG/WS5SkTHOgj/REjeqICs6O69rOZyO92wxEJqlNEZjXA5XUleLvzifG64//w
         jWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697103830; x=1697708630;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80KQwHZS2L1cgtTUnBG228r6in8Wi1eyN85GmoX3ijA=;
        b=wDzohQa2v9rDZkqUeYdspOZ+b9G9WcnXkC9EBAfHuEP5EL523/5CxAIFDp46p2iw53
         TF1bHvXTWiJA/daEqOrKcztbNYuXOKvIfGpdDJZnm5q93h3HKqgh6yqXHZsjWt8IAd0A
         Ry50qz1+9T01TAt496/uJcl2p3VfcG6No11bCE4qJgyll1utl0+ulK6B6gYrZFK2qRaS
         hzDnvP2fh9bfOOCgnxid3iz2pSa17ZIKaJhnoFSQ2m8FJHLOh4kMxd+z4FwHd2TPadbB
         ya2HWVGYJkepUe2pee+99THoAEXG/F4aPepjmRiTpdw2Twi+K4gblPak1E7uneRIXDia
         ywzA==
X-Gm-Message-State: AOJu0YzdMR7wc0EsqpiZG+zw+5vVAvy2y0gkYu6ULPIY4nSZawGp0vTA
        WUtrkoyzDeDFfFCIJbaDMGaWgw==
X-Google-Smtp-Source: AGHT+IGABRdHpUIhZnG7BIkaySzTWLIodpVTha17bZ/kzP2rHcXD+FJrJ0ooacvs7zsVdP74p3/LOg==
X-Received: by 2002:a7b:c38b:0:b0:405:3559:7c0a with SMTP id s11-20020a7bc38b000000b0040535597c0amr20088375wmj.3.1697103829940;
        Thu, 12 Oct 2023 02:43:49 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c20d300b004075b3ce03asm5642875wmm.6.2023.10.12.02.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 02:43:49 -0700 (PDT)
Date:   Thu, 12 Oct 2023 12:43:46 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: missing error checking in
 __bch2_btree_root_alloc()
Message-ID: <14684abe-5652-459d-aae5-278da8cb7b36@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/btree_update_interior.c:2336 __bch2_btree_root_alloc()
	error: 'b' dereferencing possible ERR_PTR()

fs/bcachefs/btree_update_interior.c
    2319 static int __bch2_btree_root_alloc(struct btree_trans *trans, enum btree_id id)
    2320 {
    2321         struct bch_fs *c = trans->c;
    2322         struct closure cl;
    2323         struct btree *b;
    2324         int ret;
    2325 
    2326         closure_init_stack(&cl);
    2327 
    2328         do {
    2329                 ret = bch2_btree_cache_cannibalize_lock(c, &cl);
    2330                 closure_sync(&cl);
    2331         } while (ret);
    2332 
    2333         b = bch2_btree_node_mem_alloc(trans, false);

Smatch complains that bch2_btree_node_mem_alloc() can fail

    2334         bch2_btree_cache_cannibalize_unlock(c);
    2335 
--> 2336         set_btree_node_fake(b);
                                     ^
Leading to a crash.

    2337         set_btree_node_need_rewrite(b);
    2338         b->c.level        = 0;
    2339         b->c.btree_id        = id;
    2340 

regards,
dan carpenter
