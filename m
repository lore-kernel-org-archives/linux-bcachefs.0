Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA74AEEA
	for <linux-bcachefs@vger.kernel.org>; Sun,  2 Jun 2024 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717344750; cv=none; b=flNbdQxAZ5UPgnfEngbx+rqZ6vrZI5HYn3tNbbzNAEkzG66ng0T0f1KDL+ycElPUICkBYuQqBFKmlSLV1xBBO/BAuMPFnY/iscQo43xRPqvmZHS90SwUdKtu7G1IZPsEXARjde83u6K2sa6yhIcHBhV0EXivRu2MnT/i2255UQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717344750; c=relaxed/simple;
	bh=cr4+sYC7zS0bv15s4QqxxxMivQkk3+TAJgeKs+36yXw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=T5bhvXEuaT2XsFzGqVljQG2Dk+RRpHfyuzmxH8HQGD3+vcN0ewXnkPBz+P6/1QYekvyA2S7tqQhfNMlohivkexD90lAubZwqLNynfROKbSpAs7u9pCes/XKi6cX1DsGhe86YSm/PQALhDJ8shIIc0oxy3AU5fXj7Vrlw/7+3QLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3746d2ce7e8so43498065ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 02 Jun 2024 09:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717344748; x=1717949548;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OIthNeqaR2cObPoQ3PmKTBeUyl99JAwJc3b1aUsN0EM=;
        b=RKuJeeg/Lj4pbTLJsY4ezALFbuinQISRqOPeECCyITUcTskcPAere+Y+I51y0ponyj
         bj6/ay4fvxtNIhC/V62HqDZMFRb5v9DGpor4JdlY93OUodGmpPbB68VFiFvazCAC8HWF
         +b8fxhkALnxQxPQmAubG8xAH/CMkSzvd+gwCB88LepvlZO+SAW+2gz0q+b+jNH2Q3bJi
         13ZWYV1J4wLUcJyq+41gIoqK2fh3T8Y7jBv6NXqdA3EdCXrd7EjTUtEEPu15mvvdyiHH
         oFnSln5batVl41uwfnMu5ZuoAQW+VWJAZYtP87iEJy6i6r4NhBoBVZOu2lIMgrmrCaYn
         I9oQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Mhb3oA1g0Lo5fUeMxDJcj7gK9Qx9Z38NYr1Q/M6RU1LyaBWgekitgtEbayyDGpoJuUMLcrTEZcSQ9cqYuSHKmdzviL5s1Jd/mI6wmEo=
X-Gm-Message-State: AOJu0YyFH7hZ3K68yAv6AU1Yl4IkmCJoQD9wPOSMXl433AN0jdnHD3cu
	kyVAsidtH1hmSvS1dhb5SCE38P2DuotdGMd1K1vLY4Q5l3LdFDJ6XZD/EITqkuNS4fXUV2n0NrD
	iPchD3IBDx2TCcEqhP7hKL/kjm+br/Vo2WWY4XjBc++y7DqhFQWyQKNA=
X-Google-Smtp-Source: AGHT+IG1W7wEazQlDW7CylT5GrbqP1vJgfBieXOQ1h512Fe1y52aijY6Qt7qqOiKRJgfOx9OIkELLPJmjKlRuH1u3Q5bFD6yNGdb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c4:b0:373:80a6:ba6c with SMTP id
 e9e14a558f8ab-3748b9d5b51mr5525695ab.3.1717344748065; Sun, 02 Jun 2024
 09:12:28 -0700 (PDT)
