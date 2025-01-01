Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEFA2F85C
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 20:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735764921; cv=none; b=Nq8saW6V6zVZ2klpb9wyNjx6xxULzQibdtE2d+3ng0UNeKWmk9gxXvZINDQcsCunU0eVkIZWaPy83o3TT2L7EFvRiez1mlj/NrHvME5J3VfOoRkQxbMfyFBhxb7OvQyh06yu960h9Ck7ibp2P4UpsOqiG5txCa221tjKgdxjths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735764921; c=relaxed/simple;
	bh=sxfrBu1rCzfXr1oWL60ps/v9l3bBtt+vB2We+KEtAmM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ryKygfFdJ2nwKNP+mOMwwc20u9X5iCvJr1VuTwSjWHMxA8d5wURdwMPBRYEsjfyrlP4FDakRPVyIrjNJhIdDuxB58baBX9ANcUGgtLf+n3OVyvS92sJysDOswHxze8pCzwntojWXWqG9FhH3YXmqc4IBn+eePFZCuOEVueMrtBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-844e9b92401so1845197839f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 12:55:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735764919; x=1736369719;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAGuy/a9W3IQtPB+h+HBKi8FmS2YmrW9upz+FGk6Hwo=;
        b=mRIbnXhPPdTMHPn8ZTu6Rmnd9AQ4RgBKhcP5zYCmh4a8lgsmt/UPhMvqEQdwlH7LoC
         iXQAoMkAwaYnmpSRQxFFgmRFuqesAcSmnSc/b9WEwzbPOhGiiQuCIfHWdx/c6RQPQ10m
         TwZSkdbM8BKPmmWOF3oU/UtgMIrxML6ndRx8gFnrnif8k9nAIPjhcHVrIAl4y/wh3Pnb
         t+ZWDJQ10072YbymTG3LLfc+qw5Wf8PPpzN6vYWp16fpegzelCkpf+ErwCYgeNFTSVnx
         9gppAgwZkZaRJRbC+xln4Xba1iZAXNubIrSMmX86M0hEbHMCm4nN0xYlRankOQ+Yn/0K
         /rhA==
X-Forwarded-Encrypted: i=1; AJvYcCUDvkEbwmad4ymaI6kGZWWyFQUFMbZZCMmayd1qesHQjR0UkCagK7Go6Tqr+AQlwYa68ikYyEDtXwAz7mR1Yg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEjWXc8kgGZTDlHfyx5NNRbZCaWvKoj8x/q/F8KnaS/NKnUoKj
	FONvdbYVwCb/EbChWL4EXInSLym/LThia+7nfOxyx1ap0PlmhUxv4dfiGGJ9BRL9xonp0AkdkUt
	3zbT02jahJcAdj/wIinmLDWKG1uY/8imUVSEO33VM4ziN3vlIV+sYdiw=
X-Google-Smtp-Source: AGHT+IFniLqpTUdlaFgWxWQniXbzvWJroIFbwdqqgCleA6qsxwZyKphCdnK+uv7wp5AYKcdsnGDEzexpjzQV//L5yua0IUFSH5Q/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda6:0:b0:3a7:8720:9e9f with SMTP id
 e9e14a558f8ab-3c2d14d1c30mr325906035ab.2.1735764918931; Wed, 01 Jan 2025
 12:55:18 -0800 (PST)
Date: Wed, 01 Jan 2025 12:55:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6775abb6.050a0220.3a8527.002c.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_inode_unpack (2)
From: syzbot <syzbot+9b79c816ed3895539cf4@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13493818580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31c2647cf06aa81e
dashboard link: https://syzkaller.appspot.com/bug?extid=9b79c816ed3895539cf4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da86466e08c0/disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/673316cfa30c/vmlinux-ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4d50a89ed2d4/bzImage-ccb98cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b79c816ed3895539cf4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_inode_unpack_v3 fs/bcachefs/inode.c:274 [inline]
BUG: KMSAN: uninit-value in bch2_inode_unpack+0x9fb/0x4ca0 fs/bcachefs/inode.c:331
 bch2_inode_unpack_v3 fs/bcachefs/inode.c:274 [inline]
 bch2_inode_unpack+0x9fb/0x4ca0 fs/bcachefs/inode.c:331
 bch2_inode_rm+0xdbc/0x1260 fs/bcachefs/inode.c:1042
 bch2_evict_inode+0x2d5/0x6a0 fs/bcachefs/fs.c:1836
 evict+0x723/0xd10 fs/inode.c:796
 iput_final fs/inode.c:1946 [inline]
 iput+0x97b/0xdb0 fs/inode.c:1972
 bch2_symlink+0x49f/0x540 fs/bcachefs/fs.c:821
 vfs_symlink+0x1ed/0x460 fs/namei.c:4669
 do_symlinkat+0x253/0x8b0 fs/namei.c:4695
 __do_sys_symlink fs/namei.c:4716 [inline]
 __se_sys_symlink fs/namei.c:4714 [inline]
 __x64_sys_symlink+0xe0/0x140 fs/namei.c:4714
 x64_sys_call+0x31ca/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:89
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:513 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:259 [inline]
 btree_key_cache_fill+0xd1a/0x3d60 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x988/0xe20 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x749/0x47b0 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_slot+0x10b7/0x3950 fs/bcachefs/btree_iter.c:2629
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:575 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:589 [inline]
 bch2_inode_rm+0x95d/0x1260 fs/bcachefs/inode.c:1027
 bch2_evict_inode+0x2d5/0x6a0 fs/bcachefs/fs.c:1836
 evict+0x723/0xd10 fs/inode.c:796
 iput_final fs/inode.c:1946 [inline]
 iput+0x97b/0xdb0 fs/inode.c:1972
 bch2_symlink+0x49f/0x540 fs/bcachefs/fs.c:821
 vfs_symlink+0x1ed/0x460 fs/namei.c:4669
 do_symlinkat+0x253/0x8b0 fs/namei.c:4695
 __do_sys_symlink fs/namei.c:4716 [inline]
 __se_sys_symlink fs/namei.c:4714 [inline]
 __x64_sys_symlink+0xe0/0x140 fs/namei.c:4714
 x64_sys_call+0x31ca/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:89
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_write+0x21c/0x2e0 fs/bcachefs/btree_io.c:2289
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:261
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

CPU: 0 UID: 0 PID: 6027 Comm: syz.1.13 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
