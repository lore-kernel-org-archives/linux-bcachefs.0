Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E123CEDE99C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 10:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbjINKTA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238023AbjINKS7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 06:18:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600DC1BFB
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 03:18:55 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-31aeedbb264so684192f8f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 03:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694686734; x=1695291534; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oxorSNcuhc7Rp6RnJ5GVrxZ1MlUyny7z2O6i0HP0JZ4=;
        b=i6vI3WkeLdx5iUeb4NzXcmeY4UI3kg/vMyasqsEFCQMw4bDZOAAgMWxdkGPDdhhnf5
         gNtuu3FAHtdus9Ue/j3KAJzdC2mAExkodoSfxbTOUQdQLjRvpYdoMPGmjwIrg/RnYr5m
         sw0nTw0MiSv/sfJuT4el1u8pFkGoNyzrlcHh/52IgBQJr8KOvliE8RQEtwiwsu3ti+Cj
         Zp3eCzchNFWH5FmyVSDozgi9B+oCrKGJjk/diLjfyasFctfHWUasHSWYmmQ94e7NBuOs
         zQaVFi3hd/VVY9o7grfN7Ecqg56nkulsvgG3WDYMe1rRiU9FHsV1fVcRhCcNs148yduH
         z0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694686734; x=1695291534;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxorSNcuhc7Rp6RnJ5GVrxZ1MlUyny7z2O6i0HP0JZ4=;
        b=ioakrGjDgsnIHx1hq165Q8Czw7frHILEdZdWJTQ9J5wLHCVAKNhxFfEN09jZ2AD1I4
         N/u48c91C0qn2y0Sr9MNEvEd04hT2Gib6u+NeEh7jbyrGILKWVaI10J3mofXjJt+psdT
         EetZWCi2bhZfpHu6HFwVh1QOWXnXzYMC2WhMXHEYP8IoGdfmP0LY5WDTWyvAGpWPHPBH
         q7ckGFioAlwqPnpZ4qBoH4TivIauPjTSyI651lT/4/SJRkPUqzu/N5c1PN5SqEe7kk8f
         jwrgYgJJ/bDHPXw1AHZZu0eLWIUsrVCrCyUmlb31Ld2XMZMWzs0vWO1+WI27u/CQ8fUT
         D03Q==
X-Gm-Message-State: AOJu0Yzbk3KiUJeJkZNBIilyaWkzUmVeMzTs41FBJu7dss3qm09uK7zX
        b1cr628T8dYqneQYe75hiycUiQ==
X-Google-Smtp-Source: AGHT+IFQr83jLh4ArO/qWyiZNV78rEkAekAUIoyw9Vm0+1rs2WMJa7ZPQetY3dpLGqcell7l9dVoaw==
X-Received: by 2002:a5d:560e:0:b0:31d:74f8:fae with SMTP id l14-20020a5d560e000000b0031d74f80faemr3865702wrv.71.1694686733700;
        Thu, 14 Sep 2023 03:18:53 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s24-20020a7bc398000000b003feee8d8011sm4444151wmj.41.2023.09.14.03.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 03:18:53 -0700 (PDT)
Date:   Thu, 14 Sep 2023 13:18:49 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Erasure coding
Message-ID: <c6eba72b-bf7b-4610-a5b2-df67ab737565@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 2d69588454f4: "bcachefs: Erasure coding" from Nov 1, 2018
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/alloc_foreground.c:1056 should_drop_bucket()
	warn: sleeping in atomic context

The call tree is:

    bch2_open_buckets_stop() <- disables preempt
    -> should_drop_bucket()

fs/bcachefs/alloc_foreground.c
  1114          spin_lock(&c->freelist_lock);

Preempt disabled

  1115          i = 0;
  1116          while (i < c->open_buckets_partial_nr) {
  1117                  struct open_bucket *ob =
  1118                          c->open_buckets + c->open_buckets_partial[i];
  1119  
  1120                  if (should_drop_bucket(ob, c, ca, ec)) {

Called

  1121                          --c->open_buckets_partial_nr;
  1122                          swap(c->open_buckets_partial[i],
  1123                               c->open_buckets_partial[c->open_buckets_partial_nr]);
  1124                          ob->on_partial_list = false;
  1125                          spin_unlock(&c->freelist_lock);
  1126                          bch2_open_bucket_put(c, ob);
  1127                          spin_lock(&c->freelist_lock);
  1128                  } else {
  1129                          i++;
  1130                  }
  1131          }
  1132          spin_unlock(&c->freelist_lock);

fs/bcachefs/alloc_foreground.c
    1043 static bool should_drop_bucket(struct open_bucket *ob, struct bch_fs *c,
    1044                                struct bch_dev *ca, bool ec)
    1045 {
    1046         if (ec) {
    1047                 return ob->ec != NULL;
    1048         } else if (ca) {
    1049                 bool drop = ob->dev == ca->dev_idx;
    1050                 struct open_bucket *ob2;
    1051                 unsigned i;
    1052 
    1053                 if (!drop && ob->ec) {
    1054                         unsigned nr_blocks;
    1055 
--> 1056                         mutex_lock(&ob->ec->lock);

Sleeps.  Do you have CONFIG_DEBUG_ATOMIC_SLEEP enabled in your .config?

    1057                         nr_blocks = bkey_i_to_stripe(&ob->ec->new_stripe.key)->v.nr_blocks;
    1058 
    1059                         for (i = 0; i < nr_blocks; i++) {
    1060                                 if (!ob->ec->blocks[i])
    1061                                         continue;
    1062 
    1063                                 ob2 = c->open_buckets + ob->ec->blocks[i];
    1064                                 drop |= ob2->dev == ca->dev_idx;
    1065                         }
    1066                         mutex_unlock(&ob->ec->lock);
    1067                 }
    1068 
    1069                 return drop;
    1070         } else {
    1071                 return true;
    1072         }
    1073 }

regards,
dan carpenter
