Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D753482E9
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 May 2024 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714989090; cv=none; b=SLViMRltroiOTFQo4gKjtV4cQpI72UEoU5+vfdqpQx/5Nf3LBkri3YW0LgmzNK+2KUqYKqBnJ40NyuuJkL/wiHowCVhL8D6NsSS6GRhtK+2v8dgfw4Sx82NYjEqrfs/HKZ1pE7uzJkN1RBT1ozgC/pZ20OVBh4drmcFYAPr8aOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714989090; c=relaxed/simple;
	bh=4FSlf26e9rNb8eqHzOX4Rt01U4R+DNZA1vwdPYWm2AU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KbKMyvS8wKc8XL7j3Rl2ObDFnPckVdW1xZ0c2FknagSXIw1H7uWljED9c2v49LyUOu0HXvfcHE1aQf0cqzRY5HrHBgoMKDfAiVjCAO0Mb7InRVSwOeKtAPJ5E7Vvm2byU5IppqP1RnD4lD+YCpGHkecaLlAomO4jl22nEjoW+yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7dec785a659so204852739f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 May 2024 02:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714989088; x=1715593888;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IvNvu4p143zMW785CGQE8LLYZty5gyzNTmzL35Go5us=;
        b=ONqMHqaJrC6kbKDCQxxJInB2MujZZAhdN9i0nhM1Nj09Si0h793lEcvWoUBjSzTn2S
         Y9JUn/SDBA97J3SECPhbXAo3oHZGqA+dNRHrWCaqWMKf7LGkluSk3NuFY1UkwnBXIrP7
         AomP1CZ1DtjHdxx5f4Zyvpby/WTXWVt7Nu3Su72NXFmw8kuHuwa3SnqtyflPO5oigpah
         br+z9rEU06H5Ek387e+WdTJYnkDA1r0PdqefYgHhCWVGctWcWrPwJqKe/a8Y4gP43D7z
         9T16uC8CPOjA64thyNvC20wgvggk52T0Uy9yD2+Adh31+Hf1vrfmKKk9FSCumk5dvzDl
         /zYg==
X-Forwarded-Encrypted: i=1; AJvYcCUqMWC3YwaRJcq45BRaiwWU6QVzgTNa+Cdju2PT1WJFNEn8taXZKuKCFFCGv/t1Ys1E+iXZK0PcS/b2PTdqVynd0YoDksxCwSm4c1QtJZ4=
X-Gm-Message-State: AOJu0YziGGZQFT7mzmPBuv/iqUqK/UvQgiPrIGyx3SKEIX3C6c/UXdLH
	KCiSmSz14wcfhS89sEsXL4F0GGMAijRsAdtcorA7k01jrteXHHcp38UlKqPtBdkmtbdCg8r6wXG
	3f2/RHw9YhEFzmiDr5HEMY/BhgdRnH/AAOyRZkTQQjvpxqb61i9hljNs=
X-Google-Smtp-Source: AGHT+IH3EJUA974MZrHES6Xiz/d5o8oYRGc2Sau85rwgef0z6FVDradIPyKyLr+SDZ4q5YXRcB9424nY+xPc6Y9WDjE5kmHt/PTt
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2197:b0:36b:fbab:9f1a with SMTP id
 j23-20020a056e02219700b0036bfbab9f1amr391216ila.1.1714989088368; Mon, 06 May
 2024 02:51:28 -0700 (PDT)
Date: Mon, 06 May 2024 02:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067ff3c0617c603c2@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in read_one_super
From: syzbot <syzbot+a8b0fb419355c91dda7f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    78186bd77b47 Merge branch 'for-next/mm-ryan-staging' into ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=177bab54980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ee4da92608aba71
dashboard link: https://syzkaller.appspot.com/bug?extid=a8b0fb419355c91dda7f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154d0d1f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12119450980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6645ec7d501b/disk-78186bd7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d272001bc0f/vmlinux-78186bd7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/95e2c70cba6e/Image-78186bd7.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6679d36fb016/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8b0fb419355c91dda7f@syzkaller.appspotmail.com

loop3: detected capacity change from 0 to 32799
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/super-io.c:652:18
shift exponent 32 is too large for 32-bit type 'int'
CPU: 1 PID: 7180 Comm: syz-executor245 Not tainted 6.9.0-rc6-syzkaller-g78186bd77b47 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:114
 dump_stack+0x1c/0x28 lib/dump_stack.c:123
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x2f4/0x36c lib/ubsan.c:468
 read_one_super+0xab8/0x2614 fs/bcachefs/super-io.c:652
 __bch2_read_super+0x714/0x10a8 fs/bcachefs/super-io.c:750
 bch2_read_super+0x38/0x4c fs/bcachefs/super-io.c:842
 bch2_fs_open+0x1e0/0xb64 fs/bcachefs/super.c:2049
 bch2_mount+0x558/0xe10 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1779
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
---[ end trace ]---
bcachefs (/dev/loop3): error reading default superblock: Invalid superblock: too big (got 4696 bytes, layout max 2199023255552)
bcachefs (/dev/loop3): error reading superblock: Not a bcachefs superblock (got magic 00000000-0000-0000-0000-000000000000)Not a bcachefs superblock (got magic 00000000-0000-0000-0000-000000000000)


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
