Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F91918C008
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810655; cv=none; b=VhW2Jok0GAT2FCH+gcmCulkda0PskvYnI85LTyDHN8m3H/dSxmzZh67sSR+APGR3ajF6rwhreHD7wKLf+l8jwe+bUeBwxxdotibcyL+495KyoZwh4vSlEF7oGDv9ODwSmk3KhAP5l2sRvhSjr4DNTN8GQuQsTlkDwtxWVPEjYtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810655; c=relaxed/simple;
	bh=lnh4ypc4XVGfh2e0hH5Qpk3Njh3zj6JvX4iLa4gH1vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWz4/K97q+HXMnmuEtjhbK7SnAFfPBgB6aX09q/yGXd5cfI7ly53xin22b9ZPw2SJDTQ+c51Ceo/ZuuCezp711yzir0L2WT4pZcL8jLhe3kZWSwTNhMzKCMUacX/PS8LsAL64H30XrgxYsf1UttA2xcm+He5qBCBxjUGmn9l1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XZXMaIjF; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XZXMaIjF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GQNDMdr3qhYROZT6RsVUsuo6PXnnICBJIB+PLm95Euo=;
	b=XZXMaIjF+FssO0u/hHfvwa1PipbBU2IlgLgdL7bNmreldrEbhvg9OMlw6UukmEj448hFqD
	RAXsEodtL5/yW0DGM5NpStrG3A1ZOz5FVSMjMcj3w/6tcpT+ats185qr83Q6nTcSLJaclk
	psmeoEraDoP3nKb6iKA/1iFCwFK26a8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/6] bcachefs: print_str_as_lines() -> print_str()
Date: Wed, 16 Apr 2025 09:37:22 -0400
Message-ID: <20250416133724.3653606-4-kent.overstreet@linux.dev>
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

bch2_print_string_as_lines() is a low level helper that allows messages
longer than 1k to be printed without truncation.

But we should always be printing with the helpers that take a filesystem
object, if we're in fsck they direct output to the userspace process
controlling fsck instead of the dmesg log.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c      |  2 +-
 fs/bcachefs/bcachefs.h              |  3 ++-
 fs/bcachefs/btree_io.c              |  2 +-
 fs/bcachefs/btree_iter.c            |  4 ++--
 fs/bcachefs/btree_locking.c         |  2 +-
 fs/bcachefs/btree_node_scan.c       |  6 +++---
 fs/bcachefs/btree_update_interior.c |  2 +-
 fs/bcachefs/buckets.c               |  6 +++---
 fs/bcachefs/data_update.c           |  2 +-
 fs/bcachefs/error.c                 | 10 +++++-----
 fs/bcachefs/journal.c               |  4 ++--
 fs/bcachefs/journal_io.c            |  2 +-
 fs/bcachefs/recovery_passes.c       |  2 +-
 fs/bcachefs/sb-members.c            |  2 +-
 fs/bcachefs/super.c                 | 15 +++++++++++++--
 fs/bcachefs/util.c                  | 14 ++------------
 fs/bcachefs/util.h                  |  3 +--
 17 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index ae7eb523fae7..59950d733da8 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -1642,7 +1642,7 @@ static noinline void bch2_print_allocator_stuck(struct bch_fs *c)
 	bch2_journal_debug_to_text(&buf, &c->journal);
 	printbuf_indent_sub(&buf, 2);
 
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_str(c, KERN_ERR, buf.buf);
 	printbuf_exit(&buf);
 }
 
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 4e5cc127ea93..a1a4e941704b 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -269,7 +269,8 @@ do {									\
 
 #define bch2_fmt(_c, fmt)		bch2_log_msg(_c, fmt "\n")
 
-void bch2_print_str(struct bch_fs *, const char *);
+void bch2_print_str(struct bch_fs *, const char *, const char *);
+void bch2_print_str_nonblocking(struct bch_fs *, const char *, const char *);
 
 __printf(2, 3)
 void bch2_print_opts(struct bch_opts *, const char *, ...);
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index afcd13092807..79cf1392f83a 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -604,7 +604,7 @@ static int __btree_err(int ret,
 	}
 
 	if (!silent)
-		bch2_print_string_as_lines(KERN_ERR, out.buf);
+		bch2_print_str(c, KERN_ERR, out.buf);
 out:
 fsck_err:
 	printbuf_exit(&out);
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index db7d6e1902a7..c824f1b6be27 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -1591,7 +1591,7 @@ void __bch2_dump_trans_paths_updates(struct btree_trans *trans, bool nosort)
 	__bch2_trans_paths_to_text(&buf, trans, nosort);
 	bch2_trans_updates_to_text(&buf, trans);
 
-	bch2_print_str(trans->c, buf.buf);
+	bch2_print_str(trans->c, KERN_ERR, buf.buf);
 	printbuf_exit(&buf);
 }
 
