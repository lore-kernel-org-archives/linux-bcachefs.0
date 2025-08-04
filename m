Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F988253931
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309950; cv=none; b=gE5PZSXyauc/4WN8hxp82j+BZM5oS5GTMxyjc4359uSh7w3oqW8TBWMfnqCDdxmmVdSI4MDPliEcXMzx6CBdG7t+H6Lk1ti/1DEyfq5TTfDREt9m+tkYtT+DagkYbql+9apfoFkyS5TaLws5vrsqJ0toc6TXjIKE368qMMGJzBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309950; c=relaxed/simple;
	bh=ChDc5J+I6BOVgCWeZ+q7JgjE+UM97VG+eXv6Hlju3Dk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tjEuuiyBGGiFxQLMaGi6VspYMEz8rGr0kcAyzHFhH1elvPDyKIex+U6XRjA9gwJyfP8yEtYOnabfJ9N77NnPcbpqYp4VUs4hKBjOOq5C+E02ck9ChAdpNu0H/3fYUS1wEcWdVq6YovfIk5CNObCZXgEb3pjCunnTFktx0LPVbWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3e401ca74fbso32565535ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 05:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309947; x=1754914747;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z57i5H0WxvDf3+coeJXJ6pHhujcF0Ys9zSadkwnHR2Q=;
        b=rmjOx0zNuoT/ZPb4qaoKmqupxBJI7ogOtU8verKyfhGKM3UQM5Fx1vB1t4Vnu0L3h4
         C+3iIJzlriFZ1kULTKYR7P/MmpgC1QNju2Tm4+Xhmg2Zo/JwkZ0XGPvuznuY2WBoLiVH
         gZTnoY2UUFsxAgi2iQTo0qA6p1Qb6TKErm9q/nO3fJY5fp0/2kNpIZIj4lJ699pn0UrL
         NDm9HXuWZurcA1i8NlT8ohKsfDCqZ6VLGpEnb2G0XM8hnUJ+btawG5OmEt93tLIe3oRj
         gR61SCuAsb31mI8rZnMcMleuZSVOkTB/kG5BCrxNIDL+gOoGnd1Yejs49fDfqI3w23rT
         57bw==
X-Forwarded-Encrypted: i=1; AJvYcCXShpJDqTBMwuX5lz4ezrM0O1zwryoHOce9nmjpFTqysQ4Im1DUmY8rs/ZmlQj6eBhc5Cq4bAwq+V6hQCkFdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUkOEXZxhszKTCMqrfguJ6yKB9riTgQaPLsLE9nVg+jP72YXn4
	iWPdQbqwunED8oTmhaRJmDvFk+QiLEszOXRCGI6p5JeffvfA83GKZbsqsz3yEwLFqZhC02Zm2hU
	46dY6r+uErOFj1Sxfews4U5kqJs586QYjsoDab9vNTAdEFnNySiT8cjU0/Kw=
X-Google-Smtp-Source: AGHT+IEJOBTdi2aNPO36e/O34CebS0gThXMn70P6CyO5XX9VuEUWtA2a4fDAVP7jMCWqUytLECF1mSSdJNugT0Zgv2eXLWGrJUe1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f12:b0:3e3:cfa2:c8f with SMTP id
 e9e14a558f8ab-3e41612a0e2mr163111445ab.9.1754309947301; Mon, 04 Aug 2025
 05:19:07 -0700 (PDT)
