Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5C0374F2
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351389; cv=none; b=kS2cWEQ6blsDRN21WYnNnzc0IplNguu2pfl3sX4n/e70pimhE4iLX/i9XQuZv5kkapCwIXCJ3JVGxNnhCHXvBWExJORIFnL8rYFRVyF54fxwn+SX1/Xh9zKvGm+UfItnd6SBXWBv9w+pvDZ9S2B5DJjl2U+0h+NiKn06HVzxBcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351389; c=relaxed/simple;
	bh=7bemK/dKJzWr8Zh6HtXAKFMtok6y7I9cARSSdnnpcmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOmF+GmH7UrZ2WcZYWkcZMjS09EKKJAN4dKO/gwDH9W1L6zEtEoW0W4VpB/tjQPw4oQUZkROhQPDep2RbIQDNYf2FZd9nLvJQMvwZKJ/DE96FC2AQueOcl0MK2xvWZIPt9w1AMGxUSJl8X7rhKcTYgKtO7Z5WZS+9jIvxtWPGaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=fy404T3R; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="fy404T3R"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dc0e5b223eso1074775ad.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351387; x=1708956187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LLuWUQoB6jl1AhPFPYKZndF9usWN04HNeJiolnhs5k=;
        b=fy404T3RyU4IFUd0N9HRHbRvpg0m4lXCrZzUpIJvilpD+6bpmdpyz0YVkMmGT3ss43
         dnLcqTl3DKp5b6J4gD+neAQWQg1h0cHmZTuH3pCbglIhTqRL1c3JrkfYueXdXNhnPQ5H
         7/g4TizsmxbgNf5NDY0MxeFw/jXWKXmFnKNQVtdrrOFv2j5l3YWhD+sX8SiQFU0031FV
         17f3Au36fzLY+x33pESQP6kCWaTwAhdEAQkHOlU/q3HKdrlwScj8AD69HY///zG0yGYz
         YuMGkv24uIAg6zsx8c3rDJGTduUKa9ci6HbQywGtufHfUJfTJbJzEDzeAOVXgTQIopaz
         5oMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351387; x=1708956187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LLuWUQoB6jl1AhPFPYKZndF9usWN04HNeJiolnhs5k=;
        b=eXMH7LRcoyTG4jjOwC0nibj76+DgUOtLnhN6oslkKdFKIfPyfv56XyIgGCp917kRlV
         m63X9/Vf7mUEDGRoHtvZNN+pJOz581/uOVt03SSBRMwQcDnOvPZCfoZnucmY4j7WaX2o
         Q1sZVfd3yJuIiqp3/UN3tL9+moGyy7JzykxHG3jQ6Y1AOA3qQNhi27blxoioIUGJcvUG
         hP4S3yFwFJW7voiDQdsc70l1LeLSIXrWn5TH8Q4am0rpcMS+EF0dTloI0RVR3onipSyM
         0aMa+2o7Y2G0aOPij32Qr12uyoeAVL8osr+a7PBuw1RChOIvBDgPE/X6CkcdywlsoMvY
         mNrw==
X-Gm-Message-State: AOJu0YxU+X3RAjcZGbqBepVyQw/JUjB8f0SHvajLi9smkOuvV7LlprkB
	jNBvuvFd0YqUcqG0k+HHgTrP3dkheVloch2Rn6CkdPdwlf9863xbi5Yg+/TwzVWquhunx4ISwsZ
	E
X-Google-Smtp-Source: AGHT+IEQeBi3/172mOh6eitk0JYp3jX+Hq/9lK9ztUEccze8HkEqK7vcqjGF9IRL7PLDhY1ffuv5JA==
X-Received: by 2002:a17:902:7c01:b0:1d9:f495:cfa4 with SMTP id x1-20020a1709027c0100b001d9f495cfa4mr10516131pll.62.1708351386744;
        Mon, 19 Feb 2024 06:03:06 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id kj4-20020a17090306c400b001d6f29c12f7sm4456722plb.135.2024.02.19.06.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:03:06 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 1/3] bcachefs: improve move_extent tracepoints
Date: Tue, 20 Feb 2024 03:01:56 +1300
Message-ID: <20240219140230.897597-2-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219140230.897597-1-daniel@gluo.nz>
References: <20240219140230.897597-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/data_update.c | 70 +++++++++++++++++++++++++++++++--------
 fs/bcachefs/move.c        | 23 +++++++++++--
 fs/bcachefs/trace.h       | 11 ++++--
 3 files changed, 86 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 4150feca42a2..b14bd845f34a 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -88,6 +88,15 @@ static void trace_move_extent_fail2(struct data_update *m,
 	printbuf_exit(&buf);
 }
 
