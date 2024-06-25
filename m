Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF253176AAF
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Jun 2024 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719335602; cv=none; b=nMPdjiMIPPQ8CdWBZ+Z6DBJDd5OTjlrhrUMcSEogU5LmU4B1NA0b99vYF99SAx5vj3doM4O1oQNYLsBnK5M8ANx9hoOyGSQB+1AdYetas2/28I3Wzfq+qiAymqSYTb2rmGMvY9nX2Bo4CtMDd7Wso/5ZzxrMPssKw7y4GEs5Av0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719335602; c=relaxed/simple;
	bh=EehPf8S1tgEOAWW0oPbZjLhqaVxYgZ40z0A2C7d2k6o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sBafJi2hk0PCjtDCbAp/s79CUZGUTNVLqptTYR4/4TZXyEhgC8ynpGPHxhFwUJ+FxiHMFBRH51BLm+dLI29g+IcS79Q5O5+HRmVg8HE4u4rAd7gdUnPvSN0KDp1vAPcKi5rWsRSmaA75Niprs/6Om3NOG1m9b3nXa6hoQo9r5p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3761cec5b39so62034325ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Jun 2024 10:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719335600; x=1719940400;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/qpoSgxuUceFvD4VRDBoC7IsPLM80+SNtA4vfaQkEw=;
        b=VNuZuFuCvNVLQVgTd3QSv2fkhEUZ0godIHyiyFnu7feLSQQ7grudwE7/pFLtTuOJYc
         MseyO8F313NTPxy2mmRb1BHaFvgB9FiezzQW806ytDVVOkkajCfsQ1vNgYwruEhzJ4ih
         gizjxlBM/fJjc+pFEi7Ng2ulN40dWECOwY2MWOwgwM520AUz3ayMWEgBkwPZ4/13wEoi
         mr6SK6VCLQ43v2K8+qQOoX26u4kBXbXdbFoecInEingwFlh95xXcx9KQf7/FjnGERRiJ
         thbYCnj185lwNABgM3pL1mO8pw4UbBGw0+mrYjYVfihCYLcMWMgnCE/U/dYJzeaV+iRg
         L+SA==
X-Forwarded-Encrypted: i=1; AJvYcCXfaZI5h/5nznDohnFc2w8g2nTLOr79uhZIfIa4kGK2jlTIYg17vEDEQTt9TSkdBO++PNZfJoGVZJqDmmTINHOw49AT+DzNgbqzwU+WILg=
X-Gm-Message-State: AOJu0YwJhBk6D+Eglew0KN3N1xKBlwgy+99u7IxJIFl1XxHIWe75CKbj
	rIPaFDIXpoBVoQPjCoQGIRjf3JN4R13B8QjZTs2n0Zo/+2acUH8vwkCtMx2S1u6lBlUQo31AUYo
	agmbQESH5uhkwhc+ZI196ILDYrxcSyuNlslCntWZc6x+xuVuCOPuVvG0=
X-Google-Smtp-Source: AGHT+IEzNRf2/MSDtxakbi0yRTo7gC02MYQqkN9MGDLUKIi2E8FczcX1nty6mwWbRCYomjwgW5BlwR1JfQnDBYF+KAD40RDqJCKR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a06:b0:375:9cb9:9d04 with SMTP id
 e9e14a558f8ab-3763b339fcamr10239155ab.3.1719335600174; Tue, 25 Jun 2024
 10:13:20 -0700 (PDT)
Date: Tue, 25 Jun 2024 10:13:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2c201061bba0374@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_blacklist_entries_gc
From: syzbot <syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    563a50672d8a Merge tag 'xfs-6.10-fixes-4' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1286cdda980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3820d4fff43c7a3
dashboard link: https://syzkaller.appspot.com/bug?extid=835d255ad6bc7f29ee12
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e2d08e980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1009808e980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-563a5067.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6ef95d163dde/vmlinux-563a5067.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0102d9e1ac9a/bzImage-563a5067.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7fdc5cd163b4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com

bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in ./include/linux/log2.h:67:13
shift exponent 4294967295 is too large for 64-bit type 'long unsigned int'
CPU: 0 PID: 5189 Comm: syz-executor355 Not tainted 6.10.0-rc4-syzkaller-00283-g563a50672d8a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x2a5/0x480 lib/ubsan.c:468
 __rounddown_pow_of_two include/linux/log2.h:67 [inline]
 eytzinger1_first fs/bcachefs/eytzinger.h:51 [inline]
 eytzinger0_first fs/bcachefs/eytzinger.h:194 [inline]
 bch2_blacklist_entries_gc.cold+0x35/0x56 fs/bcachefs/journal_seq_blacklist.c:235
 bch2_fs_recovery+0x3240/0x3e40 fs/bcachefs/recovery.c:897
 bch2_fs_start+0x2e9/0x600 fs/bcachefs/super.c:1036
 bch2_fs_open+0xfa0/0x1110 fs/bcachefs/super.c:2128
 bch2_mount+0xe2c/0x1230 fs/bcachefs/fs.c:1926
 legacy_get_tree+0x109/0x220 fs/fs_context.c:662
 vfs_get_tree+0x8f/0x380 fs/super.c:1780
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x14e6/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd8395e2bba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe022b6078 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe022b6090 RCX: 00007fd8395e2bba
RDX: 0000000020011a00 RSI: 0000000020000040 RDI: 00007ffe022b6090
RBP: 0000000000000004 R08: 00007ffe022b60d0 R09: 00000000000119f4
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffe022b60d0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


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
