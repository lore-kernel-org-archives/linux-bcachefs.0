Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9913D8A0
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747933227; cv=none; b=S1gvtxCbeontpWk41eQXHEXn3YChgyYZK0SeKXW6/r47/lVfjhM8DhIR/xrzX4O8FzoLPJP1QNxQA7a1xO6h3XcsEKKcZbJQGkPOT9aBMFlMsUtEa2PZ35paHgzTTqNMYZNuA2q3RcRwVrL9dwb9IaLFV2OgYLtmuiEJNDM/xd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747933227; c=relaxed/simple;
	bh=di6lnctZ68CbdemR33SuOnK3IAPWYGRSZBaWZU+U9qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvAJTKdVpODBiNcriflvJnjQ1J8587qOQhgBzulZLpr8LXTKK0vjFgxCzHol2yz72PuEw1gNblwv4anBLfuzje4GNjhUcs5NgpsQDmiOQO3PPFW1t18yngg+JqFMiKKjePtl/S9RssZmcBYjkNVGXjJOQAVn6YffdIiXZYyFPMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rwfOC07c; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rwfOC07c"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747933224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPijSL2WisLPW5DPkG2EvWUbi5fqv6ZMUHX/vaHGFuQ=;
	b=rwfOC07cuCtpcUKNlpj8P4+GxlnXqreZSMUAOJPbaUITfkdEXPezv6DsyoW3tIbjcuafrc
	gjPPxxYFimlvq6zPxu8YBXIknopyoamlP1iINUtqxSj+C+JhnGTlfVT4SQtCWtw4qQeTBd
	cN3LinTZYa6o4VOtlBzNkW/uvSGgeMs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: bch2_trans_log_str()
Date: Thu, 22 May 2025 13:00:18 -0400
Message-ID: <20250522170019.2909181-2-kent.overstreet@linux.dev>
In-Reply-To: <20250522170019.2909181-1-kent.overstreet@linux.dev>
References: <20250522170019.2909181-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The data update path doesn't need a printbuf for its log message - this
will help reduce stack usage.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update.c | 26 ++++++++++++++++++--------
 fs/bcachefs/btree_update.h |  1 +
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index afd05c3dfd03..8fe2834f9d57 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -829,25 +829,35 @@ int bch2_btree_bit_mod_buffered(struct btree_trans *trans, enum btree_id btree,
 	return bch2_trans_update_buffered(trans, btree, &k);
 }
 
-int bch2_trans_log_msg(struct btree_trans *trans, struct printbuf *buf)
+static int __bch2_trans_log_str(struct btree_trans *trans, const char *str, unsigned len)
 {
-	unsigned u64s = DIV_ROUND_UP(buf->pos, sizeof(u64));
-
-	int ret = buf->allocation_failure ? -BCH_ERR_ENOMEM_trans_log_msg : 0;
-	if (ret)
-		return ret;
+	unsigned u64s = DIV_ROUND_UP(len, sizeof(u64));
 
 	struct jset_entry *e = bch2_trans_jset_entry_alloc(trans, jset_u64s(u64s));
-	ret = PTR_ERR_OR_ZERO(e);
+	int ret = PTR_ERR_OR_ZERO(e);
 	if (ret)
 		return ret;
 
 	struct jset_entry_log *l = container_of(e, struct jset_entry_log, entry);
 	journal_entry_init(e, BCH_JSET_ENTRY_log, 0, 1, u64s);
-	memcpy_and_pad(l->d, u64s * sizeof(u64), buf->buf, buf->pos, 0);
+	memcpy_and_pad(l->d, u64s * sizeof(u64), str, len, 0);
 	return 0;
 }
 
+int bch2_trans_log_str(struct btree_trans *trans, const char *str)
+{
+	return __bch2_trans_log_str(trans, str, strlen(str));
+}
+
+int bch2_trans_log_msg(struct btree_trans *trans, struct printbuf *buf)
+{
+	int ret = buf->allocation_failure ? -BCH_ERR_ENOMEM_trans_log_msg : 0;
+	if (ret)
+		return ret;
+
+	return __bch2_trans_log_str(trans, buf->buf, buf->pos);
+}
+
 int bch2_trans_log_bkey(struct btree_trans *trans, enum btree_id btree,
 			unsigned level, struct bkey_i *k)
 {
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index a54dc7277177..f907eaa8b185 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -205,6 +205,7 @@ void bch2_trans_commit_hook(struct btree_trans *,
 			    struct btree_trans_commit_hook *);
 int __bch2_trans_commit(struct btree_trans *, unsigned);
 
+int bch2_trans_log_str(struct btree_trans *, const char *);
 int bch2_trans_log_msg(struct btree_trans *, struct printbuf *);
 int bch2_trans_log_bkey(struct btree_trans *, enum btree_id, unsigned, struct bkey_i *);
 
-- 
2.49.0

