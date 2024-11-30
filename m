Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBE2AF06
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930114; cv=none; b=aL7cwPftiMOC5Z3Nz69xDMx/sCjrqc0SdjsIPCbGLObdCuOa1sXam9E2VaiQa+i9INdt100/iFfOyciQ6rYSoblZqBjCfFH7S+fYmMST12SJSXG8/WRpsXp2TFrW7OPylUGqKJseizV8uB4l4XC9/tUReQZCTl91ex46wEEfFic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930114; c=relaxed/simple;
	bh=reAZeu7txCp8WOgMQy8Frd6A6ccJvMAKjrexZTOUhIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIUa18IQcMi413no1Nzd/q6JENUvjIFB9C8Qgk9lAduitdDDtaHHodk0PeCWnbtqjP5VtI1a4Z8NXB3Ei3sdYEniCRtWojG8vWDnCVf2TN8BuchRmy9+JhE543cPST+ZTdySpHvu58OdwoMtKBIGbQMI3qFPmMHVA/xGnZkCnSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cV54e0uH; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cV54e0uH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oq8VRJc316Z/a2+yJcGQm51mN7fTuETMoW7fYM7G5gk=;
	b=cV54e0uH7qxI7qFKPfq91KDMpBH3xMA7TesjtYy61GbbnpTZngkfyEjg9Ey+GK0GhuEwb5
	xNptXpBwY4IYh7/sW9QyKF5mQ6d75IdiSdiuWajE0zTXBonO/MfWvarl3hbIe1YKDIabfv
	JR01eF8q5HJqBXzvjRWOeC+lRCS2K3I=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] bcachefs: If we did repair on a btree node, make sure we rewrite it
Date: Fri, 29 Nov 2024 20:28:09 -0500
Message-ID: <20241130012812.3135521-4-kent.overstreet@linux.dev>
In-Reply-To: <20241130012812.3135521-1-kent.overstreet@linux.dev>
References: <20241130012812.3135521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ensure that "invalid bkey" repair gets persisted, so that it doesn't
repeatedly spam the logs.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 228a8bd7a673..b99cbbd04a5c 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -997,6 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 got_good_key:
 		le16_add_cpu(&i->u64s, -next_good_key);
 		memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *) k);
+		set_btree_node_need_rewrite(b);
 	}
 fsck_err:
 	printbuf_exit(&buf);
@@ -1258,6 +1259,7 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 			memmove_u64s_down(k, bkey_p_next(k),
 					  (u64 *) vstruct_end(i) - (u64 *) k);
 			set_btree_bset_end(b, b->set);
+			set_btree_node_need_rewrite(b);
 			continue;
 		}
 		if (ret)
@@ -1371,15 +1373,18 @@ static void btree_node_read_work(struct work_struct *work)
 			       rb->start_time);
 	bio_put(&rb->bio);
 
-	if (saw_error &&
+	if ((saw_error ||
+	     btree_node_need_rewrite(b)) &&
 	    !btree_node_read_error(b) &&
 	    c->curr_recovery_pass != BCH_RECOVERY_PASS_scan_for_btree_nodes) {
-		printbuf_reset(&buf);
-		bch2_btree_id_level_to_text(&buf, b->c.btree_id, b->c.level);
-		prt_str(&buf, " ");
-		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
-		bch_err_ratelimited(c, "%s: rewriting btree node at due to error\n  %s",
-				    __func__, buf.buf);
+		if (saw_error) {
+			printbuf_reset(&buf);
+			bch2_btree_id_level_to_text(&buf, b->c.btree_id, b->c.level);
+			prt_str(&buf, " ");
+			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
+			bch_err_ratelimited(c, "%s: rewriting btree node at due to error\n  %s",
+					    __func__, buf.buf);
+		}
 
 		bch2_btree_node_rewrite_async(c, b);
 	}
-- 
2.45.2

