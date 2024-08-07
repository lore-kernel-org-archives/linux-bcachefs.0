Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E1541C6A
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046484; cv=none; b=Y90EBcOlRQN3G7iqIpViVu/ppWf3ECS4/uS99g/BimUqOc+UeI81w2LWo3gRP0f6cw55H2sx0Yqo8ENTGLLY2LI4BOVIf+c9sazWjG/O2Z1EpLbwuorGq5M2tFBZssVqH/JY05hrm9ijQSHJy7RC6Pm5Y8sMkbtrlPXc5+OagZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046484; c=relaxed/simple;
	bh=XDWxJRjohpUXaGesHo3jCeDrYPGNwD5wbBuACXt/Id8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCjoPZq7ULkR8qW1wBEN+3qInTBwojl4WBssvoI39wLAyWwWqPRBm1/MWYA/DiY5m0X3FEZVChIBEqeNtdXGiDoSYViRO7nt4V9uJ9of4+N3tUIR2UG/3x3zBG+/Y+X/AJ4GCloMXt2ZuVXucGquYZ9rMXosPqTU13jEAUi/0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N+NiiP2y; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N+NiiP2y"
Date: Wed, 7 Aug 2024 12:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723046480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lF3oZZB79kutjqIIqK+RHbnwRqOlKMXuWcl+Kwbx1/k=;
	b=N+NiiP2yrpaGmmVJwmU8I58+9QM6uuasQyhG+Uxl1IsUIdhnQcImvYmZpywkQCPEZSS6yk
	HsFOA7pto6cD1CqsSW6/Dcm6h8GVYCgsEiglxxnrqJhX8AyX6h6Q6iqfbh10uAsQ7KpFue
	lrKMs/Bdh0uhbcN4Hux9C9epMvaxvzA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eli Schwartz <eschwartz@gentoo.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian
Message-ID: <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 11:01:12AM GMT, Eli Schwartz wrote:
> On 8/7/24 12:34 AM, Kent Overstreet wrote:
> > Debian (as well as Fedora) currently have a broken policy of switching
> > Rust dependencies to system packages - which are frequently out of date,
> > and cause real breakage.
> > 
> > As a result, updates that fix multiple critical bugs aren't getting
> > packaged.
> > 
> > (Beyond that, Debian is for some reason shipping a truly ancient
> > bcachefs-tools in stable, for reasons I still cannot fathom, which I've
> > gotten multiple bug reports over as well).
> 
> 
> I can help you fathom the reason.
> 
> The inherent purpose of Debian is to not provide updates to software,
> since the general class of "computer code" contains the general risk of
> "regressions", including "existing config files need to be updated, and
> that regresses my ability to run a box unattended for 10 years without
> ssh'ing in even once".
> 
> It is therefore the stated purpose of Debian that:
> 
> - if you managed to get a working installation you do not need new
>   versions of the software to maintain a holding pattern in your ability
>   to get the same work done today that you were able to get done
>   yesterday -- whereas upgrading to new features can break that holding
>   pattern.
> 
> - if you did NOT manage to get a working installation, you do not need
>   that new stuff, and should stop attempting to have an "off-topic
>   conversation that misses the purpose of Debian"
> 
> 
> If you want updates to software, you upgrade debian, rather than
> upgrading software. If you want modern software, you either use Debian
> sid rather than stable (bcachefs-tools 1.9.1 may not be the most recent
> version but it's very much not "truly ancient") or you do the sensible
> thing and use a reasonable distro.
> 
> "Reasonable distro" meaning a distro that, when faced with the choice
> between:
> 
> - allow people who installed the distro in 2017 to pretend it is still
>   2017 and keep using their system the way they did back then
> 
> - improve the user experience for users
> 
> choose the latter.
> 
> In short, it is foolish to criticize Debian for shipping ancient
> software since the answer is "the purpose of Debian is so that users can
> use ancient software".

This is holding up _bugfix releases_.

Anyone would run screaming from a distro that didn't ship updates at
all.
