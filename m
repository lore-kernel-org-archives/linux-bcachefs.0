Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4C9C77B60
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 11:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbjDZLd5 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 07:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240561AbjDZLdx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 07:33:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548A65592
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 04:33:50 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a66b9bd7dfso73156115ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 04:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682508829; x=1685100829;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c81skaEAGcxNRjGtv+vdrJPEFZSewpeVnPWCBInyAdM=;
        b=HYuVsedkIX3lodMfbk5k2/KhzQNM1HPB7xexbPeZBuw/NhKqn1VCyCpKMGtB9Sw8zW
         X6+Zj2BzXs4N7JU4y2I5P5dSoLh3PYDovAR8obJlazMZOCNha10sUJsNPZARkKQ+uzi+
         q3vqOByftl4MRvPrbQkNDptMEJC/MuTVYhUf19WFhsOpla89k/lV0ya64Rqjcm6v5wlQ
         d5jqlB9Gpf5s3eYcRMqNx05ChpIjvIKF7S5+Cl9VhpqN9woyUsmCaf9MEiRQhPnlMgoM
         kSoGbKvK7Tpo2StBhvJvzctAoctxcTw0AYSw+lEuDi3ZsdP7zJrdFldYwucORllIs27k
         +tiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682508829; x=1685100829;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c81skaEAGcxNRjGtv+vdrJPEFZSewpeVnPWCBInyAdM=;
        b=YiUacZ7xxdMuKIUctbp6BPL1pMKbXCb8t50OAf76B2JvLATtSy8Klz/fm9shBbmhsx
         Y81+UXWzRjG61inGQxps9x4GYYq6KxcLSSDdYu6Wz7VnnLA7I/doqI5pInjICAgDL9U+
         gVTX2vbV2zWxN2xQWFz1/VmTGZXPgTfAxECpMhwLmEI5P0VTTuyPjOk9011iAGO+dMGl
         iRHNOgQ1n98j8OfXKLLGA78MuOUzPNEgY5ZONhM8jq/54Th28MKrvbu2yH3eGX4GhJh4
         IaUqMWDC1thwiF+cvgTjpV+BaJ0spYgPG3W92E2tpHMV5mKlpgszJT9cifx2k5oRM2v1
         7NFw==
X-Gm-Message-State: AAQBX9eBj9cKpWlk7B/sCgjpzBVGpmovvVSDAfgyWfU2S6ZJeTWmoPa6
        CaJKVOREQIxQo/Akl/OdQcCBKPznUCgOKw==
X-Google-Smtp-Source: AKy350Ya1Papupe19MHQ5eWavYgOeMQNUWZ/kE49j9yzA51ncc9D1C0FMWvqb26Wc8LmR0Rm0Os0gw==
X-Received: by 2002:a17:902:ea0e:b0:19a:a520:b203 with SMTP id s14-20020a170902ea0e00b0019aa520b203mr25409532plg.25.1682508829470;
        Wed, 26 Apr 2023 04:33:49 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:2:a2a::1])
        by smtp.gmail.com with ESMTPSA id g4-20020a1709026b4400b0019f3cc463absm9858330plt.0.2023.04.26.04.33.47
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 04:33:48 -0700 (PDT)
From:   Alan Huang <mmpgouride@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Question: Is it okay to develop and test a filesystem within a
 virtual machine?
Message-Id: <C1C60796-ED70-4B6F-8491-032DB2BECB87@gmail.com>
Date:   Wed, 26 Apr 2023 19:33:32 +0800
To:     linux-bcachefs@vger.kernel.org
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,

I want to contribute to bcachefs. Is it appropriate to use a virtual =
machine as a development environment?

Also, I would like to ask how to learn bcachefs more quickly. Any =
suggestion?

Thanks,
Alan


