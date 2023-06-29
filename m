Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC54EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Thu, 29 Jun 2023 17:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjF2Rej (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 29 Jun 2023 13:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjF2ReY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 29 Jun 2023 13:34:24 -0400
X-Greylist: delayed 492 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Jun 2023 10:34:23 PDT
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321733AB8
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Jun 2023 10:34:23 -0700 (PDT)
Received: from quad.stoffel.org (097-095-183-072.res.spectrum.com [97.95.183.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 11A8B1E131
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Jun 2023 13:26:11 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id CFD3BA8779; Thu, 29 Jun 2023 13:26:09 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25757.48817.821649.430062@quad.stoffel.home>
Date:   Thu, 29 Jun 2023 13:26:09 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     linux-bcachefs@vger.kernel.org
Subject: Can I export bcachefs via NFS yet?
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


Hi,
I looked on the web site but didn't see anything in the docs or the
FAQ, and all questions about this are quite old, so I figured I'd ask
if NFS exports are now supported with bcachefs?

Thanks,
John
