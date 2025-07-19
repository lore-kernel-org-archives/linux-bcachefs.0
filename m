Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5FA7FD
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752959468; cv=none; b=hJl8qqmIEnnVR7kO7grC9sBCicYHJIDVJ4tVn0vSe0z3kyI0x8PEJgCWbHqnPwd50JA8Yog09eomFzOgvOB6YhayI93v3LmwiGleNTikQGN4710Hd44XXqJ5Txg6cLxlu/ZHc1NlHvd3NbLp8o+UlWTyQz7ZmdTSHgj94EU8f04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752959468; c=relaxed/simple;
	bh=f4mVRmSS5zwo/+69Lf/8SnOIf2ToVuUaa4SR3RYhhqo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hrY9fleP21Gbhcg3pE7t1BcWZ07XZ3SxMKMBQ8SETO1m5gnGZbgATBKG9819LcjNwlNRpXZsLNH7FqSJniPa/n3Ba5aOf+IPR/SX0vwPHE4DLT7HSco4zz1EenCNo/suWfszFD1/u+2b/eTYsEvalWykJ/E5hh5eGwzB6/xf/Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ddbfe1fc8fso69302865ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 14:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752959466; x=1753564266;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IyUCadtFBvejsvhONvhc8/3NBpBPoWwi+Q2YsetS1m4=;
        b=fosbmldh4q+NRrw6OPAF4Ap0Eb8MhURe3NdORIQy7zv1n4gIdC9qNGCasznUfQiOQZ
         BtxsG8ilQF5/rOAR+/l3c+gkS6VoNiFo8v2cnnkHjvIkNhk9cTUkLH8qQcyC5iaFbbYJ
         C/dNwhNp89YGc/sF6tJVk2qMyS5rr0pdj6iyMNIzjIrKN+DY3gVdu0tU6/GKkkg7um2f
         7wzdnokpbKqLS4T3KyqIoMgQird3g+z3lmvOi9dDV+nQuKSHWwJIohNAfgZmwyRPDGNS
         tMnYQMIwcsgvxn1Tw0nXkBHAQgYpisBOUcKptiHf8h9p6bAV1sB8HmJB25duJhkO6FIx
         HrbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4xwKA3La1E0Z7iyZfeSWU8yoIpJ1ZmBoCmQlyNfzcLhIpptwQ4vwKxWQM5p9BRvIkcFhpzAA/r7Z4O4QeEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjTUN/AKxYUgH/RWxf22PzmmG0MrC5G72Cv2o4j7+DFHOQxH70
	PO1ftgqgo5yKg+zoR61kCrAO7TjevOmoa2zszKzOcQIJ0qfamIZlJrIuFbAkunKWCeoLzJQhmz6
	KNmPZozIgJQ/xSLbMkIhQyghFaQV1RfYP4U/Pv2MfaOtCLTOCZ8TC2SULa4g=
X-Google-Smtp-Source: AGHT+IF9ThgsjzgmjSCo2y9S10Hq2jTXsYcC1pm2LeL5sIE7Q3swJWTQrq6D6AxMs6PNAqmevbZ0Isyok8Kz1nDXQBLYTS1+Qr0p
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2602:b0:3e2:988a:101d with SMTP id
 e9e14a558f8ab-3e2988a12bfmr69339225ab.6.1752959466272; Sat, 19 Jul 2025
 14:11:06 -0700 (PDT)
Date: Sat, 19 Jul 2025 14:11:06 -0700
In-Reply-To: <gtbxhrjzbwuevau27w2zi645uu2y4xuhzutebojmh535blvah7@bc4344cq25cs>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687c09ea.a70a0220.693ce.0097.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_get_next_dev
From: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in seq_buf_puts

