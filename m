Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49D310E5
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Feb 2025 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738954601; cv=none; b=gXrUWpVbfdk40PjHVez+NsPWtGDgfBv0VPE2iG1chzyxtSVGE6y6z5LWfDXlEtAkXZ3LJg4r+oBAZ+K9yoxcTiCsQETIiEgeXuhsiiIahwrrz2+xF03xWppPZxKGQUqAV+Fmnd9ayjzSbdYezQZfdBTvnumHN67o/uZHQu9EAjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738954601; c=relaxed/simple;
	bh=diQDvFQSa5BnXCI9tgexajlSRSDIGloEhyAl60SeKRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4bLmJAxEhwReYWVfcHemG3OCWFxCLtmoTYdrAqdkBB+oJWM8rYHiERiqwgWAzNQAsDg2ml/VuXjZGNMEeOX+X5mY1I+sRSkYuKRPzNspWFzwmQRNYxw9ql1irTM72tqnBunepqDEAkOM+cSKOoWmP3YQMxAY5IJFdpQYLT7L8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oKrXbU/R; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oKrXbU/R"
Date: Fri, 7 Feb 2025 13:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738954597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0rfBfBAKcaBSLSzO0nBsO8xfuNf2sHer376XnOxUvrE=;
	b=oKrXbU/RNJB7degHWZXR6m0T3c9ZwA07nmLfWjl2hjsfnBO37kr8FVMqSxCc3GIwn3FmOG
	GK8QsLlcu04CunTDUbhuwZb5VvmyxkJK9dq0mYYhRXmbTPQeQWpMHXAkrVaA+kxglt12Mi
	lSr4hx9PY6mT05tj3Jv+qoMmWezxrvc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/21] bcachefs: eytzinger code
Message-ID: <yoxmbxirfwr6tpl4lp3jnnb26ef3omhjna5b7p4d6522xvmnco@3eajr5hkfmhp>
References: <20250128163859.1883260-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128163859.1883260-1-agruenba@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 28, 2025 at 05:38:37PM +0100, Andreas Gruenbacher wrote:
> Kent, to continue our discussion from last November, I've gone through
> more parts of the eytzinger code and as a result, here are some patches
> for you to consider.
> 
> What I've not looked at are the eytzinger_to_inorder and
> inorder_to_eytzinger functions, as well as the implementation of sort.
> Those functions could use a bit more documentation, but the code iself
> looks reasonable.
> 
> 
> Shuah, I've also had a quick look at converting the tests into kernel
> selftests, but that hasn't gone very far because of the lack of support
> for basic functions like __fls(), __ffs(), ffz(), and
> rounddown_pow_of_two() in selftests.  Are there any plans for making
> those kinds of primitives generally available to selftests?

Ping on this patchset - can you throw up a git repo that's ready to be
applied directly, and have you run the test that failed yourself to
confirm the fix?

Also, I'll make an exception for this patchset if need be, but fyi:
in the future I'm getting out of the game of running tests for people.

Either run ktest locally, or get redhat to chip in on the cluster and
I'll give you CI access (and I highly reccomend that option, it'll get
you quick feedback with a nice dashboard and you can use it for non
bcachefs work as well).
