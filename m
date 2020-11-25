Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55CFC56202
	for <linux-bcachefs@archiver.kernel.org>; Wed, 25 Nov 2020 12:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E57B206E5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 25 Nov 2020 12:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Fj8oVw0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgKYMfb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 25 Nov 2020 07:35:31 -0500
Received: from mout.gmx.net ([212.227.15.18]:37067 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgKYMfb (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 25 Nov 2020 07:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1606307730;
        bh=aE09HQo5JGx9moRjSa0UQ1X0mj4HF6qoNS8tu4ZShpE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Fj8oVw0A0gxooTGSQ8NIYnY5Si4TejCdmCXcMFXOc9eX1bGeDdENZMi0qWbSXqSzP
         TUiJ367TNp2jbjxbK9X456gQhndtJBcbHR7inU36QnmShkjkxjgpQ3DvyiWwWocJDe
         NB9Fg4XK3legy5j1RzxNJt1RCx1PI9MswZuyEnDk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([92.214.189.46]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MHoRA-1kT6BD3guM-00ExSc; Wed, 25
 Nov 2020 13:35:29 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcachefs@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org
Subject: Status of merging bcachefs into mainline
Date:   Wed, 25 Nov 2020 13:35:29 +0100
Message-ID: <3738693.ng0IJAnuUy@t460-skr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:sWQxj7/whobUwluOjXJBXiN5lTyVU2NA/iDurTh+9XbWTKZvSgQ
 IrcdLX0xSCBBTOPQ4Sy80+yBLSbc0R6hcqN1xk3+d6TiQ/12K31SaLSSYRso8fOKFuWYQFr
 rU2YTQYMBFvpXayLQsdwNfM7AneK8lC+ASQJ4k8fzmd+g3BeEpnZkxWir408dkumlZRnDhC
 +YxKpn2OB2QsND5124rfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LtoQ1mIKQuQ=:QcgFZ2P3Dsu369MF+DyBC8
 6Dv+VM+6yFfzPe2KrvaRhnFVhBKEXWNiu5D3UCR+M6YfEfZOK7Ot/feVDNtNFA0/A3d5Xb4R5
 0xFJT/dc1eCOeR+QxNU3LIbfxD8LAQLSj4VMezNYDP1LLTkfXAVwD7PIrcV8lPaliSljySQE8
 Fb7bgKYOZgCagh7oonRWgP0pjz8ddZqFIgbCT0P8NuRDBYNjlQdcsmhFEHJnqsltOSiKBMgD1
 YVYqHxYfnQXTBKejMI8aD59Gbm68JXeWxRk16nTf646/UvTKwy3CMwc4C6BnjX+O88SigApe5
 E1icGByGNr5Z1H663Yx/QlGByUfYhE6GujUtfrcLeBA87lUEJsGQ8XCtKEeVUTA3XciGM+bM6
 PF1cH2F0niUAyeFxpOyeT63X034hlQzw5JAl7lP/w6e7cz/aR4YPHHED9aShNhqLM/GHD/GMl
 +Iv5zztmA1+9ghDnFCrQb1UyZ6qAKJxD/7qY5z5As25754cWAY2Ds5M0/4+K8sY0skKZdup//
 iJPgHsVQDqntKH8aMIPouthwc4PBgYWx0U15Kjx3seg88xctiLc0diNiiQxsGM3j++YVe54kr
 hDdVGvwlYptq+krVFt0ul1d4EE5WYx2mspSdlnsi6PclpCEH4TAwGXdzWcmfCiAnD7shxH3xL
 MNixfWSvHBz0XOiFJU4ALOe1Zlsxc5TqBfsVQq6/IilL3tmhGrRBJA8eBGB9wH7N2vnUKlDjt
 Dm9f5AweaXZIYaWtwC9VIpB439H6qjUD4Yu/xMAR0ymcFDPXzAbevtkbXWYbMWrY8MEmsGglc
 WwuOs5Q1jvGJky0SboQKpI3Jxi4PCK3IBor9hTg0KhkoPSC7JMnYFtwxew+ufKupY90l5HnBF
 L+h9dMC+Fvqvnjq6eZNg==
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

I saw that Kent ask for review for bcachefs[1], also the latest patreon post of "upcoming changes"[2]. But how is the status to get bcachefs into the mainline kernel?
I don't see 'usefull' answers on the mailinglist, does Kent get answers directly?
It would be very nice if we (the bcachefs community), get more details here.

[1] https://lkml.org/lkml/2020/10/27/3684
[2] https://www.patreon.com/posts/upcoming-changes-44125345

best regards
Stefan


