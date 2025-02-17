Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899B72AD02
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 02:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739758281; cv=none; b=O80ZY+qEauDK9fNQZATIbJJZF8rtWLih9fiWXo782Ve1fBcRxOu8JANvWCse40ww+t8c19VC41so3lOYM9WItJRDAkjrr8Bi2qXM+9BrlWhMpnNLDTgKm9wAHFNRSUP3RZbt0cFWzcRJzKrYKD+gYRM2e9a9E14r2HehY6em8wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739758281; c=relaxed/simple;
	bh=BQWhNkIkITDFgj+pqH98SJOgqDC0q9J2U4dt+CRbEKc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tbY+QGP6a2w9HMgYA1i7IXh6feETf+qHDAknGv/idnewRWIJhzbMXpSBjH2krgk6BmnUt+W0/PX3d7W3oWKZSA3JdwY9Y4+2/c8bZkk3VTXRkpvUMu48y2Ghxl/HtxkMtC4uqI9t1D0HvzPeoHkZn9UN6hz+qRSJ68EBfqWYFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d060cfe752so26176545ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 18:11:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739758278; x=1740363078;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fn9l4Yj5NFQ4838XD4RT4ed3t6Y0RF0aDBN+uxZBAIk=;
        b=LXOlXllJbbIhvrz5sNRJonbYdryqU8X7u+HgSdJPBuFIOoERfhc9YwdwQ6hasSiUom
         aJ0i5+S8787A+a8Zh7+z24T8hmXzLbrIEE6LOA86IrrhpnUq+Q+QB3kKFc2W/OQxdZ2C
         cDm2hJKu09et2HPKLNdw31+6HcGMy7uwcMpj0QfDbIYQ9wbJD7CqZmUPXMZsih8LkJ83
         Bo+0GJLCv4VL6+TaNU+VyzOqchAvIMuGzcv+LfSHic+P0VmQ9QyzxN6l4V81pq0RyLtA
         vQvG631jHHJYRMEQoP7iO9cMeu59wDXEFunp7SRQ4SgbnF5qIuxeLnjDaR4V+dT3PGYX
         mdYA==
X-Forwarded-Encrypted: i=1; AJvYcCX5WW8vYCkI910x4guC5UrKoCwkmLodcWZrHbxpnydsZxEoFiCqx+0ZljUX2YEWrNcr3Y9S6pcwyPiyRPTxlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEXnP3pyR0q5jp0rjW3KIcdZ/yq6YGZ0jUkiY/y0s9FrkoQCT2
	vndZOtZQUwIGS/An54TEEZdbafx8MBvgf5sNaStbfbMJepIaGNRlUnwuFWqY47VfEYBcw40DHqL
	A3CzGwflMFqQv4wbjpS5f+W9n6SmcYUA4Tfiwbneh9nSr2CIt6K06DTI=
X-Google-Smtp-Source: AGHT+IHZ6EI9S2wtYp0GiaUFXrM3xQSW/nzb2cQVeB2B/sdih4KSnYuvS1pbnEZdhDj7A8Zil9QLmMTx4rALk6gKkTxgDYo2HQJ/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170b:b0:3d0:235b:4810 with SMTP id
 e9e14a558f8ab-3d280764217mr52204345ab.2.1739758278649; Sun, 16 Feb 2025
 18:11:18 -0800 (PST)
Date: Sun, 16 Feb 2025 18:11:18 -0800
In-Reply-To: <679fb3a5.050a0220.163cdc.0030.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b29ac6.050a0220.173698.001c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] general protection fault in bioset_exit (2)
From: syzbot <syzbot+76f13f2acac84df26aae@syzkaller.appspotmail.com>
To: axboe@kernel.dk, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    224e74511041 Merge tag 'kbuild-fixes-v6.14-2' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169b5bf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=76f13f2acac84df26aae
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e8b5a4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1155a898580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b4272577622/disk-224e7451.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec492843be2b/vmlinux-224e7451.xz
kernel image: https://storage.googleapis.com/syzbot-assets/013e7903deef/bzImage-224e7451.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6b2a19ba3037/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+76f13f2acac84df26aae@syzkaller.appspotmail.com

