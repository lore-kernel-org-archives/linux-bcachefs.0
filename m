Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF918A6B6
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Sep 2024 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726702167; cv=none; b=SBzsGsHNZdWn0VLBOGmOttZYaprFAMnykp9kyWWJlBpT3N1F1DpjRuSrnJzA9PKmAwgtZvtXW6Fa+1dWAzhWqqnCO4RrnYw0f5zmywiMz65dNbkkcfmqoL9O1Sku5UspQ+8+ZcYcUKYx2PZkJYi+MgkSIOqwITbOxjPcoY4AfgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726702167; c=relaxed/simple;
	bh=FM1XhAoAvnG8yU8C8slzPxJLsSLErMUxGwaqxk2ETBw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WdufmGTDREuiGhIff9qrOubNHBpjqkb1wXqSv6M+2kbxuDwEdhl/MQlwCCI8yKYHmGjOsfSR8rDSiObEQvBlPtAs2OjrggIWOwdi3sBUcRCA7n+pqhOoAobmMdSjVsxBJU/cAH8Th8rnANWETily9vsYzEVeQEn4Xscri9skv9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39f5328fd5eso3590965ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Sep 2024 16:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726702164; x=1727306964;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MG4qYuEYgY2F4rb2s1I0pOQ6JfmsY9G6MRD32wvArho=;
        b=CtR4C4aQtjiUnwHbk9Wi7LyI5BV0h+/dkpaun6uB547fObVOoXI92guuBageYJYPI/
         +VQ/k0MuHV2UiciThmTVIO9M7pMZtVYOzGaEBcIClc0+u2kvUCAvOu3n/TXM0WSgi0Gl
         z8Tho8ipLrrW0oYUDjBg+a0zH2NR4ZSyxqE1+ilkhAPVQA+Pr/Olo88RdZ3XhKhck1jb
         vPPZYghvK75kGE2YYqGZetFKJuAhiN2nqT1dVsEzY5h1GpFpZZGc9V5c6YnXozK07Y40
         aXULVGSwNDD/P+sXWTGYmw3PFUywqk/3peIO4oaO3BnbutfT5H/7ANoIDAVnTTvH1OSn
         6tCg==
X-Forwarded-Encrypted: i=1; AJvYcCUg4BHnAEvRcseuMz0AM6Re14TPQqT2Wi7czaRUfrqIuH2rAM499l50r/O97oq8c0/cSf4M5BXibz5dM8yvzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIqTE/97HxuTIJPtLGKxl3Vi7iFcTjpfx8ghOZC1v6CcCksR4C
	kMRNSee6DLRR5epH/2yFPfz9B1JUnWxL0RIXUuDx3yZcu5U2o0NIqHrzADqFgtkvYOYB+SC/sCF
	HhODUOIcyPkB2pUQWisRJqPFbYezVJedsVp+g7VQbmWq/4i8KQJ7wHZM=
X-Google-Smtp-Source: AGHT+IGbwLVjTBX7ANQZ5lcTZ+yoLCvdeWrvoH2s22NwC2xSpUgv39hwAs/291harZta38YPqCqToN8lwCX5FR+32KWBb9XWEnD7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4d:b0:39f:51b8:5e05 with SMTP id
 e9e14a558f8ab-3a08495477fmr185587325ab.16.1726702164501; Wed, 18 Sep 2024
 16:29:24 -0700 (PDT)
Date: Wed, 18 Sep 2024 16:29:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in bch2_opt_to_text
From: syzbot <syzbot+294f528e56138c357a48@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16006407980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=294f528e56138c357a48
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11006407980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151e1900580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b5f17be42aea/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
Unable to handle kernel paging request at virtual address dfff800000000000
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
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
[dfff800000000000] address between user and kernel address ranges
Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6405 Comm: syz-executor394 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : strlen+0x30/0x70 lib/string.c:402
lr : prt_str fs/bcachefs/printbuf.h:230 [inline]
lr : bch2_opt_to_text+0x158/0x6b8 fs/bcachefs/opts.c:424
sp : ffff8000a38773e0
x29: ffff8000a38773e0 x28: ffff0000dce00000 x27: 1ffff00011728510
x26: dfff800000000000 x25: 0000000000000002 x24: 0000000000000002
x23: ffff0000dce00000 x22: 0000000000000000 x21: dfff800000000000
x20: 0000000000000000 x19: 0000000000000000 x18: ffff8000a3876d00
x17: 000000000000ce44 x16: ffff80008b2e26cc x15: 0000000000000001
x14: 0000000000000000 x13: 0000000000000003 x12: ffff0000cf959e40
x11: 0000000000ff0100 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff8000a38772e0 x6 : 000000000000003d
x5 : ffff0000c5ac126f x4 : ffff80008b945083 x3 : ffff80008b2e5714
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 strlen+0x30/0x70 lib/string.c:402
 prt_str fs/bcachefs/printbuf.h:230 [inline]
 bch2_opt_to_text+0x158/0x6b8 fs/bcachefs/opts.c:424
 print_mount_opts+0xbbc/0x164c fs/bcachefs/super.c:992
 bch2_fs_start+0x44/0x53c fs/bcachefs/super.c:1004
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
Code: f2fbfff5 8b140260 d343fc08 12000809 (38f56908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f2fbfff5 	movk	x21, #0xdfff, lsl #48
   4:	8b140260 	add	x0, x19, x20
   8:	d343fc08 	lsr	x8, x0, #3
   c:	12000809 	and	w9, w0, #0x7
* 10:	38f56908 	ldrsb	w8, [x8, x21] <-- trapping instruction


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
