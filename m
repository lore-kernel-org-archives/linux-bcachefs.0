Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D1875813
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 May 2024 05:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357514; cv=none; b=HoVK8hXSmR6t9FQ4TJyUvHNs7QNxomYTvVrSjJpTetmMD00YDcgV+vjMCYIECpyi+Eyn8NTwxzlkOmdmAnGXCqzmLxTajqMMdVkl3+8S99807sDU/2lWUWUlfRl6ovfk0CD7+7h6ueE3QRpgJN8FfKbYMZfdeFKwnR6tC3eW4T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357514; c=relaxed/simple;
	bh=BrAHIEucf6NFI0eHOQWdWy8AGOA4ok3y3h+SS9BvU1g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sIbM0nsXNpNbid7KjrBcIM0tF96y5IHHa8HhDfE/j/wdMyt+qXXohi+FscNhBQ4Ls+NY4UfeXkTwDaPzT9pRywGCH2QDDxGTlTKM7YdBlyljVafkcyri+MAJpjcVcm38DHfI1O5JjkNgV/m7keMcgcu3hkOgbQRY+DzJXbKDxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e1db7e5386so1327364539f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 May 2024 22:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716357512; x=1716962312;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QVU2kpvwMDn6k+1lS5g1mfIkWln5txH9V3O8iMO/kow=;
        b=CQK14gziLamD7zC0KYbT7V0TLbDT2wYt1o4KygKBU/97VyoIstYecQ37sdCzS9NRfl
         PVBPsL4tML3j0OHsR+ejqrryL7FN4t3nSiWuHHBB7nnS6By+iNAdD1cB1iApcpsye+I6
         e36fXen0vgXhliKIK13fFEahb/W5sFa2pCj9oK9Se+uV/eLkOLQjOn2tOUpZfMSb7s7W
         vvn6eOHF7zO/U8GitAr3QbXCNP8Z1Md9k5k3drcUA0PhUokBCAEjIDAOsaYjXy/q7Wd5
         JdeK1WedHJ781xsEXcOlW2SBCzlY4br1RWkVc+NpZdx7W3GaJNdUoJP9j5HzokjMHwk/
         WEvw==
X-Forwarded-Encrypted: i=1; AJvYcCUBlVGOxKFzWnEXMwuRDp5aGVL8l/XCR9ZhDxyj92gqtyb83b1LKwiD3BF/VxyElA4lob9pMPwRoeRY8AFkoa6RBYhCkCnZ/e9tzbgidJQ=
X-Gm-Message-State: AOJu0YxJfZreIJX7neCjmTgioWOqRNSivb2dlx+rMRzpYLIqj82Qb7sc
	k0MzqNPziN1EJB0HfqPVb6Jd5Q4kPYFkUpUYz7fV85jjftMK4nsKw0vYD4msDbwjtK93Vby0Y5j
	BCBRtE1AZ7KJ6Y7Y8fL9/27yD5v8a4w2S62WmUyvG32OjeRj9RBAzGZQ=
X-Google-Smtp-Source: AGHT+IG6Yns3UyyUE7roYjd/CKL/G/CnZcqmlaS/4d6a6H+ZGRwBakA8QO9EPXEkKg/ADBMAdg4fYcXgj5f080OTx1bwLj3fxWB2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c02:b0:36d:bf62:9276 with SMTP id
 e9e14a558f8ab-371fcfa3251mr790495ab.5.1716357511976; Tue, 21 May 2024
 22:58:31 -0700 (PDT)
Date: Tue, 21 May 2024 22:58:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf30d00619049f93@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in poll_state_synchronize_srcu
From: syzbot <syzbot+3af9daea347788b15213@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2a8120d7b482 Merge tag 's390-6.10-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b5be58980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5dd4fde1337a9e18
dashboard link: https://syzkaller.appspot.com/bug?extid=3af9daea347788b15213
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2a8120d7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/78c72ae6bdaf/vmlinux-2a8120d7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99dbb805b738/bzImage-2a8120d7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3af9daea347788b15213@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000030: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000180-0x0000000000000187]
CPU: 0 PID: 111 Comm: kswapd0 Not tainted 6.9.0-syzkaller-10713-g2a8120d7b482 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:rcu_seq_done kernel/rcu/rcu.h:156 [inline]
RIP: 0010:poll_state_synchronize_srcu+0x43/0x90 kernel/rcu/srcutree.c:1543
Code: 48 83 ec 08 48 c1 ea 03 80 3c 02 00 75 45 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 38 48 8d bb 80 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 32 48 8b 93 80 01 00 00 31 c0 48 39 f2 78 0b f0 83
RSP: 0018:ffffc90000e6f698 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888062204528
RDX: 0000000000000030 RSI: 0000000000000004 RDI: 0000000000000180
RBP: dffffc0000000000 R08: 0000000000000000 R09: fffffbfff283f87a
R10: ffffffff941fc3d7 R11: 0000000000000002 R12: ffff88804bca2cf0
R13: ffff88804bc3aec8 R14: ffff888062200000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f7f8cea0 CR3: 0000000045b60000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_key_cache_scan+0x3c7/0x1820 fs/bcachefs/btree_key_cache.c:835
 do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
 shrink_slab+0x18a/0x1310 mm/shrinker.c:662
 shrink_one+0x493/0x7c0 mm/vmscan.c:4790
 shrink_many mm/vmscan.c:4851 [inline]
 lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4951
 shrink_node mm/vmscan.c:5910 [inline]
 kswapd_shrink_node mm/vmscan.c:6720 [inline]
 balance_pgdat+0x1105/0x1970 mm/vmscan.c:6911
 kswapd+0x5ea/0xbf0 mm/vmscan.c:7180
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rcu_seq_done kernel/rcu/rcu.h:156 [inline]
RIP: 0010:poll_state_synchronize_srcu+0x43/0x90 kernel/rcu/srcutree.c:1543
Code: 48 83 ec 08 48 c1 ea 03 80 3c 02 00 75 45 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 38 48 8d bb 80 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 32 48 8b 93 80 01 00 00 31 c0 48 39 f2 78 0b f0 83
RSP: 0018:ffffc90000e6f698 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888062204528
RDX: 0000000000000030 RSI: 0000000000000004 RDI: 0000000000000180
RBP: dffffc0000000000 R08: 0000000000000000 R09: fffffbfff283f87a
R10: ffffffff941fc3d7 R11: 0000000000000002 R12: ffff88804bca2cf0
R13: ffff88804bc3aec8 R14: ffff888062200000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbbf486e060 CR3: 0000000045a9e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 83 ec 08          	sub    $0x8,%rsp
   4:	48 c1 ea 03          	shr    $0x3,%rdx
   8:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   c:	75 45                	jne    0x53
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 5b 38          	mov    0x38(%rbx),%rbx
  1c:	48 8d bb 80 01 00 00 	lea    0x180(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	75 32                	jne    0x62
  30:	48 8b 93 80 01 00 00 	mov    0x180(%rbx),%rdx
  37:	31 c0                	xor    %eax,%eax
  39:	48 39 f2             	cmp    %rsi,%rdx
  3c:	78 0b                	js     0x49
  3e:	f0                   	lock
  3f:	83                   	.byte 0x83


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
