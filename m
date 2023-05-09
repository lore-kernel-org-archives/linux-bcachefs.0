Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF9BC7EE22
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 19:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbjEIT5X (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 15:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjEIT5W (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 15:57:22 -0400
Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179063AA4
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 12:57:19 -0700 (PDT)
Date:   Tue, 9 May 2023 15:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683662238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vA3sbbV/QHVDEjFWeRW1Pm0ZfEpL5zDeaHwLB6+B5mM=;
        b=LIjUnmNxS8zN+vYMhDT777VrmOACO6jwMvt5gO+8h44LS8gTFFx/ZseLESAkOf3iWbefUm
        5h5F1IFqHB+hPJr/ZJwiTYG5znYVAvWkwxkodArfJldk7wj43vOFNhstko3JOQ0thONvyA
        InTGcdRW5rNd1CoPZXKYU/LtJb9c/7w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 03/32] locking/lockdep: lockdep_set_no_check_recursion()
Message-ID: <ZFqlmrL27is3AofY@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-4-kent.overstreet@linux.dev>
 <20230509193147.GC2148518@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509193147.GC2148518@hirez.programming.kicks-ass.net>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 09:31:47PM +0200, Peter Zijlstra wrote:
> On Tue, May 09, 2023 at 12:56:28PM -0400, Kent Overstreet wrote:
> > This adds a method to tell lockdep not to check lock ordering within a
> > lock class - but to still check lock ordering w.r.t. other lock types.
> > 
> > This is for bcachefs, where for btree node locks we have our own
> > deadlock avoidance strategy w.r.t. other btree node locks (cycle
> > detection), but we still want lockdep to check lock ordering w.r.t.
> > other lock types.
> > 
> 
> ISTR you had a much nicer version of this where you gave a custom order
> function -- what happend to that?

Probably in the other branch that I was meaning to re-mail you separately,
clearly I hadn't pulled the latest versions back into here... expect
that shortly :)
