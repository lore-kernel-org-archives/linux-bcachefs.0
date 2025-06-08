Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1065122B595
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Jun 2025 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749396408; cv=none; b=RciZTNYyBWYISMw/KmvjR/BUtnjnSgB3y8sWy9ai+gPE49GvSmej74HKbMGcr3OY/EVmbD57DXnpRf7JfBnslPwX1cL75z2wU6lZUzIsyXdOxA2Po+bpom6+4s6+nhUvHjqv8tl+xZgRpYCzewprZwG+GyswfPyrfYUFVs4Kxcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749396408; c=relaxed/simple;
	bh=TAcN2Wqva1vjaooOAydwl8d2WBh+sYR8wGRrqqZUGlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBZMlmIBctaLKvuBwD/pr2irLmRIjValzUoMo5jS7qJ4qJbj2nCDZ3/3jaslt6BPcG9ekrb7bqTl3D0J5th3ogNVcdd+Cu//AEYMmdpUzVqhYL3z2L3yo0GIxXRyYXQ1BuzAMoPbOyf1gMdLtmo+cbVERXGSBEThq3XIirpHuUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XXFUfr2/; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XXFUfr2/"
Date: Sun, 8 Jun 2025 11:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749396392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Jt4JQmErq4Yny7pnS33f1+VIu1hHHRGrT6P+hATzHU=;
	b=XXFUfr2/HE2QR5HzLf3Za2ogrd27YGSJfSOqWBrR1Zz8UJFlMtLOqrXlSl41lKdvy50MJj
	E9eLgGe7RAd3UhbMEaojSl62uK/F8Bb80qBbZesusr492NOg9DKncZ78ypNau4hijhDmD5
	IUZ0na7Jr1lphTdNWeWjLfFAad3HWPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, josh@joshtriplett.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 06:56:19AM -0800, Paul E. McKenney wrote:
> On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
> > dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > 
> >  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > #PF: supervisor instruction fetch in kernel mode
> > #PF: error_code(0x0010) - not-present page
> > PGD 0 P4D 0 
> > Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> > CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > RIP: 0010:0x0
> > Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> > RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> > RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> > RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> > R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> > R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> > FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <IRQ>
> >  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
> 
> The usual way that this happens is that someone clobbers the rcu_head
> structure of something that has been passed to call_rcu().  The most
> popular way of clobbering this structure is to pass the same something to
> call_rcu() twice in a row, but other creative arrangements are possible.
> 
> Building your kernel with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y can usually
> spot invoking call_rcu() twice in a row.

I don't think it's that - syzbot's .config already has that enabled.
KASAN, too.

And the only place we do call_rcu() is from rcu_pending.c, where we've
got a rearming rcu callback - but we track whether it's outstanding, and
we do all relevant operations with a lock held.

And we only use rcu_pending.c with SRCU, not regular RCU.

We do use kfree_rcu() in a few places (all boring, I expect), but that
doesn't (generally?) use the rcu callback list.

So I'm not sure this is even a bcachefs bug.
