Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E59FC7EE22
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 20:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbjEIUTF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 16:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjEIUTF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 16:19:05 -0400
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027B63ABF
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 13:19:03 -0700 (PDT)
Date:   Tue, 9 May 2023 16:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683663542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3NB9UVIxBGJqWtZGB1ALQW3U92XErZENLAn8qk7xNIM=;
        b=q5sPvgkBW++VRojipgY8KW+2lpXFtMiia21SScukswTn4rwBnEpdMkNzUrm6+sZ+5cH6ZX
        6uNK6pOdWdmnNxPRrbBUmdrPhQROwqSSfWH0ihSZjx22vZ9ev/hhXiwllYyQiJjSVY5e5h
        WaPw1UVUFJn1+g0/r51dh8LdwRgHAtQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 03/32] locking/lockdep: lockdep_set_no_check_recursion()
Message-ID: <ZFqqsyDpatgb77Vh@moria.home.lan>
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

Actually, I spoke too soon; this patch and the other series with the
comparison function solve different problems.

For bcachefs btree node locks, we don't have a defined lock ordering at
all - we do full runtime cycle detection, so we don't want lockdep
checking for self deadlock because we're handling that but we _do_ want
lockdep checking lock ordering of btree node locks w.r.t. other locks in
the system.
