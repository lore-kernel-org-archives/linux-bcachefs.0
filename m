Return-Path: <SRS0=HM7X=CM=vger.kernel.org=linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20382C433E2
	for <linux-bcachefs@archiver.kernel.org>; Thu,  3 Sep 2020 08:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19FA20897
	for <linux-bcachefs@archiver.kernel.org>; Thu,  3 Sep 2020 08:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SAEo9l2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgICIZY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:25:24 -0400
Received: from mout.gmx.net ([212.227.17.21]:37823 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgICIZX (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 3 Sep 2020 04:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599121521;
        bh=5QR8eYzEW9bHXRQcr8MkJKJyqFauvnc0LnH+X5HPwrw=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=SAEo9l2jvxkngAsHie3GYDYlLmypvFaSsp6w3QwakV5u+55RtuKFP5IEnPwTrpKGn
         DCjLAQHnLJdUxlFSovxkgz0tXuiHXvGDbqq9oDa+CJBoFWoYywXmsQvgDgFdOGcsWn
         CmHcGFL+00H9VCHzay2Klc9iwy2jpLHI/uzoMlxs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.225.9]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAfUe-1kOhqL2xU8-00B71k for
 <linux-bcachefs@vger.kernel.org>; Thu, 03 Sep 2020 10:25:21 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcachefs@vger.kernel.org
Subject: test
Date:   Thu, 03 Sep 2020 10:25:20 +0200
Message-ID: <18827797.ZkHi0RTPq4@t460-skr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:+9ZaUJA900gPpBIh+5RVXi18k08SXt7Fbc3RLhlSYfKvBQK2PRS
 lfxxApXJ4PD3qhPAdVcsICzW1KNajUhUyCRzMozwrvOQO+zZ//5SFPrGA+xmf1YXTJBcnQV
 R+pRlJImwMA4egV0IkfbpD6zTnEMiMcuinItiWkCoVqonChwSJPqNGLNB7g3ywEFonfoE68
 ikbz+6hdvdg+8z+BmL6fg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tm5NtmQQoRQ=:9RiPj9FFFiHs3WMbQEj2n/
 PUaS7c57hLC21/Lj1ylnD/PcI2IAFr2MIOHfDd+lK0McaItqdPs2oFda8VCJuuGSOB6R03JaF
 Q3+Glw48jQcwA0AHANWgioSkldpXP3839ezRGI7Crp0yYQPIdP2TgXykvXg/Ubzl8JOsCgPMQ
 9fKe0oW6C/qftrZ1ogBcm0PueQFUzaUa3+HfwD6iCQPIzIinWeIy2u7VmWBjISV+Zj7ty90mM
 26sI0D3U5kmieMR9FvtroSfGwbzhNFx3mIFoQocP183YJ7PG/GK+gIR2vcehcR/Tm+aU6cZVU
 J05yWbAx1SC9PLRuybRQGgqstU34r3q0O1qCJLQCS3LfMOi70ZhGRD3g2aZH36kdviGKSsSNA
 SE3UscoWvMOym8kgdjm7JRUI9NgYvzhzjugNJLmUNbA9NcyNcDy0piC5jaUsBfkZT/viwqxmy
 RpQN/XeACf5HaBoSTjraTG88hja9gKqHpKbhwYOwq1YRjxv1Md4uPcUvuxiVXWzuTJ0Z5YK/g
 em0u5M3rRsTXBxU//DRHP0ZhElRt91jwYCsuiQKMCw2WzOL4aamSAjDvtA8ZCz/5oNl/B+gH9
 /Vjqh9DymcyCYEdd3d4LvScBa3tAgiTOVbUyMeR2mWhZXT+rle1uH8LPKm66v6a6pP4EAvlZx
 txdPOmeNur416PiImLOcRYjBOYkAheQS4EtDzoWq1td1P8AatT9yhXaaDasuzWgthGCHlmn6f
 6z6KjbojX1NWrXQ553gu9AZAvnrnibm+tQ1dQaWWxtFmZPrAEpLj95tQTMxZKMtZdyRFTjeCk
 y0VGQjsFjTrljbxmvDiSMCChtuAeNglQrhamyd87uOFxbj4rl4pki8x/x3pLZTSTSjupXmwvn
 /pzijYLmKyuezgxFhR6h1oQslEB1mkBaLgb3Ow0HIeYhRfYvOt1BbXSV1l6U2t+j9WxTY8rRY
 kKt3NCM+KO6RgHJEWMOvUs+TyM3Cm92tzbMgbbX8H8+pfLjw3xzBXvs9QD/v7iDcEy0p4VTiz
 2UnAjuni5SDBHyABRva5GJnqlbBco+twcue0eFfeHcyGYfYo7lw12pYw+X9/ma+cN5vEFIqca
 c+UcVwHjCv0K3F2WPwdBLKnYIMSE5xlTZDKgLv9XSVwqFf7D3p4nOfUADTbi0sgxbAHNy7nfV
 YmIPLn/kWeqrJ8P1VlX0tHVPidMCJnU1J0zsCrBD3pV6/0/Jd7pn9kFxMe5wo2p2GcLmmk4Hn
 aiVyl+i6AAHW3hWf0
Sender: linux-bcachefs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

sorry for spamming, its just a test mail

does anybody receive this message? if yes please reply.


