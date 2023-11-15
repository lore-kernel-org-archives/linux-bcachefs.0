Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DFF635
	for <linux-bcachefs@vger.kernel.org>; Wed, 15 Nov 2023 01:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jlzXZs1g"
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4CFD5
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 17:50:19 -0800 (PST)
Date: Tue, 14 Nov 2023 20:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700013016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JlmlR9bact57F7yoGB++Bt4Tn9Y4WQ7YxfOdRVRbdDY=;
	b=jlzXZs1gDUaWdL2fZMJ/NMX19l/Ho8bA+VqCkXNrLcFD+42RMwds4/MwFIT8ZbPFzMg0Vq
	iQ0rEmsFaHh9ALcHokEriAN0p0Eh/7sGNUznyxnfClPOSz27sTZlJs/gdaEJUddSSJZBTP
	c+OCp5doxpifREFB0lUehGbwop24/hU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 07/17] bcachefs: Make journal replay more efficient
Message-ID: <20231115015012.rq5r53jeuu2nbwql@moria.home.lan>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-8-kent.overstreet@linux.dev>
 <ZVNzyMRK6BHeEIiS@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVNzyMRK6BHeEIiS@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 14, 2023 at 08:19:04AM -0500, Brian Foster wrote:
> On Fri, Nov 10, 2023 at 11:31:44AM -0500, Kent Overstreet wrote:
> > +	/*
> > +	 * First, attempt to replay keys in sorted order. This is more
> > +	 * efficient, but some might fail if that would cause a journal
> > +	 * deadlock.
> > +	 */
> 
> What does "sorted order" mean here vs. when we sort by journal seq
> below?

Btree key order - so better locality in the btree.

> > +	bch2_trans_put(trans);
> > +	trans = NULL;
> > +
> 
> Nit: This looks spurious w/ the exit path, just FWIW.

It's because flush_all_pins() is going to internally use a btree_trans,
and we can't have two btree_trans in the same thread - I'll add a
comment.
