Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6BEC61DA3
	for <linux-bcachefs@archiver.kernel.org>; Sat,  4 Mar 2023 02:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCDC5t (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Mar 2023 21:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjCDC5t (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Mar 2023 21:57:49 -0500
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89DA637E8
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Mar 2023 18:57:44 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:57:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677898663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D4o9XJK6WS1tj6TGcOHlI8cqrEsXKu8aZWWg4h+dWGY=;
        b=kJOURykj553iQHn4AnU8N0rNcx3o5hGxzR5nfzj1iFCNQwRBkS539OmOYUKk43aSWJtWBy
        EO4HbKziQ0DqaYgalOCHcylCjjmGrp0hjclCNdk1QUbcYo8pMe2qwNVJbLSHknDDAgOwK+
        VbsvoNwoX1jg5moFJcQXks+1G4f2Cwo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v0] implement torture test when formatting device
Message-ID: <ZAKzpJVb7EE/raxX@moria.home.lan>
References: <fb79ef69-7b0b-c790-a212-ca1cf76da8cd@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb79ef69-7b0b-c790-a212-ca1cf76da8cd@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Mar 03, 2023 at 01:21:47PM +0100, Janpieter Sollie wrote:
> Hi everyone,
> 
> following my question yesterday:
> hereby what I'd suggest as a torture test when formatting the device,
> it would be implemented as a "torture" option, and not set by default.
> Whereas this code is still not failproof (which will be for v1), and error
> handling should be returned instead of dying,
> is it worth it to keep writing in libbcachefs.c?
> Or should I go completely rust-way instead?

I'm not sure this is something that belongs in bcachefs; this semes like
it should be a generic tool, and then we could add an option to
'bcachefs format' to call it pre-format.

Alternately: if it was going to be integrated into the filesystem, the
reason to do that would be to make it a runtime thing, sort of an
ongoing 'health check'.

But we already tools like smartctl, so we'd have to be clear on what the
goals are and what we're trying to provide.

There _is_ something related that I've been wanting, though. We need
latency numbers for every device - we need to track each device's
current latency, so we know which device(s) to send reads to, and we
need to know the latency each device is capable of, so we know if a
device is congested.

That is, we want baseline and current numbers for every device. Right
now we're collecting latency quantiles for every device and using (IIRC)
99th percentile latency for baseline, but computing quantiles is an
expense I'd like to get rid of - having a baseline would be better.

If we're computing baseline numbers, we could also re-compute them with
a short test on every mount and track them over time - I think that's
something we could reasonably add. That'd let us provide the user with
some basic performance numbers for each device and a history over time.
