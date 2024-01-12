Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8BF6BB40;
	Fri, 12 Jan 2024 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XyqsDZrW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mcveIrfm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XyqsDZrW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mcveIrfm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45394222B2;
	Fri, 12 Jan 2024 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705067926;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HqVQzM59rREB+HKNlQD5Ej/HEsQgUqlm1eyf5ROcYM=;
	b=XyqsDZrWYtabY5kJ52JkQby2UXHoT7FE0J9Q3GMOB9V56AEW7PBvZ7zmg5mDcw5bQ3vCbS
	VQeo9nm1w2P7gb3cv2XLxX/Mu3Xet+6zbqHNU2TE+NsQavdlqYz2kOufyyODdTozM8ajYV
	e8QCO8sW5LbHjExLapXU3R+BlnlZuzE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705067926;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HqVQzM59rREB+HKNlQD5Ej/HEsQgUqlm1eyf5ROcYM=;
	b=mcveIrfmVqqn256Wp3ACMPrClWxe0O4ana+x2HTbQis5LQHFgOB4ZocRHhLtX2kpHY2SOz
	s4hs2eEHbyfzABCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705067926;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HqVQzM59rREB+HKNlQD5Ej/HEsQgUqlm1eyf5ROcYM=;
	b=XyqsDZrWYtabY5kJ52JkQby2UXHoT7FE0J9Q3GMOB9V56AEW7PBvZ7zmg5mDcw5bQ3vCbS
	VQeo9nm1w2P7gb3cv2XLxX/Mu3Xet+6zbqHNU2TE+NsQavdlqYz2kOufyyODdTozM8ajYV
	e8QCO8sW5LbHjExLapXU3R+BlnlZuzE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705067926;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HqVQzM59rREB+HKNlQD5Ej/HEsQgUqlm1eyf5ROcYM=;
	b=mcveIrfmVqqn256Wp3ACMPrClWxe0O4ana+x2HTbQis5LQHFgOB4ZocRHhLtX2kpHY2SOz
	s4hs2eEHbyfzABCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27E35136A4;
	Fri, 12 Jan 2024 13:58:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9/SWBpVFoWVdfgAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Fri, 12 Jan 2024 13:58:45 +0000
Date: Fri, 12 Jan 2024 14:58:38 +0100
From: Petr Vorel <pvorel@suse.cz>
To: Su Yue <l@damenly.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, ltp@lists.linux.it,
	Cyril Hrubis <chrubis@suse.cz>, Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/3] lib: Add Bcachefs magic
Message-ID: <20240112135838.GA2009596@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-2-pvorel@suse.cz>
 <frz27k44.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <frz27k44.fsf@damenly.org>
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XyqsDZrW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mcveIrfm
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.72 / 50.00];
	 HAS_REPLYTO(0.30)[pvorel@suse.cz];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.01)[51.26%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 REPLYTO_EQ_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[14];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[linux.dev,lists.linux.it,suse.cz,redhat.com,suse.com,fujitsu.com,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -0.72
X-Rspamd-Queue-Id: 45394222B2
X-Spam-Flag: NO

Hi all,


> On Thu 07 Dec 2023 at 20:40, Petr Vorel <pvorel@suse.cz> wrote:

> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > New in v2

> >  include/tst_fs.h  | 3 +++
> >  lib/tst_fs_type.c | 2 ++
> >  2 files changed, 5 insertions(+)

> > diff --git a/include/tst_fs.h b/include/tst_fs.h
> > index eb9841165..06f5be896 100644
> > --- a/include/tst_fs.h
> > +++ b/include/tst_fs.h
> > @@ -34,6 +34,9 @@
> >  #define TST_VFAT_MAGIC     0x4d44 /* AKA MSDOS */
> >  #define TST_EXFAT_MAGIC    0x2011BAB0UL

> > +/* fs/bcachefs/bcachefs_format.h */
> > +#define TST_BCACHE_MAGIC		0xca451a4e
> > +

> Not object to the patch. There are three MAGIC values in
> bcachefs_format.h: BCACHE_MAGIC, BCHFS_MAGIC, BCACHEFS_STATFS_MAGIC.

> IIUC, BCACHE_MAGIC is the older one in superblock, BCHFS_MAGIC is the
> new one. BCACHEFS_STATFS_MAGIC is for statfs.
> Kent,
> Would you please export needed magic values to include/uapi/linux/magic.h?

+1, very good idea.

Kind regards,
Petr

> Since you are the maintainer also I'm confused about variables to be named.
