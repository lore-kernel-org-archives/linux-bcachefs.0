Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E16C77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 20:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbjEIUfz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 16:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbjEIUfx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 16:35:53 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0204C3A
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 13:35:51 -0700 (PDT)
Date:   Tue, 9 May 2023 16:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683664550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bOLU3sapllcewNBR7FzZE4kRKHtulEGc3tuPC3AF1dw=;
        b=U8bcUVvotaRPyRRACFPnRTRwvPS3y5ur307IdPdCCWvv/UwWw7OvkRF5cbgs6N3lhpYgze
        TrAoI+TVLgb0XR9foD0b810kH+b9S30Jf10Gm+3xJnpN8nlqTqJqHhGPlW/pNq0DDTZe9P
        mUpbKetA3FAX/6MKkBpPLhT0lZ6E1d8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Waiman Long <longman@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 03/32] locking/lockdep: lockdep_set_no_check_recursion()
Message-ID: <ZFquoxJn1RzWhRiI@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-4-kent.overstreet@linux.dev>
 <20230509193147.GC2148518@hirez.programming.kicks-ass.net>
 <ZFqqsyDpatgb77Vh@moria.home.lan>
 <d5b65b01-62a9-e483-dea8-5e2bb65be278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5b65b01-62a9-e483-dea8-5e2bb65be278@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 04:27:46PM -0400, Waiman Long wrote:
> 
> On 5/9/23 16:18, Kent Overstreet wrote:
> > On Tue, May 09, 2023 at 09:31:47PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 09, 2023 at 12:56:28PM -0400, Kent Overstreet wrote:
> > > > This adds a method to tell lockdep not to check lock ordering within a
> > > > lock class - but to still check lock ordering w.r.t. other lock types.
> > > > 
> > > > This is for bcachefs, where for btree node locks we have our own
> > > > deadlock avoidance strategy w.r.t. other btree node locks (cycle
> > > > detection), but we still want lockdep to check lock ordering w.r.t.
> > > > other lock types.
> > > > 
> > > ISTR you had a much nicer version of this where you gave a custom order
> > > function -- what happend to that?
> > Actually, I spoke too soon; this patch and the other series with the
> > comparison function solve different problems.
> > 
> > For bcachefs btree node locks, we don't have a defined lock ordering at
> > all - we do full runtime cycle detection, so we don't want lockdep
> > checking for self deadlock because we're handling that but we _do_ want
> > lockdep checking lock ordering of btree node locks w.r.t. other locks in
> > the system.
> 
> Maybe you can use lock_set_novalidate_class() instead.

No, we want that to go away, this is the replacement.