@@ -3112,7 +3112,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 #ifdef CONFIG_BCACHEFS_DEBUG
 		struct printbuf buf = PRINTBUF;
 		bch2_trans_kmalloc_trace_to_text(&buf, &trans->trans_kmalloc_trace);
-		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		bch2_print_str(c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 #endif
 	}
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index f4f563944340..baa505a9a706 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -236,7 +236,7 @@ static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle,
 			prt_newline(&buf);
 		}
 
-		bch2_print_string_as_lines_nonblocking(KERN_ERR, buf.buf);
+		bch2_print_str_nonblocking(g->g->trans->c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 		BUG();
 	}
diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 86acf037590c..81ee7ae88a77 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -395,7 +395,7 @@ int bch2_scan_for_btree_nodes(struct bch_fs *c)
 		printbuf_reset(&buf);
 		prt_printf(&buf, "%s: nodes found:\n", __func__);
 		found_btree_nodes_to_text(&buf, c, f->nodes);
-		bch2_print_string_as_lines(KERN_INFO, buf.buf);
+		bch2_print_str(c, KERN_INFO, buf.buf);
 	}
 
 	sort_nonatomic(f->nodes.data, f->nodes.nr, sizeof(f->nodes.data[0]), found_btree_node_cmp_cookie, NULL);
@@ -424,7 +424,7 @@ int bch2_scan_for_btree_nodes(struct bch_fs *c)
 		printbuf_reset(&buf);
 		prt_printf(&buf, "%s: nodes after merging replicas:\n", __func__);
 		found_btree_nodes_to_text(&buf, c, f->nodes);
-		bch2_print_string_as_lines(KERN_INFO, buf.buf);
+		bch2_print_str(c, KERN_INFO, buf.buf);
 	}
 
 	swap(nodes_heap, f->nodes);
@@ -470,7 +470,7 @@ int bch2_scan_for_btree_nodes(struct bch_fs *c)
 		printbuf_reset(&buf);
 		prt_printf(&buf, "%s: nodes found after overwrites:\n", __func__);
 		found_btree_nodes_to_text(&buf, c, f->nodes);
-		bch2_print_string_as_lines(KERN_INFO, buf.buf);
+		bch2_print_str(c, KERN_INFO, buf.buf);
 	} else {
 		bch_info(c, "btree node scan found %zu nodes after overwrites", f->nodes.nr);
 	}
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 55fbeeb8eaaa..953fb3338d70 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -1792,7 +1792,7 @@ static int bch2_btree_insert_node(struct btree_update *as, struct btree_trans *t
 		bch2_btree_update_to_text(&buf, as);
 		bch2_btree_path_to_text(&buf, trans, path_idx);
 
-		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		bch2_print_str(c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 		bch2_fs_emergency_read_only(c);
 		return -EIO;
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index be71851baf3c..09e84d4a76b5 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -409,7 +409,7 @@ static int bucket_ref_update_err(struct btree_trans *trans, struct printbuf *buf
 	}
 
 	if (print || insert)
-		bch2_print_string_as_lines(KERN_ERR, buf->buf);
+		bch2_print_str(c, KERN_ERR, buf->buf);
 	return ret;
 }
 
@@ -699,7 +699,7 @@ static int bch2_trigger_stripe_ptr(struct btree_trans *trans,
 				   (u64) p.ec.idx);
 			bch2_bkey_val_to_text(&buf, c, k);
 			__bch2_inconsistent_error(c, &buf);
-			bch2_print_string_as_lines(KERN_ERR, buf.buf);
+			bch2_print_str(c, KERN_ERR, buf.buf);
 			printbuf_exit(&buf);
 			return -BCH_ERR_trigger_stripe_pointer;
 		}
