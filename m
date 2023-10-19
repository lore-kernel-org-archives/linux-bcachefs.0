Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6E8CDB465
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjJSRXM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjJSRXL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 13:23:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EA712F
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 10:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697736144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXJ9JuL3Dno6k0U4BX1kjtohTG0QgN9f8PG72sEviIU=;
        b=I9j3tSRtlWY2jyOGYfmcbT+z0UmgIOM9hhwlxLSXbi+oFKPzj82doqapM5G64i2R4jVm3q
        xmdZU19v/rsrB+rg4LrSfBCAFFVttPZLLSTZWG0LHzShM+84B+qTV9xaTsTX8FLU3JFdLG
        l7VlJKzVOMaAIHEaOKKpqamQ+WMHAz4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-L2Be-JN4M7y4MzTLdXoAtg-1; Thu, 19 Oct 2023 13:22:22 -0400
X-MC-Unique: L2Be-JN4M7y4MzTLdXoAtg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E90F28E6D05;
        Thu, 19 Oct 2023 17:22:21 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9E4A492BEE;
        Thu, 19 Oct 2023 17:22:21 +0000 (UTC)
Date:   Thu, 19 Oct 2023 13:22:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: update alloc cursor in early bucket allocator
Message-ID: <ZTFl3jJJi2CoDdJB@bfoster>
References: <20231019132746.279256-1-bfoster@redhat.com>
 <20231019153019.jl73n6ipif7zwc5b@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019153019.jl73n6ipif7zwc5b@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 11:30:19AM -0400, Kent Overstreet wrote:
> On Thu, Oct 19, 2023 at 09:27:46AM -0400, Brian Foster wrote:
> > A recent bug report uncovered a scenario where a filesystem never
> > runs with freespace_initialized, and therefore the user observes
> > significantly degraded write performance by virtue of running the
> > early bucket allocator. The associated bug aside, the primary cause
> > of the performance drop in this particular instance is that the
> > early bucket allocator does not update the allocation cursor. This
> > means that every allocation walks the alloc btree from the first
> > bucket of the associated device looking for a bucket marked as free
> > space.
> > 
> > Update the early allocator code to set the alloc cursor to the
> > prospectively allocated bucket, similar to how the freelist
> > allocator behaves. This improves performance of the early bucket
> > allocator dramatically (even though it should be bypassed in favor
> > of the freelist allocator in most cases).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > cshepherd on #bcache originally reported the early bucket allocator
> > problem and helped chase it down to what looks like a members_v2
> > regression. I believe he was planning to post a patch for that one.
> > 
> > Brian
> > 
> >  fs/bcachefs/alloc_foreground.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
> > index 3bc4abd3d7d5..be3fc0f38c79 100644
> > --- a/fs/bcachefs/alloc_foreground.c
> > +++ b/fs/bcachefs/alloc_foreground.c
> > @@ -431,7 +431,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
> >  	}
> >  	bch2_trans_iter_exit(trans, &iter);
> >  
> > -	ca->alloc_cursor = alloc_cursor;
> > +	ca->alloc_cursor = IS_ERR_OR_NULL(ob) ? alloc_cursor : ob->bucket;
> 
> Oh, this code is broken. The local alloc_cursor never gets updated, and
> it needs to for where we check if we need to loop around.
> 

Ah, good point.

> The proper fix would be to add
> 
>   alloc_cursor = iter.pos.offset;
> 
> before the line you changed
> 

Thanks. I'll give that a whirl.

BTW, should this code be protected from no free space situations at a
higher level, or should we consider a max retry count or something? I
want to be cautious about things like prospective livelocks
(particularly if this path is less common) if this retry was effectively
dead code due to not updating alloc_cursor.

Brian

