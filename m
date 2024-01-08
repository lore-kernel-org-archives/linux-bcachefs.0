Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA0113ADD;
	Mon,  8 Jan 2024 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="heTbXZo2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="08id9X59";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q/IE4VBS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4V9WpmE7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 161AF21E9D;
	Mon,  8 Jan 2024 10:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704708830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV9emtJh7du1R65xT45Il3U/dY7jz8kJt1zx9A0asZY=;
	b=heTbXZo2pMfsoIomSg2Qizn9W1gKoXTe9sKPLualJ6I9hajYe4TpoMyuusrfuPgtISJMU9
	jq7NdkwZK98KrcIwMDBSMf7KwysMBSG37YEbzUZjY/cxiWKwFAx0A8uoM7gEWyekHLAipM
	jxRpm3U7ZCSKza7iJlVAMQi7yxOpGk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704708830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV9emtJh7du1R65xT45Il3U/dY7jz8kJt1zx9A0asZY=;
	b=08id9X59nR/4+AphIRDeu521AyASWkLX14qzzrqbDc6ajj9cXHSM9JK1bd7tcke59KC99a
	Y63vQZvoNdXQC1BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704708829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV9emtJh7du1R65xT45Il3U/dY7jz8kJt1zx9A0asZY=;
	b=Q/IE4VBSmDCmYCixXDg/KZ84wa82uSbPS3evhFYpI/EOaPulCDI4vAa0sg0HVYJ8AtdHOm
	m5OcTh3wCGSVMTWkk0xRmddIQ9ETysMjaTuVAdx7FC8iQv3hGmQ46kAjTxpCCqZXpznim5
	6sqpKmtq86G3hkzazm2IKRC2MA/fC+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704708829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AV9emtJh7du1R65xT45Il3U/dY7jz8kJt1zx9A0asZY=;
	b=4V9WpmE7Mk9wXja3svfu9uIOPUH6OScxRYRZhPCdzm5oLu1gwl3Ol22SuRopG3M/s30IDt
	WtD6FYK7y0CQ8rAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E53A61392C;
	Mon,  8 Jan 2024 10:13:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z+s/NdzKm2U3OAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Mon, 08 Jan 2024 10:13:48 +0000
Date: Mon, 8 Jan 2024 11:14:12 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 0/3] Add support bcachefs filesystem
Message-ID: <ZZvK9OL6MduUpWZQ@yuki>
References: <20231207194011.273027-1-pvorel@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207194011.273027-1-pvorel@suse.cz>
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 161AF21E9D
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Q/IE4VBS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4V9WpmE7
X-Spam-Score: -1.43
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.43 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[13];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[lists.linux.it,redhat.com,suse.com,fujitsu.com,linux.dev,vger.kernel.org,gmail.com,suse.cz];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.42)[78.20%]

Hi!
I suppose that it's fine to merge the first two patches to enable
bcachefs in LTP before there release.

For the first two patches:

Reviewed-by: Cyril Hrubis <chrubis@suse.cz>


For the last patch that disables check for STATX_ATTR_COMPRESSED it
looks like this is missing plumbing in bcachefs so I would avoid adding
workarounds into LTP for now.

-- 
Cyril Hrubis
chrubis@suse.cz
