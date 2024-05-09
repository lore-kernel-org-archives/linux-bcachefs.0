Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6338149C71;
	Thu,  9 May 2024 06:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715235454; cv=none; b=dwze82Y3LIr0aRCjMk4IFmwI4xLOZmgM2wBW6fwYXwsUq0+FSorDG4SMLC4Xt/R0xzhr79V3HZa+bhsqykyYzSJVDO6LplvqUfdHT7d/Vk2+spx0GHks5BCUqcRKu08gSEUCXLeFaXsaDjbBGB+39BRtHVG7XoisaeAQlHZzpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715235454; c=relaxed/simple;
	bh=bOfBY0JRENHjmcmy2f9640NSh1AJPQ45xTEljPOZTVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvO/LH9QfmBLOhTclJfDKOK5CgmXvoFeCtBSERq2YDLzqNKGf7+BhOWnO+Xhhr388TkJZTJ2zo4w1qABncOFQLZdhHyePJEwlXlwLPg+FswMbwFid8BFK934rP543FT/UC5Ar+YKQFltGM/p0jQEITbGNggBcjHHzrwB/g217Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MBwGDLNX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x2+cVxy1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MFj2YLUf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lu2L4sDi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MBwGDLNX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x2+cVxy1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MFj2YLUf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lu2L4sDi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59B9F37E5E;
	Thu,  9 May 2024 06:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715235441;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZDLMSsx3H/rJjZy/vs+WtnK86c8QRZBsSMgF8f4SU=;
	b=MBwGDLNX/eXktk3v4fpiLecLGA9SppHwlDPZ1lZI85e7C+7TTyPfeYGAdVFRCiq6AYcDDt
	qms4cfR2vqP+8JrzH56MjLD61uEwN20Zbg9XB+3ixSxbi4CEI3Nd0uE7bhz5EEzN7HXGF6
	6t7Ig0rsJ20Obr+ALgW7+jIRJI8kswA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715235441;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZDLMSsx3H/rJjZy/vs+WtnK86c8QRZBsSMgF8f4SU=;
	b=x2+cVxy1fYHK6+9Dj4gSLrYEpIy1pM7xjSWbjXHt/99S0DZLlwAdSd+G45+3wjGfkWAH51
	ALfx4gLVWCfnczDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MFj2YLUf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lu2L4sDi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715235440;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZDLMSsx3H/rJjZy/vs+WtnK86c8QRZBsSMgF8f4SU=;
	b=MFj2YLUfIbyelUVzJKz3bM4f+Zi3tngcESqCFKBpSRQizpPJJkGprkb5KxlRzdlIy1Ovsl
	r4u4QtvhOwiEPPJTL7IipY+/6VtGwIGcpZT2jwPLp/ICfGstxBSMW4GcXdEOpLpde5GxJL
	UfbyegAkPwT5+pPhvP4ySqmYH6V3lco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715235440;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZDLMSsx3H/rJjZy/vs+WtnK86c8QRZBsSMgF8f4SU=;
	b=lu2L4sDiyFkQnLarg5PBRkIHMbAHXeaqVONsiKMZ26vCDGFDRIlMtXAbKJIdiSE7bjCe1f
	z31xsjUl+AH9fYCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2748D13941;
	Thu,  9 May 2024 06:17:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cW+jCHBqPGZkeQAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Thu, 09 May 2024 06:17:20 +0000
Date: Thu, 9 May 2024 08:17:18 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Glass Su <glass.su@suse.com>, linux-bcachefs@vger.kernel.org,
	Su Yue <l@damenly.org>, Brian Foster <bfoster@redhat.com>,
	Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to
 UAPI magic.h
Message-ID: <20240509061718.GA231218@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240507153757.150891-1-pvorel@suse.cz>
 <6D9FCB08-480D-4CA0-82E2-284B1F2BF8FD@suse.com>
 <20240508211759.GA209026@pevik>
 <fg3cvwvadldeglwrqdeeglswxwupyy2cjki7si7sz3jwsrpzpf@5pkugq7jyzb2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fg3cvwvadldeglwrqdeeglswxwupyy2cjki7si7sz3jwsrpzpf@5pkugq7jyzb2>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:replyto,suse.cz:email,damenly.org:email,evilpiepirate.org:url];
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 59B9F37E5E
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.71

