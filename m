Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC68CC48BCD
	for <linux-bcachefs@archiver.kernel.org>; Wed,  9 Jun 2021 19:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF40460E0C
	for <linux-bcachefs@archiver.kernel.org>; Wed,  9 Jun 2021 19:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhFITqP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:46:15 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:59811 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhFITqO (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 9 Jun 2021 15:46:14 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 15:46:14 EDT
Date:   Wed, 9 Jun 2021 21:38:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1623267528; bh=w0BIPEijxY4CROjUXR2nb7vubOdp2YglpgfY4rWFGfY=;
        h=Date:From:To:Cc:Subject:From;
        b=gfA1z6hlNeR2ZmY0rDVj5Yk3Zx+vtUH3OShbW3JGCa8gxPFP7DVRrjg23djpYYJrW
         28aWlUgRZf2bDUs9kHPaEc8/Tgu7CQvHelZl6zo+iGGYc6JFAgvuff8PRtI8IUru39
         ZoVet3NUdqqL+wdtR143HQH5zGAK6bHOpWPktv7g=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: Archives for linux-bcachefs@vger.kernel.org
Message-ID: <5eb474a5-95e3-4861-94dc-795c14350b70@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Jabber-ID: thomas@t-8ch.de
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi everyone,

I'd like to ask to have the archives of linux-bcachefs@vger.kernel.org to be
published to http://lore.kernel.org .
This would allow interested lurkers (like me) to follow the discussions from
time to time.

Sorry if this has already been discussed, but there are no archives I could
have checked :-)

The process for adding new lists to lore.kernel.org is described here:
https://korg.docs.kernel.org/lore.html

Thanks,
Thomas
