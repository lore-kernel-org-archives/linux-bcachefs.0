Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3238528E
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 08:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750147894; cv=none; b=l2hu6uj6m+/lCvfBwY7Txn+zGfNgFhtc8FAQimplMWbYQJTGrxYEyvw/SjrbhIk2B1XmRNsOXubKPcg+WMCzUxYG48fnHVt1ZfjPtPCfwziY7OLQ7eiZrPfSt5deOHahS8N0qniguWdLYlsZ8XwTZSzpyZoRm3n2F1AaMH0oDWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750147894; c=relaxed/simple;
	bh=aJDMKLvSD4FsH9IzZ8n5o90Yxqp4mzXt9RIHIAdAX/s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=opE69qRqgZi7wh5GOLRVUROXi81IITzMHg9Myb9ZR31SK3aiNqlWprFqukTk3bH5xpav4Rel+95yi2XmKXbyo4RuACpePOOEE7eRDTYJZGGZgNLLVVYOdX2GotmPzXDYxavOPvDxfUCovsdbqh14Xsin2HEFqy6Gxt/T++hA9FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3de0f73f9e0so21630215ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 01:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750147891; x=1750752691;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYzFrCMb6kG6IH/YxFgUA1tFuW21p0F2EED3xtBQjvE=;
        b=R8fYVXSyRpUq5BCbQ2S/1DQSo3dcx2h37KWctN3jtmAZdMYY6z4zoUUU7S2wbZC7ks
         4OA1EeV4+y4EmMTRNhC0vhFY+wPaqgFYS7xhqNyjf2CtG4DAjtX079ukrMVogfLlrMUs
         5fG1izDecqBd9vulf0bRHGqEIpJZfrjbptSkGfUWxmU75JaIyXnRm7RNNZyeGhx0ls+b
         aWK+Bp0tmOctE6bKEa0hI25SkrG0MizM87YogzNw1kkd0gwKBP6FQwvaR2NbJpivaGeF
         /4w3kmDuZz41A4Py4O2RKZ4xnNZl5ctHjLcANrMFs3YWJIu8rf5PGtKUIoQCRRlqAxJq
         GaFw==
X-Forwarded-Encrypted: i=1; AJvYcCXOwYLipWNaqdHhzsGAW6IfYWT4WrvG8C69Ze2Fd3nZ/DRv/l8gY3El8P6ODuGR29WeqeyBNtnld+Z5OIQp/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfAgFMuY+/1lLuJRtWN2pmMO6Y7mH3pdl18P4s6TlhMHMSmbjK
	mZYl00KCpkh3pPfR754Y7QaaNbSJrMKKJH/lS4NW+Wogo2hwGjYycubjQUpAyzNGsb0C70AapaW
	deMyxdYf+dZuQl00hEwP0jRwMzMPyHDvLnOAEJTUrtnk0TtD/FagO/CZqdSY=
X-Google-Smtp-Source: AGHT+IGNguvuLEC/zxZL/TOlNFNAS8BFX0Utgu1krU1KL/N49/lokGZz8LJNMOEzaujIQUutWHecFwJTuUypvDV+MUPxUSoS2ZJq
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1449:b0:3dd:d7ea:ae4c with SMTP id
 e9e14a558f8ab-3de07d34057mr158515775ab.21.1750147891443; Tue, 17 Jun 2025
 01:11:31 -0700 (PDT)
Date: Tue, 17 Jun 2025 01:11:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68512333.a70a0220.395abc.0206.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in __bch2_alloc_v4_to_text
From: syzbot <syzbot+8eb51728519f6659ef7b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e04c78d86a96 Linux 6.16-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16fdc90c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db26f33438d76de9
dashboard link: https://syzkaller.appspot.com/bug?extid=8eb51728519f6659ef7b
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fdc90c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132995d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c0f064a5f302/disk-e04c78d8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b71205c143e3/vmlinux-e04c78d8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2abdee22b79e/bzImage-e04c78d8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3838d178b843/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8eb51728519f6659ef7b@syzkaller.appspotmail.com

    cached_sectors       0
    stripe               0
    stripe_redundancy    0
    io_time[READ]        1
    io_time[WRITE]       1024
    fragmentation     0
    bp_start          7
  
  incorrectly set at freespace:0:37:0 (free 0, genbits 0 should be 0), fixing
