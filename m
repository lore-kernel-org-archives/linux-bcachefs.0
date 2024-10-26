Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A457F101C8
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729901793; cv=none; b=ko3N4LQh5MDu207kzX1Otw9KUlJhvP+HbORupMF8tpkKt7qZGlEYvl66eStgDYaoRLFp5pQHJuffLtiQMcDGv8DvTO8oa19yXW5dfM8ffdCpQqBvxF9BkA6k3qeJM82g/bLhAJ1+AEyFu1f/yOVv+nxpR2RYET1EkN6W6d1Wt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729901793; c=relaxed/simple;
	bh=/q6mYPumxLMEvjS42sidS1mVtyYVrj6b1U7jbM+8hro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdFxfYQN9J2roTAiyj08XnawJTxuSvQmmZSkzt6NtPVfkUkbgPyZ70bAInNFp8kPvqOmibJEKlyhGVKi5k3+zuf/8J7FB2km4s3MEXE+vridY2p6NOZGo1kaRgxnBQZXu0fLQ0yNLH3rzCph7Qil5t9pn2o9fJLi3vNcAuhk6cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xZ9H4L7F; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xZ9H4L7F"
Date: Fri, 25 Oct 2024 20:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729901789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MQcQks05pR8c0e7hTYUF2oLSCrdVwTNMYWYjeMrrqtM=;
	b=xZ9H4L7FxXxLObC+fAhAxngco/dpfzvxFZgaT3QAhr6CVs7ldrMQr4tAKni6GQDECbSja6
	+IMiqRPYUlNuWb4Gq6zuYTUyjLIVQZd63FNDrGHfwX9pnxWrXsIAsOMv2PyVDk8ykHujSH
	38sgcdQG9znVZDuTdbXRt03HAMriuyo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Piotr Zalewski <pZ010001011111@proton.me>, 
	linux-bcachefs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, 
	syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
Message-ID: <6uve5q7c6o4bvuifa2klcwpussxpy5cvcjf2pqdezfuvneqjaz@kdj67a2ehnrf>
References: <20241023072024.98915-3-pZ010001011111@proton.me>
 <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com>
 <udcnrneobxa2nmwg47jrks6j67bsulaw7s43oldd5l3ge5wunp@r5rzrwwgzls6>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <udcnrneobxa2nmwg47jrks6j67bsulaw7s43oldd5l3ge5wunp@r5rzrwwgzls6>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 08:11:50PM -0400, Kent Overstreet wrote:
> On Wed, Oct 23, 2024 at 03:33:22PM +0800, Alan Huang wrote:
> > On Oct 23, 2024, at 15:21, Piotr Zalewski <pZ010001011111@proton.me> wrote:
> > > 
> > > Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
> > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > bch2_bkey_buf_reassemble.
> > 
> > It would be helpful if the commit message explained why k.k is null in this case
> 
> This code is only for iterating over interior btree nodes - k.k is only
> null when we have a bad btree topology (gaps).
> 
> Piotr, could you add a comment to that effect?

Actually, not just that - when this happens we should flag the
filesystem as having topology repairs, and possibly start topology
repair.

Calling bch2_topology_error() will do that.

We definitely want to log an error message, too; it should reference the
btree node we're iterating over and explain that it's missing child
nodes.
