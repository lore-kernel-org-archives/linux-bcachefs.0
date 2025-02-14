Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49DF193086;
	Fri, 14 Feb 2025 20:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739565290; cv=none; b=WvK7uiEMQoJvrdAMFwaock+KZDVwbIWyC9r+nYbzAHbHtMvyKf64cqrQxpa7Ma8SZDKJC0bJX3A3TdaSMGcip+bTTgtT9FDD0nQ0XvZm9lk11gkwj/OuddGDm+lBeO11MtuM/QS67bTQl0hsfQg/dg7Qwb4DDPo1yq5JN9hpdeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739565290; c=relaxed/simple;
	bh=u/t8g1NoWnmHSSICBYNjJuB6CkcEz3PNfsqxDMlVi0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaUc/7vQ34hfR7Kb0POeghy7ic3lu8DPH9T7Jq+hgm71JfA/mMVkxiLpj9fxA4NssRfzj9TVrswNPXbq6iJWjrvQT3Y1n+0d1pcmYjGN3aHG0lPSEhrWJsL8Mt2/AtV7PyC/uyrQdUGJdg7H7MAsC7wRswas5WLf366s30C0hqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n2exppF8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n2exppF8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4Gk+Gl41zV4/ds48dGjzz+nvq0u8MT2WvURHCtpUanw=; b=n2exppF8s2burixSMpwn3wasvK
	+TXXN6vr9sgEwCGjwMEUaL+IOv+5e7iRBk/2Zk/Re27Kzf5mwBiR/FqH0vmSv3vME9pNO3jC7S2iO
	5iTbWyGVoTsQk4FvNP0erjFirJFmjkXr7ysIhs6++si6ay0f+ShJ9yoqiLfNLpx+TO11UneqGKcxB
	aaEien3nMOyhR757w/PQgEe+7hXcEQ5NAqifBlcOcmfRqg4SIBLerUD6zBdxztn/eEKdbQuEKSwG6
	qH0SlP+3sdBbjg/OETbRv05l69sgXBjxAp4Tv9eQvUy+VbvlaDr4qgXsZ6RVyCzyYQX8ncclugWc8
	6dA7NArw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tj2Ob-0000000C1V6-0TlA;
	Fri, 14 Feb 2025 20:34:45 +0000
Date: Fri, 14 Feb 2025 20:34:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: syzbot <syzbot+2110ef46097c323451eb@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] [bcachefs?] KASAN: slab-out-of-bounds Read in
 folio_try_get
Message-ID: <Z6-o5A4Y-rf7Hq8j@casper.infradead.org>
References: <67afa09f.050a0220.21dd3.0053.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67afa09f.050a0220.21dd3.0053.GAE@google.com>

On Fri, Feb 14, 2025 at 11:59:27AM -0800, syzbot wrote:
> BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> BUG: KASAN: slab-out-of-bounds in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> BUG: KASAN: slab-out-of-bounds in page_ref_count include/linux/page_ref.h:67 [inline]
> BUG: KASAN: slab-out-of-bounds in page_ref_add_unless include/linux/page_ref.h:237 [inline]
> BUG: KASAN: slab-out-of-bounds in folio_ref_add_unless include/linux/page_ref.h:248 [inline]
> BUG: KASAN: slab-out-of-bounds in folio_try_get+0xde/0x350 include/linux/page_ref.h:264
> Read of size 4 at addr ffff88804f904b34 by task syz-executor127/5388
> 
> CPU: 0 UID: 0 PID: 5388 Comm: syz-executor127 Not tainted 6.14.0-rc2-syzkaller-00056-gab68d7eb7b1a #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:489
>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
>  page_ref_count include/linux/page_ref.h:67 [inline]
>  page_ref_add_unless include/linux/page_ref.h:237 [inline]
>  folio_ref_add_unless include/linux/page_ref.h:248 [inline]
>  folio_try_get+0xde/0x350 include/linux/page_ref.h:264
>  filemap_get_entry+0x240/0x3b0 mm/filemap.c:1870
>  shmem_get_folio_gfp+0x285/0x1840 mm/shmem.c:2446
>  shmem_get_folio mm/shmem.c:2628 [inline]
>  shmem_write_begin+0x165/0x350 mm/shmem.c:3278
>  generic_perform_write+0x346/0x990 mm/filemap.c:4189
>  shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
>  new_sync_write fs/read_write.c:586 [inline]
>  vfs_write+0xacf/0xd10 fs/read_write.c:679
>  ksys_write+0x18f/0x2b0 fs/read_write.c:731
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb60d00ef1f
> Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 19 81 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 6c 81 02 00 48
> RSP: 002b:00007fb60c7b9fb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fb60c7b9ff0 RCX: 00007fb60d00ef1f
> RDX: 0000000001000000 RSI: 00007fb604200000 RDI: 0000000000000003
> RBP: 00007fb60d0976e0 R08: 0000000000000000 R09: 000000000000590c
> R10: 0000000000000002 R11: 0000000000000293 R12: 00007fb60d0976ec
> R13: 00007fb60c7ba030 R14: 0000000000000003 R15: 00007ffe9f1d73d8
>  </TASK>
> 
> The buggy address belongs to the object at ffff88804f904b00
>  which belongs to the cache radix_tree_node of size 576
> The buggy address is located 52 bytes inside of
>  allocated 576-byte region [ffff88804f904b00, ffff88804f904d40)

Wait, what?  We're calling folio_try_get() on a pointer which isn't a
pointer to a folio, but a pointer to somewhere in a radix_tree_node?

This fits a pattern we're seeing a lot of recently.
Bugs:

https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
https://syzkaller.appspot.com/bug?extid=8ae0902c29b15a27a4ee
https://syzkaller.appspot.com/bug?extid=07392c132f11b1758ac3
https://syzkaller.appspot.com/bug?extid=fe375f77ba1a6ab944b6
https://syzkaller.appspot.com/bug?extid=a0ae55e3dde11d2d790c

They all fit the form of syzbot mounts a (potentially fuzzed?) bcachefs
file system and later we have a corruption in the radix tree.

I have two suspicions (feel free to assign your own probabilities to which
is correct).  The first is that a bunch of tweaky little cleanups went
into the xarray code in the last merge window.  I really wish we could
stop doing that kind of bullshit.  Can we just agree that the xarray
code is good enough and not keep pissing with it?  Obviously if there's
a bug, then we should fix it (and that should come with test cases!),
but otherwise just leave it alone.  Please.  It would make finding this
kind of problem much easier.

The second is that bcachefs has a random memory stomper.  That would
suck.  Kent, you said you had some automated tooling to feed syzbot
reproducers into?

