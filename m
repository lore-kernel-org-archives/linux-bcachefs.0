Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C14F3A28D
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 06:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716531509; cv=none; b=RDXWV8xjpBBh39Lpn+WupSqDOwMaH9CMjPSsV0YfOjCyew7CHp3WjJpq3+jJl7PNV6HMORHzWvgHTr4YeN+VQ4s/0uLH+ddbtrkQrJxfSGjkNEdTAqihrnEZNqJPp7+VDLTc5CA/pvPJmJd7W6+eOEciTJQ13ZyXZOUMDRNtbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716531509; c=relaxed/simple;
	bh=1s1BWPfkrWwqcxTCUmiRYigcKpmViP8RKSyWEeyEcwE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FALT/Nqcfufwsqkw1ImKbyVMF36TILppDMrtz2s8z8UzCNEHAmX7malEW05wI9k3utoDKNsSkIK/w9GoZRvz03BN+SGBNzCAkQOISBywANSP8Kyiid0h3Oz9Klgc5HTx0+ZUO0Ze4f4Sequal3sVhO9IAQsLigb4a6Y2JXHs3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3737b401944so6836775ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 23 May 2024 23:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716531506; x=1717136306;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/RrFb12gbkLxmMgRGm2nf1bRqPGN6rOAZGz4/1nNHxI=;
        b=kN/bkOY7lIeVEGYwcILvTm34ak3vOsrrzdqK94c6bb/gng683GL8cQh2hs8FlN80un
         bjlsAfgsfNTPYd2+6uiQX+V4SuFqobUvUAjahveWCLBM23gfmNjURnmWHsTNsmtIr4XT
         opN0o1vH4bYMvp+Zd4tgMjSKo10zTjkFOaY7gwQ5dYkFd7WlgQ8ho8Hs0ivV39mYyTW/
         kaIxL0N3alTtLerUr/L1+8wlpZMTqqaphoA35ZjIkoH+MA82MYjA7k5ZTLC0Hm8QDWV8
         odoAY2/kSlVbuJE/GXnb9FNu5eWb73/s9pAMCYxr+bvsOvhXyya7C6iRWuPJZUHTsq07
         tclA==
X-Forwarded-Encrypted: i=1; AJvYcCXd00J/fQxoC1jB+WAco+iZzzh65TrqqBMhE+e6rrsOQuhnK8t5X5Rs8PuTWFp/zyJ1KtkazhGD0/r7F2IqAZLTLKx1xcoJ47RxY7kVAvU=
X-Gm-Message-State: AOJu0Yx8Iav5YdEvjvKIKTPtPFlx4qfy3iPUF8e8JEJuB17o7ztqXGux
	AYRA24egchPV0uyZ0U6PitGHketXJpRJ0qrwQHbbLviHVJLYbL1tJr2SyEK118R3WHyF0DhAOUX
	jK2ADbWF6drq9ENhtS3Hb6SACoLbMlPYLowq/CxgTeBoEJahMkBWB3a4=
X-Google-Smtp-Source: AGHT+IFS+VmAnmtIMK6DHu0QoepSfrJaF8oau+10m8Qn9AqBUrCc0gs7iR7OeIB1KkbiUqkpv9n77Qj+1ICnIwWrK7yRNOd9rzB6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a0e:b0:36c:2981:a85a with SMTP id
 e9e14a558f8ab-3737b2053d1mr1019895ab.0.1716531506757; Thu, 23 May 2024
 23:18:26 -0700 (PDT)
Date: Thu, 23 May 2024 23:18:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4d66d06192d22d4@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_dirent_lookup_trans
From: syzbot <syzbot+b09b7a89937134dc8f93@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12866ab2980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=b09b7a89937134dc8f93
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b09b7a89937134dc8f93@syzkaller.appspotmail.com

bcachefs (loop4): snapshots_read... done
bcachefs (loop4): journal_replay... done
bcachefs (loop4): resume_logged_ops... done
bcachefs (loop4): going read-write
bcachefs (loop4): done starting filesystem
=====================================================
BUG: KMSAN: uninit-value in dirent_is_visible fs/bcachefs/dirent.c:85 [inline]
BUG: KMSAN: uninit-value in is_visible_key fs/bcachefs/str_hash.h:159 [inline]
BUG: KMSAN: uninit-value in bch2_hash_lookup_in_snapshot fs/bcachefs/str_hash.h:177 [inline]
BUG: KMSAN: uninit-value in bch2_hash_lookup fs/bcachefs/str_hash.h:202 [inline]
BUG: KMSAN: uninit-value in bch2_dirent_lookup_trans+0x652/0xfb0 fs/bcachefs/dirent.c:482
 dirent_is_visible fs/bcachefs/dirent.c:85 [inline]
 is_visible_key fs/bcachefs/str_hash.h:159 [inline]
 bch2_hash_lookup_in_snapshot fs/bcachefs/str_hash.h:177 [inline]
 bch2_hash_lookup fs/bcachefs/str_hash.h:202 [inline]
 bch2_dirent_lookup_trans+0x652/0xfb0 fs/bcachefs/dirent.c:482
 bch2_unlink_trans+0x505/0x2190 fs/bcachefs/fs-common.c:264
 __bch2_unlink+0x3e5/0x9c0 fs/bcachefs/fs.c:529
 bch2_unlink+0x128/0x1d0 fs/bcachefs/fs.c:563
 vfs_rmdir+0x5b1/0x790 fs/namei.c:4214
 do_rmdir+0x630/0x8b0 fs/namei.c:4273
 __do_sys_rmdir fs/namei.c:4292 [inline]
 __se_sys_rmdir fs/namei.c:4290 [inline]
 __x64_sys_rmdir+0x78/0xb0 fs/namei.c:4290
 x64_sys_call+0x3a8e/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:85
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
 __do_kmalloc_node mm/slub.c:4027 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
 bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 PID: 6831 Comm: syz-executor.4 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
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
