Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E4B1E98EF
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167092; cv=none; b=IBdrOHLsnBJ+isdp+0faoHgJ1HlnkIqfwlWMkfK+SrNvtjfmsfP9iF1e2rNRUKNHPgAJbwrS0iKAPFQWBGWvmKeqU334FXI3QqX6VZ6xgOwLETEcz4hYqHdZjp/mOuAz5HuKIyhG0S5k3h48NB5mW1EGRMa8HY9e8zdHgvPzSkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167092; c=relaxed/simple;
	bh=SLyAzh32UqaCPlF6eqy7LHpLwc7EeUvbYVVrTTONmHg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mN+hAM0UYLFgimcSUjGBG/pwslVLomR8tnFnwV8c6zJxcXI8nj62qrxrb3+gicX2fjKqllj9/eMi6mgsq/t8/PWBZk2z60O+E2ogbR3YhqI+noLa5gZi6IMemLrkSrXHnsrvebV91psZpbmZYV8dJmYHZa1xPXQnX7+awvrwvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kx+zdUn1; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kx+zdUn1"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6fb73240988so16791027b3.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 11:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740167090; x=1740771890; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZjnVAd0Kk3hsZLXO7/QTBdvrnQz6hHcWXWZZevM+TY=;
        b=kx+zdUn1tgNNiqmxDFJR5Mplc/LIEGZhkVN+LVxHhPQ9Eg7EvJOAs8qKmHFuSfdQ0O
         Y4rU2nbcxqSNDMrRCAW63qAaqWOJ5KJvvlfzLJ8fSumsv1bfioS/KbmDvQEej6vC6LGH
         GHHekcRKLKto6ZYcQP6gsZn4+lgCkdIv36Ln0VlTMpFocf4Tk8QyWrvXzhHY6OD2Q0Q4
         0DUUuQBMSi8vO6Hp5+bNSuBLuATnt8DaCPqGcWYcsqh9HjN7CzPfJV6B/KpZoKAsYXMQ
         hek7Hv1Y8RFeOCMQN3I8gvsXCfFe6Rk7TRqp5tza4wcKdHravFQKp3YNWwKQj2nGkIIR
         cihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740167090; x=1740771890;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZjnVAd0Kk3hsZLXO7/QTBdvrnQz6hHcWXWZZevM+TY=;
        b=N4qRzP91O0J/Mwl4buLaRyqlAeDAbKgFwCDt/XbQgGTU1SISV7QIqVvvXsJ2UaIy54
         qjnp3NwSAljAfE4Fr3Texwk76nagjF6iyg2JcQfnMt6WNZ8pKJ8ZoBfhN4mLCYyvK0/V
         KNEplvi9Vtm/yHqtagZ8Qse2qGm3T1HkYbcgeiX1iOuD5sjIb5J+t8KAbB1NBSUiyLW5
         B2BWjyMTZiQtCKQZPrfsFpBe+4wpcpFnASeq+2xTODZs5UyQhfcWD3UnWSzrvf15G/X4
         L0052+iW1D3yKTQHYxzyTzbEUoKSdBx2FMG7CzhizUXVYHMXmYt6+6BcQiH1+83yLYIT
         FE8w==
X-Forwarded-Encrypted: i=1; AJvYcCUBSEh8n5Ot3gKjLSgnMdxqTpdwd3JVZJ6kKRvEK+infw902xPqEQ0chWNYMRVQZtbpBtnKqWX7sMnoDCwgDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT8Fh2zxYF05biBJHRZXEfP7pvoscipuWDwtE2Fw5Y3hOTsm+4
	7gdCDlqiYqLrfi+UOVTC57RlaI4v5V/nw+S8tzwwePSKM8Rf9Ib9
