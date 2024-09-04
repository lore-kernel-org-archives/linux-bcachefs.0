Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A111E1309
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468365; cv=none; b=tTTIuxzMeE4gKhZu3+LDpKAQnsbjllOfVb+Mk9E+ULvgInPH7PREDF50XaMBRVCK98aAUiMkNoXNBcRLIgwXoBi5QE6cmsDWWYZ2XaXczWvoAtxtdWRSxX3SrNTtGxR3DystNbepPyoQ7r3iv3KG8Cqs7hq2EZOlSim2Gcd8Xf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468365; c=relaxed/simple;
	bh=dFhS4dE8uedw1cXPhdYDcbjHlnz46XsrbzBFKCVKkYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlGivrTn4cmegvjKZQJ7fQMCqGl/TCqwClaa7SDDXn283NRdlBi462PBxopTLnAoZeouBCCymr8uphOWkylAO0Nhl0ABVG9ztL7z4HrgEW6w5GbEdsXbLfFbQkHJSrS2BzaFriJjPVU6nX/GSV/6sv/SLNwQu05iucvecGVecBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TWW6zgwB; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TWW6zgwB"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a89c8db505bso501053466b.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Sep 2024 09:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725468362; x=1726073162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mxgCn6iAecAxYp2unFwUyhJKU6UBoBh4bFD7TaZBxYs=;
        b=TWW6zgwBjAkSrMpnh2tC2DA8pXNlBIl5ImbCm0HixiGW0LSK0/ePsjK34+k3kNPLIx
         qmdOq7fo6xPkfjz+0kJvYpq603enrd6lGHSkb52B4tWIL33Wa12RZV5GXFssroLcNF7A
         AswvnzWcsNTCIuThAyTSkYPc62FQ4Ec4jKp2KbqJ1DsxBy03qhKb+y5Cw2Vb9hD6easL
         /BLj88kZc4EJJcK4cfS+Gdiylm0utojsHa450/7f53op865vprXI7mQHzEkyKhZicuDc
         E6BdOSrvqSSlxAJ4sOguEC9zGma5Hp9jBu7055eKjt+LU94PzdtWu53Levq99C0CX9aY
         O+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725468362; x=1726073162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxgCn6iAecAxYp2unFwUyhJKU6UBoBh4bFD7TaZBxYs=;
        b=Ki4l9Qpb/VQvAbgrN0LFzG3aA6adRIkPRThrMmUydLLkBSWtSk8x9/dFfIkfpU1AxD
         stR6N/y2auwO+8LH4JIClR1GppRt4RdMl0CEovlYypAzjqdGVccdozVMIzIaiUroPyLM
         8xLmmZzAc7qM+YIuH3xpP6m7TDqkXsf2CpLRx7m+Vj2RVR9VF32KWiCeplBwBynzJPjr
         wLpZ2qZv/LKNM2NN2pqDf+YW6yXbteIljdjR2caj37K80Bfg9MCwro8w+XIpjfvAnBUl
         AgyLUf27iZJlijAyXc3DIDuHnKPcEVueYiZGUD1L6iVupPPNiyCDfnm0dNvv+1NDn472
         PpSw==
X-Forwarded-Encrypted: i=1; AJvYcCVYUj3o60GdABC19Jxj/mizdfbviUryrnGHmQi6/B92McDase8C0675FUcQHx7puP4pd/78ZVey26zs3uM0+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6dJi6gD9GGZYVR/mFHttDL6H9/TM1Mn8TVN8ABBOeer2oGzT1
	pj9EAwRD7bfcuJkHsPsJ8QBWWapr64YgGFb5vbdhrNkfkZM18edcbE7aq9xw/Ag=
X-Google-Smtp-Source: AGHT+IGRz0ziFAeppg2o5paJw6XE1KSt3WjvRwb7zjZiymqFUfXvnLBXV+d9kgfP3Swh5wb5XF0BCg==
X-Received: by 2002:a17:907:e8d:b0:a86:899d:6459 with SMTP id a640c23a62f3a-a8a32eda727mr377230566b.38.1725468361792;
        Wed, 04 Sep 2024 09:46:01 -0700 (PDT)
Received: from localhost (109-81-94-33.rct.o2.cz. [109.81.94.33])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fbaf5bsm13498066b.23.2024.09.04.09.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:46:01 -0700 (PDT)
Date: Wed, 4 Sep 2024 18:46:00 +0200
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
Message-ID: <ZtiOyJ1vjY3OjAUv@tiehlicka>
References: <20240902095203.1559361-1-mhocko@kernel.org>
 <ggrt5bn2lvxnnebqtzivmge3yjh3dnepqopznmjmkrcllb3b35@4vnnapwr36ur>
 <20240902145252.1d2590dbed417d223b896a00@linux-foundation.org>
 <yewfyeumr2vj3o6dqcrv6b2giuno66ki7vzib3syitrstjkksk@e2k5rx3xbt67>
 <qlkjvxqdm72ijaaiauifgsnyzx3mw4edl2hexfabnsdncvpyhd@dvxliffsmkl6>
 <ZtgI1bKhE3imqE5s@tiehlicka>
 <xjtcom43unuubdtzj7pudew3m5yk34jdrhim5nynvoalk3bgbu@4aohsslg5c5m>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xjtcom43unuubdtzj7pudew3m5yk34jdrhim5nynvoalk3bgbu@4aohsslg5c5m>

