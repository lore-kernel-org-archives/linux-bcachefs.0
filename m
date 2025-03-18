Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D594D20D515
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321605; cv=none; b=BFVPZQhlJjPF8aywR456fKs65uYNo3BzQq7BnHbkvWdLLCz4ozkABqLFgDSiCY59xJVSdd8+yEWhCnGYqkLUsXELruM7JBd8RiH0zQVKpMvE64NcHkyfDCiSR5BOFnQYqAsMyn0ptIpMklmKBFl7/wEXttFpDR67r3hgX/4i0ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321605; c=relaxed/simple;
	bh=+Ka0GAu/yKipwXeABR9985DKVZA6fbyc6MxRi4bVEWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqkrWAV4o9gHfQZ1dovefAJDBaoWvtnC6sTW4qQlDkWwSt2tt860gLXROLZOlBOkx5On32uS47LSEhbal7mTfxYoQ45EG/HWoF0k5FhVuRv9vFybfFk+eeX4VrB7TjIS7YsyfDT9hDJPej/+SNesdXfagzTGOEBKY81bpxBH+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gOX/b0P+; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gOX/b0P+"
Date: Tue, 18 Mar 2025 14:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742321590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RyfZeJfC6tsJmRGtCCJpSJfM8TuGFOjQuz9+h4jER2c=;
	b=gOX/b0P+oEfwjmWGcToXYmnwjjqszisG1hsgTRtuEOMRIwbA5oYtSEbGFanoQ9iDZL3DU1
	NXOALpWk2pbrjwrILXRHc68y5yjKfEzW5kV8xhuVcwJoKKBZRrb0BGctjKw+Jt3ifvb+IB
	OdA32hZ2IARDAZTDf75zjn31xjvzgvE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <cwavlaeg6l46pxjw65hjjrz3xkjuwz5sprqe7rl2uftdot7l75@wnielzxhvcpd>
References: <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
 <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
 <t4zch7xnj5j3ifnivw3fkhkjpjldk2mozk3ouhogi224ntalab@3jjt2j6crbxe>
 <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9m3KSGxyt_HQ5oD@kbusch-mbp>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 12:10:49PM -0600, Keith Busch wrote:
> On Tue, Mar 18, 2025 at 02:00:13PM -0400, Kent Overstreet wrote:
> > It's certainly not in dispute that read fua is a documented, legitimate
> > command, so there's no reason for the block layer to be rejecting it.
> > 
> > Whether it has exactly the behaviour we want isn't a critical issue that
> > has to be determined right now. The starting point for that will be to
> > test device behaviour (with some simple performance tests, like I
> > mentioned), and anyways it's outside the scope of the block layer.
> 
> Maybe just change the commit log. Read FUA has legit uses for persisting
> data as described by the specs. No need to introduce contested behavior
> to justify this patch, yah?

That's reasonable, I'll do that.
