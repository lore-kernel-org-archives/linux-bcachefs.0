Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C5BEB64DD
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Jul 2023 02:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjGYCo4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 24 Jul 2023 22:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjGYCoz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 24 Jul 2023 22:44:55 -0400
Received: from out-62.mta1.migadu.com (out-62.mta1.migadu.com [IPv6:2001:41d0:203:375::3e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C23199B
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jul 2023 19:44:26 -0700 (PDT)
Date:   Mon, 24 Jul 2023 22:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690252995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zRlrLYqhm+DPWxs7qL0A08DMpLwzB/CFij0sa/3sknc=;
        b=VSIgW8uv8ZpGeForKyxp5LXrl5qslkkkhEn9qNjeG9qTCU4POVXOOYUylXGypZcMWWZmvn
        SdaODHDbZ5GG80ZkjdvF7HKp5q/RI24bsVi1BIh0WuEQjtnIo8Rs++eMnE9lKrB3BUaLoT
        OtPtHX4794EPxbB++CXEbjcq6hzLpD4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 05/20] block: Allow bio_iov_iter_get_pages() with
 bio->bi_bdev unset
Message-ID: <20230725024312.alq7df33ckede2gb@moria.home.lan>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
 <20230712211115.2174650-6-kent.overstreet@linux.dev>
 <ZL62HKrAJapXfcaR@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL62HKrAJapXfcaR@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:34:20AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 12, 2023 at 05:11:00PM -0400, Kent Overstreet wrote:
> > bio_iov_iter_get_pages() trims the IO based on the block size of the
> > block device the IO will be issued to.
> > 
> > However, bcachefs is a multi device filesystem; when we're creating the
> > bio we don't yet know which block device the bio will be submitted to -
> > we have to handle the alignment checks elsewhere.
> 
> So, we've been trying really hard to always make sure to pass a bdev
> to anything that allocates a bio, mostly due due the fact that we
> actually derive information like the blk-cgroup associations from it.
> 
> The whole blk-cgroup stuff is actually a problem for non-trivial
> multi-device setups.  XFS gets away fine because each file just
> sits on either the main or RT device and no user I/O goes to the
> log device, and btrfs papers over it in a weird way by always
> associating with the last added device, which is in many ways gross
> and wrong, but at least satisfies the assumptions made in blk-cgroup.
> 
> How do you plan to deal with this?  Because I really don't want folks
> just to go ahead and ignore the issues, we need to actually sort this
> out.

Doing the blk-cgroup association at bio alloc time sounds broken to me,
because of stacking block devices - why was the association not done at
generic_make_request() time?
