Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F81B672;
	Tue,  7 May 2024 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101426; cv=none; b=gi1FIOXv6dbY2y4ZJHvQ4AaTwvHX5nwzBBJ42NI3OWHxRjoBd9xyc5Ec6wIN58WpTBlueLJW0r7im00wq3ZEzgf+Ew87DfUgyBrJAojYbEeV5yLkpffE7wsHMkOvctHrJP1918rI7srq4zPZpYX2cU7K51559UGpWiEtuKY+Sew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101426; c=relaxed/simple;
	bh=9/6g6rTiwhnaq2SHTx0nCaltq1CiWrlxM+5f+KSoLr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rt3RdxGVhnFIsbg5eGu0kfCUGTE2mR72p29rPyFpCZToSmaPPqY67cTL88HMadEtg3K0VGaz6OCem0mGKd3zT+oe9LMO1XlYTGdgbZnjVKoDfl9KYGQz5iCkkFuS2Ui0F82D6rtuuEy3PCles22H0CRiTGl5oD9iblV3hrHwCxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hVdA1bJp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jqO533Fh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hVdA1bJp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jqO533Fh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hVdA1bJp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jqO533Fh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hVdA1bJp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jqO533Fh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6095F20DAA;
	Tue,  7 May 2024 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715101422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/6g6rTiwhnaq2SHTx0nCaltq1CiWrlxM+5f+KSoLr0=;
	b=hVdA1bJpYYghQGNLKSQyZBPUo2gFibNxOWHP3T/7CeLiaqfO7C1YISnWS4dgXqSocAEOZw
	Q/gWrgyTQsBPrpEmUyVhzckVjM2sT1s15n5rNLRaZSYFE8g+3yfqrDhUFZog5yrz0ITBYp
	swqQQn/chjocYzL1x5G/XDlPW6WB2/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715101422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/6g6rTiwhnaq2SHTx0nCaltq1CiWrlxM+5f+KSoLr0=;
	b=jqO533Fhsga/2OinLWLGjgqBeBoi+UnCQ4hbosl00r/eSWfzEetZD4gdcCC2K8kbl+XMFD
	W9zk4G/kVpySV8DA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715101422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/6g6rTiwhnaq2SHTx0nCaltq1CiWrlxM+5f+KSoLr0=;
	b=hVdA1bJpYYghQGNLKSQyZBPUo2gFibNxOWHP3T/7CeLiaqfO7C1YISnWS4dgXqSocAEOZw
	Q/gWrgyTQsBPrpEmUyVhzckVjM2sT1s15n5rNLRaZSYFE8g+3yfqrDhUFZog5yrz0ITBYp
	swqQQn/chjocYzL1x5G/XDlPW6WB2/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715101422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9/6g6rTiwhnaq2SHTx0nCaltq1CiWrlxM+5f+KSoLr0=;
	b=jqO533Fhsga/2OinLWLGjgqBeBoi+UnCQ4hbosl00r/eSWfzEetZD4gdcCC2K8kbl+XMFD
	W9zk4G/kVpySV8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0407A139CB;
	Tue,  7 May 2024 17:03:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UQAeNuxeOmbxdAAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 17:03:40 +0000
Date: Tue, 7 May 2024 19:03:31 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
	Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, ltp@lists.linux.it,
	Coly Li <colyli@suse.com>
Subject: Re: [LTP] [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on
 Bcachefs
Message-ID: <20240507170331.GF138935@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
 <ZZvIBO-a1b_nIHJ8@yuki>
 <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
 <ZZ0guBd48WXYapPL@yuki>
 <ZiJtf07WGFJPb_w2@yuki>
 <20240507081846.GA97446@pevik>
 <xlqa5l5si2mp3troac56tq7q3gansgi2fqs57rd2i2xrudiq34@iit2ymv4pzy6>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xlqa5l5si2mp3troac56tq7q3gansgi2fqs57rd2i2xrudiq34@iit2ymv4pzy6>
X-Spam-Level: 
X-Spamd-Result: default: False [-7.50 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_EQ_FROM(0.00)[]
X-Spam-Score: -7.50
X-Spam-Flag: NO

> On Tue, May 07, 2024 at 10:18:46AM +0200, Petr Vorel wrote:
> > > Hi!
> > > > > > Quite likely, other filesystems does have an inode flag that is set when
> > > > > > file has been compressed and simply report that in the foo_getattr()
> > > > > > callback. Looking at bcachefs I supose that we need to figure out if the
> > > > > > inode is v3 and then unpack the v3 info to get to the compressed flag,
> > > > > > you probably know best how to do that.

> > > > > I'm still not clear how we want to map STATX_ATTR_COMPRESSED, since it's
> > > > > extents that are compressed, not entire files - and just reporting the
> > > > > compression option is probably not what we want since it can be flipped
> > > > > off, and existing data will still be compressed.

> > > > > Do you know anything about the intended use case?

> > > > As far as I understand the flag it's a hint that the file I/O may be
> > > > slower/need more memory because of the compression.

> > > Ping.

> > > Kent we are getting closer to a next LTP release, are you going to add
> > > the compressed flag support into bcachefs or should we add bcachefs to
> > > the test skiplist?

> > Kent, gentle ping ^.

> Add it to the skiplist for now, thanks

Thanks, whitelist merged with your ABT.

Kind regards,
Petr
