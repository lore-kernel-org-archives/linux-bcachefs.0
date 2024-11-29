Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD31A3AAD
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912073; cv=none; b=qGImx6LPCvBsfBaDvqXZCd2ywocIoBAmdNytUjhpO+dTYO9NG91utpGS4RPdXkyMzkFAuDnUPI9korVMTbaYyoFboacFU8S7bCj9NBXkjUG/KEhBL9nUb3r8JqYUEa3c2E9CW1LwWeDGhMkAXmOCxmB7TZhxKCiXjXTDfoX8cfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912073; c=relaxed/simple;
	bh=KyAsbnKDnh4V9H3unkxC5Ru4647ifLCQwK86wxo7pwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nE0qGUxdFrTpTYaxmAkb/57beAcapcJejEyO0sqZeEFvO/hb5ucxf+IOOPqSvGTuxCKCx/TA//HrNLNaMx9ecrMEzgM59J7P8hhEx7MUuMLzvfBRC0km7BedW34V998XCI/TKQsncdmquwPEvkytzeMFxil7N3CiYJaToEBEEa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+1f202d4da221ec6ebf8e@syzkaller.appspotmail.com
Subject: [PATCH 07/34] bcachefs: Fix btree node scan when unknown btree IDs are present
Date: Fri, 29 Nov 2024 15:27:06 -0500
Message-ID: <20241129202736.2713679-8-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

btree_root entries for unknown btree IDs are created during recovery,
before reading those btree roots.

But btree_node_scan may find btree nodes with unknown btree IDs when we
haven't seen roots for those btrees.

Reported-by: syzbot+1f202d4da221ec6ebf8e@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_cache.c | 11 ++++++++---
 fs/bcachefs/btree_cache.h |  9 +++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 36dfa6a48aa6..1f06e24e53fc 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1406,9 +1406,14 @@ void bch2_btree_id_level_to_text(struct printbuf *out, enum btree_id btree, unsi
 void bch2_btree_pos_to_text(struct printbuf *out, struct bch_fs *c, const struct btree *b)
 {
 	bch2_btree_id_to_text(out, b->c.btree_id);
-	prt_printf(out, " level %u/%u\n  ",
-		   b->c.level,
-		   bch2_btree_id_root(c, b->c.btree_id)->level);
+	prt_printf(out, " level %u/", b->c.level);
+	struct btree_root *r = bch2_btree_id_root(c, b->c.btree_id);
+	if (r)
+		prt_printf(out, "%u", r->level);
+	else
+		prt_printf(out, "(unknown)");
+	prt_printf(out, "\n  ");
+
 	bch2_bkey_val_to_text(out, c, bkey_i_to_s_c(&b->key));
 }
 
diff --git a/fs/bcachefs/btree_cache.h b/fs/bcachefs/btree_cache.h
index 6cfacacb6769..dcc34fe4996d 100644
--- a/fs/bcachefs/btree_cache.h
+++ b/fs/bcachefs/btree_cache.h
@@ -128,14 +128,19 @@ static inline struct btree_root *bch2_btree_id_root(struct bch_fs *c, unsigned i
 	} else {
 		unsigned idx = id - BTREE_ID_NR;
 
-		EBUG_ON(idx >= c->btree_roots_extra.nr);
+		/* This can happen when we're called from btree_node_scan */
+		if (idx >= c->btree_roots_extra.nr)
+			return NULL;
+
 		return &c->btree_roots_extra.data[idx];
 	}
 }
 
 static inline struct btree *btree_node_root(struct bch_fs *c, struct btree *b)
 {
-	return bch2_btree_id_root(c, b->c.btree_id)->b;
+	struct btree_root *r = bch2_btree_id_root(c, b->c.btree_id);
+
+	return r ? r->b : NULL;
 }
 
 const char *bch2_btree_id_str(enum btree_id);	/* avoid */
-- 
2.45.2

