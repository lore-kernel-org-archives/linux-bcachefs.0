Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6F82137F
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 May 2024 08:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715330742; cv=none; b=VGStx/LZxCk8IEzNuczJIaiRBsECuYg6JFdEYOHDPOqjNrxaNLL0TCdNPRnEahrYhky76SPWCJcxebwB5yyctByZ17cd53qxkazp78jJyiLFhG1CJg38Td1/3fhLKWPGJJIhn9/q9VIfCRQhF11W51jhcuH0iE6xvj6S33E8tZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715330742; c=relaxed/simple;
	bh=BDF9cgmrLahewf/VVc/0cj9BYwYmheq0Yy4oWYazeTI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Go/JOFNQMLnvleNa6ErwMEr54DGVuIGVG2j3gkk6bOGcKZjVrbF80X5+3eeZrA4GuGRqEa8tETXBZps3PQkmsFKVbFCFcCIEWD90qATtLhxSSdCrHaVFX2lzif7OUPKTO7KVGWWA/QcuNw9EwLS4+sMKgnr/BAFnw0/sD9kzBhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7da52a99cbdso171421039f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 10 May 2024 01:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715330740; x=1715935540;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRsm4pB8/VaBHzboVqr2bGRZ82LTcrxc7Q0z4o++KUY=;
        b=F2wQFr0gMC2htP0iOfngnU3B9JUnY9PJJkbx9eINf3hUwakchAY7oKs0E9jSGPWXSs
         DRNEq2041EP8y0LwOrEs6g2TSVvTMs9ulCoa1T7LTqGgJ2oX/81RIn43NwJsnVu76hyf
         sHIWhx1wD3teB+eqwrhBeUkiu+fs4kWfezbv6+zJsCYJlDGfDAKPCh9tlKKsZ7cOvsi1
         F1nwNgxzR0cXym93X3AcgM30HeXO+jqUYQXTS0AfYM/0Ua+mjRqXOyaxGej2OM/VsY/l
         dcGbiZUgrx8fPfcV2H5hX9IzgwK0Z1e+YkxUIbxt44BApVv734Cj4kukvDhL9xTN+RUq
         md6A==
X-Forwarded-Encrypted: i=1; AJvYcCVLmyJVU6PN36lpbcutgTyIc0iNDeF5fhfosSkqwoBX24zBifY+WjmA9yD0f8ZGywmLD5eimahkpNgqi1Y37iDZAZVZy4JcKrLkBOMm3bA=
X-Gm-Message-State: AOJu0Yy0haDePGqKPg/6/nO/S7zV83Fk/NFJYIE6+D5MvWxenfoUjS8M
	yv4NDMls16BfrsEMFBXnbY7o+g8+K1cjZR5864Rvu46EtFS1Pb/A4mPESMqEq3SIZsCNlY5JL4V
	fkXz7CunsAGRxZXuwfit22CD4tQDVnvhtwzJL7Ku/HTx9daMa4pu6HX0=
X-Google-Smtp-Source: AGHT+IHg7t9T26F7tFDYRm3DItP+905oKiJVpcbNJ4ZW9d5E0fpbo6m0Ht7oWITbqzPJwRlOCTsoye/G19PU4zI22UqnDD4uW4mN
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8523:b0:488:5ceb:9533 with SMTP id
 8926c6da1cb9f-48957ec306dmr135291173.0.1715330739398; Fri, 10 May 2024
 01:45:39 -0700 (PDT)
Date: Fri, 10 May 2024 01:45:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064f7a40618158fd5@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_checksum_update
From: syzbot <syzbot+8d0e17030490d2299222@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bc7d04980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=617171361dd3cd47
dashboard link: https://syzkaller.appspot.com/bug?extid=8d0e17030490d2299222
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b58970980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/232e7c2a73a5/disk-45db3ab7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7e9bf7c936ab/vmlinux-45db3ab7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5e8f98ee02d8/bzImage-45db3ab7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3f122e1fb69e/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d0e17030490d2299222@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in crc64_be+0x202/0x310 lib/crc64.c:59
 crc64_be+0x202/0x310 lib/crc64.c:59
 bch2_checksum_update+0x15e/0x1d0 fs/bcachefs/checksum.c:87
 bch2_checksum+0x3c5/0x7c0 fs/bcachefs/checksum.c:216
 __bch2_btree_node_write+0x528c/0x67c0 fs/bcachefs/btree_io.c:2151
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:829 [inline]
 btree_interior_update_work+0x3e09/0x47f0 fs/bcachefs/btree_update_interior.c:857
 process_one_work kernel/workqueue.c:3267 [inline]
 process_scheduled_works+0xa81/0x1bd0 kernel/workqueue.c:3348
 worker_thread+0xea5/0x1560 kernel/workqueue.c:3429
 kthread+0x3e2/0x540 kernel/kthread.c:388
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:46 [inline]
 bch2_sort_keys+0x1b4d/0x2cb0 fs/bcachefs/bkey_sort.c:194
 __bch2_btree_node_write+0x3acd/0x67c0 fs/bcachefs/btree_io.c:2100
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:829 [inline]
 btree_interior_update_work+0x3e09/0x47f0 fs/bcachefs/btree_update_interior.c:857
 process_one_work kernel/workqueue.c:3267 [inline]
 process_scheduled_works+0xa81/0x1bd0 kernel/workqueue.c:3348
 worker_thread+0xea5/0x1560 kernel/workqueue.c:3429
 kthread+0x3e2/0x540 kernel/kthread.c:388
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3927
 __do_kmalloc_node mm/slub.c:3960 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:3979
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_node_data_alloc fs/bcachefs/btree_cache.c:98 [inline]
 __bch2_btree_node_mem_alloc+0x2cf/0x9d0 fs/bcachefs/btree_cache.c:143
 bch2_fs_btree_cache_init+0x4d1/0x960 fs/bcachefs/btree_cache.c:479
 bch2_fs_alloc+0x33ca/0x4210 fs/bcachefs/super.c:923
 bch2_fs_open+0xd9b/0x15f0 fs/bcachefs/super.c:2084
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 PID: 3712 Comm: kworker/u8:21 Not tainted 6.9.0-rc7-syzkaller-00056-g45db3ab70092 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Workqueue: btree_update btree_interior_update_work
=====================================================


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
