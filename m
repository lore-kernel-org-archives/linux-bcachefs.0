Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149D1E7C05
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Aug 2025 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754771890; cv=none; b=uBRnnxIhf787rvqGCz9fLbXXpy1v+DSbHhvd44ZH1ANMLTzk8UP5SWaLMmIENlXNydQ0Tg1VqzMqMxwfxrH/FCSV/UMePdS9Le+ai/44SH3YFB12/c8eUh4ay41vyxZUxx2bZgu823e7UiJBrV7WqzhYPVzXkJluHMGO7DOtTJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754771890; c=relaxed/simple;
	bh=sZgDLUIceb9be0h0ngV8e+sXSsmU2OGUiswsKtBY+NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCHVn808+XDIVqdqEgdkA4Cx5KYu/T2x7RK6bgEBBY3uCHNxwrUkf3kas4+MHHSguqH1M2bUajE3uAlfcjQmoaO7LzVUKPZoxDYs80fMFgNjR+pmbUY3MNEtFnS0MBtzitn9tGwEsDMIA8VJ5budyBgRMcBQ4TI+vDdlV9jkGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FVyZQuwM; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FVyZQuwM"
Date: Sat, 9 Aug 2025 16:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754771875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kStFxE7DFQgif82GUSMYwqRr+44VVaP8Wn9TTyEkclo=;
	b=FVyZQuwM0qH/U8n8sHbLXkpbSl9DFm6rd+ML+pTixhVW06QGYTApBrV6h2aE3qhXiIXM/k
	RvLOAYUZTj6qD3zu5TfICjbtPuahR5oeDV2nJjZ4hdrH2TOXoXyV/s6R9nzDUkG2la6W80
	oF7sdLNk9RdYZ62yjGctCFYGx66Htv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Aquinas Admin <admin@aquinas.su>, 
	Malte =?utf-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Carl E. Thompson" <list-bcachefs@carlthompson.net>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.17
Message-ID: <2z3wpodivsysxhxmkk452pa4zrwxsu5jk64iqazwdzkh3rmg5y@xxtklrrebip2>
References: <22ib5scviwwa7bqeln22w2xm3dlywc4yuactrddhmsntixnghr@wjmmbpxjvipv>
 <f4be82e7-d98c-44d1-a65b-8c4302574fff@tnxip.de>
 <1869778184.298.1754433695609@mail.carlthompson.net>
 <5909824.DvuYhMxLoT@woolf>
 <3ik3h6hfm4v2y3rtpjshk5y4wlm5n366overw2lp72qk5izizw@k6vxp22uwnwa>
 <20250809192156.GA1411279@fedora>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809192156.GA1411279@fedora>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 09, 2025 at 03:21:56PM -0400, Josef Bacik wrote:
> On Sat, Aug 09, 2025 at 01:36:39PM -0400, Kent Overstreet wrote:
> > On Thu, Aug 07, 2025 at 07:42:38PM +0700, Aquinas Admin wrote:
> > > Generally, this drama is more like a kindergarten. I honestly don't understand 
> > > why there's such a reaction. It's a management issue, solely a management 
> > > issue. The fact is that there are plenty of administrative possibilities to 
> > > resolve this situation.
> > 
> > Yes, this is accurate. I've been getting entirely too many emails from
> > Linus about how pissed off everyone is, completely absent of details -
> > or anything engineering related, for that matter. Lots of "you need to
> > work with us better" - i.e. bend to demands - without being willing to
> > put forth an argument that stands to scrutiny.
> > 
> > This isn't high school, and it's not a popularity contest. This is
> > engineering, and it's about engineering standards.
> > 
> 
> Exactly. Which is why the Meta infrastructure is built completely on btrfs and
> its features. We have saved billions of dollars in infrastructure costs with the
> features and robustness of btrfs.

That's great for Facebook, but you're doing everyone else a disservice.

The big cloud providers don't require as much reliability from
individual nodes. I've provided data in the form of bug reports and
actual user reports, you've provided no data on reliability within
Facebook, nor which featureset is being used (it's the multi device
stuff that's been absolutely notorious; Synology famously still uses md
raid to avoid that, write hole and all).

This is real, Josef. I've seen time and again how corporate development
works; I've been at Google, I've worked with Redhat enough to see their
model, and within the filesystem world engineering standards have not
been what they should be, and the wider community (i.e. the rest of the
world, not just the tech giants) is not being served.

COW filesystems were supposed to bring improved reliability over
conventional filesystems - it's been known for decades that "update in
place" is a massive problem if we want real advances in reliability. ZFS
showed that it was possible, but the common consensus in the user
community, among people with the data (i.e. quite a few of the distros)
is that btrfs dropped the ball, and regressed on reliability from
ext4/xfs.

That's common knowledge.

At this point in the development and deployment in bcachefs I can say,
with confidence, that bcachefs is changing that, and that in time we
will deliver _better_ reliability than ext4/xfs.

That's why my work has been funded, that's what people want, and that's
why I'm talking about it.