+static void trace_move_extent_fail3(struct bch_fs *c, const char *msg, int ret)
+{
+	struct printbuf buf = PRINTBUF;
+
+	prt_printf(&buf, "error %s %i", msg, ret);
+	trace_move_extent_fail(c, buf.buf);
+	printbuf_exit(&buf);
+}
+
 static int __bch2_data_update_index_update(struct btree_trans *trans,
 					   struct bch_write_op *op)
 {
@@ -121,13 +130,16 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		bool should_check_enospc;
 		s64 i_sectors_delta = 0, disk_sectors_delta = 0;
 		unsigned rewrites_found = 0, durability, i;
+		const char *msg = "no err";
 
 		bch2_trans_begin(trans);
 
 		k = bch2_btree_iter_peek_slot(&iter);
 		ret = bkey_err(k);
-		if (ret)
+		if (ret) {
+			msg = "peek_slot";
 			goto err;
+		}
 
 		new = bkey_i_to_extent(bch2_keylist_front(keys));
 
@@ -171,7 +183,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (m->data_opts.rewrite_ptrs &&
 		    !rewrites_found &&
 		    bch2_bkey_durability(c, k) >= m->op.opts.data_replicas) {
-			trace_move_extent_fail2(m, k, bkey_i_to_s_c(&new->k_i), insert, "no rewrites found:");
+			trace_move_extent_fail2(m, k, bkey_i_to_s_c(&new->k_i),
+						insert, "no rewrites found:");
 			goto nowork;
 		}
 
@@ -188,7 +201,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			}
 
 		if (!bkey_val_u64s(&new->k)) {
-			trace_move_extent_fail2(m, k, bkey_i_to_s_c(&new->k_i), insert, "new replicas conflicted:");
+			trace_move_extent_fail2(m, k, bkey_i_to_s_c(&new->k_i), insert,
+						"new replicas conflicted:");
 			goto nowork;
 		}
 
@@ -225,16 +239,21 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 						 &should_check_enospc,
 						 &i_sectors_delta,
 						 &disk_sectors_delta);
-		if (ret)
+		if (ret) {
+			msg = "sum_sectors";
 			goto err;
+		}
+
 
 		if (disk_sectors_delta > (s64) op->res.sectors) {
 			ret = bch2_disk_reservation_add(c, &op->res,
 						disk_sectors_delta - op->res.sectors,
 						!should_check_enospc
 						? BCH_DISK_RESERVATION_NOFAIL : 0);
-			if (ret)
+			if (ret) {
+				trace_move_extent_fail3(c, "disk_reservation_add", ret);
 				goto out;
+			}
 		}
 
 		next_pos = insert->k.p;
@@ -299,11 +318,15 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			this_cpu_add(c->counters[BCH_COUNTER_move_extent_finish], new->k.size);
 			trace_move_extent_finish2(c, bkey_i_to_s_c(&new->k_i));
 		}
+
 err:
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			ret = 0;
-		if (ret)
+
+		if (ret) {
+			trace_move_extent_fail3(c, msg, ret);
 			break;
+		}
 next:
 		while (bkey_ge(iter.pos, bch2_keylist_front(keys)->k.p)) {
 			bch2_keylist_pop_front(keys);
@@ -367,7 +390,7 @@ void bch2_data_update_exit(struct data_update *update)
 	bch2_bio_free_pages_pool(c, &update->op.wbio.bio);
 }
 
