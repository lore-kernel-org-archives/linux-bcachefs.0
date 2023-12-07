Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="doXt4rO1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DGU+BeDe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="doXt4rO1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DGU+BeDe"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4668B12E;
	Thu,  7 Dec 2023 11:22:45 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 952271FB94;
	Thu,  7 Dec 2023 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701976963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuJqg9FogtX1OC5fPo866MSNYG+Vu5BSS/9xrb+y6GM=;
	b=doXt4rO1Um5eZkKxPf2lLVy//+/5pXLX0Y+Mzy14iG1Am02V7ZbOnuSNlnsEcCVXhvlgPX
	CasuV2demcTyNViwtavLqvskk9k9XePBh7WqQeHOc2S9YuMO98XkHuVSwPZiR8U9tLt/46
	5nYoIrs1NG+qcUaxIon91Qy1pDHLz+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701976963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuJqg9FogtX1OC5fPo866MSNYG+Vu5BSS/9xrb+y6GM=;
	b=DGU+BeDeYsx3NPd4EoIOl42QPVPQBOv3HjJ7Z+hVNMmAcrQ+XavEMUXlv1C2VYBNoinuSJ
	vox2uaLc23+CaSCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701976963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuJqg9FogtX1OC5fPo866MSNYG+Vu5BSS/9xrb+y6GM=;
	b=doXt4rO1Um5eZkKxPf2lLVy//+/5pXLX0Y+Mzy14iG1Am02V7ZbOnuSNlnsEcCVXhvlgPX
	CasuV2demcTyNViwtavLqvskk9k9XePBh7WqQeHOc2S9YuMO98XkHuVSwPZiR8U9tLt/46
	5nYoIrs1NG+qcUaxIon91Qy1pDHLz+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701976963;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuJqg9FogtX1OC5fPo866MSNYG+Vu5BSS/9xrb+y6GM=;
	b=DGU+BeDeYsx3NPd4EoIOl42QPVPQBOv3HjJ7Z+hVNMmAcrQ+XavEMUXlv1C2VYBNoinuSJ
	vox2uaLc23+CaSCw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B37513907;
	Thu,  7 Dec 2023 19:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id fnd2HIIbcmVyfwAAn2gu4w
	(envelope-from <pvorel@suse.cz>); Thu, 07 Dec 2023 19:22:42 +0000
Date: Thu, 7 Dec 2023 20:22:40 +0100
From: Petr Vorel <pvorel@suse.cz>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] lib: Add support bcachefs filesystem
Message-ID: <20231207192240.GB248849@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231116135546.2599273-1-pvorel@suse.cz>
 <ZXHXxCRa31xO-Lo_@rei>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXHXxCRa31xO-Lo_@rei>
X-Spam-Level: 
X-Spam-Score: -6.29
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.83 / 50.00];
	 ARC_NA(0.00)[];
	 HAS_REPLYTO(0.30)[pvorel@suse.cz];
	 REPLYTO_EQ_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-1.53)[91.92%]
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.83

Hi Cyril, all,

BTW we need to add TST_BCACHE_MAGIC to detect used filesystem.
(BCACHEFS_STATFS_MAGIC       0xca451a4e from fs/bcachefs/bcachefs_format.h)
Will be in v2.

Kind regards,
Petr