Date: Mon, 04 Aug 2025 05:19:07 -0700
In-Reply-To: <C7C64869-A0CE-4C77-9838-E86A0C31C1C2@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6890a53b.050a0220.7f033.0008.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_accounting_validate
From: syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com>
To: mmpgouride@gmail.com
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On Aug 4, 2025, at 15:18, syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com> wrote:
>> 
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    352af6a011d5 Merge tag 'rust-6.17' of git://git.kernel.org..
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=135d7aa2580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=cae1291240e8962a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=cd063f869beedf5b9cd7
>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dcc6a2580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133e02f0580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/a762497d1fce/disk-352af6a0.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/3055e1e47995/vmlinux-352af6a0.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/aa300ee98202/bzImage-352af6a0.xz
>> mounted in repro: https://storage.googleapis.com/syzbot-assets/de2a4b00a48a/mount_0.gz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
>> 
>> bcachefs (loop0): error reading btree root btree=subvolumes level=0: btree_node_read_error, fixing
>> bcachefs (loop0): invalid bkey in btree_node btree=snapshot_trees level=0: u64s 6 type snapshot_tree POS_MIN len 0 ver 0: subvol 1 root snapshot 4294967295
>>  bad pos, deleting
>> bcachefs (loop0): error reading btree root btree=snapshot_trees level=0: btree_node_read_error, fixing
>> ------------[ cut here ]------------
>> UBSAN: array-index-out-of-bounds in fs/bcachefs/disk_accounting.c:238:2
>> index 175 is out of range for type 'const unsigned int[9]'
>> CPU: 0 UID: 0 PID: 5849 Comm: syz-executor427 Tainted: G        W           6.16.0-syzkaller-11322-g352af6a011d5 #0 PREEMPT_{RT,(full)} 
>> Tainted: [W]=WARN
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
>> Call Trace:
>> <TASK>
>> dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>> ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
>> __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
>> bch2_accounting_validate+0x112f/0x1400 fs/bcachefs/disk_accounting.c:238
>> bch2_bkey_val_validate+0x202/0x3e0 fs/bcachefs/bkey_methods.c:143
>> btree_node_bkey_val_validate fs/bcachefs/btree_io.c:880 [inline]
>> bch2_btree_node_read_done+0x4051/0x5550 fs/bcachefs/btree_io.c:1303
>> btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
>> bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
>> __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
>> bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
>> read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
>> bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
>> bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
>> bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
>> vfs_get_tree+0x92/0x2b0 fs/super.c:1815
>> do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>> do_mount fs/namespace.c:4133 [inline]
>> __do_sys_mount fs/namespace.c:4344 [inline]
>> __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f5016bf5eaa
>> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffd552f5c58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
>> RAX: ffffffffffffffda RBX: 00007ffd552f5c70 RCX: 00007f5016bf5eaa
>> RDX: 0000200000001000 RSI: 0000200000000000 RDI: 00007ffd552f5c70
>> RBP: 0000200000000000 R08: 00007ffd552f5cb0 R09: 000000000000492c
>> R10: 0000000000000000 R11: 0000000000000282 R12: 0000200000001000
>> R13: 00007ffd552f5cb0 R14: 0000000000000003 R15: 0000000000000000
>> </TASK>
>> ---[ end trace ]---
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> 
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>> 
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>> 
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>> 
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>> 
>> If you want to undo deduplication, reply with:
>> #syz undup
>> 
>
>
> #syz test:

want either no args or 2 args (repo, branch), got 4

>
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index f96530c70262..4f5b290dc8f1 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -184,6 +184,11 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
>         void *end = &acc_k + 1;
>         int ret = 0;
>  
> +       bkey_fsck_err_on(acc_k.type >= BCH_DISK_ACCOUNTING_TYPE_NR,
> +                        c, accounting_key_type_invalid,
> +                        "invalid accounting type (%u >= %u)",
> +                        acc_k.type, BCH_DISK_ACCOUNTING_TYPE_NR);
> +
>         bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
>                          bversion_zero(k.k->bversion),
>                          c, accounting_key_version_0,
> diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
> index 5317b1bfe2e5..5ba28a684f51 100644
> --- a/fs/bcachefs/sb-errors_format.h
> +++ b/fs/bcachefs/sb-errors_format.h
> @@ -328,6 +328,7 @@ enum bch_fsck_flags {
>         x(accounting_key_replicas_devs_unsorted,                280,    FSCK_AUTOFIX)   \
>         x(accounting_key_version_0,                             282,    FSCK_AUTOFIX)   \
>         x(accounting_key_nr_counters_wrong,                     307,    FSCK_AUTOFIX)   \
> +       x(accounting_key_type_invalid,                          325,    FSCK_AUTOFIX)   \
>         x(logged_op_but_clean,                                  283,    FSCK_AUTOFIX)   \
>         x(compression_opt_not_marked_in_sb,                     295,    FSCK_AUTOFIX)   \
>         x(compression_type_not_marked_in_sb,                    296,    FSCK_AUTOFIX)   \
> @@ -336,7 +337,7 @@ enum bch_fsck_flags {
>         x(dirent_stray_data_after_cf_name,                      305,    0)              \
>         x(rebalance_work_incorrectly_set,                       309,    FSCK_AUTOFIX)   \
>         x(rebalance_work_incorrectly_unset,                     310,    FSCK_AUTOFIX)   \
> -       x(MAX,                                                  325,    0)
> +       x(MAX,                                                  326,    0)
>  
>  enum bch_sb_error_id {
>  #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
>
