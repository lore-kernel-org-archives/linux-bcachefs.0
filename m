Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B323C05027
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjBBUD6 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 15:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjBBUD5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 15:03:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A1B22A22
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 12:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675368191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXBjVgslfKTMDIK/AsaWIbA7jEM6olE9cS4ChBEFQ+g=;
        b=aWhs2Z+UeyN0AHoaOJkF25LTyo4aWwm5LxUKMFgeVMdlMFbeznomVG2YkPI5ZD+hbfGCNT
        bCOj3hmvJfXZDqtakT0cMT/JfYDeJNohK8D3hNlBSHcQsJZ8PNhd9zSwA6eU9CA0GkplzZ
        /CFDNyfwest6Ugb/WffojFhvy0VhZEs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-593-yghfv_CPNCqQyOGuOj_z8A-1; Thu, 02 Feb 2023 15:03:09 -0500
X-MC-Unique: yghfv_CPNCqQyOGuOj_z8A-1
Received: by mail-qk1-f199.google.com with SMTP id j29-20020a05620a001d00b00724fd33cb3eso1981890qki.14
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Feb 2023 12:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXBjVgslfKTMDIK/AsaWIbA7jEM6olE9cS4ChBEFQ+g=;
        b=64knwUtKLbwnrSHMiwueWSRzbhV92jVhgOp8mh6TbS0RNSvg917oDqbkKV9B9pgmuM
         feQWfyppEsOT9m7cD2wLchl15YRgXrhp2vkNuSNzga2rokw3dw9SdxUETZf7kJDHIGdp
         RPTD7b7PljbCuLgaA7Y9OV/4+KqQj3/hrDQiRuCCvxVR0P5VzVh40kOVbKSiGrOit5Ih
         RjGkd9yAxb9l+zYC2ohI3N8Qr868qAIzQ9+8fOOHla4eshjAQrFD40K6VqBWqLFo6MdZ
         yPvGdayriCRazWu/hc6c9kk44MEtUvZAFAkbfFcXebmYu5qe6EO6xTBrfMxQg31cw3Z5
         rfpg==
X-Gm-Message-State: AO0yUKW5RuacPVI9fCZwYvzLnu76MToUTIITJCGJxhg+EbL7yJvVhQrm
        pICjKp6VmxXl1otlEXp8wLTEG2i5eOmcmBGlsveVhNlE+BJT9l4IRjAG2eVFXiaFGklVzI5dihG
        BZzxh4rkMicq0B+W5Ctt9h1Iyt2w=
X-Received: by 2002:ac8:7f47:0:b0:3b9:a532:a1d with SMTP id g7-20020ac87f47000000b003b9a5320a1dmr13673269qtk.58.1675368189195;
        Thu, 02 Feb 2023 12:03:09 -0800 (PST)
X-Google-Smtp-Source: AK7set+S9aJM5Ma2gvKYs3wahfArgzovZcvezM4JzB4xDax4HrQ5OZX4rbfbpR56S+YxyBvoHFE2pg==
X-Received: by 2002:ac8:7f47:0:b0:3b9:a532:a1d with SMTP id g7-20020ac87f47000000b003b9a5320a1dmr13673226qtk.58.1675368188854;
        Thu, 02 Feb 2023 12:03:08 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id 22-20020ac85616000000b003b630456b8fsm142566qtr.89.2023.02.02.12.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 12:03:08 -0800 (PST)
Date:   Thu, 2 Feb 2023 15:04:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     dchinner@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: Freezing (was: Re: fstests generic/441 -- occasional bcachefs
 failure)
Message-ID: <Y9wXRmo6zYAQCOx1@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9p4ihwzFs0OP6to@moria.home.lan>
 <Y9vbv7TFyu+stccD@bfoster>
 <Y9vuQHtYOhAOqPF1@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vuQHtYOhAOqPF1@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 02, 2023 at 12:09:20PM -0500, Kent Overstreet wrote:
> On Thu, Feb 02, 2023 at 10:50:23AM -0500, Brian Foster wrote:
> > I don't have a public repo atm but I've posted the patch if you have
> > somewhere to land it for CI testing..? It survived my regression tests
> > so far, FWIW. (I also had posted that random cleanup patch a bit ago if
> > you hadn't noticed..).
> 
> Must have missed it, sorry. I can host a git repo for you on my server,
> or github works fine - I generally prefer git repo links, git am is
> always a bit of a hassle.
> 

Sounds good.

> > Is there a reporting dashboard or something available for the test
> > infrastruture for bcachefs?
> 
> https://evilpiepirate.org/~testdashboard/ci
> 
> I've got a small server farm that watches git branches and runs the
> entire test suite on every commit starting from the recent - once you've
> got a git branch up I'll add yours to the list it watches.
> 

Cool. I see that it reproduces the generic/441 failure.

I need to use GitLab for other things so I managed to create a project
cloning your repo there and pushed a testing branch with both of those
commits. I think it should be accessible here:

https://gitlab.com/bfoster2/bcachefs.git bf-bcachefs-testing

... but let me know if it doesn't work.

> You'll probably want to get acquainted with ktest, it's what both the CI
> uses for running tests, and what we use for local development:
> 
> https://evilpiepirate.org/git/ktest.git
> 

I'll check it out, thanks!

Brian

> > > Freeze definitely needs to happen. It's been _ages_ since I was looking
> > > at it so I couldn't say offhand where we'd need to start, but if you're
> > > interested I'd be happy to look at what it'd take.
> > > 
> > 
> > Yeah, that would be interesting. Thanks.
> 
> Maybe we could get Dave to give us a brief rundown of freezing? It's
> been ages since I was thinking about that and it's all fallen out of my
> brain, but Dave was the one who was able to explain it to me before :)
> 
> I think getting freezing done would up our test coverage by a good bit,
> so it's worth prioritizing.
> 
> > FWIW, I was reading through the "Journaling" and "Sequential
> > consistency" sections of the architecture documentation [1]. It's
> > possible I just misinterpreted some wording.
> > 
> > [1] https://bcachefs.org/Architecture/#Journaling
> 
> *nod* Thanks for the link, that's old but not ancient - that's from when
> the journal seq blacklist mechanism was how we did sequential
> consistency.
> 
> Whenever I find the time to work on documentation again, I want to move
> more stuff (including that sort of high level developer documentation)
> to the principles of operation: https://bcachefs.org/bcachefs-principles-of-operation.pdf
> 
> Right now it's more end user documentation, but last I was working on
> that I was starting to add documentation centered around on disk data
> structures - i.e. btrees and key types, and it seemed to be going in a
> useful direction.
> 

