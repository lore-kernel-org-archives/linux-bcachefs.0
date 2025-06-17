Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222212F2375
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175790; cv=none; b=I9N4DFr/WGDUBjAiaUR5avevd1lbo36C8+f+FLugI2sj2MUjEUr6aefVFLLfIxiUQtxpJu03eecMoajfO8QgHyHzcveS0U3Gpz9oQ5cHigmmMDeMS84iptolfFrom79R13Wyk2QrBuKVUOE7NcFtJaUahpyrsv4C+bA3aB2M3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175790; c=relaxed/simple;
	bh=RGRnkECr5n3/DDT27ZVZu7IMiTSokd33b4A2E+dwDMQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UystUOZIPORvIylWQJWgfMgjz2I/rAMFdqlgl023Ktq5Qi5WuTm7BqThWnpf8PSaZwwUW7YMNv8PmldesKch94RaiWQIJtUpO0tUcRVmYJo+aefelN5G/FJ+7qH4bOXd+Khqnf+49upF0jaE8jNeJBxEQ/4EZZMPTYCX/ZCTZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ddd03db21cso101373075ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 08:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175787; x=1750780587;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LIgPSCKjElwDdYYwEQMlrvQkf1oqMpFPHHeVWEqnJOQ=;
        b=TFFMr25vIFL3z9Qx12XLPCANZCQwwnq+xSr2uldRle2lYz62WgH3zoV2M3oKTwoyRC
         IRuMiaU02LHN1YJFPNqZfJOcfrM2lQjyu9NIm95Dmt9ng+kKg/cP9f4OlsU88db4am0j
         mvDnk8ViWMBtOgzsDAfQo5dQenJL4sT+Bm8jebKRzo/lyCzCrTQdp+KmxdOPCFERx4r8
         Rh+u7qjP8EhEP8OS5GHMxMmX18gum23ytUzQyjxGFDOuanTkF2V6AI/j+fye6iZ/hvWN
         a9qNBpp2PlhzBmEGEN/V9UOR+zZIjtZpK6IvumnOm05HpUwDfBv1BuE4c8YXkVFNPy0M
         k7mA==
X-Forwarded-Encrypted: i=1; AJvYcCXQakP5D8S0ksNfSZ99N4213p2/WkqI8ukYTrzGZrLkPugFQ0Ns8QVtwsyK+adxMrfBgivapQGyxO51XwvG9g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2VeAAR0A3kCiChlscmBdTGQnAKLsn7Beu4mbJAY8zJ0c3pxWZ
	260RMl62QywwGT/87HdrJbLvbePWu2KbpRQ1EGLvYKCVqRj5qvB91w0Mi3VgvVQjiGXDDAba4SR
	YSz4PrvHBH52O2pWFCX/8TXp4mlV9P17l5Ayzdynxk7Dql7Hs4/UzpFfR2kY=
X-Google-Smtp-Source: AGHT+IEUi7GFMDpl47GaU3HqBMpHHwtQ82OzDls8DjvbcpguVzeHDyvfJzY5F8Y2yIljaOGbV/Wn6TWn5H1ywN4pYKoTD2MJpFW1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198e:b0:3dc:7a9a:44d5 with SMTP id
 e9e14a558f8ab-3de07ced270mr156209075ab.22.1750175787196; Tue, 17 Jun 2025
 08:56:27 -0700 (PDT)
Date: Tue, 17 Jun 2025 08:56:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6851902b.a70a0220.395abc.0223.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Write in bch2_dirent_init_name
From: syzbot <syzbot+894877f2c4dd5fdea634@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    39dfc971e42d arm64/ptrace: Fix stack-out-of-bounds read in..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14e965d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=941e423b930a32dc
dashboard link: https://syzkaller.appspot.com/bug?extid=894877f2c4dd5fdea634
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ee1a7942f1b9/disk-39dfc971.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b94ed3d0f7e/vmlinux-39dfc971.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9ce219d3314e/Image-39dfc971.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+894877f2c4dd5fdea634@syzkaller.appspotmail.com

bcachefs (loop3): bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
  Ratelimiting new instances of previous error
