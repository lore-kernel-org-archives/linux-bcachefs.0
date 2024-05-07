Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40F315FD0E
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 May 2024 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715095678; cv=none; b=Wg/8qjFTjLL8PrCd9VNgPj9E2FdrIIiv0vBCquZ9uufYVyV65eRYHdFPCUqtEjabjKpOdrtCoTDHbHwxJbm5nWVaqwuSElLf5h+e09Vyex8I0bPiJCXfAIfBe4c50IK+d6jKwJmzBJXI9C0OIoFbFSnYi1YiDqjzAbPhp03Cxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715095678; c=relaxed/simple;
	bh=JWTCLRwTKdxklZuNp/Rib1ejNmFkuPCcRX13xVhfOUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfpuJuQOLSDAhFSVCOHL8elfaCg95JyBnE8M8ZNkotkfbNKkrMw9IcCMTqbDxxWpfObTg/tSpRNgg3Rta68XppQ++CvQ2sianGzgTdDPa3BuNZq0tIci6OrhEo41P9VsQ1gr2j2FOnY4aX17ha6PeLIDqFs3waNrRsn1IYbqJuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wszb102x; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wszb102x"
Date: Tue, 7 May 2024 11:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715095674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FQYetRaj2G06vixmhegXHGRS3pEXWJu8nVuWoNZuM7w=;
	b=Wszb102xULBhRSoFDVFMM3bZC8z1Blu4ylS4VJLjcwEZikXgHEFMfRByHU6iAzpDejSFPJ
	xm/HQKXRQEkqpcoRP1tvBVjSXMlNFGUYYsVmFxA5lfULtLBYzuv1pOWaQXGshgqQFKMG8x
	FmA/ieRp1nfcXtCdT66rwrJnEeKoS1U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.9
Message-ID: <gqtaouixd7pmxyzttmyexwqzrziujo7ncqoc54vqhjqdnr326u@t5eolb2vdihp>
References: <3x4p5h5f4itasrdylf5cldow6anxie6ixop3o4iaqcucqi7ob4@7ewzp7azzj7i>
 <4u2imuisg3sxaomerwbss6p22vxyc2lk6esyn5asybytwgrhe3@tccxjeu5hqmq>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4u2imuisg3sxaomerwbss6p22vxyc2lk6esyn5asybytwgrhe3@tccxjeu5hqmq>
X-Migadu-Flow: FLOW_OUT

On Tue, May 07, 2024 at 11:10:44AM -0400, Kent Overstreet wrote:
> On Tue, May 07, 2024 at 10:43:11AM -0400, Kent Overstreet wrote:
> > Hi Linus, another stack of fixes for you.
> 
> I have a report from a user that the sb-downgrade validation has an
> issue, so that's been yanked.

As a followup: the sb-downgrade patch was good, the user had at some
point been running an unreleased version (which adds new accounting for
amount of unstriped data in stripe buckets); and that version generated
a faulty downgrade entry (because it has custom logic for generating the
downgrade entry based on whether erasure coding is in use).

But I'm still holding that patch for now while I come up with something
for that user's filesystem - I'll probably add a flags parameter to that
validation code so that we only fail to validate if we're writing out
something new, like we already can for bkeys.
