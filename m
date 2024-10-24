Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906617F7FC
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 01:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729735082; cv=none; b=V3ExR4f/cINLclC+s5VuMck3NdqBcOGP7XT2WKoay1NhRKeZFxywzq4cFpy5FGE+x8Lu/+voL8u6pOmaJnTcHD4oteP59V/U7SckJnTjjojALJJe9DmAX1CNudQ+bI84ptf6qkvvo7psQuzEJACg/yOhjiflyMEfByQ1pC+Nad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729735082; c=relaxed/simple;
	bh=qLPeCI08odMIXP7vd58+agr+Z3mKVGJHg3Nf1bF/jqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLxcV19TgbMjNdtuwHLB42rfuLTDXbtLWTQhHXYv+2KEMsmT/oXBoBI8HNqTaNd3XuQESl5FGuElvm7w01ef9Nsf/3skseQzWbZQ05m6wtvF2Y8eQsBZNu4/oEyLqVf2hlYaw8y9f+brHFbio/O909rFr1mUFlMZcUHLAx+uc9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tBVpuqjJ; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tBVpuqjJ"
Date: Wed, 23 Oct 2024 21:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729735076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CFjpqWrnqoG6+a4l76NLnie6w+aL1dRHD1BYLLkzmtw=;
	b=tBVpuqjJ6T97HwgXk1GDNcEiBoVra8jKjWvY+YHcv86Us+NyzkHU9aH8WU/4hm7kBDaDpK
	Kxw12Ld2abOBqM0t4v6BiAYHpLqsbmC4apKR3pejs+mcMNrcvcTxyxjRwcxCZnvcgV6cja
	O15cpAf+TR1UJTZfSxNVC43qd28Y4QE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [Syzkaller & bisect] There is INFO: task hung in
 __rq_qos_throttle
Message-ID: <kuvbuekbzs6saggfxleiaqtl5mleozqozpamivz2zo6pd4istq@c6hfl6govn44>
References: <ZxYsjXDsvsIt4wcR@ly-workstation>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxYsjXDsvsIt4wcR@ly-workstation>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 21, 2024 at 06:27:25PM +0800, Lai, Yi wrote:
> Hi Kent Overstreet,
> 
> Greetings!
> 
> I used Syzkaller and found that there is INFO: task hung in __rq_qos_throttle in v6.12-rc2
> 
> After bisection and the first bad commit is:
> "
> 63332394c7e1 bcachefs: Move snapshot table size to struct snapshot_table

You sure...?

Look at the patch, that's a pretty unlikely culprit; we would've seen
something from kasan, and anyways there's guards on the new memory
accesses/array derefs.

I've been seeing that bug too, but it's very intermittent. How did you
get it to trigger reliably enough for a bisect?