BUG: MAX_LOCKDEP_CHAINS too low!
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 9405 Comm: syz.3.515 Not tainted 6.16.0-rc1-syzkaller-g39dfc971e42d #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 add_chain_cache kernel/locking/lockdep.c:-1 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3858 [inline]
 validate_chain kernel/locking/lockdep.c:3879 [inline]
 __lock_acquire+0xf9c/0x30a4 kernel/locking/lockdep.c:5240
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5871
 percpu_down_write+0x6c/0x2f0 kernel/locking/percpu-rwsem.c:232
 bch2_gc_accounting_done+0xe64/0x190c fs/bcachefs/disk_accounting.c:625
 bch2_check_allocations+0x3a38/0x3c34 fs/bcachefs/btree_gc.c:1063
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:477 [inline]
 __bch2_run_recovery_passes+0x29c/0xd18 fs/bcachefs/recovery_passes.c:532
 bch2_run_recovery_passes+0x174/0x1f4 fs/bcachefs/recovery_passes.c:603
 bch2_fs_recovery+0x1db8/0x2fd4 fs/bcachefs/recovery.c:974
 bch2_fs_start+0x914/0xbc0 fs/bcachefs/super.c:1200
 bch2_fs_get_tree+0x890/0xfd0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x90/0x28c fs/super.c:1802
 do_new_mount+0x228/0x814 fs/namespace.c:3885
 path_mount+0x5b4/0xde0 fs/namespace.c:4209
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount fs/namespace.c:4410 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4410
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
 done
bcachefs (loop3): going read-write
bcachefs (loop3): journal_replay...
 done
bcachefs (loop3): check_alloc_info... done
bcachefs (loop3): check_lrus... done
bcachefs (loop3): check_btree_backpointers... done
bcachefs (loop3): check_backpointers_to_extents... done
bcachefs (loop3): check_extents_to_backpointers...
bcachefs (loop3): scanning for missing backpointers in 4/128 buckets
 done
bcachefs (loop3): check_alloc_to_lru_refs... done
bcachefs (loop3): bucket_gens_init... done
bcachefs (loop3): check_snapshot_trees... done
bcachefs (loop3): check_snapshots...
bcachefs (loop3): snapshot points to missing/incorrect tree:
  u64s 8 type snapshot 0:4294967295:0 len 0 ver 0: subvol parent          0 children          0          0 subvol 1 tree 0, fixing
 done
bcachefs (loop3): check_subvols... done
bcachefs (loop3): check_subvol_children... done
bcachefs (loop3): delete_dead_snapshots... done
bcachefs (loop3): check_inodes...
bcachefs (loop3): inode points to missing dirent
  inum: 4099:4294967295 
    mode=100755
    flags=(15300000)
    journal_seq=5
    hash_seed=fc917866faeb7b5b
    hash_type=siphash
    bi_size=1050
    bi_sectors=8
    bi_version=0
    bi_atime=2770562249
    bi_ctime=2770562249
    bi_mtime=2770562249
    bi_otime=2770562249
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
    bi_dir_offset=8977922886548783724
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop3): inode points to missing dirent
  inum: 4100:4294967295 
    mode=120777
    flags=(15300000)
    journal_seq=4
    hash_seed=f4891abdd5c0cd85
    hash_type=siphash
    bi_size=38
    bi_sectors=8
    bi_version=0
    bi_atime=2770562249
    bi_ctime=2780562352
    bi_mtime=2770562249
    bi_otime=2770562249
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
    bi_dir_offset=5675548428000973578
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
 done
bcachefs (loop3): check_extents... done
bcachefs (loop3): check_indirect_extents... done
bcachefs (loop3): check_dirents...
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 7 type dirent 4096:189491840996961599:U32_MAX len 0 ver 0: file0 -> 4098 type dir, fixing
==================================================================
BUG: KASAN: slab-out-of-bounds in bch2_dirent_init_name+0x28c/0x670 fs/bcachefs/dirent.c:271
Write of size 1985 at addr ffff0000ce7a8041 by task syz.3.515/9405

