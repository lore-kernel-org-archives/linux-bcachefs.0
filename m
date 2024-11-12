Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AD379C4
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 08:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731399372; cv=none; b=SGb8+BA7gDcXwQTgZfcdShplmnfb6GzxLYcQChCVjPR9EFr5MwQB9YWw3Xc9pN927EJUwQNiMPHMjxVHF9ipRqxLtXyqmBDDOiH/4ogdkyymmlHHwBR1tdVYdVJYzTfYEJfUTr33cvR+TS9bRnbWUdTSSYIo/Iq9Ovj+4bYB81o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731399372; c=relaxed/simple;
	bh=EEDKo38sZ/ofkZomEGr0CAdzklX4Rg1gqgDoYAa6Zgs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fHnEBcOYG2pjl/FAMp+vdHb++d40uoisPr0eL01wP0c2VMYzbGiZNhxrMeAidJm5DB0tMYfTj3IN6A5Tep/DTi5SkOfGbw8M+hoTpQDXwGe4Itc8esVolr6TMp0pt/IW6rT4oZitGOhhsaPHhd2Oz9w+wgJXXSYZ+SH5Zo5pmY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XnfMT2zq9zpZFf;
	Tue, 12 Nov 2024 16:14:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C19B1400D5;
	Tue, 12 Nov 2024 16:16:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 12 Nov
 2024 16:16:06 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v3] bcachefs: add counter_flags for counters
Date: Tue, 12 Nov 2024 16:15:47 +0800
Message-ID: <20241112081547.408060-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

In bcachefs, io_read and io_write counter record the amount
of data which has been read and written. They increase in
unit of sector, so to display correctly, they need to be
shifted to the left by the size of a sector. Other counters
like io_move, move_extent_{read, write, finish} also have
this problem.

In order to support different unit, we add extra column to
mark the counter type by using TYPE_COUNTER and TYPE_SECTORS
in BCH_PERSISTENT_COUNTERS().

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

v3:
  - Add counter_flags TYPE_COUNTER and TYPE_SECTORS

v2: https://lore.kernel.org/linux-bcachefs/20241107123145.1003801-1-lihongbo22@huawei.com/
  - Add extra column to represent the unit for counters.

v1: https://lore.kernel.org/r/all/eef1d336-65e2-4650-92ac-8f6329f89a57@huawei.com/T/
---
 fs/bcachefs/sb-counters_format.h | 165 ++++++++++++++++---------------
 fs/bcachefs/sysfs.c              |   9 +-
 2 files changed, 93 insertions(+), 81 deletions(-)

