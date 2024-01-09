Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3F13FE0;
	Tue,  9 Jan 2024 10:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jvkffs1h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="D1QEvop2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jvkffs1h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="D1QEvop2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 329A01F7F6;
	Tue,  9 Jan 2024 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704796321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOn5eJ+geO/Iv0b3t0P8rCWcuO2Y7FAKYPtyb8WT6M=;
	b=Jvkffs1h3ZCOgnV+v4rOYd0nDkiMbWnKuqCXkOKj2KatsdD0uGvxuU0DbUlaJg23DmRFl7
	mhHK+rKb2lmWx5AONisJM10Oo2b/ZqT1X6tqPC3NFyWFyvjTLDyHVkDo9n6an2+u0KphFa
	di1mlnkd9u3T04oeC5zbEci2KuEuKDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704796321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOn5eJ+geO/Iv0b3t0P8rCWcuO2Y7FAKYPtyb8WT6M=;
	b=D1QEvop2sHGWz1+93W6SHiqIFVe67oF1z3KLgAXlBUVKaKFrt/XwlgnFYgndq8RXRYOQ17
	13Bc3C2e8/QslVCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704796321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOn5eJ+geO/Iv0b3t0P8rCWcuO2Y7FAKYPtyb8WT6M=;
	b=Jvkffs1h3ZCOgnV+v4rOYd0nDkiMbWnKuqCXkOKj2KatsdD0uGvxuU0DbUlaJg23DmRFl7
	mhHK+rKb2lmWx5AONisJM10Oo2b/ZqT1X6tqPC3NFyWFyvjTLDyHVkDo9n6an2+u0KphFa
	di1mlnkd9u3T04oeC5zbEci2KuEuKDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704796321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DZOn5eJ+geO/Iv0b3t0P8rCWcuO2Y7FAKYPtyb8WT6M=;
	b=D1QEvop2sHGWz1+93W6SHiqIFVe67oF1z3KLgAXlBUVKaKFrt/XwlgnFYgndq8RXRYOQ17
	13Bc3C2e8/QslVCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08773134E8;
	Tue,  9 Jan 2024 10:32:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UteWO6AgnWVZTAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Tue, 09 Jan 2024 10:32:00 +0000
Date: Tue, 9 Jan 2024 11:32:24 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Vorel <pvorel@suse.cz>, ltp@lists.linux.it,
	Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
Message-ID: <ZZ0guBd48WXYapPL@yuki>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
 <ZZvIBO-a1b_nIHJ8@yuki>
 <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
X-Spam-Level: ***
X-Spamd-Bar: +++
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Jvkffs1h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=D1QEvop2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [3.49 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[13];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[suse.cz,lists.linux.it,redhat.com,suse.com,fujitsu.com,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: 3.49
X-Rspamd-Queue-Id: 329A01F7F6
X-Spam-Flag: NO

Hi!
> > Quite likely, other filesystems does have an inode flag that is set when
> > file has been compressed and simply report that in the foo_getattr()
> > callback. Looking at bcachefs I supose that we need to figure out if the
> > inode is v3 and then unpack the v3 info to get to the compressed flag,
> > you probably know best how to do that.
> 
> I'm still not clear how we want to map STATX_ATTR_COMPRESSED, since it's
> extents that are compressed, not entire files - and just reporting the
> compression option is probably not what we want since it can be flipped
> off, and existing data will still be compressed.
> 
> Do you know anything about the intended use case?

As far as I understand the flag it's a hint that the file I/O may be
slower/need more memory because of the compression.

-- 
Cyril Hrubis
chrubis@suse.cz
