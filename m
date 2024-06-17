Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D10171B0
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718614761; cv=none; b=Q1nL8TH8oZl3/+SThASYdLXscijOYq5qHh0UB6/mPKesUGyPmUhG94jarzx8Ati2rggqg7Pa4u6FshGctk0aebBV1533MA10i21tycBcJN0Fsmo4otYanQkMcbBDcPjTHK+JYy+mI+WpqmkXfqrunh2X2EJUXUtatw1q3CAsAqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718614761; c=relaxed/simple;
	bh=azrhHKA8GofXXpFtnTVLKlnvryN0CNZGEUH5cnPaz08=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=p/xKRyGLcoR9+QVMr9EoG0j3fikWy6QvoKrGgHxg3wbkZdEH2Mhtv73E7JFLLg7vi6FNDnkMIiwpTkK2+2rHJgaTcjFFAx2aaCt4Zhwuuy14W7KOM7hNdv2tjF63p5ibO5VTcVy6wTzsn02/unCNIKQAObK1kWd68sdUTDDq/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7eee7741583so100120139f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 01:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718614759; x=1719219559;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6M+uX0qwRHQUN70aVnCHGwZLDZe6zA4HwQq3ercWqw=;
        b=JNaQbT5dwfA9oABaISf2eH2gekSCENaPQk9KwryQG2DmYPCF67N1kUtcAsBPIWAPEt
         Yti23rhTIdcKkR3beZvz6BSDMS1d5Mk5mYEFdxb3q4Z4Kut3T15jo+m9F4pn1zG9Zfal
         CrfYSeWgcfK47hJJKkj+5jRjC/9GYNQ0OJo+uG/IwbAsKStwK54xOYEpSXE7xk9n1B/I
         BGhp01K4ajHXkVHC/xPtBbCEe+ev+hgoVVvh5XqUYcrUmEuWGLlQdiNCMTqv3k67BCvJ
         oHmqdCrk/UT7nFsZ2YBm2xU8TidkSeubXvu1AdC6Jovz7ar5DYMk9++l0K7T+FX6fbGr
         skyg==
X-Forwarded-Encrypted: i=1; AJvYcCVnm/lzp/zMSR2utJsehMhK9zFLjpQl31VVsYjy9YV3YpJ8G1bV6cvVHpUxJcyGYNKcz98I13hb036pYr5mmJTh3NQa0eWSptIr3Eauh3I=
X-Gm-Message-State: AOJu0YwTCoag6x6Qj2zG7fPBmVAYCOPcsrw4C81FqcoZo1k/VZlh3PY3
	LHWdHQZr3iab3u1lD7OXp1j68aMFN6MJjTDwifZ2/+Zeoogp+hqITfiTQ5IhNU6Ix1Hx+ZDyQzx
	hTGWtfVaOQrJ3hZJwcwrgJrx+eN6UdIvQu4WIz+xZkDhj7Hy/8lSM9Iw=
X-Google-Smtp-Source: AGHT+IHvzyIxHQtz6i7UeyWeO5D3kAAlL6SpUbyIh+TyaF6UDh6WKHEv5tJL8CmzzUlLzgsIKJfaM2nJq2QYoihyI7367qkRT41E
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148b:b0:375:ac5d:d5df with SMTP id
 e9e14a558f8ab-375e0c7dcaemr9446075ab.0.1718614758871; Mon, 17 Jun 2024
 01:59:18 -0700 (PDT)
Date: Mon, 17 Jun 2024 01:59:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003565fc061b122e02@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in read_one_super (2)
From: syzbot <syzbot+9f74cb4006b83e2a3df1@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15286f7a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0ce06dcc735711
dashboard link: https://syzkaller.appspot.com/bug?extid=9f74cb4006b83e2a3df1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/27e64d7472ce/disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1c494bb5c9c/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/752498985a5e/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f74cb4006b83e2a3df1@syzkaller.appspotmail.com

loop2: detected capacity change from 0 to 32789
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/super-io.c:653:3
shift exponent 106 is too large for 64-bit type 'unsigned long'
CPU: 0 PID: 9174 Comm: syz-executor.2 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 read_one_super+0xfb5/0xfc0 fs/bcachefs/super-io.c:653
 __bch2_read_super+0x65a/0x1460 fs/bcachefs/super-io.c:750
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2074
 bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
 legacy_get_tree+0xf0/0x190 fs/fs_context.c:662
 vfs_get_tree+0x92/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f82b087e5aa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f82b1586ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f82b1586f80 RCX: 00007f82b087e5aa
RDX: 0000000020011a00 RSI: 0000000020000780 RDI: 00007f82b1586f40
RBP: 0000000020011a00 R08: 00007f82b1586f80 R09: 0000000001200014
R10: 0000000001200014 R11: 0000000000000206 R12: 0000000020000780
R13: 00007f82b1586f40 R14: 00000000000119fa R15: 00000000200007c0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
