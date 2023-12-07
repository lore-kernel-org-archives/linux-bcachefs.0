Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3aTN0icn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k9dVbOKT"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970F612E;
	Thu,  7 Dec 2023 09:55:44 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A840221DA9;
	Thu,  7 Dec 2023 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701971742;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNnU+TSS/qfLmITURuC6kWZHVs4AC2ymKQhfiuMGq4o=;
	b=3aTN0icnt8Mz09oVjEOwYkA/GPu0S+GJOII9MAJd4A8qt0q/ZLMBIdS6USmR1U6cWef+MV
	C0L+Y/Mo5MZY5JP6IpSAy0D7Pjy2lWrzcSEowF3wgXykCHZnOBv+gvDJxqwafJFfJa6TuV
	rtk8KpZgzNCzmTMP4RBM++y1D1DYq8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701971742;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNnU+TSS/qfLmITURuC6kWZHVs4AC2ymKQhfiuMGq4o=;
	b=k9dVbOKTdp8VXj37AxPCtBv32nokrbADaYXYJ7cA7gf4pz8KfuAQeBIfPl+GY0OZRicj4b
	oUb8p569RTphMiBA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AA7713907;
	Thu,  7 Dec 2023 17:55:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id cDCSGR0HcmUTZwAAn2gu4w
	(envelope-from <pvorel@suse.cz>); Thu, 07 Dec 2023 17:55:41 +0000
Date: Thu, 7 Dec 2023 18:55:38 +0100
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
Message-ID: <20231207175538.GA248849@pevik>
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
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.50
X-Spamd-Result: default: False [-4.50 / 50.00];
	 ARC_NA(0.00)[];
	 HAS_REPLYTO(0.30)[pvorel@suse.cz];
	 REPLYTO_EQ_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,lwn.net:url];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[21.67%]

> Hi!
> > bcachefs has been merged into v6.7-rc1 [1]. Let's add it's support to
> > LTP .all_filesystems = 1 and TST_ALL_FILESYSTEMS=1.

> > [1] https://lwn.net/Articles/934692/

> > Suggested-by: Cyril Hrubis <chrubis@suse.cz>
> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > Hi,

> > this should be merged after v6.7 is released.

> Agreed, although it's unlikey that they will pull bcachefs off from the
> tree now. Any way I think that we should add the support to the next
> release.

Yep, now it's 6.7-rc4. I'll prepare v2

> > So far I haven't tested all LTP tests on bcachefs temporary directory.
> > I have only tested tests which use .all_filesystems = 1 or TST_ALL_FILESYSTEMS=1.
> > So far it looks like there are only a few tests failing:

> > statvfs01.c:44: TFAIL: creat(valid_fname, 0444) failed: ENAMETOOLONG (36)

> That strange, that would mean that statvfs() reports possibly wrong
> f_namemax. Looking at the code the f_namemax is initialized to
> BCH_NAME_MAX in bch2_statfs().

> And the dirent_create_key() does:

>         if (name->len > BCH_NAME_MAX)
>                 return ERR_PTR(-ENAMETOOLONG);

> That does not look like there is any room for a failure. Maybe we can
> print the buf.f_namemax value in the test and check if it's 512 since
> that is the value of BCH_NAME_MAX.

> > statx04.c:122: TFAIL: STATX_ATTR_COMPRESSED not supported

> This probably just needs:

> diff --git a/testcases/kernel/syscalls/statx/statx04.c b/testcases/kernel/syscalls/statx/statx04.c
> index 58296bd24..8d14cef8c 100644
> --- a/testcases/kernel/syscalls/statx/statx04.c
> +++ b/testcases/kernel/syscalls/statx/statx04.c
> @@ -97,7 +97,8 @@ static void setup(void)
>                 expected_mask |= attr_list[i].attr;

>         /* STATX_ATTR_COMPRESSED not supported on XFS, TMPFS */
> -       if (!strcmp(tst_device->fs_type, "xfs") || !strcmp(tst_device->fs_type, "tmpfs"))
> +       if (!strcmp(tst_device->fs_type, "xfs") || !strcmp(tst_device->fs_type, "tmpfs") ||
> +           !strcmp(tst_device->fs_type, "bcachefs")
>                 expected_mask &= ~STATX_ATTR_COMPRESSED;

Obviously skipping works. STATX_ATTR_COMPRESSED is not in fs/bcachefs/ directory in stat->attributes,
unlike on the other fs, so it looks like it's not supported.

>         /* Attribute support was added to Btrfs statx() in kernel v4.13 */

> > fanotify13.c, fanotify15.c and fanotify16.c produce many errors.

> That is probably something for Jan Kara or Amir Goldstein.

Yep, I'll Cc them on v2 and ask for help.

Kind regards,
Petr

> > I haven't tested on machine with more NUMA nodes, thus
> > set_mempolicy03.c, set_mempolicy04.c has not been tested.
