Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19B61448E4
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715694999; cv=none; b=f9QEXEan2bKvVcDvX2nJ9UoZdxCIdroPU7QBoktD9rUdZN589DEOuUMFqpfEdOtCIXNcA+74GC7icP0xztZMqbuc0YOgmOvaua788gltSFvA34mc8LuzFiBuNINXDYpXGei/QYV9KXNPp+DZEQ6gN9kfxXFcPrMgJCbhLf6l21s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715694999; c=relaxed/simple;
	bh=nfzLjkF+O8VbA9hAeacLykxNwCTkL1GjlRWOA4oAN7E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JaNwXG3Lg9NKd5yZmNwSNJKsLEfAgH6fJ0CylRGeYRQSt97HJKYuz3iwyY1Gb5FcJNYiL2W9Ca9q2c0DqBj4rn9xcOB7QvojCCuUns2Dx6aBMxpmuCBopyqhUb1qZsTWD75U4yqYyR9eR5tQjmvWSRA9x5vF4x1wt9jHgFeCSuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7dec4e29827so627463639f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 06:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715694997; x=1716299797;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9QUw4znG6Zkd8t2vNAPl8dtkMYXTahCd/CeAkVBkiM=;
        b=P/rF4NUIi6OFc0xOZS/TPoXVbL8cJzAlk3M1yrguUYlPDlY0xg91eklfB+soKR5V//
         F2BLZaJasKamqL+MX7IJTbvGjZ5ajVENZsmqVRdj/cfcgqth1ok9b3nVUW1Q3B8fQy/o
         cujg9KTrlHV8GHAxpJgAZ7Nwhb7iEwD+DXQJa16nu2JKxDbT/Jk4mS49OKepufDiO3DQ
         GF3rLXo17RYddVZAIyeM1YKljAgtmIu4bK6oSW9MVwpJWuCXQ/XFeXxt2ZcIPRXjlEkq
         tn2XbLCZ8x5OYG/XgnnrvlafmdzHt+0X+cOoIivIy/Yze0WWIzp8fvXNFMRNs6Wd/0Pu
         rynA==
X-Forwarded-Encrypted: i=1; AJvYcCX5Bs6LbfStsKFd2zkB3t4DhncEtGtJN6etwdFHna43SKTKkx+RE8LcIpbOkaZpcLfXVsYAmuVDUA38gUi35M/Jc7TK0QstRXezrswRh0o=
X-Gm-Message-State: AOJu0YzLH1MWlK94QB3K9x8vNc+xLuAk/vmDacRI3JuCFeilqItfQoVV
	Yq/z/QvU2T178xl0SZ2jthIbDHNFaujSJNUVe2HVC613FIwjJnBqse6NxJjAnWpl94izdraqEtg
	mslTVKah9FnkpA/TbJKJff+y6EbvIip7+IpH3g14ARrlPO5jenaNOYjk=
X-Google-Smtp-Source: AGHT+IED5GuYc/qycmxtnmG7IVsKchSO7/U6U0CF4NI/ZjmKXd3MDNYX2hRo9e8zFu9h+VckKMNmgORYNG3u4W5ovnf3QDJFpzwv
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8696:b0:488:7f72:b3b0 with SMTP id
 8926c6da1cb9f-48959031a96mr610608173.5.1715694996552; Tue, 14 May 2024
 06:56:36 -0700 (PDT)
Date: Tue, 14 May 2024 06:56:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d00dce06186a5efc@google.com>
Subject: [syzbot] [bcachefs?] KASAN: stack-out-of-bounds Read in __bch2_encrypt_bio
From: syzbot <syzbot+fff6b0fb00259873576a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17a13f70980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=fff6b0fb00259873576a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1679303f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a2743f180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/134862d610aa/mount_0.gz

The issue was bisected to:

commit 023f9ac9f70fbb1d94d27583fc06225355c73a67
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Dec 20 02:58:20 2023 +0000

    bcachefs: Delete dio read alignment check

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130be15c980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=108be15c980000
console output: https://syzkaller.appspot.com/x/log.txt?x=170be15c980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fff6b0fb00259873576a@syzkaller.appspotmail.com
Fixes: 023f9ac9f70f ("bcachefs: Delete dio read alignment check")

==================================================================
BUG: KASAN: stack-out-of-bounds in sg_mark_end include/linux/scatterlist.h:258 [inline]
BUG: KASAN: stack-out-of-bounds in __bch2_encrypt_bio+0x84d/0xb10 fs/bcachefs/checksum.c:355
Read of size 8 at addr ffffc900001176a0 by task kworker/u8:1/12

CPU: 0 PID: 12 Comm: kworker/u8:1 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Workqueue: events_unbound __bch2_read_endio
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 sg_mark_end include/linux/scatterlist.h:258 [inline]
 __bch2_encrypt_bio+0x84d/0xb10 fs/bcachefs/checksum.c:355
 bch2_encrypt_bio fs/bcachefs/checksum.h:97 [inline]
 __bch2_read_endio+0x8ab/0x23c0 fs/bcachefs/io_read.c:601
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

The buggy address belongs to stack of task kworker/u8:1/12
 and is located at offset 1120 in frame:
 __bch2_encrypt_bio+0x0/0xb10 fs/bcachefs/checksum.c:72

This frame has 5 objects:
 [32, 48) 'nonce.i115'
 [64, 528) '__req_desc.i116'
 [592, 608) 'nonce.i'
 [624, 1088) '__req_desc.i'
 [1152, 1664) 'sgl'

The buggy address belongs to the virtual mapping at
 [ffffc90000110000, ffffc90000119000) created by:
 copy_process+0x5d1/0x3dc0 kernel/fork.c:2220

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x17297
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_ZERO), pid 2, tgid 2 (kthreadd), ts 2480284041, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1468
 prep_new_page mm/page_alloc.c:1476 [inline]
 get_page_from_freelist+0x2ce2/0x2d90 mm/page_alloc.c:3438
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4696
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 vm_area_alloc_pages mm/vmalloc.c:3567 [inline]
 __vmalloc_area_node mm/vmalloc.c:3643 [inline]
 __vmalloc_node_range_noprof+0x9a4/0x1490 mm/vmalloc.c:3824
 alloc_thread_stack_node kernel/fork.c:309 [inline]
 dup_task_struct+0x444/0x8c0 kernel/fork.c:1115
 copy_process+0x5d1/0x3dc0 kernel/fork.c:2220
 kernel_clone+0x226/0x8f0 kernel/fork.c:2797
 kernel_thread+0x1bc/0x240 kernel/fork.c:2859
 create_kthread kernel/kthread.c:412 [inline]
 kthreadd+0x60d/0x810 kernel/kthread.c:765
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
page_owner free stack trace missing

Memory state around the buggy address:
 ffffc90000117580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc90000117600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffc90000117680: f2 f2 f2 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 00
                               ^
 ffffc90000117700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc90000117780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


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
