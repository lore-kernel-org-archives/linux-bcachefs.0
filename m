Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE0825D200;
	Thu,  6 Mar 2025 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280986; cv=none; b=UgukJe3GmMqQ+ha7xaaeE7QMebahC2lQL25FBUYoqek7ZVJHFxz7BH8INv7Jtz9j5LCyKU6gss7VU8pTdzPJvHuOA3L8IKe80+c9avjBUEFO2y6W/lrbDn1lunL6vGBx9zAVzDlH9+zE6lquDCTs0ZLH5tmYE0KbkArOhocThd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280986; c=relaxed/simple;
	bh=BLglZ9cTBtrp3sne5u6Ch1nT0XNftk9RhNBXV5vSm94=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BA1MjbkbSXdwimqsev4LTtKceZVNMwEvfqBpXY5M3NFD8SRzJFAE/mWr5X7mT22Qvvrgj3sj0xaTmZJrCjLHy1cYzD66oS3LbKSQoF6/9ZXwWSNOHD8OmNWAvhukbG2cm4pq6/TJzwTs59lwM4InA1Vk4TlGOvDMiSNS1f9mYBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=daXflpUL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="daXflpUL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223785beedfso16989235ad.1;
        Thu, 06 Mar 2025 09:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741280982; x=1741885782; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ty0VFu9c5iknpHGEPfJuJ6QWp4nCgIXmkbmBu5l0gio=;
        b=daXflpULYVD1AAYUCmwx/c5nGyU6bBOdL069FCXRKrdbQRxLgDixfeRWfBzn84ZGK+
         ufBBNef5CgaGYrdoieYoq1DhXkiQzpXK76RZlk9S1qYqR0mFv5k0K2CoSXk8j4hAc2rV
         4T5UXxyW/sdeULnRhV/66u9A26eFl+K2VSMs6/+hnh+mXpKdGg33n5xMr1CffqvicDx+
         gfS9YxoEnzPaa5C5CbLOVHnCKGntmP/JTemc+5JB1IdMWhqlbfClDrzFi8Enbx5n7eDA
         Z9n2Dq0wEVGwrEw6z2Yw5gGNX4vxIALi9635xijQsp8DMETlfq09SUDJQD5mv4PKoUyD
         IDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741280982; x=1741885782;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ty0VFu9c5iknpHGEPfJuJ6QWp4nCgIXmkbmBu5l0gio=;
        b=Y+TzZ23iGCji7M2p1oYA8+Mq50ge93nlDUu2X3QM3/0MdQX/xPkH3bGEbzhN0bi5OX
         JFlNEoFDDuBYm3qYxOYBDEBUfO8hvdBVZ7lQ9iRIaY6J3Ri2I8chjo0a6vDAR7MCUc0a
         6rN4XPFqOM2ZnFHUA9uvCCvl/QBw3rVEYS/gJV9uFmcWLnH2ShQTtxvomIRID3cS9lWd
         F2qbo2NS1kLyI+XvBKjkHWCFIvAw1J7STGz1QfT+VHx51tn68NOo5brM7bbZ4jByNLdo
         2D5ljlM7GSo22jeDTp9QYrvq9iSnb2hK4ymVR50I6XsTr73Nd8YGGrmF0RuqQPOcYU+0
         3noQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB/tV8rLjEjkq7C+vreu8L3oselHRpnTkIE/ySqCI6RB//8vvcJQyvCAQ6BtfYjrJ2GMPg2wBuk8+LzcwP@vger.kernel.org, AJvYcCXxVHXfidLjXe4OCOO+iuj3lMeDraTIwuyeyG7MYdPXG4eqP7/G+fM8QI/f4jw3L5d+62KoPnOzPNdYccjheQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg/sCJEKU+VYSZXZHouuH7B5LN55JUXH5GheUBNxtlvH7qYiZS
	ESd2vgpZaciIP3Dxqxdcvq7aFBqWj7XwTa4FGBhIpK6bszBp3pKj
X-Gm-Gg: ASbGncvXawtoKSfvVa0wJz5cTySqocNewjpuw9xsEBSHXLLIXdNfi1+F5m1mkDXehlt
	DXDRn+ZypKbOd7MwvgKNm1MZ5ypCbcw47DoDJTYWuPTu5b0SRDHzawWXQqO7HwuJFvZlaOc9XTY
	gtnqoglJi9SUbGFzzDgt9YZAberro4GSRhe7y32+LtLB+KCRKQ6pBj4Kb6t/o78LfEnctZoKc+d
	q0dpbv25BXshJTjLjHR1uA7ph2dC205eOSmFzjD/fRzVIrMGUOI+ykO10Vxu4ljOFb8jagHiXYj
	2R2gMo1FhGpmzwR6emA8hpzQpoMb
