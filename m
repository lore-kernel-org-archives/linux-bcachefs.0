Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE0E20B22
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 03:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156678; cv=none; b=u9TUAQS8YoVGykvwtggA7PEzebutLGcNDaEHGIzmoo7eIrKXeX6bh0GAB8NC7WpXw98EEppBdRdoU0wpKt5pX2xVCvXEliMs0wO4hIDSB49piVz72H8bAKwfTuhspieIgLmBFSKOB8pczj5NZrzagBIkUn5OQubFuaTj7M6NO9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156678; c=relaxed/simple;
	bh=I1/qr7C49GPADXyFZxMKHUKR1npjYarD/xGIAcG16N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YN0JGuPk62+gQKMY4zsWIPjSblFy0BdVVRmfsJmmWKluueSLvI51I1d0YbBquz6mAN1KbW3Wd/yLZAgS6hZrCWep9WN+0gQ1xXdsaH5UiRKRTvhZhDylWoJZRZ/stYqpHR4b6Fx8az7J9LAlxCNQw4QuY7GyqRUnVEg/KGORUmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZfn6qiC; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZfn6qiC"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e440e64249so42938206d6.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Feb 2025 19:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739156676; x=1739761476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90RCRydLC0a1+0vMw8nI6BuiFCfgke1zI1lNzY0QJE4=;
        b=kZfn6qiCTHyYbTD21E95sBAeYSu+Yd10FdKqqsRdEhoxmbYyDzJPMFmY3AgqsD5aEx
         7mA00MDKCVAkdj+SKKReY8yGR+h3a3KExk8dLC+e58pGmUEuf1XvYr08g3JSB92TJa6w
         I4u56M2Yl2dtrDmfsr51Se74yLx6iG1OosRuF7nMLzYmu8Lz3tDdkrO+T8p5KQWAviG5
         QxJo+j7/cixW11/7x9J7+E2y58I5H+ZPm2X/8j2c1wQWL4gPtGCQ3R7P/Qfxt513m9jG
         VTq2/rVxS5teJYKi8a1djH7kqrDlXUdtgAnEYSFOzlawJVN/bsjGphnng9GRjotAvihD
         8KlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739156676; x=1739761476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=90RCRydLC0a1+0vMw8nI6BuiFCfgke1zI1lNzY0QJE4=;
        b=T/lv4l6AbLP71RkLl3H9zwcP9rSX0KIKuhJvFvdDu8X3w9ncYZu1OSojZd/Jxi8Dgi
         RnF15zSjrKSZXAkvO4rAB8nNoUUo3O5L4gbdH8HwGCZqpB9RN2N2mqu9utKcbXn9EEuO
         eTZAaTn0fy6OLuWBFg5hYsYgzBWzTjVewq1/BBIfWRDak+eMIqVQPdMyxDsZ4GxkFyXF
         KTF1t1NapZEOpA26EtJB3EX8a4uRYJaoyDSQkKxvN/mB4MolLXEjQ6ZtbUwWyKyxlmRw
         8Chlp2ZmcLm9xe+qOYBEJ+re+/mJ+Yi8cm4ZwBwgQGau+OESguGhtwtkM/hRrWs11RlZ
         YyJA==
X-Gm-Message-State: AOJu0Ywacz8Nqr+IcfA0XbAJ+KSAEz13XCGE5cAny+UK/dYssLj7y9yO
	06oakOTp+POoW19GGwdEskadXEZ5URCnopxOZ0gzumxrDxcEiGbS
X-Gm-Gg: ASbGnct7AR8yFmRAo/T0zp+IF1RgeWYnVJqdGVg5wYJK4tvsVAhxzYOlBtbZq6uzXqU
	hyNi6DYqypEs+FhejdN/Od4h7GvgrcjYtc36iaF63ybHmZrNgVPZrXtPTvyg6QEQT6XBeSBDx6E
	qdULwIEbb4ug4LXLDvJq6HG//bnk8LrNNAek47thqrBNexfcGlIGm5Y6EO2R4w7thza2oPAXE2N
	KAVLutEVUjMPg+9GkuPESF8YEEzA4dxzyIjaKmJkbbY0OlvZC8GxPx4B9rMGxYFgQ==
