Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9721FDE05
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Mar 2025 10:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082483; cv=none; b=Ew2v3naciOuWqIOU6utLGuWHch1UA2tkJ5BO858d+gPaeunxLPORxNnlLENlln36uWN9eSds6cAIhPvRNRMREcuFgg7GG0j7Qn1UY/O6zeHPq2c3UFtULkhl7Bp1+P6EJGpCnnBYIzHKBNpP9o/Z3EWy0w1TpUrCEkz9gepsSmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082483; c=relaxed/simple;
	bh=I9P5Gtso5RQYpPJYahKfjtEqCDNVQAB1DE0d7nvma+s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TmyTHfRBTLYZH9/sm2KksQS8WYdB6G38xHbC5ih1X48pEP3R4fzpWN8lny1Q2La5Xi5zesQlJnRnZZo3VmyaAdBr4tFhgl7Hk2TwP+aN1EWh8aa4C8iw0pNM6iSFoFx3vfBFl/DbtjezuQvSycS6OncmfofXoRpdLERKQUG422o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d2b6d933a5so49519705ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Mar 2025 02:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741082480; x=1741687280;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FefLW67sQmVsLR2sFGg0Kb+iinVxl/v0+h0mH51OFOQ=;
        b=Yeje1FtiUbMJrNN7dnd/CRXSZLD0duUfzf17bEfwwfwqEvVp5UMYXV6dEYdKlD/M5G
         gZKMRdeNev9QoTlmLwONK93HNLm/neFGRN6rBkz1Bpa5f1I2VgHha9G0XzxWa7Ne7v0a
         HSCJRTiKccaLrrFxxo2fhlu3Mkiu4TUTrrsvPPRvu1hYbtwUJeUGJAjojCE0isxgp8+o
         fRXthzOsZ+iQif1iIGsEbOLPj/FzEfrBOZnEXmgftsusqCTqX6vrdAJoK5clXT4Ib3Gw
         RYCYDG7wf6Lz6L83Ii+yn44i4pNvTTZybSK501vvUOYaJun9WT/twDt02qtWVvu75Eb6
         e1VA==
X-Forwarded-Encrypted: i=1; AJvYcCUydnfhnA02yMrCYeLxRFaoJcuhPySUiqkfRvJw+25So7A1B3S0kgJRW5dLD1krrDAxslY5O+jTByjzpHMUkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxukeKz0mAOxEfLKu+6fuIbaEdGTF8PeR5/vb4Xj+VmnakaeLTh
	jQ+tBAUh+QRTdtFRXRVF+NXYlNmD8SV2LE4PgqPx3B37yd+FMvPnX9L6Er9fB7oqTANyvkJL4oi
	PYCiGJuPH+/s9gcLviK0+y6ikHc3Pwy7hDJHdzah4fLEFgl7K/71OVlI=
X-Google-Smtp-Source: AGHT+IGQ993vW6XPMpeApP3BoP89HZot5k8gHVZJvitbCAfQdQgYbqS4hKG76YhmnyCFdoTAh07GTwmLpgtbWEwRn1xAzj2aGxBS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2218:b0:3d3:d965:62c4 with SMTP id
 e9e14a558f8ab-3d3e6e39e4emr152868435ab.10.1741082480341; Tue, 04 Mar 2025
 02:01:20 -0800 (PST)
Date: Tue, 04 Mar 2025 02:01:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c6cf70.050a0220.15b4b9.0009.GAE@google.com>
Subject: [syzbot] [net?] [bcachefs?] INFO: trying to register non-static key
 in sock_def_readable
