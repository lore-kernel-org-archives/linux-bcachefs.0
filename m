Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3473A23C4E7
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351046; cv=none; b=BHE8XLxmkbMx9bMfZHfHxIepnUljDgf9Ctc7wkQVoVEDzP/aK2+5FKbj6H+BI3eRKrP8jZ8PfCbCqteenfFzK49IJfmavmY0Gv3Kr/NdJ6DY/sQ8Lesq7yb2ji3t9aMSjHRCX87+/COG8wELbnnP7N6OuS2I572XJAmKcZ64ias=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351046; c=relaxed/simple;
	bh=XoM0Jj667tlVJSz2k+bUpFDXY4wAtYu5+SWKr/o4Y3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cNuPAAOSIPPSbA0M45TciWbEVUm6jLMrsyByom4cKyeibsyXWsnKfPr0SD7HgOleVJxzuE/71jC3/q85fMEQtWZE4bDfwh5NIoe2fjxNhkO0hkqIVO7LNgAiJbAnZBCKFtGCqSe80eSWom3Dro6m2012EOJ3AT9V7eYf8lmnWC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=irFiQLV6; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="irFiQLV6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750351040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BI92bftSbQfETQGT1GAIDHrMczr+a/hh4FyLhE1kOqc=;
	b=irFiQLV61I6RxxWgr+SczPhqCX5E8ntMWMtthXsc5udDnhQm1EhpMzGXLvHMFBcxCxjEjj
	BXzdyLc75SabIHqJgPruX5tOP4ycwMYJvtNomO0gG9eGWhE9HHB+jJESJIR/2BFAhBJgr+
	HTHu+K4Gg5pRBhnVS1LQf4O9KtFa678=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Plumb trans_kmalloc ip to trans_log_msg
Date: Thu, 19 Jun 2025 12:37:12 -0400
Message-ID: <20250619163714.767851-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_update.c | 15 ++++++++-------
 fs/bcachefs/btree_update.h | 26 ++++++++++++++++++++------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index e97e78c10f49..f7949dbe8f70 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -546,7 +546,7 @@ int bch2_btree_insert_clone_trans(struct btree_trans *trans,
 
 void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
 				struct btree_trans_subbuf *buf,
-				unsigned u64s)
+				unsigned u64s, ulong ip)
 {
 	unsigned new_top = buf->u64s + u64s;
 	unsigned old_size = buf->size;
@@ -554,7 +554,7 @@ void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
 	if (new_top > buf->size)
 		buf->size = roundup_pow_of_two(new_top);
 
-	void *n = bch2_trans_kmalloc_nomemzero(trans, buf->size * sizeof(u64));
+	void *n = bch2_trans_kmalloc_nomemzero_ip(trans, buf->size * sizeof(u64), ip);
 	if (IS_ERR(n))
 		return n;
 
@@ -807,11 +807,11 @@ int bch2_btree_bit_mod_buffered(struct btree_trans *trans, enum btree_id btree,
 	return bch2_trans_update_buffered(trans, btree, &k);
 }
 
-static int __bch2_trans_log_str(struct btree_trans *trans, const char *str, unsigned len)
+static int __bch2_trans_log_str(struct btree_trans *trans, const char *str, unsigned len, ulong ip)
 {
 	unsigned u64s = DIV_ROUND_UP(len, sizeof(u64));
 
-	struct jset_entry *e = bch2_trans_jset_entry_alloc(trans, jset_u64s(u64s));
+	struct jset_entry *e = bch2_trans_jset_entry_alloc_ip(trans, jset_u64s(u64s), ip);
 	int ret = PTR_ERR_OR_ZERO(e);
 	if (ret)
 		return ret;
@@ -824,7 +824,7 @@ static int __bch2_trans_log_str(struct btree_trans *trans, const char *str, unsi
 
 int bch2_trans_log_str(struct btree_trans *trans, const char *str)
 {
-	return __bch2_trans_log_str(trans, str, strlen(str));
+	return __bch2_trans_log_str(trans, str, strlen(str), _RET_IP_);
 }
 
 int bch2_trans_log_msg(struct btree_trans *trans, struct printbuf *buf)
@@ -833,13 +833,14 @@ int bch2_trans_log_msg(struct btree_trans *trans, struct printbuf *buf)
 	if (ret)
 		return ret;
 
-	return __bch2_trans_log_str(trans, buf->buf, buf->pos);
+	return __bch2_trans_log_str(trans, buf->buf, buf->pos, _RET_IP_);
 }
 
 int bch2_trans_log_bkey(struct btree_trans *trans, enum btree_id btree,
 			unsigned level, struct bkey_i *k)
 {
-	struct jset_entry *e = bch2_trans_jset_entry_alloc(trans, jset_u64s(k->k.u64s));
+	struct jset_entry *e = bch2_trans_jset_entry_alloc_ip(trans,
+						jset_u64s(k->k.u64s), _RET_IP_);
 	int ret = PTR_ERR_OR_ZERO(e);
 	if (ret)
 		return ret;
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index 9feef1dc4de5..e4b6e7d51a2e 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -137,21 +137,29 @@ static inline void *btree_trans_subbuf_top(struct btree_trans *trans,
 
 void *__bch2_trans_subbuf_alloc(struct btree_trans *,
 				struct btree_trans_subbuf *,
-				unsigned);
+				unsigned, ulong);
 
 static inline void *
-bch2_trans_subbuf_alloc(struct btree_trans *trans,
-			struct btree_trans_subbuf *buf,
-			unsigned u64s)
+bch2_trans_subbuf_alloc_ip(struct btree_trans *trans,
+			   struct btree_trans_subbuf *buf,
+			   unsigned u64s, ulong ip)
 {
 	if (buf->u64s + u64s > buf->size)
-		return __bch2_trans_subbuf_alloc(trans, buf, u64s);
+		return __bch2_trans_subbuf_alloc(trans, buf, u64s, ip);
 
 	void *p = btree_trans_subbuf_top(trans, buf);
 	buf->u64s += u64s;
 	return p;
 }
 
+static inline void *
+bch2_trans_subbuf_alloc(struct btree_trans *trans,
+			struct btree_trans_subbuf *buf,
+			unsigned u64s)
+{
+	return bch2_trans_subbuf_alloc_ip(trans, buf, u64s, _THIS_IP_);
+}
+
 static inline struct jset_entry *btree_trans_journal_entries_start(struct btree_trans *trans)
 {
 	return btree_trans_subbuf_base(trans, &trans->journal_entries);
@@ -162,10 +170,16 @@ static inline struct jset_entry *btree_trans_journal_entries_top(struct btree_tr
 	return btree_trans_subbuf_top(trans, &trans->journal_entries);
 }
 
+static inline struct jset_entry *
+bch2_trans_jset_entry_alloc_ip(struct btree_trans *trans, unsigned u64s, ulong ip)
+{
+	return bch2_trans_subbuf_alloc_ip(trans, &trans->journal_entries, u64s, ip);
+}
+
 static inline struct jset_entry *
 bch2_trans_jset_entry_alloc(struct btree_trans *trans, unsigned u64s)
 {
-	return bch2_trans_subbuf_alloc(trans, &trans->journal_entries, u64s);
+	return bch2_trans_jset_entry_alloc_ip(trans, u64s, _THIS_IP_);
 }
 
 int bch2_btree_insert_clone_trans(struct btree_trans *, enum btree_id, struct bkey_i *);
-- 
2.50.0

