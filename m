Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810C0C4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 23 Dec 2022 18:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiLWSDC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 23 Dec 2022 13:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiLWSDB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 23 Dec 2022 13:03:01 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386901DF2D
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Dec 2022 10:03:00 -0800 (PST)
Date:   Fri, 23 Dec 2022 13:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671818578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1UI3Y+a8o31mL/C2pqBdSszc4Mxn92buUs/morP3lRY=;
        b=sn9iNuAnBIAGtZA7on96NzmphesBu5u9fj2OHrg+nASFkr8Wyvu1ZkiffkZGrwGMFFxiHh
        dx8MsJ2/BML9AO5Pfd2HMkLXfX2DIIg4qC0l3g7sEQ9qtKREdoP31dul+FK7JhUw1FxSK/
        PDt0G4wjFNpx7A6iV1mf7N042HjR4WI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6XtSd8Fme4XpQoZ@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y6CC27y2Rf44DzFI@bfoster>
 <Y6EJmGTbFmAgmjre@moria.home.lan>
 <Y6RjqsXgCAJ/M7c+@bfoster>
 <Y6UwQnjX7VyV2NGk@moria.home.lan>
 <Y6WVsZ6IXPngUw9R@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6WVsZ6IXPngUw9R@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Dec 23, 2022 at 06:49:05AM -0500, Brian Foster wrote:
> IIRC that's pretty much the current behavior with XFS and iomap. XFS
> aggressively allocates large contiguous extents, writeback thus
> constructs large enough bio chains in the iomap ioend that completion
> processing can produce soft lockups just dealing with pages involved
> with the bio chain. Therefore the ioend became capped to a max number of
> chained bios. Of course writeback still carries on submitting the same
> amount of overall I/O either way, just made up of more ioends with
> smaller bio chains. But I suspect as folio size is able to increase,
> we'll be back to constructing larger I/Os based on fewer folios and thus
> with less processing overhead per submission (in scenarios where
> multipage bvecs doesn't already do so, at least).

Multipage bvecs just move segment merging up to bio_add_page() and allow more
pages to be stuffed into a bio when they're contiguous in memory - they don't
help with completion processing. Large folios will.
