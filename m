Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B11A3AA8
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912076; cv=none; b=aQVWMhgzznCy3adQ0vZnCsSOqudU6Nwk9FuV8z4hDnaFK7YgczZRjNC3VolnJYD8LRPV35BJqV+rTqOWXRF40k6Jdt1ZP0DLaY/KOTGPb6JHR9LgFjH+TrbGBQvxYXGUaI48vIr7LM9Iyqgoerk2gwDQWfh4Dswj4R1Vp5L5LxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912076; c=relaxed/simple;
	bh=TqNwuyWB4cq9yLO7FQLvOpvxas6i/L9DpUrwiPElnYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/yrUB+qfnPr3H+Nc5r0EP/qkAdYjH+neXXr5fHnoOQzEdX3Oa83ou+3+JiGBXdWWS8w6AnR3d6q6mqLNKLIVwbFeVQ6yaeKQ0hiBtw7WUQmKtUY+KW0AOSG8HGV03vu4FqT/pn8kYfX+58c+tihhOgTo8RBx69A8H2ZtkBGvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com
Subject: [PATCH 10/34] bcachefs: Fix dup/misordered check in btree node read
Date: Fri, 29 Nov 2024 15:27:09 -0500
Message-ID: <20241129202736.2713679-11-kent.overstreet@linux.dev>
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

We were checking for out of order keys, but not duplicate keys.

Reported-by: syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 89a42ee81e5c..2b5da566fbac 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -857,6 +857,14 @@ static bool bkey_packed_valid(struct bch_fs *c, struct btree *b,
 	return !__bch2_bkey_validate(c, u.s_c, btree_node_type(b), BCH_VALIDATE_silent);
 }
 
+static inline int btree_node_read_bkey_cmp(const struct btree *b,
+				const struct bkey_packed *l,
+				const struct bkey_packed *r)
+{
+	return bch2_bkey_cmp_packed(b, l, r)
+		?: (int) bkey_deleted(r) - (int) bkey_deleted(l);
+}
+
 static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 			 struct bset *i, int write,
 			 bool have_retry, bool *saw_error)
@@ -917,7 +925,7 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 				    BSET_BIG_ENDIAN(i), write,
 				    &b->format, k);
 
-		if (prev && bkey_iter_cmp(b, prev, k) > 0) {
+		if (prev && btree_node_read_bkey_cmp(b, prev, k) >= 0) {
 			struct bkey up = bkey_unpack_key(b, prev);
 
 			printbuf_reset(&buf);
-- 
2.45.2

