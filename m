Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418721CC48
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283686; cv=none; b=UdPhZyCZBjC6SprSOQrKK6kyudrB+YSX+BGNKo/cw+2qlqqdDxGF2JTBtSpbKzzCE0lG+6dWvX96w9t4izaFuOhS+l2fsgntFy3qc7cjGM7rA+mDkt0SySNhF8nc0lCvWE1rTcIhrXtdLzQO4CNQvalXmoCkdssd1AuppRipMPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283686; c=relaxed/simple;
	bh=rIpqcP7pdYyL6JLawhOxP0CzveXEBkimLxRg3jahUMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgwJemqOJLeiqThgObhI7cqmJymx6dETgIb81LwxDH2o9hZJF7E2iSkyAJUOSL9zUC9rS3r2PlCCasPU/tRyBbG8+lW8nzQZryul7BOSFoinSCdjP3ojfOnw0Zxxm3D304D2sb4LDTBPZoJevaAr42iZsvS3Ymnf24UaYvVC3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HSinZDa6; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HSinZDa6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6Ml2IccfejHb7i59qTee5yFLYek3kOW65sxLonTYqc=;
	b=HSinZDa6sMChLbXjGa2T0Lpp70nAPY1B+dVMqt+tQmEG+FzffOHWgAKs4LQxsZXwltneZF
	+rY2XD9sYn+ci7CugBQJEd32zMEgKOnqRoSRPnCbqdDj4hBISr2OI8/5kd8C5H+z/5AK5w
	iQ2FrQLuwkVwp6ynwUs43HFW93944/0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/37] bcachefs: btree iter tracepoints
Date: Wed, 18 Jun 2025 17:53:53 -0400
Message-ID: <20250618215431.738317-3-kent.overstreet@linux.dev>
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

We've been seeing some livelock-ish behavior in the index update part of
the main write path, and while we've got low level btree path
tracepoints, we've been lacking high level btree iterator tracepoints.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 67 +++++++++++++++++++++++++++++++++++++---
 fs/bcachefs/trace.h      | 20 ++++++++++++
 2 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b78403376c07..b586ecf2fdfa 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2326,6 +2326,20 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_trans *trans, struct
 	}
 
 	bch2_btree_iter_verify(trans, iter);
+
+	if (trace___btree_iter_peek_enabled()) {
+		CLASS(printbuf, buf)();
+
+		int ret = bkey_err(k);
+		if (ret)
+			prt_str(&buf, bch2_err_str(ret));
+		else if (k.k)
+			bch2_bkey_val_to_text(&buf, trans->c, k);
+		else
+			prt_str(&buf, "(null)");
+		trace___btree_iter_peek(trans->c, buf.buf);
+	}
+
 	return k;
 }
 
@@ -2484,6 +2498,19 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_trans *trans, struct btree
 
 	bch2_btree_iter_verify_entry_exit(iter);
 
+	if (trace_btree_iter_peek_max_enabled()) {
+		CLASS(printbuf, buf)();
+
+		int ret = bkey_err(k);
+		if (ret)
+			prt_str(&buf, bch2_err_str(ret));
+		else if (k.k)
+			bch2_bkey_val_to_text(&buf, trans->c, k);
+		else
+			prt_str(&buf, "(null)");
+		trace_btree_iter_peek_max(trans->c, buf.buf);
+	}
+
 	return k;
 end:
 	bch2_btree_iter_set_pos(trans, iter, end);
@@ -2724,6 +2751,19 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_trans *trans, struct
 
 	bch2_btree_iter_verify_entry_exit(iter);
 	bch2_btree_iter_verify(trans, iter);
+
+	if (trace_btree_iter_peek_prev_min_enabled()) {
+		CLASS(printbuf, buf)();
+
+		int ret = bkey_err(k);
+		if (ret)
+			prt_str(&buf, bch2_err_str(ret));
+		else if (k.k)
+			bch2_bkey_val_to_text(&buf, trans->c, k);
+		else
+			prt_str(&buf, "(null)");
+		trace_btree_iter_peek_prev_min(trans->c, buf.buf);
+	}
 	return k;
 end:
 	bch2_btree_iter_set_pos(trans, iter, end);
@@ -2767,8 +2807,10 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_trans *trans, struct btre
 	/* extents can't span inode numbers: */
 	if ((iter->flags & BTREE_ITER_is_extents) &&
 	    unlikely(iter->pos.offset == KEY_OFFSET_MAX)) {
-		if (iter->pos.inode == KEY_INODE_MAX)
-			return bkey_s_c_null;
+		if (iter->pos.inode == KEY_INODE_MAX) {
+			k = bkey_s_c_null;
+			goto out2;
+		}
 
 		bch2_btree_iter_set_pos(trans, iter, bpos_nosnap_successor(iter->pos));
 	}
@@ -2785,8 +2827,10 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_trans *trans, struct btre
 	}
 
 	struct btree_path *path = btree_iter_path(trans, iter);
-	if (unlikely(!btree_path_node(path, path->level)))
-		return bkey_s_c_null;
+	if (unlikely(!btree_path_node(path, path->level))) {
+		k = bkey_s_c_null;
+		goto out2;
+	}
 
 	btree_path_set_should_be_locked(trans, path);
 
@@ -2879,7 +2923,20 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_trans *trans, struct btre
 	bch2_btree_iter_verify(trans, iter);
 	ret = bch2_btree_iter_verify_ret(trans, iter, k);
 	if (unlikely(ret))
-		return bkey_s_c_err(ret);
+		k = bkey_s_c_err(ret);
+out2:
+	if (trace_btree_iter_peek_slot_enabled()) {
+		CLASS(printbuf, buf)();
+
+		int ret = bkey_err(k);
+		if (ret)
+			prt_str(&buf, bch2_err_str(ret));
+		else if (k.k)
+			bch2_bkey_val_to_text(&buf, trans->c, k);
+		else
+			prt_str(&buf, "(null)");
+		trace_btree_iter_peek_slot(trans->c, buf.buf);
+	}
 
 	return k;
 }
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 41efebdd06ef..e759c9ff3965 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1495,6 +1495,26 @@ DEFINE_EVENT(fs_str, extent_trim_atomic,
 	TP_ARGS(c, str)
 );
 
+DEFINE_EVENT(fs_str, btree_iter_peek_slot,
+	TP_PROTO(struct bch_fs *c, const char *str),
+	TP_ARGS(c, str)
+);
+
+DEFINE_EVENT(fs_str, __btree_iter_peek,
+	TP_PROTO(struct bch_fs *c, const char *str),
+	TP_ARGS(c, str)
+);
+
+DEFINE_EVENT(fs_str, btree_iter_peek_max,
+	TP_PROTO(struct bch_fs *c, const char *str),
+	TP_ARGS(c, str)
+);
+
+DEFINE_EVENT(fs_str, btree_iter_peek_prev_min,
+	TP_PROTO(struct bch_fs *c, const char *str),
+	TP_ARGS(c, str)
+);
+
 #ifdef CONFIG_BCACHEFS_PATH_TRACEPOINTS
 
 TRACE_EVENT(update_by_path,
-- 
2.50.0

