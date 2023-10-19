Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE18CDB482
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 17:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjJSR0h (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 13:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjJSR0g (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 13:26:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD67BCF
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 10:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697736347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J15DD9/6Bm6gtLdv0yq1wwMKAVeCJHnKU0/uiY8Yb4g=;
        b=FRTjce7QQYcPyvhPEz8eqnGhsXaahf8gUeTjPbIwfIvUmvK1XmUGR2zjzBvNA8dLSNLEHT
        nr7lJ844KMwpKePbHHxnjx1WzJ+b+zDMWtR4FDthvz9vbFgclC8GTKK28ftL7Nf2uYWiZL
        +WtEpqp5scEnwU7kYgPbCh9jauZk+6E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-BcK39X3fM-S49Zj_Owrhrw-1; Thu, 19 Oct 2023 13:25:30 -0400
X-MC-Unique: BcK39X3fM-S49Zj_Owrhrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E983E10201F4;
        Thu, 19 Oct 2023 17:25:27 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA2A225C9;
        Thu, 19 Oct 2023 17:25:27 +0000 (UTC)
Date:   Thu, 19 Oct 2023 13:25:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] bcachefs (early?) bucket allocator raciness
Message-ID: <ZTFmomUJBoVfqUHs@bfoster>
References: <ZTExFP9G1fUIUgVZ@bfoster>
 <20231019155211.ir433bgkuyuh6cqc@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019155211.ir433bgkuyuh6cqc@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 11:52:11AM -0400, Kent Overstreet wrote:
> On Thu, Oct 19, 2023 at 09:37:24AM -0400, Brian Foster wrote:
> > Hi Kent, All,
> > 
> > I recently observed a data corruption problem that is related to the
> > recently discovered issue of mounted fs' running with the early bucket
> > allocator instead of the freelist allocator. The immediate failure is
> > generic/113 producing various splats, the most common of which is a
> > duplicate backpointer issue. generic/113 is primarily an aio/dio stress
> > test.
> > 
> > I eventually tracked this down to an actual duplicate bucket allocation
> > in the early bucket allocator code. The race generally looks as follows:
> > 
> > - Task 1 lands in bch2_bucket_alloc_early(), selects key A from the
> >   alloc btree, and then schedules (perhaps due to freelist_lock).
> > 
> > - Task 2 runs through the same alloc path and selects the same key K,
> >   but proceeds to open the associated bucket, alloc/write to it,
> >   complete the I/O and release the bucket (removing it from the hash).
> > 
> > - Task 1 continues with alloc key K. bch2_bucket_is_open() returns false
> >   because the previously opened bucket has been removed from the hash
> >   list. Therefore task 1 opens a new bucket for what is now no longer free
> >   space and uses it for the its associated write operation.
> 
> This shouldn't be possible because task 1 is holding the alloc key
> locked, and task 2 has to update that same alloc key before releasing
> the open bucket.
> 
> Except perhaps not - perhaps this is a key cache coherency issue?
> 
> We're not using a BTREE_ITER_CACHED iterator, because we're scanning and
> we can't scan with key cache iterators. It's still supposed to be
> coherent with the key cache; bch2_btree_iter_peek_slot() ->
> btree_trans_peek_key_cache() checks if a key exists in the key cache and
> returns that key instead of the key in the btree if it exists.
> 
> But it doesn't return with that slot locked in the key cache locked if
> the key didn't exist in the key cache. Oops.
> 

Ah, interesting. I wasn't aware of the lower level locking involved
here. This sounds like a plausible theory wrt key cache, but I'll have
to dig more into it to grok the locking. Thanks for the additional
context.

Brian

> So we're going to need to keep an eye out for this issue occuring
> elsewhere, and maybe come up with a real fix in the btree iterator code:
> looking up a key in a cached btree without BTREE_ITER_CACHED _does_
> return the correct key at that particular point in time, but it does
> _not_ necessarily keep it locked for the duration of the transaction.
> 
> For now, we can fix this locally in bch2_bucket_alloc_early() with a
> second BTREE_ITER_CACHED iterator - run some tests with freespace
> initialization disabled, confirm that that's the issue, then go from
> there.
> 

