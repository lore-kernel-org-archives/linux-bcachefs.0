Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5852F13CFA3
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723051769; cv=none; b=egzSysWSY0oSc4F62/EL1/KW5SlAantTBXUeWy/bgUQuU4QZ8JM36RKXGf25CQxyvvN+dy1d6LeV01PdjDi7Lj9Q/rJBKYcDcGqY1eYogy+L9/PsHyr6l2mKr66J3bdnM3rklo9LCcjpJZjjo38mTTNYvd6Qe6UwKcwOZ6HY4S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723051769; c=relaxed/simple;
	bh=Yg8e4pEBG87/VFz5K2cymU9WIAZcWWud9hBR935gP0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STwh7ma7m/Ev+kb92bwKyS4Ovocjwu4t0oi25NMFOdl7NPSSaLwCR+abE2trC6i/ozB0QL5Fl10rccfdb//ZfGrkLW4OVIwtaggXMUw5ckiVAu/J4bL/4WxisTk6iAgIx8/SuxbeGL2k7O3Jj1Z2DQ9JwZaL6LOyrlwZWm0D9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wjQAw8DX; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wjQAw8DX"
Date: Wed, 7 Aug 2024 13:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723051764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7YPpgZREQSrRJBtDHfBvgFk3qdji+IW7ATwOCP/7/ao=;
	b=wjQAw8DXNPoV0avscR/Oy+p3sQ00NYdJTYCYFWY53dVC12b1vdrHLchlWEkXbux2CpCWZH
	GuaVXo6AK7nZTPnalkAxIEMDQlOjCw82GmYeSONkt6EhK/mux2fvjNpNgcg8Y52GhazA+X
	yLfUrYH35SZBVhXRN7YuGFfSBygqq6c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eli Schwartz <eschwartz@gentoo.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian
Message-ID: <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
 <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 12:09:53PM GMT, Eli Schwartz wrote:
> On 8/7/24 12:01 PM, Kent Overstreet wrote:
> > This is holding up _bugfix releases_.
> > 
> > Anyone would run screaming from a distro that didn't ship updates at
> > all.
> 
> 
> (What if I said that lots of people *do* run screaming from Debian?)

Heh.

Personally, in _general_, I feel quite affectionate towards debian; I've
been running it for 20 years, and there's a lot to like about it and a
lot of good stuff they've done.

But lately a _lot_ of the bug reports I'm seeing have "I was running an
old broken Debian package" as a root cause or additional complicating
factor.

And considering that this is due to something we discussed months? a
year? ago, and they're still insisting on broken policies, I am growing
_increasingly_ pissed off about it.

(Personally, this is pushing me to migrate my infrastructure to NixOS
sooner rather than later...)

> You have to manually negotiate for those, to avoid the risk of
> accidentally shipping an updated bugfix release that breaks their
> spacebar heating: https://xkcd.com/1172/

Which isn't remotely feasible; I have a lot of distros packaging
bcachefs, and I don't have time to devote to interactions like this with
all of them. This is Debian wanting to think they're special, assuming
that they can dominate with their policies - but that's not a winning
long term strategy, that's just going to result in them being left
behind.

The only honest way of influencing other people, and the only way that
works long term, is with the quality of your ideas. "But this is our
policy and you just have to abide" - nope. Even if people don't react
right away, they see that and take note and start maing other plans.

> When software cannot be updated by default because it might break
> someone's workflow, the natural result of sometimes needing an update is
> that people who want updates are pitted adversarially against people who
> do not want updates -- you need to plead your case and get permission
> and, well, fight for your right to receive a bugfix.

I've put a _lot_ of work into making sure bcachefs updates are as
painless as they can be, with e.g. seamless upgrade and downgrade paths,
and ways of dealing with version mismatch between tools/kernel/ondisk
filesystem.

Because we _have to be able to ship our work_, and in a timely manner.
Our systems get steadily more complicated year by year, decade by
decade, as we build up more processes and tooling around the whole
business of writing and shipping code. Making progress in our work
requires shipping code and iterating, so if we can't and we let the
political process bullshit it's death by a thousand cuts and work slowly
grinds to a halt.

> Has anyone volunteered to be the political advocate for bcachefs-tools
> bugfix releases in Debian?

No, and nor would I recommend anyone else for that kind of bullshit,
make-work job.

The real issue here is just that Debian needs to figure out how to have
some flexibility, recognize when policies aren't working, and develop a
better and more practical minded attitude.

So they can stop wasting my time with this stupid bullshit and I can get
back to real work.
