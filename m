Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F7DC0015E
	for <linux-bcachefs@archiver.kernel.org>; Fri, 21 Jul 2023 21:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjGUVCL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 21 Jul 2023 17:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjGUVCK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 21 Jul 2023 17:02:10 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88882D46
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 14:02:08 -0700 (PDT)
Date:   Fri, 21 Jul 2023 17:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689973326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qU4pVSi0qlsp/0gxWHwDn4/ri1zKINeBjharA19UaFk=;
        b=Oip8IxKTBK+I26brJgkdhp4lHFcuGA1IlfJg+zTU/pS3B+ZdqwvTmcbTPxQPD1x6gR/kkJ
        3EuVqunTwDU7WQcBbii7zrQ8u2Hugu8KCZ6PBLRBhyPw6KYOXBKygKpd5TjrE2qd71aUfa
        EUZBrDxPreBQ2hBd1WJHECVHwY/XDC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs fallocate btree lock contention
Message-ID: <20230721210202.3xwczo2fmymul26m@moria.home.lan>
References: <ZLqIB3k600oAS3G1@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLqIB3k600oAS3G1@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jul 21, 2023 at 09:28:39AM -0400, Brian Foster wrote:
> One question that comes to mind: why do we cycle locks here? Is this a
> lock ordering requirement between folio locks and btree node locks?

There is a lock ordering requirement, but more broadly we don't like to
hold btree locks while doing anything else that could block - we strive
to keep the lock hold time for btree node locks as low as possible, as
that's one of the biggest factors for overal tail latency.

btree node locks shouldn't be held for more than tens of microseconds -
folio lock can be held for the duration of IO, so we definitely don't
want to be blocked on that.

Recently I was doing some work to avoid ever invoking memory reclaim
while holding btree node locks - same deal. We first try memory
allocations with GFP_NOWAIT|__GFP_NOWARN, then if that fails, call
bch2_trans_unlock() and retry with GFP_KERNEL. Also means we don't have
to muck with GFP_NOFS/GFP_NOIO as much...
