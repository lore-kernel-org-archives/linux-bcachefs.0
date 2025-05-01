Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6379C0
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 May 2025 03:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746069106; cv=none; b=UQqaYdBe9si1wyRQsTd8tCzg3g2MA2oIKzsSLCqZgBEhaL5oRD/aZkz5tgyh7+99Jml0piZWmkZ5+xKPqlyY6ONwMVj1YRKG/+gWfIugMCi92fPR3KLsTfjNVWq43zmZCwANkY0RlsGaBVuslyGCAPoiGFsGybWV29RgoX/H0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746069106; c=relaxed/simple;
	bh=7khwD9zpUcBSuTbQLLJi+PXraV7hpZFehlDxNcwN32U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpo3loU9fcDUntv9dOd6/RN7jLicEdSTANiaxD2CahGgAmfOZPApVR4QsOV4byFJ64G+My6wEbVsFSfL/90v/w8LONvfTkh7SHv6Z9GZ6XKlAL0O3yROmbbxkBdaQLwN/ty7LsiiMqrO0DZtD/gNdlSYCCHXUlLoAW45NRfrY3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RilV/1Aa; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RilV/1Aa"
Date: Wed, 30 Apr 2025 23:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746069099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOVXkRAnlkTfLIOI7aDoNf7o3WKrMGuwkdDG/cGMJ1w=;
	b=RilV/1AayixcmLUL7C0y5gXXVMe9suPC8A8CZ+/RzYhaMvMm5mGElyvVL7W4rG+CSnTtMX
	C/FQHK+fGF3jgS+oXZiLJIICDRFcRjzlN3jzlTHlDDTArSmzRTTTgwCsCsanH58l9w1Ofd
	WEWcPQMYbeNvFAg6puKwPIJx4AvsOHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <h3lt736royh562shwlau3kpjmydq5575oilp2sl23aash6gj3x@rw4gn4r2thcy>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <20250425195910.GA1018738@mit.edu>
 <d87f7b76-8a53-4023-81e2-5d257c90acc2@zytor.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d87f7b76-8a53-4023-81e2-5d257c90acc2@zytor.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 30, 2025 at 07:48:20PM -0700, H. Peter Anvin wrote:
> On 4/25/25 12:59, Theodore Ts'o wrote:
> > 
> > Another use case was Valve who wanted to support Windows games that
> > expcted case folding to work.  (Microsoft Windows; the gift that keeps
> > on giving...)  In fact the engineer who worked on case folding was
> > paid by Valve to do the work.
> > 
> > That being said, I completely agree with Linus that case insensitivity
> > is a nightmare, and I don't really care about performance.  The use
> > cases where people care about this don't have directories with a large
> > number of entries, and we **really** don't want to encourage more use
> > of case insensitive lookups.  There's a reason why spent much effort
> > improving the CLI tools' support for case folding.  It's good enough
> > that it works for Android and Valve, and that's fine.
> > 
> [...]
> > 
> > Perhaps if we were going to do it all over, we might have only
> > supported ASCII, or ISO Latin-1, and not used Unicode at all.  But
> > then I'm sure Valve or Android mobile handset manufacturers would be
> > unhappy that this might not be good enough for some country that they
> > want to sell into, like, say, Japan or more generally, any country
> > beyond US and Europe.
> > 
> > What we probably could do is to create our own table that didn't
> > support all Unicode scripts, but only the ones which are required by
> > Valve and Android.  But that would require someone willing to do this
> > work on a volunteer basis, or confinuce some company to pay to do this
> > work.  We could probably reduce the kernel size by doing this, and it
> > would probably make the code more maintainable.  I'm just not sure
> > anyone thinks its worthwhile to invest more into it.  In fact, I'm a
> > bit surprised Kent decided he wanted to add this feature into bcachefs.
> > 
> > Sometimes, partitioning a feature which is only needed for backwards
> > compatibiltiy with is in fact the right approach.  And throwing good
> > money after bad is rarely worth it.
> > 
> 
> [Yes, I realize I'm really late to weigh in on this discussion]
> 
> It is worth noting that Microsoft has basically declared their "recommended"
> case folding (upcase) table to be permanently frozen (for new filesystem
> instances in the case where they use an on-disk translation table created at
> format time.)  As far as I know they have never supported anything other
> than 1:1 conversion of BMP code points, nor normalization.
> 
> The exFAT specification enumerates the full recommended upcase table,
> although in a somewhat annoying format (basically a hex dump of compressed
> data):
> 
> https://learn.microsoft.com/en-us/windows/win32/fileio/exfat-specification

Thanks, I'm adding this to Documentation/filesystems/bcachefs/casefolding.rst
