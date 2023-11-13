Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C01DFC6
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bTXfAhrk"
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [IPv6:2001:41d0:203:375::b1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72D7DB
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 08:36:27 -0800 (PST)
Date: Mon, 13 Nov 2023 11:36:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699893386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Httg05OX08jbFP6hCVlZ29bItSSI/HLDoJyO9ILLGJE=;
	b=bTXfAhrk7pIx5Rhy05h2zK1da6ZzsudhDNpWY1CMLuEltb6KEOlJOkg/6F79jDihTnppuM
	M61VeDn0txoKk+5Mg8n7DdINqGzlqhlpwfAFOqBT5bh1RpWchE7QyrBhjv7jEgAkB6ayNy
	zW3zWPI+mnFp+SRDoFHynogh5H0hvps=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 03/17] bcachefs: Journal pins must always have a flush_fn
Message-ID: <20231113163623.k4bi232ktfigu62n@moria.home.lan>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-4-kent.overstreet@linux.dev>
 <ZVI/JaW+btefRvj3@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVI/JaW+btefRvj3@bfoster>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 10:22:13AM -0500, Brian Foster wrote:
> On Fri, Nov 10, 2023 at 11:31:40AM -0500, Kent Overstreet wrote:
> > -		if (i->journal_seq > pin.seq) {
> > -			struct journal_entry_pin pin2;
> > -
> > -			memset(&pin2, 0, sizeof(pin2));
> > -
> > -			bch2_journal_pin_add(j, i->journal_seq, &pin2, NULL);
> > -			bch2_journal_pin_drop(j, &pin);
> > -			bch2_journal_pin_copy(j, &pin, &pin2, NULL);
> > -			bch2_journal_pin_drop(j, &pin2);
> > -		}
> > +		bch2_journal_pin_update(j, i->journal_seq, &pin,
> > +			      bch2_btree_write_buffer_journal_flush);
> 
> Hmm.. I recall looking at this on the previous improvements to this
> path, but I don't quite remember why I didn't make this sort of change.
> The existing code implies a race (i.e., using pin2 to ensure the pin is
> never fully absent from the pin list) as opposed to what _pin_update()
> does (remove then add). Any idea why the existing code does what it does
> and/or can you explain why this change is safe? Thanks.

Perhaps you missed it because journal_pin_update() could be named
better? journal_pin_add() and journal_pin_update() have opposite
behaviour when asked to overrwite an existing pin, I would like names
that make that more explicit.

But I don't see any races possible here: journal_pin_update() first
checks pin->seq, and that's entirely under the control of this thread so
we're fine, and if it overwrites an existing pin the drop and the set
are done together under the journal lock.
