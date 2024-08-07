Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A87163
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057456; cv=none; b=HGreWvxuQyEsdFspam9Cg4pxPHFSkcFghcZNamlKkcHNowYCoWCEqqzM8+NU5NHL8elQ4FIDfPk8MEIYhcUkrCV2ZxKA7G3p1aqiFpjzqcS0LOMG8MIWW0LitAU367DT4fru3bNaipe7EnFvZi591bYeuFIctFgHMvG5RxHg6HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057456; c=relaxed/simple;
	bh=/rzY5QigmKlGjsI6ZUoG448sx3M8cgZUEbNuifr6d+M=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=tQ2/rQDsNtjtnXS8e9LfRMmn9KPgcem/3SFFodULjGxLCm44b077YOBLMa4bSyvmvFbV3b/yDKu89zLF7gqP7ILrgXqWLqtf7hr0KfTkZRGWwEu4ksuk4BYlvPNcqrz7zovuvSykrGpWv5kg4JZhdwZcHSBQ7FuW8lpOvL5deb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id AC6B4500B81BC;
	Wed,  7 Aug 2024 12:04:13 -0700 (PDT)
Date: Wed, 7 Aug 2024 12:04:13 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Eli Schwartz <eschwartz@gentoo.org>, linux-bcachefs@vger.kernel.org
Message-ID: <917737081.127.1723057453386@mail.carlthompson.net>
In-Reply-To: <qri2e26cmkjmffya27mx5g2yuasswlbw4opnzokpybnvt2t5et@wvjj3o3lj4qc>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
 <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
 <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
 <1705511146.62.1723052659777@mail.carlthompson.net>
 <qri2e26cmkjmffya27mx5g2yuasswlbw4opnzokpybnvt2t5et@wvjj3o3lj4qc>
Subject: Re: PSA: Avoid Debian
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

Again, my point was (in my opinion) the bcachefs mailing list is probably not the best place to argue about whether Debian's policies / procedures are a good idea.

Of course I wasn't suggesting that bcachefs and the corresponding userspace tools need to be "perfect" before being included in Debian stable. But IMO they should at least be reasonably _stable_ to be included in Debian stable and bcachefs definitely wasn't at the time of its inclusion. Debian isn't Arch.

As far as Debian unstable goes, I have no strong opinions on that.

BTW, I'm not trying to be critical of you or of bcachefs. I have been using it on my personal systems for years now since long before it was in the kernel and there have been relatively few bumps on the road along the way and I have never lost any data. I'm impressed with what you've accomplished and have even donated my own personal money to you. However, as good as bcachefs is, based on the bug reports and rapid changes I've seen on this list I don't think it's truly stable yet. That's just my opinion.

Carl

> On 2024-08-07 11:19 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
>  
> On Wed, Aug 07, 2024 at 10:44:19AM GMT, Carl E. Thompson wrote:
> > Whether or not the concept of Debian is a good idea probably isn't a constructive discussion for this list.
> > 
> > The problem here is that what was essentially an _alpha_ piece of
> > software for what at the time was essentially an _alpha_ filesystem
> > was allowed into the _stable_ release of Debian at all. Whoever on the
> > Debian side allowed its inclusion dropped the ball.
> 
> We're primarily talking about the package in Debian _unstable_, although
> the ancient -tools package in stable is also causing problems. The
> package in unstable is at 1.9.1, and we're just trying to get it to
> 1.9.4.
> 
> And you're blameshifting and making excuses. System critical packages
> (and the filesystem is about as critical as it gets) absolutely need
> timely updates, no matter what stage of the lifecycle it's at.
> 
> "Don't include it until it's perfect" is not an answer, because:
> a) there will also be a period of stabilization for the distro rollout
> itself where we find bugs that are specific to distro packaging and
> distro process
> b) software is never perfect
> 
> a) is what's going on here, and it's turning into a whole thing because
> it's a Debian policy that's causing problems, and the Debian package
> maintainer's response to that was "of course we won't change our policy".
> 
> So given that, and the number of bugs in my inbox from Debian users for
> stuff that's already been fixed, I really have no choice but to tell
> users to stay away from Debian until this gets sorted.
