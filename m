Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C461EC4FD
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Dec 2024 11:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433224; cv=none; b=flU45M+4GGLEWn+SZzCKx8p2r6TgHOL/6RWup/STB6ZXtKwnOr77lJvybK2vyclskdsk/SlJWrumffwDSye2ONPb+JxRpgIW6SXq3FLE9vV+NPwFDSsB8M7UUJ43J93N+0ojw024LbVVB530PHTaUVns9vP4RIABz2hlceq7Zfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433224; c=relaxed/simple;
	bh=mxL81D/UG7PxRJJXW7LGMHSWsEoY4U8cEjAR6Aj7G+s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YtfwStbyoFeeAPSokBbMPHTEgp/jmUK0fl3/XsSRGAVpfplPBFwM8buHrUmrXln+iwyyreX2BjUmopfMmvoOkEWgwHcLc5TG9bpwiLv+UUbK97W51Q2k6wEZxQiPAPcl2iRFfFN5Rykfq0ql5YyEVOlHJ66W0sdnh8wcHGvf9qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-844db0decffso457788139f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Dec 2024 03:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734433221; x=1735038021;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9l1dCmP6YyidctdXBCDFs4vs2G8oh+UhEZ7QoQunXU=;
        b=B6NyD6s9KPsadkd97uq2KLzqtZJAC4ufLhaWNEZtM/D2fVoSx2httiopafssslhXle
         xA1t3t47W9whzFXIZGxNH42/yBbF0z6CHFLqfbsm913OzcxI3AQ55KZOQ/ZWiHRtp7qu
         w8cdcCVhZEdBwwf7/zwTwZErryy5+FhS6OcodhmddJR37Vmi/pZ2B9ixpZBj6uImtPtt
         37lDjx81PnR/U4zzmuGJysyJnJiOiQpc+RqjDeh1ORh8O192yYA54VUjjZMXwJ0IBlVL
         8w2c5OyDokhd6xtCsSehRdX4ZytzT0pnlnrz2qUKwfAgr7fM0cHXOF8648D6KuDfzQCH
         CU2w==
X-Forwarded-Encrypted: i=1; AJvYcCWT1tPknpeyHAfNeO8/srfuaoch7vmu3sN2nIJh5lRX6DBjgi2KTCkhJ6CjM+s1GQ+A9+j9H0FBAbNCjpJCGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YymdpvQIPmyg7sRQppfXuRVpq07ZyHvZhF9qBH20xU+k58qktFZ
	gFSB6IDlWWsRmsNYSdz2mDA0OMEujGOd+0mydwKJ/91oGB8E9z8WZSJo4lXtzm5zVPzh7STghy3
	lOdtdAHOYsEMrPi7Fn5OpeAYHAuYVRxxePbkmD+lwq9458RnNhA+QjTc=
X-Google-Smtp-Source: AGHT+IFyv2Y0w3dnfVz5Zrx2l4eBibmvlywpi8nPIbJDKKtxyFJ2FTJ2Fc0cQA1EmAhb3BV9wVVS7e963Hd4jnh3C3LmhWbtN6Lo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164f:b0:3a7:c81e:825f with SMTP id
 e9e14a558f8ab-3bb09e8b71emr27050065ab.9.1734433221339; Tue, 17 Dec 2024
 03:00:21 -0800 (PST)
Date: Tue, 17 Dec 2024 03:00:21 -0800
In-Reply-To: <6750931a.050a0220.17bd51.0071.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676159c5.050a0220.37aaf.0166.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_dev_freespace_init
From: syzbot <syzbot+aa2232cb0e5de0c0b56f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f44d154d6e3d Merge tag 'soc-fixes-6.13' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c0a7e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=caeefc00e8b4dc9f
dashboard link: https://syzkaller.appspot.com/bug?extid=aa2232cb0e5de0c0b56f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dc74f8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/009edf262d35/disk-f44d154d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9929be9055fe/vmlinux-f44d154d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/24e56358f05d/bzImage-f44d154d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/18b4c753db11/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aa2232cb0e5de0c0b56f@syzkaller.appspotmail.com

bcachefs (loop1): going read-write
bcachefs (loop1): marking superblocks
bcachefs (loop1): initializing freespace
=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
BUG: KMSAN: uninit-value in bch2_dev_freespace_init+0x1044/0x1eb0 fs/bcachefs/alloc_background.c:2232
 bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
 bch2_dev_freespace_init+0x1044/0x1eb0 fs/bcachefs/alloc_background.c:2232
 bch2_fs_freespace_init+0x599/0xb30 fs/bcachefs/alloc_background.c:2304
 bch2_fs_initialize+0x2140/0x35d0 fs/bcachefs/recovery.c:1082
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

CPU: 1 UID: 0 PID: 6157 Comm: syz.1.21 Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
