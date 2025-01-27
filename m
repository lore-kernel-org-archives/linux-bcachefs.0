Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F108F2907
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951181; cv=none; b=tyOiAMSzlHZexSXnT5FaJ5+3gSpzygZtlBkuDjgylvoL38wlBbID0M5OAIELRuVS2PQ4tOUv3kFdJpirxh3J/aZcdghRmxlrXB8jaSgvl89Q1A5lcovYnqS5SBmlrL6erT5+2i7ncI2+J8lHukYZCtqdztjwUXr1PnT6K8yzxOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951181; c=relaxed/simple;
	bh=AvuENeeIAv0omt4deGFaaxKVP5qJYZ8ozOhJNcx1CYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyZrKLQZEcsu/BbXB5XMyNXq1rzdW57iCJZ/5VFDeONPvljrq/o69bXI3sHJycKGcoxA2w9JhtkKRqvAWTyDp07VLvquuoCDl6HS4ND7h5f48tF+cm3O7rN3qb77LGHhwLdkwHbZ5d4ZNziZwLhMilRAtJyY924tstLRqd1Klns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=boAdP9Cb; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="boAdP9Cb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbnhoL7rSwUkvumh65YvI8EDT7Hl8OivLDXTGArVcPY=;
	b=boAdP9CbFeTzgRwNpS2naBtp0IbV2sxHs+qsk7WM95Xp8vkgtFSCkYKA8tHhUcdW/7HMEz
	+aRqe+gejlwj8M+UtU8QNv+nwpfnvd/fGfPLR1EVS9QsX/ZZmxEKN721uamW5OHvBRqxeF
	KJfLGSihZECrs325AllDbNh0Xa0GJDU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/11] bcachefs: Fix trace_copygc
Date: Sun, 26 Jan 2025 23:12:36 -0500
Message-ID: <20250127041239.2693707-11-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/movinggc.c | 11 +++++++----
 fs/bcachefs/trace.h    | 26 ++++++++++++--------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 85c361e78ba5..21805509ab9e 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -215,7 +215,8 @@ static int bch2_copygc(struct moving_context *ctxt,
 	};
 	move_buckets buckets = { 0 };
 	struct move_bucket_in_flight *f;
-	u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
+	u64 sectors_seen	= atomic64_read(&ctxt->stats->sectors_seen);
+	u64 sectors_moved	= atomic64_read(&ctxt->stats->sectors_moved);
 	int ret = 0;
 
 	ret = bch2_copygc_get_buckets(ctxt, buckets_in_flight, &buckets);
@@ -245,7 +246,6 @@ static int bch2_copygc(struct moving_context *ctxt,
 		*did_work = true;
 	}
 err:
-	darray_exit(&buckets);
 
 	/* no entries in LRU btree found, or got to end: */
 	if (bch2_err_matches(ret, ENOENT))
@@ -254,8 +254,11 @@ static int bch2_copygc(struct moving_context *ctxt,
 	if (ret < 0 && !bch2_err_matches(ret, EROFS))
 		bch_err_msg(c, ret, "from bch2_move_data()");
 
-	moved = atomic64_read(&ctxt->stats->sectors_moved) - moved;
-	trace_and_count(c, copygc, c, moved, 0, 0, 0);
+	sectors_seen	= atomic64_read(&ctxt->stats->sectors_seen) - sectors_seen;
+	sectors_moved	= atomic64_read(&ctxt->stats->sectors_moved) - sectors_moved;
+	trace_and_count(c, copygc, c, buckets.nr, sectors_seen, sectors_moved);
+
+	darray_exit(&buckets);
 	return ret;
 }
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 9d40b7d4ea29..56a5a7fbc0fd 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -902,32 +902,30 @@ TRACE_EVENT(evacuate_bucket,
 
 TRACE_EVENT(copygc,
 	TP_PROTO(struct bch_fs *c,
-		 u64 sectors_moved, u64 sectors_not_moved,
-		 u64 buckets_moved, u64 buckets_not_moved),
-	TP_ARGS(c,
-		sectors_moved, sectors_not_moved,
-		buckets_moved, buckets_not_moved),
+		 u64 buckets,
+		 u64 sectors_seen,
+		 u64 sectors_moved),
+	TP_ARGS(c, buckets, sectors_seen, sectors_moved),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev			)
+		__field(u64,		buckets			)
+		__field(u64,		sectors_seen		)
 		__field(u64,		sectors_moved		)
-		__field(u64,		sectors_not_moved	)
-		__field(u64,		buckets_moved		)
-		__field(u64,		buckets_not_moved	)
 	),
 
 	TP_fast_assign(
 		__entry->dev			= c->dev;
+		__entry->buckets		= buckets;
+		__entry->sectors_seen		= sectors_seen;
 		__entry->sectors_moved		= sectors_moved;
-		__entry->sectors_not_moved	= sectors_not_moved;
-		__entry->buckets_moved		= buckets_moved;
-		__entry->buckets_not_moved = buckets_moved;
 	),
 
-	TP_printk("%d,%d sectors moved %llu remain %llu buckets moved %llu remain %llu",
+	TP_printk("%d,%d buckets %llu sectors seen %llu moved %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->sectors_moved, __entry->sectors_not_moved,
-		  __entry->buckets_moved, __entry->buckets_not_moved)
+		  __entry->buckets,
+		  __entry->sectors_seen,
+		  __entry->sectors_moved)
 );
 
 TRACE_EVENT(copygc_wait,
-- 
2.45.2

