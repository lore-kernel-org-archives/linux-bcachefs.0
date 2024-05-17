Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D81A28D
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 May 2024 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715932951; cv=none; b=ktnHDwFtxpgnBk28ZSp4xCRNKNicCdpPSKBkhFzq+Nvf6R6GHT4t4J299cdCP2gp1FyRIhCCcq6zid9VwYZ+YnXsal+uXPO7GY5Wx2ItidzJedWxwqX0V9W2VzDyv2YFqYmsLFcfepflRXTQVbH6SWxObufPuvJmtz+s+g1oCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715932951; c=relaxed/simple;
	bh=p45+b/pSpV/zvqpjYIjk+i4pyy2EMc9SNVvuUSNDgzI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QG8WGke5jtf/qeFxDBubyo9EYp9ukeOAPqaZTuThD2dNKdL4tl787pPkd/299CFb4PFewXB8fzJ7+5KlWv+BJHxilqOzTShGyNXml3myNJwMlSY7QL3muJSJed0jx+gvLl81R3WGICFvIx3pit0EDX9gVjb9ncnEM1H/pOZmRQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1ac2fbcb7so1048204339f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 17 May 2024 01:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715932948; x=1716537748;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p3IPiib30PKj0HoFUNsOUfWlrZ5YZUAkEjiI/WkOAew=;
        b=fp5H5m0VcOqwcl7XdBs2bMg5L8sxE18o/3TOH85zgIS/uHtHhAiOb+iZCOPc3h+LCp
         AQta7u6BWI3q5F3pK5IdFGN4yXt4gsmp+warBlVcHk90QJdRZ7+ptzKB6PRYYKsyNmEA
         uWhMsjSN2un+JTVGsg25yUqo/4xMUgXCnSujM4vhEbKOXun5PtAxzN1Dt68uYrqpHugH
         gziNAtbYhvA+ZGEczYrjl1TTX05qlPoR7fQM7hpCXY0H7JgePX1xkqEmJu9w0xZSkN5o
         o18ItEkksZve1rnKkZPKl+bwACd2rTpru8WNYlJu7yKF7QoV/CB/DccmwAU+dThPqrWO
         xmAA==
X-Forwarded-Encrypted: i=1; AJvYcCVMLRSr5jdjciut/OuWEINV/aXrrtQz2/sv8+ocKzKKv2OxKXp5hMtmenDwo67LlW9u67ShK3OUpAS3HYZzRAx6v2MPyA56bJ4nRUEBlBQ=
X-Gm-Message-State: AOJu0YyezuFnTHtK8Z3EMEGs3VmCg5uxu+cSb1xTewNbq5tGSGBrVLt4
	+X0zH4YsbxTOWcJmRMOaek25OtumWK9hDoqmhXcmL9+5sXvW6r2PFVb9IUzQcBeSdc+JR9oOrDG
	p4N2ad73qHb6/iJlCcfudblyhuHICmtCi5XmfvAtzI3H0hEVBWrXveq0=
X-Google-Smtp-Source: AGHT+IGAjDdsV8ez56rlHz1o0lz0WD4jrCNjiClk7aEbNl1XYJdX7MGQXv32iG91ji5IRRyNi4AWTvGP5jC0RIdZTAMbNY0i7Fwa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:484:b0:7de:e182:ddf1 with SMTP id
 ca18e2360f4ac-7e1b5010346mr83760039f.0.1715932948678; Fri, 17 May 2024
 01:02:28 -0700 (PDT)
Date: Fri, 17 May 2024 01:02:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd5d730618a1c598@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_btree_lost_data
From: syzbot <syzbot+29f65db1a5fe427b5c56@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8c06da67d0bd Merge tag 'livepatching-for-6.10' of git://gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=135f87d4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc69cd6a2dcb5aa
dashboard link: https://syzkaller.appspot.com/bug?extid=29f65db1a5fe427b5c56
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d09ce0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ea775c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/331202aeac12/disk-8c06da67.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4db56871f364/vmlinux-8c06da67.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2ab7bc870390/bzImage-8c06da67.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b709a5f7f34f/mount_0.gz

The issue was bisected to:

commit 55936afe11077a84d9e1c5068169af328bbf2811
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Mar 16 03:03:42 2024 +0000

    bcachefs: Flag btrees with missing data

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=145dc1d0980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=165dc1d0980000
console output: https://syzkaller.appspot.com/x/log.txt?x=125dc1d0980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+29f65db1a5fe427b5c56@syzkaller.appspotmail.com
Fixes: 55936afe1107 ("bcachefs: Flag btrees with missing data")

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): error validating btree node on loop0 at btree (unknown) level 3/3
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 27c2ec7b8e70cb08 written 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0
  node offset 0/16 bset u64s 0: incorrect btree id
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/recovery.c:38:10
shift exponent 255 is too large for 64-bit type 'unsigned long long'
CPU: 1 PID: 5082 Comm: syz-executor184 Not tainted 6.9.0-syzkaller-07387-g8c06da67d0bd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 bch2_btree_lost_data+0x143/0x150 fs/bcachefs/recovery.c:38
 bch2_btree_node_read_done+0x50f9/0x5a40 fs/bcachefs/btree_io.c:1272
 btree_node_read_work+0x665/0x1300 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x2b64/0x32c0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x4334/0x63b0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1043
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1906
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa695417daa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4c8ca6b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc4c8ca6d0 RCX: 00007fa695417daa
RDX: 0000000020011a00 RSI: 0000000020000080 RDI: 00007ffc4c8ca6d0
RBP: 0000000000000004 R08: 00007ffc4c8ca710 R09: 00000000000119fd
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffc4c8ca710 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
