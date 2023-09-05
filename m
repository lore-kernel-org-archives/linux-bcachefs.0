Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE24CA0FE2
	for <linux-bcachefs@archiver.kernel.org>; Tue,  5 Sep 2023 16:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344804AbjIEQeu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354623AbjIEM7s (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 5 Sep 2023 08:59:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9540EE9
        for <linux-bcachefs@vger.kernel.org>; Tue,  5 Sep 2023 05:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693918737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bpoF3Aqb38wku5H0lq8D7rim97zEjeKYdqUMf46XFVY=;
        b=dm5tSYRfFXQ4h8W1jxo5byhHHCV6OFtxrs4v2hbjkIfAkxyRErrpXv8KiuP6ieZLQKzANj
        pP7PoNuSkAigTwkOCBDh+OrFrHJ04HPOjKnUqBrzN+OV1Qz5Vhl4rtmIcPL9VXjZT9IzNi
        ZfGMaaMre1CS/P1Mf/noq35swN8tlRQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-E3OZ3zyDO9C2-ANOi4U_cQ-1; Tue, 05 Sep 2023 08:58:56 -0400
X-MC-Unique: E3OZ3zyDO9C2-ANOi4U_cQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-76ef87c5b76so220249585a.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Sep 2023 05:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693918735; x=1694523535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpoF3Aqb38wku5H0lq8D7rim97zEjeKYdqUMf46XFVY=;
        b=YsourOHTUkkHhsg8Uz14KZk+lgsxSz8G62SW2cEq24IOwl9HPqX0lsYkE8NKz/Xl9L
         H8u6v/pg1mA3002eDwAY2FPGGOgRVWtVYMvALnm7deVzTlnSbacR5FETZo6JzHQD8G29
         wqtqBi5VRp7c4W00U7DJyQG7q1DefM5YQ+LdUg7szmGttC/4slFkLxtqAg3mtOTUzLlW
         UQFq8+wxcSsfN7RYEYIngpHE+3+9zc28FU/pLmucseffHwOFvTnJY+Nk02w0LD8DjAzo
         VpAzUcjULAws/XgpowW5GBU1TKbjKH1Lvvkpnazu4ytlKLPrYoZdqFMJ9WYX1lOk7vm7
         FNIg==
X-Gm-Message-State: AOJu0Yz54C9Er3BlcR/oMWyWH3zhnTfYvF9rxsnji458G8212jBjfTy5
        E9PmGUnfiA1N440f/NdNqBDaApCzBvR4eUB+kVrZwS7a6ZqK9BrlsiTKpNXcC96NCbjFrsSgO9X
        y2dHtk1j59hmXn98SwXwaoPojPDtu4xmMZFs=
X-Received: by 2002:a05:620a:4250:b0:76c:c055:aa32 with SMTP id w16-20020a05620a425000b0076cc055aa32mr12884577qko.24.1693918735171;
        Tue, 05 Sep 2023 05:58:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPxWsRYHdoDfMCWo6V4LdUwumDTEAJe13OXUSD4Q/xLWbUMLqua1shWnTs2HJYr6s1jdvsRg==
X-Received: by 2002:a05:620a:4250:b0:76c:c055:aa32 with SMTP id w16-20020a05620a425000b0076cc055aa32mr12884562qko.24.1693918734924;
        Tue, 05 Sep 2023 05:58:54 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id y21-20020a37e315000000b0076827ce13f6sm4051787qki.10.2023.09.05.05.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 05:58:54 -0700 (PDT)
Date:   Tue, 5 Sep 2023 08:59:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <ZPcmFqnjouET8rqa@bfoster>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
 <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
 <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Sep 03, 2023 at 10:29:28PM -0400, Kent Overstreet wrote:
> On Sun, Sep 03, 2023 at 05:18:12PM -0400, Kent Overstreet wrote:
> > On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> > > bcachefs freeze testing via fstests generic/390 occasionally
> > > reproduces the following BUG from bch2_fs_read_only():
> > > 
> > >   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
> >
> > Your fix makes sense, but I wonder if it might be simpler and better to
> > fix this in bch2_journal_reclaim_fast().
> 
> What do you think of this fix?
> 
> diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
> index 10e1860dad..021c56ac67 100644
> --- a/fs/bcachefs/journal_reclaim.c
> +++ b/fs/bcachefs/journal_reclaim.c
> @@ -303,6 +303,12 @@ static void bch2_journal_reclaim_fast(struct journal *j)
>  	 */
>  	while (!fifo_empty(&j->pin) &&
>  	       !atomic_read(&fifo_peek_front(&j->pin).count)) {
> +		u64 seq = journal_last_seq(j);
> +
> +		if (seq > j->seq_ondisk &&
> +		    journal_state_count(j->reservations, seq & JOURNAL_BUF_MASK))
> +			break;
> +
>  		fifo_pop(&j->pin, temp);
>  		popped = true;
>  	}
> 

So my first reaction once I figured out what was going on was to
consider something like this, because it seemed like the issue was
premature release of the journal tail. After digging into that a bit it
didn't quite feel right, which is what had me digging further into why
the ref count was zero on a seq with outstanding reservation.

I think I see what the above is doing, but I really don't see how this
is simplified in any way. Maybe the code changes are slightly smaller,
but IMO the bigger picture is far easier to reason about when the
reference counts are properly honored. I.e., the outstanding
reservations hold references on the journal buffer associated with the
seq, and the active journal buffer holds a reference on the pin fifo.

Conversely, the above strikes me as unnecessarily clever based on the
fact that just to review it I need to grok behavior in several different
contexts (res and seq management, on disk seq updates, etc.) to convince
myself whether it's safe, and even then I'm not totally sure I have
enough context to say whether the state count check can't ever break on
something like a reused (for a new seq) journal buffer. Heh, the more I
think about that the more I have to ask: why not just make the reference
count work? ;P

FWIW, one thing I disliked about the original patch was the need to
mostly duplicate the buf put helper due to the locking context quirk. I
was trying to avoid that, but I ran out of ideas before I wanted to move
on actually fixing the bug. My preference would be to address the
reference counting issue as is (to preserve design simplicity), and then
maybe think a bit harder about cleaning up the res put implementation if
the primary concern is that we feel like this starts to make things a
bit convoluted..

Brian

