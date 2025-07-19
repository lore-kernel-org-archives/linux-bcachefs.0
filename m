Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD750A923
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752949434; cv=none; b=pFBtOXJsOubv16ObBlqA4shzZdoWJjst1Aw0gzCeaOSuW8yRMmMA6fCO+ZPDnNw3W8Frqanp+tm960j14JIV423m5OCWnTwbMY/cOYtmWn5Pz+ZlNcqzfnH6cBWXGfoXFgoSTKZX5adDhU99RsdogXjQvK90z0gFH8Pch+xFwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752949434; c=relaxed/simple;
	bh=nuU4mdOobL67xNrn3j1Q+QlHy+gYsTQlVY9cjyDLs9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9hh6e/Azw3gVCDwKvJxSQIrONTL0tOUON2aIySIy7CIzqm7i91x2YMVXKTtxtVWs01MklbDcyX6uqDg0MMeCvsgNbNgu+kLE5uKBfYJALIIiNplkkPP36Oaxog9cbxRVCOFXcWRth1a+S9YvENdMGQOCFLPwUIYX4rZeziOsFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uxLdz5Is; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uxLdz5Is"
Date: Sat, 19 Jul 2025 14:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752949428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3SR847fU0+ZN9JbGCXp2+j9CL/K+GJvO19i9f39mEaU=;
	b=uxLdz5IsEVwpvdK8bs9Lm0hHcxbRm7jBgIMMWRGC8G8MkPbrUbibhQQbuWmsew7vSIyOXA
	iZYuREoQY1/2i4uercNMLe7ihcIyIuOkao6dxif9DA7PU8HJJK649C9Q76Xrq9nBjLJVZK
	v7hIBehJESCeyjf40h+kB65Bj750YFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in
 bch2_get_next_dev
Message-ID: <n2gwogdq44vxgvjdefktzbhfny2ezktepblcsj2q3z7t4dgbtv@6uafqubd7qr2>
References: <ci6d4nck2pydr7gprqmv5v5rudgx5wrt5xumkzrewnwol2p2z7@t6ksfe4l3ayu>
 <687ac6f0.a70a0220.693ce.0070.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687ac6f0.a70a0220.693ce.0070.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 18, 2025 at 03:13:04PM -0700, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> general protection fault in seq_buf_puts
> 
> shmem_inode_cache total: 7.91 MiB active: 7.89 MiB
> kmalloc-8k        total: 5.63 MiB active: 5.48 MiB
> Shrinkers:
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 6968 Comm: syz.4.25 Not tainted 6.16.0-rc6-syzkaller-gca12b17b7ceb #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:strlen+0x29/0x70 lib/string.c:420
> Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
> RSP: 0018:ffffc90003dde7a0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802c468000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003dde8f0 R08: ffff8880357dead7 R09: 1ffff11006afbd5a
> R10: dffffc0000000000 R11: ffffed1006afbd5b R12: ffffc90003dde860
> R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
> FS:  00007fb031fe66c0(0000) GS:ffff888125d2a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe025a39e9c CR3: 0000000034726000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __fortify_strlen include/linux/fortify-string.h:268 [inline]
>  seq_buf_puts+0x34/0x1a0 lib/seq_buf.c:184
>  shrinker_to_text+0x115/0x3c0 mm/shrinker.c:836
>  shrinkers_to_text+0x840/0x960 mm/shrinker.c:911
>  __show_mem+0x242b/0x24d0 mm/show_mem.c:496
>  warn_alloc_show_mem mm/page_alloc.c:3719 [inline]
>  warn_alloc+0x2dd/0x310 mm/page_alloc.c:3744
>  __vmalloc_area_node mm/vmalloc.c:3702 [inline]
>  __vmalloc_node_range_noprof+0x67e/0x12f0 mm/vmalloc.c:3893
>  __kvmalloc_node_noprof+0x3b8/0x5f0 mm/slub.c:5037
>  bch2_fs_journal_start+0x2b4/0x12b0 fs/bcachefs/journal.c:1484
>  bch2_fs_recovery+0x1fbe/0x3860 fs/bcachefs/recovery.c:975
>  bch2_fs_start+0x957/0xbf0 fs/bcachefs/super.c:1216
>  bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2462
>  vfs_get_tree+0x92/0x2b0 fs/super.c:1804
>  do_new_mount+0x24a/0xa40 fs/namespace.c:3902
>  do_mount fs/namespace.c:4239 [inline]
>  __do_sys_mount fs/namespace.c:4450 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4427
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb0311900ca
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb031fe5e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fb031fe5ef0 RCX: 00007fb0311900ca
> RDX: 000020000000fec0 RSI: 000020000000ff00 RDI: 00007fb031fe5eb0
> RBP: 000020000000fec0 R08: 00007fb031fe5ef0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000020000000ff00
> R13: 00007fb031fe5eb0 R14: 000000000000fe88 R15: 000020000000ff40
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:strlen+0x29/0x70 lib/string.c:420
> Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
> RSP: 0018:ffffc90003dde7a0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802c468000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003dde8f0 R08: ffff8880357dead7 R09: 1ffff11006afbd5a
> R10: dffffc0000000000 R11: ffffed1006afbd5b R12: ffffc90003dde860
> R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
> FS:  00007fb031fe66c0(0000) GS:ffff888125d2a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005578d9f91950 CR3: 0000000034726000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>    0:	90                   	nop
>    1:	f3 0f 1e fa          	endbr64
>    5:	41 57                	push   %r15
>    7:	41 56                	push   %r14
>    9:	41 54                	push   %r12
>    b:	53                   	push   %rbx
>    c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
>   13:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
>   1a:	fc ff df
>   1d:	48 89 fb             	mov    %rdi,%rbx
>   20:	49 89 c7             	mov    %rax,%r15
>   23:	48 89 d8             	mov    %rbx,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
>   2f:	84 c0                	test   %al,%al
>   31:	75 11                	jne    0x44
>   33:	48 ff c3             	inc    %rbx
>   36:	49 8d 47 01          	lea    0x1(%r15),%rax
>   3a:	42 80 7c 3f 01 00    	cmpb   $0x0,0x1(%rdi,%r15,1)
> 
> 
> Tested on:
> 
> commit:         ca12b17b bcachefs: fix check_extent_overbig() call
> git tree:       git://evilpiepirate.org/bcachefs.git bcachefs-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=1752038c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=37de60b3108b6d8f
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b98caf09c41174a9697
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Note: no patches were applied.

#syz test: git://evilpiepirate.org/bcachefs.git for-next
