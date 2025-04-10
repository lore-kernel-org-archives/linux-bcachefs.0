Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B72040A8
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Apr 2025 06:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268308; cv=none; b=HNUCCoVf3ZgBuGg05su9FuFVyBCc1nAt53Q6iOzlWRd8ztAfmLEgAQ7EJGS47ee0b/7DagkYzWtsEk6z5aT9DLFTWHXwdUGdJvZSYVve4kSPTlG/Ul41IeQMEMWVoFhZCTBhjqrpRmHuoLVFmQWyKp2WAZULi4O5OND4yxpFqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268308; c=relaxed/simple;
	bh=sryZn6ZgzjVKs/6YCp1JM29i/2IZOriqd3ozfD78J9Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HA0sawNVqCNTB/oDuI4xcfDhS46XvYdgrYiM/BRJrPOGzx3grdduy6UKuyFp18AbQnhbUCY3jNbtySOQBOIbwobsZbBAvoVfey64YdR1m+8pExOSFi3vXKTrhvRBl7VBghAWNvX/2mdN+GNDhZVzEqEA57Tp287QCC2pdzNlRmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d6e10f4b85so10570565ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Apr 2025 23:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744268305; x=1744873105;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTF7Kx0ylcTZ32YLLmw0B4ESqKuiCDu+c/J/ULllbmQ=;
        b=FjVgfmALwliIQIzElxZXbGMqsWuNLhsy1XECHTSPAgGqtBMWHb3wlyLVQdHJ+oDwxX
         pfK6thIps0n9cktu7mde2GBdaERrROHRkjQC8LkPoUPtohtoGEsDX6+5y6ItBadUykLS
         CILynicFTP4rWwxxzlvVeHryOe7pMRDTZgVzen5BYYuocFJAiDLRKp2cS9ITe/3SZ5hY
         cWtMIS+e7eHKprOf+Ca/AzRNCbhq4xlCY/oPp1Ax9VFFDV5bSjM97BmBZFv5KSl0G2ka
         ks5tg9Ho+UArYf95uzuAV5gCKvkWyF1d50RtQQ+iaWUNJu6YhKsVHnB7aIMThXoCvRYp
         V3Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWHxP97OqpBSiRvNRtpHYlHMmarlI4oTtGoFlFXfUPYLma8xTE7FKDe2n+kwee68C+kcI6LJIrxdBfHwR28xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsH2rCKPl7hmeQPsrDnYucB3Y2VGaNxFJNOj7pbHBmNsElV8jk
	QXx/tV0IQ1sCVxdgrET6sSSmwWCo3vwUavEW4MQ2bKAht1YNLVCe4VRagtVKhvFHl0rhVqONGNf
	f6HprHQUzil9J5AAOoJoFfv5pEc4BAEu868M4/7aUaXD/a770CO+F1HQ=
X-Google-Smtp-Source: AGHT+IEhYdJuoNmXoiEi+ThrI1NdVO06bCg3efT1FQizTiEnH7cAIilHSWMPmkTvRyNtcysnC+cmdvVnKVuk2OL76BaG0ZKvPbe0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2290:b0:3d4:70ab:f96f with SMTP id
 e9e14a558f8ab-3d7e46f987dmr20036485ab.8.1744268305177; Wed, 09 Apr 2025
 23:58:25 -0700 (PDT)
Date: Wed, 09 Apr 2025 23:58:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f76c11.050a0220.258fea.0029.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_str_hash_check_key
From: syzbot <syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    56f944529ec2 Merge tag 'input-for-v6.15-rc0' of git://git..=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16391fb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df2054704dd53fb8=
0
dashboard link: https://syzkaller.appspot.com/bug?extid=3D843981bb836d699c0=
7d1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-56f94452.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c6da83e5191b/vmlinux-=
56f94452.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5c060438ea13/bzI=
mage-56f94452.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com

    bi_dir=3D4096
    bi_dir_offset=3D5682031293254759865
    bi_subvol=3D0
    bi_parent_subvol=3D0
    bi_nocow=3D0
    bi_depth=3D0
    bi_inodes_32bit=3D0, fixing
