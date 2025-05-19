Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B99D27AC54
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747666469; cv=none; b=OSEBi1uWvLuHNEod8dGIw96GP26x3rT1d6t/k1TxAfCP2wKZa3wI5r3u5cupq+qswYWrgR4l4o/8ivMf8KpODQ9xf91qc9IQ2f4xbI+88M08ieK+tLwSSk841XjcSfeKo/TBZaW/7zu4KUkt/vYO1Kk0IBIGp3Nu/1qMcXFEKgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747666469; c=relaxed/simple;
	bh=A2Vp0DqBAq4/qi4irOzEbKvzfiCLlU1eqMOMpcIL3sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YU73vfZB1BB3WtjDFke/3D6JqTN+ONDLiG7d6qimnTcCCIGLeqckjSe/I2HSA+Ek3EmF0ZOjGXJ4jvhZRSqPi7yGTJI1AoSNTKCB7chpcGFYstjX3i1oH2vuldu6+Maw4NzHo6iwWVfZVr+C6Iu32YQga+Gl/0ZM5KfpLpKYPJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qyYywlMH; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qyYywlMH"
Date: Mon, 19 May 2025 10:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747666461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wE16Hl4MTAV+/pRRGG2mwKfgntag08VCRHEZVjFWCnI=;
	b=qyYywlMHIhW/ky2+fcFxjliK9nYeAw5Ag/RRgS+IY9iUni0BPQ1OHoMoJhVI9STSVHlKxr
	+dceciVvlVwRmlY5+OIjOmuLL3ZRPkwAUy+7A2ptM8CZNAcQEh3prstwErHEsigNocPQnM
	/haF+u4yraZxv5D2jMH8GsRz1d7WacM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: John Stoffel <john@stoffel.org>
Cc: Malte =?utf-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>, 
	Pavin Joseph <me@pavinjoseph.com>, Martin Steigerwald <martin@lichtvoll.de>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: Status of rebalance and scrub support
Message-ID: <wqlurfdcgogbxneenl4dbu756x3qy5oez3thyp5ifjb2n326md@ixrcqjntrzc2>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
 <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
 <5890559.DvuYhMxLoT@lichtvoll.de>
 <dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
 <21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
 <qmuquecmaljpmmullubtsw2bflzspmtwp2u4ffdcrbvyoro6lh@arpwh7rlc5jl>
 <26667.17285.448393.277537@quad.stoffel.home>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26667.17285.448393.277537@quad.stoffel.home>
X-Migadu-Flow: FLOW_OUT

On Mon, May 19, 2025 at 10:43:17AM -0400, John Stoffel wrote:
> >>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:
> 
> > On Sat, May 17, 2025 at 02:21:34PM +0200, Malte Schröder wrote:
> >> On 17/05/2025 14:18, Pavin Joseph wrote:
> >> > On 5/17/25 4:11 PM, Martin Steigerwald wrote:
> >> >> So seems since 6.15 there is scrub support :)
> >> >
> >> > That's wonderful news!
> >> > Could you check if rebalance is also working in 6.15?
> >> >
> >> > Thanks,
> >> > Pavin.
> >> 
> >> If by "rebalance" you mean equalize the amount of data between drives
> >> (like btrfs): No, it can't do that at the moment. There is a thing
> >> called rebalance on bcachefs, but it does something different (I think
> >> it moves data between tiers).
> 
> > I was thinking about renaming "rebalance" to "background_data".
> 
> tier_migrate?  migrate?  

It's not just for migrating to different devices, background compression
is quite popular.
