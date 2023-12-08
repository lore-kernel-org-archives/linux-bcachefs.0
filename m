Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wxYl+rbu"
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [IPv6:2001:41d0:203:375::aa])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634E510E0
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:34:59 -0800 (PST)
Date: Fri, 8 Dec 2023 15:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702067697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBb/RWw0h06nG4n+o6Y9dD5iHPORUl0mnzxDKCi6asE=;
	b=wxYl+rbueQLF/ut02Xm8gf4iyT8LCD8Q2Zs64sRs9VCKoZe+1kC0HTHv9SiNfHz80E0hT1
	TrK0f5FFwk6Km9WTGcIOkGEvRriKcdQyNvHS4kDwsTVCO5UALH3x+KRxzuaZsUZ9oY1vEc
	NgZUL0sFfRPpi/sfB0jDcKb9D5qkdUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 4/6] bcachefs: bch2_run_online_recovery_passes()
Message-ID: <20231208203455.csqf5v6j5eteczhb@moria.home.lan>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-5-kent.overstreet@linux.dev>
 <ZXN7nrQJCsPzFab3@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXN7nrQJCsPzFab3@bfoster>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 03:25:02PM -0500, Brian Foster wrote:
> On Wed, Dec 06, 2023 at 03:33:08PM -0500, Kent Overstreet wrote:
> > Add a new helper for running online recovery passes - i.e. online fsck.
> > This is a subset of our normal recovery passes, and does not - for now -
> > use or follow c->curr_recovery_pass.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  fs/bcachefs/bcachefs.h |  7 ++++++
> >  fs/bcachefs/recovery.c | 51 ++++++++++++++++++++++++++++--------------
> >  fs/bcachefs/recovery.h |  1 +
> >  3 files changed, 42 insertions(+), 17 deletions(-)
> > 
> ...
> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> > index 585b4928964f..262c923b2f1a 100644
> > --- a/fs/bcachefs/recovery.c
> > +++ b/fs/bcachefs/recovery.c
> ...
> > @@ -651,39 +651,56 @@ static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pa
> >  
> >  static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
> >  {
> > +	struct recovery_pass_fn *p = recovery_pass_fns + pass;
> >  	int ret;
> >  
> > -	c->curr_recovery_pass = pass;
> > +	if (!(p->when & PASS_SILENT))
> > +		printk(KERN_INFO bch2_log_msg(c, "%s..."),
> > +		       bch2_recovery_passes[pass]);
> > +	ret = p->fn(c);
> > +	if (ret)
> > +		return ret;
> > +	if (!(p->when & PASS_SILENT))
> > +		printk(KERN_CONT " done\n");
> >  
> > -	if (should_run_recovery_pass(c, pass)) {
> > -		struct recovery_pass_fn *p = recovery_pass_fns + pass;
> > +	return 0;
> > +}
> >  
> > -		if (!(p->when & PASS_SILENT))
> > -			printk(KERN_INFO bch2_log_msg(c, "%s..."),
> > -			       bch2_recovery_passes[pass]);
> > -		ret = p->fn(c);
> > -		if (ret)
> > -			return ret;
> > -		if (!(p->when & PASS_SILENT))
> > -			printk(KERN_CONT " done\n");
> > +static int bch2_run_recovery_passes(struct bch_fs *c)
> > +{
> > +	int ret = 0;
> >  
> > -		c->recovery_passes_complete |= BIT_ULL(pass);
> > +	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
> > +		if (should_run_recovery_pass(c, c->curr_recovery_pass)) {
> > +			ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
> > +			if (bch2_err_matches(ret, BCH_ERR_restart_recovery))
> > +				continue;
> > +			if (ret)
> > +				break;
> > +
> > +			c->recovery_passes_complete |= BIT_ULL(c->curr_recovery_pass);
> > +		}
> > +		c->curr_recovery_pass++;
> >  	}
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  
> > -static int bch2_run_recovery_passes(struct bch_fs *c)
> > +int bch2_run_online_recovery_passes(struct bch_fs *c)
> >  {
> >  	int ret = 0;
> >  
> > -	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
> > +	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++) {
> > +		struct recovery_pass_fn *p = recovery_pass_fns + c->curr_recovery_pass;
> 
> Maybe I'm confused, but should this be using i?

Yeah, this was my early rough draft, it's fixed now :)
