Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35515B102
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801826; cv=none; b=d26ZX/lewwRYD6rz2ZzRi1cQXIDF47p+YpPfG2XTbgKzQ3k356Bgd/4nRpFo+TroTlVc+LJCemeNAlqOcjvgX0TKFeXG2OYh+B98SpWmS5KfjeLcerQhtYbWbknHy3A6MRCt1UQZEGJdDlbZqa8HwyfFzgKKOUpInKfXUxDpyuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801826; c=relaxed/simple;
	bh=NN/91hkMKagCjzztsZVJRxvLvku0Mz9HbC8Gn6Q9ekg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ffIaE3/KHhDQp3wuFyIVsV6fojbJndiSzXy601YQMATbLFjiToChQJIPDcalxO7TSLBu0jPx5HqLGU8SpWztb5OO0kioop52Ae/X1XiDPD+VuC+k1pG81tos9wwm8nJPbX0J0sev25ZhA6nFCE9zJsQRIG5C3qZ9TntMnxJg2WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f8489097eso180246739f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 02:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723801823; x=1724406623;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9oTjHn5Pdwbl5l6qiMqGJ8O01dU04mrK77hAuS/Y0H8=;
        b=iCLmWuVp2OM2aqzFWym6H0VUichgFRMnZMp4TBHcdWCCMr7aRvxJsGqr/fdzDwGzun
         BVCCSewOXpIy2p4llvr7ULd2PlKr/Cz08kB3w3UK4oGeTqmJHN2HRi9WgcpYAMCtLPIq
         7bgo67OcXNXNM3fNqNa5k7jgbUgjGFVsYBO+jbNs5wH1awamSjfIOP8s8Na16F9yH/Z2
         aYaeF7K+su33RNFbJodgLEDDCKO8LHGg0mIhaOlK26xDRQaVvfuN1tmtXGKOaOoynEvF
         ZDEQo/FeXomq4nUQlYFoCqk28NCIhlAKI7Yo/Xts09Y9W0m0tmm9VWfIJjjLODnWFsRj
         nuVg==
X-Forwarded-Encrypted: i=1; AJvYcCWmm2ri19Ei2LVaFiRpcFixp4Qh+y2QJ3M6tuXA+/Dr44nbcRYkFN09z3fPhKiNkP5lXaAYcmk45iJVrRKlncYL3zmH/xCYnfD+IpAApXk=
X-Gm-Message-State: AOJu0YwsW/rAr3tglubQ/kgwvIH77B+78DWHL9agwHxSQQndn7F1tZZO
	jZVTEyCr+Z0ifiu7h1D6sx1eujuZxS77JUu1wOSZ4yh0YiasN2jCGSJWKH/ujUk09loB96blA6n
	eTSnpbZGDN2a5muRsEAXpGlssOaHF3lGtayXfb/OvpdteYowZjo0q4Ac=
X-Google-Smtp-Source: AGHT+IF3R9obd6LzAY7LUOIqJlXr00TCRXswukkibjLN+n8WnX9GUSTD01VeLZkTTeaTRaL2PJPh2PzzW6e/mZb+lTYJvOxmdGWR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:860b:b0:4b7:c9b5:6765 with SMTP id
 8926c6da1cb9f-4cce16eb89dmr105310173.5.1723801823586; Fri, 16 Aug 2024
 02:50:23 -0700 (PDT)
Date: Fri, 16 Aug 2024 02:50:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005bb657061fc9e31e@google.com>
Subject: [syzbot] [bcachefs?] WARNING in discard_new_inode
From: syzbot <syzbot+95e40eae71609e40d851@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d7a5aa4b3c00 Merge tag 'perf-tools-fixes-for-v6.11-2024-08..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131e27c5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=95e40eae71609e40d851
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150be3c5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165c93cb980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d7a5aa4b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/af15738cca6c/vmlinux-d7a5aa4b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/62dacb1384ee/bzImage-d7a5aa4b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/92de1b01cc1a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95e40eae71609e40d851@syzkaller.appspotmail.com

R13: 00007f7d2a233210 R14: 0000000000000001 R15: 0032656c69662f2e
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5116 at fs/inode.c:1143 discard_new_inode+0x217/0x2a0 fs/inode.c:1143
Modules linked in:
CPU: 0 UID: 0 PID: 5116 Comm: syz-executor345 Not tainted 6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:discard_new_inode+0x217/0x2a0 fs/inode.c:1143
Code: 00 e8 ad d7 59 ff 4c 89 f7 e8 e5 98 ad 09 4c 89 e7 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 9f 00 00 00 e8 ba 6e 80 ff 90 <0f> 0b 90 42 80 3c 2b 00 75 ae eb b4 44 89 e1 80 e1 07 fe c1 38 c1
RSP: 0018:ffffc90002d1f1e0 EFLAGS: 00010293
RAX: ffffffff82131c36 RBX: 1ffff110078521f2 RCX: ffff888018a94880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff82131bdd R09: fffff520005a3e2c
R10: dffffc0000000000 R11: fffff520005a3e2c R12: ffff88803c290ec0
R13: dffffc0000000000 R14: ffff88803c290f40 R15: ffff88803c290f90
FS:  00007f7d2a2336c0(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4c62ac2440 CR3: 000000003a4be000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_inode_insert+0x35b/0x3d0 fs/bcachefs/fs.c:203
 bch2_lookup_trans fs/bcachefs/fs.c:465 [inline]
 bch2_lookup+0x1014/0x16c0 fs/bcachefs/fs.c:483
 lookup_open fs/namei.c:3556 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0x11cc/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d2a2861a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 71 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d2a233208 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f7d2a30c6a8 RCX: 00007f7d2a2861a9
RDX: 0000000000000000 RSI: 0000000020004280 RDI: ffffffffffffff9c
RBP: 00007f7d2a30c6a0 R08: 00007f7d2a232fa7 R09: 0000000000000038
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7d2a2d9090
R13: 00007f7d2a233210 R14: 0000000000000001 R15: 0032656c69662f2e
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
