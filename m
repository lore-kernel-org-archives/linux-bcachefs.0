Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057315098D;
	Tue,  7 May 2024 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715093007; cv=none; b=ZDsOTSfZHGLt6n86JcZ4b4rQVOXwlx0kzKmZWyXEzJaCnNiRX/lnYrdNsz7FvvWq+WVEfImbGHUeLsRKq3hnAj7LSefTiYKsqjTUD8FQzyNLZFupQA1+zUeNNtIaALO/nt9tj8MX1XKEimisqtGNy+YBBqkGtYfkX3ygzkrGo0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715093007; c=relaxed/simple;
	bh=dEaNxRAzhuVz2zwbLAZO0fodhXrNZ3heVpfnOCqIK7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roqVQ121Nw562gaMx7kX0WkywdD+l9mMlXL07QYnMLg3C0Nvn2lPVMj6sb8vROJrDKjeNsBJKs422UvoyMMYssGqEt+Py9fyBPAhevJqChHum+LMDB3Jue/rWIWPzqfG3zLK0AJZk4rLiV9ok7TZEUQI7vMeHBqnnMw2ztZXmYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FAZX997d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vrNfPLDD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yY9pTwQQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ywGCfOMb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FAZX997d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vrNfPLDD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yY9pTwQQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ywGCfOMb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B6C4E20B91;
	Tue,  7 May 2024 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715093003;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FTczNht+/rGWhzBV/ml37bhYIYXRuHDflYaAfTgiSPU=;
	b=FAZX997d0a+fkSSKoXTgQSrhSNNti6Zgvfo4437EYJuYUMVH5W6r2uYxuKU8dlwe2ls/+7
	oPO7YTN+7dVGkUiePtexuvQZj4QZfGqZg+NCrjRzdNQgCH2crIZ7mBpX/wqi/B6i7uVDJf
	0vKUVG+jea62HCHSfC1biYmM6xcX78M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715093003;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FTczNht+/rGWhzBV/ml37bhYIYXRuHDflYaAfTgiSPU=;
	b=vrNfPLDDpir1UoY5RLPszseMSgfgKCCJ8S6M/BTFia9i8UYJYfrTFrdMoGNnZmuDYKTZc4
	vGCSEi+hCYOKCsBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715093002;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FTczNht+/rGWhzBV/ml37bhYIYXRuHDflYaAfTgiSPU=;
	b=yY9pTwQQoKlrgi2cOsgmkfaWzZi+R+D47hXWcTJNGWKoU6dx8QBUn5gptNykuTNHXnQ806
	lpZqLQMCcW3pCEosNcBqbIqrUwMkM7JA8omSGkG8D2/9hF725opOUInjtupkjZnawc6bqM
	phgt8YENTN1cubLFOn8FdberSJ/9OkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715093002;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FTczNht+/rGWhzBV/ml37bhYIYXRuHDflYaAfTgiSPU=;
	b=ywGCfOMbjmEJzOiWvFBKDjkQxqa87Vr/qCcvtiEVA08EaV/hrzRVkwYlhghFnuoXFpoEa8
	e/orznv0i4KiNhDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5A5C13A3C;
	Tue,  7 May 2024 14:43:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dtbULwk+OmaARAAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 14:43:21 +0000
Date: Tue, 7 May 2024 16:43:19 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>, Su Yue <l@damenly.org>,
	Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC to UAPI magic.h
Message-ID: <20240507144319.GC138935@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240507111124.118520-1-pvorel@suse.cz>
 <Zjot36J9negcVlfh@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zjot36J9negcVlfh@bfoster>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:email];
	REPLYTO_EQ_FROM(0.00)[]
X-Spam-Score: -3.50
X-Spam-Flag: NO

Hi Brian,

> On Tue, May 07, 2024 at 01:11:24PM +0200, Petr Vorel wrote:
> > There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
> > which use UUID_INIT() and are used only in libbcachefs. Therefore move
> > to <linux/magic.h> only BCACHEFS_STATFS_MAGIC, which can be used outside
> > of libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

> > Keeping non-standard name BCACHEFS_STATFS_MAGIC instead of renaming it
> > to more generic BCACHEFS_MAGIC to not confuse with the other bcachefs
> > definitions.


> Perhaps it would be better to use the standard naming for the global
> header and let the bcachefs subsystem catch up with better names for
> internal defs? Something like BCACHEFS_SUPER_MAGIC also seems like it
> would be generally consistent, FWIW.

I was also thinking about this. I'll send v2.

> > Suggested-by: Su Yue <l@damenly.org>
> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> >  fs/bcachefs/bcachefs_format.h | 2 --
> >  fs/bcachefs/fs.c              | 1 +
> >  include/uapi/linux/magic.h    | 2 ++
> >  3 files changed, 3 insertions(+), 2 deletions(-)

> > diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> > index f7fbfccd2b1e..52e03f13b780 100644
> > --- a/fs/bcachefs/bcachefs_format.h
> > +++ b/fs/bcachefs/bcachefs_format.h
> > @@ -1275,8 +1275,6 @@ enum bch_compression_opts {
> >  	UUID_INIT(0xc68573f6, 0x66ce, 0x90a9,				\
> >  		  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)

> > -#define BCACHEFS_STATFS_MAGIC		0xca451a4e
> > -
> >  #define JSET_MAGIC		__cpu_to_le64(0x245235c1a3625032ULL)
> >  #define BSET_MAGIC		__cpu_to_le64(0x90135c78b99e07f5ULL)

> > diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> > index fce690007edf..1c856ae2b0e2 100644
> > --- a/fs/bcachefs/fs.c
> > +++ b/fs/bcachefs/fs.c
> > @@ -27,6 +27,7 @@
> >  #include "super.h"
> >  #include "xattr.h"

> > +#include <uapi/linux/magic.h>
> >  #include <linux/aio.h>
> >  #include <linux/backing-dev.h>
> >  #include <linux/exportfs.h>
> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > index 1b40a968ba91..45c8f4916167 100644
> > --- a/include/uapi/linux/magic.h
> > +++ b/include/uapi/linux/magic.h
> > @@ -103,4 +103,6 @@
> >  #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
> >  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */

> > +#define BCACHEFS_STATFS_MAGIC		0xca451a4e
> > +

> Is there intended to be at least some logical organization to this file?
> It kind of looks like it, but maybe not as a rule. Personally, I'd
> probably stick this somewhere in the first chunk of definitions where
> the other major local/block filesystems are, but just a nit.

I was asking myself, but did not see any rule :). But sure, I can add it below
FUSE_SUPER_MAGIC (the end of the first chunk).

Thanks for your review!

Kind regards,
Petr

> Brian

> >  #endif /* __LINUX_MAGIC_H__ */
> > -- 
> > 2.43.0


