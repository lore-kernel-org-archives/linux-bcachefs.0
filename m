Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342B150981
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 Jan 2025 20:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736021904; cv=none; b=Ae/iArnUGDUK2P3byl5PtbSqaVjhqm05cXhklSNb4OjPPoBfXHuJ9GSYZdCeSxA7mH4X52+yafThWk6LvoFyhI6GNwNFqOwHDFPsn8HccpeyZtCzV952gGAhv/h+lI9Tt+dltc05dpQnFDSXPtbTx+UAiZX8OQoPkdVqYeB1DJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736021904; c=relaxed/simple;
	bh=dILPD1PqeLhB54uGrENrwRX0AjH251a51ZyQaTkzr7g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LmY6cjXIM1hOEn5hBItQfwtt6lR42GyA9hFVy8nTA+nz8OEKsRorJVEOjvC43aW9do15VOudu5a3myV4vB+0lf0idBIlAKNsUZHikulKqZp0zK5sHmdsQsOCc3BXvqhyOlqYliYE1+iR3yS+LMN4KO/XyWPhgln/y/9clrOdpGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso141138555ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 Jan 2025 12:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736021902; x=1736626702;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLQQq3Sev9za8Fff3jkdSfdaP7umSjcjtAPA55ghp8I=;
        b=xTA+l6K/bt7g8kCRy4iN0Vb+0sLET8+wwMlPjFCY2cwvVTjGiO1UyIndmw2W3xz+X4
         dsVjIx3NDlLRGO8c5JWodySO/kDuK+5TXJfX6Hn2NNiwlhyAIUhcfMlbo2EmnMq8hWuE
         s5gUEiMl4wb59RqXK8cbM8Sqqj8xv7/mKVtk+1VL7YFAr3OdLx8brtNKqdbfcEg9QLL8
         Cminjd56dHtk+m3KPWDfCUIMIMjHnJ3v/MWySjyToMlOl8iK1x7ilET9+lYrx9DJQDL2
         JutdFUL1qrAsvz2F6cP/pf3v3AsZnjvSYwXMrzMd1y7+m/OYebEp4BND649cE2KMd37N
         5jzA==
X-Forwarded-Encrypted: i=1; AJvYcCV9ZcmCeC8DZOzUHpQNythYviuw30uJzVMO/4/xsRScqnPiU8Lx43N5Aw7QQZEBlqS3l2srrm9OpTivBEejhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2MgfdpCBA4ipBxuwZF9SBG5S5+pypIjpM0BVy0Tko9fo803d
	Q7gB0E4aN6fZGO0XrSIo/rp1LYVL/5gjsLkWk3CKIIpeyjOhG3e2qqIitMkMzD8v1MVuCAfKMaU
	HgDvcMdA8WvasOzhzh86YZEBFT1ePnleuoJBxpYVwiRVOTtANdec5TJ0=
X-Google-Smtp-Source: AGHT+IFXMEKPyJbH5yYYTncxrTQf524WnRME22RaD1M4BjKHUoBwRTZTgbm4L9VUsMa0eq3aaFxvZPG/YFf9WRzMZrvA000bTupC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b24:b0:3a7:85ee:fa78 with SMTP id
 e9e14a558f8ab-3c2d51516acmr424862705ab.18.1736021902183; Sat, 04 Jan 2025
 12:18:22 -0800 (PST)
Date: Sat, 04 Jan 2025 12:18:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6779978e.050a0220.380ff0.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_quota_transfer
From: syzbot <syzbot+ed19b61515c19e78a5af@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e2c8b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
dashboard link: https://syzkaller.appspot.com/bug?extid=ed19b61515c19e78a5af
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/703c842459ce/vmlinux-ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1a8db4bb5dbb/bzImage-ccb98cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed19b61515c19e78a5af@syzkaller.appspotmail.com

inum: 4099:4294967295 
  mode=100755
  flags=(15300000)
  journal_seq=5
  hash_seed=ab878b4c5ab7c89e
  hash_type=siphash
  bi_size=1050
  bi_sectors=8
  bi_version=0
  bi_atime=1997793410
  bi_ctime=1997793410
  bi_mtime=1997793410
  bi_otime=1997793410
  bi_uid=0
  bi_gid=0
  bi_nlink=0
  bi_generation=0
  bi_dev=0
  bi_data_checksum=0
  bi_compression=0
  bi_project=0
  bi_background_compression=0
  bi_data_replicas=0
  bi_promote_target=0
  bi_foreground_target=0
  bi_background_target=0
  bi_erasure_code=0
  bi_fields_set=0
  bi_dir=4098
  bi_dir_offset=2566586984702133180
  bi_subvol=0
  bi_parent_subvol=0
  bi_nocow=0, fixing
 done
