Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C3115665E
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 09:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318451; cv=none; b=s7MwsTTn0bBY0JRNsv7rkaXbneYvt2904ESRa5zqG9K82Eg206/oIi9kzBxUOfNNWPk4b9cIdNFahPuwRqRM7iqUhwFDtelSzglTpZxKOb3FCDjvWEgg1pr2UeWJJJ1na6t13mtZGh0PYFjKlcdma3gxof3m/xMxzORAPLDN3XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318451; c=relaxed/simple;
	bh=zvdsUIeImEN20ynEZubddx3JI+74spUCTnF290mQlvI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M4ZB+XaMjlAgFCOr4rC+qX7p+tDNAs0x6Eq/HrCuQrThN90ZwA/FSbYeK29LZYwCZ18z+RHw1nzeyveiE3l2SrHEfFFkfmzfxke5hImPfPdeueYFKvd7BQmDR/I8NqAtfNyjsl9u19/DgTOZFP4Oufvn3FCjNLXywWRBY6GwIBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83abad6594fso506878939f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 01:47:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731318447; x=1731923247;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AjpxjB9abbYFMlkuKSBbiU+plTKsyEQujgvc3Dj/rTc=;
        b=SczUGoHhb+vBuvkPcie1GPME/glic2mFDToaYYAl7r51c0yj93kbg0S+zIEzV7yZrZ
         +l64eMX9oOc7JMILBsu/2MePk3R/7QB3r3aG/VbOgdR7pgOhLsmIi9XkX9EfTWBRYdLJ
         T4MGvZSqaWkan/FuIJvzM6BgGGqk0JDukdT7do7cU0KPF7T6x14xgduvM8nNhRifgGpK
         4dSv5pu+AuOrrnhDbVbag9O5WB/QOBoYMpsBNXMExBXYN16rv/EzTL7Vhwxw+tWudlnp
         7SvQ+7OtCBPgMnq7/Yc5s0JC8OC9H1IxEryiyVbZy7nbSQRhOeM+2hVPdizr9aO9tx2t
         f6JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVHGVVvTbMh78q5PdfhsvTKwL8hdYHZBq/GdGCNqs5lVP3ruoSZLrfKAfHQ0y09b98lUl1BqN3TpymvX9Lyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4kMiu0+/vGX8d3KY2W/Axx/rqjNRKMqigZAszKJAFRybbud1B
	BFDdxHqmO7fYfQY4yS0qu5zsJaii4CiY3ufC4Ll9f+CElZeVX45dajJPkrBDEcXFlkN+rp9uzbL
	/A/ElhUVMNLS0MYHKVcLWokRHPoFhaqZQAUpdT7Cn0V1ORcHN/3uw5g8=
X-Google-Smtp-Source: AGHT+IGgLRr6ZB3Q/CtR0nEbK0cGtc4IDKwTe65Cnwh1k3DxRhsYtipMWM0zaqI/wg0XXU5a7XOh9zn4X+oF2f9TgfupZihRmvFj
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0b:b0:3a6:b8f5:715b with SMTP id
 e9e14a558f8ab-3a6f1a48fd5mr124457955ab.19.1731318447164; Mon, 11 Nov 2024
 01:47:27 -0800 (PST)
Date: Mon, 11 Nov 2024 01:47:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6731d2af.050a0220.1fb99c.014c.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in progress_init
From: syzbot <syzbot+d55ed90d27ed7725b4fd@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    c1e939a21eb1 Merge tag 'cgroup-for-6.12-rc5-fixes' of git:.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D13fdc55f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D4aec7739e14231a=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd55ed90d27ed7725b=
4fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-c1e939a2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79a07b922222/vmlinux-=
c1e939a2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a5d98e2bb0d/bzI=
mage-c1e939a2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+d55ed90d27ed7725b4fd@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=3Derrors=3Dcon=
tinue,metadata_checksum=3Dnone,data_checksum=3Dnone,compression=3Dlz4,recov=
ery_pass_last=3Dcheck_root,nojournal_transaction_names,reconstruct_alloc,no=
_data_io
invalid journal entry, version=3D1.7: mi_btree_bitmap type=3Dbtree_root in =
superblock: invalid btree root journal entry: wrong number of keys, fixing
invalid journal entry, version=3D1.7: mi_btree_bitmap type=3Dbtree_keys in =
superblock: k->u64s 0, fixing
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.7: mi_btree_bitmap incomp=
lete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.13: in=
ode_has_child_snapshots
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,set_fs_needs_rebalance
bcachefs (loop0): dropping and reconstructing all alloc info
invalid btree root extents, fixing
bcachefs (loop0): will run btree node scan
bcachefs (loop0): flagging btree extents lost data
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  inodes l=3D0 seq=3D1 journal_seq=3D12884901892 cookie=3D7589ab5e0c11cc7a =
POS_MIN-SPOS_MAX ptr: 0:38:0 gen 0
  dirents l=3D0 seq=3D1 journal_seq=3D4 cookie=3D9aa2895aefce4bdf POS_MIN-S=
POS_MAX ptr: 0:41:0 gen 0
  xattrs l=3D0 seq=3D1 journal_seq=3D4 cookie=3D2285c34bed0abe32 POS_MIN-18=
446742974197924607:18374686479671623680:50331647 ptr: 0:31:0 gen 0
  subvolumes l=3D0 seq=3D1 journal_seq=3D1 cookie=3Dc0bef60d07ceb940 POS_MI=