CPU: 0 UID: 0 PID: 9405 Comm: syz.3.515 Tainted: G        W           6.16.0-rc1-syzkaller-g39dfc971e42d #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x254 mm/kasan/report.c:408
 print_report+0x68/0x84 mm/kasan/report.c:521
 kasan_report+0xb0/0x110 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2a4 mm/kasan/generic.c:189
 __asan_memset+0x34/0x64 mm/kasan/shadow.c:84
 bch2_dirent_init_name+0x28c/0x670 fs/bcachefs/dirent.c:271
 bch2_dirent_create_key+0x1b4/0x434 fs/bcachefs/dirent.c:316
 check_dirent fs/bcachefs/fsck.c:2223 [inline]
 bch2_check_dirents+0x1d1c/0x27ac fs/bcachefs/fsck.c:2326
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:477 [inline]
 __bch2_run_recovery_passes+0x29c/0xd18 fs/bcachefs/recovery_passes.c:532
 bch2_run_recovery_passes+0x174/0x1f4 fs/bcachefs/recovery_passes.c:603
 bch2_fs_recovery+0x1db8/0x2fd4 fs/bcachefs/recovery.c:974
 bch2_fs_start+0x914/0xbc0 fs/bcachefs/super.c:1200
 bch2_fs_get_tree+0x890/0xfd0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x90/0x28c fs/super.c:1802
 do_new_mount+0x228/0x814 fs/namespace.c:3885
 path_mount+0x5b4/0xde0 fs/namespace.c:4209
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount fs/namespace.c:4410 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4410
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

Allocated by task 9405:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x44/0x54 mm/kasan/generic.c:562
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x9c/0xb4 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kmalloc_node_track_caller_noprof+0x304/0x4d0 mm/slub.c:4347
 __do_krealloc mm/slub.c:4905 [inline]
 krealloc_noprof+0x11c/0x2f0 mm/slub.c:4958
 __bch2_trans_kmalloc+0x1f4/0xb8c fs/bcachefs/btree_iter.c:3187
 bch2_trans_kmalloc_ip fs/bcachefs/btree_iter.h:604 [inline]
 bch2_trans_kmalloc+0x10c/0x160 fs/bcachefs/btree_iter.h:616
 bch2_dirent_create_key+0x50/0x434 fs/bcachefs/dirent.c:299
 check_dirent fs/bcachefs/fsck.c:2223 [inline]
 bch2_check_dirents+0x1d1c/0x27ac fs/bcachefs/fsck.c:2326
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:477 [inline]
 __bch2_run_recovery_passes+0x29c/0xd18 fs/bcachefs/recovery_passes.c:532
 bch2_run_recovery_passes+0x174/0x1f4 fs/bcachefs/recovery_passes.c:603
 bch2_fs_recovery+0x1db8/0x2fd4 fs/bcachefs/recovery.c:974
 bch2_fs_start+0x914/0xbc0 fs/bcachefs/super.c:1200
 bch2_fs_get_tree+0x890/0xfd0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x90/0x28c fs/super.c:1802
 do_new_mount+0x228/0x814 fs/namespace.c:3885
 path_mount+0x5b4/0xde0 fs/namespace.c:4209
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount fs/namespace.c:4410 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4410
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

