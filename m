Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687E1EE3F0C
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 18:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjILSzO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjILSzO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Sep 2023 14:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FA19106
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 11:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694544865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ytn/9L2VrMI/poRjrtjXvPWimIKwcE9zMcX3enM9jfU=;
        b=QdkMNSol8o/qmuXa5CnM+B9p+LjrHvKYWXKFiS7xfptxCAPkkvb6KWj75uFMXERWoNJWpK
        UQVooO05uF633yRJmMH/2I/T4TD2XvbcRIGAlguNAacK8T4YsVjZ+TZAx1AUzzfrJN0Zah
        IhlBYGeZgULmTJwi42zLoeQo3AqOezk=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-uZvwDciQMs-IRI_gxrKUow-1; Tue, 12 Sep 2023 14:54:24 -0400
X-MC-Unique: uZvwDciQMs-IRI_gxrKUow-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-495bdbe0d25so920203e0c.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 11:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694544863; x=1695149663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ytn/9L2VrMI/poRjrtjXvPWimIKwcE9zMcX3enM9jfU=;
        b=Oknz88x7Z4LSSVh7WhC26dpW9laxGaFi8CkI+YUZs2IsW7rrfbaqbejtiw11w/uuHk
         QjJpBpMuXuxTSPte03y2PpI5hY0pkcp+qu9/j0f4b3EnfZ436R5VQMhcMMUEyhGO4JVv
         amP9spWNFUsTHDUx2h+vJQZuB4kZGmsAXUHdcPQOfCSQ/VOiFG2YAf7T6kij8L+6H8h/
         DxE5+sZtGIM80LELzT558MZJXk5DooBkuzorppZD4vsyZCMwdIKmf82/ARWHnNz+y4dz
         WmnYtmPaDDb/15wlmZ40WHDeXCJ6+MJTTDbycTEOhYIV68amPRxh4TbKwhpQ0QFa5Z/z
         +rpw==
X-Gm-Message-State: AOJu0Yym4BiwpQ6Ekvo1zqnLZm9Ar/0NUpDTSu8/gEOv9knj4zUAYp/N
        cM18oJ5dX6meFDAT1hOjJneH5ch98uIHR9G3uzK2At0bZXbrY4PJKRtgNfzvspEKZXHZ4Q03ExB
        fUKwS9oRdC1oSqKW+b/BWJYPNx0mkHOq6rFM=
X-Received: by 2002:a1f:d3c4:0:b0:48d:29ef:1764 with SMTP id k187-20020a1fd3c4000000b0048d29ef1764mr520267vkg.9.1694544863062;
        Tue, 12 Sep 2023 11:54:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRb6Xz4DYv75Y7NyCnsThESA9/0MXwDQcNgngo78q9JYecJUGqjxlKUWj9sWBjREi8Tz6R9w==
X-Received: by 2002:a1f:d3c4:0:b0:48d:29ef:1764 with SMTP id k187-20020a1fd3c4000000b0048d29ef1764mr520261vkg.9.1694544862730;
        Tue, 12 Sep 2023 11:54:22 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id u11-20020a0c8dcb000000b0063cdbe739f0sm3921585qvb.71.2023.09.12.11.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:54:22 -0700 (PDT)
Date:   Tue, 12 Sep 2023 14:54:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <ZQCz6qYUdWdgVsGH@bfoster>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
 <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
 <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
 <ZPcmFqnjouET8rqa@bfoster>
 <ZPjODscrfsdXcgPf@bfoster>
 <20230910020304.bhoqfrsq2ez3ngri@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910020304.bhoqfrsq2ez3ngri@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Sep 09, 2023 at 10:03:04PM -0400, Kent Overstreet wrote:
> On Wed, Sep 06, 2023 at 03:07:58PM -0400, Brian Foster wrote:
> > On Tue, Sep 05, 2023 at 08:59:02AM -0400, Brian Foster wrote:
> > > On Sun, Sep 03, 2023 at 10:29:28PM -0400, Kent Overstreet wrote:
> > > > On Sun, Sep 03, 2023 at 05:18:12PM -0400, Kent Overstreet wrote:
> > > > > On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> > > > > > bcachefs freeze testing via fstests generic/390 occasionally
> > > > > > reproduces the following BUG from bch2_fs_read_only():
> > > > > > 
> > > > > >   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
> > > > >
> > > > > Your fix makes sense, but I wonder if it might be simpler and better to
> > > > > fix this in bch2_journal_reclaim_fast().
> > ...
> > > 
> > > FWIW, one thing I disliked about the original patch was the need to
> > > mostly duplicate the buf put helper due to the locking context quirk. I
> > > was trying to avoid that, but I ran out of ideas before I wanted to move
> > > on actually fixing the bug. My preference would be to address the
> > > reference counting issue as is (to preserve design simplicity), and then
> > > maybe think a bit harder about cleaning up the res put implementation if
> > > the primary concern is that we feel like this starts to make things a
> > > bit convoluted..
> > > 
> > 
> > Another thought that comes to mind is to perhaps allow the journal_res
> > to hold a reference to the pin fifo for the associated seq.. The idea
> > would be we could continue to hold a reference during the open/close
> > journal buffer lifecycle, but a res of the same seq would acquire an
> > additional reference as well to keep the tail from popping before a
> > transaction can actually set a pin (i.e. essentially parallel to the
> > buffer reference).
> 
> Yeah that would probably be cleanest - but it would be much too heavy.
> 

I'm curious how so? Additional atomics? 

If so, we could also consider something that allows a pin list ref on
the reservation to simply transfer to a pin set via the transaction.
That might not add any new overhead over the current code, but would
require some plumbing.

> > In a sense the behavior in this patch is kind of an optimization of that
> > approach, but I think implementing it directly would eliminate the need
> > to mostly duplicate the put helper, perhaps making things a bit more
> > natural. We could still fall into bch2_journal_reclaim_fast() from
> > res_put(), but now only for cases where the reservation outlives the
> > active journal buffer (due to a journal flush or whatever). That also
> > still addresses the race by properly using the reference count. I'd
> > probably have to try it to be sure I'm not missing something, but...
> > thoughts?
> 
> We can do your approach if that's what you feel is going to be cleanest,
> but if we go that way here's my two main concerns:
> 

Ok..

FWIW, it's not so much that I think it's the cleanest (I agree that the
variant discussed above probably ends up cleaner code-wise), but rather
that it provides sufficient confidence we won't just have to revisit the
same underlying problem the next time some bit of code assumes that an
outstanding reservation guarantees a usable pin list.

>  - we can't put more slowpath code into the inline fastpath, remember
>    this is all inlined into the main __bch2_trans_commit() path
> 

Sure. I missed that closure_call() was itself inlined. I think that is
what initially confused me wrt to the feedback on patch 2. I'll try to
keep that helper external and perhaps just rename it.

>  - your approach (the optimized version) means there's a new state
>    transition where we do work, i.e. when journal_state_count() hits 0.
> 

Indeed.

>    So we have to make sure that that refcount isn't hitting 0 multiple
>    times. The appropriate assertion already exists in
>    journal_res_get_fast() - for a refcount to hit 0 multiple times it
>    must leave 0 while in use, and we check for that.
> 
>    Let's just add a comment by that EBUG_ON(!journal_state_count(new,
>    new.idx)) line indicating why it's now important.
> 

Sounds reasonable. I'll try to come up with something. Thanks.

Brian

