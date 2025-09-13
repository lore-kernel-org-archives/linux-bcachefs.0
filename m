Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A01CEAA3
	for <linux-bcachefs@vger.kernel.org>; Sat, 13 Sep 2025 04:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757738575; cv=none; b=liydoffBfoi0SfasmvMLSGqsrXeAl6oglJqFCfkPqaceW4M72+XSdftOL5tZbxfbfeFKvi50zvVCfD0t3k3wpvOG+PTlAFgnVafP9oRWIJ8gZygSM87z2MPIOYo/80Gp1jv55OWVciROeozyFdLpwNDu9ZZtGl0qWZ35/rBshS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757738575; c=relaxed/simple;
	bh=VBp4FsGVb7em+jqHbqCzp3mG12hupJDhDSk9zZq6nTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGYt1ANoa+QpcpyPkf/bPWzAZpsh9/vXsNwit3EUEp64cUx2twupZH/t0VEzPBs78IJTdXJOaoq33UQ8HC8nleiVNVRU2kNBvzEcKcd5ghcFO7GBBQgJF977mFbHBFuXhFQGT2AIc5nIXX3YGHdrDxOTs1PFA1Q26e8KRCSMs8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sxhlHh9H; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sxhlHh9H"
Date: Sat, 13 Sep 2025 00:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757738570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvISeGyJOstQeTBz0ivY8lwBZQMmoD9Ij0MAod9SP3Y=;
	b=sxhlHh9H8Ag14Jikjsd0JWwWRKxF9tyzDFEidyKdnQcG9HsWrmuGzw+lVuoJV9L3lSrkmp
	j9zidHpu4bVKHt7Oj2ETjk0pjximPsuk/QCQMO1ZBOCqeCtd4q+EAP7LR1nGmyBIcsmmW7
	UG6wiARgJsqL7z+dIUPJgnkArSMr8Fo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Upcoming changes for bcachefs; notes for users distributions
Message-ID: <5tle2holwzznjhuqvpplyemh5ykwsjamd4cypf2wahyyyu2mca@263qi2bnoeiq>
References: <yokpt2d2g2lluyomtqrdvmkl3amv3kgnipmenobkpgx537kay7@xgcgjviv3n7x>
 <238333e2-79af-44bd-8481-7d6c71d42537@kabelmail.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <238333e2-79af-44bd-8481-7d6c71d42537@kabelmail.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 12, 2025 at 10:37:16AM +0200, Janpieter Sollie wrote:
> Hi Kent,
> 
> At 12/09/2025 01:19 Kent Overstreet wrote:
> > - My git trees are still there, and I'm going to switch to basing them
> >    on .0 releases. For people who are comfortable with compiling kernels
> >    or want to avoid DKMS hassle, this is something to keep in mind.
> I'm happy to read  that, I've always been a fan of "trim unused exported kernel symbols",
> If you want to boot directly from EFI to root, skipping bootloader (I do),
> this avoids a mess as well.
> 
> However, for vanilla 6.12 LTS kernel the situation is not clear to me:
> Bcachefs is marked as "Experimental" but "Maintained" in 6.12 tree.
> Will you still be able to post bug fixes to Greg in the 6.12 code?
> Are you even supposed to do that for an experimental kernel subsystem?

Note that while we're experimental, I've only been doing backports for
the absolutely critical bugs - 6.12 has not been supported for bcachefs
in quite some time.

There's no rule one way or the other that I know of, it's just been a
bandwidth issue with the sheer amount of bugfixing going on.

But, bugfixing has dropped off dramatically, and we are getting close to
finally lifting the experimental label. So we can start to think about
what LTS kernel support will look like soon :)

DKMS should make that easier, too. I have a plan for multiple release
channels (that don't lag nearly as far behind as LTS kernels), but I'll
write that up when we're ready for it.
