Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DB313BAE3
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723053075; cv=none; b=iLVyy+UzooRIH3N1P8fEmjUJfuyjg7JnWa2TigfOGawvvQkhYaxq9OAmjEPLNR5f3YN38Y/fHhunM/uFm9aKM3l2EfTfIsRMEMbx/Y9Gy2XtX41Ove8ijgWDGAWtqj5NzX1RyWa60CtbgFvDEjT/DD5vqowfl9VAP6pZU1U2c5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723053075; c=relaxed/simple;
	bh=5vO+q7PlPFnyQLBl9MjvHjTcubX9e3ylkmu+RzaNVLw=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=VfhE2EnfNYHwU1FvP3D8wTv37/3A+j4tXHDL3+Oq2sQlneEynE8L0UnwJIG1BGjijGvvhbH5SiuaqcIo2Mz0lQp0dX2pSZuvp00NnOYacaHqsMTYvmbEwUnHHBbqMY+V6Vw2n1tK2CNvNSva90ISVyzuybO7nmCKE7Rzeqs6RF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 1A008F71A1;
	Wed,  7 Aug 2024 10:43:18 -0700 (PDT)
Date: Wed, 7 Aug 2024 10:43:17 -0700 (PDT)
From: "Carl E. Thompson" <cet@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Eli Schwartz <eschwartz@gentoo.org>
Cc: linux-bcachefs@vger.kernel.org
Message-ID: <41409810.56.1723052597872@mail.carlthompson.net>
In-Reply-To: <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
 <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
 <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
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

Whether or not the concept of Debian is a good idea probably isn't a constructive discussion for this list.

The problem here is that what was essentially an _alpha_ piece of software for what at the time was essentially an _alpha_ filesystem was allowed into the _stable_ release of Debian at all. Whoever on the Debian side allowed its inclusion dropped the ball.

Carl


> On 2024-08-07 10:29 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
>  
> On Wed, Aug 07, 2024 at 12:09:53PM GMT, Eli Schwartz wrote:
> > On 8/7/24 12:01 PM, Kent Overstreet wrote:
> > > This is holding up _bugfix releases_.
> > > 
> > > Anyone would run screaming from a distro that didn't ship updates at
> > > all.
> > 
> > 
> > (What if I said that lots of people *do* run screaming from Debian?)
> 
> Heh.
> 
> Personally, in _general_, I feel quite affectionate towards debian; I've
> been running it for 20 years, and there's a lot to like about it and a
> lot of good stuff they've done.
> 
> But lately a _lot_ of the bug reports I'm seeing have "I was running an
> old broken Debian package" as a root cause or additional complicating
> factor.
> 
> And considering that this is due to something we discussed months? a
> year? ago, and they're still insisting on broken policies, I am growing
> _increasingly_ pissed off about it.
> 
> (Personally, this is pushing me to migrate my infrastructure to NixOS
> sooner rather than later...)
> 
> > You have to manually negotiate for those, to avoid the risk of
> > accidentally shipping an updated bugfix release that breaks their
> > spacebar heating: https://xkcd.com/1172/
> 
> Which isn't remotely feasible; I have a lot of distros packaging
> bcachefs, and I don't have time to devote to interactions like this with
> all of them. This is Debian wanting to think they're special, assuming
> that they can dominate with their policies - but that's not a winning
> long term strategy, that's just going to result in them being left
> behind.
> 
> The only honest way of influencing other people, and the only way that
> works long term, is with the quality of your ideas. "But this is our
> policy and you just have to abide" - nope. Even if people don't react
> right away, they see that and take note and start maing other plans.
> 
> > When software cannot be updated by default because it might break
> > someone's workflow, the natural result of sometimes needing an update is
> > that people who want updates are pitted adversarially against people who
> > do not want updates -- you need to plead your case and get permission
> > and, well, fight for your right to receive a bugfix.
> 
> I've put a _lot_ of work into making sure bcachefs updates are as
> painless as they can be, with e.g. seamless upgrade and downgrade paths,
> and ways of dealing with version mismatch between tools/kernel/ondisk
> filesystem.
> 
> Because we _have to be able to ship our work_, and in a timely manner.
> Our systems get steadily more complicated year by year, decade by
> decade, as we build up more processes and tooling around the whole
> business of writing and shipping code. Making progress in our work
> requires shipping code and iterating, so if we can't and we let the
> political process bullshit it's death by a thousand cuts and work slowly
> grinds to a halt.
> 
> > Has anyone volunteered to be the political advocate for bcachefs-tools
> > bugfix releases in Debian?
> 
> No, and nor would I recommend anyone else for that kind of bullshit,
> make-work job.
> 
> The real issue here is just that Debian needs to figure out how to have
> some flexibility, recognize when policies aren't working, and develop a
> better and more practical minded attitude.
> 
> So they can stop wasting my time with this stupid bullshit and I can get
> back to real work.
