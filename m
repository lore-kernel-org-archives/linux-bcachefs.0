Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5214CC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  9 Oct 2021 09:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D98660F6C
	for <linux-bcachefs@archiver.kernel.org>; Sat,  9 Oct 2021 09:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhJIJWW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 9 Oct 2021 05:22:22 -0400
Received: from cdw.me.uk ([91.203.57.136]:45173 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhJIJWV (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 9 Oct 2021 05:22:21 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mZ8Wl-0006pF-5Y; Sat, 09 Oct 2021 10:20:23 +0100
Date:   Sat, 9 Oct 2021 10:20:23 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: BUG_ON in fs/bcachefs/btree_iter.c
Message-ID: <20211009092022.GA21732@arachsys.com>
References: <20211007115230.GA24322@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007115230.GA24322@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent. A quick follow-up to the bug report I sent to the list on Thursday:

Chris Webb <chris@arachsys.com> writes:

> However, when I test a simple replicated config on two small zram disks,
[...]
> I can get instantly get a reliable BUG_ON at fs/bcachefs/btree_iter.c:2475
> by running a data rereplicate, which should presumably be a no-op?
[...]
>   [  238.033452] kernel BUG at fs/bcachefs/btree_iter.c:2475!
[...]
>   [  273.286870] kernel BUG at fs/bcachefs/btree_iter.c:367!

I can no longer trigger either of these bugs following your recent set of
patches from 2021-10-07: 222a80c6 to c988c58e.

Thanks, and sorry I forgot to copy you on both the original report and the
btrfs-tools libsodium scrypt patch which I sent to the linux-bcachefs
mailing list. (I was so excited at finding a project mailing list, I forgot
to actually CC: the maintainer!)

Best wishes,

Chris.
