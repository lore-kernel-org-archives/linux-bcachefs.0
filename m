Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0F2EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Jul 2023 14:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjGJO5A (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Jul 2023 10:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGJO5A (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Jul 2023 10:57:00 -0400
Received: from out-56.mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B4AC7
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 07:56:58 -0700 (PDT)
Date:   Mon, 10 Jul 2023 10:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689001017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mh9flybIQnasyqC4kTGvMop+7ZvEahZXsEp8eyGQhQc=;
        b=qUWxQmb7FgqvzE4CD9qfoe6lohCFW356Ncl8pKEIzziJnEV0nVZN66ZPu6k1FT9LZmsT3x
        lT/jmgFCd62yn+pCyz+HX3AHOzToGcZN9w93woVuKXfCbJ4iZczvviL/2j3ewTIJH+hXcD
        2AXvi+NDgciiCTzf+FaSmqaaeb7xyZA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
 <ZKwJk/JBoZzizU4p@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKwJk/JBoZzizU4p@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Jul 10, 2023 at 09:37:23AM -0400, Brian Foster wrote:
> This wording is a little confusing.. it's not clear to me why the lack
> of ref counts directly means they have to run in reverse order. What
> happens if such triggers are not run in reverse order? From the old (now
> removed) ordering fix patch, I take it the issue is that a backpointer
> (for example) key would be added and then immediately removed, right?
> 
> I wonder if this bit of docs would be more clear to do something like 1.
> explain what specific key types have particular ordering rules (and why,
> such as the reference count example given above), and then 2.  explain
> why the high level trigger invocation code has the current ordering (if
> it matters). I suspect the part below just goes away with that write buf
> ordering patch, at least for the time being..

Yeah, that sounds like a better documentation approach.

I'll work up a new patch (and try to do some git spelunking to make sure
I remember all the context).

> > Yeah I tend to think adding a bch2_trans_update_ordered() that matches
> > the behaviour of bch2_trans_update_buffered() is the way to go - the
> > whole point of the nowritebuffer path is to give us something simpler
> > but with matching behaviour of the write buffer path, to aid in
> > isolating bugs, so that only makes sense if they actually do behave the
> > same way.
> > 
> 
> I take it your follow up reply (re: the ordering patch) invalidates the
> thought around bch2_trans_update_ordered(), but this is useful context
> on !writebuffer nonetheless. I'll see if I can just bypass these
> existing backpointer errors and narrow further in on the actual missing
> bp issue...

Yeah, it turned out the recent trigger ordering patches were definitely
to blame. With those patches yanked, I was able to run the
merge_torture_flakey test for ~24 hours in
backpointers_no_use_write_buffer mode - and with the write buffer on,
we're not hitting the "backpointer not found" errors as often as we were
before.

So we probably need to think a bit more about what happens differently
when the write buffer is in use; we're doing exactly the same updates,
but flushing them to the btree is a bit delayed and the ordering is
different. I think we need to hone in on that.