On Wed 04-09-24 12:05:56, Kent Overstreet wrote:
> On Wed, Sep 04, 2024 at 09:14:29AM GMT, Michal Hocko wrote:
> > On Tue 03-09-24 19:53:41, Kent Overstreet wrote:
> > [...]
> > > However, if we agreed that GFP_NOFAIL meant "only fail if it is not
> > > possible to satisfy this allocation" (and I have been arguing that that
> > > is the only sane meaning) - then that could lead to a lot of error paths
> > > getting simpler.
> > >
> > > Because there are a lot of places where there's essentially no good
> > > reason to bubble up an -ENOMEM to userspace; if we're actually out of
> > > memory the current allocation is just one out of many and not
> > > particularly special, better to let the oom killer handle it...
> > 
> > This is exactly GFP_KERNEL semantic for low order allocations or
> > kvmalloc for that matter. They simply never fail unless couple of corner
> > cases - e.g. the allocating task is an oom victim and all of the oom
> > memory reserves have been consumed. This is where we call "not possible
> > to allocate".
> 
> *nod*
> 
> Which does beg the question of why GFP_NOFAIL exists.

Exactly for the reason that even rare failure is not acceptable and
there is no way to handle it other than keep retrying. Typical code was 
	while (!(ptr = kmalloc()))
		;

Or the failure would be much more catastrophic than the retry loop
taking unbound amount of time.

> > > So the error paths would be more along the lines of "there's a bug, or
> > > userspace has requested something crazy, just shut down gracefully".
> > 
> > How do you expect that to be done? Who is going to go over all those
> > GFP_NOFAIL users? And what kind of guide lines should they follow? It is
> > clear that they believe they cannot handle the failure gracefully
> > therefore they have requested GFP_NOFAIL. Many of them do not have
> > return value to return.
> 
> They can't handle the allocatian failure and continue normal operation,
> but that's entirely different from not being able to handle the
> allocation failure at all - it's not hard to do an emergency shutdown,
> that's a normal thing for filesystems to do.
> 
> And if you scan for GFP_NOFAIL uses in the kernel, a decent number
> already do just that.

It's been quite some time since I've looked the last time. And I am not
saying all the existing ones really require something as strong as
GFP_NOFAIL semantic. If they could be dropped then great! The fewer we
have the better.

But the point is there are some which _do_ need this. We have discussed
that in other email thread where you have heard why XFS and EXT4 does
that and why they are not going to change that model. 

For those users we absolutely need a predictable and well defined
behavior because they know what they are doing.

[...]

> But as a matter of policy going forward, yes we should be saying that
> even GFP_NOFAIL allocations should be checking for -ENOMEM.

I argue that such NOFAIL semantic has no well defined semantic and legit
users are forced to do
	while (!(ptr = kmalloc(GFP_NOFAIL))) ;
or
	BUG_ON(!(ptr = kmalloc(GFP_NOFAIL)));

So it has no real reason to exist.

We at the allocator level have 2 choices.  Either we tell users they
will not get GFP_NOFAIL and you just do the above or we provide NOFAIL
which really guarantees that there is no failure even if that means the
allocation gets unbounded amount of time. The latter have a slight
advantage because a) you can identify those callers more easily and b)
the allocator can do some heuristics to help those allocations.

We can still discuss how to handle unsupported cases (like GFP_ATOMIC |
__GFP_NOFAIL or kmalloc($UNCHECKED_USER_INPUT_THAT_IS_TOO_LARGE, __GFP_NOFAIL))
but the fact of the Linux kernel is that we have legit users and we need
to optimize for them.

> > Yes, we need to define some reasonable maximum supported sizes. For the
> > page allocator this has been order > 1 and we considering we have a
> > warning about those requests for years without a single report then we
> > can assume we do not have such abusers. for kvmalloc to story is
> > different. Current INT_MAX is just not any practical limit. Past
> > experience says that anything based on the amount of memory just doesn't
> > work (e.g. hash table sizes that used to that scaling and there are
> > other examples). So we should be practical here and look at existing
> > users and see what they really need and put a cap above that.
> 
> Not following what you're saying about hash tables? Hash tables scale
> roughly with the amount of system memory/workingset.

I do not have sha handy but I do remember dcache hashtable scaling with
the amount of memory in the past and that led to GBs of memory allocated
on TB systems. This is not the case anymore I just wanted to mention
that scaling with the amount of memory can get really wrong easily.

> But it seems to me that the limit should be lower if you're on e.g. a 2
> GB machine (not failing with a warning, just failing immediately rather
> than oom killing a bunch of stuff first) - and it's going to need to be
> raised above INT_MAX as large memory machines keep growing, I keep
> hitting it in bcachefs fsck code.

Do we actual usecase that would require more than couple of MB? The
amount of memory wouldn't play any actual role then.

-- 
Michal Hocko
SUSE Labs
