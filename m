Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985D5257AC1;
	Mon,  4 Aug 2025 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309948; cv=none; b=m4ZQOPn9Ma3L+QefxfseXr2N8gC8kHPI8MUNjxSTF0s3CKWrSHnxhTLD7Zeh+dd0MW8y3z8F01Ooz5lauGntfGDVnTpQUzGQaMhRi1YLBavk+oMct1i67PU32BDjTbxlSpgeyNCZ3g8K/hPtSyvSH/dPtRzBt7BXBGIOdy63Qt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309948; c=relaxed/simple;
	bh=jkDSZv15qwXHRGH6CvYE9qsG7GZKM4wGoeyjhRgxphQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fcT/G1bzVutVG+W+YtQvR6Dh5+UUtkjBvFSDh48PUYwF0h5E+L3OaJW9yJP31ZGboYNRZQFZb6yy5N6yuL7B0QmpsBCg1tGaFBuWfW2NNRtLW8C3PSaVTEG6+WPhS7LFzjRCeQs+OMmJnFe6sbuMgPv0D1gOdrQxu3ELi/TKezU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLWFMJGm; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLWFMJGm"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76bd041c431so3436390b3a.2;
        Mon, 04 Aug 2025 05:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754309946; x=1754914746; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+vDNMJj4rQAYFZ3+H0cE5vrDV6ZSRr+XQ0at8pKMLw=;
        b=NLWFMJGmFc82H4of2vtVFCnuS0NBZP+Shr5Nm4ky9lW0AzOZ/aZs7yxvA7nYMpZb1M
         zyW3Of7CyNxkLG1AiM5pEKbq/au6A+eYctHr+2PAvC9o0N+mP2JAxhIcMtIaSAe+YdOm
         XDBN2xkmk7KTsRmh9VOgVPACjlQNXDNjNvt05vjPEPEfC9bEmXeRqfPg3uMAxML7ItSz
         nAV0HbB9czfarj+j46eQpv2AIbx7hGs8NCd1q+2XC18yXUO13ov+X0FYw0HLo1Ie9c23
         LPRbMtJXM4wOcKIaYKTKViHraLl7qXz3wOFMbNBajmtS5uZuWXkZlD/Svv7Q1ZG1o3P7
         CfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309946; x=1754914746;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+vDNMJj4rQAYFZ3+H0cE5vrDV6ZSRr+XQ0at8pKMLw=;
        b=UVOrPQlLry9MAcBkg7vCHOOUc9YqCc7ZZoQkLIEE86M4YnF4o4/z6l88RtQPAUHWoO
         vCaquubcR+J6fBZM9s35OCAJu+ZKdI295+q4QlDhiX/49RHRVfMFMqSElAs/5teEPRTm
         ChQVXquiZ9G3XKXamOntD1tXlpHURPdNx1jXPf13UG/TPmcDjQ/ly3az38IPFLCiKR9+
         AqN0HGFWSH+u/kW34XyBPMQnpuCteUuRYI81XKmhwbqe9DcBGrs8ABDK1Q1G/hua0HJO
         5c/WM1F8xDUN9Gge+vYGK8k2vb+iRuhwY1FvbimH2413RFf8j9GPqA9VShXoZqwD3Eh3
         SS3A==
X-Forwarded-Encrypted: i=1; AJvYcCVueMs3vXQVTRO5IGXCFFIgS0JQdneDHj49lFbt4GH+J5euncxClWiekmKVRoAE+I8TGMCpper3Kw6QHvNc@vger.kernel.org, AJvYcCXspT42vcHFmA0IWZfyFUu8L8e9ygGAEvPZbo9CSrw3EBxdMyB7NKUe4gqg1FYhK0H2idA3Hy9XMFJckcTVrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxY48sIir/7Fxp+oJtNYb4G/KGh0xfNvu8+BLyF7GSKvSOxESIF
	aE9SAX9L1uSpKUMaOxE/NMwgic0L5LGLjbAst1vUPY70ezhli7iC9QE2
X-Gm-Gg: ASbGnctiOM32QW7aWp8t7WxP/kA3usfEeFnitZBu/xLaBKAsBH1PsdF6sNyqUROzOQ8
	oqEF5bFm3iJcpgzwNcHCVhTagpOwBmwdsr4yvoVv+6+ucwakENeYTC3cCaLCvnigB9sqMi2Q24i
	skAH5fBkxNS3BjaL+wSrBsyq0gLXGtLCTJChr1rZy2p5kOqAo9vmq9H8kfPxikux9obxkJj1iRQ
	3WXLHkmtK4g0jL3vq+V4HxGL3j0o9OLvBE0VsIPsQXgv+7wtsN4xZnjz/tG41qBWgX4gn2DItdx
	rpPHXnIFt1Kuiu6swWVTiAvU4IHHIEH1Z/y/Qjlbos4QHaAXaOYHhUMcjz5xGwbuK/54UDdqJeC
	6Fpy0bA==
X-Google-Smtp-Source: AGHT+IE4qWpC9zVh0oULXPE6A7TXw0EdAhTl3tWtZ8f2xl/XDdxWwPFBTv3hATb3NDd1ajQ1TrTPqg==
X-Received: by 2002:a05:6a00:140e:b0:76b:fe65:71f5 with SMTP id d2e1a72fcca58-76bfe6574demr5576739b3a.20.1754309945674;
        Mon, 04 Aug 2025 05:19:05 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bf148333dsm5213358b3a.100.2025.08.04.05.19.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:19:05 -0700 (PDT)
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
Date: Mon, 4 Aug 2025 20:18:49 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7C64869-A0CE-4C77-9838-E86A0C31C1C2@gmail.com>
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


#syz test:

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