=====================================================
BUG: KMSAN: uninit-value in __bch2_alloc_v4_to_text+0x7a4/0xdf0 fs/bcachefs/alloc_background.c:355
 __bch2_alloc_v4_to_text+0x7a4/0xdf0 fs/bcachefs/alloc_background.c:355
 bch2_alloc_v4_to_text+0x181/0x1f0 fs/bcachefs/alloc_background.c:380
 bch2_val_to_text fs/bcachefs/bkey_methods.c:321 [inline]
 bch2_bkey_val_to_text+0x1e8/0x280 fs/bcachefs/bkey_methods.c:331
 bch2_check_discard_freespace_key+0xe35/0x1a30 fs/bcachefs/alloc_background.c:1436
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:272 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:420 [inline]
 bch2_bucket_alloc_trans+0x225d/0x3a40 fs/bcachefs/alloc_foreground.c:544
 bch2_bucket_alloc_set_trans+0xebb/0x1c10 fs/bcachefs/alloc_foreground.c:728
 __open_bucket_add_buckets+0x21f8/0x37b0 fs/bcachefs/alloc_foreground.c:925
 open_bucket_add_buckets+0x347/0x580 fs/bcachefs/alloc_foreground.c:957
 bch2_alloc_sectors_start_trans+0x1de1/0x3560 fs/bcachefs/alloc_foreground.c:-1
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:320 [inline]
 bch2_btree_reserve_get+0x9fd/0x2120 fs/bcachefs/btree_update_interior.c:534
 bch2_btree_update_start+0x2cf3/0x3620 fs/bcachefs/btree_update_interior.c:1289
 bch2_btree_node_rewrite+0x1cd/0x1b50 fs/bcachefs/btree_update_interior.c:2245
 bch2_btree_node_rewrite_key fs/bcachefs/btree_update_interior.c:2311 [inline]
 async_btree_node_rewrite_work+0x6e8/0x10d0 fs/bcachefs/btree_update_interior.c:2368
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3321
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3402
 kthread+0xd5c/0xf00 kernel/kthread.c:464
 ret_from_fork+0x1e0/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4154 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_noprof+0x95f/0x1310 mm/slub.c:4340
 kmalloc_noprof include/linux/slab.h:909 [inline]
 __bkey_cached_alloc fs/bcachefs/btree_key_cache.c:139 [inline]
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:162 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:231 [inline]
 btree_key_cache_fill+0x784/0x4780 fs/bcachefs/btree_key_cache.c:344
 bch2_btree_path_traverse_cached+0x10d7/0x1870 fs/bcachefs/btree_key_cache.c:399
 bch2_btree_path_traverse_one+0x6db/0x4060 fs/bcachefs/btree_iter.c:1179
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:250 [inline]
 bch2_btree_iter_peek_slot+0xd74/0x3910 fs/bcachefs/btree_iter.c:2781
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:632 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:646 [inline]
 bch2_check_discard_freespace_key+0x321/0x1a30 fs/bcachefs/alloc_background.c:1414
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:272 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:420 [inline]
 bch2_bucket_alloc_trans+0x225d/0x3a40 fs/bcachefs/alloc_foreground.c:544
 bch2_bucket_alloc_set_trans+0xebb/0x1c10 fs/bcachefs/alloc_foreground.c:728
 __open_bucket_add_buckets+0x21f8/0x37b0 fs/bcachefs/alloc_foreground.c:925
 open_bucket_add_buckets+0x347/0x580 fs/bcachefs/alloc_foreground.c:957
 bch2_alloc_sectors_start_trans+0x1de1/0x3560 fs/bcachefs/alloc_foreground.c:-1
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:320 [inline]
 bch2_btree_reserve_get+0x9fd/0x2120 fs/bcachefs/btree_update_interior.c:534
 bch2_btree_update_start+0x2cf3/0x3620 fs/bcachefs/btree_update_interior.c:1289
 bch2_btree_node_rewrite+0x1cd/0x1b50 fs/bcachefs/btree_update_interior.c:2245
 bch2_btree_node_rewrite_key fs/bcachefs/btree_update_interior.c:2311 [inline]
 async_btree_node_rewrite_work+0x6e8/0x10d0 fs/bcachefs/btree_update_interior.c:2368
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3321
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3402
 kthread+0xd5c/0xf00 kernel/kthread.c:464
 ret_from_fork+0x1e0/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

CPU: 1 UID: 0 PID: 4181 Comm: kworker/u8:21 Not tainted 6.16.0-rc2-syzkaller #0 PREEMPT(undef) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
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
