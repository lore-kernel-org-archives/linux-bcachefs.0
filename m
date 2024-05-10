Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320064207D
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 May 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715380589; cv=none; b=RsnxceCF/Qm1b6ugZq6L4scAw3bHdBjqzeoK0UZQxCfmCBjNxhWyxVWvmnMOXL6pSYFfKSzd4TY4ih+d2YyMcKtRu5OcwH43SwCOLtYPaQWEK+LYQVHsrkM/hu+PEixS3mUGA92Ye+UHOjjjEvGRtuD3F4KOqQLszM3nWqZPaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715380589; c=relaxed/simple;
	bh=HBYzTxGb1feW0hvGlmK9jvD8v0MOy9a+pORuCqg4diM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LvqrG4bao8d5NEiJqwUxVKmrwuxE+hHT5EZSU5nCLacrPawe2WPYV0vufiksmbEumICXTN61fzRQ32o4w6dCzT9C/bIRxMFrcX9IEM4fXMI/Tb9OuoPZAFU+MYPq15xScgnjzG/B65/cOoD0RyMlgk8tELExdKzZpA/k/miGYso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-36cc59b06a1so10273745ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 10 May 2024 15:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715380587; x=1715985387;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z8jYuWSv5DCkOYW/uJpzuWdX9C0xP+JwKPmlwZkVzY0=;
        b=d11qWxWnL4i4ZQQalYPu/GBoUb04xFncBhgz9vb0A9+EZoJzZA16+wXTADmgZL/YHA
         GkWcNoaoOYTaFv6DAMKbyndvrMzS5Q6KZYSU80HAdl3+02C9vT3DS5+LU6/RIbjlhcoR
         3jtfPfAIZTRq7ec22THwHgxjBlVmxpF3HgDN6uZwbisS6oyxcgKRHCeoaqCh8BBlInNl
         fZ22qxGfQo2ozE+pS9vrEUEc2x8L/TKYkhBdjWNTvVS/dtS02vtJSp4LaKb2g99N3E/Y
         6Zo7nsO7UfjFr/hjiioHbatqRi3S3MbAsjBkVST9MJunjTPonsoOFtRMGZBdQHZo2ZUU
         HNDw==
X-Forwarded-Encrypted: i=1; AJvYcCVgGzgZKftTUDUgY5pNIJ0yt4KR1QmD4bjfVtsrf/CDIDNsE0Wys3dSb6J/5Dvl2uIGl107VSOo3KXEaUQs9zstnoCnisNgpZzJq/63ywI=
X-Gm-Message-State: AOJu0YwG4sdmt9/WhNy5pnjh+TuP/GfkZcq2xaV3I9N61v4h4fKoiaGw
	q3QddGdRTPp4qEoB7AD0rbAabp6K3SDY4bg49aNXLLcn2Wwh1QUF46LQpUBYIuInz0ZBWdtxvaK
	eAPakNcU2IPRWxm9hc0U0GrZF6qeaaG3OGj1eI1znsynH5srrWMVd68s=
X-Google-Smtp-Source: AGHT+IFau/9e0ITa3ik3afa1z66qke/vU41DYIN1UCaIwCPmJK9IriUqqRRGUEgA/Q9gdO5Y6SEf3qCO6OYRHrNEanvGLKVMCIUx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:4b06:0:b0:36c:5029:1925 with SMTP id
 e9e14a558f8ab-36cc1385589mr1150845ab.0.1715380587387; Fri, 10 May 2024
 15:36:27 -0700 (PDT)
Date: Fri, 10 May 2024 15:36:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090ebe40618212a25@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_prt_printf
From: syzbot <syzbot+4e41a25632658c77b441@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13cb8b04980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=4e41a25632658c77b441
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5ec3f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126cdfc0980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/244f301e9090/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e41a25632658c77b441@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5100 at mm/page_alloc.c:4672 __alloc_pages_noprof+0x36a/0x6c0 mm/page_alloc.c:4672
Modules linked in:
CPU: 1 PID: 5100 Comm: syz-executor185 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:__alloc_pages_noprof+0x36a/0x6c0 mm/page_alloc.c:4672
Code: a9 00 00 08 00 0f 85 12 01 00 00 44 89 e9 81 e1 7f ff ff ff a9 00 00 04 00 44 0f 45 e9 e9 02 01 00 00 c6 05 c3 c3 a8 0d 01 90 <0f> 0b 90 83 fb 0a 0f 86 6c fd ff ff 45 31 ed 48 c7 44 24 20 0e 36
RSP: 0018:ffffc90002dd6940 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000b RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90002dd69c8
RBP: ffffc90002dd6a48 R08: ffffc90002dd69c7 R09: 0000000000000000
R10: ffffc90002dd69a0 R11: fffff520005bad39 R12: 1ffff920005bad30
R13: 0000000000040cc0 R14: dffffc0000000000 R15: 1ffff920005bad2c
FS:  0000555573a66380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f740571f40 CR3: 0000000022430000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 __kmalloc_large_node+0x91/0x1f0 mm/slub.c:4066
 __do_kmalloc_node mm/slub.c:4109 [inline]
 kmalloc_node_track_caller_noprof+0x2d2/0x450 mm/slub.c:4141
 __do_krealloc mm/slab_common.c:1183 [inline]
 krealloc_noprof+0x7d/0x120 mm/slab_common.c:1216
 bch2_printbuf_make_room fs/bcachefs/printbuf.c:52 [inline]
 bch2_prt_printf+0x41e/0xa10 fs/bcachefs/printbuf.c:179
 bch2_bkey_to_text+0x124/0x330 fs/bcachefs/bkey_methods.c:288
 bch2_bkey_val_to_text+0x35/0x160 fs/bcachefs/bkey_methods.c:312
 journal_entry_btree_keys_to_text+0x1d7/0x390 fs/bcachefs/journal_io.c:437
 bch2_sb_clean_to_text+0x138/0x240 fs/bcachefs/sb-clean.c:313
 bch2_sb_field_validate+0x201/0x2e0 fs/bcachefs/super-io.c:1234
 bch2_sb_validate+0xa69/0xe00 fs/bcachefs/super-io.c:468
 __bch2_read_super+0xc9a/0x1460 fs/bcachefs/super-io.c:822
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2070
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fce02323b3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffc866b068 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fffc866b080 RCX: 00007fce02323b3a
RDX: 0000000020000000 RSI: 0000000020011a40 RDI: 00007fffc866b080
RBP: 0000000000000004 R08: 00007fffc866b0c0 R09: 00000000000119f4
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007fffc866b0c0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>


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
