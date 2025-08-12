Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D66156CA
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Aug 2025 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755016028; cv=none; b=CUD7ZqaykZbyBVEPqD3Un/YteraP5qHNAf4d7cED86Bog4Cm8u4depCxm78nGD/XFWu+tV8NUUB/8w4BP+QqW4jW5R9UIXNA+mOnK4qaRjHse7vNtjBOJ4MExnhLlIp3TMgCHyDOYKmOdcwhB91vKDvsqLRQbDYjcnapqJHC/DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755016028; c=relaxed/simple;
	bh=LAikos5lzzdESsSEkmdS9LjgN97g2onbBh4FxE+a9K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTJfo6/LhBJWt3Tms/OwWnuZN8UtoCt0MszmPS5mVyvK0dZdBhe9niVV7c9ZeydiPyedwHCQdJczjQOcAWvCJA0f8zMFqDJb28s27yeI60VF+gt6J/JssKEZNTpRgO9tKT9yyEji81jXqKKceKjmiogxardTjoqFoLA3/XpeTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UFbCLI06; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UFbCLI06"
Date: Tue, 12 Aug 2025 12:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755016013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJlIa7B1GOmbF07zwobl79PO4S1K7t//me3rFoWJres=;
	b=UFbCLI06OvK2/xHzupsvhKVkZe8XtqTL4bGU8BnkMKF7I1SYwdyTyLQsKejAXoFIAQ5y0k
	pXxf249bH13IoZ3ivHTgoqzm/btr7F+eczN4IgKzxlvtvfOYTfRPjTo3iku7NozNm7SYcp
	CCC4RZtR95GoxhDr5JIkUA1YjBvEhXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Johannes Thumshirn <jth@kernel.org>
Cc: James Lawrence <jalexanderlawrence@gmail.com>, tytso@mit.edu, 
	admin@aquinas.su, gbcox@bzb.us, josef@toxicpanda.com, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	list-bcachefs@carlthompson.net, malte.schroeder@tnxip.de, sashal@kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: Peanut gallery 2c
Message-ID: <cijxbws4ngjmfj7chgz7pyjelc4lpz2uqqo655sc6rlyoai6og@ysy65pdg56fz>
References: <20250810055955.GA984814@mit.edu>
 <20250811154826.509952-1-james@egdaemon.com>
 <ct5pqur2cwn2gulxuu277uomoknflxae32zzpyf4yqbrxcxj4d@p5j77u6xks4l>
 <aJsIOj6jbPKayO0s@mayhem.fritz.box>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJsIOj6jbPKayO0s@mayhem.fritz.box>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 12, 2025 at 11:24:18AM +0200, Johannes Thumshirn wrote:
> On Mon, Aug 11, 2025 at 12:08:12PM -0400, Kent Overstreet wrote:
> > I think bcachefs has been a bit of a kick in the pants for them, they've
> > taken some stuff directly from bcachefs - e.g. I believe they took the
> > basic design of raid5 v2, the stripes tree, directly from bcachefs. A
> > btrfs engineer asked me and I explained the design at a conference some
> > years back [...]
> 
> Just one single mail and I will not reply to any follow ups on this. But I
> feel the need to clarify things as people have approached me. Yes Kent and I
> have talked about RAID. This has been at LSFMM 2024 in Salt Lake City. 
> 
> I can't remember if we talked about stripe trees, I only remember us talking
> about erasure coding, which Kent has done for bcachefs and I was planning to
> do for btrfs as well.
> 
> But the 1st presentations I did on the idea of the stripe tree have been Lund
> Linux Conference and Plumbers in 2022 [1]. This is easy to look up. In the
> beginning the RAID stripe tree didn't have anything to do with RAID5 and the
> write hole at all (this is just a nice side effect) but with doing RAID on
> zoned block devices and ZONE APPEND writing.
> 
> [1] https://lpc.events/event/16/contributions/1235/attachments/1111/2132/BTRFS%20RAID-DP.pdf

Thanks for the correction :)