bcachefs (loop0): check_dirents...
dirent points to missing inode:
u64s 8 type dirent 4096:1859603997870691834:U32_MAX len 0 ver 0: lost+found -> 4097 type dir, fixing
 done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): reading quotas
bcachefs (loop0): quotas done
bcachefs (loop0): scanning for old btree nodes: min_version 0.24: unwritten_extents
bcachefs (loop0): scanning for old btree nodes done
bcachefs (loop0): done starting filesystem
netlink: 'syz.0.0': attribute type 10 has an invalid length.
netlink: 40 bytes leftover after parsing attributes in process `syz.0.0'.
A link change request failed with some changes committed already. Interface virt_wifi0 may have been left with an inconsistent configuration, please check.
------------[ cut here ]------------
kernel BUG at fs/bcachefs/quota.c:319!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5322 Comm: syz.0.0 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_quota_transfer fs/bcachefs/quota.c:319 [inline]
RIP: 0010:bch2_quota_transfer+0xaba/0xad0 fs/bcachefs/quota.c:367
Code: 48 c7 c7 f0 4a f6 8e 4c 89 e6 e8 41 2a b1 00 e9 c8 fd ff ff e8 37 db 55 fd 90 0f 0b e8 2f db 55 fd 90 0f 0b e8 27 db 55 fd 90 <0f> 0b e8 1f db 55 fd 90 0f 0b e8 d7 10 7f 07 0f 1f 80 00 00 00 00
RSP: 0018:ffffc9000d4bf640 EFLAGS: 00010287
RAX: ffffffff844998b9 RBX: ffff8880522c80a0 RCX: 0000000000100000
RDX: ffffc9000eac2000 RSI: 0000000000000ad7 RDI: 0000000000000ad8
RBP: ffffc9000d4bf7e8 R08: ffffffff84499589 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2032fcf R12: 0000000000000001
R13: 0000000000000000 R14: 1ffff1100a3a1685 R15: ffff888051d0b428
FS:  00007f307cbc16c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020006140 CR3: 0000000040468000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_quota_transfer+0x282/0x4d0 fs/bcachefs/fs.c:140
 bch2_setattr_nonsize+0x3c2/0x12a0 fs/bcachefs/fs.c:1044
 notify_change+0xbca/0xe90 fs/attr.c:552
 chown_common+0x501/0x850 fs/open.c:778
 do_fchownat+0x16a/0x240 fs/open.c:809
 __do_sys_lchown fs/open.c:834 [inline]
 __se_sys_lchown fs/open.c:832 [inline]
 __x64_sys_lchown+0x85/0xa0 fs/open.c:832
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f307bd85d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f307cbc1038 EFLAGS: 00000246 ORIG_RAX: 000000000000005e
RAX: ffffffffffffffda RBX: 00007f307bf75fa0 RCX: 00007f307bd85d29
RDX: 0000000039323420 RSI: 00000000706d6174 RDI: 0000000020000200
RBP: 00007f307be01b08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f307bf75fa0 R15: 00007ffdf9b434c8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_quota_transfer fs/bcachefs/quota.c:319 [inline]
RIP: 0010:bch2_quota_transfer+0xaba/0xad0 fs/bcachefs/quota.c:367
Code: 48 c7 c7 f0 4a f6 8e 4c 89 e6 e8 41 2a b1 00 e9 c8 fd ff ff e8 37 db 55 fd 90 0f 0b e8 2f db 55 fd 90 0f 0b e8 27 db 55 fd 90 <0f> 0b e8 1f db 55 fd 90 0f 0b e8 d7 10 7f 07 0f 1f 80 00 00 00 00
RSP: 0018:ffffc9000d4bf640 EFLAGS: 00010287
RAX: ffffffff844998b9 RBX: ffff8880522c80a0 RCX: 0000000000100000
RDX: ffffc9000eac2000 RSI: 0000000000000ad7 RDI: 0000000000000ad8
RBP: ffffc9000d4bf7e8 R08: ffffffff84499589 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2032fcf R12: 0000000000000001
R13: 0000000000000000 R14: 1ffff1100a3a1685 R15: ffff888051d0b428
FS:  00007f307cbc16c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020006140 CR3: 0000000040468000 CR4: 0000000000352ef0
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
