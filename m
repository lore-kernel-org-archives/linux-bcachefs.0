Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C652139D8
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Mar 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741013501; cv=none; b=Ws5+kz8FRw2jmnIAcWxoGB9iED0PY9aIzOaLk2m0PpnQAnbq2Xst3XEW25uBQ417VfB6xsZA6sDvnjSMkGKhK2M2ezJkJvK8WoRQSVO9EmBtfYITxlgcuVEVxcM8LbMJVZPIR7Rv8iShZFhMSjJo/5+CJxJN9a32HBYhevZOxI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741013501; c=relaxed/simple;
	bh=kncXkqs/RyK5p/cwOFJ2VPlVOE/IidZ99Hy3aiwcTx8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Jyq0C8EUb66gEHrErqZXbcKzSIhtqB3wJF7OmS07U/iExK3ZwJopu3jmjk8JPr1JtJdqUNEY+gXl0dJq5uZpIRO1zKQyZfGL7HwGchL2CUF0g8fpnGJFUdqjKDuLvv1dcB3nY8Dkzxwr7y+bJvmg7Km3/hh2IwAPxKZQc5CreK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d289bf6c39so50512315ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Mar 2025 06:51:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741013496; x=1741618296;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1g7+EiyTZUNCEP/ZYvZ8l1P3mdWRP6tTPqFc1jNiYks=;
        b=JAcK6JgRya7KHuVUAQM/8aYoUWXnzsuNDOknIxYUU8FN400/3NEH3kWaHj4wyrOKV0
         h237E8op9QV+HYl/O7z6oavU06xVUAdcJOzS6/VpBi11jEHiZIRzhxXhgtFyWQhVeNW7
         bTQqL0I0Lps946+fkMQb3hpdZTAvF3IQB2T0F3A4H9mjRakzOVLOBfh+WN0925YlTJCg
         b/xhDATYfAJi3OybvqLrKed0AmqJxC1aELTo+YsMUCArQjdthSrozW4cnyNiLBoH9yG4
         w9vY7ieo0gE9ULMaEhi9AC9nPOEh8XpFR3xV8IW02kJ3145v2g3qld16G2tdA0qFaiep
         HWZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHXJPZ35UcKFVt2icM032f0q09Khl86dUB/QdjvaMD7ayKzWD7L0C0uXhNXSzwpQrOpI40UH7pKA+6ONq3BA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykbmNRnhoVgyKThsopB47Mt7x98NsiZnet9gJQ1iHyZn3Iz3FA
	sV7MWkbMFUqSLXJFilcyt4kX9o3w9XFwX6scp3fPhqPmqmms2y0zDveG7ZE7ZCCry0pcRaxAAcD
	vus2o5PcqDuUI35QENVn1tJKECAX4+YPe5nSd9UDwg1wUDBYIae1wM70=
X-Google-Smtp-Source: AGHT+IHT7hUswIIDKHpwweDEsrbA7EKke1BwaVk+D8G2iKqxVa58xEiyJ27xpz756ei8fNOeuGlv8eSxiYASKW47smHlr6/O6jxa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d58a:0:b0:3d3:f15e:8e23 with SMTP id
 e9e14a558f8ab-3d3f15e9d67mr84829265ab.10.1741013496377; Mon, 03 Mar 2025
 06:51:36 -0800 (PST)
Date: Mon, 03 Mar 2025 06:51:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c5c1f8.050a0220.55417.06f6.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in validate_bset_keys
From: syzbot <syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e056da87c780 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16fa9864580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b7e15dc5b5e776
dashboard link: https://syzkaller.appspot.com/bug?extid=3cb3d9e8c3f197754825
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1614e8b7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fa9864580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3d8b1b7cc4c0/disk-e056da87.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b84c04cff235/vmlinux-e056da87.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2ae4d0525881/Image-e056da87.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/54f57836a7d4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2097 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
==================================================================
BUG: KASAN: slab-out-of-bounds in __memcpy_u64s fs/bcachefs/util.h:434 [inline]
BUG: KASAN: slab-out-of-bounds in __memmove_u64s_down fs/bcachefs/util.h:450 [inline]
BUG: KASAN: slab-out-of-bounds in memmove_u64s_down fs/bcachefs/util.h:458 [inline]
BUG: KASAN: slab-out-of-bounds in validate_bset_keys+0xa08/0x16e8 fs/bcachefs/btree_io.c:999
Read of size 8 at addr ffff0000de6100a8 by task kworker/1:1H/57

