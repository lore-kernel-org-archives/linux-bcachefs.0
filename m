Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163D8C121
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Feb 2024 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707090404; cv=none; b=pAOg2l0WvfqAxq6KneR2au2NMU4o0/27eGhm5vgMjgsjQf/0VUadYm25yiU+y1KfouIvSjQwTAYXytZPXKi9vvWhkGhjXZyf5CQYPaA5rlMiI3P2HhN3BNQLetVLtKPBdBdiywA8llgK8BS970PpTRGYFe6mbti6/wPGYFrioCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707090404; c=relaxed/simple;
	bh=0CmIxcVSEtfe4t1k55l3kodYCT7R1skf5R8s2gkFRjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geD9BUvnLjabMrjM00sHRIJZekyK4PfVi6yUCWZEujp6586KA2Cks2N/lSLAVYNPGh6y/DUIDhk6nnZsoIu1LyGkwjog0OcvRUCQM2ClseIYR2UpR/g5nw/OOykM2qfQw6F9Yjo4XofOillBhJ9PU9zfcr0DjF/tfs44C8SCOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xrqgt4Ox; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xrqgt4Ox"
Date: Sun, 4 Feb 2024 18:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707090399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jOJTLUvr6Asxg7KEqyNAfbpXxfGuH5pAaQQoGLGXVNw=;
	b=Xrqgt4OxdGd1K9yE1ncAFwAZ574Xg3n6CnGOTJKMQDG7dvlJS5NdYI/X90fEfkaUy6tyHK
	56N1UznFeTrmXgkVCMSnYCFPhSa6Ct4whSA4Mh3kPlkXSqCfaEtp+42pg08cNixcMH0HyI
	YmM6f4Y1rLWJuue3wdKS4jB2VNn5VYE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: install fd later to avoid race with close
Message-ID: <u2dylt3m7xymqtsgrqoqrbsbnmj5bgv3h6so35zwzgolazq22s@b3dk3zdesjuh>
References: <20240204075152.695920-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204075152.695920-1-minipli@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 04, 2024 at 08:51:52AM +0100, Mathias Krause wrote:
> Calling fd_install() makes a file reachable for userland, including the
> possibility to close the file descriptor, which leads to calling its
> 'release' hook. If that happens before the code had a chance to bump the
> reference of the newly created task struct, the release callback will
> call put_task_struct() too early, leading to the premature destruction
> of the kernel thread.
> 
> Avoid that race by calling fd_install() later, after all the setup is
> done.
> 
> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>

The fixes line is wrong, but I'll take care of that - thanks!