bcachefs (loop0): inode points to missing dirent
  inum: 4099:4294967295=20
    mode=3D100755
    flags=3D(15300000)
    journal_seq=3D5
    hash_seed=3Dab878b4c5ab7c89e
    hash_type=3Dsiphash
    bi_size=3D1050
    bi_sectors=3D8
    bi_version=3D0
    bi_atime=3D1997793410
    bi_ctime=3D1997793410
    bi_mtime=3D1997793410
    bi_otime=3D1997793410
    bi_uid=3D0
    bi_gid=3D0
    bi_nlink=3D0
    bi_generation=3D0
    bi_dev=3D0
    bi_data_checksum=3D0
    bi_compression=3D0
    bi_project=3D0
    bi_background_compression=3D0
    bi_data_replicas=3D0
    bi_promote_target=3D0
    bi_foreground_target=3D0
    bi_background_target=3D0
    bi_erasure_code=3D0
    bi_fields_set=3D0
    bi_dir=3D4098
    bi_dir_offset=3D2566586984702133180
    bi_subvol=3D0
    bi_parent_subvol=3D0
    bi_nocow=3D0
    bi_depth=3D0
    bi_inodes_32bit=3D0, fixing
 done
bcachefs (loop0): check_dirents...
bcachefs (loop0): hash table key at wrong offset: btree dirents inode 4096 =
offset 6229884513039707068, hashed to 5410109479790105297
  u64s 7 type dirent 4096:6229884513039707068:U32_MAX len 0 ver 0: =EF=BF=
=BD=CB=A8=EF=BF=BD -> 2166030336 -> 1073741825 type subvol, fixing
bcachefs (loop0): hash table key at wrong offset: btree dirents inode 4096 =
offset 6229884513039707068, hashed to 5410109479790105297
  u64s 7 type dirent 4096:6229884513039707068:U32_MAX len 0 ver 0: =EF=BF=
=BD=CB=A8=EF=BF=BD -> 2166030336 -> 1073741825 type subvol, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/fsck.c:954!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted 6.14.0-syzkaller-13443-g5=
6f944529ec2 #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_fsck_update_backpointers+0x4ed/0x4f0 fs/bcachefs/fsck.c:954
Code: e9 2b fc ff ff 89 d9 80 e1 07 38 c1 0f 8c 62 fc ff ff 48 89 df e8 63 =
77 b7 fd e9 55 fc ff ff e8 39 78 ba 07 e8 74 4e 4d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d4ce460 EFLAGS: 00010246
RAX: ffffffff847608cc RBX: 0000000000000010 RCX: 0000000000100000
RDX: ffffc9000e50a000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d4ce600 R08: ffffffff84760529 R09: 0000000000000000
R10: ffffc9000d4ce530 R11: fffff52001a99caf R12: ffffc9000d4cf290
R13: dffffc0000000000 R14: ffff888052bda000 R15: ffff888052900000
FS:  00007f5be4f2b6c0(0000) GS:ffff88808c596000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b32eddc088 CR3: 0000000044eda000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_str_hash_check_key+0x202c/0x3b50 fs/bcachefs/str_hash.c:257
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:415 [inline]
 check_dirent fs/bcachefs/fsck.c:2135 [inline]
 bch2_check_dirents+0x2d45/0x3b90 fs/bcachefs/fsck.c:2230
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:285
 bch2_fs_recovery+0x292a/0x3e20 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x310/0x620 fs/bcachefs/super.c:1069
 bch2_fs_get_tree+0x113e/0x18f0 fs/bcachefs/fs.c:2253
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3879
 do_mount fs/namespace.c:4219 [inline]
 __do_sys_mount fs/namespace.c:4430 [inline]
 __se_sys_mount+0x38c/0x400 fs/namespace.c:4407
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5be418e90a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5be4f2ae68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f5be4f2aef0 RCX: 00007f5be418e90a
RDX: 000020000000f640 RSI: 0000200000000140 RDI: 00007f5be4f2aeb0
RBP: 000020000000f640 R08: 00007f5be4f2aef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000140
R13: 00007f5be4f2aeb0 R14: 000000000000f61b R15: 0000200000000340
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fsck_update_backpointers+0x4ed/0x4f0 fs/bcachefs/fsck.c:954
Code: e9 2b fc ff ff 89 d9 80 e1 07 38 c1 0f 8c 62 fc ff ff 48 89 df e8 63 =
77 b7 fd e9 55 fc ff ff e8 39 78 ba 07 e8 74 4e 4d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d4ce460 EFLAGS: 00010246
RAX: ffffffff847608cc RBX: 0000000000000010 RCX: 0000000000100000
RDX: ffffc9000e50a000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d4ce600 R08: ffffffff84760529 R09: 0000000000000000
R10: ffffc9000d4ce530 R11: fffff52001a99caf R12: ffffc9000d4cf290
R13: dffffc0000000000 R14: ffff888052bda000 R15: ffff888052900000
FS:  00007f5be4f2b6c0(0000) GS:ffff88808c596000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b32eddc088 CR3: 0000000044eda000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
