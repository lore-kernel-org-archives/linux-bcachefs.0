Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E3A257AEC;
	Mon,  4 Aug 2025 12:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754310104; cv=none; b=t7z0S4F19S+DcS85F8jY8JbVCpm10Rs9JemBlni6bqxN0IX1Nz9c1bqA+gr2njEJUXAfN/gxkjDeF9KD1zFTixSQdMpHt/hplb0HSaz+pqdsWxl2gCQNZUUaVFpgaeXbWyfxB8a/Vylcui5DOdTFvIkwKfimE8jmxeqJBlAUqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754310104; c=relaxed/simple;
	bh=Cd+J/fuFJeOf2BdB605y67NdZ6pgAvTvT+hOGCVGjU0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=phBX0Ep/8AnsEso9ts53hGzRFQlax2aFCSTQ1cvKPH2Db9wndNGRXGpbBGgeeNaoLHglmR6UQkPp18qurIbC44Te+cXYGQDqdpr6lBoQ6hftBTX1qWi1o2omZK0bk+J33xYhnzVP19TA0zx9Y4R5cRGTCWU+PojMpiXTAV0RZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EH+N/Ws8; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EH+N/Ws8"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2402774851fso35623285ad.1;
        Mon, 04 Aug 2025 05:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754310102; x=1754914902; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmwTseNNKWZTAlyuGNiRct16YBu9K9tkWd47g2bBReA=;
        b=EH+N/Ws8fBKYOf81kvgFFc4pZIGNcpFAy2LKziYpe2ae6cQCLC8/F/t+zDP7TPi/Ex
         QjlAbs2W3wVmU3NkdKV28TtUXKIIEZIKBA2r3xOXqni+I3xskex8atUQU24YH+9M3Ez2
         JeQi8WuNjw4QPMy241X2+xZxOohaC/FyufRpfE5BiAX9zEScVDbg4CjLGeSFLrOPYD1s
         AKAHJVNITNEJMfKJgDrKD+YTNp4mCVkiDK6ss+FIRbDfmCl0Y/flXNUlMQh/jhaANCIT
         yVHjBe+9Kd3WYw2gNNzu4XVdDTwbW1JowMQxkeXhm3Glow1P6iscmh9MvUur4hTnO+aY
         Pa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754310102; x=1754914902;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmwTseNNKWZTAlyuGNiRct16YBu9K9tkWd47g2bBReA=;
        b=EJsSnlnyKKAHi3VC9VQHQu6/LEtBIecwiY2sIbKm4Twf7kEtJ7VBCDzSUm+UYpqDL0
         LRXsmeEZ75PtnZOROFPEtskSzInDNjziZfeet40CuRmY2QP8xEUpjEIjJ6AAEXfO7/2o
         /uqULK3DTZwaey+r8fSSTQrUVrG15Kj6O2g2KcHC65JQrQIg1vggxCHRShBF5NmBgRfy
         RnEop013HStE1QGUBwKD7sca+KIFYnci7KfPkgrVvJ1etn6juPRxu2qhH+UKO9ZO7Wc3
         RD+dWlzC2Wmlt+6Bx+JCzMfBuamiaYTgX5jAewTN6FrHgR93nSEMDqRK2PUg1EVuC+x0
         69UA==
X-Forwarded-Encrypted: i=1; AJvYcCWH1UZO5TA36SY4FDxNOAHg0XCl0Job7kdGhhRrQUCCQ5O3ye+GAoKGaWehbJv8nqyS3Bx135eMFAMF1opG@vger.kernel.org, AJvYcCXJ71lqitC5yaYhrTCVvrREE3+vCBmxsytJicOFOFySVhd1uzaZH0U+MdVpuDSAaPEgJCuXxvGgr7esk2cUcw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5K1z6Bm4Uf5desVezWJLoz4ah6pZDDX4zOCECXjkOboTz2l/q
	uc0+bkZ1UI/9GtpglDSPa5O2oq7R0I8XtetlrKfFiMcJWhZWoK/XvSNr
X-Gm-Gg: ASbGncsqbBHAL7keQ/m8vsYzr6HNnXNv4x375CMEnbCp6tNZxUaTDIGJ8gMpaUmnWb4
	JIOQVyHjvRwqtn6L4idUQvhT8lrpp2jV5m51LSoGZMl5JIy/viJ2MDJ4rLl7MZjWIRDshLyLnIf
	jnpA+rrgypMYGEYkHCHE2igo8fMOZCcladTsF7Db3B3hXFdedFG9aScA8gg2ijEkWYuEXqyzOzL
	5iLQc2Q0ZThvGw5Bs97ms4XBIHqO4hIrNyi8aTvPq5ku3yD4mDOONY32ALc/O2UDrdqbkIJLldn
	n1hPb7ZGlppBaZnh7dsbCMPRWuqk8YNoXEDNwic/zZFtu3u5YHixBjPFYSoOXc17TjiCIL102wZ
	gd9+Dp76HzkcUs61o
