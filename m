Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF6E197A95
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725534578; cv=none; b=hCEB1d4PWtu0GYqS60MxRBYsAFYegV9TCin3u3xheeZPRVMJJUwtU7uBDo5DVrlsVGkpCZJ9RvK8aNRvXpxRk5Lpq0DHyoEgGb2VGjG4+Qh7PuWhqKllBSxFganaVmLUeT5LUK/McBW830rF31IXXHX3CqQXXOW8eOhgOkRBfRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725534578; c=relaxed/simple;
	bh=wHuVpEcff0i9nRW1pklhL1Nau6JwRSLCwNgjhbuw4V0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxqDFMXrwR1y2xm07q1cZX/CsUNsp/PNXd6xqwj+BqUHleuLpvqOljWyq7rG3x5sKiMr/DHMFlFDU1UGO8qLnHToL/OHkNjyV2hcscTT6Uf0JLBzUfxp8PKPbAMjEkmuaEfDYFzyQnOcQWYKbv06SYd8wukb2lg0DyfdSfuvBLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mVigMtk5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fy7Nlxqq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Levgxet0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UbiS1VD/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mVigMtk5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fy7Nlxqq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Levgxet0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UbiS1VD/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E814921A5D;
	Thu,  5 Sep 2024 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725534574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykdftg6jdYpskoPyzPHIJlI8LwUEroQaeFKNcuRQUzg=;
	b=mVigMtk5DzdmaJlX725/WsBrBdKVDFOC8QdEyCRi0idRHYlMMlaMZ2rQ7NkbolNfHa/11f
	kBU3QEDkCkdvXABGtlEH66ck/bhvn7a1N20io7lvbIaU5xnOilh8iuHvHQ3LwLwtg0UA/g
	lRowmdiys43uTTVkLRc5CQDjhY5ogvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725534574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykdftg6jdYpskoPyzPHIJlI8LwUEroQaeFKNcuRQUzg=;
	b=fy7NlxqqcIaI6nsifekgOneVgxl5wGwqmuZ2wHlIwX9bHEfbgg7NWtZAqDgJWsNcHZ1yP1
	/+f0iIog3u97GqBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Levgxet0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="UbiS1VD/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725534573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykdftg6jdYpskoPyzPHIJlI8LwUEroQaeFKNcuRQUzg=;
	b=Levgxet0zP3zW0SdPhHMQdRvmlmmOucqSQ6zyqE3UoHNUCf6N7nO4vakq512CiCfm7rQoW
	XWUbpjdrzuQtU98m/hzhVbeijYdM7Sf3a56iAvwKF4AcNnsFlFVZrbqiYuWwyrDQ2fbqeL
	4osUi6EbdxV3zxEN+3CiPR2aDn3AN6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725534573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykdftg6jdYpskoPyzPHIJlI8LwUEroQaeFKNcuRQUzg=;
	b=UbiS1VD/TDHCRS7/omlyjkEWfoRQvsL0s5iMjZ30SZde43KHu/ZN8RUKEEZt17O0IfgR7P
	dvh6VoCMNNqnXRAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60CF8139D2;
	Thu,  5 Sep 2024 11:09:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wylbBWyR2WYAWQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 05 Sep 2024 11:09:32 +0000
Date: Thu, 5 Sep 2024 11:08:34 +0000
From: David Disseldorp <ddiss@suse.de>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <linux-bcachefs@vger.kernel.org>, Martin Doucha <martin.doucha@suse.com>
Subject: Re: [PATCH] Revert "bcachefs: Ignore unknown mount options"
Message-ID: <20240905110834.5a18b81f.ddiss@suse.de>
In-Reply-To: <b696e5c8-6f79-492d-8b66-fd012f5d69c5@huawei.com>
References: <20240905020956.29821-1-ddiss@suse.de>
	<b696e5c8-6f79-492d-8b66-fd012f5d69c5@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E814921A5D
X-Spam-Level: 
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:email,suse.de:dkim,suse.de:mid,opensuse.org:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.51
X-Spam-Flag: NO

On Thu, 5 Sep 2024 15:28:42 +0800, Hongbo Li wrote:

> On 2024/9/5 10:09, David Disseldorp wrote:
> > This reverts commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b.
> >   
> May be the subject should be Fix .... The original commit 
> 03ef80b469d5d83530ce1ce15be78a40e5300f9b has been changed by other change.

True, it's not a clean revert of 03ef80b469d5d ("bcachefs: Ignore
unknown mount options") but is atop 929d954330142 ("bcachefs: use new
mount API"). Can change this over to a regular Fixes commit if desired.

> > Contrary to the commit message, unknown mount options do result in
> > failure on other filesystems such as xfs, btrfs, ext4, etc.
> > 
> > Ignoring unknown options may result in unexpected behaviour: e.g. if
> > an application requires future-workload-specific-mount-option to work
> > and is run on a system without future-workload-specific-mount-option
> > kernel support, then it may fail without indication of the missing
> > kernel functionality.
> > 
> > This reversion may cause failures for existing users reliant on the
> > ignore-unknown behaviour, but it should be bearable given bcachefs is
> > still flagged experimental.
> > 
> > Reported-by: Martin Doucha <martin.doucha@suse.com>
> > Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >   fs/bcachefs/opts.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> > index e10fc1da71b1..bc5c18087821 100644
> > --- a/fs/bcachefs/opts.c
> > +++ b/fs/bcachefs/opts.c
> > @@ -482,9 +482,8 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
> >   		val = "0";
> >   	}
> >   
> > -	/* Unknown options are ignored: */
> >   	if (id < 0)
> > -		return 0;
> > +		goto bad_opt;  
> As other filesystem done, for unknown options, it prints the `Unknown 
> parameter` to hint the user. May be goto bad_opt is not reasonable.

bad_opt prints an error message naming the invalid option:
521 bad_opt:
522         pr_err("Bad mount option %s", name);
523         ret = -BCH_ERR_option_name;
524         goto out;

Thanks, David
