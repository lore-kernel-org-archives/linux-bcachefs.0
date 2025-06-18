Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E979821CFEF
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283689; cv=none; b=cYhlDsfXpth0UbSo2o08/dS6n0CtnpRnrC9isasxtrWC9HLcjyXDg2ygbazJurwGxCkbYcwqXumefrlMKdJxRz4EWkKWlBAhHRUlVuqL2LhkOQRDH8XnDDXc4KLvc/qTXuA1Q2v/lYylxn0BWslajUId3rV5HLlAmaFoGeywqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283689; c=relaxed/simple;
	bh=41pJOwfGLcYPMb8llxPHB1eIZQK1trrTgk8jXHJfI20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDGWj/bvdMraB2v0DAI+K6zrF74SDeUPcu6MOyEAV1CbcofTKifQ91Ybf/P+9PaM6cWyIGC253H1tBTW7kQzBrWLLxeA2FMdJ2bqaiZU2aaUOhCvkYk4m58484I7PukIN5ePbp0bmasnlic9A6EfCS9KPipDy5ukwPLlUe51UYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JaAK87Nl; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JaAK87Nl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWhajHZ52VSIgsFLq/aTMtNF0FHAt4L2tz9IlRkikBI=;
	b=JaAK87NlCagRnYdGL7U5lK/a3b9yg//eyuG0vL7dAFGewZUgMTm97IgBgf+nNVVaLLO4b6
	W1mZv1qH3bUJGcEq1L9DBcOLN2c/dqaHgEehv+ohZb+KF0qCMQqW1d3ffVEIPph0+tx19o
	Ns9ZFqDfA0nUyTfCfr5yfc9dS6Yj+e0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/37] bcachefs: Delay calculation of trans->journal_u64s
Date: Wed, 18 Jun 2025 17:53:57 -0400
Message-ID: <20250618215431.738317-7-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Alan Huang <mmpgouride@gmail.com>

When there is commit error that need split btree leaf, fsck might change
the value of trans->journal_entries.u64s, when retry commit, the value of
trans->journal_u64s would be incorrect, which will lead to trans->journal_res.u64s
underflow, and then out of bounds write will occur:

[  464.496970][T11969] Call trace:
[  464.496973][T11969]  show_stack+0x3c/0x88 (C)
[  464.496995][T11969]  dump_stack_lvl+0xf8/0x178
[  464.497014][T11969]  dump_stack+0x20/0x30
[  464.497031][T11969]  __bch2_trans_log_str+0x344/0x350
[  464.497048][T11969]  bch2_trans_log_str+0x3c/0x60
[  464.497065][T11969]  __bch2_fsck_err+0x11bc/0x1390
[  464.497083][T11969]  bch2_check_discard_freespace_key+0xad4/0x10d0
[  464.497100][T11969]  bch2_bucket_alloc_freelist+0x99c/0x1130
[  464.497117][T11969]  bch2_bucket_alloc_trans+0x79c/0xcb8
[  464.497133][T11969]  bch2_bucket_alloc_set_trans+0x378/0xc20
[  464.497151][T11969]  __open_bucket_add_buckets+0x7fc/0x1c00
[  464.497168][T11969]  open_bucket_add_buckets+0x184/0x3a8
[  464.497185][T11969]  bch2_alloc_sectors_start_trans+0xa04/0x1da0
[  464.497203][T11969]  bch2_btree_reserve_get+0x6e0/0xef0
[  464.497220][T11969]  bch2_btree_update_start+0x1618/0x2600
[  464.497239][T11969]  bch2_btree_split_leaf+0xcc/0x730
[  464.497258][T11969]  bch2_trans_commit_error+0x22c/0xc30
[  464.497276][T11969]  __bch2_trans_commit+0x207c/0x4e30
[  464.497292][T11969]  bch2_journal_replay+0x9e0/0x1420
[  464.497305][T11969]  __bch2_run_recovery_passes+0x458/0xf98
[  464.497318][T11969]  bch2_run_recovery_passes+0x280/0x478
[  464.497331][T11969]  bch2_fs_recovery+0x24f0/0x3a28
[  464.497344][T11969]  bch2_fs_start+0xb80/0x1248
[  464.497358][T11969]  bch2_fs_get_tree+0xe94/0x1708
[  464.497377][T11969]  vfs_get_tree+0x84/0x2d0

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 55952143f0d3..61107f2310ab 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -1005,6 +1005,7 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 {
 	struct btree_insert_entry *errored_at = NULL;
 	struct bch_fs *c = trans->c;
+	unsigned journal_u64s = 0;
 	int ret = 0;
 
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
@@ -1033,10 +1034,10 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 
 	EBUG_ON(test_bit(BCH_FS_clean_shutdown, &c->flags));
 
-	trans->journal_u64s		= trans->journal_entries.u64s + jset_u64s(trans->accounting.u64s);
+	journal_u64s = jset_u64s(trans->accounting.u64s);
 	trans->journal_transaction_names = READ_ONCE(c->opts.journal_transaction_names);
 	if (trans->journal_transaction_names)
-		trans->journal_u64s += jset_u64s(JSET_ENTRY_LOG_U64s);
+		journal_u64s += jset_u64s(JSET_ENTRY_LOG_U64s);
 
 	trans_for_each_update(trans, i) {
 		struct btree_path *path = trans->paths + i->path;
@@ -1056,11 +1057,11 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 			continue;
 
 		/* we're going to journal the key being updated: */
-		trans->journal_u64s += jset_u64s(i->k->k.u64s);
+		journal_u64s += jset_u64s(i->k->k.u64s);
 
 		/* and we're also going to log the overwrite: */
 		if (trans->journal_transaction_names)
-			trans->journal_u64s += jset_u64s(i->old_k.u64s);
+			journal_u64s += jset_u64s(i->old_k.u64s);
 	}
 
 	if (trans->extra_disk_res) {
@@ -1078,6 +1079,8 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		memset(&trans->journal_res, 0, sizeof(trans->journal_res));
 	memset(&trans->fs_usage_delta, 0, sizeof(trans->fs_usage_delta));
 
+	trans->journal_u64s = journal_u64s + trans->journal_entries.u64s;
+
 	ret = do_bch2_trans_commit(trans, flags, &errored_at, _RET_IP_);
 
 	/* make sure we didn't drop or screw up locks: */
-- 
2.50.0

