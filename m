Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D9517D346
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739702847; cv=none; b=H2EsZ1BcpgUWMyI0x9MQ42aFvYV3Kxg+QwQ6GH1Ap7dRHVVdpNUU5Z5O7cm+tmzKfnRDBPhqML3nQZCYcL2zVRMuIx8oNpXk5Ki1AUEbVyWTIcGrRYKdzqwfd4X1z8+CaDhhvhvK08n4mnbTwlgbNpu+iIdRSpbrNqiXn6j3/LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739702847; c=relaxed/simple;
	bh=5MmFb+s/3IH8CHgp3DbPAEYSYLgpz/LUKEtPYcn9r2k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Z+WVmNaRpcP1DKHf80wKOtnCn48LjGfrdfTalp1NGLVi2CVaJz4Q38TDsng9TRBlE9hqLIjnWWtqQ4b93g2307E8MLTqPJB9FzIqRJiO/CvPuGYAQy+6Tdo1pARDWDzhXNyQHKDP4wEh+6zB5CMaWsQ3Yxt1vM0oeodS624awKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-851a991cf8bso289113039f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 02:47:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739702845; x=1740307645;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1rC5yZD1Oj7xxoIUrL4EBv5WYlNr78NfBA7GYtJkCc=;
        b=Bw0mi1a8WIKheF8LNdFQPTAXUbfX9u3PfcHxOz/ygu4eQCuF7/Sp9BGkHSnOV5yHh8
         Zm0ejdwQzHFYucjeCK0GSGJzXoy+VLhFcdLE3qqFotYY7EUpANCVkJYC2ifX1T7/CeJ1
         1KWly19AkCyeCxDGfq4ujFmA4yp0kAfGf48SkxieDbRvOxJt8OvH2fJ/AG8fai68gRt+
         v0CNmdWcMiSgD/4Gz3CZPJNDTwhu3Ce62zUTlP/hOUjJJz3wFzGINEq/RmQ1uILeEZFG
         ab9Gqh/YIgpJ8MkIv3AXwI0ao91kJ/Rbcu8KUq8GiVsfg1DaVGeJSqYBj20I4H7vuUlm
         5ptg==
X-Forwarded-Encrypted: i=1; AJvYcCXREqQTVbIBaqtgHCsowy8VWo2IXCx9PuEJYNwARQ/HXdU5n+EKflZ1tvN30iaBgIUrINgoZI5+81Mrqxk6xg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQJPfO/IctxriiXRNkKa09+/gwCOpEw6Pn6S3ZP6C2VweJCjSu
	Watairj9sW+ViHyIyfpMrPUvyXWtamp1zJ2ZrDqMtN7atN+Nv9jIs33flfgMq42Zik+qP3fCNWf
	At82TFtDY1ytdekZtqe/6CnB6copJ6zcOuTE57pvZc6cE8jLcdNmS/QU=
X-Google-Smtp-Source: AGHT+IHJn51wBYnnnfHBFAbF++gEpzsR5TFBiMdzYfHmdQ0mIS5I4CP4444lkzfPvz3A3WgBtXVMouCb2o7EPqWqwhTQW4E4N2uZ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:692:b0:3d1:4747:f387 with SMTP id
 e9e14a558f8ab-3d18c9b8f2dmr88866535ab.0.1739702845358; Sun, 16 Feb 2025
 02:47:25 -0800 (PST)
Date: Sun, 16 Feb 2025 02:47:25 -0800
In-Reply-To: <67476c0d.050a0220.253251.005e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b1c23d.050a0220.54b41.0007.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_cmp_packed_inlined
 (2)
From: syzbot <syzbot+65b594f491e4023728b0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    496659003dac Merge tag 'i2c-for-6.14-rc3' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12c2d5a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=264db44f1897cdc3
dashboard link: https://syzkaller.appspot.com/bug?extid=65b594f491e4023728b0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161d2bf8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172a97df980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/96211a6dd5b7/disk-49665900.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/28af00be6abb/vmlinux-49665900.xz
kernel image: https://storage.googleapis.com/syzbot-assets/250398195b35/bzImage-49665900.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/25c6d0c4b587/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65b594f491e4023728b0@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_bkey_cmp_packed_inlined+0x8d0/0xd50 fs/bcachefs/bkey_cmp.h:115
 bch2_bkey_cmp_packed_inlined+0x8d0/0xd50 fs/bcachefs/bkey_cmp.h:115
 bch2_sort_keys_keep_unwritten_whiteouts+0xebd/0x1840 fs/bcachefs/bkey_sort.c:184
 __bch2_btree_node_write+0x3b3f/0x6870 fs/bcachefs/btree_io.c:2140
 bch2_btree_node_write_trans+0xd7/0x890 fs/bcachefs/btree_io.c:2357
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:816 [inline]
 btree_interior_update_work+0x3c02/0x48c0 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xc1a/0x1e80 kernel/workqueue.c:3317
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3398
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4249
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4266
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4300
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:662
 btree_node_data_alloc fs/bcachefs/btree_cache.c:156 [inline]
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:201
 bch2_fs_btree_cache_init+0x4f0/0xb60 fs/bcachefs/btree_cache.c:655
 bch2_fs_alloc fs/bcachefs/super.c:919 [inline]
 bch2_fs_open+0x4d84/0x5ba0 fs/bcachefs/super.c:2064
 bch2_fs_get_tree+0x98a/0x24e0 fs/bcachefs/fs.c:2190
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

CPU: 1 UID: 0 PID: 3010 Comm: kworker/u8:7 Not tainted 6.14.0-rc2-syzkaller-00281-g496659003dac #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: btree_update btree_interior_update_work
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
