Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FDDC7EE23
	for <linux-bcachefs@archiver.kernel.org>; Mon, 29 May 2023 23:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjE2Xv3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 29 May 2023 19:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjE2Xv3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 29 May 2023 19:51:29 -0400
Received: from out-24.mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEBABE
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 May 2023 16:51:27 -0700 (PDT)
Date:   Mon, 29 May 2023 19:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685404285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZMyH5ywG95dJvqFxeP9ZoI1z8D8zSKJF9jm0WDtx81o=;
        b=bDvlAjngnw8S8QDdRW3x/tnFNMBnKbLP4KSPE0BX6iLVTLgGFQsHLt6xWQWcXPWL+T3HsU
        Xrpis5AsEDWlIDEdhxC9r+hDytGJO2x5gRhI5LhXe6WKT3cGzxLNhxSPbBPrsjfsxu2Azy
        2W2k1/Ze5SA79btwwFF32DjntsQOSaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-bcachefs@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: fuzzing bcachefs with dm-flakey
Message-ID: <ZHU6eX2wOXJjDVc0@moria.home.lan>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHUVy7jut1Ex1IGJ@casper.infradead.org>
 <ZHUxbLh1P9yiq2c9@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHUxbLh1P9yiq2c9@dread.disaster.area>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 30, 2023 at 09:12:44AM +1000, Dave Chinner wrote:
> Perhaps it is worthwhile running the same tests on btrfs so we can
> something to compare the bcachefs behaviour to. I suspect that btrfs
> will fair little better on the single device, no checksums
> corruption test....

It's also a test we _should_ be doing much, much better on: we've got
validation code for every key type that we run on every metadata read,
so there's no excuses for thees bugs and they will be fixed.

Just a question of when and in what order...
