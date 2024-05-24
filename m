Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7C4BAA6
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 18:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716575552; cv=none; b=PtVwLR6EdKI/62+f6DCid9qF7fhBEIT9GbyQOFsFIZbp5RNUvrHUujnkMKvchP3TOuoXprJKvRJcSGZDB8lo+uTHOTfRAG2y9ZwkiaIIhU+LWH8sZ/ZflQpfhOfjuJX67Fc9lZ/Hc23mw4X2w7QRIdgJplBWWygXGZ28w6e/Oms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716575552; c=relaxed/simple;
	bh=5MXfzijCDxxd9H2vbtmW/rXJvVpjV24Vzf6RoShmVSs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BXanY1gO1x8J0mhow1dTIU1gdpHkitYKVuUwxdDBVG+/MWlzfKWbjLoz/gqMKtK8vCl0tJr2+3+ld/uV1ikJEUHbylQcrF+HviaZK2arBOrLZ2JQ+TyZVk6tEFhlupGQhSHxPI8rX5Gorwg+srVZqzUMgb8MqpFoY0btG8lVLbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3738836578aso4373555ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 11:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716575550; x=1717180350;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJFC2Vp+rWFXQVgcfqBh2caRcHKCyQVUV0kVjLLEKE8=;
        b=pVaw0xVzEk6VM9CQamhD6Zq0joQrGo/84N2XYU5AR8L+TeyML5sqXBSw92QXIpk/C0
         ySn1rPmkNukHdwcEEnG/DWrjJU4DjWDQR5hJcrH1NIEl+IdpMpm1fRq7ZQrijdj6ugwn
         G0W5Hnmt2vg26wS+xnVMwQr5923hkkk7TyUP1NYQWgenOCCNHVJUCvB8pILXg9Po+MdE
         bILJuPzZQoW1vm3xWzxVzcHPMHfuEtPnMMsTWqyDa/UnjkT9JPovcigdKUKe03oN0DiC
         HX9CviFpgn7pQ2JVsZczTEEPso/EZgFuhUc4Z908OiXAe8YjjCTzxw36LahEDQggR0pF
         lvxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtpAqY7pgDVBWki/oYJ+w9y2QPhgZKP9QkgVz90tqzZAJaFp0yMCVMEWJqCDf3sbysO3nZgOhZ1+XqnV9t+e9yYZMy0d6l1G3X4K94nQ4=
X-Gm-Message-State: AOJu0YyzvUzBda5DOnvZO2LzFsKj4U71brfu4Ru6Pq33lal07zUbFtrT
	9zgG+C/fPTR682cb1iMTp/HJalh/09bUU+IIk0NyAMy3NFkuoUUMcAOWYETkv1Vp/h+2V7uqu/m
	2oVkmr39Xk+uKr4CM9gMBtW6qX+MMEuy/EWJor2CnNJJntOyh/Wg8O7k=
X-Google-Smtp-Source: AGHT+IEKxxixXWBBy0y31Py2QAi2pheZfRTMqqkxOxSHSK0tLbc/vxD4b/AbQd9TpQe7LuJ6tsFYsIPOLQ1ft63kzemsYE1WE5Qm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1563:b0:36c:c4cc:80e2 with SMTP id
 e9e14a558f8ab-3737b41c396mr1970395ab.6.1716575549869; Fri, 24 May 2024
 11:32:29 -0700 (PDT)
Date: Fri, 24 May 2024 11:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e15f4b06193763db@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in rw_aux_tree_set
From: syzbot <syzbot+681f3c43b6970652376b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10eb00ec980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=681f3c43b6970652376b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+681f3c43b6970652376b@syzkaller.appspotmail.com

bcachefs (loop0): snapshots_read... done
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
=====================================================
BUG: KMSAN: uninit-value in bkey_unpack_pos fs/bcachefs/bkey.h:455 [inline]
BUG: KMSAN: uninit-value in rw_aux_tree_set+0x4d2/0x580 fs/bcachefs/bset.c:521
 bkey_unpack_pos fs/bcachefs/bkey.h:455 [inline]
 rw_aux_tree_set+0x4d2/0x580 fs/bcachefs/bset.c:521
 bch2_bset_fix_lookup_table+0x16b2/0x1e90 fs/bcachefs/bset.c:995
 bch2_bset_insert+0x1617/0x19f0 fs/bcachefs/bset.c:1042
 bch2_btree_bset_insert_key+0xf56/0x2b70 fs/bcachefs/btree_trans_commit.c:194
 bch2_btree_insert_key_leaf+0x276/0x1050 fs/bcachefs/btree_trans_commit.c:277
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:744 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:854 [inline]
 __bch2_trans_commit+0x98e6/0xab10 fs/bcachefs/btree_trans_commit.c:1093
 bch2_trans_commit fs/bcachefs/btree_update.h:168 [inline]
 __bch2_create+0xe93/0x15d0 fs/bcachefs/fs.c:327
 bch2_mknod fs/bcachefs/fs.c:451 [inline]
 bch2_create+0xdd/0x1e0 fs/bcachefs/fs.c:465
 lookup_open fs/namei.c:3505 [inline]
 open_last_lookups fs/namei.c:3574 [inline]
 path_openat+0x2d74/0x5b00 fs/namei.c:3804
 do_filp_open+0x20e/0x590 fs/namei.c:3834
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __x64_sys_openat+0x2a1/0x310 fs/open.c:1432
 x64_sys_call+0x3a64/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
 __do_kmalloc_node mm/slub.c:4027 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
 bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
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

CPU: 0 PID: 5149 Comm: syz-executor.0 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
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
