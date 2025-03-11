Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB91E9B2C
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707980; cv=none; b=Uvi14/849tXEN8FTpXER0XMRUF5LlHRRIFRXxtQGe5ey4oaWHmnQXPqHSzbJT+UTXXw2jWFlTcD385vWLfDBo4UlbZYpFiAA/xHEceyRx4j1e/f2Qu2/V+loYXqtYSHSdxFKJO1KGVFx5fWFiXgog+y/xRKfgEtCcYeyXMthPNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707980; c=relaxed/simple;
	bh=pn2vXfzCRWW+o+b5Er2ejRmco+jaub7vQm6EWgbRtf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBYoJue5dtUNk9Q71wsQ6dngNOZkcHbU/5pqEmx/ankDpPG3R83jtTGf8WjEvRO0OJxf5YNeMJKOQ59INplAgUqipQEnxt1l1y3fANI+2AXa5y80mEy1QmAQG3UKcSVpNywmn/hDCUqWUwoBlzPDDhXnKexFBdjTpVuZ6pwkNb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MZ7POKEw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MZ7POKEw"
Date: Tue, 11 Mar 2025 11:46:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741707974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji8thG6H59+4XjPu1zLzEfSGKmC6Uidb7JsRoGfOX3Y=;
	b=MZ7POKEwZeX2XKfRERaPHFZjR6RenLOgZdNwNkmIO52mqbMhnIpDWkEPZ9P/O6p0SnkHsr
	Jj6gn4LpGgdsCTm/GwCPavdAcPsdIr6Cpl+yQapC0Ac2FlpmBI9zN/J+rvATXsTD1UP8W7
	5WUGd9RUGYqzPMD7ChaDPRDepq+27xk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Help with bcachefs from a mentee
Message-ID: <uz2w3i2577xwiktgy2n5q7mjv5ua322yuy2l7kkj7cwir343hc@qyast7rsnakx>
References: <z6vR0lxi2JA9dGlQQLGuaSIx8l9D2izYNdkcKgZ0rA0a45LjIbeRFNCMB4lZdupN3PcV8Fhi0l4NmCQRKo_fDFaI_3Iswa1v2UxXA0bOVF8=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <z6vR0lxi2JA9dGlQQLGuaSIx8l9D2izYNdkcKgZ0rA0a45LjIbeRFNCMB4lZdupN3PcV8Fhi0l4NmCQRKo_fDFaI_3Iswa1v2UxXA0bOVF8=@protonmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 11, 2025 at 03:39:18PM +0000, Roxana Nicolescu wrote:
> Hi there,
> 
> I am Roxana and I recently joined the Linux Kernel Mentorship program.
> 
> As you probably may know, we must submit at least 5 patches to graduate from this program.
> I started looking at the syzbot bugs and came across bcachefs. I plan to try to solve some of those. I have to admit I don’t know much about the implementation, but I want to learn along the way.
> If you have any suggestions that may help me or if you need help with something specific, please let me know.
> 
> All the best,
> Roxana

Hi!

For syzbot bugs, I'd first start out by getting ktest up and running:
https://evilpiepirate.org/git/ktest.git/

Once you can use it to run simple tests, you can use it to run syzbot
reproducers locally:

build-test-kernel run -IP ~/ktest/tests/syzbot-repro.ktest <bug-id>

And join the IRC channel, feel free to hit me up there:

irc.oftc.net#bcache
