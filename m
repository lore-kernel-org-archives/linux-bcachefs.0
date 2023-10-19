Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD1ECDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 15:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345484AbjJSPa1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 11:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345450AbjJSPa1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 11:30:27 -0400
Received: from out-193.mta0.migadu.com (out-193.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3203121
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 08:30:24 -0700 (PDT)
Date:   Thu, 19 Oct 2023 11:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697729423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVZr8pdATtAuW4NYuvMYvVXQ0LwrEXc3ZrLK8IVDtz8=;
        b=tnz/2s2JiovkW6wU7VtEbPdUet5CiScAMklSSR/3P5xQqYVDrLr2AaOSUed0BqndRy3moy
        PL5na/SsSU+B308PljXShqwxaN4+3N4TW0cuFrwERoEtpUT1rQBJ5/LM6ZruT3uONsBUpW
        h1NavDEqMrfIgsoXTDP0dYh0kAKB+xk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: update alloc cursor in early bucket allocator
Message-ID: <20231019153019.jl73n6ipif7zwc5b@moria.home.lan>
References: <20231019132746.279256-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019132746.279256-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 09:27:46AM -0400, Brian Foster wrote:
> A recent bug report uncovered a scenario where a filesystem never
> runs with freespace_initialized, and therefore the user observes
> significantly degraded write performance by virtue of running the
> early bucket allocator. The associated bug aside, the primary cause
> of the performance drop in this particular instance is that the
> early bucket allocator does not update the allocation cursor. This
> means that every allocation walks the alloc btree from the first
> bucket of the associated device looking for a bucket marked as free
> space.
> 
> Update the early allocator code to set the alloc cursor to the
> prospectively allocated bucket, similar to how the freelist
> allocator behaves. This improves performance of the early bucket
> allocator dramatically (even though it should be bypassed in favor
> of the freelist allocator in most cases).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> cshepherd on #bcache originally reported the early bucket allocator
> problem and helped chase it down to what looks like a members_v2
> regression. I believe he was planning to post a patch for that one.
> 
> Brian
> 
>  fs/bcachefs/alloc_foreground.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
> index 3bc4abd3d7d5..be3fc0f38c79 100644
> --- a/fs/bcachefs/alloc_foreground.c
> +++ b/fs/bcachefs/alloc_foreground.c
> @@ -431,7 +431,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
>  	}
>  	bch2_trans_iter_exit(trans, &iter);
>  
> -	ca->alloc_cursor = alloc_cursor;
> +	ca->alloc_cursor = IS_ERR_OR_NULL(ob) ? alloc_cursor : ob->bucket;

Oh, this code is broken. The local alloc_cursor never gets updated, and
it needs to for where we check if we need to loop around.

The proper fix would be to add

  alloc_cursor = iter.pos.offset;

before the line you changed
