Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983938DD6;
	Tue,  7 May 2024 16:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100280; cv=none; b=Tf0d6AVp+VFMJj93ygVBqIVPiN1CG5GXJYe1/nbP3eIvG/ESq6L4AiVRoWnuy+N3DAh5iOpMmg9T37SXBldKzULEsUcshFRlKM50Vk57GrBHuUhWK1FKdU0dwsV/2Hgyo6thzZpCMLoJkTAq70xJszPRGmqEbpJY8hb+PSCl0QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100280; c=relaxed/simple;
	bh=kAKlVw87PPuSWXnb3AnyFkrp/Eif5CHqGGcqc9qtqpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Twa23Q8/ndV9jBMoeVhz7ly2o8SMUwYWpJmBXXFdjY769j3G7yemtPCWYoe6gBCt8D3Y+JKZllH/8GClxOWK0wMpZ5jm9KkZ9oG/chKsHcTlyRTF1qrMR6pWWWOtPk+LecnfsEY1ssoULadKI3cRgbFGPt83BkS/zeUPB5dPwiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IlhhHAXT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=et8FFqUq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IlhhHAXT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=et8FFqUq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IlhhHAXT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="et8FFqUq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IlhhHAXT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="et8FFqUq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7373C3422A;
	Tue,  7 May 2024 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715100276;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRUKIk56AMBa83RB7gUeR1KP/QLaFZJMu5dlZQb6BZ4=;
	b=IlhhHAXTY8L0W7QnTFgiES7pmtNsDhum3EzUSRSQSeQ5NKVJ9Dj86e/SOtUf4JvMz3K/dD
	jgZbU/azE4V6zepUIC9VQFry66yTz7Vf08L3W0tph5R5WJJlw35o2yFXTZ5N46uzNo5BDZ
	MFD1KNdeQ3t3mahs8plWp1RkTxEUHxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715100276;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRUKIk56AMBa83RB7gUeR1KP/QLaFZJMu5dlZQb6BZ4=;
	b=et8FFqUqj9uixX+E6fz0+sQVMVqu8BLSKYBERLZSZUmkKtA6kE1VODoMTiT6lhonCp5QfQ
	cybSIrStt+OrcGCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715100276;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRUKIk56AMBa83RB7gUeR1KP/QLaFZJMu5dlZQb6BZ4=;
	b=IlhhHAXTY8L0W7QnTFgiES7pmtNsDhum3EzUSRSQSeQ5NKVJ9Dj86e/SOtUf4JvMz3K/dD
	jgZbU/azE4V6zepUIC9VQFry66yTz7Vf08L3W0tph5R5WJJlw35o2yFXTZ5N46uzNo5BDZ
	MFD1KNdeQ3t3mahs8plWp1RkTxEUHxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715100276;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRUKIk56AMBa83RB7gUeR1KP/QLaFZJMu5dlZQb6BZ4=;
	b=et8FFqUqj9uixX+E6fz0+sQVMVqu8BLSKYBERLZSZUmkKtA6kE1VODoMTiT6lhonCp5QfQ
	cybSIrStt+OrcGCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E30913A2D;
	Tue,  7 May 2024 16:44:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c5IdCXRaOmbHbgAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 16:44:36 +0000
Date: Tue, 7 May 2024 18:44:30 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>, Su Yue <l@damenly.org>,
	Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to
 UAPI magic.h
Message-ID: <20240507164430.GD138935@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240507153757.150891-1-pvorel@suse.cz>
 <ZjpQV0ddhG9sUo8P@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjpQV0ddhG9sUo8P@bfoster>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:replyto,suse.cz:email];
	REPLYTO_EQ_FROM(0.00)[]
X-Spam-Score: -3.50
X-Spam-Flag: NO

> On Tue, May 07, 2024 at 05:37:57PM +0200, Petr Vorel wrote:
> > Move BCACHEFS_STATFS_MAGIC value to UAPI <linux/magic.h> under
> > BCACHEFS_SUPER_MAGIC definition (use common approach for name) and reuse the
> > definition in bcachefs_format.h BCACHEFS_STATFS_MAGIC.

> > There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
> > which use UUID_INIT() and are used only in libbcachefs. Therefore move
> > only BCACHEFS_STATFS_MAGIC value, which can be used outside of
> > libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

> > Suggested-by: Su Yue <l@damenly.org>
> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---

> I was thinking you'd just rename the STATFS_MAGIC def locally as well,
> but whatever.. LGTM, thanks for the tweaks!

Ah, I thought it'd be more readable this way from bcachefs point.
Kent, just let me know if you prefer Brian's way and I'll send v4.

Kind regards,
Petr

> Acked-by: Brian Foster <bfoster@redhat.com>

> > Changes v2->v3:
> > * Align tab with other entries.

> > Changes v1->v2 (all suggested by Brian Foster - thanks!):
> > * rename constant to BCACHEFS_SUPER_MAGIC,
> > * keep BCACHEFS_STATFS_MAGIC in bcachefs_format.h, just include
> >  <uapi/linux/magic.h> and use BCACHEFS_SUPER_MAGIC definition,
> > * move the constant to the first chunk.

> > Kind regards,
> > Petr

> >  fs/bcachefs/bcachefs_format.h | 3 ++-
> >  include/uapi/linux/magic.h    | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)

> > diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> > index f7fbfccd2b1e..3b831415409b 100644
> > --- a/fs/bcachefs/bcachefs_format.h
> > +++ b/fs/bcachefs/bcachefs_format.h
> > @@ -76,6 +76,7 @@
> >  #include <asm/byteorder.h>
> >  #include <linux/kernel.h>
> >  #include <linux/uuid.h>
> > +#include <uapi/linux/magic.h>
> >  #include "vstructs.h"

> >  #ifdef __KERNEL__
> > @@ -1275,7 +1276,7 @@ enum bch_compression_opts {
> >  	UUID_INIT(0xc68573f6, 0x66ce, 0x90a9,				\
> >  		  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)

> > -#define BCACHEFS_STATFS_MAGIC		0xca451a4e
> > +#define BCACHEFS_STATFS_MAGIC		BCACHEFS_SUPER_MAGIC

> >  #define JSET_MAGIC		__cpu_to_le64(0x245235c1a3625032ULL)
> >  #define BSET_MAGIC		__cpu_to_le64(0x90135c78b99e07f5ULL)
> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > index 1b40a968ba91..bb575f3ab45e 100644
> > --- a/include/uapi/linux/magic.h
> > +++ b/include/uapi/linux/magic.h
> > @@ -37,6 +37,7 @@
> >  #define HOSTFS_SUPER_MAGIC	0x00c0ffee
> >  #define OVERLAYFS_SUPER_MAGIC	0x794c7630
> >  #define FUSE_SUPER_MAGIC	0x65735546
> > +#define BCACHEFS_SUPER_MAGIC	0xca451a4e

> >  #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
> >  #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
> > -- 
> > 2.43.0


