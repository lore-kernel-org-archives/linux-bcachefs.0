Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069D22B8D5
	for <linux-bcachefs@vger.kernel.org>; Sun, 10 Aug 2025 06:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754808709; cv=none; b=F8Cm+7NIHv0l8qbAoq+GXVjcoKsZVC0db0lswRiH6fptPCFWv9ALPCh5YqYnCgG9MIyPZEVCld25vvKAbWteMXWMYAHC1JZgGgP8mC0ylZaRrSCNGbsHd1uDau+hseylUmeWStsCTo45F46iwp6ktY0BdeMHRVMPTfKZ4cUf6Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754808709; c=relaxed/simple;
	bh=w4s6ef9QQuQTpsSCeAfALWWCxl+SH5jM25lC0VRVzBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I26pPPKOifeElKhPkCwuMlL68Zq8H4nC+e+IKVCWkolLyqpJTy2OylwQTA8Bk1qe9ip8UkHMzJ4ZLJeuc5h0ZQOTeqKq6YVUF2L/Sn3Kt7xXne4LSstKUcYGRHurmqBx2qqoNspCONx6YN/1KyXE05a/CowJrIXk2ZRm35O1/6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v6GKyG/R; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v6GKyG/R"
Date: Sun, 10 Aug 2025 02:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754808695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5opVV4qX373/TZHQ2Y1gR+gQdhGSWKpiSvpwpU6mgQ0=;
	b=v6GKyG/RSDO9WYfTaWi5TYOt+TQ05SVVoGDvQgBNkNrkOYFnnN7EjqP8JZ0vfBQLJiasNe
	VrdW40Fbg2tjBrKcgdH7eA5meOYM2a1PE6VXS6Z/oCwD/9DVCz2dQgj/I8ud6ERIGY++o+
	b9hSpMNDch8nXHdFyFAWY6cftHZHzdg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Gerald B. Cox" <gbcox@bzb.us>, Sasha Levin <sashal@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Aquinas Admin <admin@aquinas.su>, 
	Malte =?utf-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Carl E. Thompson" <list-bcachefs@carlthompson.net>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.17
Message-ID: <s3bemxtilqqkr4ncii23z2sjvwkkol5bab6ox5o76hifkzgqvk@uuiqgxzqhpnx>
References: <5909824.DvuYhMxLoT@woolf>
 <3ik3h6hfm4v2y3rtpjshk5y4wlm5n366overw2lp72qk5izizw@k6vxp22uwnwa>
 <20250809192156.GA1411279@fedora>
 <2z3wpodivsysxhxmkk452pa4zrwxsu5jk64iqazwdzkh3rmg5y@xxtklrrebip2>
 <20250810022436.GA966107@mit.edu>
 <k6e6f3evjptze7ifjmrz2g5vhm4mdsrgm7dqo7jdatkde5pfvi@3oiymjvy6f3e>
 <aJgaiFS3aAEEd78W@lappy>
 <2e47wkookxa2w6l2hv4qt2776jrjw5lyukul27nqhyqp5fsyq2@5mvbmay7qn2g>
 <CACLvpcxmnXFmgfwGCyUJe1chz5vLkxbg3=NzayYOKWi4efHrqQ@mail.gmail.com>
 <20250810055955.GA984814@mit.edu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250810055955.GA984814@mit.edu>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 10, 2025 at 01:59:55AM -0400, Theodore Ts'o wrote:
> If Kent hadn't spoken up, I would have remained quiet and waited for
> Linus to do what he was going to do --- but no, he decided to take
> this public, and started slamming Linux's engineering standards.  I
> will point out that a good engineer has to have good people skills[2].
> In fact, there are many who have claimed that engineers' soft skills
> are just as important, if not more important than their technical
> abilities.

If I had simply remained quiet until it happened, I think the entire
bcachefs userbase, and my funders, would have been absolutely furious
with me.

And yes, the kernel engineering processes and standards that got us to
the point are absolutely relevant to the discussion.
