Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E32C83F2D
	for <linux-bcachefs@archiver.kernel.org>; Sun,  3 Sep 2023 21:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348222AbjICVJO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 3 Sep 2023 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjICVJN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 3 Sep 2023 17:09:13 -0400
Received: from out-214.mta0.migadu.com (out-214.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62C7B6
        for <linux-bcachefs@vger.kernel.org>; Sun,  3 Sep 2023 14:09:09 -0700 (PDT)
Date:   Sun, 3 Sep 2023 17:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693775347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p6IlPWFez+ahhP1rzU12e5bhuoULoJo03pSWthoC1as=;
        b=XuCoxAiWOCilp4CC7IWehpDFqxmfgRf4nESXihBUL3Jrk6mYFIqdAXxPwyX89IOcUBIFSC
        3qpCACVIPSV3N4HSFUKrZMp0JGYKKT8DTJ7douxAHoKZ8b0WPvMOcXq0dyXAu07G7aux2i
        C6I7CruuYhRXknmIWZkhazJJrETGujQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/3] bcachefs: prepare journal buf put to handle pin put
Message-ID: <20230903210904.3rf7khzkz2k3tkdx@moria.home.lan>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110734.787212-3-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Aug 31, 2023 at 07:07:33AM -0400, Brian Foster wrote:
> bcachefs freeze testing has uncovered some raciness between journal
> entry open/close and pin list reference count management. The
> details of the problem are described in a separate patch. In
> preparation for the associated fix, refactor the journal buffer put
> path a bit to allow it to eventually handle dropping the pin list
> reference currently held by an open journal entry. Open code the
> journal write dispatch since it is essentially a single line and
> instead factor out the journal state update to be reused, consistent
> with other journal state update helpers. No functional changes in
> this patch.

So, I don't want to take this patch as is because even though
__bch2_journal_buf_put() is small, you're putting it into an inline
fastpath that we want to be as small and fast as possible - the main
transaction commit path.

journal_state_buf_put() is fine though, happy to take that part of the
patch.

> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/bcachefs/journal.c |  9 ---------
>  fs/bcachefs/journal.h | 22 +++++++++++++++++-----
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 055920c26da6..76ebcdb3e3b4 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -132,15 +132,6 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
>  	return stuck;
>  }
>  
> -/* journal entry close/open: */
> -
> -void __bch2_journal_buf_put(struct journal *j)
> -{
> -	struct bch_fs *c = container_of(j, struct bch_fs, journal);
> -
> -	closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
> -}
> -
>  /*
>   * Returns true if journal entry is now closed:
>   *
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index 008a2e25a4fa..c7a31da077c9 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -252,9 +252,10 @@ static inline bool journal_entry_empty(struct jset *j)
>  	return true;
>  }
>  
> -void __bch2_journal_buf_put(struct journal *);
> -
> -static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
> +/*
> + * Drop reference on a buffer index and return true if the count has hit zero.
> + */
> +static inline union journal_res_state journal_state_buf_put(struct journal *j, unsigned idx)
>  {
>  	union journal_res_state s;
>  
> @@ -264,9 +265,20 @@ static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
>  				    .buf2_count = idx == 2,
>  				    .buf3_count = idx == 3,
>  				    }).v, &j->reservations.counter);
> +	return s;
> +}
>  
> -	if (!journal_state_count(s, idx) && idx == s.unwritten_idx)
> -		__bch2_journal_buf_put(j);
> +void bch2_journal_write(struct closure *);
> +static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
> +{
> +	struct bch_fs *c = container_of(j, struct bch_fs, journal);
> +	union journal_res_state s;
> +
> +	s = journal_state_buf_put(j, idx);
> +	if (!journal_state_count(s, idx)) {
> +		if (idx == s.unwritten_idx)
> +			closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
> +	}
>  }
>  
>  /*
> -- 
> 2.41.0
> 
