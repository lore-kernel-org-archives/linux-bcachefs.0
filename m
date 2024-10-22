Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EB48CFC
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729561806; cv=none; b=fMvLEnxS8NEvlLRDbCo7WSn/YYamjZmtf6g/YkEIpAR7NMItYBTKjp1sO/AcZ7ynVI874XO24f1AmMwHS8GYXe1g2K9jKhx5Aa7jdTc6Vxa2Dr6swYB3xDzkFl7pHUXkF+TbJZUoN8eVly1sbTT5QcvgsuZ3larP1epLQI0bCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729561806; c=relaxed/simple;
	bh=UTnuywt4nyP3mmg7CHAIDAQsx3aYs2JWUdkTAAFncmY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=VcA1HWnXVjA2woHZrQJIS/YahP2Mkd0tVhgTNXCLoggaL5TvzbThkcPQv59V73AnocF2eXv+/Qns1H+AKhTpwqn+ERSvO6acHWvBBhpoi3GM/u2hjEcMA7lfmEBWPwhQ2pwoI/MJgJixUFLdKJ/QwSvc/8vsdgUc+FbriD0Srek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3ae3c2cacso49303035ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 18:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729561804; x=1730166604;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HgmwNQfqsKcOMKindI3W18Ec0Q2U/e0fdYSbLLcH+oU=;
        b=bdHhmpbBBJQ4c27PN4phFA5c9jgJZgOJ01dOTxVzWEGsz05l37EmA/8hX5IKJ1NFzU
         EW1zLr0fFn89Y/gQUAGOYAEXgRRt1PCQzr1hT2hgt1E0NlkSKrEf7j07+oUQ48PEN1SM
         GOI/F6tcZRcQbYXWYK0XtyKsBGt9c23lk3E1aRwfrOuLCFCoTQ57nr77EhYw6ZzbvCXA
         c1ZW56SMnN5CLgvQzLBrDbhsaja2Z5UBJdc0+n1ywlBX3HX/Qw2ZBppz529WAd346k2n
         1NRhxKwaZUniy4ArNWMxcIDYKgaSNxC5lcsl3+WUvMTKHGDTAu3QoqCD2yQr0Wv1rvdP
         wP+g==
X-Forwarded-Encrypted: i=1; AJvYcCU6XcWut2Jy4oZ5Qoa2yWFkH+J32afM3OYMAHcEBCcBQCScKOq9x/xi12yTrwfHDpIFM8+aatj1aCKiG/BswA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHP/iPeUVkj2Wsfo/ZUAigEIDWCtBSu27f9SmqRDvn3awTU81X
	Be5P9r5EtpmpQuty8/9W3BPY6IiqUHe2tmw7YFTd4QUFF3zQTIYXI1M2kyaQj6KmTFXHT6tsj7K
	0J5up3fi+DB7I1Mh+Q5myfhMFBI8hBl9aPVObtc8kTWl5rZys9WT2tqM=
X-Google-Smtp-Source: AGHT+IH1TBHWorIXr39NQH15YpMPv5VQb4pLKvKU5mnRA9ySO1FT9KwwGJBjmdokDkgNKI50msKUPwBSbumlb3viLzLFhHihbUn0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198b:b0:3a3:4221:b0d3 with SMTP id
 e9e14a558f8ab-3a4cd2f8be0mr11246615ab.0.1729561803849; Mon, 21 Oct 2024
 18:50:03 -0700 (PDT)
Date: Mon, 21 Oct 2024 18:50:03 -0700
In-Reply-To: <d72c960b-b524-4c8a-9809-7885aaf6a904@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671704cb.050a0220.1e4b4d.006b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text
From: syzbot <syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, lihongbo22@huawei.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
UBSAN: shift-out-of-bounds in bch2_alloc_to_text

bcachefs (loop0): fatal error - emergency read only
bcachefs (loop0): insufficient writeable journal devices available: have 0, need 1
rw journal devs: loop0
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/alloc_background.h:165:13
shift exponent 129 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 5607 Comm: syz.0.15 Not tainted 6.12.0-rc3-syzkaller-00087-gc964ced77262-dirty #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 data_type_movable fs/bcachefs/alloc_background.h:165 [inline]
 alloc_lru_idx_fragmentation fs/bcachefs/alloc_background.h:171 [inline]
 bch2_alloc_to_text+0xc79/0xce0 fs/bcachefs/alloc_background.c:373
 __bch2_bkey_fsck_err+0x1c8/0x280 fs/bcachefs/error.c:454
 bch2_alloc_v4_validate+0x97b/0xf30 fs/bcachefs/alloc_background.c:259
 bch2_btree_node_read_done+0x3e7e/0x5e90 fs/bcachefs/btree_io.c:1223
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
 bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca2ff7f79a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fca30df3e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fca30df3ef0 RCX: 00007fca2ff7f79a
RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007fca30df3eb0
RBP: 00000000200058c0 R08: 00007fca30df3ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020000100
R13: 00007fca30df3eb0 R14: 00000000000058cc R15: 0000000020005940
 </TASK>
---[ end trace ]---


Tested on:

commit:         c964ced7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=139890a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=7f45fa9805c40db3f108
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15735c87980000

