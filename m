Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC8C20E02E
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Feb 2025 20:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738614572; cv=none; b=pFbZT0pWXOxVH/9HY0OAFk14sj8JPGa71WEIxIIB6TSvXM7jbMy2vDzYEG6KeDit0jU9E63b+Ru7g0G871tHgaYxZaOm10gdyHifhm/ZRfU5gl6rphQE+Z8i2efaOVGNLOLCqLiG6VAI8E2dCVaiQLWhZwXVfqtmA3hE0F/R4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738614572; c=relaxed/simple;
	bh=zxJGX0OU6dZ/tUo5gZwFvEJ4juDjjPWDH+MSaVkleN8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QjadKxRyb1vklK5q8/vgnT20Z3ND6t4tEiOcXafz3T8N6yZMcmUXs2vMxxnohsmmo21cO0QHyujDXocnKfaJRgX/4LIyPSh8jko9OvIZtBDgftxBSgWkFG5A6gyKEUXg7b/jOyMoYWleT1SoFDLMi4eCLuNonZRk1qKqLmGz4k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d01c66745cso20442235ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Feb 2025 12:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738614570; x=1739219370;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtQyloYLa0hSazjSmT3VtRmVZBfI1Ct34W+5EWC/El4=;
        b=iimXnJlKufnV51F/4cqaL3Kt+BVAiH05VepM8YX8UXShAuqpoqV1/Ou2blXRSerSr2
         vnzkgTGhhD9CyNHDp6if+z9H+ACTxEUkSKe4b68z/6i7e9m1C5F7GLhmx+l9TuK3NIHL
         qE7Qd1uebF/TA31Ot8I2GRKs6rRnhg6oaYK9yCXn6TCJWHEaJlVdI4A1qmOEehPSmol9
         tn/gFnv49GmCSuNZ8oc1tiO9ZQ3+wL+vxMevVaTSloQuY+QjKnYMkOMJbZNgKiFjDMv+
         eaTR/X0Dvw4+gKnTxBhivNJmqwM+zQz4gQBAo9mR7JByE5Y5flfrMyPNOJKeiuzCO1O/
         cC+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXoDw4RZPwpc2OtTSRKMV+NqyNZxmgfmZ/32vqu0JUU9tsbe4VU7DCfZTTlHzZFnUCC02KzZJ4565Rjl6kiaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJXR6V97S+ljEKRu0KhrOPZHUR0pRsVNEAQvmjHW7JQyC9AqmM
	vC0tgYJ3Evg3L0S95F+D0cDny+5rYwtUWj6E3H9FIORw4amwewoKnIjkViqeOymaOJNSG+CZI6a
	GKYn6znn8i9QxYKz3HvwGWiRnr2sW3/DZ2vRSV7TnQ12qoyzBUZNoJ8o=
X-Google-Smtp-Source: AGHT+IHKKi7kU8mhLWnde96zmelWDef1vKKZEZrlxzzPMXRrImvuLJ0tLZFw2YSnZ/TUS4s2eIrAiDPuNgBAYKGNMHDCy6Els153
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a29:b0:3d0:258e:4841 with SMTP id
 e9e14a558f8ab-3d0258e49f8mr95974055ab.21.1738614570339; Mon, 03 Feb 2025
 12:29:30 -0800 (PST)
Date: Mon, 03 Feb 2025 12:29:30 -0800
In-Reply-To: <6750931a.050a0220.17bd51.0071.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a1272a.050a0220.163cdc.0053.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_dev_freespace_init
From: syzbot <syzbot+aa2232cb0e5de0c0b56f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2014c95afece Linux 6.14-rc1
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15526eb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aa4f01a8a3baec54
dashboard link: https://syzkaller.appspot.com/bug?extid=aa2232cb0e5de0c0b56f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1071d724580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b1c3df980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5f7690b1fcba/disk-2014c95a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf88797ccf0a/vmlinux-2014c95a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c40073027cde/bzImage-2014c95a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/243156c15973/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aa2232cb0e5de0c0b56f@syzkaller.appspotmail.com

bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,metadata_checksum=none,data_checksum=none,compression=lz4,nojournal_transaction_names
bcachefs (loop0): initializing new filesystem
bcachefs (loop0): going read-write
bcachefs (loop0): marking superblocks
bcachefs (loop0): initializing freespace
=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:233 [inline]
BUG: KMSAN: uninit-value in bch2_dev_freespace_init+0x1044/0x1eb0 fs/bcachefs/alloc_background.c:2254
 bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:233 [inline]
 bch2_dev_freespace_init+0x1044/0x1eb0 fs/bcachefs/alloc_background.c:2254
 bch2_fs_freespace_init+0x599/0xb30 fs/bcachefs/alloc_background.c:2326
 bch2_fs_initialize+0x1a74/0x2f90 fs/bcachefs/recovery.c:1154
 bch2_fs_start+0x792/0xc20 fs/bcachefs/super.c:1031
 bch2_fs_get_tree+0x143a/0x2330 fs/bcachefs/fs.c:2203
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
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:201
 bch2_fs_btree_cache_init+0x4f0/0xb60 fs/bcachefs/btree_cache.c:655
 bch2_fs_alloc fs/bcachefs/super.c:908 [inline]
 bch2_fs_open+0x4b24/0x59c0 fs/bcachefs/super.c:2053
 bch2_fs_get_tree+0x986/0x2330 fs/bcachefs/fs.c:2190
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

CPU: 1 UID: 0 PID: 5778 Comm: syz-executor213 Not tainted 6.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