X-Google-Smtp-Source: AGHT+IGHBPEG481+adzQAFBNw2lzGhXs0u+x98bDjaJgHJdbCy4Wx7RDv9m37R3VSK/jdR6old3aFQ==
X-Received: by 2002:a05:6214:76f:b0:6d8:9e16:d07e with SMTP id 6a1803df08f44-6e4455bafabmr178044856d6.4.1739156675652;
        Sun, 09 Feb 2025 19:04:35 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e4544e42cfsm19522826d6.43.2025.02.09.19.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 19:04:34 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix use after free
Date: Mon, 10 Feb 2025 11:04:22 +0800
Message-ID: <20250210030422.711912-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250210030422.711912-1-mmpgouride@gmail.com>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

acc->k.data should be used with the lock hold:

00221 ========= TEST   generic/187
00221        run fstests generic/187 at 2025-02-09 21:08:10
00221 spectre-v4 mitigation disabled by command-line option
00222 bcachefs (vdc): starting version 1.20: directory_size opts=errors=ro
00222 bcachefs (vdc): initializing new filesystem
00222 bcachefs (vdc): going read-write
00222 bcachefs (vdc): marking superblocks
00222 bcachefs (vdc): initializing freespace
00222 bcachefs (vdc): done initializing freespace
00222 bcachefs (vdc): reading snapshots table
00222 bcachefs (vdc): reading snapshots done
00222 bcachefs (vdc): done starting filesystem
00222 bcachefs (vdc): shutting down
00222 bcachefs (vdc): going read-only
00222 bcachefs (vdc): finished waiting for writes to stop
00223 bcachefs (vdc): flushing journal and stopping allocators, journal seq 6
00223 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 8
00223 bcachefs (vdc): clean shutdown complete, journal seq 9
00223 bcachefs (vdc): marking filesystem clean
00223 bcachefs (vdc): shutdown complete
00223 bcachefs (vdc): starting version 1.20: directory_size opts=errors=ro
00223 bcachefs (vdc): initializing new filesystem
00223 bcachefs (vdc): going read-write
00223 bcachefs (vdc): marking superblocks
00223 bcachefs (vdc): initializing freespace
00223 bcachefs (vdc): done initializing freespace
00223 bcachefs (vdc): reading snapshots table
00223 bcachefs (vdc): reading snapshots done
00223 bcachefs (vdc): done starting filesystem
00244 hrtimer: interrupt took 123350440 ns
00264 bcachefs (vdc): shutting down
00264 bcachefs (vdc): going read-only
00264 bcachefs (vdc): finished waiting for writes to stop
00264 bcachefs (vdc): flushing journal and stopping allocators, journal seq 97
00265 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 101
00265 bcachefs (vdc): clean shutdown complete, journal seq 102
00265 bcachefs (vdc): marking filesystem clean
00265 bcachefs (vdc): shutdown complete
00265 bcachefs (vdc): starting version 1.20: directory_size opts=errors=ro
00265 bcachefs (vdc): recovering from clean shutdown, journal seq 102
00265 bcachefs (vdc): accounting_read...
00265 ==================================================================
00265  done
00265 BUG: KASAN: slab-use-after-free in bch2_fs_to_text+0x12b4/0x1728
00265 bcachefs (vdc): alloc_read... done
00265 bcachefs (vdc): stripes_read... done
00265 Read of size 4 at addr ffffff80c57eac00 by task cat/7531
00265 bcachefs (vdc): snapshots_read... done
00265
00265 CPU: 6 UID: 0 PID: 7531 Comm: cat Not tainted 6.13.0-rc3-ktest-g16fc6fa3819d #14103
00265 Hardware name: linux,dummy-virt (DT)
00265 Call trace:
00265  show_stack+0x1c/0x30 (C)
00265  dump_stack_lvl+0x6c/0x80
00265  print_report+0xf8/0x5d8
00265  kasan_report+0x90/0xd0
00265  __asan_report_load4_noabort+0x1c/0x28
00265  bch2_fs_to_text+0x12b4/0x1728
00265  bch2_fs_show+0x94/0x188
00265  sysfs_kf_seq_show+0x1a4/0x348
00265  kernfs_seq_show+0x12c/0x198
00265  seq_read_iter+0x27c/0xfd0
00265  kernfs_fop_read_iter+0x390/0x4f8
00265  vfs_read+0x480/0x7f0
00265  ksys_read+0xe0/0x1e8
00265  __arm64_sys_read+0x70/0xa8
00265  invoke_syscall.constprop.0+0x74/0x1e8
00265  do_el0_svc+0xc8/0x1c8
00265  el0_svc+0x20/0x60
00265  el0t_64_sync_handler+0x104/0x130
00265  el0t_64_sync+0x154/0x158
00265
00265 Allocated by task 7510:
00265  kasan_save_stack+0x28/0x50
00265  kasan_save_track+0x1c/0x38
00265  kasan_save_alloc_info+0x3c/0x50
00265  __kasan_kmalloc+0xac/0xb0
00265  __kmalloc_node_noprof+0x168/0x348
00265  __kvmalloc_node_noprof+0x20/0x140
00265  __bch2_darray_resize_noprof+0x90/0x1b0
00265  __bch2_accounting_mem_insert+0x76c/0xb08
00265  bch2_accounting_mem_insert+0x224/0x3b8
00265  bch2_accounting_mem_mod_locked+0x480/0xc58
00265  bch2_accounting_read+0xa94/0x3eb8
00265  bch2_run_recovery_pass+0x80/0x178
00265  bch2_run_recovery_passes+0x340/0x698
00265  bch2_fs_recovery+0x1c98/0x2bd8
00265  bch2_fs_start+0x240/0x490
00265  bch2_fs_get_tree+0xe1c/0x1458
00265  vfs_get_tree+0x7c/0x250
00265  path_mount+0xe24/0x1648
00265  __arm64_sys_mount+0x240/0x438
00265  invoke_syscall.constprop.0+0x74/0x1e8
00265  do_el0_svc+0xc8/0x1c8
00265  el0_svc+0x20/0x60
00265  el0t_64_sync_handler+0x104/0x130
00265  el0t_64_sync+0x154/0x158
00265
00265 Freed by task 7510:
00265  kasan_save_stack+0x28/0x50
00265  kasan_save_track+0x1c/0x38
00265  kasan_save_free_info+0x48/0x88
00265  __kasan_slab_free+0x48/0x60
00265  kfree+0x188/0x408
00265  kvfree+0x3c/0x50
00265  __bch2_darray_resize_noprof+0xe0/0x1b0
00265  __bch2_accounting_mem_insert+0x76c/0xb08
00265  bch2_accounting_mem_insert+0x224/0x3b8
00265  bch2_accounting_mem_mod_locked+0x480/0xc58
00265  bch2_accounting_read+0xa94/0x3eb8
00265  bch2_run_recovery_pass+0x80/0x178
00265  bch2_run_recovery_passes+0x340/0x698
00265  bch2_fs_recovery+0x1c98/0x2bd8
00265  bch2_fs_start+0x240/0x490
00265  bch2_fs_get_tree+0xe1c/0x1458
00265  vfs_get_tree+0x7c/0x250
00265  path_mount+0xe24/0x1648
00265 bcachefs (vdc): going read-write
00265  __arm64_sys_mount+0x240/0x438
00265  invoke_syscall.constprop.0+0x74/0x1e8
00265  do_el0_svc+0xc8/0x1c8
00265  el0_svc+0x20/0x60
00265  el0t_64_sync_handler+0x104/0x130
00265  el0t_64_sync+0x154/0x158
00265
00265 The buggy address belongs to the object at ffffff80c57eac00
00265  which belongs to the cache kmalloc-128 of size 128
00265 The buggy address is located 0 bytes inside of
00265  freed 128-byte region [ffffff80c57eac00, ffffff80c57eac80)
00265
00265 The buggy address belongs to the physical page:
00265 page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1057ea
00265 head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
00265 flags: 0x8000000000000040(head|zone=2)
00265 page_type: f5(slab)
00265 raw: 8000000000000040 ffffff80c0002800 dead000000000100 dead000000000122
00265 raw: 0000000000000000 0000000000200020 00000001f5000000 ffffff80c57a6400
00265 head: 8000000000000040 ffffff80c0002800 dead000000000100 dead000000000122
00265 head: 0000000000000000 0000000000200020 00000001f5000000 ffffff80c57a6400
00265 head: 8000000000000001 fffffffec315fa81 ffffffffffffffff 0000000000000000
00265 head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
00265 page dumped because: kasan: bad access detected
00265
00265 Memory state around the buggy address:
00265  ffffff80c57eab00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00265  ffffff80c57eab80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
00265 >ffffff80c57eac00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
00265                    ^
00265  ffffff80c57eac80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
00265  ffffff80c57ead00: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
00265 ==================================================================
00265 Kernel panic - not syncing: kasan.fault=panic set ...
00265 CPU: 6 UID: 0 PID: 7531 Comm: cat Not tainted 6.13.0-rc3-ktest-g16fc6fa3819d #14103
00265 Hardware name: linux,dummy-virt (DT)
00265 Call trace:
00265  show_stack+0x1c/0x30 (C)
00265  dump_stack_lvl+0x30/0x80
00265  dump_stack+0x18/0x20
00265  panic+0x4d4/0x518
00265  start_report.constprop.0+0x0/0x90
00265  kasan_report+0xa0/0xd0
00265  __asan_report_load4_noabort+0x1c/0x28
00265  bch2_fs_to_text+0x12b4/0x1728
00265  bch2_fs_show+0x94/0x188
00265  sysfs_kf_seq_show+0x1a4/0x348
00265  kernfs_seq_show+0x12c/0x198
00265  seq_read_iter+0x27c/0xfd0
00265  kernfs_fop_read_iter+0x390/0x4f8
00265  vfs_read+0x480/0x7f0
00265  ksys_read+0xe0/0x1e8
00265  __arm64_sys_read+0x70/0xa8
00265  invoke_syscall.constprop.0+0x74/0x1e8
00265  do_el0_svc+0xc8/0x1c8
00265  el0_svc+0x20/0x60
00265  el0t_64_sync_handler+0x104/0x130
00265  el0t_64_sync+0x154/0x158
00265 SMP: stopping secondary CPUs
00265 Kernel Offset: disabled
00265 CPU features: 0x000,00000070,00000010,8240500b
00265 Memory Limit: none
00265 ---[ end Kernel panic - not syncing: kasan.fault=panic set ... ]---
00270 ========= FAILED TIMEOUT generic.187 in 1200s

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/disk_accounting.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index 5360cbb3ec29..f4372cafea2e 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -210,11 +210,13 @@ static inline void bch2_accounting_mem_read_counters(struct bch_accounting_mem *
 static inline void bch2_accounting_mem_read(struct bch_fs *c, struct bpos p,
 					    u64 *v, unsigned nr)
 {
+	percpu_down_read(&c->mark_lock);
 	struct bch_accounting_mem *acc = &c->accounting;
 	unsigned idx = eytzinger0_find(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
 				       accounting_pos_cmp, &p);
 
 	bch2_accounting_mem_read_counters(acc, idx, v, nr, false);
+	percpu_up_read(&c->mark_lock);
 }
 
 static inline struct bversion journal_pos_to_bversion(struct journal_res *res, unsigned offset)
-- 
2.47.0

