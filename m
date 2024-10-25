Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC67175D5D
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 06:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838912; cv=none; b=JKCo4Km1OWJHXhAbTXGL/IDg6qpZJ0IxrRNLHOJ9QFUopUGmo5Cx2tl4+SWqm8YWEA/+FhzTfgO6GKmcXYedFD2GXMerOafO+yBRqVMZeTkw7cb/Qoj93w8cJkusffLSp1AfflFhvyuG+ulTJgfC03as5p24OPEkkfLYkLPboMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838912; c=relaxed/simple;
	bh=ZHtYrFOm5pwWVXHLxw+PjjEt0kz3KxRMTfujpwWjYGk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ihF7UZAlHV1vELBsRjIPYo5+PmahVt3mmTEY8L1vHhbDuapabYfNMDw90IkR0wEcZjvpTg20cXYplm3U2Kt17yQe63jXvvrhcg96eKdNMAKSXQ0W3IIfj8+JXZElLw02UT3Vt7fYa9n7xKycSVrVvX2I3bbNIW+B6zF7tSvcIMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83abf68e7f0so157068139f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 23:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838910; x=1730443710;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3rPTvTvAJsgeJMoZq5P9bmyZj5JGRxgKU7WSmZGZCzM=;
        b=ESmYidj+R0gUd8/0mcQ4d1pejZUD+4IQRH2GdQIObXgBNG4IC4TbK1eSzKvkS7WZ1/
         NN3vW5+5C82y2IYQouTy5QClApprtpNSElJB0BUoodArRnpa8cdbjz1aHTQtrAKQ6LGg
         BdsWTqhYEXdAjfyoAuK5fGSypIYQkpcu0kGrN4qDWpuhHFChAJZErybhJuSynnBzONB5
         rBcJXJtaN+Kll8sXizBMCRyrQwgj8mU5NqML95v5BW2VcY/s6ycHhYI1GoEgQdJPELSu
         0Feke5rNilErL7wumDrdZnBBaJD4He0WtufXuPWd00V7VEbajs1NlgV82umWXDN8Xi18
         ktRw==
X-Forwarded-Encrypted: i=1; AJvYcCXnBQpoxUqU5dVYY2TWe3VoBzQZ5vlKh7Dima3ldt1xThES1AfEhoKuPikNug3y+3X5U1SRp4wbKFX9hAospg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzhT3Tc58bS7RqvCsKMu6LkVfWb31rquCk+2l6iM7MrTDQ7Kbuo
	pETvqOR0/abRuGwaT2VLEgbUP4vzwOINeWgXSjIA2a/hnuZak3V32ohJKY452Oxq6RaK612a70e
	ER2rmCKmdBqs4d/RbQRNCN1QYLcymebB+2x8H6kkWWwlegVV50ti25Pw=
X-Google-Smtp-Source: AGHT+IG4mMv0VpJExgXSgv2Jn3ph7CWqy5xDUOZRjOlo7VECpsm7PJBR6RggoHjqiUVYWyBkb40AzKYw2GyxCLRxs2foVomkWxkV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1652:b0:834:d7b6:4fea with SMTP id
 ca18e2360f4ac-83b0401981amr536401639f.6.1729838909871; Thu, 24 Oct 2024
 23:48:29 -0700 (PDT)
Date: Thu, 24 Oct 2024 23:48:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671b3f3d.050a0220.2eb763.00d3.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_res_get (2)
From: syzbot <syzbot+859300e61790263514a3@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    526116b79e8c KVM: arm64: Shave a few bytes from the EL2 id..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17e78c30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e39b0b4b1ace5bc0
dashboard link: https://syzkaller.appspot.com/bug?extid=859300e61790263514a3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164488a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17052a5f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2f7b2b08fdad/disk-526116b7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b69595b63015/vmlinux-526116b7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/39fd415ada60/Image-526116b7.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bc1232192aa1/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+859300e61790263514a3@syzkaller.appspotmail.com

bcachefs (loop0): bch2_write_super(): fatal error  loop0: Superblock write was silently dropped! (seq 0 expected 53)
bcachefs (loop0): fatal error - emergency read only
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.h:375!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.12.0-rc4-syzkaller-g526116b79e8c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_update btree_interior_update_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : bch2_journal_res_get+0x6fc/0x710 fs/bcachefs/journal.h:375
lr : bch2_journal_res_get+0x6fc/0x710 fs/bcachefs/journal.h:375
sp : ffff8000978b7560
x29: ffff8000978b7650 x28: 000000000000000e x27: ffff0000e0aca500
x26: 1fffe0001b9a901a x25: dfff800000000000 x24: 1ffff00012f16ebc
x23: 0000000000000044 x22: ffff8000978b75e0 x21: ffff0000e0aca500
x20: 0000000000000004 x19: ffff0000dcd480d0 x18: ffff8000978b6740
x17: 0000000000000000 x16: ffff80008b3d3d08 x15: ffff700012f16e9c
x14: 1ffff00012f16e9c x13: 0000000000000004 x12: ffffffffffffffff
x11: ffff700012f16e9c x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c19dbc80 x7 : 0000000000000000 x6 : 0000000000000105
x5 : ffff8000978b7308 x4 : 0000000000000000 x3 : 000000000000000e
x2 : 0000000000000044 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 bch2_journal_res_get+0x6fc/0x710 fs/bcachefs/journal.h:375 (P)
 bch2_journal_res_get+0x6fc/0x710 fs/bcachefs/journal.h:375 (L)
 bch2_trans_journal_res_get fs/bcachefs/btree_trans_commit.c:350 [inline]
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:668 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:900 [inline]
 __bch2_trans_commit+0x2a00/0x6604 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:728 [inline]
 btree_interior_update_work+0xd40/0x1e00 fs/bcachefs/btree_update_interior.c:866
 process_one_work+0x7bc/0x1600 kernel/workqueue.c:3229
 process_scheduled_works kernel/workqueue.c:3310 [inline]
 worker_thread+0x97c/0xeec kernel/workqueue.c:3391
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
Code: 955b1ed6 97749ac7 d4210000 97749ac5 (d4210000) 
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