X-Google-Smtp-Source: AGHT+IHr+FQmnyYLpjpL0xF2Gp4lMXIArYiGXiocSe7WRNjSVRVNCBurvsUI1XVRZDRcZg2Ffclb7Q==
X-Received: by 2002:a17:902:e54c:b0:240:8704:fb9 with SMTP id d9443c01a7336-242470647bemr137464495ad.53.1754310101723;
        Mon, 04 Aug 2025 05:21:41 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3207eca6eb1sm11674849a91.22.2025.08.04.05.21.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:21:41 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in
 bch2_accounting_validate
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <68905ecc.050a0220.7f033.0004.GAE@google.com>
Date: Mon, 4 Aug 2025 20:21:25 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D7EE43B-5C6F-4F46-AE09-D5B50FF64589@gmail.com>
References: <68905ecc.050a0220.7f033.0004.GAE@google.com>
To: syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Aug 4, 2025, at 15:18, syzbot =
<syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    352af6a011d5 Merge tag 'rust-6.17' of =
git://git.kernel.org..
> git tree:       upstream
> console+strace: =
https://syzkaller.appspot.com/x/log.txt?x=3D135d7aa2580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dcae1291240e8962a
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dcd063f869beedf5b9cd7
> compiler:       Debian clang version 20.1.7 =
(++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD =
20.1.7
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D14dcc6a2580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D133e02f0580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/a762497d1fce/disk-352af6a0.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/3055e1e47995/vmlinux-352af6a0=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/aa300ee98202/bzImage-352af6a0=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/de2a4b00a48a/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
>=20
> bcachefs (loop0): error reading btree root btree=3Dsubvolumes level=3D0:=
 btree_node_read_error, fixing
> bcachefs (loop0): invalid bkey in btree_node btree=3Dsnapshot_trees =
level=3D0: u64s 6 type snapshot_tree POS_MIN len 0 ver 0: subvol 1 root =
snapshot 4294967295
>  bad pos, deleting
> bcachefs (loop0): error reading btree root btree=3Dsnapshot_trees =
level=3D0: btree_node_read_error, fixing
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in =
fs/bcachefs/disk_accounting.c:238:2
> index 175 is out of range for type 'const unsigned int[9]'
> CPU: 0 UID: 0 PID: 5849 Comm: syz-executor427 Tainted: G        W      =
     6.16.0-syzkaller-11322-g352af6a011d5 #0 PREEMPT_{RT,(full)}=20
> Tainted: [W]=3DWARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 07/12/2025
> Call Trace:
> <TASK>
> dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
> __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
> bch2_accounting_validate+0x112f/0x1400 =
fs/bcachefs/disk_accounting.c:238
> bch2_bkey_val_validate+0x202/0x3e0 fs/bcachefs/bkey_methods.c:143
> btree_node_bkey_val_validate fs/bcachefs/btree_io.c:880 [inline]
> bch2_btree_node_read_done+0x4051/0x5550 fs/bcachefs/btree_io.c:1303
> btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
> bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
> __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
> bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
> read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
> bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
> bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
> bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
> vfs_get_tree+0x92/0x2b0 fs/super.c:1815
> do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
> do_mount fs/namespace.c:4133 [inline]
> __do_sys_mount fs/namespace.c:4344 [inline]
> __se_sys_mount+0x317/0x410 fs/namespace.c:4321
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5016bf5eaa
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd552f5c58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffd552f5c70 RCX: 00007f5016bf5eaa
> RDX: 0000200000001000 RSI: 0000200000000000 RDI: 00007ffd552f5c70
> RBP: 0000200000000000 R08: 00007ffd552f5cb0 R09: 000000000000492c
> R10: 0000000000000000 R11: 0000000000000282 R12: 0000200000001000
> R13: 00007ffd552f5cb0 R14: 0000000000000003 R15: 0000000000000000
> </TASK>
> ---[ end trace ]---
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20


#syz test

diff --git a/fs/bcachefs/disk_accounting.c =
b/fs/bcachefs/disk_accounting.c
index f96530c70262..4f5b290dc8f1 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -184,6 +184,11 @@ int bch2_accounting_validate(struct bch_fs *c, =
struct bkey_s_c k,
        void *end =3D &acc_k + 1;
        int ret =3D 0;
=20
+       bkey_fsck_err_on(acc_k.type >=3D BCH_DISK_ACCOUNTING_TYPE_NR,
+                        c, accounting_key_type_invalid,
+                        "invalid accounting type (%u >=3D %u)",
+                        acc_k.type, BCH_DISK_ACCOUNTING_TYPE_NR);
+
        bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
                         bversion_zero(k.k->bversion),
                         c, accounting_key_version_0,
diff --git a/fs/bcachefs/sb-errors_format.h =
b/fs/bcachefs/sb-errors_format.h
index 5317b1bfe2e5..5ba28a684f51 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -328,6 +328,7 @@ enum bch_fsck_flags {
        x(accounting_key_replicas_devs_unsorted,                280,    =
FSCK_AUTOFIX)   \
        x(accounting_key_version_0,                             282,    =
FSCK_AUTOFIX)   \
        x(accounting_key_nr_counters_wrong,                     307,    =
FSCK_AUTOFIX)   \
+       x(accounting_key_type_invalid,                          325,    =
FSCK_AUTOFIX)   \
        x(logged_op_but_clean,                                  283,    =
FSCK_AUTOFIX)   \
        x(compression_opt_not_marked_in_sb,                     295,    =
FSCK_AUTOFIX)   \
        x(compression_type_not_marked_in_sb,                    296,    =
FSCK_AUTOFIX)   \
@@ -336,7 +337,7 @@ enum bch_fsck_flags {
        x(dirent_stray_data_after_cf_name,                      305,    =
0)              \
        x(rebalance_work_incorrectly_set,                       309,    =
FSCK_AUTOFIX)   \
        x(rebalance_work_incorrectly_unset,                     310,    =
FSCK_AUTOFIX)   \
-       x(MAX,                                                  325,    =
0)
+       x(MAX,                                                  326,    =
0)
=20
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t =3D n,

