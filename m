Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BD6CA0FFA
	for <linux-bcachefs@archiver.kernel.org>; Tue,  5 Sep 2023 16:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbjIEQey (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354566AbjIEMm2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 5 Sep 2023 08:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3241C1A8
        for <linux-bcachefs@vger.kernel.org>; Tue,  5 Sep 2023 05:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693917698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4HkI6qDnp2Lo5r99cQMtWqZDb1zArsyD3jPQLKP5Pf4=;
        b=ImG/sxUknBJhry7OuT8L+gVs99J+w4nXZAwmNHTcq8ZrmrUDy+K5C0NEQC/p35ZjUEe65K
        st//Gf27e1iG7BWMLmVFJ2aNfPkrhaiH6pt7YtX9QlQLJy+/1Cor62sKxxcWQ/fV39BrEF
        SolW0EvS3EV7GWoLwkCFh2gfoqxJ+jk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-lofxuhi8Nk6EYCqy30M3DQ-1; Tue, 05 Sep 2023 08:41:36 -0400
X-MC-Unique: lofxuhi8Nk6EYCqy30M3DQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-76ef03effdcso291668585a.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Sep 2023 05:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693917696; x=1694522496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HkI6qDnp2Lo5r99cQMtWqZDb1zArsyD3jPQLKP5Pf4=;
        b=Hjc/FP27Qao/0Mru/I7dRmgylGhY9iuZ4peR288gSB6+NWiJS5snsdpzGi3juxVKAQ
         sknbkRygRRw1plmagoAzVmraO8qTsxW+z3gCv4s/88536PU0mgDkjhLZgHs3h/XDOU4E
         JqNQ8A45JQgqh/tuxWqtiJU6OwTPLZHJ4pcW6MWW+ZW9wJO9gOAvELsZ4NaqKX/qIbSf
         bQ82xdw5R3x8y0b8YarNN9p6Hs2y+Q4iKOTTbR+Zesmqb97usU1XzF3VLpdt5uj+wrxt
         BSyqyu4wg66tOhQi6YlQEUJ9+hmSYrbuAU5B5TkQpx5saKktsEJ82Rzc+LE0rwO43g5J
         DX0Q==
X-Gm-Message-State: AOJu0Yy1HvhgACFdFWtEO4ORz5M9O6SIvWkd929ELBRUKbqkqrQJ3gtp
        w1W1/DUcLQSRthssnJJICwug88kXKxERhIZdJa0AqzOTdnPx/tdeZR8b8rXThtVXNgWzZC18TWG
        w4zj/C51Z47VZj8bd5pAY7Xq9szrMk4F3fiw=
X-Received: by 2002:a05:620a:2846:b0:76c:a9a1:a318 with SMTP id h6-20020a05620a284600b0076ca9a1a318mr16472904qkp.6.1693917696195;
        Tue, 05 Sep 2023 05:41:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFovs19eyCmDPiazThEkxV2uCI8n0JnaabVtNg4VPo9sHhsAlgna8JTYdaMH1jUttFHtpvlA==
X-Received: by 2002:a05:620a:2846:b0:76c:a9a1:a318 with SMTP id h6-20020a05620a284600b0076ca9a1a318mr16472893qkp.6.1693917695966;
        Tue, 05 Sep 2023 05:41:35 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id h12-20020a37c44c000000b0076d0312b8basm3981848qkm.131.2023.09.05.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 05:41:35 -0700 (PDT)
Date:   Tue, 5 Sep 2023 08:41:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/3] bcachefs: prepare journal buf put to handle pin put
Message-ID: <ZPciCK3DVinKnedn@bfoster>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-3-bfoster@redhat.com>
 <20230903210904.3rf7khzkz2k3tkdx@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230903210904.3rf7khzkz2k3tkdx@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Sep 03, 2023 at 05:09:04PM -0400, Kent Overstreet wrote:
> On Thu, Aug 31, 2023 at 07:07:33AM -0400, Brian Foster wrote:
> > bcachefs freeze testing has uncovered some raciness between journal
> > entry open/close and pin list reference count management. The
> > details of the problem are described in a separate patch. In
> > preparation for the associated fix, refactor the journal buffer put
> > path a bit to allow it to eventually handle dropping the pin list
> > reference currently held by an open journal entry. Open code the
> > journal write dispatch since it is essentially a single line and
> > instead factor out the journal state update to be reused, consistent
> > with other journal state update helpers. No functional changes in
> > this patch.
> 
> So, I don't want to take this patch as is because even though
> __bch2_journal_buf_put() is small, you're putting it into an inline
> fastpath that we want to be as small and fast as possible - the main
> transaction commit path.
> 

Can you elaborate on what you mean here? ISTM all this patch does is
replace a function call to __bch2_journal_buf_put() that already
exists..

Brian

> journal_state_buf_put() is fine though, happy to take that part of the
> patch.
> 
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/bcachefs/journal.c |  9 ---------
> >  fs/bcachefs/journal.h | 22 +++++++++++++++++-----
> >  2 files changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> > index 055920c26da6..76ebcdb3e3b4 100644
> > --- a/fs/bcachefs/journal.c
> > +++ b/fs/bcachefs/journal.c
> > @@ -132,15 +132,6 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
> >  	return stuck;
> >  }
> >  
> > -/* journal entry close/open: */
> > -
> > -void __bch2_journal_buf_put(struct journal *j)
> > -{
> > -	struct bch_fs *c = container_of(j, struct bch_fs, journal);
> > -
> > -	closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
> > -}
> > -
> >  /*
> >   * Returns true if journal entry is now closed:
> >   *
> > diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> > index 008a2e25a4fa..c7a31da077c9 100644
> > --- a/fs/bcachefs/journal.h
> > +++ b/fs/bcachefs/journal.h
> > @@ -252,9 +252,10 @@ static inline bool journal_entry_empty(struct jset *j)
> >  	return true;
> >  }
> >  
> > -void __bch2_journal_buf_put(struct journal *);
> > -
> > -static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
> > +/*
> > + * Drop reference on a buffer index and return true if the count has hit zero.
> > + */
> > +static inline union journal_res_state journal_state_buf_put(struct journal *j, unsigned idx)
> >  {
> >  	union journal_res_state s;
> >  
> > @@ -264,9 +265,20 @@ static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
> >  				    .buf2_count = idx == 2,
> >  				    .buf3_count = idx == 3,
> >  				    }).v, &j->reservations.counter);
> > +	return s;
> > +}
> >  
> > -	if (!journal_state_count(s, idx) && idx == s.unwritten_idx)
> > -		__bch2_journal_buf_put(j);
> > +void bch2_journal_write(struct closure *);
> > +static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
> > +{
> > +	struct bch_fs *c = container_of(j, struct bch_fs, journal);
> > +	union journal_res_state s;
> > +
> > +	s = journal_state_buf_put(j, idx);
> > +	if (!journal_state_count(s, idx)) {
> > +		if (idx == s.unwritten_idx)
> > +			closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
> > +	}
> >  }
> >  
> >  /*
> > -- 
> > 2.41.0
> > 
> 

