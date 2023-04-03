Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46256C76188
	for <linux-bcachefs@archiver.kernel.org>; Mon,  3 Apr 2023 15:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjDCPfS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 3 Apr 2023 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjDCPfS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 3 Apr 2023 11:35:18 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D422709
        for <linux-bcachefs@vger.kernel.org>; Mon,  3 Apr 2023 08:35:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id bx10so12460659ljb.8
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Apr 2023 08:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680536114;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2ZVtlt4ZQIQK85LFWjqVDsOVA+CjB3/S9JkwaHqwM7I=;
        b=UVCKx9NdDiUT3x3J3yhH2u2rz9gx3mXlyvNAuLCup77NMJ+edizwAtTmCfSDAz1HBf
         cZftihive7Daa44l0CKQJi9zDFsDvlBue9UQFJcNQUD0TGiPtkSVL6xIsGLxKmOF+6na
         QRH0xxvedaYKK70WN1S1BGd93PoEa90MNfK68zZKxq/YeypGdYAvThaQf/8WWlx4X2wU
         mCok5G6tMEhcooYooQh3zkSPDnpGZpfEFKPHmtPPuy9W0c4W7E6MLYxUAmfRUBUmdLD+
         2efpc19QewSYGBftCXurhaKi2Un7AD7NEmOWs7X8sp/Gluq9FU5KlinHC9Wc8T111C79
         tfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680536114;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ZVtlt4ZQIQK85LFWjqVDsOVA+CjB3/S9JkwaHqwM7I=;
        b=MthkQAMsfl7qC9GGL4yls/s3Qm05fnCH2y++/bp5cAull9k9XRuXLdAMKdvmhYg7Wo
         gsEyWjYLh3XCEEf0VKIAToR3m/MYp5ZMMUTGHaeFAEmEoRGlXYcIw7LbbyJn9l8Gu6T8
         f9kuh4y3XUj0E9QypWq8qI7FWSM+MZlsPJfzqxJIcJgJ2ZqKVhzU7nVls8pzDOY0i/9l
         VFJk00H8P9NsAWeULp474LsRcwQNECb0/jR2zq5hDh/0co9oy7PqyCWGllFO36USiUD9
         kY+MPc4Xl3+6+MfRzjkHlFHQYIF1ucur8e5TsxCywfzr8GH70U+oXOKGBCMpgtZCca9z
         vtlA==
X-Gm-Message-State: AAQBX9eZXM0TACX38c/GrwnpfR95QLY/M5i4NKiGPMGj5O/xanPUz659
        WGE9iw4H1Ph6eqxgOBSa3I9EneCV019M7i6Yg6ZiG43gbuo=
X-Google-Smtp-Source: AKy350Y7UzhumYz4mfLW8RBu41tQjRJvWn9PxL1I4YJd+cUsAI67SokXjt1oqLdZdOOFGU5RFm4mgij3S1KDg1jXfBk=
X-Received: by 2002:a05:651c:21a:b0:2a5:fa58:cac2 with SMTP id
 y26-20020a05651c021a00b002a5fa58cac2mr8200770ljn.1.1680536114156; Mon, 03 Apr
 2023 08:35:14 -0700 (PDT)
MIME-Version: 1.0
From:   cee1 <fykcee1@gmail.com>
Date:   Mon, 3 Apr 2023 23:35:02 +0800
Message-ID: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
Subject: Questions about struct btree
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

Curious about the details described by the heading comments of bcachefs.h.

Some questions:
a) struct btree::aux_data
  a.1) The aux_data is NOT stored on disk. It will be created for each
bset runtime, am I right?

  a.2) bch2_compile_bkey_format() write some info to aux_data, what
does that info mean?


b) struct btree::set
How many effective bsets (or btree_node / btree_node_entry) referenced
by btree::set?
Two? one for written, one for in-memory?

In other words, a "struct btree" contains at most two effective bsets?


c) What are bch_vals ?
bch_val is BCH_REPLICAS_MAX number pointers, which are offsets --
pointing to BCH_REPLICAS_MAX number extents, am I right?


-- 
Regards,

- cee1
