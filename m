Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394272AD2F
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319086; cv=none; b=rf1QeEyW1o7rJR+YqO9tKY0xYhiYNjJHI5CBGOOntkpJjAxd++Yo1urIABkRSnUCjekSMu4eb0NcHyqBjRSC8F9idi/sbeP2F65vdmoTFlBqygvlPg30qCJIFHEQxThOGVO03Eyh7QukSxPKO/gZdL0XCbSwQuG6S1WcpcFyPvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319086; c=relaxed/simple;
	bh=YAfY1Nrejuaj4ChbLyxGtC5tinDpqw2ZKXDlULG/a80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AtWzodZSBFwXsMVrL1gdT3j+4h/K1lvWYrF3XbRX2+526OrdYgLdMCyOhvHVlVKiNXnSnh0i1gw/DZ9jwc5n3fMsKA0QOTsbqPxjzMcFIMDAN0ufVz5zOu87+0acqWPncclFVQu3S5cN0A7+aDQj2d1/S0Qy7IEOyzs6ywu2+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K8gD3GlJ; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K8gD3GlJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751319083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rXk4T04YrfbNIh1kvuTp5IB7kSGdb0CcvFtxGjGdfDw=;
	b=K8gD3GlJMz35qMy1QkqIp2ZJadhaEAfu39VSlLa1QX5aikFSTaVzRrKj4MDma8i8Twy2nm
	P0oXociIBNagkmZQxLaNW+OlGByRz04B05BnmrV/iSGHaYIk3bxEnicDBlDyB9E2cHe46g
	IzQogcHL1AV7IWj5ePfmw9YoGDwbr34=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: opts.journal_rewind_no_extents
Date: Mon, 30 Jun 2025 17:31:16 -0400
Message-ID: <20250630213118.2063622-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an option to skip rewinding extents when rewinding the journal.

If the only extents operatinos that have occurred are data move
operations, then this will give a higher probability of successful
recovery - until we implement the "buffer discards by a percentage of
device size" functionality.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_journal_iter.c | 17 ++++++++++++++---
 fs/bcachefs/opts.h               |  5 +++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index ea839560a136..341d31b3a1f1 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -717,6 +717,18 @@ static void __journal_keys_sort(struct journal_keys *keys)
 	keys->nr = dst - keys->data;
 }
 
+static bool should_rewind_entry(struct bch_fs *c, struct jset_entry *entry)
+{
+	if (entry->level)
+		return false;
+	if (btree_id_is_alloc(entry->btree_id))
+		return false;
+	if (c->opts.journal_rewind_no_extents &&
+	    entry->btree_id == BTREE_ID_extents)
+		return false;
+	return true;
+}
+
 int bch2_journal_keys_sort(struct bch_fs *c)
 {
 	struct genradix_iter iter;
@@ -735,9 +747,8 @@ int bch2_journal_keys_sort(struct bch_fs *c)
 		cond_resched();
 
 		vstruct_for_each(&i->j, entry) {
-			bool rewind = !entry->level &&
-				!btree_id_is_alloc(entry->btree_id) &&
-				le64_to_cpu(i->j.seq) >= rewind_seq;
+			bool rewind = le64_to_cpu(i->j.seq) >= rewind_seq &&
+				should_rewind_entry(c, entry);
 
 			if (entry->type != (rewind
 					    ? BCH_JSET_ENTRY_overwrite
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index b0a76bd6d6f5..9301f318c4d4 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -384,6 +384,11 @@ enum fsck_err_opts {
 	  OPT_UINT(0, U64_MAX),						\
 	  BCH2_NO_SB_OPT,		0,				\
 	  NULL,		"Rewind journal")				\
+	x(journal_rewind_no_extents,	bool,				\
+	  OPT_FS|OPT_MOUNT,						\
+	  OPT_BOOL(),							\
+	  BCH2_NO_SB_OPT,		0,				\
+	  NULL,		"Don't rewind extents when rewinding journal")	\
 	x(recovery_passes,		u64,				\
 	  OPT_FS|OPT_MOUNT,						\
 	  OPT_BITFIELD(bch2_recovery_passes),				\
-- 
2.50.0