Hi Kent,

> On Wed, May 08, 2024 at 11:17:59PM +0200, Petr Vorel wrote:
> > Hi Su, Kent,

> > > > On May 7, 2024, at 23:37, Petr Vorel <pvorel@suse.cz> wrote:

> > > > Move BCACHEFS_STATFS_MAGIC value to UAPI <linux/magic.h> under
> > > > BCACHEFS_SUPER_MAGIC definition (use common approach for name) and reuse the
> > > > definition in bcachefs_format.h BCACHEFS_STATFS_MAGIC.

> > > > There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
> > > > which use UUID_INIT() and are used only in libbcachefs. Therefore move
> > > > only BCACHEFS_STATFS_MAGIC value, which can be used outside of
> > > > libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

> > > > Suggested-by: Su Yue <l@damenly.org>

> > > Would you kindly amend it to Su Yue <glass.su@suse.com> or
> > > Kent can help if the patch is going to be applied.

> > Unfortunately Kent was faster, it's already merged without your SUSE address
> > (and your RBT you added in the end):

> > https://evilpiepirate.org/git/bcachefs.git/commit/?h=for-next&id=ce8f9355f23be9756e499682d0d642a741db6c3a

> > @Kent: Maybe it can be even now amended (with Su Yue's RBT).

> ...sure, make me invalidate my test results :)

Thank you! FYI there was also his RBT (Reviewed-by: Su Yue <glass.su@suse.com>)

https://lore.kernel.org/linux-bcachefs/6D9FCB08-480D-4CA0-82E2-284B1F2BF8FD@suse.com/

Kind regards,
Petr

> > > > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > > > ---
> > > > Changes v2->v3:
> > > > * Align tab with other entries.
> > ...
> > > > #include <linux/uuid.h>
> > > > +#include <uapi/linux/magic.h>
> > > > #include "vstructs.h"

> > > > #ifdef __KERNEL__
> > > > @@ -1275,7 +1276,7 @@ enum bch_compression_opts {
> > > > UUID_INIT(0xc68573f6, 0x66ce, 0x90a9, \
> > > >  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)

> > > > -#define BCACHEFS_STATFS_MAGIC 0xca451a4e
> > > > +#define BCACHEFS_STATFS_MAGIC BCACHEFS_SUPER_MAGIC

> > > > #define JSET_MAGIC __cpu_to_le64(0x245235c1a3625032ULL)
> > > > #define BSET_MAGIC __cpu_to_le64(0x90135c78b99e07f5ULL)
> > > > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > > > index 1b40a968ba91..bb575f3ab45e 100644
> > > > --- a/include/uapi/linux/magic.h
> > > > +++ b/include/uapi/linux/magic.h
> > > > @@ -37,6 +37,7 @@
> > > > #define HOSTFS_SUPER_MAGIC 0x00c0ffee
> > > > #define OVERLAYFS_SUPER_MAGIC 0x794c7630
> > > > #define FUSE_SUPER_MAGIC 0x65735546
> > > > +#define BCACHEFS_SUPER_MAGIC 0xca451a4e

> > > IIUC, due to some historical reasons bcachefs used to switched
> > > ondisk sb magic from BCACHE_MAGIC to BCHFS_MAGIC.
> > > Other major fses uses  *_SUPER_MAGIC both for ondisk 
> > > sb magic, kstatfs::f_type and super_block::s_magic.
> > > However, for bcacehfs there are three magic numbers.

> > Thanks for info. But for struct statfs in statfs() or fstatfs() only 0xca451a4e
> > is needed, right? I would not expose the other(s) unless it's really needed.
> > Also we'd need to backport UUID_INIT() into UAPI :(.

> > > Anyway, it looks good to me so far:
> > > Reviewed-by: Su Yue <glass.su@suse.com> 

> > And also without your RBT.

> > Kind regards,
> > Petr

> > > — 
> > > Su
