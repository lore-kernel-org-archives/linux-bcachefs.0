Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BACE810DB
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 12:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjI0Ml7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjI0Ml6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 08:41:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5190192
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 05:41:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-405621baba7so81007855e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 05:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695818514; x=1696423314; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YF/PxPj+LNpX0UrvQFPhzoZQ900pE9UScYJoKfBTqg8=;
        b=nu2mP5WI8PJ8e5G5L4cE5Fhamv6yFX+pdLvvHX2M3fvqOq5iBoSb3dcilsU3nZtv2f
         ok7w8g+EY7vjrYlyfSM0xVHfVmbUEyMgW+CicPW9ShHpcXtyv6zxA4JUpwCiwe1L9BLl
         TJqGg0t9lx4AG52CMCyORqPQDWbFpfLltTO2S2yusmpm3iOT7GgbYrF96WmQkGRKRvHl
         DaNqBA/5C4Ilsqt3I0ee1Lmdws+LAI+KxLXEg/gWw9O0ulqwU+MlWiWQIDDYSTuhElFs
         ZZasInSDA6M6ErZhxpYUYysCoruFHuGe/lW+ioa74uqinQLpfqqxPH1cESCa52mHXEL0
         0PQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695818514; x=1696423314;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YF/PxPj+LNpX0UrvQFPhzoZQ900pE9UScYJoKfBTqg8=;
        b=hGxtYLYUYlbJf4UdxrKxgkdUOt3ybtXKSe6nZFJTi+tzU9tT2ijSZ4mp3xaFbvCtAR
         ycBI7KCMVGltXbMvAYrzcEeafEEHXfTNh2XtypYC+VUx+S+XsNZeoSOgLivXENQFTkF0
         TC0VH+ZikKW1g0b6HRzXGzP6gWgQql0iJtxpJ+vbX0LpPUpKQ3TjihULAm0Tb7Z2s04r
         npbyIKxAfFG9h6a8Au/J5RzFoqC/HR2bA66hO6LewWGjoyEWgvLBmTkxUUuNy+efnX7/
         N6YWcNaQoKQ+h8SoDJ5tLprh0WYOR36ipP9LE4ftKuaDSAWWVA6y1NZzuDayU5WHGo70
         M92Q==
X-Gm-Message-State: AOJu0Yzps100ZXx7zOfXlZhNTFtW74PhNWntvpbLwNC9CvHTblZ2f9Kh
        tngxsGGcaTmoM8R13UjX1uHNlg==
X-Google-Smtp-Source: AGHT+IFZSViRciJHixHKN/5pPXxvhPbLKPfa+TqRjFpr2CzWWhpPNaWChTTKnVCycvNT4RvMZBSP8w==
X-Received: by 2002:a5d:62d1:0:b0:323:33cf:7872 with SMTP id o17-20020a5d62d1000000b0032333cf7872mr1725103wrv.6.1695818514180;
        Wed, 27 Sep 2023 05:41:54 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b00315af025098sm16879547wrt.46.2023.09.27.05.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 05:41:53 -0700 (PDT)
Date:   Wed, 27 Sep 2023 15:41:50 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Improve assorted error messages
Message-ID: <38de9d9b-38d0-4fb3-9cf2-6380d5c339b9@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 3d86e847fdd2: "bcachefs: Improve assorted error messages"
from Jun 3, 2020 (linux-next), leads to the following Smatch static
checker warning:

	fs/bcachefs/buckets.c:697 check_bucket_ref()
	warn: sleeping in atomic context

fs/bcachefs/buckets.c
    673 static int check_bucket_ref(struct btree_trans *trans,
    674                             struct bkey_s_c k,
    675                             const struct bch_extent_ptr *ptr,
    676                             s64 sectors, enum bch_data_type ptr_data_type,
    677                             u8 b_gen, u8 bucket_data_type,
    678                             u32 dirty_sectors, u32 cached_sectors)
    679 {
    680         struct bch_fs *c = trans->c;
    681         struct bch_dev *ca = bch_dev_bkey_exists(c, ptr->dev);
    682         size_t bucket_nr = PTR_BUCKET_NR(ca, ptr);
    683         u32 bucket_sectors = !ptr->cached
    684                 ? dirty_sectors
    685                 : cached_sectors;
    686         struct printbuf buf = PRINTBUF;
    687         int ret = 0;
    688 
    689         if (bucket_data_type == BCH_DATA_cached)
    690                 bucket_data_type = BCH_DATA_user;
    691 
    692         if ((bucket_data_type == BCH_DATA_stripe && ptr_data_type == BCH_DATA_user) ||
    693             (bucket_data_type == BCH_DATA_user   && ptr_data_type == BCH_DATA_stripe))
    694                 bucket_data_type = ptr_data_type = BCH_DATA_stripe;
    695 
    696         if (gen_after(ptr->gen, b_gen)) {
--> 697                 bch2_fsck_err(c, FSCK_CAN_IGNORE|FSCK_NEED_FSCK,

bch2_fsck_err() takes a mutex, but we're holding a spinlock so that's
not allowed.  The spinlocks are in:

mark_stripe_bucket() <- disables preempt
bch2_mark_pointer() <- disables preempt
-> __mark_pointer()
   -> check_bucket_ref()

(This warning requires two cross function database rebuilds before it
shows up).

    698                         "bucket %u:%zu gen %u data type %s: ptr gen %u newer than bucket gen\n"
    699                         "while marking %s",
    700                         ptr->dev, bucket_nr, b_gen,
    701                         bch2_data_types[bucket_data_type ?: ptr_data_type],
    702                         ptr->gen,
    703                         (bch2_bkey_val_to_text(&buf, c, k), buf.buf));
    704                 ret = -EIO;
    705                 goto err;
    706         }
    707 

regards,
dan carpenter
