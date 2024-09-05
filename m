Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB3F19924A
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535615; cv=none; b=SUJfwYvNVyCjb6Hrjq1pJ/RANBG0ypZR6iZDmhAUy5YRNO8nuksCVPynFGzMEU2kYRBlbdvcHFXhRvtuon1hd75IPDRCg4NKunx1q1oEl4uBFnxhRgWsPP6iGDUlRjJiL05fP/7n6SdB+ggCuSFLi+OrFfBiXbvqTx13KBsEtBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535615; c=relaxed/simple;
	bh=uDHN9oD3ymzNoKqucZVNQadRU4ImbE+RLTgFQhaenkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVxuffypbR4xngS39g4Y7oWd4ImRtKypx2CvsBanvK6bR+YmXL5xuTYg92hBijs+ubr1gu920nqX1NqwIo8hRRR0YsY21cFxdiOV8dEKLYi4pfeYGIfw7+twxJM6vY+Bc58q16X7w5px/pqvRvNRTOl4Ktc2BySgzUCOgzZJhH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BEu8qjzB; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BEu8qjzB"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5356ab89665so735386e87.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Sep 2024 04:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725535611; x=1726140411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MT1b/AWbDQ4Zc2FSXLwenhXbbMScTqyTjSATBO5zm2Q=;
        b=BEu8qjzBcMUR56NsccopP84Ny24P/QojRgTGrRGCOueAi+bw9q1+swNtnNE1g4MOYt
         cM+xo/+/RpRjGLjkc/L3mnWGAdttToWfGZjfo9J3dVG3QJj7Y2+/oHfL8ifAordAnf28
         +MwrvqMyAu1t/UKHB7P6rGE7HX0PPetS4N9vczFGrepUi4xw7ozG3trsYs9SSfsD7jJ6
         sBO9MGmBgHLFIpNGE9t3LbwmHH3Bm33RLg7C4CI1IFYc8KYvBlC4LtPuR0y0cvt5bsr/
         Rk4AZCzxD/LK7Q6yTOS8GTV92VKWvNE31tfF480i4clqfOHNhZ9U+2t1hPswLN4dWTVF
         lHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535611; x=1726140411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MT1b/AWbDQ4Zc2FSXLwenhXbbMScTqyTjSATBO5zm2Q=;
        b=qVXgm85B2crGSesGSSilsGE1R4zO6O6qYHO2sLz4E5gS7jW9oZUZv0aEKJLeoC8M1D
         tok4f7NpXqW+Ui5GcE781EkQKIt3Ruvm3RtqGLhZqdbFii9pW5Qz8UcOtQTlHK3jQr0w
         mU2yRvMWq8si+YskMleyMUXXglhCQ/tkgEvzgSrvte/b8QxKr9fV15ZJHXpNlbp3u71X
         XJGtOJP9hByVQqIezL1OrS2u3Ns4AHVwAxP3tFADGgUgPVbIllOgtWEf/Z1OmcIND4hl
         2W7qJyqN4G0ERcM4VYELditEMUDOz9MyrZABgQ1pBMybs98cez1AGwijV0KLwzimVlPn
         Gv9w==
X-Forwarded-Encrypted: i=1; AJvYcCWlv5At8eHgQnz9Rhcc3fIfN8hvlkxgEd5gwvnwYuFmfkRElh8MUiOHUlRLKz5oawD4omjN0xKMHzkruSA/rQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4nt+lQ4Xtoqqe3VnJtYRFNnYSKQ68Dml49GWTe12hbLWaqoUf
	yG2vW+x2XNF/RN8gN1gfCu/W3dgoFUTz3kpGVsypA628aSFfgq6ZbU07Fgce5Ss=
X-Google-Smtp-Source: AGHT+IEtrnolfEptjFfOHaUd4JcPGLaKbwZaBjtKbHZL9CqfOihD83PJlSp/4jz+xU32g7o2FRHYcQ==
X-Received: by 2002:a05:6512:230c:b0:530:ad7d:8957 with SMTP id 2adb3069b0e04-53546bb3b33mr14872842e87.49.1725535611082;
        Thu, 05 Sep 2024 04:26:51 -0700 (PDT)
Received: from localhost ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a764794c9sm55307966b.1.2024.09.05.04.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:26:50 -0700 (PDT)
Date: Thu, 5 Sep 2024 13:26:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>,
	jack@suse.cz, Vlastimil Babka <vbabka@suse.cz>,
	Dave Chinner <dchinner@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] remove PF_MEMALLOC_NORECLAIM
Message-ID: <ZtmVej0fbVxrGPVz@tiehlicka>
References: <20240902095203.1559361-1-mhocko@kernel.org>
 <ggrt5bn2lvxnnebqtzivmge3yjh3dnepqopznmjmkrcllb3b35@4vnnapwr36ur>
 <20240902145252.1d2590dbed417d223b896a00@linux-foundation.org>
 <yewfyeumr2vj3o6dqcrv6b2giuno66ki7vzib3syitrstjkksk@e2k5rx3xbt67>
 <qlkjvxqdm72ijaaiauifgsnyzx3mw4edl2hexfabnsdncvpyhd@dvxliffsmkl6>
 <ZtgI1bKhE3imqE5s@tiehlicka>
 <xjtcom43unuubdtzj7pudew3m5yk34jdrhim5nynvoalk3bgbu@4aohsslg5c5m>
 <ZtiOyJ1vjY3OjAUv@tiehlicka>
 <pmvxqqj5e6a2hdlyscmi36rcuf4kn37ry4ofdsp4aahpw223nk@lskmdcwkjeob>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pmvxqqj5e6a2hdlyscmi36rcuf4kn37ry4ofdsp4aahpw223nk@lskmdcwkjeob>