Date: Sun, 02 Jun 2024 09:12:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa690a0619ea7b3d@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_extent_crc_append
From: syzbot <syzbot+c816b9d76d3c2f738309@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15fc62b4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=c816b9d76d3c2f738309
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c816b9d76d3c2f738309@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in variable__ffs arch/x86/include/asm/bitops.h:251 [inline]
BUG: KMSAN: uninit-value in extent_entry_type fs/bcachefs/extents.h:60 [inline]
BUG: KMSAN: uninit-value in extent_entry_bytes fs/bcachefs/extents.h:69 [inline]
BUG: KMSAN: uninit-value in extent_entry_u64s fs/bcachefs/extents.h:82 [inline]
BUG: KMSAN: uninit-value in bch2_extent_crc_append+0x7cd/0x830 fs/bcachefs/extents.c:574
 variable__ffs arch/x86/include/asm/bitops.h:251 [inline]
 extent_entry_type fs/bcachefs/extents.h:60 [inline]
 extent_entry_bytes fs/bcachefs/extents.h:69 [inline]
 extent_entry_u64s fs/bcachefs/extents.h:82 [inline]
 bch2_extent_crc_append+0x7cd/0x830 fs/bcachefs/extents.c:574
 init_append_extent+0x466/0x1050 fs/bcachefs/io_write.c:701
 bch2_write_extent fs/bcachefs/io_write.c:1045 [inline]
 __bch2_write+0x53a5/0x8530 fs/bcachefs/io_write.c:1451
 bch2_write+0xe36/0x1c80 fs/bcachefs/io_write.c:1620
 closure_queue include/linux/closure.h:257 [inline]
 closure_call include/linux/closure.h:390 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:531 [inline]
 bch2_direct_write+0x290e/0x5340 fs/bcachefs/fs-io-direct.c:652
 bch2_write_iter+0x46d/0x5b30 fs/bcachefs/fs-io-buffered.c:1143
 call_write_iter include/linux/fs.h:2120 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb31/0x14d0 fs/read_write.c:590
 ksys_pwrite64 fs/read_write.c:705 [inline]
 __do_sys_pwrite64 fs/read_write.c:715 [inline]
 __se_sys_pwrite64 fs/read_write.c:712 [inline]
 __x64_sys_pwrite64+0x2c5/0x3b0 fs/read_write.c:712
 x64_sys_call+0xa4f/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:19
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 bch2_extent_crc_pack+0x686/0x6b0 fs/bcachefs/extents.c:530
 bch2_extent_crc_append+0x645/0x830 fs/bcachefs/extents.c:572
 init_append_extent+0x466/0x1050 fs/bcachefs/io_write.c:701
 bch2_write_extent fs/bcachefs/io_write.c:1045 [inline]
 __bch2_write+0x53a5/0x8530 fs/bcachefs/io_write.c:1451
 bch2_write+0xe36/0x1c80 fs/bcachefs/io_write.c:1620
 closure_queue include/linux/closure.h:257 [inline]
 closure_call include/linux/closure.h:390 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:531 [inline]
 bch2_direct_write+0x290e/0x5340 fs/bcachefs/fs-io-direct.c:652
 bch2_write_iter+0x46d/0x5b30 fs/bcachefs/fs-io-buffered.c:1143
 call_write_iter include/linux/fs.h:2120 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb31/0x14d0 fs/read_write.c:590
 ksys_pwrite64 fs/read_write.c:705 [inline]
 __do_sys_pwrite64 fs/read_write.c:715 [inline]
 __se_sys_pwrite64 fs/read_write.c:712 [inline]
 __x64_sys_pwrite64+0x2c5/0x3b0 fs/read_write.c:712
 x64_sys_call+0xa4f/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:19
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page mm/slub.c:2190 [inline]
 allocate_slab mm/slub.c:2353 [inline]
 new_slab+0x2de/0x1400 mm/slub.c:2406
 ___slab_alloc+0x121d/0x34a0 mm/slub.c:3592
 __slab_alloc mm/slub.c:3682 [inline]
 __slab_alloc_node mm/slub.c:3735 [inline]
 slab_alloc_node mm/slub.c:3908 [inline]
 kmem_cache_alloc+0x6d6/0xc20 mm/slub.c:3925
 mempool_alloc_slab+0x36/0x50 mm/mempool.c:565
 mempool_alloc+0xfa/0x530 mm/mempool.c:408
 bio_alloc_bioset+0xb7c/0x1c10 block/bio.c:554
 bch2_direct_write+0xa50/0x5340 fs/bcachefs/fs-io-direct.c:624
 bch2_write_iter+0x46d/0x5b30 fs/bcachefs/fs-io-buffered.c:1143
 call_write_iter include/linux/fs.h:2120 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb31/0x14d0 fs/read_write.c:590
 ksys_pwrite64 fs/read_write.c:705 [inline]
 __do_sys_pwrite64 fs/read_write.c:715 [inline]
 __se_sys_pwrite64 fs/read_write.c:712 [inline]
 __x64_sys_pwrite64+0x2c5/0x3b0 fs/read_write.c:712
 x64_sys_call+0xa4f/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:19
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 PID: 5884 Comm: syz-executor.4 Tainted: G        W          6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
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
