Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CCA14431B
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 12:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732711288; cv=none; b=iYsFLo6rVifxPI9VK2rxIt5CtJab2IRzVi3T7LpOXA/cRfdRJ77YZboZ0MuONYw5e7yoaRlhKIVwBuahWrwfbe2dsJrANTt6eqPP9YX9o24aoPeAwbJU4ol7Em0hu8AgF3/fZXvYQVOjuH/Go/jAddCxyQ1yfrS414pRKSUCt+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732711288; c=relaxed/simple;
	bh=ltxwsYKMLXNAFQlvvwNcEgin+pkHdw7KaOfFBELzKFE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kazX+5jSxxCmGi6rKb6z+HE1qMp1Ti1Rf+JeFXXCHWPs57+Sd+9ILnzQ6XQuF3/fLFc3juTBWDoSiApwrfHnOqd6A9a10CGtkkMmOaOCGhw/xpgu4cUnDgFrtVAo23g8HmqE9mAyaw8JLH1utS3h2yX2Oe83Ejgmh4E9evgLNh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-843e5314c99so163948839f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 04:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732711286; x=1733316086;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQYS0cG3LtS9IuwQPAFcgh+J9lnXsoBqjCXOc+R9V6A=;
        b=tWWSUJ2bRsEnhS5j3rgYU+VryUrDDny+hvjLPL1N/9jg154bStpfOfDVmKOCerlmNh
         vUkz5jAOBt4Vrcrzm+UqfB6vDtsv4K5Aa7kPa17CeNmdS3MxqzljqmI88SzIBSatMEZR
         ahN8T8L07S/rEUmrW8EMvlX2z6KIKL1NEPlKAJuNpt2wi/fQif4xYHU1tVURB/Y1p/B/
         5qYAkayaaX/ydvWO3mzPYsJuMgc/+iWFdtF2U/mKsx82xEykCLWc7FHwLjStTAnQPVbj
         atCctnnD+zR2fmilVISV8Nicj4FUvq/pd3tgeI3POrVocZq2TlHWYtys+Kc2oCoReY9D
         ycmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwLEjPeHKLC0Cf8Jlitcc8R/y5Y5BqxqxTjQkHm+8AAjKYw1lioVDOQ7wdANmXfmyCeoMnkG72ze8W3l0NkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkCOeQ8i3s04Kf4mZBkD0mZAUndpREPYHvDUDaORL+Ckq0dpMM
	UexNbXyocw4hpG7pLRJZFE7MT4HtLkVW6YyUsFm9pAOBKSCdd+qbmeTu95lD9auprpw5S16Ol9s
	U9Z2oi5Kg7ezUcQz53/jAXe9vKa/d5ROdjB5J/7qg5ciHfXsDw157F9k=
X-Google-Smtp-Source: AGHT+IFP+zsqRvs3mQ9WuZzJ49Roy5sZs1CSK+VUqduX53qWfGd0Scup1Ob/oGPMSQYJ4BCm6+PyHYVb6kXwcwW8MIC7WRPCX9GS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:3a7:70a4:6872 with SMTP id
 e9e14a558f8ab-3a7c555f0a9mr30553605ab.9.1732711285799; Wed, 27 Nov 2024
 04:41:25 -0800 (PST)
Date: Wed, 27 Nov 2024 04:41:25 -0800
In-Reply-To: <6739af3b.050a0220.87769.0007.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67471375.050a0220.21d33d.0024.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_alloc_v4_validate
 (2)
From: syzbot <syzbot+8dd95f470e7cd0ff4b66@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7eef7e306d3c Merge tag 'for-6.13/dm-changes' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1346e1e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5486b9d7cc64830
dashboard link: https://syzkaller.appspot.com/bug?extid=8dd95f470e7cd0ff4b66
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1353fff7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151643c0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2331c33a914b/disk-7eef7e30.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8e50ed828391/vmlinux-7eef7e30.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a942e199e781/bzImage-7eef7e30.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/495fbbf0d709/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8dd95f470e7cd0ff4b66@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_v4_validate+0x739/0x19a0 fs/bcachefs/alloc_background.c:249
 bch2_alloc_v4_validate+0x739/0x19a0 fs/bcachefs/alloc_background.c:249
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 bch2_alloc_v4_validate+0x27f/0x19a0 fs/bcachefs/alloc_background.c:247
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x16af/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2095
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_repack+0xb74/0x1040 fs/bcachefs/bkey_sort.c:140
 bch2_btree_sort_into+0x212/0x620 fs/bcachefs/btree_io.c:399
 bch2_btree_node_alloc_replacement+0xa3d/0xb60 fs/bcachefs/btree_update_interior.c:469
 bch2_btree_node_rewrite+0x2d4/0x1930 fs/bcachefs/btree_update_interior.c:2155
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_prep_for_write+0x494/0x720 fs/bcachefs/btree_trans_commit.c:93
 bch2_trans_lock_write+0x7ef/0xc00 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x31c4/0xd190 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_journal_replay+0x2e3d/0x4d30 fs/bcachefs/recovery.c:317
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

CPU: 1 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.12.0-syzkaller-09567-g7eef7e306d3c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
