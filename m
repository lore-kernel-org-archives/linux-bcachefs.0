Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06A819DF52
	for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jun 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246506; cv=none; b=cLtz9NFMeByZE1XB1u36QiqnT8hbZIlJ5dFH0lsYGnEn6tNc5ClRrji0+32s2M7GDHqJwYkavXzMjs3AAGtWDQc0BzEovS0c3XgCoPhl964q3uA8/FAmaqaALyPlvkR2IKZ3DdXB+TcJzBoVi6WzqOdDowfEELqsR3lwJ7HVXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246506; c=relaxed/simple;
	bh=5DQv6q/d8Zv4IZcFJrQ5Ej/kkd3Cy1080/mSwVyHRso=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eXhhMPJcRqVr4XTf/AKdLiy9tcI398parQOKMrtJ3oob4w8o8w8ijjRg9jdYUuWKUn43f3mh3dkOjD1KtpVPQiI+jcJTro3py/dp3jkfE2z+wApTPiyeMElZUuXYLpnFyXQItuirSXiYiliI5EortB2ELCBWgLZOiN6XZArOCbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-37624b27e27so54183285ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jun 2024 09:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719246504; x=1719851304;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yXBDcDx7zvPLVQs0LnYcC7eMOxJKuBiX4Pnp+R0ymsc=;
        b=BaRWiH0m/N207KJL72tQ4vM11eo8X+wBVdI+4uidW80c4x7Fz5/4bKJ7GxsqIFiNam
         26QmA1EijCtUzQH9yNs054H8KafAZfZPnTkzMr0uoup9dmuJDUIdoTlOt5TiC0+CdWeb
         2rZjFgo0GlWcvqMVGKCRKIsacr9x82XHqaTSTxApU6SJKo9aTuZlb0ztUqmNCixPTZn1
         gOC7D58xG4x6Z7vc031jR6vqOI+IrF3qX4yGL22XMPtJ7NxyqaFM3RJHYFPR+hq8o8qQ
         ZSMQJ6R00ipL6nDL1p3EgHo84uRMNt3YNEYujn8eCYJKbNU4KVm5gMgxszoBn8de+OHF
         vpRw==
X-Forwarded-Encrypted: i=1; AJvYcCViqqnDq438A6tLLqjfPHK3u5BO+cnmJQEenjrkIEtJDUpwvn6BC+kSx4JeGZBakkmTDfUKBP1gBWe/Kt4iJUpE6fNAoBGy2GBtU4xvztk=
X-Gm-Message-State: AOJu0YzXbt1emv4twF+VCWkTx7oPpZ4HQXuXSgVHn3E77jVXD4JBWflT
	Ho2UsP/0bXGPWaVZ9l0iEDhhQ1UXvVxZJ1CYnAQ9/oA3y3D3+eswRmFXZXtNs8AeVP7j9Hv60xG
	p8Ab6zKQ8ZpXK2qNovh7sDcyvTLhhMuMTZCilhLa8kzlQXjUdvjd9bRI=
X-Google-Smtp-Source: AGHT+IGpSgacUnDvzowCijGiB6OzzIZBkIKvs2C/meh1seBg++FXNVS/PVZLbWR5bVqOh+Mnu31fVJuItyYt7E/SJKdcLgkE2Un6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4f:b0:375:c9f0:527f with SMTP id
 e9e14a558f8ab-3763f6dd87amr5271765ab.3.1719246503994; Mon, 24 Jun 2024
 09:28:23 -0700 (PDT)
Date: Mon, 24 Jun 2024 09:28:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026f7f2061ba545c2@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_write_iter
From: syzbot <syzbot+d8b126a5bfdcd1f3e7c5@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e2c02a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79815c08cc14227
dashboard link: https://syzkaller.appspot.com/bug?extid=d8b126a5bfdcd1f3e7c5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/35e32e9073a7/disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c6e34658d16/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4417e7ef76ed/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8b126a5bfdcd1f3e7c5@syzkaller.appspotmail.com

INFO: task syz-executor.4:6221 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:27824 pid:6221  tgid:6208  ppid:5618   flags:0x00000006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 inode_lock include/linux/fs.h:791 [inline]
 bch2_buffered_write fs/bcachefs/fs-io-buffered.c:1012 [inline]
 bch2_write_iter+0x22e/0x2840 fs/bcachefs/fs-io-buffered.c:1136
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe64e7cf29
RSP: 002b:00007efe65bc10c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007efe64fb4050 RCX: 00007efe64e7cf29
RDX: 0


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
