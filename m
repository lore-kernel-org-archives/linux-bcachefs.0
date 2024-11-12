Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1473220CCE9
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 09:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731405041; cv=none; b=cU0c5hgxDQVmRYO3Dt7qM1yuVp/FGqtqPkkFmQGwfxLnAXWuOMnZkVXpocGBYynTFBgGG9M5MlOxB0q+waGWr2qX/5BvXBjpCZ2kz9dq2pW9Y18JKKU1ZBHe9YQxV8cM5C7mfN+idqNKD07rFHIzWjI46JpjAlaJ8CmuO2rsXTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731405041; c=relaxed/simple;
	bh=icSWUp9KJROKbJNoKxAMX1mosalyWHx3ga1RtOk1QVU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+iF65LnCon/RGmZzwZ1oBB9Kmqb1BjNuoyZ3dY4/n0VURSdBVL0rcVlpW2UrM+yIaGm88cJj0/ib78kHQLZF5bUCMOLCk4dm1pSDidwUyZDzgqn8N4RP/m7VGwCp7BY43eNWqv2OFNgYugNpRHlLGjJ5URP4oB6ILMtJnJ5BU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XmHavjY4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8FUIjQdy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XmHavjY4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8FUIjQdy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XmHavjY4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8FUIjQdy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XmHavjY4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8FUIjQdy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 22B54216E0;
	Tue, 12 Nov 2024 09:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731405038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02Q3EqRjsrrDtReKAnZy72P7Q5/AfXxrQTA60jTQHAk=;
	b=XmHavjY4ETU96nh0jLi7nB3oGsCpAy2SwyIxgrMrHvOHFe1kBbBTisCuJv1rparDYf4KGY
	P8UXCXN1hA6twdtRZWOfaX0vuyYOAbmroZyuSb2uzA5Sy3hhVf8ZoUhkyDPuOBW4qwKJ/F
	nP+D4V1ZzNWtq4neUfg4tiiYTVGTfyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731405038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02Q3EqRjsrrDtReKAnZy72P7Q5/AfXxrQTA60jTQHAk=;
	b=8FUIjQdyCDQOeJGSMcfIvXP4CRABjysYEZOU00SW5F9oCncHGSvSAhJjiXoG6U/d2IhmhH
	HGSWvHjGC86fm2Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XmHavjY4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8FUIjQdy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731405038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02Q3EqRjsrrDtReKAnZy72P7Q5/AfXxrQTA60jTQHAk=;
	b=XmHavjY4ETU96nh0jLi7nB3oGsCpAy2SwyIxgrMrHvOHFe1kBbBTisCuJv1rparDYf4KGY
	P8UXCXN1hA6twdtRZWOfaX0vuyYOAbmroZyuSb2uzA5Sy3hhVf8ZoUhkyDPuOBW4qwKJ/F
	nP+D4V1ZzNWtq4neUfg4tiiYTVGTfyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731405038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02Q3EqRjsrrDtReKAnZy72P7Q5/AfXxrQTA60jTQHAk=;
	b=8FUIjQdyCDQOeJGSMcfIvXP4CRABjysYEZOU00SW5F9oCncHGSvSAhJjiXoG6U/d2IhmhH
	HGSWvHjGC86fm2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CDB113721;
	Tue, 12 Nov 2024 09:50:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YYkkFewkM2ckJQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 12 Nov 2024 09:50:36 +0000
Date: Tue, 12 Nov 2024 20:50:25 +1100
From: David Disseldorp <ddiss@suse.de>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] bcachefs: avoid copy from NULL printbuf when
 allocation failure
Message-ID: <20241112205025.6eb8c1d3.ddiss@suse.de>
In-Reply-To: <20241112074745.407848-3-lihongbo22@huawei.com>
References: <20241112074745.407848-1-lihongbo22@huawei.com>
	<20241112074745.407848-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 22B54216E0
X-Spam-Score: -3.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 12 Nov 2024 15:47:44 +0800, Hongbo Li wrote:

> printbuf.buf may be NULL if allocation_failure is true. Check
> for this prior to using it as a seq_printf source.
> 
> Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
> Signed-off-by: David Disseldorp <ddiss@suse.de>

This is quite different compared to the patch I initially submitted, so
please drop my sign-off tag.

Thanks, David
