Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143F762EF
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 03:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728356724; cv=none; b=OZJ9EPdA3OEZloZrLAIJV4L8n/oYXmbZ1lBOR73CAT6nwb2g9XKfXPihiadJc55rwAqi4nN1E576UH1A6XcLal8S33lTACfFAubKRciHxdbBOMBBdW8+Ik4zV9yCJVosKD6u1OoXj2B9J16bbr7TuX/xJZ8J0juCb1IAWCXycqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728356724; c=relaxed/simple;
	bh=xgzPaapAgeL2GKG6MffSRUiz2mv0vCB7Y4qozpWQ2g8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lIvBonGPzGY1h2xqnWNej0beY1uGPbsAy9JpAg40MnfuU/un8AcKBogv8GFnFXn7OF3Iwd1oX4Xv2L6zbmx0HMr+8bxtrkjEJoxD2VxCQNQzyCdx4voocbtARUJyAUvWQMvxPnYesvxB8NwekrEOv6q4PwJmyFa6eq3oyqHUaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a363981933so75274945ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Oct 2024 20:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728356722; x=1728961522;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6hyPjBciPiuR+ISiT3/yVJJaBtBvP+OaBVaBC6WMepg=;
        b=hjUQbT4m7IMMPvi99AfIadGDrFxDqN2TKTYgH3AXE+NBdRnskT2FMoi0ORnaOUuC3A
         Rzdr36yi52QRHnaiVbY+T6FRQ3eKtgve8neTPMofT8O6aI3fs3w7SiCBdj7hGL/JP1TF
         WO/xcux4L1m6Uqs8we6tamboQAZLI8375HrhlFm95IlOLfWv36MKHh3FeCdmYaNCbSkP
         pDkOsYe6Vo6Go4ITikD3xCWZUQwrklvuDGHjoFSgAvr2/d1gc22syUnICI+B2xgxS4tv
         7VTacNIKVMKu6LZaHTQ7RElZS1HRbbKaFcN/QtBAiKx4wfHAUu+rPnhDJ+LfT1Dq4y/3
         g/TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwXwUXQmGH/fwim92wNbJycKSNhmIKorQ/rqpxti7jIe3+I4v5+vymMBzvuClAiWJR+MnFmR4ROU24im020g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Q18QCQ3n6t4PCBtA15/JuVER+rFcE3xNbEIKANp2vuXe6LPq
	ANSm/whY2IagxylSSoMCE/p43lx0EkvxW097ZoWdbZFHQDOsMSL7JaSYEqVoINFJ0RApeTL1NMb
	IBYPOHbBRU3cj/ftHa/aebAqj2IIi+xZEZMZ9tspk7+mqRvvug0gAw1s=
X-Google-Smtp-Source: AGHT+IFSYhqiML3HGY+vdcChidhHXT7E/M2c6uBf5Y0S1WFUu2+E8sza3rCYpQWRjNQUQny+jCxzcSXzD6L0bBgyG+/Zfp9Fi78h
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1846:b0:39d:2939:3076 with SMTP id
 e9e14a558f8ab-3a375bd2038mr126641345ab.25.1728356722167; Mon, 07 Oct 2024
 20:05:22 -0700 (PDT)
Date: Mon, 07 Oct 2024 20:05:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6704a172.050a0220.49194.0520.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in __bch2_fsck_err (2)
From: syzbot <syzbot+a3df02951b3139aec8eb@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10cff580580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=a3df02951b3139aec8eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d5e307980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164433d0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1341ae90d594/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3df02951b3139aec8eb@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6422 at fs/bcachefs/error.c:242 __bch2_fsck_err+0x1bc8/0x278c fs/bcachefs/error.c:242
Modules linked in:
CPU: 1 UID: 0 PID: 6422 Comm: read_btree_node Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __bch2_fsck_err+0x1bc8/0x278c fs/bcachefs/error.c:242
lr : __bch2_fsck_err+0x1bc8/0x278c fs/bcachefs/error.c:242
sp : ffff8000a4326740
x29: ffff8000a4326900 x28: ffff80008b92e200 x27: dfff800000000000
x26: 0000000000000001 x25: 0000000000000055 x24: ffff8000a43267e0
x23: 0000000000000000 x22: ffff8000a4326800 x21: 0000000000000055
x20: ffff0000dcb80000 x19: 0000000000000000 x18: ffff8000a4326200
x17: 000000000000cd00 x16: ffff800080569b84 x15: 0000000000000001
x14: 1ffff00014864cc8 x13: 0000000000000000 x12: 0000000000000000
x11: ffff700014864cc9 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000e3798000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff8000930c3640 x4 : 0000000000000008 x3 : ffff80008b41d320
x2 : 0000000000000001 x1 : 0000000000000008 x0 : 0000000000000001
Call trace:
 __bch2_fsck_err+0x1bc8/0x278c fs/bcachefs/error.c:242
 __bch2_bkey_fsck_err+0x7b0/0xea8 fs/bcachefs/error.c:436
 __bch2_bkey_validate+0x554/0x768
 bset_key_validate fs/bcachefs/btree_io.c:843 [inline]
 validate_bset_keys+0x724/0x1204 fs/bcachefs/btree_io.c:914
 bch2_btree_node_read_done+0x1a64/0x4ab4 fs/bcachefs/btree_io.c:1134
 btree_node_read_work+0x50c/0xe04 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x1f50/0x280c fs/bcachefs/btree_io.c:1708
 bch2_btree_node_fill+0x8cc/0xfbc fs/bcachefs/btree_cache.c:886
 bch2_btree_node_get_noiter+0x7fc/0xbec fs/bcachefs/btree_cache.c:1155
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:190 [inline]
 read_btree_nodes_worker+0xdcc/0x1980 fs/bcachefs/btree_node_scan.c:239
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
irq event stamp: 310
hardirqs last  enabled at (309): [<ffff800080a88010>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
hardirqs last disabled at (310): [<ffff80008b3363f4>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
softirqs last  enabled at (0): [<ffff8000801d498c>] copy_process+0x11f8/0x3264 kernel/fork.c:2319
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 0000000000000000 ]---
invalid bkey u64s 7 type xattr 1073741824:2097412339779176161:U32_MAX len 9568256 ver 0: user.xattr2:xattr2
  size != 0: delete?, fixing


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
