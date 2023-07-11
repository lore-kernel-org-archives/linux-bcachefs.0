Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17728EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Tue, 11 Jul 2023 06:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGKGHU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 11 Jul 2023 02:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjGKGHT (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 11 Jul 2023 02:07:19 -0400
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jul 2023 23:07:17 PDT
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41D5D2
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 23:07:17 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 2C8D973B075
        for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jul 2023 07:59:21 +0200 (CEST)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-bcachefs@vger.kernel.org
Subject: Testing bcachefs: Which kernel source?
Date:   Tue, 11 Jul 2023 07:59:20 +0200
Message-ID: <2231825.iZASKD2KPV@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi!

I managed to compile the tools.

I also got

https://evilpiepirate.org/git/bcachefs.git

and I see tags like bcachefs-v6.3, however those are not pointing to the 
release commit by Linus. Of course this may be due to bcachefs patches 
merged on top of latest commit by Linus.

In case I decide to test bcachefs prior to merge into vanilla / mainline 
kernel, I like to make sure that bcachefs is the only "experimental" 
thing in there, i.e. that the kernel otherwise is stable.

How to go about this? Are there stable trees / tags for kernel with 
bcachefs included? If so is 6.4 already available with bcachefs on top?

Otherwise I'd  just wait for merge.

Ciao,
-- 
Martin


