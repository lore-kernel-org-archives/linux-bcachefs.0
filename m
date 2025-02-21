Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843F81FC105
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 07:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740122469; cv=none; b=sKYOWeu8K77fXf3AaHRByDeIy9GmNoJ+fQZ/QDJ0IDGphH6dEB1nz7H4N5biCa2T5wjdOyDK6NdvYMUTiWXHVYikNAu8swOUmKkJUqVKu3ILKCOvRr8FMMo2Ta5T5nlXG/Zb2FI9ZLucLIZy0z94bQjL3mT25ifPn5TizXVDx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740122469; c=relaxed/simple;
	bh=RyXVz9QronmMKhto+Su1ZQflzE9xicgI8lSDuNKGnro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K5QgV2QUEDlGpiCYjGkXpVPI7ISkPoAHuGpy0/iCA6KR8UthlJ1ZqhLPAUGVF0IDo8vIvyjofypOQ16vBceY3jpUjatf508mqjWyLPcBRbcd5Ghdu7muL+4Zl/+QLHiMhsWE6wBJnx8UEPJW6rhcL7iFzoi1Fhfr7UVszrBtCf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=13ISwTLh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MbEQV4vq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=13ISwTLh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MbEQV4vq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="13ISwTLh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MbEQV4vq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="13ISwTLh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MbEQV4vq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3799F2118A;
	Fri, 21 Feb 2025 07:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740122465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DkakeWbsGukiMnW97oQAx8ayHild3NPAZ1YdIM1LqhI=;
	b=13ISwTLhiHn1g6JSg3URuSubUvJVryUgahfKfZE0yduGwcttNn1ND2BHPvTogl5OH0RZux
	pmNCQ2yMoG3OgEDnZWo7NeqREhlP+/DOoMNW6L5YivITv9L5WhJMKXTGUFuMr10mKDHRew
	4ldtL6b+I5g0bm6dNXfCrnQAv6GHnEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740122465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DkakeWbsGukiMnW97oQAx8ayHild3NPAZ1YdIM1LqhI=;
	b=MbEQV4vqaZlbp7pe95VfxXYVCp+EYDttZ2cCcwwGPz/3UGTkWhioe8BG0GSvRgz0TDKG7r
	PiUT7nhuprGhdUDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=13ISwTLh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MbEQV4vq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740122465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DkakeWbsGukiMnW97oQAx8ayHild3NPAZ1YdIM1LqhI=;
	b=13ISwTLhiHn1g6JSg3URuSubUvJVryUgahfKfZE0yduGwcttNn1ND2BHPvTogl5OH0RZux
	pmNCQ2yMoG3OgEDnZWo7NeqREhlP+/DOoMNW6L5YivITv9L5WhJMKXTGUFuMr10mKDHRew
	4ldtL6b+I5g0bm6dNXfCrnQAv6GHnEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740122465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DkakeWbsGukiMnW97oQAx8ayHild3NPAZ1YdIM1LqhI=;
	b=MbEQV4vqaZlbp7pe95VfxXYVCp+EYDttZ2cCcwwGPz/3UGTkWhioe8BG0GSvRgz0TDKG7r
	PiUT7nhuprGhdUDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1838713888;
	Fri, 21 Feb 2025 07:21:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BJwVA2EpuGf0egAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Feb 2025 07:21:05 +0000
Message-ID: <dd7a2e57-103e-41f4-814b-3087156557ca@suse.cz>
Date: Fri, 21 Feb 2025 08:21:04 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
To: Dennis Zhou <dennis@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org,
 syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com, linux-mm@kvack.org,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Michal Hocko <mhocko@kernel.org>
