Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF31DB534
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982735; cv=none; b=MahHyCQuEemOtB2ML2eI5zjeaXXitsnWg/K5iTtrURjZJl66gCXMcPYVGnoVRMdZ1CWNQOvE8sjjRspCmmOtcOD+ZJY1BM5SBV3le7Wx4VS+AnSgjFHfxhM+pAqlY02SEpN0DUmzE5EjaBfeUdyn7Z6mxNtq+xsq7M8Tzm/BtEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982735; c=relaxed/simple;
	bh=YpvSL6Sw0rMb7nwwsYitfGsqMjTWwX35UYHKNEvacjA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QWOf1lnBoxUelmqe4jmInt1QPtp9V22K3C1qimYeU7VTB47EZ/Yes+PCIisooIinAXTrcy7PIOHRcbdvW1aF556CgwadqcXxwqJsxIqaMekTkYXpZ1XL25JJFjDEWLljzRKe+Ex4LJK3FXnn1wvnZlLkm5/9g+KnPI4GUK+4n6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XkhHP0c98z1SGCS;
	Thu,  7 Nov 2024 20:30:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1FAC21A0188;
	Thu,  7 Nov 2024 20:32:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 7 Nov
 2024 20:32:07 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2] bcachefs: add unit for counters to support different case
Date: Thu, 7 Nov 2024 20:31:45 +0800
Message-ID: <20241107123145.1003801-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

In bcachefs, io_read and io_write counter record the amount
of data which has been read and written. They increase in
unit of sector, so to display correctly, they need to be
shifted to the left by the size of a sector. Other counters
like io_move, move_extent_{read, write, finish} also have
this problem.

In order to support different unit, we add extra column to
record the unit of this counter in BCH_PERSISTENT_COUNTERS().

Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
When I read one 15.7M file, the io_read sysfs interface shows:
- Before this patch
  - original:
    since mount:                   0 B
    since filesystem creation:     5.11 KiB

  - after read:
    since mount:                   31.4 KiB
    since filesystem creation:     36.5 KiB

- After this patch:
  - original:
    since mount:                   0 B
    since filesystem creation:     18.3 MiB

  - after read:
    since mount:                   15.7 MiB
    since filesystem creation:     34.0 MiB

v2:
  - Add extra column to represent the unit for counters.

v1: https://lore.kernel.org/r/all/eef1d336-65e2-4650-92ac-8f6329f89a57@huawei.com/T/
---
 fs/bcachefs/sb-counters_format.h | 160 +++++++++++++++----------------
 fs/bcachefs/sysfs.c              |   4 +-
 2 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/fs/bcachefs/sb-counters_format.h b/fs/bcachefs/sb-counters_format.h
index 62ea478215d0..da1f462b9f9c 100644
--- a/fs/bcachefs/sb-counters_format.h
+++ b/fs/bcachefs/sb-counters_format.h
@@ -2,86 +2,86 @@
 #ifndef _BCACHEFS_SB_COUNTERS_FORMAT_H
 #define _BCACHEFS_SB_COUNTERS_FORMAT_H
 
