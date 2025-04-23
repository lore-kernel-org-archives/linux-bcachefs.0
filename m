Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C7A27F4D9;
	Wed, 23 Apr 2025 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745426248; cv=none; b=IWHvFPXV32qTpgz0H11XnwS7Y6UqLwz1Jpnac1y1iAP1+1HGACATYys6XjZeDy9epGDqFqxp6Jk3t9Da5jxdtbaYYxtEyM5YHHkg6VR8JoUYMZH7xv/mbwvVC2OeOP9qNQzSZyr9/BLyYJJwmwggJFtsFLB+qylkwX6GjNuludQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745426248; c=relaxed/simple;
	bh=MzRjrb8d940+qeWbY1aC95yDkgC+f4+azLUdJNM0BVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2fgkLJ0IoZUoiKDBM0Ss7JUtuIYEcaRh7nlqnI+3+GUrgh/+1Yy14NsVPPUkjk9A75doxeNq35WVZsQmcll5+rFDZ8/biAoFhdRJTzmh3iTWct3HjRglnogGNJ1UY5er8w/6d0M6sruR0fQaldXTTD2IyDLfAZ24aT1Hou7jyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDGHg60h; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDGHg60h"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22435603572so720145ad.1;
        Wed, 23 Apr 2025 09:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745426246; x=1746031046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xox8BeQm7Kx/G9Wei7lGV+9+maCEi+mrlIS4FPZetcY=;
        b=fDGHg60hPV09NwiLNu/KtmdCDGpMLFBG62l0MyTML8Kd2KG/OfSi/AWOtA3DNUhjLE
         SgOj4aUFLU5WeVBL+r4cFQfMFQZnTZjiZvNNXnBZORiuppwi/iKcIE8QkDzJxvHYUWSj
         1U1VpuWla6h813LKnEvuUggGll70GvE9+cOkJBWnvttTBSKarel7MU8TizRuaCaVXxvQ
         lrPftnP9J4mo77u4cFLu3juJgEwt6aZnr/r7p5DU7bZ8V+WqR5Sae3tYzS+TzlIVb/pY
         6cWzl5tPW0Smatb74Uys70gZybdJ1tPMD6sYe6QGCxaEBRXaltHtg9eCpDbHb0d+90+m
         5tWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745426246; x=1746031046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xox8BeQm7Kx/G9Wei7lGV+9+maCEi+mrlIS4FPZetcY=;
        b=gfGbSB/aS2DkfNjaG9h44np5OYPO7Olt1NeC+Dgr+RLrcPXBFGSqG/v37Sm5Xt9a6J
         MBxgrpdzZ1twsOWUmmtj3x5l3nmRxLNiJvRyfaYwdx0qyh0KyX/jGXu/97Lu30TelpUx
         C4OFc/iurygw+yx78OqGdx1cZzr6+4YsJZYFM4geKJ17YUJr42r8dGMmbvhmygTRRa68
         vv+NKPXyUhxhDu7XSr9FZPsOIgF1xlWmFWKVbH1cNj6XhIHReSRyVW1BPmatbwH1Nlrn
         DoRP0agIRRL47I7Jq/Smttn8JLm+kEjWgvzthcW6J8G9DjxjgNzn9zD9IvZrODlu23Ig
         DVUw==
X-Forwarded-Encrypted: i=1; AJvYcCUmUqg1lzqL1mtbvPQANbFrkMv3g1Tsfmy9swOeaFldWqDf3Z4tX7gqY3ov4psws0ILmkyyJKLinBZBO1P+@vger.kernel.org, AJvYcCWdc0Ulq67yUfj3D0HcoNJ02KD1ne/niCWZ14AXWBqtLXgA3QyzinUaXzKQvaWW2j9kzxO51nIZQd0fJjzyqA==@vger.kernel.org, AJvYcCXBM/wlDTWvHogHwfr6dHSyyeoq6LPRt3QLFKYps6KAFCB3RGNZCZjljul6SjATV12JaPxRV7NOTQkp9JLE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Lr+xYvoms2mvvZTTD0w0Uj1IsVTR4ZvRk/yzb1RY7mJNW1wp
	8J+xUObeJZ1iRFqU5ph6PhUwxA3at2sWfmyNTCNMFmmbojS/HWzg
