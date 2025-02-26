Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5A222591
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Feb 2025 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740582868; cv=none; b=W9EBWpYYMZIhbJGqg/rp3FaGiRnn22+B0d2sbsddVG/1MIdl81YqiClkLmYyTHBO02/YmFfV4hQ5hilZl6dBOUGRSA2rErAIZL5OUdZ1P77iyj64SnTvvlhooESCgdijffNEefJF98+v1+l4nZGtxg0OaFz9Nt376CPb9na8TFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740582868; c=relaxed/simple;
	bh=ZSjf+72l4ULpS9+WjRMnaULwTrJ3p4O6jvlFCqeY2GA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QSjNEPn/P8uwszxWVs1izs8Q10budc/msWkbs4rkJIs/lLDLAd5QP8dFL0o6VYFdkXDi/QeSLtt4cobZTOGEzWFj34syOnKrZwU4R7q4zxT6NA4jBkHS0ZoUjKJV90kzYtTK06ydJPtflgl2wcXULHm1AUXnUtEgh/cnz0z7jYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d2b6d933a5so52965005ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Feb 2025 07:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740582866; x=1741187666;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JjGZhgtmajH8ksi81iyDChdKn7BYRAvuR2AIZl1oWx0=;
        b=lbc0Dy/sEEF4NoUTMlUVmBlKKYsFYQcUPq7vr4fKXjQIADIR3CZHQP3pphTFhwA0bM
         abcMeSZQ9XaO+1RfIzqdrWvDoApqcTb1gp32Vo0WISl0nhgUkywewtIXgHbeJJlsYP8l
         JU6uDnFuVN/3JAxbcUczmRf4L4oTPnlTsSVQSJ4TaUG4VyFXr9TY3L7XH9HbYCECIfip
         GdK0yyfUHupsB2dRltZU4HWnMUhnDLZYx8tlnLcc3PT+ux2c89VwhlQ/3jNNDR4Sm5o8
         buPo9yKYRRlfgbmEo/oMv4qI3moTZUGbdKl2UsVWaUATDmlHCYzL7NyeuLZLER6HfeVl
         Lpww==
X-Forwarded-Encrypted: i=1; AJvYcCUZ71UEMBUJu9dlvibnoLdURdFp1XpGdq/K+dFfvjH7Bo9HAQJIYLF/sY0GLmvtcIiRbPktKJJiy93JdhFGOw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyld8p6XObwi1nwGkONnV8zvfBZJlLUHHU1pf9rUZTs81gQzg8s
	aw5WwoFEpsIznnCtik5XX92TskJ05+5ray1+C6m/d02Mra1aptLRpDFSEmhvAQgEbUQbYDgEcgs
	1xw9YBN2BerpdAEINSpnaIgxrVmHeTnNF0cAL8+KRcCkGUiKD+TQpc6M=
X-Google-Smtp-Source: AGHT+IHduX2kYfl0g+s4hLq/1qwTItImgVCln4vA5u60yhrBAPuDUDZAay9r5Fob/ntyIr7se55x7uYvP5na6H3Ra1vrBhB+ERwJ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4813:b0:3d3:d994:e92e with SMTP id
 e9e14a558f8ab-3d3d994ea94mr9224315ab.17.1740582866377; Wed, 26 Feb 2025
 07:14:26 -0800 (PST)
Date: Wed, 26 Feb 2025 07:14:26 -0800
In-Reply-To: <674c2f0c.050a0220.ad585.0034.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bf2fd2.050a0220.1ebef.0023.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_get
From: syzbot <syzbot+2b2046c73fcb7e6a0e4e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ac9c34d1e45a Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17a4f7a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d66f6f82ee090382
dashboard link: https://syzkaller.appspot.com/bug?extid=2b2046c73fcb7e6a0e4e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11da9c98580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177a003f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c756243ff2fa/disk-ac9c34d1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/47bd399bb287/vmlinux-ac9c34d1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6c5db9fcba1/bzImage-ac9c34d1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/039e65b899b2/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b2046c73fcb7e6a0e4e@syzkaller.appspotmail.com

bucket 0:127 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:127 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
=====================================================
BUG: KMSAN: uninit-value in bch2_btree_node_get+0x5ed/0x1970 fs/bcachefs/btree_cache.c:1180
 bch2_btree_node_get+0x5ed/0x1970 fs/bcachefs/btree_cache.c:1180
 btree_path_down fs/bcachefs/btree_iter.c:976 [inline]
 bch2_btree_path_traverse_one+0x283d/0x4790 fs/bcachefs/btree_iter.c:1202
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:249 [inline]
 bch2_btree_iter_traverse+0xbb8/0x1110 fs/bcachefs/btree_iter.c:1913
 bch2_journal_replay_key+0x28a/0x13f0 fs/bcachefs/recovery.c:264
 bch2_journal_replay+0x301d/0x4e20 fs/bcachefs/recovery.c:373
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:226 [inline]
 bch2_run_recovery_passes+0x5a2/0x1160 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x489c/0x6230 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x7ca/0xc20 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x1564/0x24e0 fs/bcachefs/fs.c:2203
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

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:416 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:506 [inline]
 bch2_bkey_buf_reassemble fs/bcachefs/bkey_buf.h:28 [inline]
 btree_node_iter_and_journal_peek+0x889/0x2560 fs/bcachefs/btree_iter.c:918
 btree_path_down fs/bcachefs/btree_iter.c:947 [inline]
 bch2_btree_path_traverse_one+0x2131/0x4790 fs/bcachefs/btree_iter.c:1202
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:249 [inline]
 bch2_btree_iter_traverse+0xbb8/0x1110 fs/bcachefs/btree_iter.c:1913
 bch2_journal_replay_key+0x28a/0x13f0 fs/bcachefs/recovery.c:264
 bch2_journal_replay+0x301d/0x4e20 fs/bcachefs/recovery.c:373
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:226 [inline]
 bch2_run_recovery_passes+0x5a2/0x1160 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x489c/0x6230 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x7ca/0xc20 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x1564/0x24e0 fs/bcachefs/fs.c:2203
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

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4249
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4266
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4300
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:662
 btree_node_data_alloc fs/bcachefs/btree_cache.c:156 [inline]
 bch2_btree_node_mem_alloc+0xa72/0x2ee0 fs/bcachefs/btree_cache.c:834
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 [inline]
 bch2_btree_reserve_get+0x37f/0x2290 fs/bcachefs/btree_update_interior.c:532
 bch2_btree_update_start+0x2b0e/0x2d60 fs/bcachefs/btree_update_interior.c:1251
 bch2_btree_split_leaf+0x120/0xc90 fs/bcachefs/btree_update_interior.c:1853
 bch2_trans_commit_error+0x1c0/0x1d60 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x1d5f/0xd310 fs/bcachefs/btree_trans_commit.c:1089
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 bch2_journal_replay+0x3125/0x4e20 fs/bcachefs/recovery.c:373
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:226 [inline]
 bch2_run_recovery_passes+0x5a2/0x1160 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x489c/0x6230 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x7ca/0xc20 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x1564/0x24e0 fs/bcachefs/fs.c:2203
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

CPU: 0 UID: 0 PID: 5784 Comm: syz-executor148 Not tainted 6.14.0-rc4-syzkaller-00052-gac9c34d1e45a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
