Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BB077107
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727102384; cv=none; b=VRlnNm0DxuhFeZjynWpGDLJYUxa1MlRw7CL22G4x+TulpheJzBmvb0jcChsTO152Z43sv2Q2uTdGW6RX027OyhClWDZLwvJLlw7GgszRMtKKa2eBGokr0Es4uESViloJ6Z+PnKVh3DFMdw9LYk4mWc23BR1mEuXqQB9HnSUqEgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727102384; c=relaxed/simple;
	bh=dw3GFCJrmmDcqHd4CaOehuctJRT4xY61f+fsYysa2vo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGhw0Y6G8SiNDZQYVg9E1Cwr88/imlGL+JmJNhmU5okLWW4buo/HXdUDPgvEXtgHYqvEVhk9RNwIMxhzDUprp1hGvc72z/0+b9UIzm32lJHq4SVOjydG2g69NaLwgz5iLhsgNCyGqa+PKcVZYVnFpL9ttejmQ8ABWndXcaYUQtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1pNnUXSS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=C8DdRHeK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1pNnUXSS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=C8DdRHeK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1pNnUXSS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="C8DdRHeK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1pNnUXSS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="C8DdRHeK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6464D1F387;
	Mon, 23 Sep 2024 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727102380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHFjsLjZz4HH1Dh+ku0WrWiy5CAdwo+wruB0BhNYzCQ=;
	b=1pNnUXSSCb8DocKFhAXwBfFLjMH58Mdu4CDJUkx4uo9o3N+w5gnzJesHwFPW5u5SPtLPLS
	3vhYK9G5xCs5cXH362vfBNHDPpZvt2hsfDESs+0nqgP6060Ek35jcfYqi+vIslnd9RD/kk
	q5sPY4ItGT6b9+jzRLgUOkEOkfOGEqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727102380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHFjsLjZz4HH1Dh+ku0WrWiy5CAdwo+wruB0BhNYzCQ=;
	b=C8DdRHeKjmdQHj8fPgWDPLn7N5vBfjZLuiOb/6pGJUY36VWcq9lA57uZSO/l0UdbbcJ6va
	SS0gmjw1+BKqeYAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1pNnUXSS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C8DdRHeK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727102380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHFjsLjZz4HH1Dh+ku0WrWiy5CAdwo+wruB0BhNYzCQ=;
	b=1pNnUXSSCb8DocKFhAXwBfFLjMH58Mdu4CDJUkx4uo9o3N+w5gnzJesHwFPW5u5SPtLPLS
	3vhYK9G5xCs5cXH362vfBNHDPpZvt2hsfDESs+0nqgP6060Ek35jcfYqi+vIslnd9RD/kk
	q5sPY4ItGT6b9+jzRLgUOkEOkfOGEqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727102380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHFjsLjZz4HH1Dh+ku0WrWiy5CAdwo+wruB0BhNYzCQ=;
	b=C8DdRHeKjmdQHj8fPgWDPLn7N5vBfjZLuiOb/6pGJUY36VWcq9lA57uZSO/l0UdbbcJ6va
	SS0gmjw1+BKqeYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7504D13A64;
	Mon, 23 Sep 2024 14:39:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DIj8Cap98WbWZgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 23 Sep 2024 14:39:38 +0000
Date: Mon, 23 Sep 2024 14:39:31 +0000
From: David Disseldorp <ddiss@suse.de>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>,
 <liaochang1@huawei.com>
Subject: Re: [PATCH] bcachefs: fix incorrect show_options results
Message-ID: <20240923143931.3a24e3c9.ddiss@suse.de>
In-Reply-To: <20240923095003.3559171-1-lihongbo22@huawei.com>
References: <20240923095003.3559171-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6464D1F387
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.51
X-Spam-Flag: NO

On Mon, 23 Sep 2024 17:50:03 +0800, Hongbo Li wrote:

> When call show_options in bcachefs, the options buffer is appeneded
> to the seq variable. In fact, it requires an additional comma to be
> appended first. This will affect the remount process when reading
> existing mount options.
> 
> Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")

Ah, that'd explain why I wasn't seeing this alongside the
fail-on-unknown-opt fix. FWIW, this first appears in
bcachefs-2024-09-21 as 3621ecc10f831f4fd27784083dfaf5b8481098b5 .

> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index e774cb3e6b1a..79c3a650b714 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1927,7 +1927,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>  	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
>  			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>  	printbuf_nul_terminate(&buf);
> -	seq_puts(seq, buf.buf);
> +	seq_printf(seq, ",%s", buf.buf);

Looks okay, although it might be simpler to just drop the !first
conditionals from bch2_opts_to_text() as things were prior to the
regression.

>  	int ret = buf.allocation_failure ? -ENOMEM : 0;

Should the copy from buf into seq occur if allocation_failure
is already flagged? I'd expect seq_puts() to have oopsed.
