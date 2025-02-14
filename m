Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208A18BBBB
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 20:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739566647; cv=none; b=Iribb4W9/VUbvj4ZVBnG4JT/sWdbJibA2eQuOgLyN5xNJQ8lO9l8FR4tFkluUMQlrBkOjjqlyDvK2n9UYLmbK7oMtzpeZnDLIYisn25HJMJte3iR9iRZRrJJNtUPnnYzlwzbdNchCZy0Z20PIq5SL2gNMgGIFQ0iUJP5X+sPQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739566647; c=relaxed/simple;
	bh=NZQ4YveTbEm5wnCOkEunC53wniq9dQGlfGqQPmsi+KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnbt7ZEVNVqhGS0Q4jY4Y46KQZ3ywl6/+bRJH0IWniod1FhgamGlPxBm6cfmXAKbanjcv8GO4/t+7vrBpH/4LiVfmKD1TSfKXbthZ90vGnTBXFzrO6My93rHlf9+RwZecGWF4bn1Wyg7LtHk/hwHWL0q/QZ7ZZE92Vio6GZuteE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t9VbUE6K; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t9VbUE6K"
Date: Fri, 14 Feb 2025 15:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739566632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6JB9eDuhdq6JTzW9JcjdbIAC+75hSX6JOkeQY8YYkQ=;
	b=t9VbUE6KlXY787XxJuoxq77SzC+STuTM2U02ZxlqeXE/t0jQMZwgBxF7Tcn6tQx7ZXM1Qz
	F94/l9MVPUYMTbpYLjgZ0/HZ7UITkJen7dOuBaOMuRtGNW2lWDQl4f34uSAkYcnTggdq4f
	XWvzbqua/LXH+YoJZNQNepWCzPxtklw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: syzbot <syzbot+2110ef46097c323451eb@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, hughd@google.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] [bcachefs?] KASAN: slab-out-of-bounds Read in
 folio_try_get
Message-ID: <twd5ppfxqyjwy3mkhfd4o646ilquoobzgwnqppjzum7dipk32j@g6cyzamxifbp>
References: <67afa09f.050a0220.21dd3.0053.GAE@google.com>
 <Z6-o5A4Y-rf7Hq8j@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6-o5A4Y-rf7Hq8j@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 14, 2025 at 08:34:44PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 14, 2025 at 11:59:27AM -0800, syzbot wrote:
> > BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> > BUG: KASAN: slab-out-of-bounds in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> > BUG: KASAN: slab-out-of-bounds in page_ref_count include/linux/page_ref.h:67 [inline]
> > BUG: KASAN: slab-out-of-bounds in page_ref_add_unless include/linux/page_ref.h:237 [inline]
> > BUG: KASAN: slab-out-of-bounds in folio_ref_add_unless include/linux/page_ref.h:248 [inline]
> > BUG: KASAN: slab-out-of-bounds in folio_try_get+0xde/0x350 include/linux/page_ref.h:264
> > Read of size 4 at addr ffff88804f904b34 by task syz-executor127/5388
> > 
> > CPU: 0 UID: 0 PID: 5388 Comm: syz-executor127 Not tainted 6.14.0-rc2-syzkaller-00056-gab68d7eb7b1a #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> >  print_address_description mm/kasan/report.c:378 [inline]
> >  print_report+0x169/0x550 mm/kasan/report.c:489
> >  kasan_report+0x143/0x180 mm/kasan/report.c:602
> >  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
> >  instrument_atomic_read include/linux/instrumented.h:68 [inline]
> >  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> >  page_ref_count include/linux/page_ref.h:67 [inline]
> >  page_ref_add_unless include/linux/page_ref.h:237 [inline]
> >  folio_ref_add_unless include/linux/page_ref.h:248 [inline]
> >  folio_try_get+0xde/0x350 include/linux/page_ref.h:264
> >  filemap_get_entry+0x240/0x3b0 mm/filemap.c:1870
> >  shmem_get_folio_gfp+0x285/0x1840 mm/shmem.c:2446
> >  shmem_get_folio mm/shmem.c:2628 [inline]
> >  shmem_write_begin+0x165/0x350 mm/shmem.c:3278
> >  generic_perform_write+0x346/0x990 mm/filemap.c:4189
> >  shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
> >  new_sync_write fs/read_write.c:586 [inline]
> >  vfs_write+0xacf/0xd10 fs/read_write.c:679
> >  ksys_write+0x18f/0x2b0 fs/read_write.c:731
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fb60d00ef1f
> > Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 19 81 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 6c 81 02 00 48
> > RSP: 002b:00007fb60c7b9fb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 00007fb60c7b9ff0 RCX: 00007fb60d00ef1f
> > RDX: 0000000001000000 RSI: 00007fb604200000 RDI: 0000000000000003
> > RBP: 00007fb60d0976e0 R08: 0000000000000000 R09: 000000000000590c
> > R10: 0000000000000002 R11: 0000000000000293 R12: 00007fb60d0976ec
> > R13: 00007fb60c7ba030 R14: 0000000000000003 R15: 00007ffe9f1d73d8
> >  </TASK>
> > 
> > The buggy address belongs to the object at ffff88804f904b00
> >  which belongs to the cache radix_tree_node of size 576
> > The buggy address is located 52 bytes inside of
> >  allocated 576-byte region [ffff88804f904b00, ffff88804f904d40)
> 
> Wait, what?  We're calling folio_try_get() on a pointer which isn't a
> pointer to a folio, but a pointer to somewhere in a radix_tree_node?
> 
> This fits a pattern we're seeing a lot of recently.
> Bugs:
> 
> https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
> https://syzkaller.appspot.com/bug?extid=8ae0902c29b15a27a4ee
> https://syzkaller.appspot.com/bug?extid=07392c132f11b1758ac3
> https://syzkaller.appspot.com/bug?extid=fe375f77ba1a6ab944b6
> https://syzkaller.appspot.com/bug?extid=a0ae55e3dde11d2d790c
> 
> They all fit the form of syzbot mounts a (potentially fuzzed?) bcachefs
> file system and later we have a corruption in the radix tree.
> 
> I have two suspicions (feel free to assign your own probabilities to which
> is correct).  The first is that a bunch of tweaky little cleanups went
> into the xarray code in the last merge window.  I really wish we could
> stop doing that kind of bullshit.  Can we just agree that the xarray
> code is good enough and not keep pissing with it?  Obviously if there's
> a bug, then we should fix it (and that should come with test cases!),
> but otherwise just leave it alone.  Please.  It would make finding this
> kind of problem much easier.

Oof. Sounds like an insufficient test suite if that stuff is making it
in? You should be able to just tell people "no more xarray patches until
the testing is improved".

> The second is that bcachefs has a random memory stomper.  That would
> suck.  Kent, you said you had some automated tooling to feed syzbot
> reproducers into?

Yeah, although on 6.14-rc1 the builds are failing with the kconfig that
syzbot built with, and bisect landed on a kbuild merge commit. Fun. It's
going to take some time digging through cpp -E output to figure out
what's going on.

btk -IP ~/ktest/tests/syzbot-repro.ktest <syz bug id>

(I really want the syzbot reproducers to run with a slimmed down ktest
generated .config, but syzbot reproducers have all sorts of random
dependencies so that's been a process).

I don't have any reason to suspect bcachefs has a memory stomper that
could cause this, but given the amount of syzbot bugs I still have to
get through I can't rule it out, and unfortunately it's looking like
it'll be a few weeks minimum before I can really start getting to the
syzbot bugs.
