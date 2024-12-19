Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8D1CC8B0
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 23:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651516; cv=none; b=B1MuKVz+G1Tyxwp4jsEvQXoRhpIODcjI+fM+Ug3G4R2clWe/vWCO3pu/PPB1R6mz6e4HaaCMmuZPAOEl6usCjInzL+38ivEEotxE5CkwiEYgLtXCfZlCDbKc07is2Za8Est5KCBsTDk9pnnZ5iq/opkRyTd7vBHAp0BPv0wWDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651516; c=relaxed/simple;
	bh=POVcfqsQW1F44uBMvsKaYySXOSSd/6O51T5O+igNI0o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tJf2X8BmnbmKnIBx6ccEVbYYwBHk//OifY6NEpVdO2CF/XMaG17B5L6fN4kJKM7RrkxgNdgxTcigiEQeyMrhKot57apaRZf2sTQAsz8KWeqGyu+pw2DF330w9jWeLIJJRG6G63tXaco/PFFqDBAwPiGeKTCf4/bjpGq3qx0FNfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso28302015ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 15:38:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734651514; x=1735256314;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uJzOKvmEpHJwKjMwlCRk73BI33LMvtQvtjiFkVcoXuU=;
        b=tNEYwk/nfN5+845yTy+3+RrXYGagfZ8G3dDPkjTXtyj2vgJu6aZgnIhvjSPSXinZ68
         PylRjZGiY7xqqKt0FzQjLG34bm2Vs51AbuQbRusFS697E0ZH5j39thmFu45M0qRUeEcn
         bMb5LkCoCiUtgAxMzhCwKM/xFemRrJ2DSeAXx6Pfd/x+kAhHH94DSA2nGALctAfmDgN+
         Fi8MnzbEDxg4sKLEJErQgw6jc65H1vLJWghPe+E4ox1NHokZeFdhb/p6snzxEXP0NQc0
         HziuLtFuCDGrooqhW/FGcxp6fFjO+N4elzHYwAhE+ryyK1WOl3/YDl3h3slgXH1O5LWV
         OVYw==
X-Forwarded-Encrypted: i=1; AJvYcCWVravAkA/wXukn1ksuisGUmXUHQjc/1a+piz64cONu+/oOt2PfzucWafolflSn8s6KsJRDFQKmB2N2apQiuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDaavdUpuYATDk/AKhhMy69Ug0OnQT0S/AZIRvkD0zvPaDfE/a
	bUPj8cAirzexZDRj8LnjXF4qBwiGL2lxU1LVAvfQbArn8eb5/l2QPHraZT8j2mVCsJQcs/xeN0g
	fAcyBqG/sOPDOLCIAJfwyDUJXR/g5gvYMS7Q5g2LqL1jOuRFUHhMvKU0=
X-Google-Smtp-Source: AGHT+IF8jSSZWvcsQxeMwokgkW/OgWhA+hljNo9xTBlGPGM0advTeCm8YWW6PPGQ5ZizMZhXW2VcyFEG8Tg1UQ+DPdrLC8yW1NuO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:3a7:4826:b057 with SMTP id
 e9e14a558f8ab-3c2d591996emr8548195ab.21.1734651514118; Thu, 19 Dec 2024
 15:38:34 -0800 (PST)
Date: Thu, 19 Dec 2024 15:38:34 -0800
In-Reply-To: <670bd8cc.050a0220.4cbc0.0031.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6764ae7a.050a0220.36de9c.0001.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel panic: bcachefs (loop3): panic after error
From: syzbot <syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8503810115fb Add linux-next specific files for 20241219
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12200fe8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26a4b4cc7f877b28
dashboard link: https://syzkaller.appspot.com/bug?extid=e6ea15c610261d2106ba
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116462df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aaf730580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8e84022cbe98/disk-85038101.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/112a23063d67/vmlinux-85038101.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3778558f0562/bzImage-85038101.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ca00766e5d34/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com

bcachefs (loop3): starting version 1.7: mi_btree_bitmap opts=errors=panic,metadata_checksum=crc64,data_checksum=none,compression=lz4,background_compression=gzip,no_splitbrain_check,nocow
superblock marked clean but clean section not present, shutting down
Kernel panic - not syncing: bcachefs (loop3): panic after error
CPU: 0 UID: 0 PID: 5901 Comm: syz-executor172 Not tainted 6.13.0-rc3-next-20241219-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 panic+0x349/0x880 kernel/panic.c:354
 bch2_inconsistent_error+0x146/0x150 fs/bcachefs/error.c:28
 __bch2_fsck_err+0x10de/0x1420 fs/bcachefs/error.c:438
 bch2_read_superblock_clean+0x166/0x260 fs/bcachefs/sb-clean.c:156
 bch2_fs_recovery+0x1e6/0x3de0 fs/bcachefs/recovery.c:707
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1032
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2200
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3556
 do_mount fs/namespace.c:3896 [inline]
 __do_sys_mount fs/namespace.c:4107 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4084
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb599d79a6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe81ab3658 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb599d79a6a
RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007ffe81ab36b0
RBP: 0000000000000004 R08: 00007ffe81ab36f0 R09: 0000000000005951
R10: 0000000000000000 R11: 0000000000000282 R12: 00007ffe81ab36f0
R13: 0000000001000000 R14: 0000000000000003 R15: 0000000000000000
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
