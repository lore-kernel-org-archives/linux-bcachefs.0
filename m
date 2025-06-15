Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2277D5383
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750005179; cv=none; b=XscVveLLQgymObr8068+Pk7TqkOjtbc3kvyMQEqfeoooKP9skszxF9VOPulNWf3WscLpb5p0g9PWjeUAobfkjpKOm7DyrbhqY7WEtYyDaXhrsY/DfIoDn8cQZc4nSIUdQFTXEYiImlM6L1b0X2sMxLtzQbFhe8EmgJE7UukzkMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750005179; c=relaxed/simple;
	bh=AOD21H+Dnq6Pzo40U8WVWsvE42WzBUT3bILwZIOjAAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIDL6hqwUhh3KFjdsC5VHL4chy7pIFiN2v9gsolAkNRlivzxEfSBLcusBstmEO8ZB7P8u2VlLWRp+GQAGtFfPB/Kz+butVqJj89jR1Kjll3SKM94+/NqJ4FSYfK09/aXZHXQS+HmriRb3KbIY25niRrbf5rt+wZlhn5FaMFnH+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N+KJb3sw; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N+KJb3sw"
Date: Sun, 15 Jun 2025 12:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750005171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WZFk5RwwWg8akF2UkEbdgckWEbXPgt8BeF3WPRpsTmM=;
	b=N+KJb3swGMcumlKs6Ueju2mjJqf9L9xv6sUrbCd3eWSC5owKJirICLkeAaCCjmFN6o+Uf7
	gvjgYljoQCdzx2XIUe18v9ULW2ptaebBbhYYbIL7n28elznI4CyzHEX4aH8vqB6vZuezMn
	XM0U05s95Ndaz/7obMli2xO6D6xx24k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aaron Friel <mayreply@aaronfriel.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Message-ID: <6v4xbwoewpmrl7uga24yjvft4dpeis65p42vez7tgi7eiuqpbq@4qvl64d3bwq3>
References: <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
 <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 15, 2025 at 04:12:07PM +0000, Aaron Friel wrote:
> > > I'm looking to see if I can submit a patch to fix this, but it seems
> > > like the durability bit field for devices may be only 2 bits, is that
> > > right?
> > 
> > That gets you values of 0-3. Why is that not enough?
> 
> In bch2_mi_to_cpu, it looks like durability is encoded with a "bias" (default value) that maps {0,1,2,3} => {1,0,1,2}.
> 
>             .durability = BCH_MEMBER_DURABILITY(mi)
>                   ? BCH_MEMBER_DURABILITY(mi) - 1
>                   : 1,
> 
> This is pretty unfortunate, because it looks like if I want to use RAID6 (replicas=3), I can't represent a device as having inherent durability of RAID6 (durability=3).
> 
> It doesn't look like too much work to add a feature flag `BCH_FEATURE_durability_bias_v2` which when set, modifies the bias to unconditionally add one to the 2-bit field, mapping {0,1,2,3} to {1,2,3,4}. That would support even very large erasure encoded arrays as well, where you might use something like RS (56,4) for a common 60 drive JBOD. Practically speaking though I don't think anyone uses stripes that wide in a single array. At least not for spinning rust, but it's been a long time since I've worked with enterprise storage and I understand the rules have changed with flash now.
> 
> I can submit patches for implementing the feature if you want me to submit them as a PR. Not sure about your stance on LLM-authored code though.

Actually there's an easier way, which I've done a few different times
before. We can extend BCH_MEMBER_DURABILITY to 4 bits (should be
sufficient, no?), with the high bits going whenever we've got room in
bch_member.

Rename BCH_MEMBER_DURABILITY -> BCH_MEMBER_DURABILTIY_LO

BCH_MEMBER_DURABILITY_HI for the new two bits

Then write new get/set functions for BCH_MEMBER_DURABILITY that
reads/stores from the lo and hi fields.

But we'd still want a new on disk format version for this, and then use
bch2_request_incompat_feature() whenever attempting to set a durability
htat doesn't fit in the old 2 bit field.
