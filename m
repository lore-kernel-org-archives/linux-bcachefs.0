Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE34A2F
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jul 2024 01:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721093002; cv=none; b=F24tf2DeEXz6TNlwCIuMSND77jOymeAvd7fE2abhP5prcN6x1ev+t/IhVvAGuSoDxxAhBgJ72KQOV6pETsXO946jvrnDwiu9Cy0QVQ9em8dsrAkppdEVMG13Q/Gy7S/9GKMgFKg3+4uCSnMppPPvXMuzNNHWUjeGdzQgphiyy0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721093002; c=relaxed/simple;
	bh=bq0vAZeiH25E5s3ISrbTktGHbbPiDY51qBzXDk3EKO8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=G1f13pIRzbngs/DllP7O6Jk73RD8JrCHSA8viBCaxL/Kw2nXyw3iwfhRd7K19H02YbQtBXMkSzac7/kurcaMoZBgomUofOA7mQIzEQgzAsAaRYxcT0JVfHiCRm9mlrCZu21h5OHysmyHBqnJH5NNG6tYJ2E2kViI5Gft1IG5kew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8152f0c63c4so63689739f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jul 2024 18:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721093000; x=1721697800;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dn2dD9SXzWCfYkGnDiRvv9qn92tH6gbZqZyhArKDrx0=;
        b=Abc74RY1FTqbnCorNgCx7AOdorpPECO3Rfv4X7l/KzLyENIuNNfPGpZYanC6phBF3G
         +EqX9BcuuIIyQk0GMHs6f+Grji1kPuhc5uzv2Lm2ZHyd26/kemx2HBEFEJg/RnuDXh7H
         Tki5WRruBNiuEt9S2XCsRd+/36i5AD+SE5GkX0RVQ/p4W1ER2lD2XTTMnYXtp+Cfjd5e
         bdxDEyteUxxufwd1LlN7IAInv0dshCke9r2hux4W6wjHnKDy4SlmqOddObETOuN7dZll
         6BeTGqOCH7WzKZ5ypemRO6A8Nm5r3j19EcCYNcNcSoa0/GbadaddF0n72iyamavF2Nr0
         GT1g==
X-Forwarded-Encrypted: i=1; AJvYcCVGJHu4YcMBjmX5wxBQnKLQ1GjRismHl8ZUj8ZI0bAIHexEftRCV7FfSd1CpZdhNAYhUF5uZfdnkYXdOW471y4+v6ZI5awPWJdE9oQ7/4Q=
X-Gm-Message-State: AOJu0YynF3rxeIIjmWJsvIE9fH2ByjbSOL+wXs+jCgv5T1uRb8ZI4sDH
	BJRbHBSgEZzxlvelJ3Yi5+yVvJTZflYD8u6HJbNJ3/5+YoZD5dwDuHAB57tciBsplc8gnIsmDwV
	DH0ihohd3e51nFlqtkCa2Hz3Arb+HNcFEp67teJHSdcoreY6EGk1cSak=
X-Google-Smtp-Source: AGHT+IEAmwQbANedBlsmL7xbuvuTXsAXFpos5LDFMFVT5CnnwlpHe7iyuc4Hb7jSMdAmqxVmzYQGx9DgXlGq3HpjM0MbubAQZn1j
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1382:b0:4b9:ad94:2074 with SMTP id
 8926c6da1cb9f-4c2070710dfmr12619173.3.1721093000071; Mon, 15 Jul 2024
 18:23:20 -0700 (PDT)
Date: Mon, 15 Jul 2024 18:23:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e51951061d533014@google.com>
Subject: [syzbot] [crypto?] [bcachefs?] BUG: unable to handle kernel paging
 request in crypto_shash_update
From: syzbot <syzbot+e46f29a4b409be681ad9@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c912bf709078 Merge remote-tracking branches 'origin/arm64-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10696b35980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79a49b0b9ffd6585
dashboard link: https://syzkaller.appspot.com/bug?extid=e46f29a4b409be681ad9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117911a5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f0554e980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fea69a9d153c/disk-c912bf70.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/be06762a72ef/vmlinux-c912bf70.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6c8e58b4215d/Image-c912bf70.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/cb5b89772c6e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e46f29a4b409be681ad9@syzkaller.appspotmail.com

 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:131
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:150
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
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
CPU: 1 PID: 6452 Comm: syz-executor232 Not tainted 6.10.0-rc7-syzkaller-gc912bf709078 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : crypto_shash_alg include/crypto/hash.h:733 [inline]
pc : crypto_shash_update+0x50/0xa8 crypto/shash.c:52
lr : crypto_shash_update+0x30/0xa8 crypto/shash.c:51
sp : ffff80009ff56620
x29: ffff80009ff56620 x28: fff1000040000000 x27: ffff80009ff56800
x26: ffff0000e1c404d0 x25: dfff800000000000 x24: ffff80009ff56800
x23: dfff800000000000 x22: 0000000000000020 x21: ffff80009ff56800
x20: ffff0000c6009000 x19: 0000000000001000 x18: 0000000000000008
x17: 0000000000000000 x16: ffff800082f8f174 x15: 0000000000000001
x14: 1ffff00011e7a636 x13: 0000000000000000 x12: 0000000000000000
x11: ffff700011e7a637 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000004 x7 : 0000000000000001 x6 : 0000000000000001
x5 : 00000000ffffffff x4 : 0000000000000cc0 x3 : 0000000000000040
x2 : 0000000000001000 x1 : ffff0000c6009000 x0 : ffff80009ff56800
Call trace:
 crypto_shash_alg include/crypto/hash.h:733 [inline]
 crypto_shash_update+0x50/0xa8 crypto/shash.c:52
 __bch2_checksum_bio+0xbf4/0x10d8 fs/bcachefs/checksum.c:300
 bch2_checksum_bio+0xc0/0x10c fs/bcachefs/checksum.c:319
 bch2_write_extent fs/bcachefs/io_write.c:1044 [inline]
 __bch2_write+0x1d20/0x47f4 fs/bcachefs/io_write.c:1461
 bch2_write+0x8bc/0x153c fs/bcachefs/io_write.c:1634
 closure_queue include/linux/closure.h:269 [inline]
 closure_call include/linux/closure.h:425 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:531 [inline]
 bch2_direct_write+0x1670/0x2988 fs/bcachefs/fs-io-direct.c:654
 bch2_write_iter+0x1a8/0x2d24 fs/bcachefs/fs-io-buffered.c:1135
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x8f8/0xc38 fs/read_write.c:590
 ksys_write+0x15c/0x26c fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:652
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:131
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:150
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 9778c38d f94002a8 91008116 d343fec8 (38776908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	9778c38d 	bl	0xfffffffffde30e34
   4:	f94002a8 	ldr	x8, [x21]
   8:	91008116 	add	x22, x8, #0x20
   c:	d343fec8 	lsr	x8, x22, #3
* 10:	38776908 	ldrb	w8, [x8, x23] <-- trapping instruction


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
