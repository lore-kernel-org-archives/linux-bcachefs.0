Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BBF2233E
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqQN/RBr"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640BA10C6
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 09:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699895258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=77urqlNfM+qc0ZPe6lbJX3DQ6kZb0sVhjMKdplGPCVA=;
	b=EqQN/RBrT7u6+HydCYbuNKcw1NWnJ4KZHlf/OkjTJQv65lB1FTUSzEgwl0+YWBdjTgzZT3
	5NwYct986nQElrgwcH5vzeZp2PeBr/2A3N+B33sXZokGwgION0+o7JKHytM90tkSRrT9mw
	SC8PKP5WgdhiQNqEsZ1ilZGiK7TNwCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-SiHmUOHzNWCADCYEyebnYQ-1; Mon, 13 Nov 2023 12:07:37 -0500
X-MC-Unique: SiHmUOHzNWCADCYEyebnYQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A16AE812C27;
	Mon, 13 Nov 2023 17:07:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D26D492BFD;
	Mon, 13 Nov 2023 17:07:36 +0000 (UTC)
Date: Mon, 13 Nov 2023 12:08:15 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 03/17] bcachefs: Journal pins must always have a flush_fn
Message-ID: <ZVJX/0VV750MX8Yr@bfoster>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-4-kent.overstreet@linux.dev>
 <ZVI/JaW+btefRvj3@bfoster>
 <20231113163623.k4bi232ktfigu62n@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113163623.k4bi232ktfigu62n@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Mon, Nov 13, 2023 at 11:36:23AM -0500, Kent Overstreet wrote:
> On Mon, Nov 13, 2023 at 10:22:13AM -0500, Brian Foster wrote:
> > On Fri, Nov 10, 2023 at 11:31:40AM -0500, Kent Overstreet wrote:
> > > -		if (i->journal_seq > pin.seq) {
> > > -			struct journal_entry_pin pin2;
> > > -
> > > -			memset(&pin2, 0, sizeof(pin2));
> > > -
> > > -			bch2_journal_pin_add(j, i->journal_seq, &pin2, NULL);
> > > -			bch2_journal_pin_drop(j, &pin);
> > > -			bch2_journal_pin_copy(j, &pin, &pin2, NULL);
> > > -			bch2_journal_pin_drop(j, &pin2);
> > > -		}
> > > +		bch2_journal_pin_update(j, i->journal_seq, &pin,
> > > +			      bch2_btree_write_buffer_journal_flush);
> > 
> > Hmm.. I recall looking at this on the previous improvements to this
> > path, but I don't quite remember why I didn't make this sort of change.
> > The existing code implies a race (i.e., using pin2 to ensure the pin is
> > never fully absent from the pin list) as opposed to what _pin_update()
> > does (remove then add). Any idea why the existing code does what it does
> > and/or can you explain why this change is safe? Thanks.
> 
> Perhaps you missed it because journal_pin_update() could be named
> better? journal_pin_add() and journal_pin_update() have opposite
> behaviour when asked to overrwite an existing pin, I would like names
> that make that more explicit.
> 

Quite possible..

> But I don't see any races possible here: journal_pin_update() first
> checks pin->seq, and that's entirely under the control of this thread so
> we're fine, and if it overwrites an existing pin the drop and the set
> are done together under the journal lock.
> 

Yeah, I don't mean to imply there actually is a race. I just mean that
it looks like the old code took care to add the new pin before removing
the old for some reason, and I'm just curious what that reason is. ;)

Brian

