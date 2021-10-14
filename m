Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AE4C433F5
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Oct 2021 12:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6957604AC
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Oct 2021 12:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhJNMyt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:54:49 -0400
Received: from cdw.me.uk ([91.203.57.136]:43847 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhJNMyt (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Oct 2021 08:54:49 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mb0Dz-0002YU-QD; Thu, 14 Oct 2021 13:52:43 +0100
Date:   Thu, 14 Oct 2021 13:52:43 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcachefs: Return -ENOKEY/EINVAL when mount decryption
 fails
Message-ID: <20211014125243.GA9460@arachsys.com>
References: <20211014124016.GE11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014124016.GE11670@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> Return explicit error pointers out of bch2_fs_alloc() and handle them in
> both callers, so the user instead sees

Very happy to re-spin this in a different shape if you prefer to do anything
differently. I haven't split any other failure cases away from -ENOMEM in
this patch: most of them seem well-characterised as 'out of memory' anyway,
at least at first glance.

I did wonder about factoring the superblock decryption out of bch2_fs_alloc
completely rather than changing the NULL return code, but I think that's not
possible as later parts bch2_fs_alloc already require it to be unlocked?

> Signed-off-by: Chris Webb <chris@@arachsys.com>

*sigh* s/@@/@/ sorry!

Cheers,

Chris.
