Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAB1B85C2
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146378; cv=none; b=AOGlI7gukQko3y8FjqtZoZX2VTuvRD3MgIQ5YDSm2X4P7RHPYlgj3+soIWWFZERkx565moXN7tB4Kbm66i/eoWiH/2HnUcuo2LDrFGTiIYYrBg9ZahzGJw49ZOEVeAiJV8G/HgZwhsWLJwtb0fYDpU6qwBcSuz45SxL+SMBX6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146378; c=relaxed/simple;
	bh=L3HAST4JleeE3SzTlEGrqiBBW4LUYlv9tmAX1cMyIZU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvAO02oc+ehRIzEis8MfjWNXRB4/LZExVXIVwWE4zGdWPO1qj+saVSG2PHTf5NbXHLgD6drQQE+RXNcO8uBqHc4FOP1L72yLRBZiI6o0xmyf725qLd9k7HfTqN1YnIgcQI95ichB4iMNjRUvufPd4euAHgFM0TrzLV0BZ4BXbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KQ5yUqF9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7Uk+0QrU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=udYW1zY9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cTnknbsQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KQ5yUqF9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7Uk+0QrU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="udYW1zY9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cTnknbsQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C4C321FBB7;
	Tue, 24 Sep 2024 02:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727146374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYqe9kHfvQFZPrGXV0wIekNM34NxflpOQSSK5+0vJmQ=;
	b=KQ5yUqF9pbhvTertXDPTj49gaBU9bQmQjY6QAweSoY4a8ZI/2qV68bmo8PPJVIXrTxPSiG
	Jzt2RsRxHovis0PVdJnGOe8f+zmLVger0A25ITWkjKRfTaPMJBc3JljtV0kaUKFyROSjhU
	TWNUKZDrJ76/mXn9OWJeYADJIe01KIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727146374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYqe9kHfvQFZPrGXV0wIekNM34NxflpOQSSK5+0vJmQ=;
	b=7Uk+0QrUZ5Xvk2Hzz4sytWxUjERXbyOJmN5N5DYidxfsURys4JR8U1fPgqoVp1inJhsFg1
	wXB6s5+WOzV4Z1Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=udYW1zY9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cTnknbsQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727146373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYqe9kHfvQFZPrGXV0wIekNM34NxflpOQSSK5+0vJmQ=;
	b=udYW1zY9sC5SU2MmOtE9vj6OjZLhroTuMqEE62ehxqodRU2axJK7kl0VwSMwphI4mkEUgJ
	+JVQx/NbR+2iFFzqevuUdRpYfgG3zRsHJ3ZEl2PsCL3BwxpDzqRDrzOIrYA1+EpXt3svlz
	WjTKdnKIDJXwlYmGMDZuhELB5T3q9ls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727146373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYqe9kHfvQFZPrGXV0wIekNM34NxflpOQSSK5+0vJmQ=;
	b=cTnknbsQc4wUfBfFjWYMMUfrvNogyJCv6x1tOeOgS+6wjOPtF1vbF19MHbfwbQzg0cIPem
	/fx542x4FWMLsACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDFA71386E;
	Tue, 24 Sep 2024 02:52:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lXFmH4Mp8maJIQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 24 Sep 2024 02:52:51 +0000
Date: Tue, 24 Sep 2024 02:52:42 +0000
From: David Disseldorp <ddiss@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org,
 liaochang1@huawei.com
Subject: Re: [PATCH] bcachefs: fix incorrect show_options results
Message-ID: <20240924025242.39f29fe8.ddiss@suse.de>
In-Reply-To: <sufy3jfju76sqh4eplc5hmsrfrpa4dtt3bocovfeygxclkvgql@ukd2pvvxn5jr>
References: <20240923095003.3559171-1-lihongbo22@huawei.com>
	<20240923143931.3a24e3c9.ddiss@suse.de>
	<sufy3jfju76sqh4eplc5hmsrfrpa4dtt3bocovfeygxclkvgql@ukd2pvvxn5jr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C4C321FBB7
X-Spam-Level: 
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.51
X-Spam-Flag: NO

On Mon, 23 Sep 2024 17:40:05 -0400, Kent Overstreet wrote:
> On Mon, Sep 23, 2024 at 02:39:31PM GMT, David Disseldorp wrote:
...
> > >  	int ret = buf.allocation_failure ? -ENOMEM : 0;  
> > 
> > Should the copy from buf into seq occur if allocation_failure
> > is already flagged? I'd expect seq_puts() to have oopsed.
> 
> That's a good point; it might be the first allocation that fails, not a
> realloc. It won't be in practice, buuuut....

I've sent a follow-up patch to avoid the seq_puts(seq, NULL). Feel free
to squash it in with this if you like.