From: syzbot <syzbot+76de817a3d28a3e50c60@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kent.overstreet@linux.dev, kuba@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e7e464580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2040405600e83619
dashboard link: https://syzkaller.appspot.com/bug?extid=76de817a3d28a3e50c60
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b858b7980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-99fa936e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef04f83d96f6/vmlinux-99fa936e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/583a7eea5c8e/bzImage-99fa936e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d211587a515f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+76de817a3d28a3e50c60@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5470 Comm: syz-executor Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 assign_lock_key+0x241/0x280 kernel/locking/lockdep.c:983
 register_lock_class+0x1cf/0x980 kernel/locking/lockdep.c:1297
 __lock_acquire+0xf3/0x2100 kernel/locking/lockdep.c:5103
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
 __wake_up_common_lock+0x25/0x1e0 kernel/sched/wait.c:105
 sock_def_readable+0x20f/0x5a0 net/core/sock.c:3493
 __netlink_sendskb net/netlink/af_netlink.c:1258 [inline]
 netlink_sendskb+0x9e/0x140 net/netlink/af_netlink.c:1264
 netlink_unicast+0x39d/0x990 net/netlink/af_netlink.c:1353
 netlink_rcv_skb+0x294/0x480 net/netlink/af_netlink.c:2539
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x8de/0xcb0 net/netlink/af_netlink.c:1882
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:733
 __sys_sendto+0x363/0x4c0 net/socket.c:2187
 __do_sys_sendto net/socket.c:2194 [inline]
 __se_sys_sendto net/socket.c:2190 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2190
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3d27d8effc
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffcb9983030 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f3d28ad4620 RCX: 00007f3d27d8effc
RDX: 0000000000000040 RSI: 00007f3d28ad4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffcb9983084 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f3d28ad4670 R15: 0000000000000000
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5470 Comm: syz-executor Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__wake_up_common_lock+0xcf/0x1e0 kernel/sched/wait.c:106
Code: fb 0f 84 d1 00 00 00 8b 6c 24 04 eb 13 48 ba 00 00 00 00 00 fc ff df 4c 39 fb 0f 84 b8 00 00 00 49 89 de 48 89 d8 48 c1 e8 03 <80> 3c 10 00 74 12 4c 89 f7 e8 13 3f 8f 00 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000293f6d0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc9000293f5a0
RBP: 0000000000000001 R08: 0000000000000003 R09: fffff52000527eb4
R10: dffffc0000000000 R11: fffff52000527eb4 R12: 1ffff11009ce1230
R13: ffff88803b3d3040 R14: 0000000000000000 R15: ffff88803b3d3080
FS:  0000555577b71500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb8921d2000 CR3: 000000005450e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sock_def_readable+0x20f/0x5a0 net/core/sock.c:3493
 __netlink_sendskb net/netlink/af_netlink.c:1258 [inline]
 netlink_sendskb+0x9e/0x140 net/netlink/af_netlink.c:1264
 netlink_unicast+0x39d/0x990 net/netlink/af_netlink.c:1353
 netlink_rcv_skb+0x294/0x480 net/netlink/af_netlink.c:2539
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x8de/0xcb0 net/netlink/af_netlink.c:1882
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:733
 __sys_sendto+0x363/0x4c0 net/socket.c:2187
 __do_sys_sendto net/socket.c:2194 [inline]
 __se_sys_sendto net/socket.c:2190 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2190
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3d27d8effc
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffcb9983030 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f3d28ad4620 RCX: 00007f3d27d8effc
RDX: 0000000000000040 RSI: 00007f3d28ad4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffcb9983084 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f3d28ad4670 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__wake_up_common_lock+0xcf/0x1e0 kernel/sched/wait.c:106
Code: fb 0f 84 d1 00 00 00 8b 6c 24 04 eb 13 48 ba 00 00 00 00 00 fc ff df 4c 39 fb 0f 84 b8 00 00 00 49 89 de 48 89 d8 48 c1 e8 03 <80> 3c 10 00 74 12 4c 89 f7 e8 13 3f 8f 00 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000293f6d0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc9000293f5a0
RBP: 0000000000000001 R08: 0000000000000003 R09: fffff52000527eb4
R10: dffffc0000000000 R11: fffff52000527eb4 R12: 1ffff11009ce1230
R13: ffff88803b3d3040 R14: 0000000000000000 R15: ffff88803b3d3080
FS:  0000555577b71500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb8921d2000 CR3: 000000005450e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	fb                   	sti
   1:	0f 84 d1 00 00 00    	je     0xd8
   7:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
   b:	eb 13                	jmp    0x20
   d:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  14:	fc ff df
  17:	4c 39 fb             	cmp    %r15,%rbx
  1a:	0f 84 b8 00 00 00    	je     0xd8
  20:	49 89 de             	mov    %rbx,%r14
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 f7             	mov    %r14,%rdi
  33:	e8 13 3f 8f 00       	call   0x8f3f4b
  38:	48                   	rex.W
  39:	ba 00 00 00 00       	mov    $0x0,%edx
  3e:	00 fc                	add    %bh,%ah


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
