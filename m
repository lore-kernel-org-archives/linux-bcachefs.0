Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBDB39FD9
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 06:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727676085; cv=none; b=kUU9eqhNdqsswNd1Elb9ENfhEBH8ip4TXjyu5Wc3rn0qc5uLwWH7ujcCfItdZq1LlUtgGPsBIjeZj9kHTs8Hd9rrGFgdnROQlE8/YvGWDc3q+mlEjrBnfUz8DQjduBG7+IbFgCdupy2CuQyyKmcHEITncBKoRZGAkpx1IjZc0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727676085; c=relaxed/simple;
	bh=Y3w5ue+zd/hBfjKx82ouX8nKDI1149V195JO2JSr+o8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Sx7H9J54XL7rhdMeHxub3UriDwAWKhMiaQ/44kqm+7jDfYYBpszhu7SmmRRCOSszGv08arKIGCLcjippL8CiymZBshy400Kwgl1UEfzxPfFfzfKK3mF1Fv+0A0cj90Lem1Yd1wLLMFvibQzlR0m0/Vx2+tfZFq9bFwWPc2VhsQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82cda24c462so388315439f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Sep 2024 23:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727676083; x=1728280883;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4bsoNy7ocIyyBmhMtBRXlLymTcT0fJP/3FWknlM+zqQ=;
        b=HKR8F05PGzp6mrmhsefON9M1R5Cv7DmPuIk+L3mFFWZvJGrv1lj7ZmkJM0rkfpmye6
         yCvmQrWhJL+NFTX8s0g2ktZq9L3vf6ttgU3GLfvktV2yXP+Wy3w8dXNvle8/lY+/0VcK
         75TJA8NNDH/wfRptiCep71K/4WAffDsxoGqpfCQC+wbY4oZv2DBLv81fj8jSqapvtZ6m
         fmRoKY4qD/SCvzSNWqC2DWqjnNBugqcGjZ4iskxemq73C/cvnxssbZNqGMf7fszNHYg7
         D0uVVa3EmEJ6KhH5PojLA6o10FkBk+9qVYouk+lElVLMwk/XTHGe4AsrsC/AbhttLMTT
         jGKA==
X-Forwarded-Encrypted: i=1; AJvYcCXhmokv0Qr7HD9LnEEUGKNnMePxRXuSKhPFujuj/7lsloNwWdzNYQYGP9/gHtoYSKNh8K/UwmgpBFZxgzZqyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yywwwa00PHAkatEj0xq+3bHOhkRp3z4p2eswQJ4tuQVl5zF8QN4
	PEAO3toT81IMu3WdzaA3KVVOz5HmxfoQdAHeSv4oncIA/fPaGENNQ3dz5MHlMz72TC70FKjVTQo
	Ay5jnNzJ/DJyuvy+BGSoGHBS+eFgxw78f7dbxbJH+LsA4hNE6VSEBW9k=
X-Google-Smtp-Source: AGHT+IGSuzJbE9aTHAqrdO62zT+nSlitoUvEaUjb9cVdyGtMZNyKZv/55aarOBbKXbgPAofnXyBHHmN36idQA9Qbg/CKdOajdH77
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe3:b0:3a3:3a77:9192 with SMTP id
 e9e14a558f8ab-3a3451c2274mr82190785ab.26.1727676083445; Sun, 29 Sep 2024
 23:01:23 -0700 (PDT)
Date: Sun, 29 Sep 2024 23:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fa3eb3.050a0220.6bad9.0030.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in btree_node_iter_and_journal_peek
From: syzbot <syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    abf2050f51fd Merge tag 'media/v6.12-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112f0a80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc30a30374b0753
dashboard link: https://syzkaller.appspot.com/bug?extid=005ef9aa519f30d97657
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-abf2050f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2179ebeade58/vmlinux-abf2050f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f05289b5cf7c/bzImage-abf2050f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.11.0-syzkaller-09959-gabf2050f51fd #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_write_ref bch2_do_invalidates_work
RIP: 0010:bch2_bkey_buf_reassemble fs/bcachefs/bkey_buf.h:27 [inline]
RIP: 0010:btree_node_iter_and_journal_peek+0x260/0x1010 fs/bcachefs/btree_iter.c:886
Code: 4c 24 18 45 89 f0 50 53 41 51 e8 2b b3 00 00 48 83 c4 18 4c 89 ff e8 8f 87 00 00 48 89 c3 49 89 d7 48 c1 e8 03 48 89 44 24 18 <42> 0f b6 04 28 84 c0 4c 89 ea 0f 85 d1 0c 00 00 48 89 5c 24 38 44
RSP: 0018:ffffc900003a6ce0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000000ff RDI: ffffc900003a6e94
RBP: ffffc900003a6f70 R08: ffffc900003a6e93 R09: 0000000000000000
R10: ffffc900003a6e80 R11: fffff52000074dd3 R12: ffffc900003a6ee0
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b220af5258 CR3: 00000000408ba000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_path_down fs/bcachefs/btree_iter.c:914 [inline]
 bch2_btree_path_traverse_one+0x1981/0x2940 fs/bcachefs/btree_iter.c:1169
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2197 [inline]
 bch2_btree_iter_peek_upto+0xb58/0x6f00 fs/bcachefs/btree_iter.c:2297
 next_lru_key fs/bcachefs/alloc_background.c:2084 [inline]
 bch2_do_invalidates_work+0x8d5/0x2710 fs/bcachefs/alloc_background.c:2118
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_bkey_buf_reassemble fs/bcachefs/bkey_buf.h:27 [inline]
RIP: 0010:btree_node_iter_and_journal_peek+0x260/0x1010 fs/bcachefs/btree_iter.c:886
Code: 4c 24 18 45 89 f0 50 53 41 51 e8 2b b3 00 00 48 83 c4 18 4c 89 ff e8 8f 87 00 00 48 89 c3 49 89 d7 48 c1 e8 03 48 89 44 24 18 <42> 0f b6 04 28 84 c0 4c 89 ea 0f 85 d1 0c 00 00 48 89 5c 24 38 44
RSP: 0018:ffffc900003a6ce0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000000ff RDI: ffffc900003a6e94
RBP: ffffc900003a6f70 R08: ffffc900003a6e93 R09: 0000000000000000
R10: ffffc900003a6e80 R11: fffff52000074dd3 R12: ffffc900003a6ee0
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2e13f7f96e CR3: 00000000408ba000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	4c 24 18             	rex.WR and $0x18,%al
   3:	45 89 f0             	mov    %r14d,%r8d
   6:	50                   	push   %rax
   7:	53                   	push   %rbx
   8:	41 51                	push   %r9
   a:	e8 2b b3 00 00       	call   0xb33a
   f:	48 83 c4 18          	add    $0x18,%rsp
  13:	4c 89 ff             	mov    %r15,%rdi
  16:	e8 8f 87 00 00       	call   0x87aa
  1b:	48 89 c3             	mov    %rax,%rbx
  1e:	49 89 d7             	mov    %rdx,%r15
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
* 2a:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	4c 89 ea             	mov    %r13,%rdx
  34:	0f 85 d1 0c 00 00    	jne    0xd0b
  3a:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
  3f:	44                   	rex.R


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
