Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1AFC77B7F
	for <linux-bcachefs@archiver.kernel.org>; Sat, 13 May 2023 00:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbjEMARc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 12 May 2023 20:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjEMARb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 12 May 2023 20:17:31 -0400
Received: from out-35.mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375A74EFA
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 May 2023 17:17:28 -0700 (PDT)
Date:   Fri, 12 May 2023 20:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683937047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ttMl3GoRsIQ0YRrQbLyOfzRqiL8QgIkkNBy0HJi+tP4=;
        b=Jlj8jvQrMzOj8HRaOclGGYRDE+ycviRq3z6G8f67Endeg3L2V1BLpLT3rP9PRqmPPUsotr
        bplaU/zH6tdzWWvuiET7LbTKrh0nvnnasSO5gT7hYLB7z5npiZVyuEzSiSuZfCwRHFytp+
        /Ox3JZ5RVHFZAiBOriaJYG8xcd9f6CM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 04/32] locking: SIX locks (shared/intent/exclusive)
Message-ID: <ZF7XEzTT+liYXEge@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-5-kent.overstreet@linux.dev>
 <7233p553-861o-9772-n4nr-rr5424prq1r@vanv.qr>
 <ZF6oejsUGUC0gnYx@moria.home.lan>
 <o52660s0-3s6s-9n74-8666-84s2p4qpoq6@vanv.qr>
 <ZF7LJdKoHj44KzVu@moria.home.lan>
 <d0c0488e-d862-fd4d-1687-5c9fec42ef76@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c0488e-d862-fd4d-1687-5c9fec42ef76@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, May 12, 2023 at 04:49:04PM -0700, Randy Dunlap wrote:
> 
> 
> On 5/12/23 16:26, Kent Overstreet wrote:
> > On Sat, May 13, 2023 at 12:39:34AM +0200, Jan Engelhardt wrote:
> >>
> >> On Friday 2023-05-12 22:58, Kent Overstreet wrote:
> >>> On Thu, May 11, 2023 at 02:14:08PM +0200, Jan Engelhardt wrote:
> >>>>> +// SPDX-License-Identifier: GPL-2.0
> >>>>
> >>>> The currently SPDX list only knows "GPL-2.0-only" or "GPL-2.0-or-later",
> >>>> please edit.
> >>>
> >>> Where is that list?
> >>
> >> I just went to spdx.org and then chose "License List" from the
> >> horizontal top bar menu.
> > 
> > Do we have anything more official? Quick grep through the source tree
> > says I'm following accepted usage.
> 
> Documentation/process/license-rules.rst points to spdx.org for
> further info.
> 
> or LICENSES/preferred/GPL-2.0 contains this:
> Valid-License-Identifier: GPL-2.0
> Valid-License-Identifier: GPL-2.0-only
> Valid-License-Identifier: GPL-2.0+
> Valid-License-Identifier: GPL-2.0-or-later
> SPDX-URL: https://spdx.org/licenses/GPL-2.0.html

Thanks, I'll leave it at GPL-2.0 then.
