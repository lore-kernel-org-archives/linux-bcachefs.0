Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F815ADB4
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951182; cv=none; b=N6uGu9lrBW5sraesBNoY3pcvSs92aOAQyyGhKjxovDpeezYLmV1RH4rL7Zmg8jHw518yePAia2dwTMFD4+zChHMBEYYBSlVNuqHctF1625JTY3x6tQcLGvmqg2BGFDK1yhP0ItIm6cQgyhgyInYA/FxHS0Md6UIp2G68ILM6a/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951182; c=relaxed/simple;
	bh=nd3Zunp6iT8b418va2AuUlh5qyAWTDWBHox6LvndQFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFPzUucLQW9a4JbyaQqjIF8ts/5gXTaCQImL/3GmhaU+Bjn9MOMQaK9jZGLPiWy8PDVzt4bkixaGZkKs+CO+UtImgO3gLUaC2+tqog69yfLUi6hcTu1pQ2bldDsfVpUsNhnNCt8khvbWntzZc2ylR9jCyOKT3Y58DVwa7+IPKRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e+aYWJdG; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e+aYWJdG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uRJGZ3zsb3sE/jeRvKXqeRri2pFBFoJUcyWduo00I1E=;
	b=e+aYWJdGRBLCay0QOVIPsvocEMqTRZMqXQGrScVuXepY4QfKDO5zBJNwtXOefCj7Volkm8
	HWZJA5UXeVRJ0BcyKLzaJMn1VYfHpwrKQgC8JUud5hB4Xsf9EjEct0Eccu/87lT4NSO8ZX
	F4bg/H6CaoZnYJa9TkGIbGucn/X6E94=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/11] bcachefs: Improve trace_move_extent_finish
Date: Sun, 26 Jan 2025 23:12:37 -0500
Message-ID: <20250127041239.2693707-12-kent.overstreet@linux.dev>
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

We're currently debugging issues with rebalance, where it's not making
progress as quickly as it should be (or sometimes not at all).

Add the full data_update to the move_extent_finish tracepoint, so we can
check that the replicas we wrote match what we were supposed to do.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 50 ++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 585214931e05..337494facac6 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -91,15 +91,28 @@ static bool bkey_nocow_lock(struct bch_fs *c, struct moving_context *ctxt, struc
 	return true;
 }
 
-static void trace_move_extent_finish2(struct bch_fs *c, struct bkey_s_c k)
+static noinline void trace_move_extent_finish2(struct data_update *u,
+					       struct bkey_i *new,
+					       struct bkey_i *insert)
 {
-	if (trace_move_extent_finish_enabled()) {
-		struct printbuf buf = PRINTBUF;
+	struct bch_fs *c = u->op.c;
+	struct printbuf buf = PRINTBUF;
 
-		bch2_bkey_val_to_text(&buf, c, k);
-		trace_move_extent_finish(c, buf.buf);
-		printbuf_exit(&buf);
-	}
+	prt_newline(&buf);
+
+	bch2_data_update_to_text(&buf, u);
+	prt_newline(&buf);
+
+	prt_str_indented(&buf, "new replicas:\t");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(new));
+	prt_newline(&buf);
+
+	prt_str_indented(&buf, "insert:\t");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
+	prt_newline(&buf);
+
+	trace_move_extent_finish(c, buf.buf);
+	printbuf_exit(&buf);
 }
 
 static void trace_move_extent_fail2(struct data_update *m,
@@ -372,7 +385,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			bch2_btree_iter_set_pos(&iter, next_pos);
 
 			this_cpu_add(c->counters[BCH_COUNTER_move_extent_finish], new->k.size);
-			trace_move_extent_finish2(c, bkey_i_to_s_c(&new->k_i));
+			if (trace_move_extent_finish_enabled())
+				trace_move_extent_finish2(m, &new->k_i, insert);
 		}
 err:
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
@@ -525,34 +539,38 @@ void bch2_data_update_opts_to_text(struct printbuf *out, struct bch_fs *c,
 				   struct data_update_opts *data_opts)
 {
 	printbuf_tabstop_push(out, 20);
-	prt_str(out, "rewrite ptrs:\t");
+
+	prt_str_indented(out, "rewrite ptrs:\t");
 	bch2_prt_u64_base2(out, data_opts->rewrite_ptrs);
 	prt_newline(out);
 
-	prt_str(out, "kill ptrs:\t");
+	prt_str_indented(out, "kill ptrs:\t");
 	bch2_prt_u64_base2(out, data_opts->kill_ptrs);
 	prt_newline(out);
 
-	prt_str(out, "target:\t");
+	prt_str_indented(out, "target:\t");
 	bch2_target_to_text(out, c, data_opts->target);
 	prt_newline(out);
 
-	prt_str(out, "compression:\t");
+	prt_str_indented(out, "compression:\t");
 	bch2_compression_opt_to_text(out, io_opts->background_compression);
 	prt_newline(out);
 
-	prt_str(out, "opts.replicas:\t");
+	prt_str_indented(out, "opts.replicas:\t");
 	prt_u64(out, io_opts->data_replicas);
+	prt_newline(out);
 
-	prt_str(out, "extra replicas:\t");
+	prt_str_indented(out, "extra replicas:\t");
 	prt_u64(out, data_opts->extra_replicas);
 }
 
 void bch2_data_update_to_text(struct printbuf *out, struct data_update *m)
 {
-	bch2_bkey_val_to_text(out, m->op.c, bkey_i_to_s_c(m->k.k));
-	prt_newline(out);
 	bch2_data_update_opts_to_text(out, m->op.c, &m->op.opts, &m->data_opts);
+	prt_newline(out);
+
+	prt_str_indented(out, "old key:\t");
+	bch2_bkey_val_to_text(out, m->op.c, bkey_i_to_s_c(m->k.k));
 }
 
 int bch2_extent_drop_ptrs(struct btree_trans *trans,
-- 
2.45.2

