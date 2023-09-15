Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71149EE6457
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbjIOM5y (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbjIOM5y (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:57:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019C1713
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-31f4a286ae1so1783053f8f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782667; x=1695387467; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PH5ux5CZtHwOwmvQfbQSpCxyYHCXurKE6cwz/gMGCsg=;
        b=razctgum37L8o1zKfCinwpEgeqhsx6L0fDogWnR9qEfC5Ht38R6EISugbiCEKJhEC7
         lp8QeepgA4gHf3rPgBKIEUpwHy3tUsu+PAYOa6dcMyElFEHBwmiyQ318zO6MGGuJKE90
         RYalO1Mfi8EPWZ3rAKHHNP4ulDA7q1DGktuqjYvgaJ19124ORml0Zw11WmO5ufIGECWG
         MPaGRbvaSNdbMXJn45oCkq7TNwPrS2xhcmzkgK3QfGc8czBTnGuBjCdEda9EjoP8ln43
         E1h9Njso9NDlr0iMs6rXqsTJmgPGsoZA0xKji3AXIG3YT/a70NGFJm6pe1EsTIrxMuOj
         Llww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782667; x=1695387467;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PH5ux5CZtHwOwmvQfbQSpCxyYHCXurKE6cwz/gMGCsg=;
        b=ICOwBKDV27RWVo2f3Mede+yCw74/Xb+pMV7NrGEiDcF1UczJpMDUELIQHZyUIYJ+qE
         a/dV2h8lBghb0XeCF3sW/dJgb4F30pjLNI22CLj8WADjIExjPbQ7e9NE4y3adISqMRGG
         qms81POoqVxpw1HeBueOgBPFUtfQY1u3yBZeU0qIDRiPerFW1XT1Ny35qyox5SJywNM3
         XiqvfWcv46tJwQr+TGTqqFl/ra2Qf5bBB4zM04HxYNGsscejBbWNHW3IyTMOZdnebhiW
         a/zJqVyCf962oE6Z49YPFsA4ZSRqMCLbhvlZdJZkHn5W0WUUR99Hd3g4Ox8SKdHTvDKz
         rPyA==
X-Gm-Message-State: AOJu0YzEf3SaYj33cKKFst9YOEIqbRZrQtC5fC47vty8oBCEwdRxOrcg
        eFXVHfFhU2u5ZTvKW0RbCkHSug==
X-Google-Smtp-Source: AGHT+IEiNJTWGKCmpmHIHa23e/cwpo6UECenlRtLjjHHS8ruHv8WEJUneLAe0oaxNiHaJrZSuq7Bfw==
X-Received: by 2002:a5d:4e4e:0:b0:31f:ecb2:1bf6 with SMTP id r14-20020a5d4e4e000000b0031fecb21bf6mr1369601wrt.8.1694782667739;
        Fri, 15 Sep 2023 05:57:47 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id z8-20020a056000110800b0031f9bdb79dasm4383515wrw.61.2023.09.15.05.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:57:47 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:57:43 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: missing error codes in
 journal_entry_blacklist_v2_validate()
Message-ID: <3cd4ecca-6002-4722-9f0e-0efc93ccb8d3@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch b3dc2344548f: "bcachefs: reserve space in journal for fs
usage entries" from Jan 24, 2019 (linux-next), leads to the following
Smatch static checker warning:

	fs/bcachefs/journal_io.c:468 journal_entry_blacklist_v2_validate()
	warn: missing error code here? 'journal_entry_err_on()' failed. 'ret' = '0'

fs/bcachefs/journal_io.c
    455 static int journal_entry_blacklist_v2_validate(struct bch_fs *c,
    456                                 struct jset *jset,
    457                                 struct jset_entry *entry,
    458                                 unsigned version, int big_endian,
    459                                 enum bkey_invalid_flags flags)
    460 {
    461         struct jset_entry_blacklist_v2 *bl_entry;
    462         int ret = 0;
    463 
    464         if (journal_entry_err_on(le16_to_cpu(entry->u64s) != 2,
    465                                  c, version, jset, entry,
    466                 "invalid journal seq blacklist entry: bad size")) {
    467                 journal_entry_null_range(entry, vstruct_next(entry));
--> 468                 goto out;

Should these error

    469         }
    470 
    471         bl_entry = container_of(entry, struct jset_entry_blacklist_v2, entry);
    472 
    473         if (journal_entry_err_on(le64_to_cpu(bl_entry->start) >
    474                                  le64_to_cpu(bl_entry->end),
    475                                  c, version, jset, entry,
    476                 "invalid journal seq blacklist entry: start > end")) {
    477                 journal_entry_null_range(entry, vstruct_next(entry));

paths set an error code?

    478         }
    479 out:
    480 fsck_err:
    481         return ret;
    482 }

regards,
dan carpenter
