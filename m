Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE6B126F0A
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Jun 2025 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750033995; cv=none; b=j0MXte1yAbJNymQQjUXNizUtOzDphRxs/H7IjnKEbwp/xuH9j75JaIIrHGJWZMzkAkt6aETJoG33c4cZEl5YkJt6g1uFRRumWantAwSgfOs2tmNt2W1l4+yoeZjuv7ZbglNpQFEv+qYk4U+gjMOQfPL2VyT2LgFf/UfriQYYScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750033995; c=relaxed/simple;
	bh=lQDyYHFXt28W7HvSu2ia8drEEeusp2Rs66KnZAyl30I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4g18B6KEiS99q9NyDVvGAdzQrEZOFOhIXOJ5VdAnvoKsXrn9k/USFY5GXIHLe/THdMmye7iycuJqnZMcpuHcuz7ARLFE3OYAfV7u4laJIZZp3Thr4Ok8FIsPw9PDg6Tg1aVWHQuE2tRcAcjzD33cFS5QiiyloUPds4e9velLbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SPsrDi7E; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SPsrDi7E"
Date: Sun, 15 Jun 2025 20:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750033990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXF56UfPLSx5Zs5TTi7ETKwia8Qkv33E5b+l0gZzpsA=;
	b=SPsrDi7EQG32gorBshpxoz+uLTYtPZpzEt4hxuskouSdRTfSUCzp5mJVI4HenbDL0GOTBA
	fE93Eaij9ifYULxGueIF4tQsiQ9JY0kUY2KV+SaWWzdmOjSwzlaWgvgTsI3TGKGZ7wWQQG
	50yaMKQDPAPZ6nBWaqx07WmgXRlWfn4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aaron Friel <mayreply@aaronfriel.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Message-ID: <jkgoqhxqhmj7dkdo76winlptddzggzbexv7y2cvrtx5jbibofz@5g6d56prjg6k>
References: <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
 <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <6v4xbwoewpmrl7uga24yjvft4dpeis65p42vez7tgi7eiuqpbq@4qvl64d3bwq3>
 <MW4PR05MB99933BF310D75964CC5FDAE7B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <dsoyo2a3h2s52sznnujwqeebdzqxmjr4jgx2vjpknpvdfktnpw@7oxvl3ntjebk>
 <MW4PR05MB999372E527C87E73BF153992B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR05MB999372E527C87E73BF153992B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 16, 2025 at 12:21:46AM +0000, Aaron Friel wrote:
> > > > > > > I'm looking to see if I can submit a patch to fix this, but it seems
> > > > > > > like the durability bit field for devices may be only 2 bits, is that
> > > > > > > right?
> > > > > > 
> > > > > > That gets you values of 0-3. Why is that not enough?
> > > > >
> > > > > In bch2_mi_to_cpu, it looks like durability is encoded with a "bias" (default value) that maps {0,1,2,3} => {1,0,1,2}.
> > > > >
> > > > >             .durability = BCH_MEMBER_DURABILITY(mi)
> > > > >                   ? BCH_MEMBER_DURABILITY(mi) - 1
> > > > >                   : 1,
> > > > >
> > > > > This is pretty unfortunate, because it looks like if I want to use RAID6 (replicas=3), I can't represent a device as having inherent durability of RAID6 (durability=3).
> > > > >
> > > > > It doesn't look like too much work to add a feature flag `BCH_FEATURE_durability_bias_v2` which when set, modifies the bias to unconditionally add one to the 2-bit field, mapping {0,1,2,3} to {1,2,3,4}. That would support even very large erasure encoded arrays as well, where you might use something like RS (56,4) for a common 60 drive JBOD. Practically speaking though I don't think anyone uses stripes that wide in a single array. At least not for spinning rust, but it's been a long time since I've worked with enterprise storage and I understand the rules have changed with flash now.
> > > > >
> > > > > I can submit patches for implementing the feature if you want me to submit them as a PR. Not sure about your stance on LLM-authored code though.
> > > >
> > > > Actually there's an easier way, which I've done a few different times
> > > before. We can extend BCH_MEMBER_DURABILITY to 4 bits (should be
> > > sufficient, no?), with the high bits going whenever we've got room in
> > > bch_member.
> > > >
> > > > Rename BCH_MEMBER_DURABILITY -> BCH_MEMBER_DURABILTIY_LO
> > > >
> > > > BCH_MEMBER_DURABILITY_HI for the new two bits
> > > >
> > > > Then write new get/set functions for BCH_MEMBER_DURABILITY that
> > > reads/stores from the lo and hi fields.
> > > >
> > > > But we'd still want a new on disk format version for this, and then use
> > > bch2_request_incompat_feature() whenever attempting to set a durability
> > > htat doesn't fit in the old 2 bit field.
> > >
> > > Do we want the new field to be additive after saturating BCH_MEMBER_DURABILITY_LO at 2, rather than treat it as a 4 bit field which could result in an older kernel seeing 0b01 and interpreting it as 0? So:
> > >
> > > LO    HI    VALUE
> > > # existing range:
> > > 00    00    1
> > > 01    00    0
> > > 10    00    1
> > > 11    00    2
> > > # expanded range:
> > > 11    01    3
> > > 11    10    4
> > > 11    11    5
> > >
> > > Then an older kernel will read any device with durability >2 as having durability=2, which is not ideal but I worry that durability=0 might result in undefined (or unspecified?) behavior.
> > 
> > No, just make it an incompat feature, it's way simpler - older kernels
> > that don't understand durability > 2 will never see them
> 
> Oh I see, an incompatible feature will prevent older kernels from
> mounting the drive. That makes sense. Do you still want to map with
> the 1 bit bias (mapping 1 to 0b0000, and durability=1 to 0b0001)? It
> seems like that would introduce the fewest changes elsewhere and
> ensure that a zero initialized struct behaves in a rational way. 

There's really no reason to change any of that
