Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B80C2AD11
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727238295; cv=none; b=kVbUvDggP1Yl1kLIa85V/+ZLwhbSzD3GFvDn1Ubqqclymg4dOCTLpHE3o/rZZpJVUgroFIs0AVb1s+xRzkjocO+iTmImiP8D2GEzssIPDA/4j4ssCoZwJUx77aMuH5ULYIj8SNYfviNh2ZXLszICurbt1vglbBuy6jGOjOu/lnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727238295; c=relaxed/simple;
	bh=idJhXEhjUxBPOP+5UxB+Mjh8nh5Yj1/3Y8m2TrgJbRg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tipeGB2QTGMBrF+dh62gDsUaFakIdlfsXjjZQLjaemXjMKRGL3OG/cEkMn2nIAa9YQNX3caBJS8OLmbSLX95p84jXiCymtjlewW5YkdX2uEJTdqkTtqqte7/uUblrQvWZCZ2G34L50kAuFjq7/FWLLZpG/Z2Hds8N3OAtfafPLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YRu6joq7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+09Ftszv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YRu6joq7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+09Ftszv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YRu6joq7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+09Ftszv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YRu6joq7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+09Ftszv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D1A521A75;
	Wed, 25 Sep 2024 04:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727238291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8kvLlXfAEBntM33j6pzMdixC6MqMc0DEA9+WB4DL5I=;
	b=YRu6joq7+3zGIHgxc1m7sM0wh1tzo0uyUMP9Ew1fYYgNIkxLhTn51eyqqdUlTxCvsE3spc
	PsD5X6FOqCSwZOjhwSOUlaOREMVYBsxVtYS0WUL13Gi+WYtN+nnaguz31xdOPlfMbm9AKb
	BvqEQrknhoiCJWzwk3h7whq8tWZNkc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727238291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8kvLlXfAEBntM33j6pzMdixC6MqMc0DEA9+WB4DL5I=;
	b=+09FtszvDHbTnFaLNnAazVMPUn/fz6nyIs1mHgSKeWMex9vmvmYrJFQzjRGEEQCqp+viV4
	Mu50bXnlucUEAxAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727238291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8kvLlXfAEBntM33j6pzMdixC6MqMc0DEA9+WB4DL5I=;
	b=YRu6joq7+3zGIHgxc1m7sM0wh1tzo0uyUMP9Ew1fYYgNIkxLhTn51eyqqdUlTxCvsE3spc
	PsD5X6FOqCSwZOjhwSOUlaOREMVYBsxVtYS0WUL13Gi+WYtN+nnaguz31xdOPlfMbm9AKb
	BvqEQrknhoiCJWzwk3h7whq8tWZNkc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727238291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8kvLlXfAEBntM33j6pzMdixC6MqMc0DEA9+WB4DL5I=;
	b=+09FtszvDHbTnFaLNnAazVMPUn/fz6nyIs1mHgSKeWMex9vmvmYrJFQzjRGEEQCqp+viV4
	Mu50bXnlucUEAxAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B55413A66;
	Wed, 25 Sep 2024 04:24:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZE5hO5GQ82Y3QQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 25 Sep 2024 04:24:49 +0000
Date: Wed, 25 Sep 2024 04:24:40 +0000
From: David Disseldorp <ddiss@suse.de>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: avoid copy from NULL printbuf
Message-ID: <20240925042440.1b26f58a.ddiss@suse.de>
In-Reply-To: <9136cbac-7603-4732-b8fe-b0cc89cb9e50@huawei.com>
References: <20240924025215.29891-1-ddiss@suse.de>
	<9136cbac-7603-4732-b8fe-b0cc89cb9e50@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Score: -3.30
X-Spam-Flag: NO

On Wed, 25 Sep 2024 10:21:58 +0800, Hongbo Li wrote:

> On 2024/9/24 10:52, David Disseldorp wrote:
> > printbuf.buf may be NULL if allocation_failure is set. Check for this
> > prior to using it as a seq_puts() source.
> > 
> > Fixes: fa8e94faeece1 ("bcachefs: Heap allocate printbufs")
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> > test test
> > 
> >   fs/bcachefs/fs.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> > index 1aee5bafaae54..6e270bf24591d 100644
> > --- a/fs/bcachefs/fs.c
> > +++ b/fs/bcachefs/fs.c
> > @@ -1931,13 +1931,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
> >   {
> >   	struct bch_fs *c = root->d_sb->s_fs_info;
> >   	struct printbuf buf = PRINTBUF;
> > +	int ret = 0;
> >   
> >   	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
> >   			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
> >   	printbuf_nul_terminate(&buf);
> > -	seq_puts(seq, buf.buf);
> > +	if (buf.allocation_failure)
> > +		ret = -ENOMEM;
> > +	else
> > +		seq_puts(seq, buf.buf);
> >     
> May I fix here in the last patch "bcachefs: fix incorrect show_options 
> results" in v2, and add you as co-author?

I'm fine with this being squashed in with or without a co-author tag.
However, I think they deserve separate commits given that they address
separate regressions, and fixing show_options is more critical.

Thanks, David
