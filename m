Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2364BC77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 05:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjEIFLP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 01:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjEIFLO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 01:11:14 -0400
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A78883C8
        for <linux-bcachefs@vger.kernel.org>; Mon,  8 May 2023 22:11:13 -0700 (PDT)
Date:   Tue, 9 May 2023 01:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683609070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1WzlbcgLXL87Hv21V2tM6g0jkXu2NDC62QpL4ybESnk=;
        b=rIgj6GSkaVdQOoX0nmNA6MRmjJXnCVM8Qb90CyVK8soSRiK7B6h1iCq/8HaNram/9jzBX5
        mFaexq6eT4NsomoHRdzIOynX35Zw9lPkSng/mc1F4qGJ3rKJKu9ZqcSP2oV2tN/9fFdF4a
        MVyhCE4l2/p57OzRfd+dKwNi2B1sfqc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Josh Litherland <josh@temp123.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs fsck out-of-memory
Message-ID: <ZFnV6wfafWPeuHDv@moria.home.lan>
References: <CAKib_wKEnoF4=aFVhA5Sd0Edcyo6=RTs0i81ntADFogFezR=cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKib_wKEnoF4=aFVhA5Sd0Edcyo6=RTs0i81ntADFogFezR=cg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, May 05, 2023 at 09:49:14AM -0400, Josh Litherland wrote:
> I have a largeish filesystem (4x16TB + 2x2TB) which was uncleanly shut
> down.  I am attempting to do an fsck repair, and consistently hitting
> the OOM killer (approximately 64GiB RAM in use) with the userspace
> fsck repair tool.  The in-kernel repair runs for a while and
> eventually stops doing any IO while the mount command hangs, so I
> assume it's hitting the same condition.
> 
> Kernel is 6.3.0-bcachefs-ccc8737427a3.
> bcachefs-tools is revision 6b1f79d5df9f2735192ed1a40c711cf131d4f43e.
> 
> Please let me know if there is any information I can provide that
> might help to debug this issue, or any other repair techniques I can
> try out.  I have a recent backup of the data, and I'm not in a
> particular hurry to wipe and reformat the drives.

In kernel fsck is a bit more resilient to low memory conditions, and a
bit easier to debug.

Could you get stacktraces when it's gotten stuck, and pipe them through
decode_stacktrace.sh (kernel source tree)?  'echo w >
/proc/sysrq-trigger' should put the right stack traces in the dmesg log.
