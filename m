Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C3D3C38
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723054767; cv=none; b=kM+u2ncLn8uk+sB37kfeQ5uirad3QvuWbM28JkUJfeQ8W8yoeqCJDg1yfwxGydrJsrlN5wSq8sUSzanA1GNDsT+NCCMRFWC1yYNqpQTkAgynodSbHWGw1k5QORabnNWlBHaqNYP3KVo41sSZRFE3KqGi+Wnx6IX9hMhrpXLqxEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723054767; c=relaxed/simple;
	bh=bSgNYGB6l2rXDqqKktEq041QQBhqmEUCWIpUp9myMXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8hoNHbo1BSQsAvxlbDD5s9nwNgOUcNwgQelwN6xEPRg3lschsrEfizUfgwD4NNK1JauXAwoew9iq+lryPfA7hAe3VgfOQfEkaCI72HRdITjWtAJKqevNXySbyPW8KNE1MhOmSsm8WpJNcT0hvcwzo/ahblbMwVk45ZXJatocpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ogyi1qZx; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ogyi1qZx"
Date: Wed, 7 Aug 2024 14:19:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723054759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Xo8p76iHrOOzaA09B6WtuofWfluN0q6/FpGE3Al21g=;
	b=Ogyi1qZxox8BhceZDD3oug532hRsLNA+yKUDOJilfQ/hfROarqz7eLWHBezuDRuxInyIJ+
	Usun1asl7DT5x53ePdWydA5cvx6Po7+ogc9J9HDbDKqS1WhbK+N32Te/ZpOzl4jKF7/68D
	DkgO19EFzDprsixs0sFumvhUiba42Fw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Eli Schwartz <eschwartz@gentoo.org>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian
Message-ID: <qri2e26cmkjmffya27mx5g2yuasswlbw4opnzokpybnvt2t5et@wvjj3o3lj4qc>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
 <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
 <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
 <1705511146.62.1723052659777@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1705511146.62.1723052659777@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 10:44:19AM GMT, Carl E. Thompson wrote:
> Whether or not the concept of Debian is a good idea probably isn't a constructive discussion for this list.
> 
> The problem here is that what was essentially an _alpha_ piece of
> software for what at the time was essentially an _alpha_ filesystem
> was allowed into the _stable_ release of Debian at all. Whoever on the
> Debian side allowed its inclusion dropped the ball.

We're primarily talking about the package in Debian _unstable_, although
the ancient -tools package in stable is also causing problems. The
package in unstable is at 1.9.1, and we're just trying to get it to
1.9.4.

And you're blameshifting and making excuses. System critical packages
(and the filesystem is about as critical as it gets) absolutely need
timely updates, no matter what stage of the lifecycle it's at.

"Don't include it until it's perfect" is not an answer, because:
a) there will also be a period of stabilization for the distro rollout
itself where we find bugs that are specific to distro packaging and
distro process
b) software is never perfect

a) is what's going on here, and it's turning into a whole thing because
it's a Debian policy that's causing problems, and the Debian package
maintainer's response to that was "of course we won't change our policy".

So given that, and the number of bugs in my inbox from Debian users for
stuff that's already been fixed, I really have no choice but to tell
users to stay away from Debian until this gets sorted.
