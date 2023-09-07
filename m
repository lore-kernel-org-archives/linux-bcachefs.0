Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8EEEC8759
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Sep 2023 20:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbjIGUh3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 7 Sep 2023 16:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjIGUh2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 7 Sep 2023 16:37:28 -0400
Received: from out-217.mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0C51BCB
        for <linux-bcachefs@vger.kernel.org>; Thu,  7 Sep 2023 13:37:24 -0700 (PDT)
Date:   Thu, 7 Sep 2023 16:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694119042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GA5nMAiT0G3MNbjKaeMA1EJ5Uv5kOOsTnwa98dAPhfY=;
        b=c3Ax82zhV4MudXHm4wVsI48RLeKX0lwf3ytp972lSFHu73dAii7XDeTiBCan4Wvf3xTSJu
        RmF9diKKx8MoXna6TV4EhbGm8afZ8abc7vVNMMy0+RB5Kb8UEec4VjP4tpSC9Bhjl74y7C
        Yf4Mewaobkp/r8LX6jRpVgBah+KrruA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230907203718.upkukiylhbmu5wjh@moria.home.lan>
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 06, 2023 at 12:36:18PM -0700, Linus Torvalds wrote:
> So I'm starting to look at this because I have most other pull
> requests done, and while I realize there's no universal support for it
> I suspect any further changes are better done in-tree. The out-of-tree
> thing has been done.
> 
> However, while I'll continue to look at it in this form, I just
> realized that it's completely unacceptable for one very obvious
> reason:
> 
> On Sat, 2 Sept 2023 at 20:26, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> >   https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
> 
> No way am I pulling that without a signed tag and a pgp key with a
> chain of trust. You've been around for long enough that having such a
> key shouldn't be a problem for you, so make it happen.
> 
> There are a few other issues that I have with this, and Christoph did
> mention a big one: it's not been in linux-next. I don't know why I
> thought it had been, it's just such an obvious thing for any new "I
> want this merged upstream" tree.
> 
> So these kinds of "I'll just ignore _all_ basic rules" kinds of issues
> do annoy me.
> 
> I need to know that you understand that if you actually want this
> upstream, you need to work with upstream.
> 
> That very much means *NOT* continuing this "I'll just do it my way".
> You need to show that you can work with others, that you can work
> within the framework of upstream, and that not every single thread you
> get into becomes an argument.
> 
> This, btw, is not negotiable.  If you feel uncomfortable with that
> basic notion, you had better just continue doing development outside
> the main kernel tree for another decade.
> 
> The fact that I only now notice that you never submitted this to
> linux-next is obviously on me. My bad.
> 
> But at the same time it worries me that it might be a sign of you just
> thinking that your way is special.

Linus, I specifically asked you about linux-next in the offlist pre-pull
request thread back in May. It would have been nice if I could've gotten
an answer back then; instead, I'm only getting a definitive answer on
that now.

That question has even come up in meetings and no one could give a
definitive answer; the suggestion was to email you and CC people and
ask, which is precisely what I did.

Sigh.

Now I'm wondering what other surprises I'm going to get the next time
around...
