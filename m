Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A5238DCE
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SNm9lrP9"
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bc])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393B23EB16
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:13 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3nocT2Emm0pv7XXIT6/q1QRXXUUv4YepPLAgSsG2JU=;
	b=SNm9lrP9ZtKIOUDvF1zH5Pa/Tst4t41Is09FBw4AHDeTJOuEQ7sigBRGkO1h6XMU2gmy6j
	9yuZLpSUstAmcQnAsTgMakBpzQjzaHs2bdi9OS+inHhWFvhVAvnHh/suTI51N2kmVVWvW8
	EQkhBTYrFOgtgNiOnjI6grC/Qu1L9vs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 14/17] bcachefs: bch2_btree_write_buffer_flush() -> bch2_btree_write_buffer_tryflush()
Date: Fri, 10 Nov 2023 11:31:51 -0500
Message-ID: <20231110163157.2736111-15-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

More accurate naming.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c   | 2 +-
 fs/bcachefs/btree_write_buffer.c | 2 +-
 fs/bcachefs/btree_write_buffer.h | 2 +-
 fs/bcachefs/ec.c                 | 2 +-
 fs/bcachefs/move.c               | 7 +++----
 fs/bcachefs/movinggc.c           | 4 ++--
 6 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 1fec0e67891f..e5e597be84bb 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1802,7 +1802,7 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 	unsigned i;
 	int ret = 0;
 
-	ret = bch2_btree_write_buffer_flush(trans);
+	ret = bch2_btree_write_buffer_tryflush(trans);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 4eced8b161bd..be8308789477 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -283,7 +283,7 @@ int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 	return ret;
 }
 
-int bch2_btree_write_buffer_flush(struct btree_trans *trans)
+int bch2_btree_write_buffer_tryflush(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
diff --git a/fs/bcachefs/btree_write_buffer.h b/fs/bcachefs/btree_write_buffer.h
index 3735bdcf11f7..89d290e306e2 100644
--- a/fs/bcachefs/btree_write_buffer.h
+++ b/fs/bcachefs/btree_write_buffer.h
@@ -4,7 +4,7 @@
 
 int bch2_btree_write_buffer_flush_locked(struct btree_trans *);
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *);
-int bch2_btree_write_buffer_flush(struct btree_trans *);
+int bch2_btree_write_buffer_tryflush(struct btree_trans *);
 
 int bch2_btree_insert_keys_write_buffer(struct btree_trans *);
 
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 2a77de18c004..423f2b04e0f3 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1005,7 +1005,7 @@ static int ec_stripe_update_extents(struct bch_fs *c, struct ec_stripe_buf *s)
 	unsigned i, nr_data = v->nr_blocks - v->nr_redundant;
 	int ret = 0;
 
-	ret = bch2_btree_write_buffer_flush(trans);
+	ret = bch2_btree_write_buffer_tryflush(trans);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index ab749bf2fcbc..581cf7e34147 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -721,11 +721,10 @@ int __bch2_evacuate_bucket(struct moving_context *ctxt,
 	bucket_size = bch_dev_bkey_exists(c, bucket.inode)->mi.bucket_size;
 	fragmentation = a->fragmentation_lru;
 
-	ret = bch2_btree_write_buffer_flush(trans);
-	if (ret) {
-		bch_err_msg(c, ret, "flushing btree write buffer");
+	ret = bch2_btree_write_buffer_tryflush(trans);
+	bch_err_msg(c, ret, "flushing btree write buffer");
+	if (ret)
 		goto err;
-	}
 
 	while (!(ret = bch2_move_ratelimit(ctxt))) {
 		bch2_trans_begin(trans);
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 0a0576326c5b..100525a38ee7 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -153,8 +153,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 
 	move_buckets_wait(ctxt, buckets_in_flight, false);
 
-	ret = bch2_btree_write_buffer_flush(trans);
-	if (bch2_fs_fatal_err_on(ret, c, "%s: error %s from bch2_btree_write_buffer_flush()",
+	ret = bch2_btree_write_buffer_tryflush(trans);
+	if (bch2_fs_fatal_err_on(ret, c, "%s: error %s from bch2_btree_write_buffer_tryflush()",
 				 __func__, bch2_err_str(ret)))
 		return ret;
 
-- 
2.42.0

