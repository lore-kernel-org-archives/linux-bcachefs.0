Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3A264624
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 22:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739226080; cv=none; b=cnJl8jyHObRWyRneocj7EW7AQFiuD5I37iw6ijB8VFab5aUZAIHJ0Tlbl0zkYvolL3AWae8wf/lYAqNb2G8BaiedioFvlL0Ikls5RZMCJ1N/6iijG4yoJlQHp3ywfQPeuDw7LaMDDhF1Nm0VuAQsiWfYJZ41PTr1rZSzV2MpTQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739226080; c=relaxed/simple;
	bh=+rNahKcWM2raCUBQ3OPTLZdoH1azoBTKV4zp0vB0kQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqcfnSQuedxyZ4JUUSrFZHAm2iJNBSE4RRyw7ua/dpWw2CeuhUcH4y6/uCnQ5evKIuHlPu5SeevvCTbcnmYVCqhxwNDAgT6VBHH7vYVlvUDtOhCaTyO2I54fGy1P6q9gx2E8aCvJdqjmUoxRzLnxcGgkwEA/R3akiifSu6SBmqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jq17BAUk; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jq17BAUk"
Date: Mon, 10 Feb 2025 17:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739226072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfc+JQKGpgw2R13XjZygwNbf06+FMRPPQaT9HnKp3XY=;
	b=Jq17BAUkjKGuN2DVn9qY/jmQY7vIDExHSw/gET0+ZavfFrlQyu79ArZIu5RpJaHNwl+wsc
	el2QfA8+xWaSz/oEw4hHDI4BRPRuoWYhw8eHpBKWg92VUzWJzOR4KEZHtUBKD45tpKmtZd
	NoJ6NQIg/JzjMe1C3x1tBrOSGLiI9RU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix use after free
Message-ID: <d3c4pq4edyhmqwupo7taput6g7vchqehjseokydi7ya56z42rb@23tgjzvnojjr>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
 <20250210030422.711912-2-mmpgouride@gmail.com>
 <glle55a36q4zzr72fa7a2n7gkp6z6xq26usmuxrojwlyctfxz7@mzhqlaumf64g>
 <65D10A49-9A37-4844-9DE7-838205FF375C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65D10A49-9A37-4844-9DE7-838205FF375C@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 11, 2025 at 12:54:29AM +0800, Alan Huang wrote:
> On Feb 11, 2025, at 00:28, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Mon, Feb 10, 2025 at 11:04:22AM +0800, Alan Huang wrote:
> >> acc->k.data should be used with the lock hold:
> > 
> > <snipped>
> > 
> >> 
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> > 
> > 
> > Test this with lockdep (you know how to edit the lists of tests the CI
> > runs, right?
> 
> The lockdep test group is in the tests lists.
> 
> Or you mean add tests in the lockdep group ? 

Ah ok, you're already running them - I'm applying this.