N-SPOS_MAX ptr: 0:35:0 gen 0
  snapshots l=3D0 seq=3D1 journal_seq=3D1 cookie=3Debb8d5a9e3463bdb POS_MIN=
-SPOS_MAX ptr: 0:32:0 gen 0
  lru l=3D0 seq=3D1 journal_seq=3D5 cookie=3D28f61e078e70b95c POS_MIN-SPOS_=
MAX ptr: 0:28:0 gen 0
  deleted_inodes l=3D0 seq=3D1 journal_seq=3D0 cookie=3D1db8f60c84bb244c PO=
S_MIN-SPOS_MAX ptr: 0:42:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root extents unreadable, must recover from scan
no nodes found for btree extents, continuing
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations... done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
 done
bcachefs (loop0): check_alloc_info... done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents...
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in accounting_pos_cmp fs/bcachefs/disk_acco=
unting.h:103 [inline]
BUG: KASAN: slab-use-after-free in bch2_accounting_mem_read fs/bcachefs/dis=
k_accounting.h:201 [inline]
BUG: KASAN: slab-use-after-free in progress_init+0x42a/0x890 fs/bcachefs/ba=
ckpointers.c:814
Read of size 4 at addr ffff88803feb7c00 by task syz.0.0/5332

CPU: 0 UID: 0 PID: 5332 Comm: syz.0.0 Not tainted 6.12.0-rc5-syzkaller-0004=
4-gc1e939a21eb1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 accounting_pos_cmp fs/bcachefs/disk_accounting.h:103 [inline]
 bch2_accounting_mem_read fs/bcachefs/disk_accounting.h:201 [inline]
 progress_init+0x42a/0x890 fs/bcachefs/backpointers.c:814
 bch2_check_backpointers_to_extents_pass fs/bcachefs/backpointers.c:1001 [i=
nline]
 bch2_check_backpointers_to_extents+0xbc9/0x2430 fs/bcachefs/backpointers.c=
:1049
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f566357feba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f566433fe68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f566433fef0 RCX: 00007f566357feba
RDX: 0000000020000180 RSI: 0000000020000000 RDI: 00007f566433feb0
RBP: 0000000020000180 R08: 00007f566433fef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000000020000000
R13: 00007f566433feb0 R14: 00000000000059e9 R15: 00000000200003c0
 </TASK>

Allocated by task 12:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __do_kmalloc_node mm/slub.c:4264 [inline]
 __kmalloc_node_noprof+0x22a/0x440 mm/slub.c:4270
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:658
 __bch2_darray_resize_noprof+0xd8/0x240 fs/bcachefs/darray.c:24
 __bch2_accounting_mem_insert fs/bcachefs/disk_accounting.c:320 [inline]
 bch2_accounting_mem_insert+0x834/0x960 fs/bcachefs/disk_accounting.c:344
 bch2_accounting_mem_mod_locked+0xa2a/0xe10 fs/bcachefs/disk_accounting.h:1=
59
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:719 [inlin=
e]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:900 [inline]
 __bch2_trans_commit+0x4432/0x93c0 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:728 [inline=
]
 btree_interior_update_work+0x1492/0x2b10 fs/bcachefs/btree_update_interior=
.c:866
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Freed by task 1029:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4727
 __bch2_darray_resize_noprof+0x18b/0x240 fs/bcachefs/darray.c:32
 __bch2_accounting_mem_insert fs/bcachefs/disk_accounting.c:320 [inline]
 bch2_accounting_mem_insert+0x834/0x960 fs/bcachefs/disk_accounting.c:344
 bch2_accounting_mem_mod_locked+0xa2a/0xe10 fs/bcachefs/disk_accounting.h:1=
59
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:719 [inlin=
e]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:900 [inline]
 __bch2_trans_commit+0x4432/0x93c0 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:728 [inline=
]
 btree_interior_update_work+0x1492/0x2b10 fs/bcachefs/btree_update_interior=
.c:866
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff88803feb7c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 freed 512-byte region [ffff88803feb7c00, ffff88803feb7e00)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3feb6
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x4fff00000000040(head|node=3D1|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801ac41c80 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000080008 00000001f5000000 0000000000000000
head: 04fff00000000040 ffff88801ac41c80 0000000000000000 dead000000000001
head: 0000000000000000 0000000000080008 00000001f5000000 0000000000000000
head: 04fff00000000001 ffffea0000ffad81 ffffffffffffffff 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 1, tgid 1 (swapper/0), ts 20559188006, free_ts 20539441288
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_node_track_caller_noprof+0x281/0x440 mm/slub.c:4283
 __do_krealloc mm/slab_common.c:1220 [inline]
 krealloc_noprof+0x88/0x120 mm/slab_common.c:1269
 add_sysfs_param+0xca/0x7f0 kernel/params.c:654
 kernel_add_sysfs_param+0xb4/0x130 kernel/params.c:817
 param_sysfs_builtin+0x16e/0x1f0 kernel/params.c:856
 param_sysfs_builtin_init+0x31/0x40 kernel/params.c:990
 do_one_initcall+0x248/0x880 init/main.c:1269
 do_initcall_level+0x157/0x210 init/main.c:1331
page last free pid 9 tgid 9 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 vfree+0x186/0x2e0 mm/vmalloc.c:3361
 delayed_vfree_work+0x56/0x80 mm/vmalloc.c:3282
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff88803feb7b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803feb7b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88803feb7c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88803feb7c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803feb7d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


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