kmalloc-512       total: 10.9 MiB active: 9.75 MiB
kmalloc-cg-2k     total: 9.78 MiB active: 8.77 MiB
shmem_inode_cache total: 8.09 MiB active: 8.06 MiB
kmalloc-8k        total: 5.72 MiB active: 5.56 MiB
Shrinkers:
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 7134 Comm: syz.0.42 Not tainted 6.16.0-rc6-syzkaller-g8546371cc837 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:strlen+0x29/0x70 lib/string.c:420
Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
RSP: 0018:ffffc90003f8e700 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802d1fda00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003f8e850 R08: ffff88814d01cad7 R09: 1ffff11029a0395a
R10: dffffc0000000000 R11: ffffed1029a0395b R12: ffffc90003f8e7c0
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
FS:  00007f15d42266c0(0000) GS:ffff888125c29000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0e6f5ff000 CR3: 00000000251d2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __fortify_strlen include/linux/fortify-string.h:268 [inline]
 seq_buf_puts+0x34/0x1a0 lib/seq_buf.c:184
 shrinker_to_text+0x115/0x3c0 mm/shrinker.c:836
 shrinkers_to_text+0x840/0x960 mm/shrinker.c:911
 __show_mem+0x242b/0x24d0 mm/show_mem.c:496
 warn_alloc_show_mem mm/page_alloc.c:3719 [inline]
 warn_alloc+0x2dd/0x310 mm/page_alloc.c:3744
 __vmalloc_area_node mm/vmalloc.c:3702 [inline]
 __vmalloc_node_range_noprof+0x67e/0x12f0 mm/vmalloc.c:3893
 __kvmalloc_node_noprof+0x3b8/0x5f0 mm/slub.c:5037
 __bch2_darray_resize_noprof+0xd7/0x290 fs/bcachefs/darray.c:24
 bch2_fs_btree_write_buffer_init+0x16e/0x1f0 fs/bcachefs/btree_write_buffer.c:885
 bch2_fs_init_rw+0x226/0x2d0 fs/bcachefs/super.c:835
 __bch2_fs_read_write+0x18f/0x5a0 fs/bcachefs/super.c:509
 bch2_fs_read_write_early+0x26/0x40 fs/bcachefs/super.c:601
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:487 [inline]
 __bch2_run_recovery_passes+0x39a/0x1050 fs/bcachefs/recovery_passes.c:543
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:614
 bch2_fs_recovery+0x2544/0x3860 fs/bcachefs/recovery.c:996
 bch2_fs_start+0x957/0xbf0 fs/bcachefs/super.c:1218
 bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2462
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15d339014a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f15d4225e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f15d4225ef0 RCX: 00007f15d339014a
RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007f15d4225eb0
RBP: 00002000000000c0 R08: 00007f15d4225ef0 R09: 0000000000818001
R10: 0000000000818001 R11: 0000000000000246 R12: 0000200000000080
R13: 00007f15d4225eb0 R14: 000000000000596b R15: 0000200000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:strlen+0x29/0x70 lib/string.c:420
Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
RSP: 0018:ffffc90003f8e700 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802d1fda00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003f8e850 R08: ffff88814d01cad7 R09: 1ffff11029a0395a
R10: dffffc0000000000 R11: ffffed1029a0395b R12: ffffc90003f8e7c0
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
FS:  00007f15d42266c0(0000) GS:ffff888125c29000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4538002565 CR3: 00000000251d2000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	f3 0f 1e fa          	endbr64
   5:	41 57                	push   %r15
   7:	41 56                	push   %r14
   9:	41 54                	push   %r12
   b:	53                   	push   %rbx
   c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  13:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
  1a:	fc ff df
  1d:	48 89 fb             	mov    %rdi,%rbx
  20:	49 89 c7             	mov    %rax,%r15
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	75 11                	jne    0x44
  33:	48 ff c3             	inc    %rbx
  36:	49 8d 47 01          	lea    0x1(%r15),%rax
  3a:	42 80 7c 3f 01 00    	cmpb   $0x0,0x1(%rdi,%r15,1)


Tested on:

commit:         8546371c bcachefs: Flush btree_interior_update_work be..
git tree:       git://evilpiepirate.org/bcachefs.git bcachefs-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=102f0b82580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37de60b3108b6d8f
dashboard link: https://syzkaller.appspot.com/bug?extid=2b98caf09c41174a9697
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
