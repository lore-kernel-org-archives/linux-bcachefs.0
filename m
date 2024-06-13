Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714BE14374F
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jun 2024 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282361; cv=none; b=KDl9m85T3dhR5IGkDQI0MlPyxmm3WPBl0DJUKROagnnCKs1uTgeDRH3h0aiOz0AtMMU/Iekl37eRXJv8MabIfcUgxpEi0PZ+i1si8djh+7KcPO1IBY7Tz8iDFeSW3n2xHO0onIq3FoCzG0jdCWSWCAwFJRL7Ua59m1yBY9RKoOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282361; c=relaxed/simple;
	bh=dIMx3klx1aYTahUxgVL0ygIuWYp3D7e2wljj0j4/hSk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kE4wqSx49c36czdGl7iPkjZZVOGY7FANFLUKh499SRZsdDhiXhVYQjsIGlz+Rt3ysgJfFpvurzCfOU0a5AGyiHql6ybPJlIYltHD7btlhRzN/NdHulk1VKBvxjph+EMDNcHluwoaLcL6PrEiJBgQ7IzJQAd9vuOb9emyQPoAr/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7ebcbef22c8so91913339f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jun 2024 05:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718282359; x=1718887159;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=90sgWRcRTbkt2hNtVjR41YJy01AkA7uEUxv3xqb4oFY=;
        b=qbfygaH+bh0VXfQgoGJmYzJpSTm9ZOhs4L4uoo6agETarOQB8ecJLs6yRnHgn9sHZn
         6QNid48fnSTZAiwXRzCIOyU/EVpXWeIjDqviZSsJc7Tq5G3+21okJ0Zd7HzhuSo8SyRZ
         D1x2jQRwvOBrWVgmY7u6BFDR/rztZEaYf8ML3OXEBS79GdMTw3HYbRTErbmpVP8rtHt3
         kFFGUxCkl6H/UQlnob7xZZyAzNpDWKtYU5g9qqR10OeEu9Kf6f9IiNwsXeQfcKfZlWea
         MNhg97yAWZjgJdHRu7OZJ1KAJTagzB4jx3aX0rkbDjZDhU4YD+88Ppo87+1tZXf7QhoM
         Khhg==
X-Forwarded-Encrypted: i=1; AJvYcCXZg/EKZolIHIXGNlkNFHGSIaa1xCh6181xpvNgUFu/Q9kgoVhc5S7V0lqfsfZGQv3svb99jWmCAN5uQeTipRSN1uwJihTt9JSvN1m2Si0=
X-Gm-Message-State: AOJu0Yxsg5Ff63ZEfRQn4jhgapEXA0hLX7qmd4EL5CVNbC8Ep8fdx3Mv
	7XnPUQc5VTSeL4OILU+VAf2BvVdAxJz3unwcXLVwVHpYiABGikBMHuMtH8Wm0oMxhSfrpuE37BY
	BHCyiE5npFTftPRge6wXT4XcmyUFwUbgeRIr9eUyzgqKyxMk1YJPCZQY=
X-Google-Smtp-Source: AGHT+IEch/ZagfAh1kyKc3yFoJwHV/k0QVtH7TxX7bC4jJNF20s094WKS+gBG1xL2vfoPcCbD2Ygn8eHL6uUvR/9CkpaiebkYz+i
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1512:b0:7eb:78b4:faff with SMTP id
 ca18e2360f4ac-7ebcd165a01mr11014839f.3.1718282359594; Thu, 13 Jun 2024
 05:39:19 -0700 (PDT)
Date: Thu, 13 Jun 2024 05:39:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aaf271061ac4c9ab@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_res_get
From: syzbot <syzbot+ffd2270f0bca3322ee00@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1210c3fc980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b4350cf56c61c80
dashboard link: https://syzkaller.appspot.com/bug?extid=ffd2270f0bca3322ee00
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16aecfba980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171b3126980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6ea21f50498b/disk-8867bbd4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2fed09364aa/vmlinux-8867bbd4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4860173c7a18/Image-8867bbd4.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bd29adaaf7ea/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ffd2270f0bca3322ee00@syzkaller.appspotmail.com

bcachefs (loop0): flushing journal and stopping allocators, journal seq 11
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 11
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.h:375!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 6249 Comm: syz-executor102 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
lr : bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
sp : ffff80009b3076e0
x29: ffff80009b3076e0 x28: 1fffe0001bf4957f x27: 0000000000000002
x26: dfff800000000000 x25: 1ffff00013660ee8 x24: dfff800000000000
x23: 1ffff00013660eec x22: dfff800000000000 x21: 0000000000000005
x20: ffff0000dfa4a5c0 x19: ffff80009b307760 x18: 0000000000000008
x17: 6c706d6f63207372 x16: ffff80008ae4f3c0 x15: 0000000000000002
x14: 1ffff00013660eec x13: 0000000000000000 x12: 0000000000000000
x11: ffff700013660eee x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d62fbc80 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000010
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
 bch2_journal_meta+0x9c/0x268 fs/bcachefs/journal.c:828
 bch2_fs_journal_stop+0x188/0x348 fs/bcachefs/journal.c:1179
 __bch2_fs_read_only+0x2a4/0x3d0 fs/bcachefs/super.c:291
 __bch2_fs_read_write+0x2f0/0x434 fs/bcachefs/super.c:507
 bch2_fs_read_write+0xa8/0xf0 fs/bcachefs/super.c:520
 bch2_remount+0x2bc/0x460 fs/bcachefs/fs.c:1731
 legacy_reconfigure+0xfc/0x114 fs/fs_context.c:685
 reconfigure_super+0x1d0/0x6f0 fs/super.c:1072
 vfs_cmd_reconfigure fs/fsopen.c:267 [inline]
 vfs_fsconfig_locked fs/fsopen.c:296 [inline]
 __do_sys_fsconfig fs/fsopen.c:476 [inline]
 __se_sys_fsconfig fs/fsopen.c:349 [inline]
 __arm64_sys_fsconfig+0x8b8/0xc40 fs/fsopen.c:349
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 17ffffab 9770cd61 d4210000 9770cd5f (d4210000) 
---[ end trace 0000000000000000 ]---


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
