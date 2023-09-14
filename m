Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A2AEEAA4E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 15:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjINPDf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 11:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjINPDf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 11:03:35 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF2AA8
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 08:03:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-401c90ed2ecso11963095e9.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 08:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694703809; x=1695308609; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K/HfIpXLj5uOmLe238XxQrD0R8vCvRiPtHPWkhFvO+s=;
        b=h0Y9atNlBP78EVMqzlvf77D12xxYfe2PC8d4zDRCLX8S9Gv3U3mKCzjpSry+FO8zbC
         x4CwVkqVR8TUgWDIM9y9Gtu9Bijq6L61FwswXp3h7xjToRIwLngdgawSe/PrRWvQsqbS
         AhZFR98aR5EC5NtkJBdyZxdnmMeLUrUxVY1n/qwVjkoEdrXqI6GQGuA4U7ABWqqtrE5x
         xMzQ8X7tyrJbbh40/REYVG4V1uYSN7KKwROsmkdUxZTJackxCKDtbGBffKlEjxWHfn+j
         Zq5g/eazxyU/fZ9QV0QuXbchxkY3Gbh0NKOz6cCo/P8PjJ7LzVtatiLq+qQGAf6NN831
         zH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694703809; x=1695308609;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/HfIpXLj5uOmLe238XxQrD0R8vCvRiPtHPWkhFvO+s=;
        b=mTrPKHNGd1SSMBQPq7vflbw1nGJ8RuWerH9t1gkLjxilfDGN92VF/5Q+UvDwGAIuSW
         /r92yk4sxfu/UhrJlV2O8PW2K6km+Odl63M1zlTYLjPBbx/58QrdV/IweKBrpQ7znaow
         WD4pV6h5QnHzkg81bp9gg2Kg5wofg+sUCmlpQFufhJHdXXFMF78l6G6qyFd4DvpMDOa1
         jAUBbkmY1rCbpfF1GjDKQ/fcDMdfJaWixPB1XSWYrIGwU/SqnZ58Sl9JSwz2nm3xIAIZ
         uLKD191vFTZmSGQ8wKe3F8xMndM43yV6bt14g/EklmKGJIf1Fz+4v1uga8n8fRGZq68c
         oRbw==
X-Gm-Message-State: AOJu0YwWCIXAAs0dxCJVRY3C/dj0IUCuXHHrYbLCdlz582XmTwibfMfU
        6rGgLXpmfxy+CJt5xqbsRRWLWw==
X-Google-Smtp-Source: AGHT+IG0IscQs0jvhr/puXxiTSRScIZ1rlPVTASSfVe5lu9ahKbEZyF6ih0aty/BYK60cgFYwwRcxw==
X-Received: by 2002:adf:e7cd:0:b0:318:70:a4ac with SMTP id e13-20020adfe7cd000000b003180070a4acmr4813384wrn.17.1694703808588;
        Thu, 14 Sep 2023 08:03:28 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g8-20020adff3c8000000b003142ea7a661sm2004993wrp.21.2023.09.14.08.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 08:03:20 -0700 (PDT)
Date:   Thu, 14 Sep 2023 18:03:08 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Add an ioctl for resizing journal on a device
Message-ID: <3b879f4f-2fe4-4e0f-aeeb-1d5a62d0a1ce@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch f9e4304e0562: "bcachefs: Add an ioctl for resizing journal
on a device" from Nov 16, 2020 (linux-next), leads to the following
(unpublished) Smatch static checker warning:

	fs/bcachefs/chardev.c:624 bch2_ioctl_disk_resize_journal()
	warn: truncating user data 'arg.nbuckets' '0-u64max'

fs/bcachefs/chardev.c
    607 static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
    608                                    struct bch_ioctl_disk_resize_journal arg)
    609 {
    610         struct bch_dev *ca;
    611         int ret;
    612 
    613         if (!capable(CAP_SYS_ADMIN))
    614                 return -EPERM;
    615 
    616         if ((arg.flags & ~BCH_BY_INDEX) ||
    617             arg.pad)
    618                 return -EINVAL;
    619 
    620         ca = bch2_device_lookup(c, arg.dev, arg.flags);
    621         if (IS_ERR(ca))
    622                 return PTR_ERR(ca);
    623 
--> 624         ret = bch2_set_nr_journal_buckets(c, ca, arg.nbuckets);

This is harmless.  arg.nbuckets is a u64 and bch2_set_nr_journal_buckets()
takes a u32.  However this u32 vs u64 inconsistency with ->nbuckets is
not just here but also in other places.  (struct journal_device)->nr is
a u32 for example.  It would be better if it were consistent everywhere.

    625 
    626         percpu_ref_put(&ca->ref);
    627         return ret;
    628 }

regards,
dan carpenter
