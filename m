Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71D12C497;
	Wed,  8 May 2024 21:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715203087; cv=none; b=MwDZwzYo234rnBSgI1GFVQpy62SIMexiazWmf/2LNwwZ/Z1XJhXHKzUV4uyyckM4PaKjtatB0CBRiga+WtyYOlGeBiVQuX7CIoBnXwXArpzdfsOidMYBC/5hjWQcorED3D0p+YVMcY0K1h4dKZfIX3h41mHfBvW8nuDrsjjR38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715203087; c=relaxed/simple;
	bh=PPKQ+QxsB1/t58zneH/9FkTgvIO2lVo/8IcKZboomtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXSbaNXZtwx0RUv55nnQA1jxmawdN2l1BwglCCp5kSc+930X84o5u1vJYCz+0G7F00laarT2gSSWfDWhawCFpqbdLX3DWiAEGvEplvgQ2fkqicat7VU6WoyAhgfApOjb4/nu7BvVBptPAV/K+6avf5t7dn1ojn1afgKWByzL8cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pq8dF/JB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=w9geRoPW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pq8dF/JB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=w9geRoPW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pq8dF/JB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="w9geRoPW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pq8dF/JB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="w9geRoPW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FCDC374DD;
	Wed,  8 May 2024 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715203083;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q5SQ6cqLhRKayLQGjy5PeZI4TAB9vgmPlhyLHGGpl8=;
	b=pq8dF/JBpC7ZPUK/AauGGYcWQ6JS8LdbDw4GVo8r8qXpFEX7xVcbhIbfm4cJpOXZcBThcs
	SytEmoyzXKcWe91vaQYbF9Kw6K9pyDNkm+0laah4dUkGyn6MNeQ2PAYRAU2QeJ5UyieUY5
	G3ftC5RSaeUJTytySMjyMFXSqq8PXKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715203083;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q5SQ6cqLhRKayLQGjy5PeZI4TAB9vgmPlhyLHGGpl8=;
	b=w9geRoPW8r11T4vW25Og+KGODiMnim95j31+SbAkTqjcTB6TpC8oZsIIBHlbK9jBKExzpz
	L2umOps0D+WG/6Bg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pq8dF/JB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=w9geRoPW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715203083;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q5SQ6cqLhRKayLQGjy5PeZI4TAB9vgmPlhyLHGGpl8=;
	b=pq8dF/JBpC7ZPUK/AauGGYcWQ6JS8LdbDw4GVo8r8qXpFEX7xVcbhIbfm4cJpOXZcBThcs
	SytEmoyzXKcWe91vaQYbF9Kw6K9pyDNkm+0laah4dUkGyn6MNeQ2PAYRAU2QeJ5UyieUY5
	G3ftC5RSaeUJTytySMjyMFXSqq8PXKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715203083;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q5SQ6cqLhRKayLQGjy5PeZI4TAB9vgmPlhyLHGGpl8=;
	b=w9geRoPW8r11T4vW25Og+KGODiMnim95j31+SbAkTqjcTB6TpC8oZsIIBHlbK9jBKExzpz
	L2umOps0D+WG/6Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C6A813A27;
	Wed,  8 May 2024 21:18:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 44LRCgrsO2ajcgAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Wed, 08 May 2024 21:18:02 +0000
Date: Wed, 8 May 2024 23:17:59 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Glass Su <glass.su@suse.com>
Cc: linux-bcachefs@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>, Su Yue <l@damenly.org>,
	Brian Foster <bfoster@redhat.com>, Coly Li <colyli@suse.de>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to
 UAPI magic.h
Message-ID: <20240508211759.GA209026@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240507153757.150891-1-pvorel@suse.cz>
 <6D9FCB08-480D-4CA0-82E2-284B1F2BF8FD@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6D9FCB08-480D-4CA0-82E2-284B1F2BF8FD@suse.com>
X-Spam-Flag: NO
X-Spam-Score: -3.71
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2FCDC374DD
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_EQ_FROM(0.00)[]

HI Su, Kent,

> > On May 7, 2024, at 23:37, Petr Vorel <pvorel@suse.cz> wrote:

> > Move BCACHEFS_STATFS_MAGIC value to UAPI <linux/magic.h> under
> > BCACHEFS_SUPER_MAGIC definition (use common approach for name) and reuse the
> > definition in bcachefs_format.h BCACHEFS_STATFS_MAGIC.

> > There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
> > which use UUID_INIT() and are used only in libbcachefs. Therefore move
> > only BCACHEFS_STATFS_MAGIC value, which can be used outside of
> > libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

> > Suggested-by: Su Yue <l@damenly.org>

> Would you kindly amend it to Su Yue <glass.su@suse.com> or
> Kent can help if the patch is going to be applied.

Unfortunately Kent was faster, it's already merged without your SUSE address
(and your RBT you added in the end):

https://evilpiepirate.org/git/bcachefs.git/commit/?h=for-next&id=ce8f9355f23be9756e499682d0d642a741db6c3a

@Kent: Maybe it can be even now amended (with Su Yue's RBT).

> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > Changes v2->v3:
> > * Align tab with other entries.
...
> > #include <linux/uuid.h>
> > +#include <uapi/linux/magic.h>
> > #include "vstructs.h"

> > #ifdef __KERNEL__
> > @@ -1275,7 +1276,7 @@ enum bch_compression_opts {
> > UUID_INIT(0xc68573f6, 0x66ce, 0x90a9, \
> >  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)

> > -#define BCACHEFS_STATFS_MAGIC 0xca451a4e
> > +#define BCACHEFS_STATFS_MAGIC BCACHEFS_SUPER_MAGIC

> > #define JSET_MAGIC __cpu_to_le64(0x245235c1a3625032ULL)
> > #define BSET_MAGIC __cpu_to_le64(0x90135c78b99e07f5ULL)
> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > index 1b40a968ba91..bb575f3ab45e 100644
> > --- a/include/uapi/linux/magic.h
> > +++ b/include/uapi/linux/magic.h
> > @@ -37,6 +37,7 @@
> > #define HOSTFS_SUPER_MAGIC 0x00c0ffee
> > #define OVERLAYFS_SUPER_MAGIC 0x794c7630
> > #define FUSE_SUPER_MAGIC 0x65735546
> > +#define BCACHEFS_SUPER_MAGIC 0xca451a4e

> IIUC, due to some historical reasons bcachefs used to switched
> ondisk sb magic from BCACHE_MAGIC to BCHFS_MAGIC.
> Other major fses uses  *_SUPER_MAGIC both for ondisk 
> sb magic, kstatfs::f_type and super_block::s_magic.
> However, for bcacehfs there are three magic numbers.

Thanks for info. But for struct statfs in statfs() or fstatfs() only 0xca451a4e
is needed, right? I would not expose the other(s) unless it's really needed.
Also we'd need to backport UUID_INIT() into UAPI :(.

> Anyway, it looks good to me so far:
> Reviewed-by: Su Yue <glass.su@suse.com> 

And also without your RBT.

Kind regards,
Petr

> — 
> Su
