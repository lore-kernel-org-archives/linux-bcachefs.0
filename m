Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445C13ACF;
	Mon,  8 Jan 2024 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BmeQ3US+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HeyWBfsl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BmeQ3US+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HeyWBfsl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57D8B21DA5;
	Mon,  8 Jan 2024 10:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704708081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlWShqjOKUBsu8m1F+QnDCfvDJCg/ee5PVLq5rTSE6o=;
	b=BmeQ3US+1vod9O83ekeM5WVxVpQysq1l9qsEy6tRtwVWgU/K+EHpslvoqWzM4zBDt7KKff
	oRjqiTgqnVRAGkZzQ8BV9b2ts4qwEEcygeBcnEEEQXpnVgRn4hLsU6zvFAlbtMzqiDW5Me
	vP4rIjDiKu/J1byXglWYAheNsyOwHJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704708081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlWShqjOKUBsu8m1F+QnDCfvDJCg/ee5PVLq5rTSE6o=;
	b=HeyWBfslA3ykwlwSkmajFoq2ZiXj639ON/RYlojA7OkrHaxZHr10F7XVVWFATLmAYfJHpd
	QxbrnWxo8zNHgbAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704708081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlWShqjOKUBsu8m1F+QnDCfvDJCg/ee5PVLq5rTSE6o=;
	b=BmeQ3US+1vod9O83ekeM5WVxVpQysq1l9qsEy6tRtwVWgU/K+EHpslvoqWzM4zBDt7KKff
	oRjqiTgqnVRAGkZzQ8BV9b2ts4qwEEcygeBcnEEEQXpnVgRn4hLsU6zvFAlbtMzqiDW5Me
	vP4rIjDiKu/J1byXglWYAheNsyOwHJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704708081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlWShqjOKUBsu8m1F+QnDCfvDJCg/ee5PVLq5rTSE6o=;
	b=HeyWBfslA3ykwlwSkmajFoq2ZiXj639ON/RYlojA7OkrHaxZHr10F7XVVWFATLmAYfJHpd
	QxbrnWxo8zNHgbAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 488B91392C;
	Mon,  8 Jan 2024 10:01:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0UUWEfHHm2WeNAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Mon, 08 Jan 2024 10:01:21 +0000
Date: Mon, 8 Jan 2024 11:01:40 +0100
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
Message-ID: <ZZvIBO-a1b_nIHJ8@yuki>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 57D8B21DA5
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BmeQ3US+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HeyWBfsl
X-Spam-Score: -1.01
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.01 / 50.00];
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
	 FREEMAIL_CC(0.00)[suse.cz,lists.linux.it,redhat.com,suse.com,fujitsu.com,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[28.56%]

Hi!
> On Thu, Dec 07, 2023 at 08:40:11PM +0100, Petr Vorel wrote:
> > STATX_ATTR_COMPRESSED is not supported on Bcachefs, thus skip it
> > (it's already skipped on tmpfs and XFS).
> 
> Hang on, bcachefs most definitely does hae compression. This would be
> just because statx isn't plumbed through?

Quite likely, other filesystems does have an inode flag that is set when
file has been compressed and simply report that in the foo_getattr()
callback. Looking at bcachefs I supose that we need to figure out if the
inode is v3 and then unpack the v3 info to get to the compressed flag,
you probably know best how to do that.

-- 
Cyril Hrubis
chrubis@suse.cz
