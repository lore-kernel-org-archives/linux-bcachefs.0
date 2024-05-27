Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37EC8DD
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716788794; cv=none; b=aGsKSs3IQgxef0Sj6O2jL4PZbpX0y7Lud7N9X0gAXuNt6S6n8r8x9S40aezBSoLTAoiaH6q25DVoQOMdC10x3EQHAHSFgqofWbesR0J65m8TvNacq2BC/031TmxcFoyyBOXjQTL0ZOm5TNTsKURsKaOcFimFSUCaZ9dCoER71zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716788794; c=relaxed/simple;
	bh=JDREHXtA6hrsuq9NcZhGYeSA55DsP9HTCLOFUmES4y8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NDfLKYGwJbdHBHDRmR4jo6HmcCBLX7ySzuwC6MCqZJlasZfEtjZZv90kupI+atZg47MgyXrTcqMLvHDiL0OnNCBrYExMtc4AEE06//Dt0daLXQF/1iYyRpIlJFnsO6+1IBIaxV8Xv0uctmPQM2XhS/TYJH3l1ocP2210vq9Q9G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1ea8608afso520542139f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 22:46:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716788792; x=1717393592;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eoePI8+Uagsc64bsTTkvo3I3ImVsjVcK2iJj9qarNuo=;
        b=PXu1q94yOcQEeG1klk30AlfDAtB+F5C5vdL9pBk6INPLIIJAqSo/D8AbXAgRhgEp9T
         vwhv6AaHSvRAdleSLqIdyUnMlyavHJ38dNR/xEw7AJ2SIstBGmGDih5p5P7JxOZrJXhY
         V/1bgQGWbUuzCgMhtnkGVCwGWgO8PZXDaiupr5hLUPs6yByUou04mccomwC5W6hJK4AT
         80qINtZ80ai+hsXuWSsMZ4VDwVS03AwElei4ecVEcMEsW7Wdg279+zey3qFaOjOfwKSa
         WAV/k81QsMExeSCBHQlvAMiCntqP1T4mMsfF5F4M9FD/yYwyzXuFQ2T4gxph4pOsIGy6
         zVlg==
X-Forwarded-Encrypted: i=1; AJvYcCUA8wmUllMg02TCC7GehGgAlIsbPzdefeVpQiW72N8W5OfKQ2G2Ekc40EFSb/VJ9+/OMlORhf2CihHOZ7v3gmlXS5Ovz8CllZIYVVvRWxo=
X-Gm-Message-State: AOJu0YwLmOR/QWy148fAl6PfIOrAYAh741vbCkpnB813MOT6IFf45Gbq
	Xk8fdq7F5azkj0jM4JVAYa5UJrX2s7NoS9cDcAMdV3CN8lk202q7+UYlj6X1OsLFl1gpFtFbTly
	eU2hFNKGoTaAQXrJ0F04Tk5ZeZ/c2rXsAmOtWPOQjGWLhFPbgPHuZapA=
X-Google-Smtp-Source: AGHT+IFL7UobkM013JqxyT1751ArKjZ2jABRaBcbpVFfLFMCm+M2dOsFp+mPuT06zPBHXfw6p74+s698Rzzy7UTtz0QzjOO7uIi0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:158d:b0:7e2:b00:2277 with SMTP id
 ca18e2360f4ac-7e8c6933fa2mr41748139f.2.1716788792669; Sun, 26 May 2024
 22:46:32 -0700 (PDT)
Date: Sun, 26 May 2024 22:46:32 -0700
In-Reply-To: <000000000000e15f4b06193763db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002447c40619690af2@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in rw_aux_tree_set
From: syzbot <syzbot+681f3c43b6970652376b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124e4572980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=681f3c43b6970652376b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b28f42980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142ddb52980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/61af6ba34933/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+681f3c43b6970652376b@syzkaller.appspotmail.com

bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 12
=====================================================
BUG: KMSAN: uninit-value in bkey_unpack_pos fs/bcachefs/bkey.h:455 [inline]
BUG: KMSAN: uninit-value in rw_aux_tree_set+0x4d2/0x580 fs/bcachefs/bset.c:521
 bkey_unpack_pos fs/bcachefs/bkey.h:455 [inline]
 rw_aux_tree_set+0x4d2/0x580 fs/bcachefs/bset.c:521
 bch2_bset_fix_lookup_table+0x16b2/0x1e90 fs/bcachefs/bset.c:995
 bch2_bset_insert+0x1617/0x19f0 fs/bcachefs/bset.c:1042
 bch2_btree_bset_insert_key+0xf56/0x2b70 fs/bcachefs/btree_trans_commit.c:194
 bch2_btree_insert_key_leaf+0x276/0x1050 fs/bcachefs/btree_trans_commit.c:277
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:744 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:854 [inline]
 __bch2_trans_commit+0x98e6/0xab10 fs/bcachefs/btree_trans_commit.c:1093
 bch2_trans_commit fs/bcachefs/btree_update.h:168 [inline]
 btree_key_cache_flush_pos fs/bcachefs/btree_key_cache.c:672 [inline]
 bch2_btree_key_cache_journal_flush+0x10f9/0x1990 fs/bcachefs/btree_key_cache.c:748
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 journal_flush_done+0xe1/0x3f0 fs/bcachefs/journal_reclaim.c:806
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:839
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x1b9/0x750 fs/bcachefs/super.c:277
 bch2_fs_read_only+0xcb4/0x1540 fs/bcachefs/super.c:357
 __bch2_fs_stop+0x112/0x6f0 fs/bcachefs/super.c:622
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:1791
 generic_shutdown_super+0x194/0x4c0 fs/super.c:641
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2015
 deactivate_locked_super+0xe0/0x3f0 fs/super.c:472
 deactivate_super+0x14f/0x160 fs/super.c:505
 cleanup_mnt+0x6c6/0x730 fs/namespace.c:1267
 __cleanup_mnt+0x22/0x30 fs/namespace.c:1274
 task_work_run+0x268/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x160 kernel/entry/common.c:218
 do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
 __do_kmalloc_node mm/slub.c:4027 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
 bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 PID: 5060 Comm: syz-executor338 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
