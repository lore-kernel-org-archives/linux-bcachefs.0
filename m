Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264D725A2B9
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Mar 2025 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742912975; cv=none; b=iFlh81nO0wKWWRvhOn/k/GBj/fELuEth07nemLmdDguc0XPQ9GaQwGVGD0PGm1utZhqkzoN+98AnnOUpq305E1QCTlNgeJLhxtYwf8NYPlDJEF1I3lCSwF2kzoMtV+4xhPu7EGEScnBPHfnviDu+Pe6MlfwxeMP8OEQhl2KgFs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742912975; c=relaxed/simple;
	bh=pRpWBV6aiJPxHYQE62iJUcEJCULdIB2RTjg/eTmauvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+DvTp1wOm/mPWVqM9Vz+2X6zKaqx+rVBtNZtT6aatVqS9fKzH4+dTfaLQlDLAeqba7S/xnKgg8a/kYN06yveFjfXUL6fv59VxXqRmB+YZexMsTxhY5BykujNBhO8vIu1flHZDBhxFLMUt614FcRfCPyOlCpYqMLA8NCncPtOio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FaE4fI5N; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FaE4fI5N"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742912970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POANQt5y8f48FUQb4HOkKk5JKKlCggPvRfvAzMon0lE=;
	b=FaE4fI5NFR3swwrlA6JhdebEFGMUXXMGdEvztT5Xzr7ty6JQkSYSwuwgIRtJWV8RPB1IFg
	S5hjcXVn34I84pY8Z3x4xfQRHUeK8FKZJ3NgKTZ2GUTo0KneL2aaJjfOmMtM3x0Cv6m98c
	Znf70TAMa8P2TLsk9MfKFkv2V4tirnU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Document disk accounting keys and conuters
Date: Tue, 25 Mar 2025 10:29:25 -0400
Message-ID: <20250325142925.1999166-2-kent.overstreet@linux.dev>
In-Reply-To: <20250325142925.1999166-1-kent.overstreet@linux.dev>
References: <20250325142925.1999166-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting_format.h | 54 +++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
index 09198ffb57b1..8269af1dbe2a 100644
--- a/fs/bcachefs/disk_accounting_format.h
+++ b/fs/bcachefs/disk_accounting_format.h
@@ -119,22 +119,57 @@ enum disk_accounting_type {
 	BCH_DISK_ACCOUNTING_TYPE_NR,
 };
 
+/*
+ * No subtypes - number of inodes in the entire filesystem
+ *
+ * XXX: perhaps we could add a per-subvolume counter?
+ */
 struct bch_acct_nr_inodes {
 };
 
+/*
+ * Tracks KEY_TYPE_reservation sectors, broken out by number of replicas for the
+ * reservation:
+ */
 struct bch_acct_persistent_reserved {
 	__u8			nr_replicas;
 };
 
+/*
+ * device, data type counter fields:
+ * [
+ *   nr_buckets
+ *   live sectors (in buckets of that data type)
+ *   sectors of internal fragmentation
+ * ]
+ *
+ * XXX: live sectors should've been done differently, you can have multiple data
+ * types in the same bucket (user, stripe, cached) and this collapses them to
+ * the bucket data type, and makes the internal fragmentation counter redundant
+ */
 struct bch_acct_dev_data_type {
 	__u8			dev;
 	__u8			data_type;
 };
 
+/*
+ * Compression type fields:
+ * [
+ *   number of extents
+ *   uncompressed size
+ *   compressed size
+ * ]
+ *
+ * Compression ratio, average extent size (fragmentation).
+ */
 struct bch_acct_compression {
 	__u8			type;
 };
 
+/*
+ * On disk usage by snapshot id; counts same values as replicas counter, but
+ * aggregated differently
+ */
 struct bch_acct_snapshot {
 	__u32			id;
 } __packed;
@@ -143,10 +178,27 @@ struct bch_acct_btree {
 	__u32			id;
 } __packed;
 
+/*
+ * inum counter fields:
+ * [
+ *   number of extents
+ *   sum of extent sizes - bkey size
+ *     this field is similar to inode.bi_sectors, except here extents in
+ *     different snapshots but the same inode number are all collapsed to the
+ *     same counter
+ *   sum of on disk size - same values tracked by replicas counters
+ * ]
+ *
+ * This tracks on disk fragmentation.
+ */
 struct bch_acct_inum {
 	__u64			inum;
 } __packed;
 
+/*
+ * Simple counter of the amount of data (on disk sectors) rebalance needs to
+ * move, extents counted here are also in the rebalance_work btree.
+ */
 struct bch_acct_rebalance_work {
 };
 
@@ -155,7 +207,7 @@ struct disk_accounting_pos {
 	struct {
 		__u8				type;
 		union {
-		struct bch_acct_nr_inodes		nr_inodes;
+		struct bch_acct_nr_inodes	nr_inodes;
 		struct bch_acct_persistent_reserved	persistent_reserved;
 		struct bch_replicas_entry_v1	replicas;
 		struct bch_acct_dev_data_type	dev_data_type;
-- 
2.49.0

