Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A811FF7C9
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Dec 2024 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733147012; cv=none; b=P7WltMQAFYcMTrFw7oPaDEFiczZr1BUpzxHE5maNZnLT7OLWbAJD3w/Rs217kRfLV8TeCDSvBobF3MQq4a3M2pgkY4yHIcI6G5qolc1CzwYei+RTYK8FbuSMEQUFWGbuSzpEvxIF5MIND6o7pagD7osiWXIfnNXBnHXS39VP++Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733147012; c=relaxed/simple;
	bh=7JrQRCwu0TfXe2NU9Tm3ibc6+iH+3XKuFgZVRE80KEs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=p6VmEuc5xL1/nB6/ibRQX8Gqjyi0xm0HKtNeYFieTOsncf0YQvCanMGsv/RNRQXSI0ed0u9j/GDJSHEjKZVBlk+UPfDqzufja8WVx6HunBPhCwlVTfNQpG+b/UxNvx/r2sqFuer5SuCkYCOJshgjy/LtGS8yywA/618OAuO+O1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so25513495ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Dec 2024 05:43:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733147010; x=1733751810;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRYzxUngfBUrmKR51U+FrTtZyKLbXqN+47VzUVT+Msk=;
        b=fpwZu9cEUTDKLsJ64Yiw8bC+AW1k8Fl3uklgh5n74ncN8t22DtkJBaX7gPCPDMRurD
         faqjRrv67+XrXbQ/oGPEnGwyhlH37r9do9Te2ifMysEzPUrWEdDuE/h69L71gWsG4Ro0
         1L+LNJt1FM55yjRfLJhqr9vypVXf6F6mvow7dnV+l21b4q191tJTqEiBeBNA9hx4HYAc
         Z2S4CJxyyRPVstN94gkG/UE0RtQyzuKsgbfKlnYFBTtCMod3dR/Z+fYbde5kovABUohI
         xwNeG0NLDNNnh7ioS8yUEHqp/TU0iV4XBglQ5dazisu+yoReWXbLxJEnAgemrlaAYe6o
         3dMg==
X-Forwarded-Encrypted: i=1; AJvYcCWdQEgzvfihJTs6wm+pUzeJwkqPGHFPvjJzic04EB+puG6IHohYCV9WY4lLWJcco+Cv/aQjxpVE1137qSwldg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4GuqTOAuTvydGW5YIkHmKprDlz5kelbUkRx6oA7UmS9gbOAS8
	IkfYrERliLSwHvERgDRW3E3+8rW0EXBRFustJQupQ91rOLuRSMZn968euQAzVfzbn76cYGaGtgW
	j7mD7pVDvHppkUsxppJ//doyfWmkWyIVFX9LtCOG+OkrDLnFclyAEtGU=
X-Google-Smtp-Source: AGHT+IEVr0WyBDt4asdo1+oOdociiGtfM/z0mxH3IqYnP6ckedBuZFLETyXdYzb3dmiI9804a4NbnKTquAHa9zUHN1b1NMdG8s2x
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b27:b0:3a7:e732:4713 with SMTP id
 e9e14a558f8ab-3a7e7324a67mr81296485ab.15.1733147008923; Mon, 02 Dec 2024
 05:43:28 -0800 (PST)
Date: Mon, 02 Dec 2024 05:43:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674db980.050a0220.ad585.0053.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_rename2
From: syzbot <syzbot+71d64eb53ffbb023de3b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    f788b5ef1ca9 Merge tag 'timers_urgent_for_v6.13_rc1' of gi.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D110d55e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D2b3a18edb5017fc=
8
dashboard link: https://syzkaller.appspot.com/bug?extid=3D71d64eb53ffbb023d=
e3b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-f788b5ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/40a792cdbfb9/vmlinux-=
f788b5ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8b3ae7a81a9a/bzI=
mage-f788b5ef.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+71d64eb53ffbb023de3b@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a writ=
ten 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0 =20
  node offset 0/24 bset u64s 0: incorrect max key 18446462598732840960:1487=
2293344460931071:U32_MAX
bcachefs (loop0): flagging btree inodes lost data
error reading btree root inodes l=3D0: btree_node_read_error, fixing
bcachefs (loop0): will run btree node scan
invalid bkey u64s 7 type xattr 536870912:3798421620223919902:U32_MAX len 0 =
ver 0: user.=06:
  xattr name has invalid characters: delete?, fixing
bcachefs (loop0): error validating btree node on loop0 at btree snapshots l=
evel 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb writ=
ten 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0 =20
  node offset 0/16 bset u64s 0: unknown checksum type 9, fixing
bcachefs (loop0): error validating btree node on loop0 at btree snapshots l=
evel 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb writ=
ten 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0 =20
  node offset 8/16: btree node data missing: expected 16 sectors, found 8, =
fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=3Dsna=
pshots level=3D0 SPOS_MAX due to error
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  extents l=3D0 seq=3D1 journal_seq=3D5 cookie=3Dc6c25c03258c59c5 POS_MIN-S=
POS_MAX ptr: 0:27:0 gen 0
  inodes l=3D0 seq=3D1 journal_seq=3D5 cookie=3D7589ab5e0c11cc7a POS_MIN-18=
446462598732840960:14872293344460931071:U32_MAX ptr: 0:38:0 gen 0
  dirents l=3D0 seq=3D1 journal_seq=3D3458764513820540929 cookie=3D9aa2895a=
efce4bdf POS_MIN-SPOS_MAX ptr: 0:41:0 gen 0
  xattrs l=3D0 seq=3D1 journal_seq=3D4 cookie=3D2285c34bed0abe32 POS_MIN-SP=
