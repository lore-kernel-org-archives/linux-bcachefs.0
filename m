Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746F18F48
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708042357; cv=none; b=IClxCxWMb1pDWlVuVSvnLNe265/jmb+yqclXH5ifIB1fq4Bi6dAdRgP+L9sTAomlxEHqaRKjiomFjFYQH8LfkBHUVDcK3i+HBFVx4sqDo20o+yxKYPORfWxiYVRRIwaiaCyQ5o5Rmcd/GSes1EL8gcEU07xPr+ty1ZejnDDD3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708042357; c=relaxed/simple;
	bh=btH+x+zgv1i+4cP4GSCL7+/bLY284jtfDy+/066gU5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbGg0qauRFR1NJmnfGGhb5rCmfl30GH+2TjVMR1X/kUm3XId7c20nPDKzWkQ764gu32IAvca4mssHf6ztkTtROU0kGmomPLcKlgTSMBm4GhlB9X1nwVXVwS/qS/z7RCnpanvFG5d3YbXAaMt3IOLbLRsehx/9jlYbSlw0wQRbVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lPlCCMhD; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lPlCCMhD"
Date: Thu, 15 Feb 2024 19:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708042352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WUrOfM73hGDwiZ1AOs0jxgvXnaBsbU/tev3IMzLSYPc=;
	b=lPlCCMhDe3Zw7om2eaIDQ3t93iciZwYC5PoMLsdsSOl8tj/b1Ba5PvsyxgiujPAkOnA0q4
	6D9BqmLVv4A/FuLkvzOsYL1aq1IKpWuYiAVPGoL0Ft8UwKeel1A1If+i/8oiBuew0xhV/i
	RyM0p60ZiEwUygNUNnZvl86kS1RoNgA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: omit alignment attribute on big endian struct
 bkey
Message-ID: <gmomwwrdeeqcj27w3lnkpmokzqkcmviamfiaaufo7k2jjvgden@jayzma4ry53k>
References: <20240215161957.112262-1-tahbertschinger@gmail.com>
 <Zc5IgMloeK/XkXR+@bfoster>
 <20240215180222.GB81623@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215180222.GB81623@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 11:02:22AM -0700, Thomas Bertschinger wrote:
> On Thu, Feb 15, 2024 at 12:23:12PM -0500, Brian Foster wrote:
> > I can't really comment on the Rust context, but could you add a comment
> > to explain why the ifdef is here? I.e., even something as simple as
> > "Rust disallows packed and aligned on ..." is useful.
> > 
> > Brian
> 
> I'll work on a v2 with an explanatory comment.
> 
> > Also out of curiosity, is there some reason these two attributes
> > together presumably isn't a problem for LE?
> 
> The root of the problem is that rustc won't compile types with both
> packed and align attributes. However, rust-bindgen tries to be helpful
> and when generating Rust bindings for C types with both attrs, will
> avoid placing one or the other attribute if it can do so without
> changing the type's layout.
> 
> For LE, the "packed" attr is unneeded because the struct is "naturally
> packed", but the "align(8)" attr is needed because the struct's natural
> alignment is 4.
> 
> For BE, the "packed" attr is needed because there are some members that
> are not aligned (e.g., `size` has as offset of 23 but wants to be at
> 24), so rust-bindgen cannot omit it. Thus we have to remove "align(8)"
> to get a type that rustc can compile.

Specifically, when i was designing bkey, I wanted the header to be no
bigger than necessary so that bkey_packed could use the rest. That means
that decently offten extent keys will fit into only 8 bytes, instead of
spilling over to 16.

But packed_bkey treats the part after the header - the packed section -
as a single multi word, variable length integer. And bkey, the unpacked
version, is just a special case version of a bkey_packed; all the packed
bkey code will work on keys in any packed format, the in-memory
representation of an unpacked key also is just one type of packed key...

So that constrains the key part of a bkig endian bkey to start right
after the header...

So if we ever do a bkey_v2 and need to expand the hedaer by another byte
for some reason, that would clean up that wart :)
