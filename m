Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BABD1B253B
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Sep 2024 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725892475; cv=none; b=XKMy/9KM1GHicgqQKurcmB+5o+G9mi8gZREd5fPtN17LiINsJLu4so7JbTrTtUO7eo0zSonHzAhuLOegdCk2QOYHKyUG9voen3IwO9Nxkha8KptvXA7goQbdD9Nrk7DMKcS0bWOhi/fCPZJ5E5aNYg7fwv4E/bolLTmRJs91vJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725892475; c=relaxed/simple;
	bh=bFpS5MoSFb6+0B+JZ5b9VE29/gt70nKWHJs3CSIhVvk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Qs4QcgYTXsBLbjb5+YOkuVVqJ9Vs5LEQJBDmof+Zu2rpi0FVnONe38enyrYuroFU9egGNqcJlL4td2A9FStrWUwQxgd1F4zCf5rBL98gVDGpm+i2esUSf11Aj+W/IJWUde6dM6YU5nuqnYWDALXVrUytl7AT6HtGBgPwCm19bgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82aac437083so409292839f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 09 Sep 2024 07:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725892473; x=1726497273;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xqAxhxMvU5qWQ5DVLIxcK8FtooROkIakO4zS/L+n9HU=;
        b=wGkLebtSAE5LORbOsbbaKDZIrXN1QFxSbGYCwiZC1XmK9kf0qGnADOj+qXLrM2UU1S
         exxb5QII3ZcfPCSrQlQ0Bll9E/T6HWR4D5zZYk4Jl7jN4V39KvalxnT8suZrPXWRpJI1
         naPzkn8Jexnco2K0aIoY6z9A0yvvi2ke3VIwc1etW2LwC+oOJ4ej7x2aKXqFUtt8dmT6
         Z8Mo4CJStqmj/N90CCNOATJjrl68nT6PUi17hIJCH2MyIUFhG9CaLYcUAtxf8VqPokB7
         sAs8o8HodgDIrlnKSqYpfEPCSmYc9D6Yq07Hxv5y9A8JAmEhgE2SVwMfexZfWhAo06ir
         AskQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVi+SvZuuwfJkapCHPl6SYUfoV4LUhiaTbaBk4/C9IUMfLmbC/mt+MXLjrhaXls5MGdrSNXzCnL+wCyAXOUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs0l+FwgrvD/xZlKHCI90wb+4i65fC59CKEBNaa1lHvOOHOem0
	ZdZpS/3f52WIzj13VEacokhMFdJ4AP5R1O+tKbZI42BbfBA8ytiJUc1JtQRFx4CGdgy6yaO+Cbu
	RK1PO3z8rBe0IErdRYS7fWD2HtGIcREjX4w5L1ziNqauKO/UatsviwQY=
X-Google-Smtp-Source: AGHT+IFLFIAL9noMLiidJYbTblBUM8EpDv5b4bH9XUgVNZ3sBsJDIpKmgn+uUzXIrKwfwrzgF0t4WGYsiofXNNEumuO74KcTIZZK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19cb:b0:3a0:4a91:2263 with SMTP id
 e9e14a558f8ab-3a04f08baefmr124741435ab.13.1725892473231; Mon, 09 Sep 2024
 07:34:33 -0700 (PDT)
Date: Mon, 09 Sep 2024 07:34:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9af510621b0a773@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_cmp_packed_inlined
From: syzbot <syzbot+6f655a60d3244d0c6718@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d1f2d51b711a Merge tag 'clk-fixes-for-linus' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11671f29980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de85d75807a205cd
dashboard link: https://syzkaller.appspot.com/bug?extid=6f655a60d3244d0c6718
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f3589f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100b589f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/df667fbbb2c1/disk-d1f2d51b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1574a134d7c4/vmlinux-d1f2d51b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a977c1daccb8/bzImage-d1f2d51b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/db88b8b6831b/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f655a60d3244d0c6718@syzkaller.appspotmail.com

bucket 0:127 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:127 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
=====================================================
BUG: KMSAN: uninit-value in bch2_bkey_cmp_packed_inlined+0x8d0/0xd50 fs/bcachefs/bkey_cmp.h:115
 bch2_bkey_cmp_packed_inlined+0x8d0/0xd50 fs/bcachefs/bkey_cmp.h:115
 bch2_sort_keys_keep_unwritten_whiteouts+0xf94/0x19d0 fs/bcachefs/bkey_sort.c:184
 __bch2_btree_node_write+0x3ae7/0x6830 fs/bcachefs/btree_io.c:2096
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2285
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:261
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x156/0x3f0 fs/bcachefs/journal_reclaim.c:821
 bch2_journal_flush_pins+0x1a1/0x3b0 fs/bcachefs/journal_reclaim.c:851
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x4923/0x4d20 fs/bcachefs/recovery.c:383
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:183 [inline]
 bch2_run_recovery_passes+0x400/0xec0 fs/bcachefs/recovery_passes.c:230
 bch2_fs_recovery+0x42d2/0x5c60 fs/bcachefs/recovery.c:859
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x13e8/0x22d0 fs/bcachefs/fs.c:1946
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1800
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3472
 path_mount+0x742/0x1f10 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:3997
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3997
 x64_sys_call+0x255a/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4117
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4134
 __do_kmalloc_node mm/slub.c:4150 [inline]
 __kmalloc_node_noprof+0x9d6/0xf50 mm/slub.c:4168
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 bch2_btree_node_read_done+0x52a9/0x7790 fs/bcachefs/btree_io.c:1192
 btree_node_read_work+0x973/0x1960 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2e6b/0x36e0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0xa81/0x13f0 fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x51c/0x1250 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x422c/0x5c60 fs/bcachefs/recovery.c:851
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x13e8/0x22d0 fs/bcachefs/fs.c:1946
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1800
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3472
 path_mount+0x742/0x1f10 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:3997
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3997
 x64_sys_call+0x255a/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5189 Comm: syz-executor350 Not tainted 6.11.0-rc6-syzkaller-00326-gd1f2d51b711a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
=====================================================


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
