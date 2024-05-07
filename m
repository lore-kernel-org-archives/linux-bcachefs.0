Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22A2D796;
	Tue,  7 May 2024 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101821; cv=none; b=gfjZrSc1TuOsB0o2UbnS1+yLCqNbYbYT70i2fMLe/MAPjOcW/XVtnMCUQ1saoU8ndayrtucbpts16P/vXZDnfs7BiJpPA/PYNeudyNkvBBynda8qgAWi8GtbmBSy7sFQdULdUZt7w4SvbAw/dxGeBJwBs3K/LrFoaJyACD0NdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101821; c=relaxed/simple;
	bh=/c8AFSLV/1NL0Dd7ZkJwB0P3hG63sLt7CBqVz94VouM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBurz/mMPOSSAU9FaOFIl3Gs5ZbATggImhfUDkWSOaccu6xjqPFmQQo3MTI9ckLSbAE3C9hB6nfBvl8bKudjNJE06Fj6KJoEZFsfIRQQW9hsGfzZkSa94zUJuiivGzz8DDRyjSyomixfYpZatpB7oqTfpK40ENTtv6i+FouoMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i10UIPYJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tmU0IhJX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i10UIPYJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tmU0IhJX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i10UIPYJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tmU0IhJX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i10UIPYJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tmU0IhJX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 096593426D;
	Tue,  7 May 2024 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715101817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOKUnpatth1b1zUgcTKXKQo0PaAikCnEX/XiIcwXPY=;
	b=i10UIPYJ3ZmLyunyDrubyAmIvEa61/pnCdqu3K3SKh7ufcdyzFb6Wr8S8foOQKHAtGYtqm
	9ONWaYmz8d/JGw2F2w8WfaRBoUCattsZIASe8Q179rJWzW/RvSpbJuLRmi6ki67Ktj0DR8
	ygXKxMiJnod3WyLKAVfU9cHpDvVOViw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715101817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOKUnpatth1b1zUgcTKXKQo0PaAikCnEX/XiIcwXPY=;
	b=tmU0IhJXYWclpLSSqttKk1SNU0YtkckqxX0fUoQ2QovfaPNemPbMqTZTzlBF08kZOpkHU8
	YrDy6cVnbhTKwEDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715101817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOKUnpatth1b1zUgcTKXKQo0PaAikCnEX/XiIcwXPY=;
	b=i10UIPYJ3ZmLyunyDrubyAmIvEa61/pnCdqu3K3SKh7ufcdyzFb6Wr8S8foOQKHAtGYtqm
	9ONWaYmz8d/JGw2F2w8WfaRBoUCattsZIASe8Q179rJWzW/RvSpbJuLRmi6ki67Ktj0DR8
	ygXKxMiJnod3WyLKAVfU9cHpDvVOViw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715101817;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOKUnpatth1b1zUgcTKXKQo0PaAikCnEX/XiIcwXPY=;
	b=tmU0IhJXYWclpLSSqttKk1SNU0YtkckqxX0fUoQ2QovfaPNemPbMqTZTzlBF08kZOpkHU8
	YrDy6cVnbhTKwEDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD20D139CB;
	Tue,  7 May 2024 17:10:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FVEeLHhgOmZTdwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 17:10:16 +0000
Date: Tue, 7 May 2024 19:10:11 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Cyril Hrubis <chrubis@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Richard Palethorpe <rpalethorpe@suse.com>, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH 1/1] lib: Add support bcachefs filesystem
Message-ID: <20240507171011.GD157588@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231116135546.2599273-1-pvorel@suse.cz>
 <ZXHXxCRa31xO-Lo_@rei>
 <20231207175538.GA248849@pevik>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207175538.GA248849@pevik>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_EQ_FROM(0.00)[]
X-Spam-Score: -3.50
X-Spam-Flag: NO

Hi all,

> > Hi!
> > > bcachefs has been merged into v6.7-rc1 [1]. Let's add it's support to
> > > LTP .all_filesystems = 1 and TST_ALL_FILESYSTEMS=1.

> > > [1] https://lwn.net/Articles/934692/

> > > Suggested-by: Cyril Hrubis <chrubis@suse.cz>
> > > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > > ---
> > > Hi,

> > > this should be merged after v6.7 is released.

> > Agreed, although it's unlikey that they will pull bcachefs off from the
> > tree now. Any way I think that we should add the support to the next
> > release.

> Yep, now it's 6.7-rc4. I'll prepare v2

> > > So far I haven't tested all LTP tests on bcachefs temporary directory.
> > > I have only tested tests which use .all_filesystems = 1 or TST_ALL_FILESYSTEMS=1.
> > > So far it looks like there are only a few tests failing:

> > > statvfs01.c:44: TFAIL: creat(valid_fname, 0444) failed: ENAMETOOLONG (36)

> > That strange, that would mean that statvfs() reports possibly wrong
> > f_namemax. Looking at the code the f_namemax is initialized to
> > BCH_NAME_MAX in bch2_statfs().

> > And the dirent_create_key() does:

> >         if (name->len > BCH_NAME_MAX)
> >                 return ERR_PTR(-ENAMETOOLONG);

> > That does not look like there is any room for a failure. Maybe we can
> > print the buf.f_namemax value in the test and check if it's 512 since
> > that is the value of BCH_NAME_MAX.

FYI Unfortunately ENAMETOOLONG is still problem on statvfs() on bcachefs.

Kind regards,
Petr

...
