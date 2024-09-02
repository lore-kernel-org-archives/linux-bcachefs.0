Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03B51A3A9A
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Sep 2024 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725303448; cv=none; b=eG4UT6jydDddO5F+h675NTDEtfXr5+xX/Im/4B3T5tIekXg/jDj/7SYqTi1PD7Nzg7MVmJE7e3ZprywOjU/sdeFhMNNYYDxe8m2HXZThboC+zbnlV9Lfc7D40SksG9U61p/P2zFK8MNaRU8KlysQOYwbqpDnVvT8i05N4MilITo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725303448; c=relaxed/simple;
	bh=4L5PqVXNaSZy4AhTjTtg+uqiYEbEkHgB3/gh+HF7w0s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=srrcXQMHb1Yj8CbK8m8PDDDIIjsb+ZP+U/3i60vrEXHChq8hyQ53njdLzY1jyFEpG/BoCJPHUXi7RcjvngDdDAVHe5kS5P7+Hk6kRFQZzqSKoDhpeMJW+cpUH8d+z2Umw0kor1zRsjmGin3sfuBiXjozVw+GdXRy8iG+lxmPEJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f37874297so57672175ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Sep 2024 11:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725303446; x=1725908246;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H5vKbG/t5N9Im1QmpPzyPQF24exK+vcLO3qnHixgyZ4=;
        b=l7tL3d7WjduiOM8iOGebuuHTA97tnCyO3ZkF/1wGJFp4bFmkwLUFnh+Dmwm97E+1Zi
         OD3gXiE8sl+JFIBOdQV/wRRwZw8KoczNusulvNnIG75/M3LbnHPVNF56cndn1smbnTs8
         7EgXU+wV/Uu3pqmaYBKj766Ss5ctAa4+z7zvjQRAM3av34vIRSeUKnxP+KkJbQ3Rs77T
         +EnK8yA3lhCnVjlQGDoZ4Hw/gaDiZvLO/NfXUsjGleYOG2sVPeJp9HLp/Dfow4FyQkHU
         TZjNJHIBWqK1zb+m/Uy8lSCt8UsWCOwMNxpURHix5wSF+GLfiZnIBkSKrnooVnAhqt0h
         n6pA==
X-Forwarded-Encrypted: i=1; AJvYcCU9SWQXYWW8eO4bEwPtjteXRsgggx0vuCU6vzjjaMIiMEh4j2nhJRMzQn/NAVd1Iwao4TKTnvlYf6ujOHgmfA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2rUFOxYeVyo5zImVfxRo/7JXXmc3Az8VEF8BF2rFqDTTIGeHd
	NlSx4X/x07xPPxrWtvP91qymSJ2d+bO3NAnkm7jjcEJ+Vgsrfc4PZz9Z9npjIkXOfLULh0OTpJv
	otMyHkWsrgOPi91BAGC0mpw8nPJmDvSXl7Rgyb1+/72nfZpiNr6p52/0=
X-Google-Smtp-Source: AGHT+IH1aN+oTrag5m42XXGH7A04KNRRFQ5cvgwHtfEjTUWPQzZeVH1OZdsOyn6GVIq77AeDqZNyMf9FxXCvqmA6EWiTAOVhvuCo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1489:b0:397:ca8e:d377 with SMTP id
 e9e14a558f8ab-39f40e1f884mr11313785ab.0.1725303445903; Mon, 02 Sep 2024
 11:57:25 -0700 (PDT)
Date: Mon, 02 Sep 2024 11:57:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005e6c90621278371@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
From: syzbot <syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    431c1646e1f8 Linux 6.11-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1433084d980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=660f6eb11f9c7dc5
dashboard link: https://syzkaller.appspot.com/bug?extid=064ce437a1ad63d3f6ef
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160ccf2b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dbab2b980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-431c1646.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e5b61d9e315e/vmlinux-431c1646.xz
kernel image: https://storage.googleapis.com/syzbot-assets/149431616278/bzImage-431c1646.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/814c5affc830/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/sb-members.c:249:2
shift exponent 69 is too large for 64-bit type 'unsigned long long'
CPU: 0 UID: 0 PID: 5099 Comm: syz-executor454 Not tainted 6.11.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 member_to_text+0x9a2/0x9b0 fs/bcachefs/sb-members.c:249
 bch2_sb_members_v2_to_text+0x267/0x3b0 fs/bcachefs/sb-members.c:310
 bch2_sb_field_validate+0x201/0x2e0 fs/bcachefs/super-io.c:1233
 bch2_sb_validate+0xb4b/0xef0 fs/bcachefs/super-io.c:472
 __bch2_read_super+0xc1b/0x1370 fs/bcachefs/super-io.c:827
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2083
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1933
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe3ee4d7faa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe262fa7b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe262fa7d0 RCX: 00007fe3ee4d7faa
RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007ffe262fa7d0
RBP: 0000000000000004 R08: 00007ffe262fa810 R09: 0000000000005903
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffe262fa810 R14: 0000000000000003 R15: 0000000001000000
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
