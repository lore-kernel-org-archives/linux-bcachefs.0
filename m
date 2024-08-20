Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB371C68A7
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 22:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192730; cv=none; b=fSjStDHuDt+FojM/ezkVvmeRtf16ZR2wDvVtVw+rq8Wopz3jZeBlva1CX79Ns3R4NcHWo0MTvPywL1mqB0vQEqWgOA4f3Vwkk31lJoOz0Rr925DKX8Y8YVEsMSLCxb07r7VFEbIgP5uE9xLTZoEuK2ekyqysudPe5thvkIMYZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192730; c=relaxed/simple;
	bh=OoCUnET1V1k1lYliFSls4bJBSea8tdq56I1z+x/ggag=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f4MVPeO39MyIAjy3kng8m2yOutxT0ymle2WCzodhw+ZadkmZZkOxPBFL162bL0iUinkETYJovBtpYQe+U5r5/BbWMHJrlfAtkidW3TilyApSd+2PeVqSNoSSKFb98uiL1sRifBUA23f3GO3NKACid9kWWNDwp9zzefuNlKAcOzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39d28a70743so1973265ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 15:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724192727; x=1724797527;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dd0HEMDsZIeGcEfRD0xkJ9xU/HNc0cJLhCZLRTxGPV0=;
        b=upxoMdjRnlIEFaCZNf3/90gdBcTyWdlTktgtvBmdGsb8bVYHTvKUu3E0dEZXlhZ/qo
         c1gq+Fz19WASbK1Lb2uNcFos5FuQ12HmWxuuLhM3gajncDEbYxmfkOtLvyXYVAioOrOo
         7BJGtZmMOCmLg/Rohm7qS1yeYGphXKss38cbyR4CJDzVhD8DXUsWVQd6Vkq/gglCJO+t
         9JbopAL9SuTw0GHVo+1EmJZIM1Dg4X5bYZrFs12HXjFd99EdlBADjJMD+hxEcxO16ixj
         hORtaiuzy+eMm8sC5kXd+koI3aYe1vvAy+0EXWX7Lv1inddZJ190bnxBMn09JOKg0rnV
         gmSw==
X-Forwarded-Encrypted: i=1; AJvYcCWWB34c3OrWhS7oxci+9bDEzButGkVMYiktS0TR0SIUbb6DFfgGrLpb1j8B3zSoo+CefzDRUYtCnvYYBRNhZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMrBeSkRN2nbJxuDCwi20Y4Ferm0Vk98da/kntmno2HTruLhr4
	3Msy09JdnXAtBtfgf+IXJ13dXgtdaNrDlJVowMqKHKGce8uY86+dMYD7nzNASi0gdUyU7umLlW5
	5Mkm1kNX6661XGRI5XSHtuTHBD5kUSDzWk5hNDC/cWyQsA7anB2XtrzY=
X-Google-Smtp-Source: AGHT+IEtLv4i5fZ4aJiVdm3kqCLGpdh8HFo8coaATgIkdnz9x/nnUaNurdlUIXeB6GXevELYvVEAjn9ArMzpoXqgMnNA4ee0pPEP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d2cb:0:b0:376:3fad:bb7c with SMTP id
 e9e14a558f8ab-39d56dd9357mr1402495ab.1.1724192727449; Tue, 20 Aug 2024
 15:25:27 -0700 (PDT)
Date: Tue, 20 Aug 2024 15:25:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b533e062024e702@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_write_super
From: syzbot <syzbot+7e9efdfec27fbde0141d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5fa841af679 Merge tag 'pull-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15295e05980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=7e9efdfec27fbde0141d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-e5fa841a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/de8799afd5d0/vmlinux-e5fa841a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70cd1d84fb4b/bzImage-e5fa841a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7e9efdfec27fbde0141d@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,compression=lz4,metadata_target=invalid device 255,noshard_inode_numbers,noinodes_use_key_cache,journal_flush_delay=1001,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5104 at fs/bcachefs/super-io.c:939 bch2_write_super+0x364c/0x3c50 fs/bcachefs/super-io.c:939
Modules linked in:
CPU: 0 UID: 0 PID: 5104 Comm: syz.0.0 Not tainted 6.11.0-rc3-syzkaller-00279-ge5fa841af679 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_write_super+0x364c/0x3c50 fs/bcachefs/super-io.c:939
Code: ff ff 48 89 44 24 10 49 be 00 00 00 00 00 fc ff df e9 79 dd ff ff e8 83 61 4f fd 90 0f 0b 90 e9 73 cb ff ff e8 75 61 4f fd 90 <0f> 0b 90 e9 82 cc ff ff 48 89 5c 24 10 e8 62 61 4f fd 48 8b 5c 24
RSP: 0018:ffffc9000b58f620 EFLAGS: 00010283
RAX: ffffffff8444297b RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc9000b0e1000 RSI: 0000000000000c1e RDI: 0000000000000c1f
RBP: ffffc9000b58f910 R08: ffffffff8443f5f2 R09: 1ffffffff202fab5
R10: dffffc0000000000 R11: fffffbfff202fab6 R12: ffffc9000b58f770
R13: 1ffff920016b1eee R14: dffffc0000000000 R15: ffff888045f80000
FS:  00007faf648136c0(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faf63a886c0 CR3: 0000000045c5c000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_ioc_setlabel fs/bcachefs/fs-ioctl.c:333 [inline]
 bch2_fs_file_ioctl+0x1e5b/0x2960 fs/bcachefs/fs-ioctl.c:578
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faf639799b9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faf64813038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007faf63b15f80 RCX: 00007faf639799b9
RDX: 00000000200006c0 RSI: 0000000041009432 RDI: 0000000000000008
RBP: 00007faf639e78d8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007faf63b15f80 R15: 00007ffe84e1c088
 </TASK>


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