X-Gm-Gg: ASbGncuzEo8oH3BKydeTzoRkXKPKfydI1V0gYNAXgKp4V9GU8ebEK7AUPLO4spGNS+m
	A42EB2CTiDcXMNtICbin1xqJAJAozl2OyKaWplkdTGntw8oZIvbjY1At+9c/2o99Pdmc6+jPMKJ
	CCyDnGRBfYxgBgell9W2NWbCB+0PYqf8//swpwg4ThW6rTmF6HzNPOPsw3MiWm8fLRs6nf5NRrG
	RP0Wzzz5ZLs+OWy9e8lNU18wiLuciUMM9SIOPKgjfwTUVkA4b9oN8ttpzgyjhlQIDLw9yR4+vAA
	8M4lGJpMNg==
X-Google-Smtp-Source: AGHT+IHpltLlzQ5mPajgCil6CZ5jnzSzFVk0xzORVfZFBTS6ypJav0O4fpnuxPf6St2J7iSoRLwJmg==
X-Received: by 2002:a05:690c:c18:b0:6fb:a467:bff4 with SMTP id 00721157ae682-6fbcc365f4amr42366297b3.24.1740167089631;
        Fri, 21 Feb 2025 11:44:49 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fb6f89cd50sm29235837b3.69.2025.02.21.11.44.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Feb 2025 11:44:49 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <Z7fpEy1fdkEtvIw2@snowbird>
Date: Sat, 22 Feb 2025 03:44:33 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>,
 linux-bcachefs@vger.kernel.org,
 syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com,
 linux-mm@kvack.org,
 Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>,
 Michal Hocko <mhocko@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <92074FA7-F37E-49E7-810B-55ACD187EC0F@gmail.com>
References: <20250212100625.55860-1-mmpgouride@gmail.com>
 <issmt55cogzyglrmao7hmqdbhvu7n6eii625ydm4irktfkfnrp@wtdbg42tumpr>
 <25FBAAE5-8BC6-41F3-9A6D-65911BA5A5D7@gmail.com>
 <78d954b5-e33f-4bbc-855b-e91e96278bef@suse.cz>
 <fld5gkrscoialgpgfrsdig6grx4bbjeaevub4ii7mh234ejhi6@adwkhlzfpvwp>
 <Z7fpEy1fdkEtvIw2@snowbird>
