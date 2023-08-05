Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBD0C001DB
	for <linux-bcachefs@archiver.kernel.org>; Sat,  5 Aug 2023 16:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjHEQFH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHEQFG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 5 Aug 2023 12:05:06 -0400
Received: from out-88.mta0.migadu.com (out-88.mta0.migadu.com [IPv6:2001:41d0:1004:224b::58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979BCE70
        for <linux-bcachefs@vger.kernel.org>; Sat,  5 Aug 2023 09:05:04 -0700 (PDT)
Date:   Sat, 5 Aug 2023 12:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691251501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QlS20ItkTPJtF0Up77rfImPazD8thrk8m2hRRGtz5x8=;
        b=ATw+sB+5DEQINlWohF/pNZN44UkzWl72RcCUxeoo6AL5pqnzMAcRX1JOm1WIUYXTS7rTnW
        /ZI8aL379HHKRieViBbNEbl/bVr68g5s2jyKZvSkS6tct3mUeauwraQJdN/rqaeBv5kMQ6
        CAH/0BNcIlhtbypvaLuoYte1rCzsHnw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix lock thrashing in __bchfs_fallocate()
Message-ID: <20230805160455.b3gsyb5qmq5f2w3p@moria.home.lan>
References: <20230803075018.3771018-1-kent.overstreet@linux.dev>
 <ZM0sbddS+mKhYkNG@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZM0sbddS+mKhYkNG@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Aug 04, 2023 at 12:50:53PM -0400, Brian Foster wrote:
> Nice. I recall that I had tried a quick experiment to just remove the
> drop_locks_do() here and did end up producing a lockup, but I forget the
> details. Aside from the general btree node locking principle you
> mentioned in the previous thread, a brief comment on the hard lock
> ordering rule here might be nice for future reference.

*nod* - added that

> > -	folio = filemap_lock_folio(mapping, *offset >> PAGE_SHIFT);
> > +	folio = __filemap_get_folio(mapping, *offset >> PAGE_SHIFT,
> > +				    !nonblock ? FGP_LOCK : 0, 0);
> >  	if (IS_ERR_OR_NULL(folio))
> >  		return true;
> 
> Looks like a bit of return value wonkiness here.. the function now
> returns int, but we return true here, ret is a bool, etc.

It looks fine to me; it would definitely make more sense in Rust where
the return value would be Result<Bool, Errcode>, that's just how I'm
thinking about it here, even if it's a bit weird in C.

> Also JFYI it looks like filemap has an FGP_NOWAIT flag that when paired
> with FGP_LOCK avoids the need for the extra code here.

Thanks, added that.

> Those nits aside this looks pretty good to me. Thanks for fixing it.
> I'll have to give it a test (once I'm back most likely, I'm away for a
> couple or so more days after today).

It's been in the master branch for a bit (and the fixup for FGP_NOWAIT
is in the testing branch now), so I think it's pretty well tested at
this point.
