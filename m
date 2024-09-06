Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA0914D29D
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Sep 2024 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725609726; cv=none; b=bkQF1P1TH8j5LZ4wf6yO98qfotgCm5iUckDQjLG8bAxGhBmGBVWRLcf/6/c1ILphUuEOv5FJzhAwONm3JNryLIiJm+6Ryp+V6S5cEE4Qma6oYwxomX8aboH35wY/7zVmdrWxyNVe8FmIkW6Eyfkf9LN2IgdlZqeYjChVUM/J924=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725609726; c=relaxed/simple;
	bh=tbP3sQ56skraJ2LBjRk5LlczHyKqRHi2CaLaabaemWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWypar7BvZznfvUtyhZ20QbPrd2eUNJy20y7wmqQM8BhSkKx2KXfpWs+2nkYyV6LbKYNZ7/wnopmvyMfwGLkazBN+OUzZP3wwlx56Q6183KQzcnV9On7kWJPubcVZlXQNrg87hsaE2LBAKk/s5ZU2K0elYeqOb26mpBK7JHzzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=COcpiAuK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CwXlPXPa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gNqgrTUm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yGpJXjv2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="COcpiAuK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CwXlPXPa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gNqgrTUm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yGpJXjv2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43B8821AAC;
	Fri,  6 Sep 2024 08:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725609723;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DVb3IiRm+FSHbq2sk7ThqBrhfqulb2BuynE5kXDXM5k=;
	b=COcpiAuKdkrmHuSI3evd7Ut36eY1WxAa76f+R5hfI1RKzSyPaPnClZOPOtTQ21kWWBgFoj
	GQVr1MFUTBdVpuySxHDB53bRJmU/1XYFk3ixMClLaukdzQ/H1bM0jDQ+N3djS7/N0A5TPI
	6pbYwVoVOWwj1u8NfkblKrq/2IF1lt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725609723;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DVb3IiRm+FSHbq2sk7ThqBrhfqulb2BuynE5kXDXM5k=;
	b=CwXlPXPaEp89DQpsQmD5KEux/VdCztin5VvxxNrvTcZUpEiMlzmIrdRxlHjIisKwFtHxXZ
	D2yuXY7zNyvoGEDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725609722;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DVb3IiRm+FSHbq2sk7ThqBrhfqulb2BuynE5kXDXM5k=;
	b=gNqgrTUmYAcAkWKuYrwFmMkbzhlcZ5YGtOnbTtcYZipfDdpeznMj0ZFnX9mI2QY2MsFHZv
	3clI4/UxXbeH44MTP7mAhFkx9PEpj7l9ycNtpEWZzdXnXZPAAa5pH9oqTjc6LKVwwo4PO7
	t7kdgfctzUNle8TEzXy6tiIL4GGgZj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725609722;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DVb3IiRm+FSHbq2sk7ThqBrhfqulb2BuynE5kXDXM5k=;
	b=yGpJXjv22qg4sImATIv8uHzWeZ0TB0ZbPGc2ufMkeQe8zI+8wC5bdbueOJO6P1esxdb6nc
	ra0GIXqppWUBpwAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 041E3136A8;
	Fri,  6 Sep 2024 08:02:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cR85Ovm22mZ2PwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Fri, 06 Sep 2024 08:02:01 +0000
Date: Fri, 6 Sep 2024 10:02:00 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Martin Doucha <mdoucha@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: Re: [LTP] [PATCH 2/2] fallocate05: Deallocate whole file on bcachefs
Message-ID: <20240906080200.GA985598@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240905134502.33759-1-mdoucha@suse.cz>
 <20240905134502.33759-2-mdoucha@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905134502.33759-2-mdoucha@suse.cz>
X-Spam-Score: -3.50
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
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.cz:replyto,suse.cz:email];
	REPLYTO_EQ_FROM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

Hi Martin, all,

[ Cc Kent and Bcachefs ML ]

> The default deallocation size is likely too small for bcachefs
> to actually release the blocks. Since it is also a copy-on-write
> filesystem, deallocated the whole file like on Btrfs.

Make sense.
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr

> Signed-off-by: Martin Doucha <mdoucha@suse.cz>
> ---

> AFAICT Bcachefs uses 512 byte data blocks by default but 256KB inode
> blocks. The whole file will be 128KB and 32KB gets deallocated which may
> be too small. However, I'm not entirely sure whether this is the best
> solution.

> See also https://bugzilla.suse.com/show_bug.cgi?id=1230155

>  testcases/kernel/syscalls/fallocate/fallocate05.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

> diff --git a/testcases/kernel/syscalls/fallocate/fallocate05.c b/testcases/kernel/syscalls/fallocate/fallocate05.c
> index 979c70d6e..732a2f15d 100644
> --- a/testcases/kernel/syscalls/fallocate/fallocate05.c
> +++ b/testcases/kernel/syscalls/fallocate/fallocate05.c
> @@ -114,7 +114,8 @@ static void run(void)
>  	tst_res(TPASS, "fallocate() on full FS");

>  	/* Btrfs deallocates only complete extents, not individual blocks */
> -	if (!strcmp(tst_device->fs_type, "btrfs"))
> +	if (!strcmp(tst_device->fs_type, "btrfs") ||
> +		!strcmp(tst_device->fs_type, "bcachefs"))
>  		holesize = bufsize + extsize;
>  	else
>  		holesize = DEALLOCATE_BLOCKS * blocksize;