To: Dennis Zhou <dennis@kernel.org>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Feb 21, 2025, at 10:46, Dennis Zhou <dennis@kernel.org> wrote:
>=20
> Hello,
>=20
> On Thu, Feb 20, 2025 at 03:37:26PM -0500, Kent Overstreet wrote:
>> On Thu, Feb 20, 2025 at 06:16:43PM +0100, Vlastimil Babka wrote:
>>> On 2/20/25 11:57, Alan Huang wrote:
>>>> Ping
>>>>=20
>>>>> On Feb 12, 2025, at 22:27, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>>>>>=20
>>>>> Adding pcpu people to the CC
>>>>>=20
>>>>> On Wed, Feb 12, 2025 at 06:06:25PM +0800, Alan Huang wrote:
>>>>>> The cycle:
>>>>>>=20
>>>>>> CPU0: CPU1:
>>>>>> bc->lock pcpu_alloc_mutex
>>>>>> pcpu_alloc_mutex bc->lock
>>>>>>=20
>>>>>> Reported-by: =
syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>>>>>> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
>>>>>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>>>>>=20
>>>>> So pcpu_alloc_mutex -> fs_reclaim?
>>>>>=20
>>>>> That's really awkward; seems like something that might invite more
>>>>> issues. We can apply your fix if we need to, but I want to hear =
with the
>>>>> percpu people have to say first.
>>>>>=20
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>>>> WARNING: possible circular locking dependency detected
>>>>> 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0 Not tainted
>>>>> ------------------------------------------------------
>>>>> syz.0.21/5625 is trying to acquire lock:
>>>>> ffffffff8ea19608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: =
pcpu_alloc_noprof+0x293/0x1760 mm/percpu.c:1782
>>>>>=20
>>>>> but task is already holding lock:
>>>>> ffff888051401c68 (&bc->lock){+.+.}-{4:4}, at: =
bch2_btree_node_mem_alloc+0x559/0x16f0 fs/bcachefs/btree_cache.c:804
>>>>>=20
>>>>> which lock already depends on the new lock.
>>>>>=20
>>>>>=20
>>>>> the existing dependency chain (in reverse order) is:
>>>>>=20
>>>>> -> #2 (&bc->lock){+.+.}-{4:4}:
>>>>>      lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>>>>      __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>>>>>      __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
>>>>>      bch2_btree_cache_scan+0x184/0xec0 =
fs/bcachefs/btree_cache.c:482
>>>>>      do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
>>>>>      shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
>>>>>      shrink_one+0x43b/0x850 mm/vmscan.c:4868
>>>>>      shrink_many mm/vmscan.c:4929 [inline]
>>>>>      lru_gen_shrink_node mm/vmscan.c:5007 [inline]
>>>>>      shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
>>>>>      kswapd_shrink_node mm/vmscan.c:6807 [inline]
>>>>>      balance_pgdat mm/vmscan.c:6999 [inline]
>>>>>      kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
>>>>>      kthread+0x7a9/0x920 kernel/kthread.c:464
>>>>>      ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>>>>      ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>>>>=20
>>>>> -> #1 (fs_reclaim){+.+.}-{0:0}:
>>>>>      lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>>>>      __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
>>>>>      fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
>>>>>      might_alloc include/linux/sched/mm.h:318 [inline]
>>>>>      slab_pre_alloc_hook mm/slub.c:4066 [inline]
>>>>>      slab_alloc_node mm/slub.c:4144 [inline]
>>>>>      __do_kmalloc_node mm/slub.c:4293 [inline]
>>>>>      __kmalloc_noprof+0xae/0x4c0 mm/slub.c:4306
>>>>>      kmalloc_noprof include/linux/slab.h:905 [inline]
>>>>>      kzalloc_noprof include/linux/slab.h:1037 [inline]
>>>>>      pcpu_mem_zalloc mm/percpu.c:510 [inline]
>>>>>      pcpu_alloc_chunk mm/percpu.c:1430 [inline]
>>>>>      pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
>>>>>      pcpu_balance_populated mm/percpu.c:2063 [inline]
>>>>>      pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2200
>>>>>      process_one_work kernel/workqueue.c:3236 [inline]
>>>>>      process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
>>>>>      worker_thread+0x870/0xd30 kernel/workqueue.c:3398
>>>>>      kthread+0x7a9/0x920 kernel/kthread.c:464
>>>>>      ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>>>>      ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>>=20
>>> Seeing this as part of the chain (fs reclaim from a worker doing
>>> pcpu_balance_workfn) makes me think Michal's patch could be a fix to =
this:
>>>=20
>>> =
https://lore.kernel.org/all/20250206122633.167896-1-mhocko@kernel.org/
>>=20
>> Thanks for the link - that does look like just the thing.
>=20
> Sorry I missed the first email asking to weigh in.
>=20
> Michal's problem is a little bit different than what's happening here.
> He's having an issue where a alloc_percpu_gfp(NOFS/NOIO) is considered
> atomic and failing during probing. This is because we don't have =
enough
> percpu memory backed to fulfill the "atomic" requests.
>=20
> Historically we've considered any allocation that's not GFP_KERNEL to =
be
> atomic. Here it seems like the alloc_percpu() behind the bc->lock()
> should have been an "atomic" allocation to prevent the lock cycle?

I think so, if I understand it correctly, NOFS/NOIO could invoke the =
shrinker, so we=20
can lock bc->lock again. And I think we should not rely on the =
implementation of=20
alloc_percpu_gfp, but the GFP flags instead.

Correct me if I'm wrong.

> Thanks,
> Dennis

