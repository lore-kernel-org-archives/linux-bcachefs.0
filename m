Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F95158538
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810653; cv=none; b=Zk8jT4a/0MeHhQZSqvYnA5q43tp4zj3Wx5JZkCb1filzZcjUvfgr6sdw7jz9Cu3B60Qjyf11Zyf3PnC06y6U91FDKfAjE/HWvSL1lq1AsbdZP6NbOXXKx900cCsuWoEXzW1ltCneBTvw8RMZ/6hYl6+eJ/GIw3uQSdawTYEfhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810653; c=relaxed/simple;
	bh=S4SqC2z2Sct7ux4sg/uWeEOpaCEmz+wuITE7wPMZH40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILbrR1v3SQE0mCpTvzdsIeyLwK6NC4ctAQ6gFYr8RnTQlTLptSM+O2M+g15v2QqY0+0iUO+wDsJTflzuL9lR9x2Qm23Pc4giFNwlaSoZZK8fEqR4i6sulNIaJLht/rBK+53dET+MH98aZCZvVegLKBtjZ47DdCkHKHpFwsVNm2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XgXqS573; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XgXqS573"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uzd9A0URau0MDwPBVbgtWct0u1DjriDRnjKMfVBBwFY=;
	b=XgXqS573jWHpvOxURSxwfAhXC+vB5f34wN87r8e08NLSAbKrL07tpWx/ve+mQSh1ReU1/W
	s7w3HDOWVxTjWj1VUFKh75kptuxDzvim3jKK9H4EKq99NKDMYUyBwu3EIKzmMSc/7xL0PU
	4j14WfDntqZNrATOlrlnrju0ajMPUOs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/6] bcachefs: Simplify bch2_count_fsck_err()
Date: Wed, 16 Apr 2025 09:37:20 -0400
Message-ID: <20250416133724.3653606-2-kent.overstreet@linux.dev>
In-Reply-To: <20250416133724.3653606-1-kent.overstreet@linux.dev>
References: <20250416133724.3653606-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/buckets.c | 16 +++-------------
 fs/bcachefs/error.c   | 14 ++++++++++----
 fs/bcachefs/error.h   |  4 +---
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index cebd4d21f361..be71851baf3c 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -392,29 +392,23 @@ static int bucket_ref_update_err(struct btree_trans *trans, struct printbuf *buf
 				 struct bkey_s_c k, bool insert, enum bch_sb_error_id id)
 {
 	struct bch_fs *c = trans->c;
-	bool repeat = false, print = true, suppress = false;
 
 	prt_printf(buf, "\nwhile marking ");
 	bch2_bkey_val_to_text(buf, c, k);
 	prt_newline(buf);
 
-	__bch2_count_fsck_err(c, id, buf->buf, &repeat, &print, &suppress);
+	bool print = __bch2_count_fsck_err(c, id, buf);
 
 	int ret = bch2_run_explicit_recovery_pass_printbuf(c, buf,
 					BCH_RECOVERY_PASS_check_allocations);
 
 	if (insert) {
-		print = true;
-		suppress = false;
-
 		bch2_trans_updates_to_text(buf, trans);
 		__bch2_inconsistent_error(c, buf);
 		ret = -BCH_ERR_bucket_ref_update;
 	}
 
-	if (suppress)
-		prt_printf(buf, "Ratelimiting new instances of previous error\n");
-	if (print)
+	if (print || insert)
 		bch2_print_string_as_lines(KERN_ERR, buf->buf);
 	return ret;
 }
@@ -969,15 +963,11 @@ static int __bch2_trans_mark_metadata_bucket(struct btree_trans *trans,
 			   bch2_data_type_str(type),
 			   bch2_data_type_str(type));
 
-		bool repeat = false, print = true, suppress = false;
-		bch2_count_fsck_err(c, bucket_metadata_type_mismatch, buf.buf,
-				    &repeat, &print, &suppress);
+		bool print = bch2_count_fsck_err(c, bucket_metadata_type_mismatch, &buf);
 
 		bch2_run_explicit_recovery_pass_printbuf(c, &buf,
 					BCH_RECOVERY_PASS_check_allocations);
 
-		if (suppress)
-			prt_printf(&buf, "Ratelimiting new instances of previous error\n");
 		if (print)
 			bch2_print_string_as_lines(KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index c3385bc0d1ef..5ea72cb7fe7e 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -379,15 +379,21 @@ static struct fsck_err_state *count_fsck_err_locked(struct bch_fs *c,
 	return s;
 }
 
-void __bch2_count_fsck_err(struct bch_fs *c,
-			   enum bch_sb_error_id id, const char *msg,
-			   bool *repeat, bool *print, bool *suppress)
+bool __bch2_count_fsck_err(struct bch_fs *c,
+			   enum bch_sb_error_id id, struct printbuf *msg)
 {
 	bch2_sb_error_count(c, id);
 
 	mutex_lock(&c->fsck_error_msgs_lock);
-	count_fsck_err_locked(c, id, msg, repeat, print, suppress);
+	bool print = true, repeat = false, suppress = false;
+
+	count_fsck_err_locked(c, id, msg->buf, &repeat, &print, &suppress);
 	mutex_unlock(&c->fsck_error_msgs_lock);
+
+	if (suppress)
+		prt_printf(msg, "Ratelimiting new instances of previous error\n");
+
+	return print && !repeat;
 }
 
 int __bch2_fsck_err(struct bch_fs *c,
diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
index d0d024dc714b..da653e4ec8fa 100644
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -76,9 +76,7 @@ struct fsck_err_state {
 
 #define fsck_err_count(_c, _err)	bch2_sb_err_count(_c, BCH_FSCK_ERR_##_err)
 
-void __bch2_count_fsck_err(struct bch_fs *,
-			   enum bch_sb_error_id, const char *,
-			   bool *, bool *, bool *);
+bool __bch2_count_fsck_err(struct bch_fs *, enum bch_sb_error_id, struct printbuf *);
 #define bch2_count_fsck_err(_c, _err, ...)				\
 	__bch2_count_fsck_err(_c, BCH_FSCK_ERR_##_err, __VA_ARGS__)
 
-- 
2.49.0

