Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1B198851
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367383; cv=none; b=mBcs2zGbmBJBKE3qUHeyySgOz6ZjyME11P8PhMj+Q0ISHzGPL7ueNZ1TfBNQkbgJAFP6uKiUfcfSrJ2UlyQnBPv9Bp7p/WuHSgNUCVNW4qnL5TJXnvbRjkSCKW2ubVLwg6pWKvoYe7b3VMgbf+asoizi6feyfahpzQJhUrN7eao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367383; c=relaxed/simple;
	bh=/Rujk8DjihECRgTxY5K/o9PR1gx2ryqyCsAZfVNkkS4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qvjilU8K3q1CfI2IO4zYNxwv/XeBElwW+SlaaR2E0S9S50/nuoN1P8oC8SewaftzOUdUnTE5sZNxrRpvgddWM7w5/rvBxTbf1Yf4pq97o7SvQL/2gIz6Kel7PqSdgSiAn8aRF5hPvcJSo9ZZ6okkvDz41ScObBfEhngJEKezubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7eb5f83ae57so248668739f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 05:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718367381; x=1718972181;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vB05HPijVVK+UzmnMPGdCm9HQMlq2U20Ujta3yugVqY=;
        b=uznONrk5bSAkQDuQXZoRXQ4qzOe39sT8WO9W19S477LKV+PnFXCmhnJvhL9/7BM3eQ
         nNsoUI4Kgw3N/ZrNUW4lBxvfc/V05pYFStOIJpfmci4jiQqTJvAMTg1kQjWDPkvjO3nk
         en/SzX/oKI+n+cBcaKx7eZQUJb5Hx/ii31kXR8/X+DeuNuzQCGwKx+fntD+Z2MYQkcig
         ejiP0OlhFpYYHv01lrOv2aD2vOPE0Sbxj4J66sYIluOJUrY+NZ5KnzRlXTgcWtd2bOYk
         3lc6C/SKDvAZo/AyjzAPDTBYmRbosCnF6H1kJaQJ58mV9RE6NtZR/Vp45Bo1OMDnrxlE
         9QXA==
X-Forwarded-Encrypted: i=1; AJvYcCUuPJXlWqZDti3XftAn02H9SAf5AMI7u6pJxk8UvrjVB99hrtXHOYypCMt4uVwfIXQqBGs5gFZ0hHIVIFhsXKg3x03KRHdhM9l8KI3yd+o=
X-Gm-Message-State: AOJu0YznhPR5xNHQ7eNBaUTtO4S305oFwFXoKdso7pixiKNTrStLkHRU
	UqN42OKENIFwC7DH3os+78WpvjcBF2V834NwQyHhUWm/B0ej0UkdRAtO5FZ2oGirdnoy4Zq9yiC
	/ZXmRczpMChH+t1ftQdb94LsKGR/ZlOyjhBafhsL4peTgb0VW4aDQGmY=
X-Google-Smtp-Source: AGHT+IHYFcJnb+5OofRIeaS8UT7bfdq2MIZHDD2qTc1tn/r5bWzluutMriZZLOcTtb6uxQDEremSBv/cJ6sTbA3fgsPNbWm3BkCT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4e:0:b0:36c:4c63:9c93 with SMTP id
 e9e14a558f8ab-375e02b6954mr1413495ab.3.1718367381068; Fri, 14 Jun 2024
 05:16:21 -0700 (PDT)
Date: Fri, 14 Jun 2024 05:16:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057a891061ad8951a@google.com>
Subject: [syzbot] [crypto?] [bcachefs?] BUG: unable to handle kernel paging
 request in crypto_skcipher_encrypt
From: syzbot <syzbot+026f1857b12f5eb3f9e9@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ac2193b4b460 Merge branches 'for-next/misc', 'for-next/kse..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=120a2a56980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ce2e16ea9422f82
dashboard link: https://syzkaller.appspot.com/bug?extid=026f1857b12f5eb3f9e9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e534a2980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e15446980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1a058064a7f1/disk-ac2193b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/71fd113f4bcf/vmlinux-ac2193b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a4603f3a4756/Image-ac2193b4.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ea4906e9262d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+026f1857b12f5eb3f9e9@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
Unable to handle kernel paging request at virtual address dfff800000000004
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[dfff800000000004] address between user and kernel address ranges
Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 6250 Comm: syz-executor983 Tainted: G        W          6.10.0-rc3-syzkaller-gac2193b4b460 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : crypto_skcipher_alg include/crypto/skcipher.h:375 [inline]
pc : crypto_skcipher_encrypt+0x48/0x124 crypto/skcipher.c:637
lr : crypto_skcipher_encrypt+0x24/0x124 crypto/skcipher.c:635
sp : ffff80009a2759d0
x29: ffff80009a2759d0 x28: 0000000000000000 x27: dfff800000000000
x26: ffff80009a275fe0 x25: ffff80009a275a80 x24: ffff80009a275a60
x23: ffff0000c8482a80 x22: 0000000000000020 x21: dfff800000000000
x20: 0000000000000008 x19: ffff80009a275a80 x18: ffff0000d67d9a30
x17: 2065657274622074 x16: ffff80008ae35f00 x15: 0000000000000002
x14: 1ffff0001344eb56 x13: 0000000000000000 x12: 0000000000000000
x11: ffff70001344eb58 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000004 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : 0000000000000000 x3 : 0000000000000010
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000020
Call trace:
 crypto_skcipher_alg include/crypto/skcipher.h:375 [inline]
 crypto_skcipher_encrypt+0x48/0x124 crypto/skcipher.c:637
 do_encrypt_sg fs/bcachefs/checksum.c:108 [inline]
 do_encrypt+0x558/0x6a0 fs/bcachefs/checksum.c:150
 gen_poly_key fs/bcachefs/checksum.c:191 [inline]
 bch2_checksum+0x1c0/0x784 fs/bcachefs/checksum.c:227
 bch2_btree_node_read_done+0x119c/0x4ac8 fs/bcachefs/btree_io.c:1074
 btree_node_read_work+0x50c/0xe04 fs/bcachefs/btree_io.c:1345
 bch2_btree_node_read+0x1f50/0x280c fs/bcachefs/btree_io.c:1730
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
 bch2_btree_root_read+0x2a8/0x534 fs/bcachefs/btree_io.c:1793
 read_btree_roots+0x21c/0x730 fs/bcachefs/recovery.c:475
 bch2_fs_recovery+0x31c4/0x5488 fs/bcachefs/recovery.c:803
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1031
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2123
 bch2_mount+0x4fc/0xe18 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1780
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 977849b2 f9400294 91006280 d343fc08 (38756908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	977849b2 	bl	0xfffffffffde126c8
   4:	f9400294 	ldr	x20, [x20]
   8:	91006280 	add	x0, x20, #0x18
   c:	d343fc08 	lsr	x8, x0, #3
* 10:	38756908 	ldrb	w8, [x8, x21] <-- trapping instruction


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
