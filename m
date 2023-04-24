Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3632AC77B61
	for <linux-bcachefs@archiver.kernel.org>; Mon, 24 Apr 2023 17:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjDXRFV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 Apr 2023 13:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXRFV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 Apr 2023 13:05:21 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7D2189
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Apr 2023 10:05:19 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f9b9aa9d75so2961586f8f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Apr 2023 10:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682355917; x=1684947917;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkQ9Lk0E+SeUukwFw0jXXufF4ydGJ2KHyH+Q0DcauS8=;
        b=dmglVoDSOQ986ZMb8sewNfmcUTbsGaPe/fUI/JzNL3hYI/ce7NEzN4uHuaysqAfO9e
         a5BFn5EPTG4ql1uhfrJHVAUahjuyzxcgotyubbLPZbs7LJYde6e/gRVyKdmI7kLilB+p
         e7oG6qaRsEvfezKVLj93B8tZZKS7PLq80wmoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682355917; x=1684947917;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkQ9Lk0E+SeUukwFw0jXXufF4ydGJ2KHyH+Q0DcauS8=;
        b=OtyyZKnC+oAjROSfp3CZJSE+EU1hF26h2NxmHL/PvQv1QlKE/a6QQA36sW7CFRmNQq
         3Q5TWKWrHD/nPMjf6VRqIQ1po1Rq/p+JNsYHIuGEOMwcpXo9M3aVD57dmrJeiTn4wO8s
         mv9uZZi6TQfFBo2CU4n9qroQAImyodHVJ83XIiEaig6BksjMMuw/bt2U/x/whmi2/zMy
         oeShu/31fFkhbRBmf2tOGEDC9V8o+QfuzO5sV9SLblrg8ou/IsHLW1FFdoNqWJ7TPcy/
         vZYl/+JvIRI7NueFePty04csDuxgSk96nE+3jWP5Ho8gvUJNfGJczLX78BbN04uez2oE
         OcAw==
X-Gm-Message-State: AAQBX9fpdsG8SeI+re0C62ypa3/BVUFAAINonilYZUGUXBUBOCQFeKCF
        u6eqAkNR2TIOGhfp0b5yIbh1d+5goIrD8sRunfgfRzruBgVtLag6IBNMJw==
X-Google-Smtp-Source: AKy350Y4ii9DY2zLTsu7GDLv9i9elG1UmuvvqX9ozpVYOQI35H/yDQf6Hmmp4iyLJ5/pWZOZQFvE2Rm9umHwUVdYpYA=
X-Received: by 2002:a5d:4385:0:b0:2d2:29a4:4457 with SMTP id
 i5-20020a5d4385000000b002d229a44457mr9593069wrq.13.1682355917082; Mon, 24 Apr
 2023 10:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAMy36z4rxgcNUmxrtapBx_LY-ZYuB0_r2pEVSf27REodE4R3Sw@mail.gmail.com>
In-Reply-To: <CAMy36z4rxgcNUmxrtapBx_LY-ZYuB0_r2pEVSf27REodE4R3Sw@mail.gmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Mon, 24 Apr 2023 10:05:05 -0700
Message-ID: <CAMy36z7GKiv5_u=WmoDpzFMUeRaWPaAme2eFmdgDdDJ+g-sROQ@mail.gmail.com>
Subject: Re: PR contribution
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi, I have 2 PRs on GitHub for bcachfs-tools [1] [2], but I don't know
whether it's more likely to be discussed and reviewed on this mailing
list. I can also submit git patch on this mailing list if it is easier
for the maintainer.

Kind regards,
Sinh

[1] https://github.com/koverstreet/bcachefs-tools/pull/141
[2] https://github.com/koverstreet/bcachefs-tools/pull/142

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21
