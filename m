Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F359B21325F
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429988; cv=none; b=mI+uGD5iNiSjkShWFG5Y4Si/ywc4wzsheBbq8CgDUiLirJZsXx3PDIi5ccXEdjZh+G0En8eGq0PCk2esfMbllVVaWjBIHSqnuCR4+Cn7JKzIcWqA6VrKZjLJoCvQOY0G/7ucPzZsD1Z6Q7focjms5wae7IiyOod6kkODTLLJsn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429988; c=relaxed/simple;
	bh=o58API7/MSUGGecLyCQOD9QENF0cJpxOJUXTJvS/ZY8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=i2TWCyDnawsKuDNJKFvvLmIJtuOZMT0eqF8huxUPQjBvmW2qsacvNsdsqzpOmnTa+Hgr6NIfYJYzwVoZj1bh6kvZsufR6IQ4VtHY7fyJkAKOnzmulGpuQOTNA6phUxSDZvc/d0QRdX/AEaHCgPYa8FDh4iVqanGTG34C2A592kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d43d3338d7so85367155ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 07:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429986; x=1744034786;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZOpejcwMdppDg0dMAfgX7XGjKXOhvdEBn+I8f9/ikIE=;
        b=TKhaNWFq9mOxxoOfsysri4TqZEzHl94EUPEqI80QwK8ON43Pjcy1RvmYNSCS3p92zQ
         ISVd/RYyl/29FSnf/zOZMty/Hcc4hs2FZfp/aA9JgZCZpmZ341k4pS0pWyfNaYG3Hop8
         8ClDJKSzCDOq+ndHN2y9dcKsRzFgKmnWGzf4tcfE5aw17YneCGQPZ5CmKB9HSKa21HUA
         K2HrYitw9MsXUJNuWCfrf8YFgONxn3/6pUstkVTzdDoMvX0nbZWdKcau3GolQjYszQ4o
         HGTrWwIEUnqnQEDp5YeqpIXw9JLKnDAepM6TwpTXse+6iP2cAu5I/tokZ9Ug+qlZz6OW
         JqxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH3twpGAG8sA0n1wOe1IPiImhFHtT9Gd9Y6HGUhvkBFhyk80JWcF+C5hj1s7cWCOYclx1BUjoNqFtT4YnDig==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmyGPmA70JYMynd9OjKRHOHg2Gh7O+HpI/UP0rXJJE6Z0Gjkcf
	FQf1mtYyB7nmAskCdXEZr5FDCfcbqUtAorC03PsWiD+MinNgQLZ4kBwTLx/K9E9g1zMllaNadIq
	qgbSe2LFl5mZBJCWdrXlmNt+kPBKweCnvBgA1KKHJ8A5DVu0piUYRgkA=
X-Google-Smtp-Source: AGHT+IG9VYXT62i/paAthE79LI4prD6ZoYlm+FBsFiCPSC2k5ramWsYpdiQMy93RazuRM1LZUhDWiDp8RWJDF0196YBhBQyBNUXr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1544:b0:3d3:f4fc:a291 with SMTP id
 e9e14a558f8ab-3d5e0a01a36mr78412185ab.19.1743429986078; Mon, 31 Mar 2025
 07:06:26 -0700 (PDT)
Date: Mon, 31 Mar 2025 07:06:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67eaa162.050a0220.3c3d88.0044.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_copygc (2)
From: syzbot <syzbot+cebfe3f22eeaff4ddd7c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1e1ba8d23dae Merge tag 'timers-clocksource-2025-03-26' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a8ede4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=887673359f1a92bf
dashboard link: https://syzkaller.appspot.com/bug?extid=cebfe3f22eeaff4ddd7c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/97b3a10186d9/disk-1e1ba8d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/de4a9446d205/vmlinux-1e1ba8d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/529352453703/bzImage-1e1ba8d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cebfe3f22eeaff4ddd7c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
BUG: KMSAN: uninit-value in __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
BUG: KMSAN: uninit-value in rhashtable_lookup include/linux/rhashtable.h:646 [inline]
BUG: KMSAN: uninit-value in rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
BUG: KMSAN: uninit-value in bucket_in_flight fs/bcachefs/movinggc.c:143 [inline]
BUG: KMSAN: uninit-value in bch2_copygc_get_buckets fs/bcachefs/movinggc.c:169 [inline]
BUG: KMSAN: uninit-value in bch2_copygc+0x1d5c/0x5e00 fs/bcachefs/movinggc.c:221
 rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
 __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
 rhashtable_lookup include/linux/rhashtable.h:646 [inline]
 rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
 bucket_in_flight fs/bcachefs/movinggc.c:143 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:169 [inline]
 bch2_copygc+0x1d5c/0x5e00 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7d2/0xf80 fs/bcachefs/movinggc.c:383
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Local variable b214.i created at:
 bucket_in_flight fs/bcachefs/movinggc.c:-1 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:169 [inline]
 bch2_copygc+0x159e/0x5e00 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7d2/0xf80 fs/bcachefs/movinggc.c:383

CPU: 1 UID: 0 PID: 5998 Comm: bch-copygc/loop Not tainted 6.14.0-syzkaller-03576-g1e1ba8d23dae #0 PREEMPT(undef) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
=====================================================
Kernel panic - not syncing: kmsan.panic set ...
CPU: 1 UID: 0 PID: 5998 Comm: bch-copygc/loop Tainted: G    B              6.14.0-syzkaller-03576-g1e1ba8d23dae #0 PREEMPT(undef) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x216/0x2d0 lib/dump_stack.c:120
 dump_stack+0x1e/0x24 lib/dump_stack.c:129
 panic+0x4e5/0xcf0 kernel/panic.c:354
 kmsan_report+0x2ca/0x2d0 mm/kmsan/report.c:218
 __msan_warning+0x95/0x120 mm/kmsan/instrumentation.c:318
 rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
 __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
 rhashtable_lookup include/linux/rhashtable.h:646 [inline]
 rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
 bucket_in_flight fs/bcachefs/movinggc.c:143 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:169 [inline]
 bch2_copygc+0x1d5c/0x5e00 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x7d2/0xf80 fs/bcachefs/movinggc.c:383
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


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
