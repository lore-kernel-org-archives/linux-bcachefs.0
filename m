Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4253F1CF96
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 07:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716795328; cv=none; b=WGpNGlvN5nNPZSZzSsyrIZaP7vWhzx2Hsk68ODsolPO2gtoQ6VrGIWqGjsmef3Z2bWN/qm55vV4vPPCmr96POUMX3U7Pjkx5p7Lpn654G9vycZ3IpVC9MYyWdmjYqU1jDeZV+tay34Dsd0d5djceHxzQkyp0swWdU/YBunMxlvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716795328; c=relaxed/simple;
	bh=eeICZKVVAQUBqBHwuxMALdSG+JLYmVgNYaWcBlcDvwA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BgXFX2gfvAPTSNoxsMO10azICx17jxRta8/4IJYnYOVRqvfZQ6q8Y9bqtGcWI83xXdQMvkxr8u+oaDsA8qNpEahEFZQW3nkuc6IOpGJUL1ryn5jj20eeUgvOBPXVWml6Ys0a8X5TD9JQCTwWX6nBTJi3peb/lk9xW+L09tjlDco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-37387e56a6fso22129195ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 00:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716795326; x=1717400126;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=79abVKmLZyi5X7rHFzMKI0vkfiXQgcvpYZSqXcUWH4Q=;
        b=P4OtLjqLYI8VCmATIgpwCXrHido7xjEuKu/nq0CYXfSObHXyH50ykVsNNXnmgcklAB
         nSxftmdNoKmjzd8sEC8s8ZJGh1zPSSMKsO8BqaFXxx6l58ok/EB6VAeR4tnqCZm1P6+G
         C81DEyxVUKMYqWs8yE+KInPFRZvhF4+ttRJzsOUzP3SLwQJnqcUxzuP8chdEM6412C1L
         whQmK+rJbd06WwdbQ7tEP3PuWx0/mz+DnjI2IWiMuqWL8f4ZLXs+lT3Llmt/Utpwn2az
         oHBKoOIxVph6k42TndE7oPtOxW32a8GGbcS5Z6rlQevAGIHLbFi/sxWMz2yf0iIZcf71
         chBA==
X-Forwarded-Encrypted: i=1; AJvYcCWX+cIONNYbTGOSw1UCOKxUfTkDbAxA/nDg3wPEljocWFBJWH9sJGMBGoiYMln9KX4UzN3T62MYRGkqFkjjX1TKRNu9JwMCNKuB3/TPPQA=
X-Gm-Message-State: AOJu0YxkF+BMgBsdUsOEntyfx9/6VNIA46HWOwbzaAhecGAMK8/uenSV
	e4d/mSWVbEMFBo9K+FffjCdwhlyOCMhofrZaTlH6Zw/53AMRBcykQ6QWv3dX8jvlxWnns4o1ty7
	zZa3ep9jt+wnn9YWTWxdsp0sMJ3XrLf9N5Xy+ZOk1q7QdA+CCcSp/a9s=
X-Google-Smtp-Source: AGHT+IEZ40ydocE6/9QamDqGIURiJPf/WWQlDbNFNA6RWdOGgOwv0xkSMcZ0tSV4YMUdS3sB+LclCE9VJ2H0bpXFVx4I0sXz9W07
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8f:b0:36d:d06c:5c10 with SMTP id
 e9e14a558f8ab-3737b3ca0aemr6186765ab.4.1716795326502; Mon, 27 May 2024
 00:35:26 -0700 (PDT)
Date: Mon, 27 May 2024 00:35:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000096a88206196a8f03@google.com>
Subject: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in srcu_gp_start_if_needed
From: syzbot <syzbot+8cb7ea0ddb1cdc8a21fc@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f16eb0549ab Merge tag 'char-misc-6.10-rc1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c46072980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f4625418c9ed5c8
dashboard link: https://syzkaller.appspot.com/bug?extid=8cb7ea0ddb1cdc8a21fc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-5f16eb05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/20ac83ea5f8c/vmlinux-5f16eb05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/31519c4f23c8/bzImage-5f16eb05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8cb7ea0ddb1cdc8a21fc@syzkaller.appspotmail.com

------------[ cut here ]------------
==================================================================
BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:646 [inline]
BUG: KASAN: global-out-of-bounds in string+0x398/0x3d0 lib/vsprintf.c:728
Read of size 1 at addr ffffffff8b2e4842 by task kswapd0/111

CPU: 3 PID: 111 Comm: kswapd0 Not tainted 6.9.0-syzkaller-11919-g5f16eb0549ab #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0xc3/0x620 mm/kasan/report.c:488
 kasan_report+0xd9/0x110 mm/kasan/report.c:601
 string_nocheck lib/vsprintf.c:646 [inline]
 string+0x398/0x3d0 lib/vsprintf.c:728
 vsnprintf+0xc67/0x1870 lib/vsprintf.c:2824
 vprintk_store+0x3a2/0xbb0 kernel/printk/printk.c:2225
 vprintk_emit kernel/printk/printk.c:2326 [inline]
 vprintk_emit+0xac/0x5a0 kernel/printk/printk.c:2300
 vprintk+0x7f/0xa0 kernel/printk/printk_safe.c:45
 __warn_printk+0x181/0x350 kernel/panic.c:740
 look_up_lock_class+0x132/0x140 kernel/locking/lockdep.c:932
 register_lock_class+0xb1/0x1230 kernel/locking/lockdep.c:1284
 __lock_acquire+0x111/0x3b30 kernel/locking/lockdep.c:5014
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __raw_spin_trylock include/linux/spinlock_api_smp.h:90 [inline]
 _raw_spin_trylock+0x63/0x80 kernel/locking/spinlock.c:138
 spin_lock_irqsave_sdp_contention kernel/rcu/srcutree.c:373 [inline]
 srcu_gp_start_if_needed+0x75e/0xf00 kernel/rcu/srcutree.c:1233
 bkey_cached_free fs/bcachefs/btree_key_cache.c:90 [inline]
 bch2_btree_key_cache_scan+0xb90/0x1820 fs/bcachefs/btree_key_cache.c:886
 do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
 shrink_slab+0x18a/0x1310 mm/shrinker.c:662
 shrink_one+0x493/0x7c0 mm/vmscan.c:4790
 shrink_many mm/vmscan.c:4851 [inline]
 lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4951
 shrink_node mm/vmscan.c:5910 [inline]
 kswapd_shrink_node mm/vmscan.c:6720 [inline]
 balance_pgdat+0x1105/0x1970 mm/vmscan.c:6911
 kswapd+0x5ea/0xbf0 mm/vmscan.c:7180
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

The buggy address belongs to the variable:
 str__rcu__trace_system_name+0x922/0xb40

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xb2e4
flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000002000 ffffea00002cb908 ffffea00002cb908 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffffffff8b2e4700: f9 f9 f9 f9 00 00 00 00 03 f9 f9 f9 f9 f9 f9 f9
 ffffffff8b2e4780: 00 00 00 00 00 00 01 f9 f9 f9 f9 f9 00 00 00 07
>ffffffff8b2e4800: f9 f9 f9 f9 00 00 00 03 f9 f9 f9 f9 00 00 00 06
                                           ^
 ffffffff8b2e4880: f9 f9 f9 f9 00 00 03 f9 f9 f9 f9 f9 00 00 00 00
 ffffffff8b2e4900: 00 00 00 00 00 00 04 f9 f9 f9 f9 f9 00 01 f9 f9
==================================================================


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
