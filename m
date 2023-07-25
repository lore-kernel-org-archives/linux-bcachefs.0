Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487E5EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Jul 2023 03:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjGYDAu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 Jul 2023 23:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjGYDAp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 Jul 2023 23:00:45 -0400
Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [IPv6:2001:41d0:203:375::11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18A0A6
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jul 2023 20:00:43 -0700 (PDT)
Date:   Mon, 24 Jul 2023 23:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690254040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q7+t6JGgjNA4srPAzMo98NzDSt2aKwb5Cbcib1WcjJM=;
        b=qOkfgLMsqd8UvX0fEhUXY2j3afh1S4GVEQM7LfgmYCfW4QzrKi0buH1nYnbQE9yCCnBoLN
        nw6UqzTjFUi37nyOeyJCqMmaNW2h6+Y9WuCrYYWKqaWqFKSNkvMgkI40DiH0ljCu1rL3lM
        D0JrzMwWir2854jKvwSTymA6T/f+AKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/20] block: Add some exports for bcachefs
Message-ID: <20230725030037.minycb3oxubajuqw@moria.home.lan>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
 <20230712211115.2174650-5-kent.overstreet@linux.dev>
 <ZL61WIpYp/tJ6XH1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL61WIpYp/tJ6XH1@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:31:04AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 12, 2023 at 05:10:59PM -0400, Kent Overstreet wrote:
> > From: Kent Overstreet <kent.overstreet@gmail.com>
> > 
> >  - bio_set_pages_dirty(), bio_check_pages_dirty() - dio path
> 
> Why?  We've so far have been able to get away without file systems
> reinventing their own DIO path.  I'd really like to keep it that way,
> so if you think the iomap dio code should be improved please explain
> why.  And please also cycle the fsdevel list in.

It's been discussed at length why bcachefs doesn't use iomap.

In short, iomap is heavily callback based, the bcachefs io paths are
not - we pass around data structures instead. I discussed this with
people when iomap was first being written, but iomap ended up being a
much more conservative approach, more in line with the old buffer heads
code where the generic code calls into the filesystem to obtain
mappings.

I'm gradually convincing people of the merits of the bcachefs approach -
in particular reducing indirect function calls is getting more attention
these days.
