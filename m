Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0279A93D
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 Jan 2025 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735869393; cv=none; b=K6mkabH9tAUhHapN22KVmx1bJQBr9WK6VzAAubmIoJV0dotswm0yzmEwILgTVHUqA/+SmJJXB4WNLWQ72lDaecfPeq0dWMFMZdV4cysaqqQjMcuLY8BNaLRR9w6JgYYNqWSs7XIQykGBbpvwsk01Eg9+rXZCFslFyHBFBtYdVKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735869393; c=relaxed/simple;
	bh=KYa0I+zvL5Olwd51o/XuOIywgCpwFMNQ3POdVhvS2dQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=l6kmNbKL+fxnmKoBvSw/t+nb586FJtzGsyIExc72JWRpYQDj7t7lWQw1SLZNqdojtP9rxx74qkl4BWzuk+GElb6mNin1Ql9PSwNbyWixLqtXJSd+IOkhoZ7DIoM75mLUOVir0IpeN1cnBn7i6faYc3An73sEaXO213e1Vl8djcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a812f562bbso255149515ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Jan 2025 17:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735869391; x=1736474191;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pt1JwDi9f994YyNsx2aoKsXHj4IzW6UoI2OIuqlIW68=;
        b=FS3QhSLZDAZJKzPyogcwU4KcwWUePZCni7sNYS2XDAvi3Kt3q4iNoRNeVa8NfFtb3N
         TvcsytToJHu62RUpo9bmXVc9Oa/z5agfD6bC9NbHd+uFu1SdeoaKWd3uzXWAzgRm1t9o
         tWdgBpqP3AQWhZ+0vP7ofj+67+Xd6WiDrF7LHdZ2ulKXR34CNEr8x7qcF6J0YtE3/dCc
         r1aph9RNZv5Ldj1q/kn6Kn364kiahHhD4keTj6JrTDmu/1Fq6SWOIRzsYtl6HROBDmDG
         ae7hHskiYGhDMEeKzWHnvZPr84AA4xx55sUQHgEpO7HklMKoC8bP5gubgjxgYHdK7uPh
         ejBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn/5QCVlEPPCZzYwTLGkORkPaG6qrbtbIdQIpPIOkgxdmFD/+vUNDyA+/2i1Bio9LmdEsZNAogpbzFHCnXwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuJhK23Sd5aBmWxcs8YEn/3gJmZxzPK2qwVrlP5inuxoz0EJ2A
	mC/fWHiv1dsXgO2p41geY+rgftxpgRQ0adqfbpacUpGvcUBtAAKCI8rp7be9s8cDSVZfW+E4gDy
	C2wW6wUEhIwDw/B3ESrtaToFeBzf3MHejS2WB+nBx7Mxyqd9lawqYSlQ=
X-Google-Smtp-Source: AGHT+IGFnBpy5YMuCy8RhHgRVvxy1K/fXuGSl/K20kBGrIGDx/u3rhHLOSWWi4rtyl065QW9O/4lKnHLS1ssm1gqa1E4SeS8/rGG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e8:b0:3a7:78a8:1fb4 with SMTP id
 e9e14a558f8ab-3c2d2f47732mr355544915ab.13.1735869390991; Thu, 02 Jan 2025
 17:56:30 -0800 (PST)
Date: Thu, 02 Jan 2025 17:56:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677743ce.050a0220.178762.0036.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_trans_start_alloc_update_noupdate
From: syzbot <syzbot+3304ecaea706d3a6524c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4099a71718b0 Merge tag 'sched-urgent-2024-12-29' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=103e70b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9048090d7bb0d06
dashboard link: https://syzkaller.appspot.com/bug?extid=3304ecaea706d3a6524c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62835b60de83/disk-4099a717.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9262b999e6be/vmlinux-4099a717.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3fc8cec4d596/bzImage-4099a717.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3304ecaea706d3a6524c@syzkaller.appspotmail.com

bcachefs (loop3): starting version 1.7: mi_btree_bitmap opts=errors=continue,metadata_checksum=none,data_checksum=none,compression=lz4,nojournal_transaction_names
bcachefs (loop3): initializing new filesystem
bcachefs (loop3): going read-write
bcachefs (loop3): marking superblocks
=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_to_v4_mut_inlined fs/bcachefs/alloc_background.c:447 [inline]
BUG: KMSAN: uninit-value in bch2_trans_start_alloc_update_noupdate+0x61b/0x12f0 fs/bcachefs/alloc_background.c:472
 bch2_alloc_to_v4_mut_inlined fs/bcachefs/alloc_background.c:447 [inline]
 bch2_trans_start_alloc_update_noupdate+0x61b/0x12f0 fs/bcachefs/alloc_background.c:472
 __bch2_trans_mark_metadata_bucket fs/bcachefs/buckets.c:958 [inline]
 bch2_trans_mark_metadata_bucket+0x2e6/0x2430 fs/bcachefs/buckets.c:1048
 __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1120 [inline]
 bch2_trans_mark_dev_sb+0xcf7/0x10e0 fs/bcachefs/buckets.c:1133
 bch2_trans_mark_dev_sbs_flags+0x3e5/0x9f0 fs/bcachefs/buckets.c:1143
 bch2_trans_mark_dev_sbs+0x32/0x40 fs/bcachefs/buckets.c:1155
 bch2_fs_initialize+0x19bd/0x35d0 fs/bcachefs/recovery.c:1074
 bch2_fs_start+0x77d/0xbd0 fs/bcachefs/super.c:1038
 bch2_fs_get_tree+0x13ea/0x22d0 fs/bcachefs/fs.c:2170
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4034
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:513 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:259 [inline]
 btree_key_cache_fill+0x13da/0x3d60 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x988/0xe20 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x749/0x47b0 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_slot+0x10b7/0x3950 fs/bcachefs/btree_iter.c:2629
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:575 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:589 [inline]
 bch2_trans_start_alloc_update_noupdate+0x390/0x12f0 fs/bcachefs/alloc_background.c:464
 __bch2_trans_mark_metadata_bucket fs/bcachefs/buckets.c:958 [inline]
 bch2_trans_mark_metadata_bucket+0x2e6/0x2430 fs/bcachefs/buckets.c:1048
 __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1120 [inline]
 bch2_trans_mark_dev_sb+0xcf7/0x10e0 fs/bcachefs/buckets.c:1133
 bch2_trans_mark_dev_sbs_flags+0x3e5/0x9f0 fs/bcachefs/buckets.c:1143
 bch2_trans_mark_dev_sbs+0x32/0x40 fs/bcachefs/buckets.c:1155
 bch2_fs_initialize+0x19bd/0x35d0 fs/bcachefs/recovery.c:1074
 bch2_fs_start+0x77d/0xbd0 fs/bcachefs/super.c:1038
 bch2_fs_get_tree+0x13ea/0x22d0 fs/bcachefs/fs.c:2170
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4034
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_node_data_alloc fs/bcachefs/btree_cache.c:153 [inline]
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x4e4/0xb50 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:917 [inline]
 bch2_fs_open+0x4d3a/0x5b40 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x983/0x22d0 fs/bcachefs/fs.c:2157
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4034
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 10842 Comm: syz.3.1345 Not tainted 6.13.0-rc4-syzkaller-00110-g4099a71718b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
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
