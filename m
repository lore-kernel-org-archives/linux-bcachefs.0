Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OAzQ/fBe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qa+P4Izo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uTGa5y8K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OpvHJSgi"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07021A8;
	Tue, 12 Dec 2023 06:48:24 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB85D22511;
	Tue, 12 Dec 2023 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702392502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4PAfGpOfftQeO2akfkq9FK9oVv+T8+yemPjH2JRXj5U=;
	b=OAzQ/fBeKayU3RkQjr2ypXR3zml+0+EZ0WaezUv5U6nr+ndBWSNpJq0fvao0iuDUhzb8TZ
	gkwc8JCaMDtJyQ0BJ302QWW+iOmuqU7JbmXq9WIg4ySzNg4W2O1k8XpH81yrznTKd7qNpX
	7rJL9C0ceTLf7stuBwXd4WGEAEb4wQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702392502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4PAfGpOfftQeO2akfkq9FK9oVv+T8+yemPjH2JRXj5U=;
	b=qa+P4IzoIAJNNzpcfKiizNZhfIT78Uhypo0WCy1DNJWwriGancaNN+l6UVx2XZWllUY3n/
	J3v7taZJfDWMqMCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702392501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4PAfGpOfftQeO2akfkq9FK9oVv+T8+yemPjH2JRXj5U=;
	b=uTGa5y8KauYVRlm4Is9n1afxzu/Kogooa3fjZWIE3E20NdEthA57GCtpYACYB4jy6stCxn
	QY22IrDVVbT3GA7wf6S5KYUxbuXssuykDwvTOFQH5eBRhTxNdIv8sQIZEu1C81uJxyDr3r
	j7BwcReTPSeBfdEAGEZEJXa+4WYcZO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702392501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4PAfGpOfftQeO2akfkq9FK9oVv+T8+yemPjH2JRXj5U=;
	b=OpvHJSgimr05uCMDcMCdMRuQv33sbnoNfu6WBQlIkl8cohrFm6xEOPxsUO5tbMnUOxJjWY
	D0NIoEx7LjjkBoBQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id DF036132DC;
	Tue, 12 Dec 2023 14:48:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id R89wNrVyeGU9WwAAn2gu4w
	(envelope-from <jack@suse.cz>); Tue, 12 Dec 2023 14:48:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 845A9A07E0; Tue, 12 Dec 2023 15:48:21 +0100 (CET)
Date: Tue, 12 Dec 2023 15:48:21 +0100
From: Jan Kara <jack@suse.cz>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 0/3] Add support bcachefs filesystem
Message-ID: <20231212144821.rji2to3iiedyqxlm@quack3>
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
X-Spam-Score: -0.16
X-Spamd-Bar: +++
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uTGa5y8K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OpvHJSgi;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of jack@suse.cz) smtp.mailfrom=jack@suse.cz
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [3.10 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-0.975];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.19)[70.97%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCVD_DKIM_ARC_DNSWL_HI(-1.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.cz];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[14];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[lists.linux.it,suse.cz,redhat.com,suse.com,fujitsu.com,linux.dev,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 RCVD_IN_DNSWL_HI(-0.50)[2a07:de40:b281:104:10:150:64:98:from]
X-Spam-Score: 3.10
X-Rspamd-Queue-Id: EB85D22511
X-Spam-Flag: NO

On Thu 07-12-23 20:40:08, Petr Vorel wrote:
> Hi all,
> 
> @Amir @Jan, could you please have look on fanotify failures on Bcachefs?
> fanotify13.c, fanotify15.c and fanotify16.c produce many errors.
> 
> To test, just apply this patchset and then run with LTP_SINGLE_FS_TYPE:
> 
> # LTP_SINGLE_FS_TYPE=bcachefs ./fanotify15

I suspect some catch with fsids but we'll see... I hopefully get to this
tomorrow.

								Honza

> changes v1->v2:
> Two new commits:
> * lib: Add Bcachefs magic
> * statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
> 
> Petr Vorel (3):
>   lib: Add Bcachefs magic
>   lib: Add support bcachefs filesystem to .all_filesystems
>   statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
> 
>  include/tst_fs.h                          | 3 +++
>  lib/tst_fs_type.c                         | 2 ++
>  lib/tst_supported_fs_types.c              | 2 ++
>  testcases/kernel/syscalls/statx/statx04.c | 5 +++--
>  4 files changed, 10 insertions(+), 2 deletions(-)
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