On Wed 04-09-24 14:03:13, Kent Overstreet wrote:
> On Wed, Sep 04, 2024 at 06:46:00PM GMT, Michal Hocko wrote:
> > On Wed 04-09-24 12:05:56, Kent Overstreet wrote:
> > > On Wed, Sep 04, 2024 at 09:14:29AM GMT, Michal Hocko wrote:
> > > > On Tue 03-09-24 19:53:41, Kent Overstreet wrote:
> > > > [...]
> > > > > However, if we agreed that GFP_NOFAIL meant "only fail if it is not
> > > > > possible to satisfy this allocation" (and I have been arguing that that
> > > > > is the only sane meaning) - then that could lead to a lot of error paths
> > > > > getting simpler.
> > > > >
> > > > > Because there are a lot of places where there's essentially no good
> > > > > reason to bubble up an -ENOMEM to userspace; if we're actually out of
> > > > > memory the current allocation is just one out of many and not
> > > > > particularly special, better to let the oom killer handle it...
> > > > 
> > > > This is exactly GFP_KERNEL semantic for low order allocations or
> > > > kvmalloc for that matter. They simply never fail unless couple of corner
> > > > cases - e.g. the allocating task is an oom victim and all of the oom
> > > > memory reserves have been consumed. This is where we call "not possible
> > > > to allocate".
> > > 
> > > *nod*
> > > 
> > > Which does beg the question of why GFP_NOFAIL exists.
> > 
> > Exactly for the reason that even rare failure is not acceptable and
> > there is no way to handle it other than keep retrying. Typical code was 
> > 	while (!(ptr = kmalloc()))
> > 		;
> 
> But is it _rare_ failure, or _no_ failure?
>
> You seem to be saying (and I just reviewed the code, it looks like
> you're right) that there is essentially no difference in behaviour
> between GFP_KERNEL and GFP_NOFAIL.

The fundamental difference is that (appart from unsupported allocation
mode/size) the latter never returns NULL and you can rely on that fact.
Our docummentation says:
 * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block
 * indefinitely but will never return with failure. Testing for
 * failure is pointless.

> So given that - why the wart?
> 
> I think we might be able to chalk it up to history; I'd have to go
> spunking through the history (or ask Dave or Ted, maybe they'll chime
> in), but I suspect GFP_KERNEL didn't provide such strong guarantees when
> the allocation loops & GFP_NOFAIL were introduced.

Sure, go ahead. If you manage to remove all existing users of
__GFP_NOFAIL (without replacing them with retry loops in the caller)
then I would be more than happy to remove __GFP_NOFAIL in the allocator. 

[...]
> > But the point is there are some which _do_ need this. We have discussed
> > that in other email thread where you have heard why XFS and EXT4 does
> > that and why they are not going to change that model. 
> 
> No, I agree that they need the strong guarantees.
> 
> But if there's an actual bug, returning an error is better than killing
> the task. Killing the task is really bad; these allocations are deep in
> contexts where locks and refcounts are held, and the system will just
> grind to a halt.

Not sure what you mean by these allocations but I am not aware that any
of the existing user would be really buggy. Also as I've said elsewhere,
there is simply no good way to handle a buggy caller. Killing the buggy
context has some downsides, returning NULL has others. I have argued
that the former has better predictable behavior than potentially silent
failure. We can clearly disagree on this but I also do not see why that
is relevant to the original discussion because my argument against
PF_MEMALLOC_NORECLAIM was focused on correct GPF_NOFAIL nested context
that would get an unexpected failure mode. No matter what kind of
failure mode that is it would be unexpected for those users.

> > > But as a matter of policy going forward, yes we should be saying that
> > > even GFP_NOFAIL allocations should be checking for -ENOMEM.
> > 
> > I argue that such NOFAIL semantic has no well defined semantic and legit
> > users are forced to do
> > 	while (!(ptr = kmalloc(GFP_NOFAIL))) ;
> > or
> > 	BUG_ON(!(ptr = kmalloc(GFP_NOFAIL)));
> > 
> > So it has no real reason to exist.
> 
> I'm arguing that it does, provided when it returns NULL is defined to
> be:
>  - invalid allocation context
>  - a size that is so big that it will never be possible to satisfy.

Those are not really important situations because you are arguing about
a buggy code that needs fixing. As said above we can argue how to deal
with those users to get a predictable behavior but as the matter of
fact, correct users can expect never seeing the failure so handling
failure might be a) impossible and b) unfeasible (i.e. you are adding a
dead code that is never tested).

[...]

> For large allocations in bcachefs: in journal replay we read all the
> keys in the journal, and then we create a big flat array with references
> to all of those keys to sort and dedup them.
> 
> We haven't hit the INT_MAX size limit there yet, but filesystem sizes
> being what they are, we will soon. I've heard of users with 150 TB
> filesystems, and once the fsck scalability issues are sorted we'll be
> aiming for petabytes. Dirty keys in the journal scales more with system
> memory, but I'm leasing machines right now with a quarter terabyte of
> ram.

I thought you were arguing about bcachefs handling failure mode so
presumably you do not need to use __GFP_NOFAIL for those.

I am sorry but I am getting lost in these arguments.
-- 
Michal Hocko
SUSE Labs
