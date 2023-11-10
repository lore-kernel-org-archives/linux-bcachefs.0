Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B7C38DD6
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X/RU+YLs"
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8843EB13
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:12 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7CFar9D5MrlKsW1n8xd7hWJxjk39TZ+wr617lkAIHpU=;
	b=X/RU+YLsf+95/Oe8mnSWX0j56JPhJuTmOCOevoDyWmrSLVcskdAO+i4EPiBexzDLicjVch
	n8HEQ+GMFEB6nw1oT6ns/WHjMYlSrQCFcqqgiWXyVoFdW9NeEnWLklo8UjUXqKyRkeD8R+
	QT72uUYN4MaKt3z6Dgrk+hCZhfK3umg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 13/17] bcachefs: bch2_btree_write_buffer_flush_locked()
Date: Fri, 10 Nov 2023 11:31:50 -0500
Message-ID: <20231110163157.2736111-14-kent.overstreet@linux.dev>
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

Minor refactoring - improved naming, and move the responsibility for
flush_lock to the caller instead of having it be shared.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c |  6 ++++--
 fs/bcachefs/btree_write_buffer.c | 23 +++++++++++++----------
 fs/bcachefs/btree_write_buffer.h |  2 +-
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 929fe398f1db..722542316eb1 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -962,7 +962,8 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 
 			if (wb->state.nr > wb->size * 3 / 4) {
 				bch2_trans_begin(trans);
-				ret = __bch2_btree_write_buffer_flush(trans, true);
+				ret = bch2_btree_write_buffer_flush_locked(trans);
+				mutex_unlock(&wb->flush_lock);
 				if (!ret) {
 					trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
 					ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
@@ -1081,7 +1082,8 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		bch2_trans_begin(trans);
 		bch2_trans_unlock(trans);
 
-		ret = __bch2_btree_write_buffer_flush(trans, true);
+		ret = bch2_btree_write_buffer_flush_locked(trans);
+		mutex_unlock(&c->btree_write_buffer.flush_lock);
 		if (!ret) {
 			trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
 			ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 7f358a3d0789..4eced8b161bd 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -137,7 +137,7 @@ btree_write_buffered_insert(struct btree_trans *trans,
 	return ret;
 }
 
-int __bch2_btree_write_buffer_flush(struct btree_trans *trans, bool locked)
+int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
 	struct journal *j = &c->journal;
@@ -152,9 +152,6 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, bool locked)
 
 	memset(&pin, 0, sizeof(pin));
 
-	if (!locked && !mutex_trylock(&wb->flush_lock))
-		return 0;
-
 	bch2_journal_pin_copy(j, &pin, &wb->journal_pin,
 			      bch2_btree_write_buffer_journal_flush);
 	bch2_journal_pin_drop(j, &wb->journal_pin);
@@ -237,7 +234,6 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, bool locked)
 	bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret));
 out:
 	bch2_journal_pin_drop(j, &pin);
-	mutex_unlock(&wb->flush_lock);
 	return ret;
 slowpath:
 	trace_write_buffer_flush_slowpath(trans, i - keys, nr);
@@ -280,8 +276,9 @@ int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 		return -BCH_ERR_erofs_no_writes;
 
 	bch2_trans_unlock(trans);
-	mutex_lock(&trans->c->btree_write_buffer.flush_lock);
-	int ret = __bch2_btree_write_buffer_flush(trans, true);
+	mutex_lock(&c->btree_write_buffer.flush_lock);
+	int ret = bch2_btree_write_buffer_flush_locked(trans);
+	mutex_unlock(&c->btree_write_buffer.flush_lock);
 	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
 	return ret;
 }
@@ -289,11 +286,16 @@ int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 int bch2_btree_write_buffer_flush(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+	int ret = 0;
 
 	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
 		return -BCH_ERR_erofs_no_writes;
 
-	int ret = __bch2_btree_write_buffer_flush(trans, false);
+	if (mutex_trylock(&wb->flush_lock)) {
+		ret = bch2_btree_write_buffer_flush_locked(trans);
+		mutex_unlock(&wb->flush_lock);
+	}
 	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
 	return ret;
 }
@@ -305,9 +307,10 @@ static int bch2_btree_write_buffer_journal_flush(struct journal *j,
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
 
 	mutex_lock(&wb->flush_lock);
+	int ret = bch2_trans_run(c, bch2_btree_write_buffer_flush_locked(trans));
+	mutex_unlock(&wb->flush_lock);
 
-	return bch2_trans_run(c,
-			__bch2_btree_write_buffer_flush(trans, true));
+	return ret;
 }
 
 static inline u64 btree_write_buffer_ref(int idx)
diff --git a/fs/bcachefs/btree_write_buffer.h b/fs/bcachefs/btree_write_buffer.h
index 8639b4209544..3735bdcf11f7 100644
--- a/fs/bcachefs/btree_write_buffer.h
+++ b/fs/bcachefs/btree_write_buffer.h
@@ -2,7 +2,7 @@
 #ifndef _BCACHEFS_BTREE_WRITE_BUFFER_H
 #define _BCACHEFS_BTREE_WRITE_BUFFER_H
 
-int __bch2_btree_write_buffer_flush(struct btree_trans *, bool);
+int bch2_btree_write_buffer_flush_locked(struct btree_trans *);
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *);
 int bch2_btree_write_buffer_flush(struct btree_trans *);
 
-- 
2.42.0

