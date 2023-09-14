Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D86EEAA40
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 13:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbjINNkj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239737AbjINNk3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 09:40:29 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EC26B1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 06:40:09 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-401d80f4ef8so10719285e9.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 06:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694698807; x=1695303607; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrClZbB+VrNXBEbLbHmtgIhM5oCYPZ6YAEl1lWxtHUo=;
        b=IwG6BIP398+ISZhQKzHFV0vfsMiNzHT+EGDq+z+AF/bVmRFYt9kVoPKG0WlbnATMrY
         +687zq9wKGABHiJeE0sfc3sP82ZHlN2AqGIzOh6UYezyBoFDH0pxooNZxP5hTYWeiuYK
         6aEOfWWieAD+owHFkBbkGxV8WmP7rjlV+YcL4e2qV1if1Kk4pPQduduyV3nMN3/zyRCs
         gKG0DyoXm8ndJNyhw/z+P4PiQSc6c5fb2o66jLu1xHnppmopj/GXHOMe02FkuWViuyXr
         /yUiy96dfMZfNqzdHgKeChj+zYbDu5GGmHd5krEhhewKMSkj7qXppe2IQghOqd549Cje
         GMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694698807; x=1695303607;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrClZbB+VrNXBEbLbHmtgIhM5oCYPZ6YAEl1lWxtHUo=;
        b=TM2eTuj+e5Ddsx5tK282woaNaDDUxjwVN6BSUaqFl9JsfdvwWeiyzRuGojQYlwHEDL
         EXDMxRlB31I7DYo6J80NG+ztaiZvi0ed6D25g3FEwqeWnh0SQJjmKRdAs5Yignj09oR2
         IEKRorGstNlnIEXw2ln/CYtE+8MPAUxgu3snwRwOgm494mw6YRyAMPsVo6dhESKoP4K/
         K7wc+4pCkWMCBbWqrLV1Y1Bkp0riWC/pISRgs1m17b7+TyuDaiKiOZPb3LgZZFUPBQBg
         CE4jEPl6rPiQ7VWo/e7QVHrUIKHaOXuV5z3xHrRE3Cdd3HpYkLoUIcAxQwL0YDWZBZw/
         3J+g==
X-Gm-Message-State: AOJu0YyDk/rje/qXxGf3ivivoXIPTz1+S+dCaeRWW464T7aGkrDYOYQ6
        cFOSwxZG0H/7P+SEIkKELUWenQPxLC78akIdk10=
X-Google-Smtp-Source: AGHT+IEmwxke124uF2TcurWHjhG5Tsy8eUsvs+S4QNh5/dIJnnoaR1gTg1gRWTXO6WfIa5bO5+0eFw==
X-Received: by 2002:a05:600c:3794:b0:3fe:d71a:d84e with SMTP id o20-20020a05600c379400b003fed71ad84emr5083347wmr.1.1694698807269;
        Thu, 14 Sep 2023 06:40:07 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p14-20020a1c740e000000b003fe407ca05bsm4935375wmc.37.2023.09.14.06.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 06:40:06 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:40:03 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Kill struct bucket_mark
Message-ID: <04b27989-3804-4ac9-91d4-7cd19cc813c5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 43ae95661a99: "bcachefs: Kill struct bucket_mark" from Feb
14, 2022 (linux-next), leads to the following Smatch static checker
warning:

	fs/bcachefs/buckets.c:755 check_bucket_ref()
	warn: impossible condition '((bucket_sectors + sectors) > (~0)) => (0-u32max > u32max)'

fs/bcachefs/buckets.c
    740         if (!data_type_is_empty(bucket_data_type) &&
    741             ptr_data_type &&
    742             bucket_data_type != ptr_data_type) {
    743                 bch2_fsck_err(c, FSCK_CAN_IGNORE|FSCK_NEED_FSCK,
    744                         "bucket %u:%zu gen %u different types of data in same bucket: %s, %s\n"
    745                         "while marking %s",
    746                         ptr->dev, bucket_nr, b_gen,
    747                         bch2_data_types[bucket_data_type],
    748                         bch2_data_types[ptr_data_type],
    749                         (printbuf_reset(&buf),
    750                          bch2_bkey_val_to_text(&buf, c, k), buf.buf));
    751                 ret = -EIO;
    752                 goto err;
    753         }
    754 
--> 755         if ((unsigned) (bucket_sectors + sectors) > U32_MAX) {

Originally this was U16_MAX instead of U32_MAX so that made sense.  Also
it's a style violation to use (unsigned) instead of (unsigned int).

    756                 bch2_fsck_err(c, FSCK_CAN_IGNORE|FSCK_NEED_FSCK,
    757                         "bucket %u:%zu gen %u data type %s sector count overflow: %u + %lli > U16_MAX\n"
    758                         "while marking %s",
    759                         ptr->dev, bucket_nr, b_gen,
    760                         bch2_data_types[bucket_data_type ?: ptr_data_type],
    761                         bucket_sectors, sectors,
    762                         (printbuf_reset(&buf),
    763                          bch2_bkey_val_to_text(&buf, c, k), buf.buf));
    764                 ret = -EIO;
    765                 goto err;
    766         }
    767 out:
    768         printbuf_exit(&buf);
    769         return ret;
    770 err:
    771         bch2_dump_trans_updates(trans);
    772         goto out;
    773 }

regards,
dan carpenter
