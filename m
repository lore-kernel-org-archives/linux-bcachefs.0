Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72913610B
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Aug 2025 01:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754960941; cv=none; b=ZDQsYTh2ye3to2ZSbiuBQlh2FRJkcGHgwv+nc63sPwW1p06KHHCyOsIXbeUhyNETmU1E2TOJik7mwhHPdiQ2jzW34WpQUXsimDGlSLotoabzZEmbloAkKL6jBe1POPO23Yi1TggQmviFEJD+rhNGbc6XsvNcgAIf5lApnpQup5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754960941; c=relaxed/simple;
	bh=Tt/tWZPNXX5wrIUuVFgS727y4zWudxHQYk7FJwx1aMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgJJEmCWHLAtyRxldZzzyJBmBPiLOL/YvlNkos4+x8HEXzKVxOb9tyrdjC6ty11R0BMTXSv1tgoD5/1f6jDUAF28ADcMGCd7G4eRgy79qF5/JhwfIbS+B847PYyh46K+RvIb5YLfIbITNG+mOzTsgB1xTVZGWgki4ZFN9DmyauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p4CHvU4+; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p4CHvU4+"
Date: Mon, 11 Aug 2025 21:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754960935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eCBNF1QAh1dQtg0vZh+mEQ/j0TWtczc2vlDbPTq4QSM=;
	b=p4CHvU4+XzLmI81Ku0I71IsA4KyzyF0K7VFh08OTkevjjLFnLsIUIrWl7YAOu5t1Rzndob
	eabXVmiMwCvbjoRgoGGAgf8sNvCu1/OlH+lyfVVIFTPYzhrbcS4JxX3WfTGyU5V/oqxtTW
	RzEGOAoFsR3uy3xddT72/0CEONoI3xE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Konstantin Shelekhin <k.shelekhin@ftml.net>
Cc: admin@aquinas.su, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, list-bcachefs@carlthompson.net, 
	malte.schroeder@tnxip.de, torvalds@linux-foundation.org
Subject: Re: [GIT PULL] bcachefs changes for 6.17
Message-ID: <tthojw6lkixjj5ackld7mjhmceffoxndpwmmgubo7gq3aclmzh@k5j2h4yfsuly>
References: <3ik3h6hfm4v2y3rtpjshk5y4wlm5n366overw2lp72qk5izizw@k6vxp22uwnwa>
 <55e623db-ff03-4d33-98d1-1042106e83c6@ftml.net>
 <iktaz2phgjvhixpb5a226ebar7hq6elw6l4evcrkeu3wwm2vs7@fsdav6kbz4og>
 <fd55b2ee-c54a-4eca-9406-92302ca61011@ftml.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd55b2ee-c54a-4eca-9406-92302ca61011@ftml.net>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 12, 2025 at 12:04:53AM +0300, Konstantin Shelekhin wrote:
> On 11/08/2025 17:26, Kent Overstreet wrote:
> 
> > Konstantin, please tell me what you're basing this on.
> 
> This, for example: -
> https://lore.kernel.org/all/9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk/
> - https://lore.kernel.org/all/20250308155011.1742461-1-kent.overstreet@linux.dev/
> I've just lurked around lore for a couple of minutes.

So for the dm-faulty one - md-flakey was removed without anyone ever
testing the equivalent functionality in the replacement - it was pretty
disruptive.

I'll fill you in on the other one off list, the tensions behind that
flare up go back years, and I don't think anyone wants that stuff
dredged up yet again on the list - Christoph and I in particular have
been quite frosty to each other at times, but we've always respected
each other and lately I think we've both made signs that we're actually
trying to work better together.

> > - and reference to an incident at LSF, but the only noteworthy event
> >  that I can recall at the last LSF (a year and a half ago) was where a
> >  filesystem developer chased a Rust developer out of the community.
> > 
> > So: what am I supposed to make of all this?
> 
> That you're trying to excuse your communication issues with other people's
> communication issues?

No, definitely not.

I don't think endlessly rehashing old stuff really solves anything. When
tensions are high, I try to narrow the focus and just focus on the work
at hand.

But the only thing I've found that really solves things in the long run
is just - talking. Talking when there isn't work hanging over our heads
that needs to be focused on, talking and listening without making
demands and trying to actually understand each other's points of view.
