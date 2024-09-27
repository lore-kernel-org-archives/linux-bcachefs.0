Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FDE1C0DD6
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727448926; cv=none; b=gDI+MeRbCpSLEjobIbVxz5X7nsoLcB+/8yC2Y4AEPPGfRjCFZ/afzPq7ol97OClJiYACtzUdBL4agwMvMUNAxX/yiUb+7uNADyBebnJ4CpH8yJ6Jwjx+OTB5rvUrexffYjxk/DIFm9OlhUnBZhme3E1XLyB3SyF1F0HvA1McdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727448926; c=relaxed/simple;
	bh=C3DV7YTrdGQhcxy6g9mY1IuaKGtbuW3A59ZAlNXDfE4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=klWEZs1E/ij40I1Tjjh0F80lbAjdb5SaPc28fl0i4tbmn9hPZFXukjzBsYzPA2Ja9FsFHGji27RjcXjnc3PEKVzhXjNTIt9qXAyKKIeYELij2GSjS99HcfG++7BWwTqM26PK8Ees87t6oniceclw2sAzzr8X1irlrAffRU6b/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3466d220dso10398965ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 07:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727448923; x=1728053723;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voKB77rCisejySRngIKRxQGFB/H/hXWbECxKtJb39y8=;
        b=wZfrgMVTo8QeLHJKPGHelrR36+Jgxl7oWcMFPbjGuplA7o+1T3F7/oejDVm4rafG68
         GBFfaiocauIXSvn5UEuTjXfRkhMFU1KrmzqepE7HNfeObvsU6+1ncb+t7JoikAp+OG/3
         gucDP+HyLQ4h2Yq1MvKS6Bg8I0O+35BMsqzpRM99E38zLD1HJ2lFOi6YATzz79mhKSM6
         QK8Rr4PTcCoAAXJeoOQAbsrhhQBTRajmQF+M92uNkq9ZFICWtTKyvDs8kc/+Usksgqbm
         hV5VmdwxxtLOIplDoOQKHAGsvrBQv85iM7jfPwRhKLpZp8rbehYBS6Qupq9ba4pa/x5c
         KNxg==
X-Forwarded-Encrypted: i=1; AJvYcCUp0Yhui4cUH2Mi4Tnteek81rXpQxuMW7dI4nZy933TZk1Zj93SHK+LoXVOGvyXo6Rrt7ifk6ziKN9iWVUcrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU6E6taZFbaXII+1GTfsWVlF9GriHptfSDaKGRplnNmaq7BXL9
	KQEAM5GOKvJclDefKYFntBubXy5QcZdObjknuMm3RPCpPoTV3eXxZ8qVzFc8TTlbvWwR8AGZi5p
	n8HNzlzbrx8OgX5WJ5RM9SB95Uv8TlOO8kQgppEx9ettq4mMNLqzqwDE=
X-Google-Smtp-Source: AGHT+IGfYvgl4t2d5KH87SOIysJD7yQWcjwsoiqjCsnNzYXjMqmOGNvsUICIa96aqdcRuCh1Mg9hRjdtLqFR8GcJA4gclYNFBTyK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c27:b0:3a0:9fa5:8f1 with SMTP id
 e9e14a558f8ab-3a3452c29a7mr31959455ab.24.1727448923616; Fri, 27 Sep 2024
 07:55:23 -0700 (PDT)
Date: Fri, 27 Sep 2024 07:55:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f6c75b.050a0220.38ace9.0025.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in __bch2_trans_get
From: syzbot <syzbot+4b39c41aee23bac377fe@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=152cdc07980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=4b39c41aee23bac377fe
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b39c41aee23bac377fe@syzkaller.appspotmail.com

bcachefs (loop4): recovering from clean shutdown, journal seq 10
bcachefs (loop4): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
Unable to handle kernel paging request at virtual address ffff0000c6b681b2
KASAN: maybe wild-memory-access in range [0xfffc000635b40d90-0xfffc000635b40d97]
Mem abort info:
  ESR = 0x0000000096000061
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x21: alignment fault
Data abort info:
  ISV = 0, ISS = 0x00000061, ISS2 = 0x00000000
  CM = 0, WnR = 1, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001a60a0000
[ffff0000c6b681b2] pgd=0000000000000000, p4d=180000023ffff003, pud=180000023f41b003, pmd=180000023f3e5003, pte=0068000106b68707
Internal error: Oops: 0000000096000061 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 7397 Comm: syz.4.294 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : raw_atomic_set_release include/linux/atomic/atomic-arch-fallback.h:524 [inline]
pc : atomic_set_release include/linux/atomic/atomic-instrumented.h:87 [inline]
pc : closure_init_stack_release include/linux/closure.h:335 [inline]
pc : __bch2_trans_get+0x790/0xa64 fs/bcachefs/btree_iter.c:3205
lr : raw_atomic_set_release include/linux/atomic/atomic-arch-fallback.h:524 [inline]
lr : atomic_set_release include/linux/atomic/atomic-instrumented.h:87 [inline]
lr : closure_init_stack_release include/linux/closure.h:335 [inline]
lr : __bch2_trans_get+0x784/0xa64 fs/bcachefs/btree_iter.c:3205
sp : ffff8000a3cc6f70
x29: ffff8000a3cc6f80 x28: ffff0000c3003c80 x27: dfff800000000000
x26: 0000000000000000 x25: 1fffe00018d6d008 x24: 0000000000000002
x23: 0000000000000000 x22: ffff0000c6b68044 x21: 00000000ffffa3ad
x20: ffff0000c6b681b2 x19: ffff0000c6b68002 x18: 1fffe000366d79ee
x17: ffff80008f56d000 x16: ffff80008b274880 x15: 0000000000000001
x14: 1fffe00018d6d036 x13: 0000000000000000 x12: 0000000000000000
x11: ffff600018d6d037 x10: 1fffe00018d6d036 x9 : dfff800000000000
x8 : 0000000040000001 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 000000000000000e x3 : ffff8000827c3258
x2 : 0000000000000001 x1 : 0000000000000004 x0 : ffff0000c6b68002
Call trace:
 __bch2_trans_get+0x790/0xa64 fs/bcachefs/btree_iter.c:3206
 bch2_btree_root_read+0xc0/0x53c fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x250/0x798 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x3278/0x5514 fs/bcachefs/recovery.c:851
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:1946
 vfs_get_tree+0x90/0x28c fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 978b1004 52800028 aa1303e0 72a80008 (889ffe88) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	978b1004 	bl	0xfffffffffe2c4010
   4:	52800028 	mov	w8, #0x1                   	// #1
   8:	aa1303e0 	mov	x0, x19
   c:	72a80008 	movk	w8, #0x4000, lsl #16
* 10:	889ffe88 	stlr	w8, [x20] <-- trapping instruction


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
