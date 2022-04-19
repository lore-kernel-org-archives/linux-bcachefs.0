Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABD3C433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 01:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245188AbiDSBS6 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 18 Apr 2022 21:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiDSBS5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 18 Apr 2022 21:18:57 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C150763EE
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 18:16:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 18D4281;
        Mon, 18 Apr 2022 18:16:16 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wvR5J0aqF6LC; Mon, 18 Apr 2022 18:16:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id B61CB40;
        Mon, 18 Apr 2022 18:16:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net B61CB40
Date:   Mon, 18 Apr 2022 18:16:09 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs loop devs (was: Comparison to ZFS and BTRFS)
In-Reply-To: <20220415191140.2xyni3kusht6wear@moria.home.lan>
Message-ID: <1f3290c6-535a-a15f-c02f-325099ecc4e0@ewheeler.net>
References: <Yk05Sk4ztxLMpgrt@itl-email> <20220415191140.2xyni3kusht6wear@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, 15 Apr 2022, Kent Overstreet wrote:
> On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> > - How does an O_DIRECT loop device on bcachefs compare to a zvol on ZFS?
> 
> I'd have to benchmark/profile it. It appears there's some bugs in the way the
> loop driver in O_DIRECT mode interacts with bcachefs according to xfstests, and
> the loopback driver is implemented in a more heavyweight way that it needs to be
> - there's room for improvement.

Hi Kent, regarding loop devs:

We wrote this up before realizing that REQ_OP_FLUSH does not order writes 
like REQ_FLUSH once did, so my premise for the email linked below was 
incorrect---but perhaps the concept is relevant.

I wonder if something is going on between (1) filesystem above loop.c 
(bcachefs in this case), (2) the block layer re-ordering, and (3) the 
kiocb ki_complete callback in loop.c that could create out-of-order 
journal commits in the filesystem above the loop device (eg, xfs from #1):

	https://www.spinics.net/lists/linux-block/msg82730.html

  From loop.c in lo_rw_aio():
	[...]
	cmd->iocb.ki_pos = pos;
	cmd->iocb.ki_filp = file;
	cmd->iocb.ki_complete = lo_rw_aio_complete; 
	cmd->iocb.ki_flags = IOCB_DIRECT;
	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);

  A more detailed loop.c call tree summary is here:
	https://lore.kernel.org/all/59a58637-837-fc28-6cb9-d584aa21d60@ewheeler.net/T/ 

If bcachefs immediately calls .ki_complete() after queueing the IO within 
bcachefs but before it commits to bcachefs's disk, then loop.c will mark 
the IO as complete (blk_mq_complete_request via lo_rw_aio_complete) too 
soon after .write_iter is called, thus breaking the expected ordering in 
the filesystem (eg, xfs) atop of the loop device.

This could be compounded if bcachefs's .write_iter calls can complete 
early _and_ out-of-order from how loop.c called them (if they are queued 
and dequeued on a tree structure, for example). Perhaps loop.c or the fs 
under the loopdev (like bcachefs) need a bit of help with completion 
notification (or ordering) in this case.

I'm not sure if this is the issue or not, so just passing it along if it 
helps.

-Eric
