Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D419CC1C
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 09:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738142247; cv=none; b=bKI394xrBDhM0LqY9vAm5bT4HGI81PRYw4rnY5rMWH58xSDBPUfBhaHmVglXVSR9+DWvu6QSRoAmrwHKgY5RNfC3Xu1Kfp1kAIch2CWHAFfp6VPMZppJgGWWbQWM707h06pJx2p4lrzk+KkeYqsMDiyypn9xj1X36qd72nsV6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738142247; c=relaxed/simple;
	bh=uhz29pFGTLO1WSLXdswVO891A/SMOx1JpDShtxF5VTA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rmSlAEawK+SXJCOWuFpET3QysQ8joeYXQpW+D6/qmLZ80Czx3JrKMKCA7Mu15CrhkrOmFC5YWj4PMztxKvwwF7PQaOnq0iVz3gCyDYAHuflcRe40hKXX93W04E2L9UNhpTsiy5nHKW/nrWpbUowm/IUyow16DhS+dB4uyoU/QhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so63245665ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 01:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738142244; x=1738747044;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P5iJ4mjMOYRgwEANmAd+8NVU2Qq6x7d5zh/kFQq1hbo=;
        b=BoctkRYZzGdBVXv8lsR6KYYMgtmexEto9cM4INzWJ3sOgUY/90BfUUN3uiUbkIEpGd
         hGPrGvpFqBtmCnfXSq1ejRT32sML0nBiLRff6CMWwWrVPSJFN7Qqpmol00i6CKUhIAm1
         ToVNTpqljYymr47nNAKDiiMRX2kCIapy3kkTHKZFbrNso4Dcr7ZTOWLpNgFqc+de/D/+
         XdZ+jOZ9mRkbl1YA2UpqQZRVlobp+rv2I1IzZjJwI9XWKPurDT480w8tgQSVP2Ztz/AN
         iy/2/dzjNVz1QSz67I/okT0T+nKpY7ftz4d1/axIFoQ5ytH0uceZhi8BosAq1l1JRJSn
         vlXg==
X-Forwarded-Encrypted: i=1; AJvYcCVQN+UI5u3XKG6ZILs1HRhe5AHjh9JoAnFPx+zpBYU+EGUhRfdbMckJic9iXA4VOs+EIgLwE77i99b9RREtXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsX/Osady01D3+v3smurl/Ros5FXKkAodq6JJmgAI3kAfqW7Xn
	sZdNyCx3o7XDWeTBhRn7XQco6KC+axEU5OcdlzXX04j3GGeq5FwJvgWDzyUg5oi9aLCLLMxdVcM
	oT2LP1I+K7ksWnTmj4/UIHTtZ/5JlRbzATj6KW59gAuwSzVLx5oC+lT0=
X-Google-Smtp-Source: AGHT+IFjPpM+n2RQZuRIXXgPmcjriFwZxjmkZ0i7auBINykh840hbWmYXhfj04akAU217sbj2/+qHa6kLZUxf2xgpOCJawCoqE1Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2608:b0:3ce:856b:e451 with SMTP id
 e9e14a558f8ab-3cffe396c69mr21949775ab.5.1738142244378; Wed, 29 Jan 2025
 01:17:24 -0800 (PST)
Date: Wed, 29 Jan 2025 01:17:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6799f224.050a0220.ac840.02cb.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in btree_interior_update_work
From: syzbot <syzbot+de02219c78c082fe2f21@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ab18b8fff124 Merge tag 'auxdisplay-v6.14-1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a47564580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac8df499d47c7efd
dashboard link: https://syzkaller.appspot.com/bug?extid=de02219c78c082fe2f21
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/366f413714ce/disk-ab18b8ff.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5270d59ecedc/vmlinux-ab18b8ff.xz
kernel image: https://storage.googleapis.com/syzbot-assets/43d7aec7a24c/bzImage-ab18b8ff.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de02219c78c082fe2f21@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in btree_update_nodes_written fs/bcachefs/btree_update_interior.c:688 [inline]
BUG: KMSAN: uninit-value in btree_interior_update_work+0xcef/0x4820 fs/bcachefs/btree_update_interior.c:844
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:688 [inline]
 btree_interior_update_work+0xcef/0x4820 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3317
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3398
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:645
 btree_node_data_alloc fs/bcachefs/btree_cache.c:153 [inline]
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x4f0/0xb60 fs/bcachefs/btree_cache.c:652
 bch2_fs_alloc fs/bcachefs/super.c:908 [inline]
 bch2_fs_open+0x4b24/0x59c0 fs/bcachefs/super.c:2053
 bch2_fs_get_tree+0x986/0x2330 fs/bcachefs/fs.c:2190
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3560
 path_mount+0x742/0x1f10 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x71f/0x800 fs/namespace.c:4088
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4088
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 5856 Comm: kworker/u8:4 Not tainted 6.13.0-syzkaller-06077-gab18b8fff124 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: btree_update btree_interior_update_work
=====================================================


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
