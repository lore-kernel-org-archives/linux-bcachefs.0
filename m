Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39612D1FE
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jun 2024 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718175863; cv=none; b=uZc6BHVgssIiOo1Bu19f78D3dK0gRSvgg89MzOeZsExFTjjB8q9VkNwC+4e5Cv1D2TT8KxfRNwrLwD8Z7uXEuFxUIrvcvbWoxKoPYqehn4BAFnQXDJv8U1huBOnmDpSfXk3P8ItnzGIrUYD3EdBewpQylu0veTjexQw7BVpuj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718175863; c=relaxed/simple;
	bh=zCOfxUMNbTimxoNGyJQ5cLuOQZScXflSS8KPyACMt5c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nLEKEecwRmUB4+URSjiiPmdwGVDuZOLYrjZhqaXvTgJxGzDbiY+2QehS+wBDjRA5sBiK3/Q7AjwS+G5iSYnXM7gvWexTq7RdBB6vbSGdcy74d2kWntkZu7ZatPZY+GVITsmiBc2MhXqy+QOOuf/vlvOmjxIzqlfOkt7RrpKpYVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7eafdb25dbbso701014539f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jun 2024 00:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718175861; x=1718780661;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tVP6kzcT3WzYOFPmgYeq/LYhwLDdwDXCf8wJa1aYRy0=;
        b=VEcvGdnaHmfClERY+qY1WPVEiv5hVxCuoVKJzz3Si1NBuhmjUfD27Xwpuamw7FmcOh
         McxDaJZGdJNoRK0SCBmFROdiSkw7iUWkeKuWqWHrn+4rS7QYgyEMaDqGVHdG+e8/pyIa
         XB6+wrOTMhp/Bhud9Ooqp+1ZhsTHj/BNNKcHsNe4O6V28e9bc8Fy6d02omq4KDhYoJeg
         XGZCj9ZF1DT9yHGGnCzbfUqlqU9zcfuTxYCPJBUZfaONsVQWsS4Ju1HnaZvoUSgOUKyB
         iXyUcc6vy3+QA6Pa9kKT6qZis8VcCvPoWkHHz/LjrKVYl9BIPNPeIyeLQpREoG/PzUKA
         OGaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTqK0NDdyEHG+iC/55KJFDtNqJc9trgIB3iRQVd3+jdZT/OBi98SxsyXxepnFaM8hkl10ylJVkG/8UCZ+BMEz6s9dVAh3xaHExjRb8PjY=
X-Gm-Message-State: AOJu0Yw0nEFnHCckzkpZRueFlNeHPdujVbrD9QhN2ilUKKnc6HXNV5Ad
	HUpzHroShZuyI0vvHzs+9JNf5c+FI1WfDQ25PBCRWHYGSYBTJEdbBhW8FLT50T0Q/PRpVD8Qgbw
	JTV+abS9a9ALGTrqKi/rzx9fYxfDmKmyXPFA6A9WIOruARZJZSR5EOCU=
X-Google-Smtp-Source: AGHT+IE1L4UGLI+rRwggB1Q4T+ACzMUx5Z8S+02UGk0btw7KxMtFtHCjU1E3BNcomnebOuTvopAinr/yk0o71hsY1dcSoVdo+NYK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8718:b0:488:d668:d201 with SMTP id
 8926c6da1cb9f-4b93ec0e1bamr66869173.1.1718175861100; Wed, 12 Jun 2024
 00:04:21 -0700 (PDT)
Date: Wed, 12 Jun 2024 00:04:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dce2f1061aabfdfd@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init
From: syzbot <syzbot+dd828a1b596932a42e10@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1749a2e2980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b4350cf56c61c80
dashboard link: https://syzkaller.appspot.com/bug?extid=dd828a1b596932a42e10
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1206d55a980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e839ac980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6ea21f50498b/disk-8867bbd4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2fed09364aa/vmlinux-8867bbd4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4860173c7a18/Image-8867bbd4.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9f1aae1e19b4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd828a1b596932a42e10@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:645!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 27 Comm: kworker/1:1 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Workqueue: bcachefs_write_ref bch2_do_invalidates_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : bch2_btree_path_level_init+0x820/0x83c fs/bcachefs/btree_iter.c:113
lr : btree_path_pos_in_node fs/bcachefs/btree_iter.c:113 [inline]
lr : bch2_btree_path_level_init+0x820/0x83c fs/bcachefs/btree_iter.c:645
sp : ffff800093f06d30
x29: ffff800093f06d40 x28: dfff800000000000 x27: 0000000000000000
x26: 0000000000000000 x25: 0000000000008000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: ffff0000d4718234
x20: ffff0000d8597800 x19: ffff0000d4718230 x18: ffff800093f079d4
x17: 000000000000cd7d x16: ffff80008af156e8 x15: ffff7000127e0d94
x14: ffff80008eff0558 x13: dfff800000000000 x12: 00000000e50ce57d
x11: 0000000000000002 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000c1b7dac0 x7 : ffff80008278cf60 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000d8597800 x1 : 0000000000008000 x0 : 0000000000000000
Call trace:
 btree_path_pos_in_node fs/bcachefs/btree_iter.c:113 [inline]
 bch2_btree_path_level_init+0x820/0x83c fs/bcachefs/btree_iter.c:645
 btree_path_lock_root fs/bcachefs/btree_iter.c:783 [inline]
 bch2_btree_path_traverse_one+0xd84/0x285c fs/bcachefs/btree_iter.c:1182
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:229 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2185 [inline]
 bch2_btree_iter_peek_upto+0xbd8/0x56e4 fs/bcachefs/btree_iter.c:2285
 bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:641 [inline]
 bch2_do_invalidates_work+0x454/0x249c fs/bcachefs/alloc_background.c:2010
 process_one_work+0x7b0/0x15e8 kernel/workqueue.c:3231
 process_scheduled_works kernel/workqueue.c:3312 [inline]
 worker_thread+0x938/0xef4 kernel/workqueue.c:3393
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
Code: d4210000 9777e81c d4210000 9777e81a (d4210000) 
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