-static void bch2_update_unwritten_extent(struct btree_trans *trans,
+static int bch2_update_unwritten_extent(struct btree_trans *trans,
 				  struct data_update *update)
 {
 	struct bch_fs *c = update->op.c;
@@ -377,7 +400,8 @@ static void bch2_update_unwritten_extent(struct btree_trans *trans,
 	struct closure cl;
 	struct btree_iter iter;
 	struct bkey_s_c k;
-	int ret;
+	int ret = 0;
+	const char *msg = "";
 
 	closure_init_stack(&cl);
 	bch2_keylist_init(&update->op.insert_keys, update->op.inline_keys);
@@ -393,8 +417,12 @@ static void bch2_update_unwritten_extent(struct btree_trans *trans,
 		}));
 		bch2_trans_iter_exit(trans, &iter);
 
-		if (ret || !bch2_extents_match(k, bkey_i_to_s_c(update->k.k)))
+		if (ret)
 			break;
+		if (!bch2_extents_match(k, bkey_i_to_s_c(update->k.k))) {
+			msg = "extent doesn't match ";
+			goto err;
+		}
 
 		e = bkey_extent_init(update->op.insert_keys.top);
 		e->k.p = update->op.pos;
@@ -416,8 +444,15 @@ static void bch2_update_unwritten_extent(struct btree_trans *trans,
 
 		bch_err_fn_ratelimited(c, ret);
 
-		if (ret)
-			return;
+		if (ret) {
+			const char *estr = bch2_err_str(ret);
+			struct printbuf buf = PRINTBUF;
+
+			prt_printf(&buf, "alloc_sectors_start err %s", estr);
+			trace_update_unwritten_extent(c, buf.buf);
+			printbuf_exit(&buf);
+			return ret;
+		}
 
 		sectors = min(sectors, wp->sectors_free);
 
@@ -441,11 +476,20 @@ static void bch2_update_unwritten_extent(struct btree_trans *trans,
 		if (ret)
 			break;
 	}
-
+err:
 	if (closure_nr_remaining(&cl) != 1) {
 		bch2_trans_unlock(trans);
 		closure_sync(&cl);
 	}
+
+	const char *estr = bch2_err_str(ret);
+	struct printbuf buf = PRINTBUF;
+
+	prt_printf(&buf, "%serr: %s", msg, estr);
+	trace_update_unwritten_extent(c, buf.buf);
+	printbuf_exit(&buf);
+
+	return ret;
 }
 
 int bch2_extent_drop_ptrs(struct btree_trans *trans,
@@ -624,7 +668,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 	}
 
 	if (bkey_extent_is_unwritten(k)) {
-		bch2_update_unwritten_extent(trans, m);
+		ret = bch2_update_unwritten_extent(trans, m);
 		goto done;
 	}
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index bf68ea49447b..40a8305b3860 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -295,6 +295,12 @@ int bch2_move_extent(struct moving_context *ctxt,
 
 	if (!data_opts.rewrite_ptrs &&
 	    !data_opts.extra_replicas) {
+		struct printbuf buf = PRINTBUF;
+
+		prt_printf(&buf, "drop ptrs or ret 0");
+		trace_move_extent_finish(c, buf.buf);
+
+		printbuf_exit(&buf);
 		if (data_opts.kill_ptrs)
 			return bch2_extent_drop_ptrs(trans, iter, k, data_opts);
 		return 0;
@@ -388,12 +394,23 @@ int bch2_move_extent(struct moving_context *ctxt,
 err_free:
 	kfree(io);
 err:
-	if (ret == -BCH_ERR_data_update_done)
+	if (ret == -BCH_ERR_data_update_done) {
+		struct printbuf buf = PRINTBUF;
+
+		bch2_bkey_val_to_text(&buf, c, k);
+		prt_str(&buf, ": ");
+		prt_str(&buf, bch2_err_str(ret));
+		trace_move_extent_finish(c, buf.buf);
+		printbuf_exit(&buf);
 		return 0;
+	}
 
-	if (bch2_err_matches(ret, EROFS) ||
-	    bch2_err_matches(ret, BCH_ERR_transaction_restart))
+	if (bch2_err_matches(ret, EROFS))
+		return ret;
+	if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
+		trace_move_extent_finish(c, "BCH_ERR_transanction_restart");
 		return ret;
+	}
 
 	count_event(c, move_extent_start_fail);
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 293b90d704fb..f48c727d89aa 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -837,6 +837,11 @@ DEFINE_EVENT(fs_str, move_extent_fail,
 	TP_ARGS(c, str)
 );
 
+DEFINE_EVENT(fs_str, update_unwritten_extent,
+	     TP_PROTO(struct bch_fs *c, const char *k),
+	     TP_ARGS(c, k)
+);
+
 DEFINE_EVENT(fs_str, move_extent_start_fail,
 	TP_PROTO(struct bch_fs *c, const char *str),
 	TP_ARGS(c, str)
@@ -875,16 +880,18 @@ TRACE_EVENT(move_data,
 		  __entry->sectors_raced)
 );
 
-TRACE_EVENT(evacuate_bucket,
+TRACE_EVENT(evacuate_bucket_finish,
 	TP_PROTO(struct bch_fs *c, struct bpos *bucket,
+		 u8 gen,
 		 unsigned sectors, unsigned bucket_size,
 		 u64 fragmentation, int ret),
-	TP_ARGS(c, bucket, sectors, bucket_size, fragmentation, ret),
+	TP_ARGS(c, bucket, gen, sectors, bucket_size, fragmentation, ret),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev		)
 		__field(u64,		member		)
 		__field(u64,		bucket		)
+		__field(u8,		gen		)
 		__field(u32,		sectors		)
 		__field(u32,		bucket_size	)
 		__field(u64,		fragmentation	)
-- 
2.43.0