OS_MAX ptr: 0:31:0 gen 0
  subvolumes l=3D0 seq=3D1 journal_seq=3D1 cookie=3Dc0bef60d07ceb940 POS_MI=
N-SPOS_MAX ptr: 0:35:0 gen 0
  snapshots l=3D0 seq=3D1 journal_seq=3D0 cookie=3Debb8d5a9e3463bdb POS_MIN=
-SPOS_MAX ptr: 0:32:0 gen 0
  lru l=3D0 seq=3D1 journal_seq=3D5 cookie=3D28f61e078e70b95c POS_MIN-SPOS_=
MAX ptr: 0:28:0 gen 0
  deleted_inodes l=3D0 seq=3D1 journal_seq=3D0 cookie=3D1db8f60c84bb244c PO=
S_MIN-SPOS_MAX ptr: 0:42:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root inodes unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovering inodes l=3D0 POS_MIN=
 - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_p=
tr_v2 18446462598732840960:14872293344460931071:U32_MAX len 0 ver 0: seq 75=
89ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
btree node with incorrect max_keyat btree inodes level 1:
  parent: u64s 5 type btree_ptr SPOS_MAX len 0 ver 0
  child: u64s 11 type btree_ptr_v2 18446462598732840960:1487229334446093107=
1:U32_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN dura=
bility: 1 ptr: 0:38:0 gen 0, fixing
bcachefs (loop0): bch2_get_scanned_nodes(): recovering inodes l=3D0 1844646=
2598732840960:14872293344460931072:0 - SPOS_MAX
btree node with incorrect max_keyat btree inodes level 1:
  parent: u64s 5 type btree_ptr SPOS_MAX len 0 ver 0
  child: u64s 11 type btree_ptr_v2 18446462598732840960:1487229334446093107=
1:U32_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN dura=
bility: 1 ptr: 0:38:0 gen 0, fixing
bcachefs (loop0): set_node_max(): u64s 11 type btree_ptr_v2 184464625987328=
40960:14872293344460931071:U32_MAX len 0 ver 0: seq 7589ab5e0c11cc7a writte=
n 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0 -> SPOS_MAX
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
bcachefs (loop0): dirent to missing inode:
  u64s 7 type dirent 4096:189491840996961599:U32_MAX len 0 ver 0: file0 -> =
4098 type dir
bcachefs (loop0): dirent to missing inode:
  u64s 7 type dirent 4096:4330382808765833931:U32_MAX len 0 ver 0: file1 ->=
 536870912 type reg
------------[ cut here ]------------
kernel BUG at fs/bcachefs/fs.c:935!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5320 Comm: syz.0.0 Not tainted 6.12.0-syzkaller-12128-gf=
788b5ef1ca9 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_rename2+0x2117/0x2130 fs/bcachefs/fs.c:935
Code: ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 0f f2 ff ff 4c 89 ff e8 f9 =
ca cc fd e9 02 f2 ff ff e8 2f bf 92 07 e8 4a e3 61 fd 90 <0f> 0b e8 42 e3 6=
1 fd 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
RSP: 0018:ffffc9000d2cf4e0 EFLAGS: 00010287
RAX: ffffffff843d8ed6 RBX: 0000000000001002 RCX: 0000000000100000
RDX: ffffc9000e772000 RSI: 0000000000002734 RDI: 0000000000002735
RBP: ffffc9000d2cfa90 R08: ffffffff843d81bd R09: 1ffff110088ba037
R10: dffffc0000000000 R11: ffffed10088ba038 R12: dffffc0000000000
R13: ffff8880545a0000 R14: 0000000000001003 R15: 0000000000000000
FS:  00007ff4ba7cf6c0(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c0 CR3: 0000000040446000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vfs_rename+0xbdb/0xf00 fs/namei.c:5067
 do_renameat2+0xd94/0x13f0 fs/namei.c:5224
 __do_sys_renameat2 fs/namei.c:5258 [inline]
 __se_sys_renameat2 fs/namei.c:5255 [inline]
 __x64_sys_renameat2+0xce/0xe0 fs/namei.c:5255
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff4b9980849
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff4ba7cf058 EFLAGS: 00000246 ORIG_RAX: 000000000000013c
RAX: ffffffffffffffda RBX: 00007ff4b9b45fa0 RCX: 00007ff4b9980849
RDX: ffffffffffffff9c RSI: 0000000020000440 RDI: ffffffffffffff9c
RBP: 00007ff4b99f3986 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ff4b9b45fa0 R15: 00007fff1bc1c7f8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_rename2+0x2117/0x2130 fs/bcachefs/fs.c:935
Code: ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 0f f2 ff ff 4c 89 ff e8 f9 =
ca cc fd e9 02 f2 ff ff e8 2f bf 92 07 e8 4a e3 61 fd 90 <0f> 0b e8 42 e3 6=
1 fd 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
RSP: 0018:ffffc9000d2cf4e0 EFLAGS: 00010287
RAX: ffffffff843d8ed6 RBX: 0000000000001002 RCX: 0000000000100000
RDX: ffffc9000e772000 RSI: 0000000000002734 RDI: 0000000000002735
RBP: ffffc9000d2cfa90 R08: ffffffff843d81bd R09: 1ffff110088ba037
R10: dffffc0000000000 R11: ffffed10088ba038 R12: dffffc0000000000
R13: ffff8880545a0000 R14: 0000000000001003 R15: 0000000000000000
FS:  00007ff4ba7cf6c0(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff4ba7adfe0 CR3: 0000000040446000 CR4: 0000000000352ef0
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
