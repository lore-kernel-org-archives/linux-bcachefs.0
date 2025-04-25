Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E28525C700
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745596563; cv=none; b=VLTVxYE8agSkqpG8wH7o3hneA8/FQQynEsihjGDIuXFw3x9iK2YlVkw6Q9YtpmxxbFbcGxugNcxrpmhqWzGVb65hkamnbGbYrLm55icum9p2gjT9s6Bb6FDSrkDp8mx2Dxe4T4u8M4RBxEQ60Dec30Jd2qzfRCCBFidMwWwO9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745596563; c=relaxed/simple;
	bh=wVGqsGeNx4xQwM0TeprZL2WJ/ex6jFfXLq4tNJyU7Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhLrgmIVHiis8D0Jl2n8D9mfv2oVYjXC5RBY5VbJ4wcFjpZTo5LyliW9C/ATX++C2svazJvD8RC+8yOtHKf7BVGJsMVzKVE+4HP+RfLBtNTt9efvw8Q1/Hnru5PPCfVymcqxcJg+96opL71YdLbOp1rF76EK+7YA5jeRJj23DQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oWWN5itk; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oWWN5itk"
Date: Fri, 25 Apr 2025 11:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745596558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bubPXEsD3rILAfuSTv+RTzWWCJRxC61lwIV8QBH+9w=;
	b=oWWN5itkwAax1hsh1v42xunoFb1vIPIUXm8eEKddS2llXchLf2tgzIND847ROZAIXbOcoM
	ALmXyuxTeI7nkdYe8niDnz37ha9Mz83W/Avn0R3eEk61tHjtR94gxY8Owa7jXRQUwQ3Yvs
	ZlUdm55vWogxjkW6usTiFDNeElfIEgE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: g2p code <g2p.code@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Don't pretty-print options in /proc/mounts
Message-ID: <vl72cakwsj3pkvuhrflnxxz3e3pro3dxeua7uu72nglisxrhhy@6wey4nvc4ris>
References: <03c6436f10a17e4e520c611d8dbca0b5a56532c8.1745590098.git.g2p.code@gmail.com>
 <fd204ad5-b8bc-45aa-b761-fc2ef91abd27@gmail.com>
 <fbvjt2yfcjwyffic3f4k7fhdt2ag7vjilrwnbl26g3qjv27rly@7awwgxnljyex>
 <CAMxhh=6nbSL2Ygb92DOMSiSbgbzXiFn20iEu6OvZMoR47VJ+bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxhh=6nbSL2Ygb92DOMSiSbgbzXiFn20iEu6OvZMoR47VJ+bw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 25, 2025 at 05:21:46PM +0200, g2p code wrote:
> On Fri, Apr 25, 2025 at 4:38 PM Kent Overstreet <kent.overstreet@linux.dev>
> wrote:
> 
> > On Fri, Apr 25, 2025 at 04:15:18PM +0200, Gabriel de Perthuis wrote:
> > >
> > > Pretty printing of sizes could introduce spaces and break
> > > the expected space-separated format.
> >
> > we shoudldn't be including spaces when we print human readable numbers,
> > that's the bug...
> 
> 
> I did a quick check, human-readable sizes from prt_human_readable_u64 also
> lose some precision.
> That's fine for dmesg and other reporting, but there need to be easy and
> obvious
> way to get the values back losslessly, I don't think /proc/mounts and
> /sys/fs/bcachefs/*/options/
> should modify them.

Who's parsing /proc/mounts for the option values, though? That's
primarily for human consumption, we have better ways of getting at
that...