-#define BCH_PERSISTENT_COUNTERS()				\
-	x(io_read,					0)	\
-	x(io_write,					1)	\
-	x(io_move,					2)	\
-	x(bucket_invalidate,				3)	\
-	x(bucket_discard,				4)	\
-	x(bucket_alloc,					5)	\
-	x(bucket_alloc_fail,				6)	\
-	x(btree_cache_scan,				7)	\
-	x(btree_cache_reap,				8)	\
-	x(btree_cache_cannibalize,			9)	\
-	x(btree_cache_cannibalize_lock,			10)	\
-	x(btree_cache_cannibalize_lock_fail,		11)	\
-	x(btree_cache_cannibalize_unlock,		12)	\
-	x(btree_node_write,				13)	\
-	x(btree_node_read,				14)	\
-	x(btree_node_compact,				15)	\
-	x(btree_node_merge,				16)	\
-	x(btree_node_split,				17)	\
-	x(btree_node_rewrite,				18)	\
-	x(btree_node_alloc,				19)	\
-	x(btree_node_free,				20)	\
-	x(btree_node_set_root,				21)	\
-	x(btree_path_relock_fail,			22)	\
-	x(btree_path_upgrade_fail,			23)	\
-	x(btree_reserve_get_fail,			24)	\
-	x(journal_entry_full,				25)	\
-	x(journal_full,					26)	\
-	x(journal_reclaim_finish,			27)	\
-	x(journal_reclaim_start,			28)	\
-	x(journal_write,				29)	\
-	x(read_promote,					30)	\
-	x(read_bounce,					31)	\
-	x(read_split,					33)	\
-	x(read_retry,					32)	\
-	x(read_reuse_race,				34)	\
-	x(move_extent_read,				35)	\
-	x(move_extent_write,				36)	\
-	x(move_extent_finish,				37)	\
-	x(move_extent_fail,				38)	\
-	x(move_extent_start_fail,			39)	\
-	x(copygc,					40)	\
-	x(copygc_wait,					41)	\
-	x(gc_gens_end,					42)	\
-	x(gc_gens_start,				43)	\
-	x(trans_blocked_journal_reclaim,		44)	\
-	x(trans_restart_btree_node_reused,		45)	\
-	x(trans_restart_btree_node_split,		46)	\
-	x(trans_restart_fault_inject,			47)	\
-	x(trans_restart_iter_upgrade,			48)	\
-	x(trans_restart_journal_preres_get,		49)	\
-	x(trans_restart_journal_reclaim,		50)	\
-	x(trans_restart_journal_res_get,		51)	\
-	x(trans_restart_key_cache_key_realloced,	52)	\
-	x(trans_restart_key_cache_raced,		53)	\
-	x(trans_restart_mark_replicas,			54)	\
-	x(trans_restart_mem_realloced,			55)	\
-	x(trans_restart_memory_allocation_failure,	56)	\
-	x(trans_restart_relock,				57)	\
-	x(trans_restart_relock_after_fill,		58)	\
-	x(trans_restart_relock_key_cache_fill,		59)	\
-	x(trans_restart_relock_next_node,		60)	\
-	x(trans_restart_relock_parent_for_fill,		61)	\
-	x(trans_restart_relock_path,			62)	\
-	x(trans_restart_relock_path_intent,		63)	\
-	x(trans_restart_too_many_iters,			64)	\
-	x(trans_restart_traverse,			65)	\
-	x(trans_restart_upgrade,			66)	\
-	x(trans_restart_would_deadlock,			67)	\
-	x(trans_restart_would_deadlock_write,		68)	\
-	x(trans_restart_injected,			69)	\
-	x(trans_restart_key_cache_upgrade,		70)	\
-	x(trans_traverse_all,				71)	\
-	x(transaction_commit,				72)	\
-	x(write_super,					73)	\
-	x(trans_restart_would_deadlock_recursion_limit,	74)	\
-	x(trans_restart_write_buffer_flush,		75)	\
-	x(trans_restart_split_race,			76)	\
-	x(write_buffer_flush_slowpath,			77)	\
-	x(write_buffer_flush_sync,			78)
+#define BCH_PERSISTENT_COUNTERS()					\
+	x(io_read,					0,	512)	\
+	x(io_write,					1,	512)	\
+	x(io_move,					2,	512)	\
+	x(bucket_invalidate,				3,	1)	\
+	x(bucket_discard,				4,	1)	\
+	x(bucket_alloc,					5,	1)	\
+	x(bucket_alloc_fail,				6,	1)	\
+	x(btree_cache_scan,				7,	1)	\
+	x(btree_cache_reap,				8,	1)	\
+	x(btree_cache_cannibalize,			9,	1)	\
+	x(btree_cache_cannibalize_lock,			10,	1)	\
+	x(btree_cache_cannibalize_lock_fail,		11,	1)	\
+	x(btree_cache_cannibalize_unlock,		12,	1)	\
+	x(btree_node_write,				13,	1)	\
+	x(btree_node_read,				14,	1)	\
+	x(btree_node_compact,				15,	1)	\
+	x(btree_node_merge,				16,	1)	\
+	x(btree_node_split,				17,	1)	\
+	x(btree_node_rewrite,				18,	1)	\
+	x(btree_node_alloc,				19,	1)	\
+	x(btree_node_free,				20,	1)	\
+	x(btree_node_set_root,				21,	1)	\
+	x(btree_path_relock_fail,			22,	1)	\
+	x(btree_path_upgrade_fail,			23,	1)	\
+	x(btree_reserve_get_fail,			24,	1)	\
+	x(journal_entry_full,				25,	1)	\
+	x(journal_full,					26,	1)	\
+	x(journal_reclaim_finish,			27,	1)	\
+	x(journal_reclaim_start,			28,	1)	\
+	x(journal_write,				29,	1)	\
+	x(read_promote,					30,	1)	\
+	x(read_bounce,					31,	1)	\
+	x(read_split,					33,	1)	\
+	x(read_retry,					32,	1)	\
+	x(read_reuse_race,				34,	1)	\
+	x(move_extent_read,				35,	512)	\
+	x(move_extent_write,				36,	512)	\
+	x(move_extent_finish,				37,	512)	\
+	x(move_extent_fail,				38,	1)	\
+	x(move_extent_start_fail,			39,	1)	\
+	x(copygc,					40,	1)	\
+	x(copygc_wait,					41,	1)	\
+	x(gc_gens_end,					42,	1)	\
+	x(gc_gens_start,				43,	1)	\
+	x(trans_blocked_journal_reclaim,		44,	1)	\
+	x(trans_restart_btree_node_reused,		45,	1)	\
+	x(trans_restart_btree_node_split,		46,	1)	\
+	x(trans_restart_fault_inject,			47,	1)	\
+	x(trans_restart_iter_upgrade,			48,	1)	\
+	x(trans_restart_journal_preres_get,		49,	1)	\
+	x(trans_restart_journal_reclaim,		50,	1)	\
+	x(trans_restart_journal_res_get,		51,	1)	\
+	x(trans_restart_key_cache_key_realloced,	52,	1)	\
+	x(trans_restart_key_cache_raced,		53,	1)	\
+	x(trans_restart_mark_replicas,			54,	1)	\
+	x(trans_restart_mem_realloced,			55,	1)	\
+	x(trans_restart_memory_allocation_failure,	56,	1)	\
+	x(trans_restart_relock,				57,	1)	\
+	x(trans_restart_relock_after_fill,		58,	1)	\
+	x(trans_restart_relock_key_cache_fill,		59,	1)	\
+	x(trans_restart_relock_next_node,		60,	1)	\
+	x(trans_restart_relock_parent_for_fill,		61,	1)	\
+	x(trans_restart_relock_path,			62,	1)	\
+	x(trans_restart_relock_path_intent,		63,	1)	\
+	x(trans_restart_too_many_iters,			64,	1)	\
+	x(trans_restart_traverse,			65,	1)	\
+	x(trans_restart_upgrade,			66,	1)	\
+	x(trans_restart_would_deadlock,			67,	1)	\
+	x(trans_restart_would_deadlock_write,		68,	1)	\
+	x(trans_restart_injected,			69,	1)	\
+	x(trans_restart_key_cache_upgrade,		70,	1)	\
+	x(trans_traverse_all,				71,	1)	\
+	x(transaction_commit,				72,	1)	\
+	x(write_super,					73,	1)	\
+	x(trans_restart_would_deadlock_recursion_limit,	74,	1)	\
+	x(trans_restart_write_buffer_flush,		75,	1)	\
+	x(trans_restart_split_race,			76,	1)	\
+	x(write_buffer_flush_slowpath,			77,	1)	\
+	x(write_buffer_flush_sync,			78,	1)
 
 enum bch_persistent_counters {
 #define x(t, n, ...) BCH_COUNTER_##t,
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 97733c766948..8c52a7aed45d 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -509,10 +509,12 @@ SHOW(bch2_fs_counters)
 
 	printbuf_tabstop_push(out, 32);
 
-	#define x(t, ...) \
+	#define x(t, n, u, ...) \
 		if (attr == &sysfs_##t) {					\
 			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
 			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
+			counter *= u;						\
+			counter_since_mount *= u;				\
 			prt_printf(out, "since mount:\t");			\
 			prt_human_readable_u64(out, counter_since_mount);	\
 			prt_newline(out);					\
-- 
2.34.1

