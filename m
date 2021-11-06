Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA61C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 17:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7A56124F
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 17:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhKFRMl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:12:41 -0400
Received: from cdw.me.uk ([91.203.57.136]:45023 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234649AbhKFRMk (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 6 Nov 2021 13:12:40 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mjPCY-0001SE-0X; Sat, 06 Nov 2021 17:09:58 +0000
Date:   Sat, 6 Nov 2021 17:09:58 +0000
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Return -ENOKEY/EINVAL when mount decryption
 fails
Message-ID: <20211106170957.GL11670@arachsys.com>
References: <20211104210316.GA22353@arachsys.com>
 <YYaxYg1hSAR01/Lk@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYaxYg1hSAR01/Lk@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> Thanks! Applied - I did some more cleanups on top of your patch, too.

Brilliant, thanks. I like that ?: chain! :)

Best wishes,

Chris.
