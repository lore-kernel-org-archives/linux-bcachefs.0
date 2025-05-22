Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4E289E3C
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747913387; cv=none; b=kti3VJz/y1A9JckpsLsktGltUfgAA6NcP9LP5DqCEvImZRuun8HAhjnThroU1KoDVf2uUOIEi48P3ZON8Eh8h6qhA4ocQa9qd9eiATOLaEsTdgBRwrOtVEJO8jFmy7yo7TlQV32Tj2IzrlCWzqsAwlT6g5Zyyn8P1y1qLNGwnFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747913387; c=relaxed/simple;
	bh=UPIFn9N+1+QDNZcNA25KXvz+sMm80w2VxPa8i9qkuCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ly6zN6JI+7mCeIWJ+qvjlQOpFd+FCAYpl750OIrSib6vihkCKDRe86OhpBrFYGyeS8RBtwJf+BB05q8PEYbRDY+e3VQoW9cpjaNS5N0XBwxXvc5ThsZvfG1oCG7MoCy5x8awIItw2j2xMTWnORjb/O5FQcKZkO5nTABqfPggISI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O3Qiqb2o; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O3Qiqb2o"
Date: Thu, 22 May 2025 07:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747913382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D30c4LpbKJGTLV3TDgbPM1yl7EfEP9gR4/PJue8vafM=;
	b=O3Qiqb2oTyWCjy+2mmqUGHpQUwP6BkMOcfELHuASHOWiSQktk1CGwhXna+jFxOqNJcc5Q6
	2MGd7pHqhmhSEa9T8Ub/KpvZ7p5AmNSPC2T3/J7I7mK4HpsQebDcYLxO6sfzrNJCl/Rwyi
	V2jPLFBTqPjBlkh3gjjmkOmjdkEEE6M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Peng Fan <peng.fan@nxp.com>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>, 
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>
Subject: Re: error: the frame size of 1552 bytes is larger than 1280 bytes
 when building bcachefs
Message-ID: <oelk3icaqi6d4qpd2lymmybnk4ah7wwydz53zihxrhula2adfr@3dsd263tjibo>
References: <PAXPR04MB845954FBBF2AD810B17536138899A@PAXPR04MB8459.eurprd04.prod.outlook.com>
 <d8e9f098-49a2-4f1e-a6a5-7a6437658d93@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e9f098-49a2-4f1e-a6a5-7a6437658d93@app.fastmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 22, 2025 at 01:23:56PM +0200, Arnd Bergmann wrote:
> On Thu, May 22, 2025, at 08:39, Peng Fan wrote:
> > Hi Kent, Arnd
> >
> > There is below build error with "make ARCH=arm randconfig; make"
> >
> > fs/bcachefs/data_update.c: In function 
> > '__bch2_data_update_index_update':
> > fs/bcachefs/data_update.c:439:1: error: the frame size of 1552 bytes is 
> > larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> Right, I think that's been the case with bcachefs since the start,
> and I see it with allmodconfig as well, the problem being mostly
> CONFIG_KASAN_STACK.
> 
> There are a couple of bcachefs functions that have an unusual number
> of local struct variables in them, and KASAN_STACK adds a redzone
> around each one of them, further increasing the size.
> 
> When I add "depends on !KASAN_STACK" to bcachefs, I see all
> randconfig builds succeeding, but that may not be the best
> solution.

Post 6.16, all the bcachefs functions I know of with high stack usage
run with nearly the full stack available - they're running from a
workqueue, or they're fsck, so this should be a non issue - I recently
did some testing with max stack tracing usage enabled and our stack
usage looks ok now.
