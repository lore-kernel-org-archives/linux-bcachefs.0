Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9EB264604
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739224935; cv=none; b=jqINnxx1Oi8AkmkvVCUOAF/+SEObsczANG5Ttxag6HmHtbvi4DFJVL0/NdGh5zAkS9u+s+arD/jAwIeHzbBvYX2Ew+6SS7BDiZiXYqK7bGci2a6Q8+ZUCeAfOhzaoARCeZXSp7b23whMDrbAizsvEA5c1yW9pYU14N25uxaAx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739224935; c=relaxed/simple;
	bh=v7Jou80XWIaumxaVAzjs8fiRwlq3WxDTXOYt61Hpx6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EthQ+i2kTeawsex5tbm1hEhj23rpRz0nuY2k2gRZ1o/l3XASOhfGgnCnN66qGRMBL9EOliIt28QR1TGPDjzyuzjUy8jqAJinpvNmgjgC7dJ8kQecgEktIgP5+ZtYVqzeUMpDqRRst+eyP+rPYz3LMbvPwNZHzBBDeWi+uXAE+yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=axxMQEM7; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="axxMQEM7"
Date: Mon, 10 Feb 2025 17:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739224930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PzugTLV8GxDlfAODNuYU52WNCiZdinFyRbHR4yb6UBE=;
	b=axxMQEM7P98qIsdAtjXypRFRtqSUIKoAhmWPbc6JeZoqL43ypI4+Vubz/N43LsRLe9tL+c
	mILo/fw8MF2jBtyu0E6reoM9CFQf5/yK/j7+ucqdHfDodlMnLqREPeYQL3CcbEnCV/LXe1
	EYdlAgM5S20WFi+2VM8kOI+0CP+jBuY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use uncompressed_size as the operand
Message-ID: <ygtjzdwj66nyib4isphdz6qwxfogejsefkjt3bsxptzofxfsei@gxnvsbebfjdn>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
 <sspfmyovbhs3d5a66cs7eau3xxkiebtvjhff3kw7iauzwhnn2y@e2f4wklauoiw>
 <2423B2FF-40A3-4E4A-A254-E049431306A8@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2423B2FF-40A3-4E4A-A254-E049431306A8@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 11, 2025 at 01:02:28AM +0800, Alan Huang wrote:
> On Feb 11, 2025, at 00:25, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Mon, Feb 10, 2025 at 11:04:21AM +0800, Alan Huang wrote:
> >> Since we don't merge compressed extents, uncompressed_size should be
> >> equal to compressed_size, use uncompressed_size to clarify the intention.
> > 
> > compressed_size actually describes the intention better here, it refers
> > to size ondisk, and we're checking if the extents are contiguous on disk
> 
> But we don’t merge compressed extents.
> 
> There is is_compressed check above (below compressed_size check in the past as the history says)
> 
> Not sure if it’s my problem, but I spent hours before figuring out that we're checking if the extents are contiguous on disk.

You're also checking p.ptr.offset, which is the offset on disk...