CPU: 1 UID: 0 PID: 57 Comm: kworker/1:1H Not tainted 6.14.0-rc4-syzkaller-ge056da87c780 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: bcachefs_btree_read_complete btree_node_read_work
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x198/0x550 mm/kasan/report.c:521
 kasan_report+0xd8/0x138 mm/kasan/report.c:634
 __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
 __memcpy_u64s fs/bcachefs/util.h:434 [inline]
 __memmove_u64s_down fs/bcachefs/util.h:450 [inline]
 memmove_u64s_down fs/bcachefs/util.h:458 [inline]
 validate_bset_keys+0xa08/0x16e8 fs/bcachefs/btree_io.c:999
 bch2_btree_node_read_done+0x19f4/0x4acc fs/bcachefs/btree_io.c:1164
 btree_node_read_work+0x534/0xf20 fs/bcachefs/btree_io.c:1358
 process_one_work+0x810/0x1638 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3317 [inline]
 worker_thread+0x97c/0xeec kernel/workqueue.c:3398
 kthread+0x65c/0x7b0 kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

Allocated by task 6439:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:562
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x74/0x8c mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4115 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 kmem_cache_alloc_noprof+0x254/0x410 mm/slub.c:4171
 alloc_buffer_head+0x38/0x320 fs/buffer.c:3015
 folio_alloc_buffers+0x40c/0x974 fs/buffer.c:924
 create_empty_buffers+0x4c/0x54c fs/buffer.c:1662
 ext4_block_write_begin+0x21c/0xf24 fs/ext4/inode.c:1046
 ext4_da_write_begin+0x4e8/0x98c fs/ext4/inode.c:2946
 generic_perform_write+0x29c/0x868 mm/filemap.c:4189
 ext4_buffered_write_iter+0x2c0/0x52c fs/ext4/file.c:299
 ext4_file_write_iter+0x1ac/0x197c fs/ext4/file.c:717
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x704/0xa9c fs/read_write.c:679
 ksys_write+0x15c/0x26c fs/read_write.c:731
 __do_sys_write fs/read_write.c:742 [inline]
 __se_sys_write fs/read_write.c:739 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

The buggy address belongs to the object at ffff0000de610000
 which belongs to the cache buffer_head of size 168
The buggy address is located 0 bytes to the right of
 allocated 168-byte region [ffff0000de610000, ffff0000de6100a8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e610
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000000 ffff0000c18aadc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000110011 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000de60ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff0000de610000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff0000de610080: 00 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00
                                  ^
 ffff0000de610100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff0000de610180: 00 00 fc fc fc fc fc fc fc fc 00 00 00 00 00 00
==================================================================
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2095 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2093 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2091 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2089 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2087 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2085 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2083 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2081 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2079 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2077 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2075 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2073 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2071 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2069 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2067 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2065 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2063 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2061 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2059 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2057 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2055 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2053 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2051 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2049 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2047 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2045 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2043 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2041 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2039 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2037 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2035 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2033 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2031 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2029 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2027 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2025 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2023 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2021 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2019 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2017 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2015 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2013 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2011 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2009 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2007 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2005 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2003 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2001 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1999 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1997 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1995 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1993 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1991 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1989 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1987 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1985 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1983 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1981 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1979 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1977 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1975 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1973 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1971 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1969 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1967 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1965 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1963 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1961 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1959 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1957 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1955 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1953 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1951 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1949 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1947 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1945 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1943 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1941 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1939 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1937 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1935 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1933 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1931 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1929 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1927 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1925 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1923 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1921 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1919 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1917 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1915 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1913 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1911 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1909 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1907 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1905 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1903 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1901 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1899 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1897 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1895 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1893 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1891 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1889 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1887 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1885 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1883 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1881 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1879 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1877 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1875 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1873 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1871 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1869 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1867 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1865 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1863 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1861 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1859 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1857 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1855 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1853 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1851 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1849 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1847 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1845 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1843 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1841 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1839 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1837 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1835 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1833 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1831 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1829 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1827 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1825 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1823 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1821 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1819 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1817 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1815 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1813 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1811 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1809 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1807 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1805 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1803 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1801 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1799 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1797 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1795 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1793 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1791 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1789 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1787 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1785 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1783 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1781 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1779 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1777 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1775 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1773 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1771 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1769 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1767 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1765 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1763 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1761 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1759 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1757 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1755 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1753 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1751 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1749 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1747 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1745 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1743 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1741 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1739 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1737 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1735 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1733 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1731 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1729 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1727 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1725 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1723 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1721 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1719 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1717 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1715 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1713 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1711 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1709 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 1707 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
bcachefs (loop0): error validating btree node at btree extents leve

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
