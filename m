Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A221B9CF
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Jun 2025 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749493740; cv=none; b=pAqUEjYosKI/2082rTsdtzVWbym+rhKByxoSs1n4x1QyPhz3R1vdDo5QxNMFjvDEwWQUtwAa7FMkvjiwhr3Xym2JBfswMy5sU9ZdOZypAstcj0+stKfsDiyaJfCzWARz57emyXdIZXi59FnOQU4iaTE7GhSoRnLSDPBRBpiM5fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749493740; c=relaxed/simple;
	bh=ipLbgmj0/RbDBE8Zmt1TzEw+CSxoGLoQIMUaaPOKwJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TX7MpRRh7LS4KaMMo5WEQI/Y2Qvzrd/05c98UZltMN1vM9D4UomhW1fVcdOyjhakGy7ndBP3PYdMmFKhezUm1lW0zEO6AMMbSL7lpv0ijmlZ5uo5m31nLW7mLyDCsRXkhSSE6c/5dZM+/fAMuJ8u5nfqoLQ1XM88BjL3YNgzveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p0eTnMvB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dyXKUd4B; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pN4duz4w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VA8ZTEAR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p0eTnMvB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dyXKUd4B";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pN4duz4w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VA8ZTEAR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D45BF1F46E;
	Mon,  9 Jun 2025 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1749493737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vk21obR3rGzVFeoYj3lWx3wONivKGACTaCAsMFKpPBc=;
	b=p0eTnMvBSXQYwXqZpbNeQC8G/EqDbx3+xglPqNHGGzHYRHmdCLhAY2BfHyiaGaWBBCTQwe
	7HWUjoLftHC3yuH5CvU4cltbInalmFKTJuXAW5wyt/S+4webJl9S//1RhMkcrTKZdYIXa4
	iGdIz22uBe2/yiD6W7sYc0WCaEzWNSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1749493737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vk21obR3rGzVFeoYj3lWx3wONivKGACTaCAsMFKpPBc=;
	b=dyXKUd4BeoErH1cyfTQoVexBpEAbb9qGWE/TpFoSIECfm1iZ2AUNR2XLwy3zgBrMTyUbxC
	ZLe2J5nxFDTvwdDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pN4duz4w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VA8ZTEAR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1749493736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vk21obR3rGzVFeoYj3lWx3wONivKGACTaCAsMFKpPBc=;
	b=pN4duz4woPE/ppLyyDdNxXYyGf2g3V0rE269SgAjC0NCIZbgr+sONrwqz+A6reZibIBGBX
	s3+yanoSBm/lJE04cvnoXZq1rstOc1hIlNT1XHxdObpHWekWj4dJI9wUjVMvi13LgC546S
	TXWTRseY68gUPyB9IeERuxysB0yrGuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1749493736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vk21obR3rGzVFeoYj3lWx3wONivKGACTaCAsMFKpPBc=;
	b=VA8ZTEARQF7lhLb3H8o8yGNht9hRcdo1RL1/METHRpOlUEZUz/gPA4Bl4V+nBKzQZIuDDO
	FKMbpmP1D5I2BMAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3F7713A1D;
	Mon,  9 Jun 2025 18:28:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0ZisKugnR2g6MgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Jun 2025 18:28:56 +0000
Message-ID: <13d5ecd9-3e9f-4593-b300-9141941a29cb@suse.cz>
Date: Mon, 9 Jun 2025 20:28:56 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>
Cc: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, josh@joshtriplett.org,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
 <aEXVKNVLI3VQInSc@pc636>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aEXVKNVLI3VQInSc@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,linux.dev,kernel.org];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[80e5d6f453f14a53383a];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: D45BF1F46E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -3.01

On 6/8/25 20:23, Uladzislau Rezki wrote:
> On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
>> 
>> I don't think it's that - syzbot's .config already has that enabled.
>> KASAN, too.
>> 
>> And the only place we do call_rcu() is from rcu_pending.c, where we've
>> got a rearming rcu callback - but we track whether it's outstanding, and
>> we do all relevant operations with a lock held.
>> 
>> And we only use rcu_pending.c with SRCU, not regular RCU.
>> 
>> We do use kfree_rcu() in a few places (all boring, I expect), but that
>> doesn't (generally?) use the rcu callback list.
>>
> Right, kvfree_rcu() does not intersect with regular callbacks, it has
> its own path. 

You mean do to the batching? Maybe the batching should be disabled with
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y if it prevents it from detecting issues?
Otherwise we now have kvfree_rcu_cb() so the special handling of
kvfree_rcu() is gone in in the non-batching case.

> It looks like the problem is here:
> 
> <snip>
>   f = rhp->func;
>   debug_rcu_head_callback(rhp);
>   WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
>   f(rhp);
> <snip>
> 
> we do not check if callback, "f", is a NULL. If it is, the kernel bug
> is triggered right away. For example:
> 
> call_rcu(&rh, NULL);
> 
> @Paul, do you think it makes sense to narrow callers which apparently
> pass NULL as a callback? To me it seems the case of this bug. But we
> do not know the source.
> 
> It would give at least a stack-trace of caller which passes a NULL.

Right, AFAIU this kind of check is now possible, previously NULL was being
interpreted as a valid __is_kvfree_rcu_offset() (i.e. rcu_head at offset 0).

> --
> Uladzislau Rezki
> 

