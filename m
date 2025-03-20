Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5730933E7
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506389; cv=none; b=OPgTKL+71w0iKqNkc+Dvz9aD+pfQlMOn/O+3DDz6NKNcTgFPNjlNOzvAaFf1cPx4LndcnAUYiyYQnvvpXzDNz5tMfJ3XQ4vqZbWq5aa6BCTvMf3ZLMeIsXA2SiSiZQBsJyB/jxbXA64lJVnqs6NiAsT+0ElDsR8C40kBijrQnwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506389; c=relaxed/simple;
	bh=arlzpadwSvfZx57bPawgUw2lOwNWMB1ZpWayPakY6iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8uWP5HsUeAHVFeEH7SeXyaAiVlxP4qG3zLqFnH9LrcF4A9hZmBXCy+iWs7VHxvLg45E7mV9/nBYz14MnC9RYdSS8+NEpT6wgtpw841QTJ6KzCTRBS5CQ6nJQO6RJvQKD9G5f48jchnEByefzJJJDdbulrYSvY3EIJq33yJqH4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c1Eu1ZYR; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c1Eu1ZYR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uva++HQ4UX37p8TFNyAB2b2+EaWzFc1hs8g6e37okSc=;
	b=c1Eu1ZYRpk2A8jWxEc+wu9XlmInlIdVB1DxGU+hGERt+r/wwxlUBSNB3DwFLwjaD6qXJv/
	DBpVlEbxhgr8tj/ts5zwotImYQB2ufT4Q9hbOCIxEeNgzAKcz/VWdgiHHrwKyCCt8ldxc1
	/ctqJVMZxxJZ6QKfToaU72S6lYpDbwk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/5] bcachefs: Fix a KMSAN splat in btree_update_nodes_written()
Date: Thu, 20 Mar 2025 17:32:52 -0400
Message-ID: <20250320213256.3359777-5-kent.overstreet@linux.dev>
In-Reply-To: <20250320213256.3359777-1-kent.overstreet@linux.dev>
References: <20250320213256.3359777-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We may sometimes read from uninitialized memory; we know, and that's ok.

We check if a btree node has been reused before waiting on any
outstanding IO.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update_interior.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index d3e0cf01ba37..67f1e3202835 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -649,6 +649,14 @@ static int btree_update_nodes_written_trans(struct btree_trans *trans,
 	return 0;
 }
 
+/* If the node has been reused, we might be reading uninitialized memory - that's fine: */
+static noinline __no_kmsan_checks bool btree_node_seq_matches(struct btree *b, __le64 seq)
+{
+	struct btree_node *b_data = READ_ONCE(b->data);
+
+	return (b_data ? b_data->keys.seq : 0) == seq;
+}
+
 static void btree_update_nodes_written(struct btree_update *as)
 {
 	struct bch_fs *c = as->c;
@@ -677,17 +685,9 @@ static void btree_update_nodes_written(struct btree_update *as)
 	 * on disk:
 	 */
 	for (i = 0; i < as->nr_old_nodes; i++) {
-		__le64 seq;
-
 		b = as->old_nodes[i];
 
-		bch2_trans_begin(trans);
-		btree_node_lock_nopath_nofail(trans, &b->c, SIX_LOCK_read);
-		seq = b->data ? b->data->keys.seq : 0;
-		six_unlock_read(&b->c.lock);
-		bch2_trans_unlock_long(trans);
-
-		if (seq == as->old_nodes_seq[i])
+		if (btree_node_seq_matches(b, as->old_nodes_seq[i]))
 			wait_on_bit_io(&b->flags, BTREE_NODE_write_in_flight_inner,
 				       TASK_UNINTERRUPTIBLE);
 	}
-- 
2.49.0