bcachefs (loop4): shutting down
bcachefs (loop4): shutdown complete
BUG: unable to handle page fault for address: 0000000000003906
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 5943 Comm: syz-executor233 Not tainted 6.14.0-rc2-syzkaller-00390-g224e74511041 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:qlist_move_cache+0x6a/0x140 mm/kasan/quarantine.c:302
Code: 00 00 00 00 48 8d 47 08 48 89 44 24 18 48 8d 47 10 48 89 44 24 10 48 8d 46 08 48 89 44 24 08 48 8d 46 10 48 89 04 24 4c 89 eb <4d> 8b 6d 00 48 89 df e8 7a 25 48 ff 48 c1 e8 06 48 83 e0 c0 48 8b
RSP: 0000:ffffc900045bf7b0 EFLAGS: 00010006
RAX: 00000000000002c0 RBX: 0000000000003906 RCX: ffffffff9a680288
RDX: ffffffff9a680290 RSI: ffff888064500258 RDI: 0000000000000000
RBP: ffffea0000000000 R08: ffffffff816eac3c R09: fffff520008b7edc
R10: dffffc0000000000 R11: fffff520008b7edc R12: ffffffff9a680280
R13: 0000000000003906 R14: ffffc900045bf808 R15: ffff88814cdb2500
FS:  00007fe4bd5596c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000003906 CR3: 0000000076ddc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kasan_quarantine_remove_cache+0x10b/0x180 mm/kasan/quarantine.c:370
 kmem_cache_destroy+0x6e/0x160 mm/slab_common.c:528
 bio_put_slab block/bio.c:155 [inline]
 bioset_exit+0x54e/0x650 block/bio.c:1662
 bch2_fs_fs_io_direct_exit+0x19/0x30 fs/bcachefs/fs-io-direct.c:676
 __bch2_fs_free fs/bcachefs/super.c:558 [inline]
 bch2_fs_release+0x1a9/0x7b0 fs/bcachefs/super.c:624
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_get_tree+0xdee/0x17a0 fs/bcachefs/fs.c:2299
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe4bddb482a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe4bd558fd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fe4bd558ff0 RCX: 00007fe4bddb482a
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007fe4bd558ff0
RBP: 0000400000005900 R08: 00007fe4bd559030 R09: 000000000000590c
R10: 0000000000010000 R11: 0000000000000282 R12: 00004000000058c0
R13: 00007fe4bd559030 R14: 0000000000000003 R15: 0000000000010000
 </TASK>
Modules linked in:
CR2: 0000000000003906
---[ end trace 0000000000000000 ]---
RIP: 0010:qlist_move_cache+0x6a/0x140 mm/kasan/quarantine.c:302
Code: 00 00 00 00 48 8d 47 08 48 89 44 24 18 48 8d 47 10 48 89 44 24 10 48 8d 46 08 48 89 44 24 08 48 8d 46 10 48 89 04 24 4c 89 eb <4d> 8b 6d 00 48 89 df e8 7a 25 48 ff 48 c1 e8 06 48 83 e0 c0 48 8b
RSP: 0000:ffffc900045bf7b0 EFLAGS: 00010006
RAX: 00000000000002c0 RBX: 0000000000003906 RCX: ffffffff9a680288
RDX: ffffffff9a680290 RSI: ffff888064500258 RDI: 0000000000000000
RBP: ffffea0000000000 R08: ffffffff816eac3c R09: fffff520008b7edc
R10: dffffc0000000000 R11: fffff520008b7edc R12: ffffffff9a680280
R13: 0000000000003906 R14: ffffc900045bf808 R15: ffff88814cdb2500
FS:  00007fe4bd5596c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000003906 CR3: 0000000076ddc000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	48 8d 47 08          	lea    0x8(%rdi),%rax
   8:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   d:	48 8d 47 10          	lea    0x10(%rdi),%rax
  11:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  16:	48 8d 46 08          	lea    0x8(%rsi),%rax
  1a:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  1f:	48 8d 46 10          	lea    0x10(%rsi),%rax
  23:	48 89 04 24          	mov    %rax,(%rsp)
  27:	4c 89 eb             	mov    %r13,%rbx
* 2a:	4d 8b 6d 00          	mov    0x0(%r13),%r13 <-- trapping instruction
  2e:	48 89 df             	mov    %rbx,%rdi
  31:	e8 7a 25 48 ff       	call   0xff4825b0
  36:	48 c1 e8 06          	shr    $0x6,%rax
  3a:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
