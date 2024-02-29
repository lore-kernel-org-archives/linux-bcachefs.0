Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D9012FB0B
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 20:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709238387; cv=none; b=ji7IziynoX9vXmIFvjF1I3FGvFdzsunUrN3mPaMc6F8/2r4XruVJ/2qlk3/jwNWeZs+m0X8x2Tto4HjP9sr6r3NbkWmjrAMP5y5OO/PCzQ9C1yQWN9MmuRwkmBi9yF8PtG82wnagjHbyHVh7+5P+r7jHGARMn9Ee5wtyHCfGXXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709238387; c=relaxed/simple;
	bh=bZpOZNaNI+kMHGjLwjAkymlrcRKJJ4cSsUicdCAFdw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDtFtpnj8OEhRARljp8G90kQbfi6XsKWdX12CFSliAYsFFZtNqwnaYViXbDNHkB93SMi6MY44yiXA7bmoMhpntaABMvakf9ctLTWXBDh7S+39qlmBuvoyNl5SOQtNrOx6L17CDROP0A7CWa/hTDCIX69DY7i3zw+Q/l9CClvkPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wkbLIYMX; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wkbLIYMX"
Date: Thu, 29 Feb 2024 15:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709238383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=59xfnzaRBGzWl0NDIk5POdTDk0znqRfb5ezAxFcFR6M=;
	b=wkbLIYMXLMKyw1Y09cQr0CqM2thwpYfMuiXmGkn2g3Iq0SN6N2mxxh2QTqp/FCgG2X0/kW
	8sgANbBxQ8zQ8w45ZP1Z6ym117Bm0kvWRaWvCwEe/7ZSnFqQ8sfCEYQ0LpzcPih7XIiW0U
	PtjZm3Z3JqqFnp16LDyf0xv4O8+Dg7I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Sebastian Arnhold <sebastian.arnhold@posteo.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Status of scrubbing
Message-ID: <2wz2ukvmy3yyvslyszr5uhexhcplwddpsx7lplsshlgivmatci@nknavdyrq4c6>
References: <FHWM9S.CKVFWC3SVV473@posteo.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FHWM9S.CKVFWC3SVV473@posteo.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 29, 2024 at 08:20:03PM +0000, Sebastian Arnhold wrote:
> Hello Kent,
> 
> first of all: Thank you very much for developing - possibly - the next
> generation filesystem on Linux! :)
> 
> I have a question. I'm building a homeserver/NAS and am thinking about using
> bcachefs in RAID1 for it. Sadly, there seems to be no scrubbing function
> yet. I would love to use bcachefs in a way that it would detect any bitrot
> and then auto-repair the file from the known-good copy.
> 
> Can you give me an update on the status of scrubbing?

Todo list item still; it'll still be awhile, since right now I'm
focusing on disk accounting and snapshots stuff.

But I will take this as a bump :)
