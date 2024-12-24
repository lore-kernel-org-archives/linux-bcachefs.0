Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1430192B69
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735051346; cv=none; b=u9/CXMRTmRRjQSka4YqyMd1t46boM6K/D1HK0z4PJ6RtdBF9QQnji/Oy0tNr76JVmZVFQbu9rSnFRrjoBSSKBp1ewS66Ec4F4ICqL45NPM4VsJoX5rwaC6u7ANtVmmNao9J6kbh0QjsYo66D7C4TsqR/R/vHzRwKcp/CfLi9BS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735051346; c=relaxed/simple;
	bh=cc2YHK0yxN6G6dmlXxHTZKq9YCuV9y/SzJN3UG1nwKk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YOttJmT+GOmCSCsG774cCMfYgfG7zGCjBciGGCmWZYurYqRlSh0HAmOu5TT32fIduKUApem8KeImk2kNlVUB6vFiDo8BtD7qapgOW+Fl+vIdkuQqai+1IqZAacP6InkYEfVRqFV1AT1z5OECvYipZwrPTmgl1RFEsH9Nrx2alS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3abe7375ba6so95888985ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 06:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735051344; x=1735656144;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZCYPBMTCzj+2CU/NSxrL9u9zq5s+BZ99kx006fy/U64=;
        b=WrwgQjoL56S7Ivl1a7A1S7ZfvEb3B0c5+5bymSDB56qPvg8zIIkeYWQ7QYAjO5n6Qn
         IKoBzBC55pPwlGMrTtYfGq0uJzfjL5YLMEPkmvoMeijzSrcOmGKs8FCuTEC7nUeK+Xt2
         k54Byy81d2zHuRwlRSXhElE44nKhwclyIS+4TFFi1FOLaaY3T7bl8nMUt2eIvJTHxwyB
         xDdWkrK+naPlZzIn1cHe8mH8xfwPS2RnANAFHKrVCYJpnoL00wxgJ1qvYVKEs7B3MTkt
         dZs5EO8Bszn/TM91RbiY8kZfsyPG1uHpJObcT0GN57Khn0BV2+qU6oOE7G+xHNWNaTt7
         LxDw==
X-Forwarded-Encrypted: i=1; AJvYcCXW6JVVAWnFasttMb6g9+jQcRC7a5eC1LH/Mt8cfMl11vdZabdFTlsmKbh1WL55qct8nvbivDrbuV26pnzlLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyjhgbEiWGfQSwraK29QY7grcXis9S72p3CdVOl9vDvzpDy0OV
	4iYlnCIq3gt2pBDPOU0kl5+zpP0g24PML6FmspvimS7Zq/lErmP9PGIZv2S5H8QNCjaZbXxZtcf
	sOe2nWry7kRJua6UfzTwEH4HK0to5e89t4XigRy7E3FnxWCuQjHcQTic=
X-Google-Smtp-Source: AGHT+IGLLrirYgw/irC3GyTktsuxkp+/kOhSbKOzKWc9UZp+e/nw1MjPcW5wJrYaKSRLUeXZ4D6wAmvVAtvifprDZSVlw6hiMFFl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a21:b0:3a7:8208:b843 with SMTP id
 e9e14a558f8ab-3c2d5a27dccmr156803335ab.23.1735051343824; Tue, 24 Dec 2024
 06:42:23 -0800 (PST)
Date: Tue, 24 Dec 2024 06:42:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676ac84f.050a0220.226966.005a.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in __bch2_bkey_cmp_left_packed
From: syzbot <syzbot+ed0bdc5b29ea2e281a83@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8faabc041a00 Merge tag 'net-6.13-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10099cf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=caeefc00e8b4dc9f
dashboard link: https://syzkaller.appspot.com/bug?extid=ed0bdc5b29ea2e281a83
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131100c4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3426cd3c012/disk-8faabc04.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c05067e0c579/vmlinux-8faabc04.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4788f870d98f/bzImage-8faabc04.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/71ea5ea439f5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed0bdc5b29ea2e281a83@syzkaller.appspotmail.com

 done
bcachefs (loop3): going read-write
bcachefs (loop3): journal_replay...
=====================================================
BUG: KMSAN: uninit-value in packed_to_bkey_c fs/bcachefs/bkey.h:251 [inline]
BUG: KMSAN: uninit-value in __bch2_bkey_cmp_left_packed+0x256/0x770 fs/bcachefs/bkey.c:1046
 packed_to_bkey_c fs/bcachefs/bkey.h:251 [inline]
 __bch2_bkey_cmp_left_packed+0x256/0x770 fs/bcachefs/bkey.c:1046
 bkey_cmp_left_packed fs/bcachefs/bkey.h:88 [inline]
 bkey_iter_pos_cmp fs/bcachefs/bset.h:391 [inline]
 btree_path_advance_to_pos fs/bcachefs/btree_iter.c:599 [inline]
 __bch2_btree_path_set_pos+0x1a9b/0x1ec0 fs/bcachefs/btree_iter.c:1301
 bch2_btree_path_set_pos fs/bcachefs/btree_iter.h:229 [inline]
 bch2_btree_iter_traverse+0x8d0/0x1020 fs/bcachefs/btree_iter.c:1875
 wb_flush_one fs/bcachefs/btree_write_buffer.c:149 [inline]
 bch2_btree_write_buffer_flush_locked+0x28d3/0x7090 fs/bcachefs/btree_write_buffer.c:379
 btree_write_buffer_flush_seq+0x2ec7/0x30b0 fs/bcachefs/btree_write_buffer.c:517
 bch2_btree_write_buffer_journal_flush+0x103/0x1f0 fs/bcachefs/btree_write_buffer.c:533
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0xe1/0x3f0 fs/bcachefs/journal_reclaim.c:819
 bch2_journal_flush_pins+0x2a9/0x3b0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x4937/0x4d30 fs/bcachefs/recovery.c:383
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:191 [inline]
 bch2_run_recovery_passes+0xaf9/0xf80 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x447b/0x5b00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1037
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

CPU: 0 UID: 0 PID: 6246 Comm: syz.3.37 Not tainted 6.13.0-rc3-syzkaller-00136-g8faabc041a00 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
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