@@ -969,7 +969,7 @@ static int __bch2_trans_mark_metadata_bucket(struct btree_trans *trans,
 					BCH_RECOVERY_PASS_check_allocations);
 
 		if (print)
-			bch2_print_string_as_lines(KERN_ERR, buf.buf);
+			bch2_print_str(c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 		ret = -BCH_ERR_metadata_bucket_inconsistency;
 		goto err;
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index b211c97238ab..c3034338f9e4 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -358,7 +358,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			prt_str(&buf, "\nnew: ");
 			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
 
-			bch2_print_string_as_lines(KERN_ERR, buf.buf);
+			bch2_print_str(c, KERN_ERR, buf.buf);
 			printbuf_exit(&buf);
 
 			bch2_fatal_error(c);
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 5ea72cb7fe7e..04a714b0e4cd 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -34,7 +34,7 @@ bool __bch2_inconsistent_error(struct bch_fs *c, struct printbuf *out)
 				   journal_cur_seq(&c->journal));
 		return true;
 	case BCH_ON_ERROR_panic:
-		bch2_print_string_as_lines_nonblocking(KERN_ERR, out->buf);
+		bch2_print_str(c, KERN_ERR, out->buf);
 		panic(bch2_fmt(c, "panic after error"));
 		return true;
 	default:
@@ -71,7 +71,7 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 	if (trans)
 		bch2_trans_updates_to_text(&buf, trans);
 	bool ret = __bch2_inconsistent_error(c, &buf);
-	bch2_print_string_as_lines_nonblocking(KERN_ERR, buf.buf);
+	bch2_print_str_nonblocking(c, KERN_ERR, buf.buf);
 
 	printbuf_exit(&buf);
 	return ret;
@@ -121,7 +121,7 @@ int bch2_fs_topology_error(struct bch_fs *c, const char *fmt, ...)
 	va_end(args);
 
 	int ret = __bch2_topology_error(c, &buf);
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_str(c, KERN_ERR, buf.buf);
 
 	printbuf_exit(&buf);
 	return ret;
@@ -331,7 +331,7 @@ static int do_fsck_ask_yn(struct bch_fs *c,
 	if (bch2_fs_stdio_redirect(c))
 		bch2_print(c, "%s", question->buf);
 	else
-		bch2_print_string_as_lines(KERN_ERR, question->buf);
+		bch2_print_str(c, KERN_ERR, question->buf);
 
 	int ask = bch2_fsck_ask_yn(c, trans);
 
@@ -566,7 +566,7 @@ int __bch2_fsck_err(struct bch_fs *c,
 		if (bch2_fs_stdio_redirect(c))
 			bch2_print(c, "%s", out->buf);
 		else
-			bch2_print_string_as_lines(KERN_ERR, out->buf);
+			bch2_print_str(c, KERN_ERR, out->buf);
 	}
 
 	if (s)
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 8ca7f1cc73ed..23f37dbfaba9 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -173,7 +173,7 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	spin_unlock(&j->lock);
 	prt_printf(&buf, bch2_fmt(c, "Journal stuck! Hava a pre-reservation but journal full (error %s)"),
 				  bch2_err_str(error));
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_str(c, KERN_ERR, buf.buf);
 
 	printbuf_reset(&buf);
 	bch2_journal_pins_to_text(&buf, j);
@@ -726,7 +726,7 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 
 	struct printbuf buf = PRINTBUF;
 	bch2_journal_debug_to_text(&buf, j);
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_str(c, KERN_ERR, buf.buf);
 	prt_printf(&buf, bch2_fmt(c, "Journal stuck? Waited for 10 seconds, err %s"), bch2_err_str(ret));
 	printbuf_exit(&buf);
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 2a54ac79189b..913125df0263 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -2105,7 +2105,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
 					  le64_to_cpu(w->data->seq),
 					  vstruct_sectors(w->data, c->block_bits),
 					  bch2_err_str(ret));