References: <20250212100625.55860-1-mmpgouride@gmail.com>
 <issmt55cogzyglrmao7hmqdbhvu7n6eii625ydm4irktfkfnrp@wtdbg42tumpr>
 <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
 <78d954b5-e33f-4bbc-855b-e91e96278bef@suse.cz>
 <fld5gkrscoialgpgfrsdig6grx4bbjeaevub4ii7mh234ejhi6@adwkhlzfpvwp>
 <Z7fpEy1fdkEtvIw2@snowbird>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <Z7fpEy1fdkEtvIw2@snowbird>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3799F2118A
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,syzkaller.appspotmail.com,kvack.org,kernel.org,linux.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[fe63f377148a6371a9db];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 2/21/25 03:46, Dennis Zhou wrote:
> Hello,
> 
> On Thu, Feb 20, 2025 at 03:37:26PM -0500, Kent Overstreet wrote:
>> On Thu, Feb 20, 2025 at 06:16:43PM +0100, Vlastimil Babka wrote:
>> > On 2/20/25 11:57, Alan Huang wrote:
>> > > Ping
>> > > 
>> > >> On Feb 12, 2025, at 22:27, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> > >> 
>> > >> Adding pcpu people to the CC
>> > >> 
>> > >> On Wed, Feb 12, 2025 at 06:06:25PM +0800, Alan Huang wrote:
>> > >>> The cycle:
>> > >>> 
>> > >>> CPU0: CPU1:
>> > >>> bc->lock pcpu_alloc_mutex
>> > >>> pcpu_alloc_mutex bc->lock
>> > >>> 
>> > >>> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>> > >>> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>> > >>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> > >> 
>> > >> So pcpu_alloc_mutex -> fs_reclaim?
>> > >> 
>> > >> That's really awkward; seems like something that might invite more
>> > >> issues. We can apply your fix if we need to, but I want to hear with the
>> > >> percpu people have to say first.
>> > >> 
>> > >> ======================================================
>> > >> WARNING: possible circular locking dependency detected
>> > >> 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
>> > >> ------------------------------------------------------
>> > >> syz.0.21/5625 is trying to acquire lock:
>> > >> ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>> > >> 
>> > >> but task is already holding lock:
>> > >> ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>> > >> 
>> > >> which lock already depends on the new lock.
>> > >> 
>> > >> 
>> > >> the existing dependency chain (in reverse order) is:
>> > >> 
>> > >> -> #2 (&bc->lock){+.+.}-{4:4}:
>> > >>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>> > >>       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>> > >>       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>> > >>       bch2_btree_cache_scan+0x184/0xec0 fs/bcachefs/btree_cache.c:482
>> > >>       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
>> > >>       shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
>> > >>       shrink_one+0x43b/0x850 mm/vmscan.c:4868
>> > >>       shrink_many mm/vmscan.c:4929 [inline]
>> > >>       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
>> > >>       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
>> > >>       kswapd_shrink_node mm/vmscan.c:6807 [inline]
>> > >>       balance_pgdat mm/vmscan.c:6999 [inline]
>> > >>       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
>> > >>       kthread+0x7a9/0x920 kernel/kthread.c:464
>> > >>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>> > >>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>> > >> 
>> > >> -> #1 (fs_reclaim){+.+.}-{0:0}:
>> > >>       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>> > >>       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
>> > >>       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
>> > >>       might_alloc include/linux/sched/mm.h:318 [inline]
>> > >>       slab_pre_alloc_hook mm/slub.c:4066 [inline]
>> > >>       slab_alloc_node mm/slub.c:4144 [inline]
>> > >>       __do_kmalloc_node mm/slub.c:4293 [inline]
>> > >>       __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
>> > >>       kmalloc_noprof include/linux/slab.h:905 [inline]
>> > >>       kzalloc_noprof include/linux/slab.h:1037 [inline]
>> > >>       pcpu_mem_zalloc mm/percpu.c:510 [inline]
>> > >>       pcpu_alloc_chunk mm/percpu.c:1430 [inline]
>> > >>       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
>> > >>       pcpu_balance_populated mm/percpu.c:2063 [inline]
>> > >>       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
>> > >>       process_one_work kernel/workqueue.c:3236 [inline]
>> > >>       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
>> > >>       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
>> > >>       kthread+0x7a9/0x920 kernel/kthread.c:464
>> > >>       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>> > >>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>> > 
>> > Seeing this as part of the chain (fs reclaim from a worker doing
>> > pcpu_balance_workfn) makes me think Michal's patch could be a fix to this:
>> > 
>> > https://lore.kernel.org/all/20250206122633.167896-1-mhocko@kernel.org/
>> 
>> Thanks for the link - that does look like just the thing.
> 
> Sorry I missed the first email asking to weigh in.
> 
> Michal's problem is a little bit different than what's happening here.

Yes, but it's related enough. He mentions commit 28307d938fb2 and there you
find a similar kind of lockdep splat.

> He's having an issue where a alloc_percpu_gfp(NOFS/NOIO) is considered
> atomic and failing during probing. This is because we don't have enough
> percpu memory backed to fulfill the "atomic" requests.

That, and we don't allow NOFS/NOIO to take the pcpu_alloc_mutex to avoid
deadlock with pcpu_balance_workfn taking it and then doing __GFP_FS reclaim.

> Historically we've considered any allocation that's not GFP_KERNEL to be
> atomic. Here it seems like the alloc_percpu() behind the bc->lock()
> should have been an "atomic" allocation to prevent the lock cycle?

That's what the original mail/patch in this thread suggested:
https://lore.kernel.org/all/20250212100625.55860-1-mmpgouride@gmail.com/
Note it proposes GFP_NOWAIT, possibly GFP_NOFS would be enough, but then the
current implementation could would make it "atomic" anyway.

But then it could end up failing like the allocations that motivated
Michal's patch? So with Michal's approach we can avoid having to weaken
pcpu_alloc() callers like this. Yes it's counter-intuitive that we weaken a
kworker context instead, which normally has no restrictions. But it's not
weakened (NOIO) nearly as much as pcpu_alloc() users that are effectively
atomic when they can't take pcpu_alloc mutex at all.

> Thanks,
> Dennis
> 