diff --git a/fs/bcachefs/sb-counters_format.h b/fs/bcachefs/sb-counters_format.h
index 62ea478215d0..fdcf598f08b1 100644
--- a/fs/bcachefs/sb-counters_format.h
+++ b/fs/bcachefs/sb-counters_format.h
@@ -2,86 +2,91 @@
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
+enum counters_flags {
+	TYPE_COUNTER	= BIT(0),	/* event counters */
+	TYPE_SECTORS	= BIT(1),	/* amount counters, the unit is sectors */
+};
+
+#define BCH_PERSISTENT_COUNTERS()					\
+	x(io_read,					0,	TYPE_SECTORS)	\
+	x(io_write,					1,	TYPE_SECTORS)	\
+	x(io_move,					2,	TYPE_SECTORS)	\
+	x(bucket_invalidate,				3,	TYPE_COUNTER)	\
+	x(bucket_discard,				4,	TYPE_COUNTER)	\
+	x(bucket_alloc,					5,	TYPE_COUNTER)	\
+	x(bucket_alloc_fail,				6,	TYPE_COUNTER)	\
+	x(btree_cache_scan,				7,	TYPE_COUNTER)	\
+	x(btree_cache_reap,				8,	TYPE_COUNTER)	\
+	x(btree_cache_cannibalize,			9,	TYPE_COUNTER)	\
+	x(btree_cache_cannibalize_lock,			10,	TYPE_COUNTER)	\
+	x(btree_cache_cannibalize_lock_fail,		11,	TYPE_COUNTER)	\
+	x(btree_cache_cannibalize_unlock,		12,	TYPE_COUNTER)	\
+	x(btree_node_write,				13,	TYPE_COUNTER)	\
+	x(btree_node_read,				14,	TYPE_COUNTER)	\
+	x(btree_node_compact,				15,	TYPE_COUNTER)	\
+	x(btree_node_merge,				16,	TYPE_COUNTER)	\
+	x(btree_node_split,				17,	TYPE_COUNTER)	\
+	x(btree_node_rewrite,				18,	TYPE_COUNTER)	\
+	x(btree_node_alloc,				19,	TYPE_COUNTER)	\
+	x(btree_node_free,				20,	TYPE_COUNTER)	\
+	x(btree_node_set_root,				21,	TYPE_COUNTER)	\
+	x(btree_path_relock_fail,			22,	TYPE_COUNTER)	\
+	x(btree_path_upgrade_fail,			23,	TYPE_COUNTER)	\
+	x(btree_reserve_get_fail,			24,	TYPE_COUNTER)	\
+	x(journal_entry_full,				25,	TYPE_COUNTER)	\
+	x(journal_full,					26,	TYPE_COUNTER)	\
+	x(journal_reclaim_finish,			27,	TYPE_COUNTER)	\
+	x(journal_reclaim_start,			28,	TYPE_COUNTER)	\
+	x(journal_write,				29,	TYPE_COUNTER)	\
+	x(read_promote,					30,	TYPE_COUNTER)	\
+	x(read_bounce,					31,	TYPE_COUNTER)	\
+	x(read_split,					33,	TYPE_COUNTER)	\
+	x(read_retry,					32,	TYPE_COUNTER)	\
+	x(read_reuse_race,				34,	TYPE_COUNTER)	\
+	x(move_extent_read,				35,	TYPE_SECTORS)	\
+	x(move_extent_write,				36,	TYPE_SECTORS)	\
+	x(move_extent_finish,				37,	TYPE_SECTORS)	\
+	x(move_extent_fail,				38,	TYPE_COUNTER)	\
+	x(move_extent_start_fail,			39,	TYPE_COUNTER)	\
+	x(copygc,					40,	TYPE_COUNTER)	\
+	x(copygc_wait,					41,	TYPE_COUNTER)	\
+	x(gc_gens_end,					42,	TYPE_COUNTER)	\
+	x(gc_gens_start,				43,	TYPE_COUNTER)	\
+	x(trans_blocked_journal_reclaim,		44,	TYPE_COUNTER)	\
+	x(trans_restart_btree_node_reused,		45,	TYPE_COUNTER)	\
+	x(trans_restart_btree_node_split,		46,	TYPE_COUNTER)	\
+	x(trans_restart_fault_inject,			47,	TYPE_COUNTER)	\
+	x(trans_restart_iter_upgrade,			48,	TYPE_COUNTER)	\
+	x(trans_restart_journal_preres_get,		49,	TYPE_COUNTER)	\
+	x(trans_restart_journal_reclaim,		50,	TYPE_COUNTER)	\
+	x(trans_restart_journal_res_get,		51,	TYPE_COUNTER)	\
+	x(trans_restart_key_cache_key_realloced,	52,	TYPE_COUNTER)	\
+	x(trans_restart_key_cache_raced,		53,	TYPE_COUNTER)	\
+	x(trans_restart_mark_replicas,			54,	TYPE_COUNTER)	\
+	x(trans_restart_mem_realloced,			55,	TYPE_COUNTER)	\
+	x(trans_restart_memory_allocation_failure,	56,	TYPE_COUNTER)	\
+	x(trans_restart_relock,				57,	TYPE_COUNTER)	\
+	x(trans_restart_relock_after_fill,		58,	TYPE_COUNTER)	\
+	x(trans_restart_relock_key_cache_fill,		59,	TYPE_COUNTER)	\
+	x(trans_restart_relock_next_node,		60,	TYPE_COUNTER)	\
+	x(trans_restart_relock_parent_for_fill,		61,	TYPE_COUNTER)	\
+	x(trans_restart_relock_path,			62,	TYPE_COUNTER)	\
+	x(trans_restart_relock_path_intent,		63,	TYPE_COUNTER)	\
+	x(trans_restart_too_many_iters,			64,	TYPE_COUNTER)	\
+	x(trans_restart_traverse,			65,	TYPE_COUNTER)	\
+	x(trans_restart_upgrade,			66,	TYPE_COUNTER)	\
+	x(trans_restart_would_deadlock,			67,	TYPE_COUNTER)	\
+	x(trans_restart_would_deadlock_write,		68,	TYPE_COUNTER)	\
+	x(trans_restart_injected,			69,	TYPE_COUNTER)	\
+	x(trans_restart_key_cache_upgrade,		70,	TYPE_COUNTER)	\
+	x(trans_traverse_all,				71,	TYPE_COUNTER)	\
+	x(transaction_commit,				72,	TYPE_COUNTER)	\
+	x(write_super,					73,	TYPE_COUNTER)	\
+	x(trans_restart_would_deadlock_recursion_limit,	74,	TYPE_COUNTER)	\
+	x(trans_restart_write_buffer_flush,		75,	TYPE_COUNTER)	\
+	x(trans_restart_split_race,			76,	TYPE_COUNTER)	\
+	x(write_buffer_flush_slowpath,			77,	TYPE_COUNTER)	\
+	x(write_buffer_flush_sync,			78,	TYPE_COUNTER)
 
 enum bch_persistent_counters {
 #define x(t, n, ...) BCH_COUNTER_##t,
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 97733c766948..6622f46d17a2 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -509,15 +509,22 @@ SHOW(bch2_fs_counters)
 
 	printbuf_tabstop_push(out, 32);
 
-	#define x(t, ...) \
+	#define x(t, n, f, ...) \
 		if (attr == &sysfs_##t) {					\
 			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
 			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
+			if (f & TYPE_SECTORS) {					\
+				counter <<= 9;					\
+				counter_since_mount <<= 9;			\
+			}							\
+										\
 			prt_printf(out, "since mount:\t");			\
+			(f & TYPE_COUNTER) ? prt_u64(out, counter_since_mount) :\
 			prt_human_readable_u64(out, counter_since_mount);	\
 			prt_newline(out);					\
 										\
 			prt_printf(out, "since filesystem creation:\t");	\
+			(f & TYPE_COUNTER) ? prt_u64(out, counter) :		\
 			prt_human_readable_u64(out, counter);			\
 			prt_newline(out);					\
 		}
-- 
2.34.1