The buggy address belongs to the object at ffff0000ce7a8000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 65 bytes inside of
 allocated 2048-byte region [ffff0000ce7a8000, ffff0000ce7a8800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10e7a8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x5ffc00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000040 ffff0000c0002000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 05ffc00000000040 ffff0000c0002000 dead000000000100 dead000000000122
head: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 05ffc00000000003 fffffdffc339ea01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000ce7a8700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff0000ce7a8780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff0000ce7a8800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff0000ce7a8880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff0000ce7a8900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 7 type dirent 4096:1896155912177158345:U32_MAX len 0 ver 0: file3 -> 536870913 type reg, fixing
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 7 type dirent 4096:2695648408715017799:U32_MAX len 0 ver 0: file2 -> 536870913 type reg, fixing
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 7 type dirent 4096:4330382808765833931:U32_MAX len 0 ver 0: file1 -> 536870912 type reg, fixing
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 8 type dirent 4096:8130059955150870709:U32_MAX len 0 ver 0: lost+found -> 4097 type dir, fixing
bcachefs (loop3): dirent casefold does not match dir casefold
  u64s 8 type dirent 4096:9097378837824744618:U32_MAX len 0 ver 0: file.cold -> 536870914 type reg, fixing
bcachefs (loop3): directory 4096:4294967295 with wrong i_nlink: got 2, should be 0, fixing
 done
bcachefs (loop3): check_xattrs... done
bcachefs (loop3): check_root... done
bcachefs (loop3): check_unreachable_inodes...
bcachefs (loop3): unreachable inode:
  inum: 4099:4294967295 
    mode=100755
    flags=(4300000)
    journal_seq=22
    hash_seed=fc917866faeb7b5b
    hash_type=siphash
    bi_size=1050
    bi_sectors=8
    bi_version=0
    bi_atime=2770562249
    bi_ctime=2770562249
    bi_mtime=2770562249
    bi_otime=2770562249
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
    bi_dir=0
    bi_dir_offset=0
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop3): creating //lost+found in subvol 1 snapshot 4294967295
bcachefs (loop3): creating //lost+found in subvol 1 snapshot 4294967295
bcachefs (loop3): creating //lost+found in subvol 1 snapshot 4294967295
bcachefs (loop3): unreachable inode:
  inum: 4100:4294967295 
    mode=120777
    flags=(4300000)
    journal_seq=22
    hash_seed=f4891abdd5c0cd85
    hash_type=siphash
    bi_size=38
    bi_sectors=8
    bi_version=0
    bi_atime=2770562249
    bi_ctime=2780562352
    bi_mtime=2770562249
    bi_otime=2770562249
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
    bi_dir=0
    bi_dir_offset=0
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop3): unreachable inode:
  inum: 536870913:4294967295 
    mode=100755
    flags=(15300000)
    journal_seq=23
    hash_seed=b68791a594a6d5ae
    hash_type=siphash
    bi_size=25769812776
    bi_sectors=24
    bi_version=0
    bi_atime=2780562352
    bi_ctime=2780562352
    bi_mtime=2780562352
    bi_otime=2780562352
    bi_uid=0
    bi_gid=0
    bi_nlink=1
    bi_generation=0
    bi_dev=0
    bi_data_checksum=0
    bi_compression=0
    bi_project=0
    bi_background_compression=0
    bi_data_replicas=0
    bi_promote_target=1
    bi_foreground_target=0
    bi_background_target=0
    bi_erasure_code=0
    bi_fields_set=0
    bi_dir=0
    bi_dir_offset=2695648408715017799
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop3): unreachable inode:
  inum: 536870914:4294967295 
    mode=100755
    flags=(15300000)
    journal_seq=23
    hash_seed=d483206f1ed95abf
    hash_type=siphash
    bi_size=100
    bi_sectors=8
    bi_version=1126999418470400
    bi_atime=0
    bi_ctime=0
    bi_mtime=0
    bi_otime=2780562352
    bi_uid=2780562352
    bi_gid=0
    bi_nlink=2780562352
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
    bi_dir=0
    bi_dir_offset=9097378837824744618
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
 done
bcachefs (loop3): check_subvolume_structure... done
bcachefs (loop3): check_directory_structure...
bcachefs (loop3): inode points to dirent that does not point back:
u64s 10 type dirent 4096:8130059955150870709:U32_MAX len 0 ver 0: lost+found (casefold lost+found) -> 4101 type dir
inum: 4097:4294967295 
  mode=40700
  flags=has_case_insensitive(15300400)
  journal_seq=23
  hash_seed=a9fcff247692d1ca
  hash_type=siphash
  bi_size=0
  bi_sectors=0
  bi_version=0
  bi_atime=200535484
  bi_ctime=200535484
  bi_mtime=200535484
  bi_otime=200535484
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
  bi_dir=4096
  bi_dir_offset=8130059955150870709
  bi_subvol=0
  bi_parent_subvol=0
  bi_nocow=0
  bi_depth=0
  bi_inodes_32bit=0
  bi_casefold=0
bcachefs (loop3): unreachable inode in check_directory_structure: ENOENT_dirent_doesnt_match_inode
u64s 17 type inode_v3 0:4097:U32_MAX len 0 ver 0: 
  mode=40700
  flags=has_case_insensitive(15300400)
  journal_seq=23
  hash_seed=a9fcff247692d1ca
  hash_type=siphash
  bi_size=0
  bi_sectors=0
  bi_version=0
  bi_atime=200535484
  bi_ctime=200535484
  bi_mtime=200535484
  bi_otime=200535484
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
  bi_dir=4096
  bi_dir_offset=8130059955150870709
  bi_subvol=0
  bi_parent_subvol=0
  bi_nocow=0
  bi_depth=0
  bi_inodes_32bit=0
  bi_casefold=0
bcachefs (loop3): check_path_loop(): error ENOENT_dirent_doesnt_match_inode
bcachefs (loop3): bch2_check_directory_structure(): error ENOENT_dirent_doesnt_match_inode
bcachefs (loop3): error in recovery: ENOENT_dirent_doesnt_match_inodeemergency read only at seq 25
bcachefs (loop3): bch2_fs_start(): error starting filesystem ENOENT_dirent_doesnt_match_inode
bcachefs (loop3): shutting down
bcachefs (loop3): shutdown complete
bcachefs: bch2_fs_get_tree() error: ENOENT_dirent_doesnt_match_inode


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