-		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		bch2_print_str(c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 	}
 	if (ret)
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 4744e2e5f2ab..d0b8a852efae 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -162,7 +162,7 @@ int bch2_run_explicit_recovery_pass(struct bch_fs *c,
 	int ret = bch2_run_explicit_recovery_pass_printbuf(c, &buf, pass);
 
 	if (len != buf.pos)
-		bch2_print_string_as_lines(KERN_NOTICE, buf.buf);
+		bch2_print_str(c, KERN_NOTICE, buf.buf);
 	printbuf_exit(&buf);
 	return ret;
 }
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 5f7a7d1965e3..cdc4258c3c21 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -24,7 +24,7 @@ int bch2_dev_missing_bkey(struct bch_fs *c, struct bkey_s_c k, unsigned dev)
 						 BCH_RECOVERY_PASS_check_allocations);
 
 	if (print)
-		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		bch2_print_str(c, KERN_ERR, buf.buf);
 	printbuf_exit(&buf);
 	return ret;
 }
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 1d27a306938d..3c61b4abda81 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -84,7 +84,8 @@ const char * const bch2_fs_flag_strs[] = {
 	NULL
 };
 
-void bch2_print_str(struct bch_fs *c, const char *str)
+static void __bch2_print_str(struct bch_fs *c, const char *prefix,
+			     const char *str, bool nonblocking)
 {
 #ifdef __KERNEL__
 	struct stdio_redirect *stdio = bch2_fs_stdio_redirect(c);
@@ -94,7 +95,17 @@ void bch2_print_str(struct bch_fs *c, const char *str)
 		return;
 	}
 #endif
-	bch2_print_string_as_lines(KERN_ERR, str);
+	bch2_print_string_as_lines(KERN_ERR, str, nonblocking);
+}
+
+void bch2_print_str(struct bch_fs *c, const char *prefix, const char *str)
+{
+	__bch2_print_str(c, prefix, str, false);
+}
+
+void bch2_print_str_nonblocking(struct bch_fs *c, const char *prefix, const char *str)
+{
+	__bch2_print_str(c, prefix, str, true);
 }
 
 __printf(2, 0)
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 87af551692f4..6e5d7fc265bd 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -252,8 +252,8 @@ void bch2_prt_u64_base2(struct printbuf *out, u64 v)
 	bch2_prt_u64_base2_nbits(out, v, fls64(v) ?: 1);
 }
 
-static void __bch2_print_string_as_lines(const char *prefix, const char *lines,
-					 bool nonblocking)
+void bch2_print_string_as_lines(const char *prefix, const char *lines,
+				bool nonblocking)
 {
 	bool locked = false;
 	const char *p;
@@ -281,16 +281,6 @@ static void __bch2_print_string_as_lines(const char *prefix, const char *lines,
 		console_unlock();
 }
 
-void bch2_print_string_as_lines(const char *prefix, const char *lines)
-{
-	return __bch2_print_string_as_lines(prefix, lines, false);
-}
-
-void bch2_print_string_as_lines_nonblocking(const char *prefix, const char *lines)
-{
-	return __bch2_print_string_as_lines(prefix, lines, true);
-}
-
 int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *task, unsigned skipnr,
 			gfp_t gfp)
 {
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 3cd2a4231d60..fa742af97a3e 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -212,8 +212,7 @@ u64 bch2_read_flag_list(const char *, const char * const[]);
 void bch2_prt_u64_base2_nbits(struct printbuf *, u64, unsigned);
 void bch2_prt_u64_base2(struct printbuf *, u64);
 
-void bch2_print_string_as_lines(const char *prefix, const char *lines);
-void bch2_print_string_as_lines_nonblocking(const char *prefix, const char *lines);
+void bch2_print_string_as_lines(const char *, const char *, bool);
 
 typedef DARRAY(unsigned long) bch_stacktrace;
 int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *, unsigned, gfp_t);
-- 
2.49.0

