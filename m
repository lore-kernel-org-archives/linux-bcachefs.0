Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24418651
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 05:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729141411; cv=none; b=nTPV08VYqublapszEsxG2Eykt3MRttBfpbX4fq20wlet8y07Ym3DaGuiOWxq4fw5bEqbbp+MPGbnCn/ywoqWnwc/A5aJNRPi7I+9ohyCYNUgKPTmZzdswALgxBgCBT0ga8T/Is/ovXWLAJqyvdDNtMIBfH/xeCE/LbpjDl4enIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729141411; c=relaxed/simple;
	bh=vpvtcgmIZHO18G5BBJBL7IfV1fRSrj5q8IVfBqCzu28=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JtfR8rD3hbwjhavjzam7QbjGgatqFmqT5t0v0KlxAfUK602KAq3RRizwaV9mzRCTBGp4LsLDspMDCvLR/wl8c72nJLn6vQh8MIrS/BFlSJpNa3GnZ1FS36mC/rVKGipNT1lBoZyL78clNL3w4cpeR8/PugStsHK93xJyuQuuXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3972c435dso5741845ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 22:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729141407; x=1729746207;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hj81h1R9+1O/badNaKzYflm7VykGj3DAndoTFNRlY8U=;
        b=iIACzjGUimRFdy5CPToueWHRC/v83rsyiLE91uqC3I5uTVmj3VShs1R/oo0QQoBt1t
         u8KT9DfbR/dSVUffIXe3NHD78vOu74P/Bul7jLLUdfvB1aiI/DMsQB9ET5yf8InWB8i6
         DMGmjawBEs/oqxxLLjc4bYYM6ttSF2Akinpqmvdr2/cjdnROto/dOQYX1HzXupuxlEcj
         FJZi3y7eB79kJ6utWeR6kP7eTvO8pd2R2trrzSpNWF7hdoIpGSq09EFR7KjiVzirCzdF
         EEdA15WzjMGp+0XIyzncFhfpNzbnBGvNXTl5iCjuFz6uyRP5NiFhxpbv5euPCG/Vuy8E
         3RJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0S88E4TQTQ5G6S2dGwPYpk9WYriVyuveI7AWKhavT0hoZQU9wGwLIyGRaEUP1/Je4XbVyh8rtsy2VDmVZPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeCyd3kXZx9cPtuWoHHfTUS7FwjhXwdDOIdjVMpBynZ1kQ7qXC
	DLrqQsiPacOMwmFhWc1VulN89mGRTQYaTJ4ymM9Gu8nQFjmB3XyjArkg9rk9rr5waRu/uW1IUTd
	yN2YPMqHxhx9mvYZ0O1Ah2VvlnhJWjcJxewlSSo8RfPqJ0kQs762zXtE=
X-Google-Smtp-Source: AGHT+IFqbXGuKnEc08y+ohoc53jfl2vV0B2suYnt95XOZ4geMSK1aAogT7Nz0kKDBmFOOXBIeSV+p4noT1vgRobwvFphpM4oX23c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1caf:b0:3a3:778e:45cd with SMTP id
 e9e14a558f8ab-3a3b5fbc20cmr199646315ab.21.1729141407620; Wed, 16 Oct 2024
 22:03:27 -0700 (PDT)
Date: Wed, 16 Oct 2024 22:03:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67109a9f.050a0220.d9b66.0182.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bucket_alloc_trans (2)
From: syzbot <syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7234e2ea0edd Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1219f05f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=2b6a17991a6af64f9489
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14018440580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14eb1087980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eb89ee889cea/disk-7234e2ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/088257a81962/vmlinux-7234e2ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2a15a9a5e99a/bzImage-7234e2ea.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2ea41a6e1171/mount_0.gz

The issue was bisected to:

commit f5095b9f85a1674a92d00e7ab466499a8ba49ce1
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Jan 2 00:42:37 2024 +0000

    bcachefs: dev_usage updated by new accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10b37fd0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12b37fd0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14b37fd0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Fixes: f5095b9f85a1 ("bcachefs: dev_usage updated by new accounting")

bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 1
------------[ cut here ]------------
kernel BUG at fs/bcachefs/alloc_foreground.c:489!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 5220 Comm: syz-executor172 Not tainted 6.12.0-rc2-syzkaller-00305-g7234e2ea0edd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:489 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x39ec/0x3a50 fs/bcachefs/alloc_foreground.c:644
Code: e8 29 8a f0 fd e9 f0 c7 ff ff 89 d9 80 e1 07 38 c1 0f 8c f3 fd ff ff 48 89 df e8 bf 88 f0 fd e9 e6 fd ff ff e8 35 fc 89 fd 90 <0f> 0b e8 2d fc 89 fd 90 0f 0b e8 95 2b b2 07 f3 0f 1e fa e8 1c fc
RSP: 0018:ffffc90003e851c0 EFLAGS: 00010293
RAX: ffffffff840aeacb RBX: 0000000000000019 RCX: ffff88802d549e00
RDX: 0000000000000000 RSI: 0000000000000019 RDI: 0000000000000000
RBP: ffffc90003e858e8 R08: ffffffff840abd99 R09: 0000000000000000
R10: ffffc90003e857a8 R11: fffff520007d0afa R12: dffffc0000000000
R13: ffff88807a51c000 R14: 0000000000000000 R15: 0000000000000000
FS:  000055555a922380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564dd46df160 CR3: 00000000766a2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:804
 __open_bucket_add_buckets+0x10dc/0x1b60 fs/bcachefs/alloc_foreground.c:1049
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1093
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:343 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:554
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1252
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 wb_flush_one fs/bcachefs/btree_write_buffer.c:183 [inline]
 bch2_btree_write_buffer_flush_locked+0x2aa8/0x59f0 fs/bcachefs/btree_write_buffer.c:375
 btree_write_buffer_flush_seq+0x1a43/0x1bc0 fs/bcachefs/btree_write_buffer.c:510
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x8e/0x260 fs/bcachefs/journal_reclaim.c:819
 bch2_journal_flush_pins+0x225/0x3a0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x124/0x430 fs/bcachefs/super.c:274
 bch2_fs_read_only+0xb57/0x1200 fs/bcachefs/super.c:354
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:619
 bch2_fs_stop+0x15/0x20 fs/bcachefs/super.c:678
 bch2_fs_get_tree+0xd9f/0x1710 fs/bcachefs/fs.c:2173
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f61de613dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb66b7d48 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdb66b7d60 RCX: 00007f61de613dea
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffdb66b7d60
RBP: 0000000000000004 R08: 00007ffdb66b7da0 R09: 0000000000005b42
R10: 0000000000000002 R11: 0000000000000282 R12: 0000000000000002
R13: 00007ffdb66b7da0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:489 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x39ec/0x3a50 fs/bcachefs/alloc_foreground.c:644
Code: e8 29 8a f0 fd e9 f0 c7 ff ff 89 d9 80 e1 07 38 c1 0f 8c f3 fd ff ff 48 89 df e8 bf 88 f0 fd e9 e6 fd ff ff e8 35 fc 89 fd 90 <0f> 0b e8 2d fc 89 fd 90 0f 0b e8 95 2b b2 07 f3 0f 1e fa e8 1c fc
RSP: 0018:ffffc90003e851c0 EFLAGS: 00010293
RAX: ffffffff840aeacb RBX: 0000000000000019 RCX: ffff88802d549e00
RDX: 0000000000000000 RSI: 0000000000000019 RDI: 0000000000000000
RBP: ffffc90003e858e8 R08: ffffffff840abd99 R09: 0000000000000000
R10: ffffc90003e857a8 R11: fffff520007d0afa R12: dffffc0000000000
R13: ffff88807a51c000 R14: 0000000000000000 R15: 0000000000000000
FS:  000055555a922380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564dd46df160 CR3: 00000000766a2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
