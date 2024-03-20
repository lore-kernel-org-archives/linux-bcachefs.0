Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0A10FF
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 19:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710964524; cv=none; b=alLLvId8TaC50nv4Pf6vOUHr/KIgUSTnORRuiTPbK90WvXbFpNmBK4loW+q/zjuOg9ONhn4nI3PR7Nl/AD9Fac2KZ77O5uLkR5JV/4PUko/1CMvqHt2ZhRaumoC0ED8QyJYrDcrvXxXde13WqbYqe6+wGivA99hOt3rmq7ASXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710964524; c=relaxed/simple;
	bh=MX8t8C3yhqrEKb88JvtuU93OEo+yN4TgyirbPJUymd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRuKZGP6zI+F1KtDnhltjHWadc1GRF/yawvSxXVnKMZIRYKri3FyNL7CO7Jj0jLW4CdIwJFKsrjDyQHuIdPnC9cFHGoYcoLx/bQ5TzL+kPQ1wVOCcEw84lFfjcfAeRVXHlrn/MOhhoGf7fyCHvlGt16qL4qXxb3DMcnQE6HVCCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BVS7EUEH; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BVS7EUEH"
Date: Wed, 20 Mar 2024 15:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710964517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QsZDkeLFGLaFoaeiRmLzxRb54jibxXnA+V4w6033vBo=;
	b=BVS7EUEH1L7FiC9YMWOuZHEJUd003xPtq6cNSml2ucJOSJmk2Z35ZKsjGlsjox105abhX/
	ud9flmI+ExLuBqYclDN7wrtAVondrIE2E3t43yup6mbneeyuoZnJQnTNS5ELZj3D7cPZZj
	TtSK1mBd98jGfSB/7viY34X+Yqb2Eyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] bcachefs: refactoring of btree_path status
Message-ID: <6ji2r4vsxucyj6i6kfve2nwk5bmwozzevpr47jtnryzjb3ggrt@hyddohv2cia5>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <6njzwe66jtwnwg3ewxmop74iongp5nuqk2736ggatolqz4tbkw@mggb3ecmvpq5>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6njzwe66jtwnwg3ewxmop74iongp5nuqk2736ggatolqz4tbkw@mggb3ecmvpq5>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 03:43:44PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 02:29:21PM +0800, Hongbo Li wrote:
> > To enhance the code readability about btree_path structure, we did 
> > some refactoring on the relevant code based on my understanding.
> > 
> > Hongbo Li (2):
> >   bcachefs: use btree_path_state to represent btree_path status
> >   bcachefs: optimize btree_path status representation
> 
> you've got some things to look at here:
> 
> https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap

sorry, wrong thread, but post your git repo and I'll add you to the CI
