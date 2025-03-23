Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B38B3C6BA
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739297; cv=none; b=k+SCjtQQg0HHBsEIN3gKzsQ4C781p5B70clAybkeu7u5pWxvVn/i7GLTKA9V2NUBBaki96MQP1C5L614jiBMxqYBs1RsxFVntFYBsTK+vybPf/0u0SIfLZBZ/0koRpj9yOwxUG9GNOEcTJAnP21dNuLAWpMIltNRflDhPhibiiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739297; c=relaxed/simple;
	bh=mxql3Y/cZ3D4hjVUfbzfHMymj1qtu//MzrA7tRZHI1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+Go/WdGkgtZqB+I7HTgeO9ZUoXbjXbPvnqnv3guaB4wSaPpuLSHJgp4eO9nZfedMlgn0FNWht6B/AAz8Wcvfei6Npq4Fw18PcTVMWjinVwoqCTr42KkFmoQtL7nPNxDc4vtoUtlaqTUkheISSawwqt+DAddghWIV54Iruanqtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ismUa0nZ; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ismUa0nZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lza+PETFlcHj5abl56INCrprOxdgtRbrhp/PiBMETss=;
	b=ismUa0nZTCxKe5D/FzOrA78qTMqlAAmA5BP7vOnJfRk66CYCXX+YeiUCUcZMqESTaWFsjg
	t7AZ+0vrvy5K/HQEkggM0PmwxmyEXjZGtnZ3xqeOPH3kxVhHzb667zGP6v21NmKy3NUVxt
	+nPeqx7dWDBvDp4GTVZLZj64r4j3+eE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/8] bcachefs: do_trace_key_cache_fill()
Date: Sun, 23 Mar 2025 10:14:37 -0400
Message-ID: <20250323141445.566595-4-kent.overstreet@linux.dev>
In-Reply-To: <20250323141445.566595-1-kent.overstreet@linux.dev>
References: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reducing stack frame usage; this moves the printbuf out of the main
stack frame.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_key_cache.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index b6b64af826be..2b186584a291 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -287,6 +287,19 @@ static int btree_key_cache_create(struct btree_trans *trans,
 	return ret;
 }
 
+static noinline_for_stack void do_trace_key_cache_fill(struct btree_trans *trans,
+						       struct btree_path *ck_path,
+						       struct bkey_s_c k)
+{
+	struct printbuf buf = PRINTBUF;
+
+	bch2_bpos_to_text(&buf, ck_path->pos);
+	prt_char(&buf, ' ');
+	bch2_bkey_val_to_text(&buf, trans->c, k);
+	trace_key_cache_fill(trans, buf.buf);
+	printbuf_exit(&buf);
+}
+
 static noinline int btree_key_cache_fill(struct btree_trans *trans,
 					 struct btree_path *ck_path,
 					 unsigned flags)
@@ -320,15 +333,8 @@ static noinline int btree_key_cache_fill(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
-	if (trace_key_cache_fill_enabled()) {
-		struct printbuf buf = PRINTBUF;
-
-		bch2_bpos_to_text(&buf, ck_path->pos);
-		prt_char(&buf, ' ');
-		bch2_bkey_val_to_text(&buf, trans->c, k);
-		trace_key_cache_fill(trans, buf.buf);
-		printbuf_exit(&buf);
-	}
+	if (trace_key_cache_fill_enabled())
+		do_trace_key_cache_fill(trans, ck_path, k);
 out:
 	/* We're not likely to need this iterator again: */
 	bch2_set_btree_iter_dontneed(trans, &iter);
-- 
2.49.0