X-Gm-Gg: ASbGncvYk0oc1yBi6yjMexUhG8CWgqDPpKp1rsehTHt5xga5vaDOQyD5Hyw3bcWZNzC
	gII5sKhG6yqbQXQNpmXC8CCV3ZT7p/6JQmmx0oosu2IersD0xjyQK9PThWbSlw2rjyi3ZDnlACu
	0rQ+1ka38pbEcUQ3NrHAQIzCO0aPrZCAl+AY5ALHADfR92iqmhuIuSRMnNnFLhy78JQrTMNqQ+s
	uUM1K3W+3sxQ3GYPFhnDZAaQRvfRscMDPApGmSxqPzWHWl5hW/6SClsV47YtmjJOQ9hCU1yPmGK
	X9pRhcaLHsBN6inFoYR8b22MLpMdw+tnfK2DfIIlNy/aorKqKLPLVGzNsYM18YF4zE9Ktgg=
X-Google-Smtp-Source: AGHT+IFIWlrnLy1iSgnthvmblbo//BwO4GthNuy0ZXRjs7CSIzp6yPk4AWDJPUZrMIfpM3lihQ5Xug==
X-Received: by 2002:a17:90b:544c:b0:2fe:d766:ad8e with SMTP id 98e67ed59e1d1-3087bb39781mr29259991a91.4.1745426245823;
        Wed, 23 Apr 2025 09:37:25 -0700 (PDT)
Received: from vaxr-ASUSPRO-D840MB-M840MB.. ([2001:288:7001:2703:8f0b:7fe7:7ec6:bfa2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309dfa25e1esm2052136a91.21.2025.04.23.09.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:37:25 -0700 (PDT)
From: I Hsin Cheng <richard120310@gmail.com>
To: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>
Subject: [PATCH] bcachefs: Fix unit-value within btree_bounce_alloc()
Date: Thu, 24 Apr 2025 00:37:18 +0800
Message-ID: <20250423163718.194316-1-richard120310@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000736bd406151001d7@google.com>
References: <000000000000736bd406151001d7@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use "kvzalloc()" instead of "kvmalloc()" in btree_bounce_alloc() to
prevent uninit-value issue.

Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
Fixes: cb6fc943b650 ("bcachefs: kill kvpmalloc()")
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
---
syzbot reported an uninit-value issue. [1]

Though the uninit value was detected in the context of crc32_body(), the
memory was actually allocated in "btree_bounce_alloc()". Use
"kvzalloc()" to allocate the memory can solve the issue, and I've tested
against syzbot. [2]

If there're any further tests needed to be performed, please let me
know. I'll be more than happy to assist you with that, thanks !

[1]:
BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:110 [inline]
BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
BUG: KMSAN: uninit-value in __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
 crc32_body lib/crc32.c:110 [inline]
 crc32_le_generic lib/crc32.c:179 [inline]
 __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
 chksum_update+0x5b/0xd0 crypto/crc32c_generic.c:88
 crypto_shash_update+0x79/0xa0 crypto/shash.c:52
 crc32c+0xba/0x170 lib/libcrc32c.c:47
 bch2_checksum_update+0x106/0x1d0 fs/bcachefs/checksum.c:83
 bch2_checksum+0x3c5/0x7c0 fs/bcachefs/checksum.c:216
 __bch2_btree_node_write+0x528c/0x67c0 fs/bcachefs/btree_io.c:2151
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:46 [inline]
 bch2_sort_keys+0x1b4d/0x2cb0 fs/bcachefs/bkey_sort.c:194
 __bch2_btree_node_write+0x3acd/0x67c0 fs/bcachefs/btree_io.c:2100
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

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

[2]:
https://lore.kernel.org/all/000000000000736bd406151001d7@google.com/T/#m748384a36239a7f66e63cfde949e3db6bf14d5c6

syzbot reply me with:
Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
Tested-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com

Tested on:

commit:         614da38e Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=10be763f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49342144b6a907af
dashboard link: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15b99a6f980000

Note: testing is done by a robot and is best-effort only.

Best regards,
I Hsin Cheng
---
 fs/bcachefs/btree_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index debb0edc3455..dc00c5273ffe 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -115,7 +115,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_t size,
 	BUG_ON(size > c->opts.btree_node_size);
 
 	*used_mempool = false;
-	p = kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
+	p = kvzalloc(size, __GFP_NOWARN|GFP_NOWAIT);
 	if (!p) {
 		*used_mempool = true;
 		p = mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
-- 
2.43.0

