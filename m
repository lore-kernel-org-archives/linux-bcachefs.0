Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10812202C3A
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Aug 2025 20:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030723; cv=none; b=Jgai1uPQ22GjbK/+3KPIoBKuvUgAaGTAlujWGK5Kl8JeEm7BGdOxCZPdUws/5vOwHcUIB4cnqBIgu1caTF9C8uwRuobE4SDE8OvFzu8o46ixwCzVLeqeQQu/lZu13gXG5R8VVQkjtTFMLJ/PL91QlZ3Zt3bQGl74PvVhchi957k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030723; c=relaxed/simple;
	bh=A0E3re4OxSsNyH/917C1ISM9f6PnIu5USAeGZnSPvks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI6ryNzE0Sh1x85szrM6wvrBaFelDZWPK4KDEFXBqTA8AvII3ahDP36KHMG4GTAHIg63lLEmkIRYxWgYYkCdjx5RCnKYmWLBkoCtUi68sg9hnayyVBuw9ldruDD4hRDb7iI/WC8ARLBDi1rhEMHEB3rYRUeKx4aLOyil8X6sRro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=moLBKbop; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="moLBKbop"
Date: Tue, 12 Aug 2025 16:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755030720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Px0hXJV0GCZwN6JekkRra0x47OWZbHLlKDve7KBBNCU=;
	b=moLBKbopM42dWCyZ78hsxsO5r60H2ctKgREkZbEdk/ea3GrMztV9b1uewoDxC72GibTc7s
	AeyGQN+um+/zg/hmsgfC8KkYe9h7g5FZ/BRX3SFdsyHW/XwCFlO8VDb9zmKAyToQHotx7s
	8mV+Kli5qoKrrB+3vVVxK/LsxUTmGTI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: Konstantin Shelekhin <k.shelekhin@ftml.net>, admin@aquinas.su, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	list-bcachefs@carlthompson.net, malte.schroeder@tnxip.de, torvalds@linux-foundation.org
Subject: Re: [GIT PULL] bcachefs changes for 6.17
Message-ID: <46cndpjyrg3ygqyjpg4oaxzodte7uu7uclbubw4jtrzcsfnzgs@sornyndalbvb>
References: <3ik3h6hfm4v2y3rtpjshk5y4wlm5n366overw2lp72qk5izizw@k6vxp22uwnwa>
 <55e623db-ff03-4d33-98d1-1042106e83c6@ftml.net>
 <iktaz2phgjvhixpb5a226ebar7hq6elw6l4evcrkeu3wwm2vs7@fsdav6kbz4og>
 <aJuXnOmDgnb_9ZPc@kbusch-mbp>
 <htfkbxsxhdmojyr736qqsofghprpewentqzpatrvy4pytwublc@32aqisx4dlwj>
 <aJukdHj1CSzo6PmX@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJukdHj1CSzo6PmX@kbusch-mbp>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 12, 2025 at 02:30:44PM -0600, Keith Busch wrote:
> On Tue, Aug 12, 2025 at 04:03:17PM -0400, Kent Overstreet wrote:
> > On Tue, Aug 12, 2025 at 01:35:56PM -0600, Keith Busch wrote:
> > > On Mon, Aug 11, 2025 at 10:26:03AM -0400, Kent Overstreet wrote:
> > > > On the other hand, for the only incidences I can remotely refer to in
> > > > the past year and a half, there has been:
> > > ...
> > > 
> > > > - the block layer developer who went on a four email rant where he,
> > > >   charitably, misread the spec or the patchset or both; all this over a
> > > >   patch to simply bring a warning in line with the actual NVME and SCSI
> > > >   specs.
> > > 
> > > Are you talking about this thread?
> > > 
> > >   https://lore.kernel.org/linux-block/20250311201518.3573009-14-kent.overstreet@linux.dev/
> > > 
> > > I try to closely follow those lists, and that's the only thread I recall
> > > that even slightly rings a bell from your description, however it's not
> > > an accurate description (you were the one who misread the specs there; I
> > > tried to help bridge the gap). I recall the interaction was pretty tame
> > > though, so maybe you're talking about something else. Perhaps a link for
> > > context if I got it wrong?
> > 
> > I've since seen a lot of actual test data from SCSI hard drives - fua
> > reads are definitely not cached, without exception across manufacturers.
> > 
> > On NVME the situation is much murkier.
> 
> Okay, I take it I got the right thread then. I just wanted to get the
> context. For the record, all the specs align with what read fua does
> (anyone interested can visit the linked thread, I don't want to hijack
> this one for it).

If you're interested, is it time to do some spec quoting and language
lawyering?
