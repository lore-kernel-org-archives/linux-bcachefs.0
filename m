Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7EC4C80
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735056689; cv=none; b=qnQ2cbxzANZ7fOE3+T0Yr8Qax63zecO5Vi5Iu5JRbA6zwbq6hOCM/Nqw4JMmEROLrlq1+nnU1BQA90jKDfozu8OA8XQJ7ORqqyyWsliFvo9xqx0IyqKJXnIIBIWH/gc/Enfcw85Z+qlkjJmGkohzTMychjAOV+CeUzU2zB+z96o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735056689; c=relaxed/simple;
	bh=cb/tcygQN470im9uwFjByiISmxZORPAomtbpudoFDQ0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=t/4QLGTW6ZCn2zKcHTpBgeHyTOid8FUHHNXbYRwD7RD6O7oUcYI2a8WyuuGZULI9i7o/VfrUrnooFXiOCZgliVMtz11diBiKQDXQT4oYFKMD9ugUCCWvAKbbm3dPXAqxtEfQZaSvMYayM+RYYL4tZdMhBU2DQnmYsxa9KhLWjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7cf41b54eso95705055ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 08:11:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735056686; x=1735661486;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgfnPq9hMwcTvMYq3qfoPBki/JAcqLK7Bu/VhPbiNZI=;
        b=h/kRP1h7SiN3uK2Ju/rfah1nDB+Q50hwfcmvd9HFFU5scE4t61jPVbZjt92xzUCwT+
         9uKOjM6SYV1EPdX52RMjODs8z9mI1oRao/YVZU/prI04EUWfDR1YFvQ+h3EnPCW3Q+ok
         Ex8psC4ExKKD1Tw7wec8iQ1lCJ4dhKacRYBFoXAQSk2LoCT68qfyoZn8byAWQMIzNh1V
         1R2nii7Tin3K6K16X1RRWOhgD6CD6WBIsUabPW1SSrkRX/tuI4evONRfKqkZixOpkSUJ
         jiO8f4HtA1w/o2PuUIGd18TEP2VTsOQTBuJg+VchoV5pQ3kXtktafvU3MLXdGQ1IyRKZ
         4WdA==
X-Forwarded-Encrypted: i=1; AJvYcCVRDMEhR5lPO/DK/Q9DeNloIcjqBeRBKCV3GIysG/uh21pCgDmNPpmmroJHeH664lTUrEa5gLg164foby1ERA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz11hPk7V7i+gWhT/wHEE0MIj1I4JfCETbuITzsfDwcyUZKRSPz
	8N8sHZ2EEuEIS/Os+ToTTsCLLv1E91IPemQc4uhliQja8Y8anQlObzh7wcmmk6qJCWg9H175zOm
	yC9ilDwbJVzy5D3mhQYAGyEFU6PIq/ZAl8ZMh20hB7BoxehdcI+tVlys=
X-Google-Smtp-Source: AGHT+IFJ93Hs47gtdjneJvduJ9k/nWPTYcrN5TT8enAtHAy8YRH/qNsqQ5CoNrWwNWRcaCH2cEYOJe4y1bIvN5ymZxwDREeekwPT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc4:b0:3a7:70a4:6877 with SMTP id
 e9e14a558f8ab-3c2d25669eemr132588125ab.7.1735056686066; Tue, 24 Dec 2024
 08:11:26 -0800 (PST)
Date: Tue, 24 Dec 2024 08:11:26 -0800
In-Reply-To: <674c1f93.050a0220.48a03.0009.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676add2e.050a0220.2f3838.01e4.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_ptrs_validate
From: syzbot <syzbot+5d8a06a9e86672d9f71f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f07044dd0df0 Merge tag 'nfsd-6.13-1' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15997fe8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9048090d7bb0d06
dashboard link: https://syzkaller.appspot.com/bug?extid=5d8a06a9e86672d9f71f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13997fe8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1168c2f8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/079ebaf3a565/disk-f07044dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/489a8d4db9f1/vmlinux-f07044dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a04386952d17/bzImage-f07044dd.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/449cac567e3a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d8a06a9e86672d9f71f@syzkaller.appspotmail.com

bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations... done
bcachefs (loop0): going read-write
bcachefs (loop0): scanning for old btree nodes: min_version 0.24: unwritten_extents
=====================================================
BUG: KMSAN: uninit-value in __extent_entry_type fs/bcachefs/extents.h:54 [inline]
BUG: KMSAN: uninit-value in bch2_bkey_ptrs_validate+0x589/0x2df0 fs/bcachefs/extents.c:1239
 __extent_entry_type fs/bcachefs/extents.h:54 [inline]
 bch2_bkey_ptrs_validate+0x589/0x2df0 fs/bcachefs/extents.c:1239
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 bch2_move_btree+0xc32/0x1400 fs/bcachefs/move.c:865
 bch2_scan_old_btree_nodes+0x15f/0x580 fs/bcachefs/move.c:995
 bch2_fs_recovery+0x58b8/0x5b00 fs/bcachefs/recovery.c:974
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

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x12d5/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2095
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 bch2_move_btree+0xc32/0x1400 fs/bcachefs/move.c:865
 bch2_scan_old_btree_nodes+0x15f/0x580 fs/bcachefs/move.c:995
 bch2_fs_recovery+0x58b8/0x5b00 fs/bcachefs/recovery.c:974
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

CPU: 0 UID: 0 PID: 5789 Comm: syz-executor916 Not tainted 6.13.0-rc4-syzkaller-00004-gf07044dd0df0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
