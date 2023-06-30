Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A159EB64DA
	for <linux-bcachefs@archiver.kernel.org>; Fri, 30 Jun 2023 16:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjF3QvE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 30 Jun 2023 12:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjF3QvD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 30 Jun 2023 12:51:03 -0400
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28E110FB
        for <linux-bcachefs@vger.kernel.org>; Fri, 30 Jun 2023 09:51:02 -0700 (PDT)
Received: from quad.stoffel.org (097-095-183-072.res.spectrum.com [97.95.183.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 560881E135;
        Fri, 30 Jun 2023 12:51:01 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 9BF8CA877F; Fri, 30 Jun 2023 12:51:00 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <25759.2036.615693.236421@quad.stoffel.home>
Date:   Fri, 30 Jun 2023 12:51:00 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     John Stoffel <john@stoffel.org>, linux-bcachefs@vger.kernel.org
Subject: Re: Can I export bcachefs via NFS yet?
In-Reply-To: <5de7dbad-5597-f70e-37d6-948ab073bc15@kabelmail.de>
References: <25757.48817.821649.430062@quad.stoffel.home>
        <5de7dbad-5597-f70e-37d6-948ab073bc15@kabelmail.de>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

>>>>> "Janpieter" == Janpieter Sollie <janpieter.sollie@kabelmail.de> writes:

> Op 29/06/2023 om 19:26 schreef John Stoffel:
>     Hi,
>     I looked on the web site but didn't see anything in the docs or the
>     FAQ, and all questions about this are quite old, so I figured I'd ask
>     if NFS exports are now supported with bcachefs?
    
>     Thanks,
>     John

> So far, when using a recent version of both bcachefs-tools and
> bcachefs kernel code, there's nothing "not working" with NFS4.  I
> didn't test 4.1 or 4.2 features (yet), but standard bcachefs NFS
> exports works for > 6 months already

Thanks for the info!  So I'm going to guess that NFSv3 works just fine
too.  Can't wait to see this make it into mainline so I can start
testing it.  I can see using this for some scratch volumes as a test
for a while to make sure it's all stable before I use it elsewhere.

John


