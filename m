Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE63C77B7E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 19:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbjDZTyK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 15:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbjDZTyJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 15:54:09 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7650819B9
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 12:54:07 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4edc7cc6f46so8099192e87.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 12:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682538845; x=1685130845;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i3z8+YKCodJ3c6a6Ny27kF2oekKrqyZwLIYOgO2qhIA=;
        b=ARpF27b/KFr60mf80yiNMgAdTjYuMQRq5Wtcr8z3fXwrxY/A1kNeivoaT32KXLs+f/
         Rc2JzErDgRrL8BY4OXKfObDNcWEeVTJaEjETQMY/czEJUf6vd3NZ1TAJFlGnVRRGKbOE
         1WF8s2Pce6czL8a37U9QBR9gFrk/fghLKMSxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538845; x=1685130845;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i3z8+YKCodJ3c6a6Ny27kF2oekKrqyZwLIYOgO2qhIA=;
        b=FElwMK77deSZzEBiuFGkPGUaiWHiOcbNvxhVuPuBlTNyJ44Wq1a3KLcni9GJal+Fko
         +YhmkgXqMSTJwlusQKNOQpEDs9mKH2ZXFcxQsdlFgXb89k7p0x8jyNARSGvWRWjA+5Fl
         KNf9j4nmzLT+wqbm0cdbeJTUOKrpzP7wxhaXloBC/bTydhiheT6W1kidRSlC4XhYGf/K
         u7WawLM/JaBk/CRm8JmTvl0QtYJn800SQqwrRtQDB4wkfL3uDufjEy/Yg0PTfjZ6dbNN
         0e0VeaJcN5VeiN/3q5Bt4DiVQmHg02k/wgeCTVN1O/VMuYOfRzY6ic/0p3G6PY45sI83
         4ZIg==
X-Gm-Message-State: AAQBX9coJBgvyWh0wxQ9FGK4agCugmAzqXyYxpa15Zf0ZoRGDYlMU4t3
        igpFDnFL297VwHG1smYlH8/10B2yc0F2sBiDd2hAhc6mMA/AIYvI90JSUg==
X-Google-Smtp-Source: AKy350ZngxRh/zk0Wi2FLzHfNwZDFZeC+NSicrQBwujfI8rhch0aZ/Na7jTCcq1rO7Dvc/POW649SB2cg5EkFW0P6gE=
X-Received: by 2002:a19:7016:0:b0:4ed:c8ba:dfb2 with SMTP id
 h22-20020a197016000000b004edc8badfb2mr5551581lfc.65.1682538845057; Wed, 26
 Apr 2023 12:54:05 -0700 (PDT)
MIME-Version: 1.0
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Wed, 26 Apr 2023 12:53:52 -0700
Message-ID: <CAMy36z4VzueBOSMf9ve+T=w+-WiUc8Gt0AmM6Dm93ks5P-qTjA@mail.gmail.com>
Subject: printbuf problems when running rust-written command
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

There are 2 problems I currently have:

1. read_super_silent only suppresses the verbose logging temporarily,
but still dumps everything before the command return 0 successfully

2. when trying to print printbuf in rust unsafe block, I get seg
fault. Probably because I don't use bindgen correctly.

My question is, when working with rust code, do we still need to use
printbuf, or can we print directly to std{out,err}?

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading

Get your own email signature
