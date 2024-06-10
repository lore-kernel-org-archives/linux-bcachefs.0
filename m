Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1342B64C
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 05:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717997969; cv=none; b=cnWA+b5lAcDFn9gOLlHWMIDXLpfCEDWlW3FgQDG2PQwYZitiaNuFZZwG92avcUcCAl3yUrW13iylZiKIJvglpkY/SrKpZFTjl+XKk+sBLMqqpdBTRPQ8wsI2SCq5nH2yZesPvMgRp7DQW4AhkbpCgvvu8M0BElw6Z7tpVEHDc+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717997969; c=relaxed/simple;
	bh=Maw+9jceAd4vds85zeu6HMJdkGcTrBHkzihWaBcDoqw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QkKt4lvF9Vbam5s0RALij550QFzrT/c+ubabUtFzD/khy7bF/5PYQVxW3cnX9S98dIMaVf8L6xD53/3expAfIWo74b9zXeattufBNhKzY7Hck2HGpU2QdXlrXB5jdrXgbjZgV5qPtJMC2OTdcpMtoGhp7d08vt4cHT2FDMzW78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-375a26a094dso8649265ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Jun 2024 22:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717997967; x=1718602767;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eurAxd79nImOWAEqQAoNdKFqjO092AUxG6aiQcVx56w=;
        b=Zb1txESjCR6amrzOLnjoiaQp+3cxoxmncdm8vDVc+vom6Y8uJbaePrtowA834ikeux
         QsS233Yp81FQqgyNTgzaZOTWrBRxuM2SMRRDkj4DHXFzaqjvqaElIgnhY6qOZNpFuktA
         DL5WYFPKD568n7adEX4nts/ZTLV5qjFNyaY1yx1uePM3n9ScIX6QGZhZrfUCq7S1usgU
         HzojzucU0+BR0s//5Db6kxvDnffW3r7DIvoNzRh4oTipYxtsLRo+Y0i6rde8xdmCmBQp
         8R+uiadYmhX4DnwhqzymzIjYEKSNRhCCfEbWcxiHl+ZcP7nR7hoEpP6IHFI/0DqoU/wl
         kL0g==
X-Forwarded-Encrypted: i=1; AJvYcCWoyUUKFaU9bXuhFe1afZPKtzTa1LsYI6DD6Yt6vTt8mKO/vh+N1+nzj5loYFkbN1GCq5M+CV5ezmg6pdAnVLlLD1GQEDX/+RMZNzBk+v8=
X-Gm-Message-State: AOJu0YznTJk6Qu2rA+2UkO13/WU+ExRgaTIJyY2q2gwK2bOBVQ4/giBv
	OezMCuJtqabuINzLhDgWffv73tl/wL2W5D7xvEGhjCEufwBwYHAoeAY95NQy6FU8Ma3h+peuCsW
	PI8cETCatl969aUJZ8Ios62wP5/PC9TboG8v90eM3YSthd26DQ80BsGQ=
X-Google-Smtp-Source: AGHT+IEYYv/lxvs7/13ZwZYQkwTpSEMUvuVmiXV5zT+xK1Aei3T7m0ckIeAIFMrWQ7rXqU7w9Y3rHTAiYhWxuRXOebhv6ouF8AVb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc9:b0:374:a840:e5be with SMTP id
 e9e14a558f8ab-375802379b1mr4857795ab.0.1717997966838; Sun, 09 Jun 2024
 22:39:26 -0700 (PDT)
Date: Sun, 09 Jun 2024 22:39:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000089ded8061a829247@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_bkey_format_invalid (2)
From: syzbot <syzbot+e5292b50f1957164a4b6@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13fc4362980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b4350cf56c61c80
dashboard link: https://syzkaller.appspot.com/bug?extid=e5292b50f1957164a4b6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a262ce980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15dc0cba980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6ea21f50498b/disk-8867bbd4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2fed09364aa/vmlinux-8867bbd4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4860173c7a18/Image-8867bbd4.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/662edb25db9f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e5292b50f1957164a4b6@syzkaller.appspotmail.com

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=ro,metadata_checksum=none,data_checksum=xxhash,compression=zstd,nojournal_transaction_names,read_only
bcachefs (loop0): recovering from clean shutdown, journal seq 10
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/bkey.c:664:22
shift exponent 64 is too large for 64-bit type 'unsigned long long'
CPU: 0 PID: 6246 Comm: syz-executor702 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:114
 dump_stack+0x1c/0x28 lib/dump_stack.c:123
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x2f4/0x36c lib/ubsan.c:468
 bch2_bkey_format_invalid+0x6a0/0x6e0 fs/bcachefs/bkey.c:664
 validate_bset+0x10ec/0x1d24 fs/bcachefs/btree_io.c:822
 bch2_btree_node_read_done+0x16f0/0x4ac8 fs/bcachefs/btree_io.c:1140
 btree_node_read_work+0x50c/0xe04 fs/bcachefs/btree_io.c:1345
 bch2_btree_node_read+0x1f4c/0x2818 fs/bcachefs/btree_io.c:1730
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
 bch2_btree_root_read+0x2a8/0x534 fs/bcachefs/btree_io.c:1793
 read_btree_roots+0x21c/0x730 fs/bcachefs/recovery.c:475
 bch2_fs_recovery+0x31c4/0x5488 fs/bcachefs/recovery.c:803
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1031
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2123
 bch2_mount+0x4fc/0xe18 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1780
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
---[ end trace ]---
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop0): flagging btree alloc lost data
error reading btree root alloc l=0: btree_node_read_error, shutting down
bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete


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