X-Google-Smtp-Source: AGHT+IEBhVhRpLx2q6NDyLHZEbFaUwifEOdeJGWBeEOSDKushCFIgFh6BEnrlxhT4sVz2XSXrcd/5A==
X-Received: by 2002:a17:902:e5d2:b0:223:3b76:4e22 with SMTP id d9443c01a7336-22428886738mr637165ad.6.1741280981194;
        Thu, 06 Mar 2025 09:09:41 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109df225sm14965195ad.47.2025.03.06.09.09.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Mar 2025 09:09:40 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in
 validate_bset_keys
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67c5c1f8.050a0220.55417.06f6.GAE@google.com>
Date: Fri, 7 Mar 2025 01:09:24 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1EE34FAC-7796-4D28-AA51-1A85E3489DDD@gmail.com>
References: <67c5c1f8.050a0220.55417.06f6.GAE@google.com>
To: syzbot <syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Mar 3, 2025, at 22:51, syzbot =
<syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    e056da87c780 Merge remote-tracking branch =
'will/for-next/p..
> git tree:       =
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git =
for-kernelci
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D16fa9864580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dd6b7e15dc5b5e776
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D3cb3d9e8c3f197754825
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> userspace arch: arm64
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D1614e8b7980000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D11fa9864580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/3d8b1b7cc4c0/disk-e056da87.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/b84c04cff235/vmlinux-e056da87=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/2ae4d0525881/Image-e056da87.g=
z.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/54f57836a7d4/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
>=20
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2097 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in __memcpy_u64s fs/bcachefs/util.h:434 =
[inline]
> BUG: KASAN: slab-out-of-bounds in __memmove_u64s_down =
fs/bcachefs/util.h:450 [inline]
> BUG: KASAN: slab-out-of-bounds in memmove_u64s_down =
fs/bcachefs/util.h:458 [inline]
> BUG: KASAN: slab-out-of-bounds in validate_bset_keys+0xa08/0x16e8 =
fs/bcachefs/btree_io.c:999
> Read of size 8 at addr ffff0000de6100a8 by task kworker/1:1H/57
>=20
> CPU: 1 UID: 0 PID: 57 Comm: kworker/1:1H Not tainted =
6.14.0-rc4-syzkaller-ge056da87c780 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 12/27/2024
> Workqueue: bcachefs_btree_read_complete btree_node_read_work
> Call trace:
> show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
> print_address_description mm/kasan/report.c:408 [inline]
> print_report+0x198/0x550 mm/kasan/report.c:521
> kasan_report+0xd8/0x138 mm/kasan/report.c:634
> __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
> __memcpy_u64s fs/bcachefs/util.h:434 [inline]
> __memmove_u64s_down fs/bcachefs/util.h:450 [inline]
> memmove_u64s_down fs/bcachefs/util.h:458 [inline]
> validate_bset_keys+0xa08/0x16e8 fs/bcachefs/btree_io.c:999
> bch2_btree_node_read_done+0x19f4/0x4acc fs/bcachefs/btree_io.c:1164
> btree_node_read_work+0x534/0xf20 fs/bcachefs/btree_io.c:1358
> process_one_work+0x810/0x1638 kernel/workqueue.c:3236
> process_scheduled_works kernel/workqueue.c:3317 [inline]
> worker_thread+0x97c/0xeec kernel/workqueue.c:3398
> kthread+0x65c/0x7b0 kernel/kthread.c:464
> ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
>=20
> Allocated by task 6439:
> kasan_save_stack mm/kasan/common.c:47 [inline]
> kasan_save_track+0x40/0x78 mm/kasan/common.c:68
> kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:562
> unpoison_slab_object mm/kasan/common.c:319 [inline]
> __kasan_slab_alloc+0x74/0x8c mm/kasan/common.c:345
> kasan_slab_alloc include/linux/kasan.h:250 [inline]
> slab_post_alloc_hook mm/slub.c:4115 [inline]
> slab_alloc_node mm/slub.c:4164 [inline]
> kmem_cache_alloc_noprof+0x254/0x410 mm/slub.c:4171
> alloc_buffer_head+0x38/0x320 fs/buffer.c:3015
> folio_alloc_buffers+0x40c/0x974 fs/buffer.c:924
> create_empty_buffers+0x4c/0x54c fs/buffer.c:1662
> ext4_block_write_begin+0x21c/0xf24 fs/ext4/inode.c:1046
> ext4_da_write_begin+0x4e8/0x98c fs/ext4/inode.c:2946
> generic_perform_write+0x29c/0x868 mm/filemap.c:4189
> ext4_buffered_write_iter+0x2c0/0x52c fs/ext4/file.c:299
> ext4_file_write_iter+0x1ac/0x197c fs/ext4/file.c:717
> new_sync_write fs/read_write.c:586 [inline]
> vfs_write+0x704/0xa9c fs/read_write.c:679
> ksys_write+0x15c/0x26c fs/read_write.c:731
> __do_sys_write fs/read_write.c:742 [inline]
> __se_sys_write fs/read_write.c:739 [inline]
> __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
> __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
> el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
> do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
> el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
> el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
> el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> The buggy address belongs to the object at ffff0000de610000
> which belongs to the cache buffer_head of size 168
> The buggy address is located 0 bytes to the right of
> allocated 168-byte region [ffff0000de610000, ffff0000de6100a8)
>=20
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 =
pfn:0x11e610
> flags: 0x5ffc00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 05ffc00000000000 ffff0000c18aadc0 dead000000000122 =
0000000000000000
> raw: 0000000000000000 0000000000110011 00000000f5000000 =
0000000000000000
> page dumped because: kasan: bad access detected
>=20
> Memory state around the buggy address:
> ffff0000de60ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff0000de610000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff0000de610080: 00 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00
>                                  ^
> ffff0000de610100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff0000de610180: 00 00 fc fc fc fc fc fc fc fc 00 00 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2095 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2093 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2091 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2089 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2087 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2085 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2083 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2081 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2079 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2077 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2075 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2073 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2071 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2069 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2067 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2065 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2063 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2061 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2059 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2057 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2055 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2053 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2051 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2049 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2047 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2045 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2043 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2041 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2039 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2037 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2035 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2033 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2031 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2029 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2027 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2025 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2023 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2021 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2019 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2017 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2015 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2013 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2011 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2009 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2007 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2005 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2003 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2001 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1999 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1997 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1995 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1993 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1991 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1989 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1987 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1985 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1983 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1981 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1979 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1977 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1975 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1973 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1971 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1969 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1967 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1965 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1963 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1961 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1959 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1957 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1955 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1953 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1951 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1949 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1947 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1945 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1943 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1941 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1939 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1937 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1935 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1933 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1931 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1929 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1927 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1925 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1923 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1921 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1919 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1917 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1915 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1913 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1911 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1909 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1907 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1905 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1903 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1901 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1899 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1897 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1895 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1893 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1891 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1889 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1887 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1885 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1883 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1881 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1879 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1877 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1875 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1873 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1871 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1869 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1867 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1865 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1863 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1861 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1859 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1857 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1855 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1853 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1851 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1849 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1847 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1845 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1843 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1841 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1839 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1837 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1835 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1833 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1831 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1829 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1827 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1825 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1823 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1821 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1819 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1817 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1815 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1813 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1811 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1809 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1807 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1805 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1803 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1801 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1799 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1797 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1795 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1793 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1791 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1789 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1787 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1785 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1783 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1781 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1779 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1777 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1775 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1773 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1771 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1769 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1767 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1765 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1763 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1761 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1759 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1757 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1755 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1753 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1751 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1749 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1747 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1745 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1743 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1741 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1739 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1737 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1735 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1733 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1731 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1729 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1727 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1725 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1723 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1721 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1719 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1717 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1715 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1713 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1711 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1709 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents level =
0/0
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 1707 bset byte offset 40: bad k->u64s 0 =
(min 3 max 253), fixing
> bcachefs (loop0): error validating btree node at btree extents leve
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

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 80a0094be356..7a16239c71ee 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1187,7 +1187,10 @@ int bch2_btree_node_read_done(struct bch_fs *c, =
struct bch_dev *ca,
                             le64_to_cpu(i->journal_seq),
                             b->written, b->written + sectors, =
ptr_written);
=20
-               b->written +=3D sectors;
+               if (likely(i->u64s))
+                       b->written +=3D sectors;
+               else
+                       break;
=20
                if (blacklisted && !first)
                        continue;


