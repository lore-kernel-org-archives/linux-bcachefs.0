Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2FC218D91
	for <linux-bcachefs@vger.kernel.org>; Fri, 11 Oct 2024 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656944; cv=none; b=YvrlleJG8aiPVNN9Q6c34U6UYvZ1qwwyZ2Tnef14Y9GGHkxMmOGwvoRXFh3+WoaobvFSwu3lsrSUJUd6GvQ0erwgmmyk+baZWiBuT+yQPZPZ1Jxa6gltUOyWd0YkSOw2V84CEqVkrODw/FqO5QH7zWha1oMYC5+Y3zUwl3j75Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656944; c=relaxed/simple;
	bh=1uetXB3URx+T8S+Js+VDeB/Dr9RedIJ+rI9U/sZjjLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEfjUycvUf6x6bVYAUZZsLdBW1jnrZukPmYSQeexdlnwB7vCZo2NjdbygSTehlZyCAFQS08gZMDkNoe0SZyIFakI4HASpww38BDUKcDSGBhc/8XOCwej/fFd4mbFdYB8XSoapUw++GSqSidDcdw9NFvAiYBirZ68ErmHxg23+rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DWrtgYs+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hevGWRI2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DWrtgYs+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hevGWRI2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DWrtgYs+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hevGWRI2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DWrtgYs+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hevGWRI2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B0B5A1F80C;
	Fri, 11 Oct 2024 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728656940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jJVKak38CsMVJTyJyuzoj0rNzr+oPmPtdtTUyQf2lSU=;
	b=DWrtgYs+OHAB2AxdfFO0Jtv1xOfTOwxg4wB1OwUMb2St+WQ9rWFitRSVVku1fWrplLtyAj
	WFftIPoxIH6v3I0VFUr+ig845AeMuoFi2VVpZL7m1PZUF7h0ZONcR0lt+cydWrn/TB4ed4
	C72qL5iyp2FM+gOXogDJDY/kKD9wcZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728656940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jJVKak38CsMVJTyJyuzoj0rNzr+oPmPtdtTUyQf2lSU=;
	b=hevGWRI211lxdcSr46Npnv92yBh/LZiMq3weGj6HZc9sUa1xS0BseiMlkhKaVJ7GkFajny
	jLh7F8nXgz/TcWAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DWrtgYs+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hevGWRI2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728656940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jJVKak38CsMVJTyJyuzoj0rNzr+oPmPtdtTUyQf2lSU=;
	b=DWrtgYs+OHAB2AxdfFO0Jtv1xOfTOwxg4wB1OwUMb2St+WQ9rWFitRSVVku1fWrplLtyAj
	WFftIPoxIH6v3I0VFUr+ig845AeMuoFi2VVpZL7m1PZUF7h0ZONcR0lt+cydWrn/TB4ed4
	C72qL5iyp2FM+gOXogDJDY/kKD9wcZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728656940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jJVKak38CsMVJTyJyuzoj0rNzr+oPmPtdtTUyQf2lSU=;
	b=hevGWRI211lxdcSr46Npnv92yBh/LZiMq3weGj6HZc9sUa1xS0BseiMlkhKaVJ7GkFajny
	jLh7F8nXgz/TcWAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE1A7136E0;
	Fri, 11 Oct 2024 14:28:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZZbIISs2CWeuFQAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 11 Oct 2024 14:28:59 +0000
Date: Fri, 11 Oct 2024 22:28:55 +0800
From: Coly Li <colyli@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] closures: Add closure_wait_event_timeout()
Message-ID: <gcrqwhvzsp4a4slsz56ias4uqmac2x7uadczcfdtevdwx3vji4@kk4kraxxm5vt>
References: <20241009235315.2249725-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241009235315.2249725-1-kent.overstreet@linux.dev>
X-Rspamd-Queue-Id: B0B5A1F80C
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, Oct 09, 2024 at 07:53:14PM -0400, Kent Overstreet wrote:
> Add a closure version of wait_event_timeout(), with the same semantics.
> 
> The closure version is useful because unlike wait_event(), it allows
> blocking code to run in the conditional expression.
> 
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  include/linux/closure.h | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/include/linux/closure.h b/include/linux/closure.h
> index 2af44427107d..880fe85e35e9 100644
> --- a/include/linux/closure.h
> +++ b/include/linux/closure.h
> @@ -454,4 +454,39 @@ do {									\
>  		__closure_wait_event(waitlist, _cond);			\
>  } while (0)
>  
> +#define __closure_wait_event_timeout(waitlist, _cond, _until)		\
> +({									\
> +	struct closure cl;						\
> +	long _t;							\
> +									\
> +	closure_init_stack(&cl);					\
> +									\
> +	while (1) {							\
> +		closure_wait(waitlist, &cl);				\
> +		if (_cond) {						\
> +			_t = max_t(long, 1L, _until - jiffies);		\
> +			break;						\
> +		}							\
> +		_t = max_t(long, 0L, _until - jiffies);			\
> +		if (!_t)						\
> +			break;						\
> +		closure_sync_timeout(&cl, _t);				\
> +	}								\
> +	closure_wake_up(waitlist);					\
> +	closure_sync(&cl);						\
> +	_t;								\
> +})
> +
> +/*
> + * Returns 0 if timeout expired, remaining time in jiffies (at least 1) if
> + * condition became true
> + */
> +#define closure_wait_event_timeout(waitlist, _cond, _timeout)		\
> +({									\
> +	unsigned long _until = jiffies + _timeout;			\
> +	(_cond)								\
> +		? max_t(long, 1L, _until - jiffies)			\
> +		: __closure_wait_event_timeout(waitlist, _cond, _until);\
> +})
> +
>  #endif /* _LINUX_CLOSURE_H */
> -- 
> 2.45.2
> 

-- 
Coly Li
