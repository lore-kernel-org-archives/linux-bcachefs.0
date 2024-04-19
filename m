Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2124F214;
	Fri, 19 Apr 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713532338; cv=none; b=Ww9vPl00I4tkBuVMKQZXB4a0k/BniuS/qx3kjWSK88UsJP+eOTugFoGYlMe+uEDqlFU9qPU+vKShggXl7jXeJA2DwU6IYaT933cqUFvD+C37OFlwOXxDqwKDo5GyR+V9doFAv1GkCqll57tMB3utx+ErceICP7Bxb4jKUDl+tP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713532338; c=relaxed/simple;
	bh=LLHhKsPgaUq6jjBOifD2j6ATQ+4xYplY09f2hVg+SqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/p87odP12X+dMoKq52yoCS/EU3RKze1gfO3chPPqXYsxiYvxU00sj0IrwANrlZL9xeveTy/LVDPqA+IiMeDr3Mg0VMxpnv6kdbhx++R/pzfKQiRFgWqZKqCsrJ38ZaosPgOiKOluCR0LbIIXQhQzfJXUPzCyNJKayYtGsyBEmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0sBHJN19; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXf3BwBD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0sBHJN19; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXf3BwBD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0sBHJN19";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXf3BwBD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0sBHJN19";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXf3BwBD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 352B45D6F7;
	Fri, 19 Apr 2024 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713532333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gRUQmY+zTFLbDhdPnN9JYqdwMNywIx2NLL3xZ9/bCg0=;
	b=0sBHJN19cARBqVlEw4zBmsAZ98rYt7F+IIaxCjz152F5P8CUmQA/2ACzZ8m1Ig5YXt2FHZ
	lNCRSKQ3ipgYlXo2WmTFkN4kGi8dV3miOwpSoA8mMWq9YT1K2F7O7JL++He9gq0Oe/zzSV
	jejtJoiyYHWqsXe/FbTPf76fqlhI7pM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713532333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gRUQmY+zTFLbDhdPnN9JYqdwMNywIx2NLL3xZ9/bCg0=;
	b=OXf3BwBDCB8QUNbQ3lofpseinFvlmWqPVqemifXt827kyytgpIycs9xZXYpuysjGMvpkCO
	AKc6zFxVjRLd5yBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0sBHJN19;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OXf3BwBD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1713532333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gRUQmY+zTFLbDhdPnN9JYqdwMNywIx2NLL3xZ9/bCg0=;
	b=0sBHJN19cARBqVlEw4zBmsAZ98rYt7F+IIaxCjz152F5P8CUmQA/2ACzZ8m1Ig5YXt2FHZ
	lNCRSKQ3ipgYlXo2WmTFkN4kGi8dV3miOwpSoA8mMWq9YT1K2F7O7JL++He9gq0Oe/zzSV
	jejtJoiyYHWqsXe/FbTPf76fqlhI7pM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1713532333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gRUQmY+zTFLbDhdPnN9JYqdwMNywIx2NLL3xZ9/bCg0=;
	b=OXf3BwBDCB8QUNbQ3lofpseinFvlmWqPVqemifXt827kyytgpIycs9xZXYpuysjGMvpkCO
	AKc6zFxVjRLd5yBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 230331395B;
	Fri, 19 Apr 2024 13:12:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gzueBq1tImY7UAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Fri, 19 Apr 2024 13:12:13 +0000
Date: Fri, 19 Apr 2024 15:11:27 +0200
From: Cyril Hrubis <chrubis@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
	fstests@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Richard Palethorpe <rpalethorpe@suse.com>, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on
 Bcachefs
Message-ID: <ZiJtf07WGFJPb_w2@yuki>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
 <ZZvIBO-a1b_nIHJ8@yuki>
 <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
 <ZZ0guBd48WXYapPL@yuki>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZ0guBd48WXYapPL@yuki>
X-Spam-Flag: NO
X-Spam-Score: -3.97
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 352B45D6F7
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.97 / 50.00];
	BAYES_HAM(-2.96)[99.84%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Hi!
> > > Quite likely, other filesystems does have an inode flag that is set when
> > > file has been compressed and simply report that in the foo_getattr()
> > > callback. Looking at bcachefs I supose that we need to figure out if the
> > > inode is v3 and then unpack the v3 info to get to the compressed flag,
> > > you probably know best how to do that.
> > 
> > I'm still not clear how we want to map STATX_ATTR_COMPRESSED, since it's
> > extents that are compressed, not entire files - and just reporting the
> > compression option is probably not what we want since it can be flipped
> > off, and existing data will still be compressed.
> > 
> > Do you know anything about the intended use case?
> 
> As far as I understand the flag it's a hint that the file I/O may be
> slower/need more memory because of the compression.

Ping.

Kent we are getting closer to a next LTP release, are you going to add
the compressed flag support into bcachefs or should we add bcachefs to
the test skiplist?

-- 
Cyril Hrubis
chrubis@suse.cz
