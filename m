Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B777C2E7BDF
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752861386; cv=none; b=WaGOb7v8sSSbsgoKz8CaxVxR0nnULNTGtWDVZ4ts3MjBorJN+1vWaShEWSxNiidBU5rrur5EMjaXo39DYyavibHDa3MS2PdiC0hfTdvLRvMSC0k6A+iaowWZg7haTrFM162EeKKQC9IlAg6Q7PpMwPU65FsFcUxV+y4BPs2H0Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752861386; c=relaxed/simple;
	bh=PRXvPDIg2rZ5YP4lxjd0jjH3TCLhXGFORlW1lTIMDow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rI1udDIna7+7K/s8hix5xn34MjBdLJRiZLKK4VJ6EMGiSY0GNXtZ2ujeOndS01NlAJ3jLB8ovc2uH/w83Ve5aK/TeInlId6cVzqHCv1wvkOzoF2XyqaSpMLZdGhvE2nbS8zs6nrNoYKFxEPItARaytRpXBePL08EK1fnIaPf4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u/dWVQ5O; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u/dWVQ5O"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752861381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X2TwKpRo0l1c5pX3ML9YVlhht1GtulqMD5EuHnImvBk=;
	b=u/dWVQ5OMGdbAP3UAqfMD+YEmfO8JSw6h/p3DBPIfzQrQzzJu6/e285JE0UyF7mSoObu7+
	gLQGAokzBQpXTXURny+YsL1uyyS1pdGVcpt34ahmB16kZ5/Xzgo7KrNOBWrEC+72D7FU3S
	iB09BYAJOy9CCSiHZ1BsHzlsQkdg1pA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+8eb51728519f6659ef7b@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix refs to undefined fields in __bch2_alloc_v4_to_text()
Date: Fri, 18 Jul 2025 13:56:16 -0400
Message-ID: <20250718175616.496553-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Recent stack usage reductions have avoided unpacking alloc keys onto the
stack in a few places, but when we do so we must be careful not to
reference fields that don't exist - key values can be extended with new
fields over time.

Reported-by: syzbot+8eb51728519f6659ef7b@syzkaller.appspotmail.com
Fixes: eabef52ff881 ("bcachefs: bch2_alloc_v4_to_text()")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 4c1604fd80f9..f1d35b7f3fc5 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -337,9 +337,10 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 }
 
 static inline void __bch2_alloc_v4_to_text(struct printbuf *out, struct bch_fs *c,
-					   unsigned dev, const struct bch_alloc_v4 *a)
+					   struct bkey_s_c k,
+					   const struct bch_alloc_v4 *a)
 {
-	struct bch_dev *ca = c ? bch2_dev_tryget_noerror(c, dev) : NULL;
+	struct bch_dev *ca = c ? bch2_dev_tryget_noerror(c, k.k->p.inode) : NULL;
 
 	prt_newline(out);
 	printbuf_indent_add(out, 2);
@@ -348,11 +349,14 @@ static inline void __bch2_alloc_v4_to_text(struct printbuf *out, struct bch_fs *
 	bch2_prt_data_type(out, a->data_type);
 	prt_newline(out);
 	prt_printf(out, "journal_seq_nonempty %llu\n",	a->journal_seq_nonempty);
-	prt_printf(out, "journal_seq_empty    %llu\n",	a->journal_seq_empty);
+	if (bkey_val_bytes(k.k) > offsetof(struct bch_alloc_v4, journal_seq_empty))
+		prt_printf(out, "journal_seq_empty    %llu\n",	a->journal_seq_empty);
+
 	prt_printf(out, "need_discard         %llu\n",	BCH_ALLOC_V4_NEED_DISCARD(a));
 	prt_printf(out, "need_inc_gen         %llu\n",	BCH_ALLOC_V4_NEED_INC_GEN(a));
 	prt_printf(out, "dirty_sectors        %u\n",	a->dirty_sectors);
-	prt_printf(out, "stripe_sectors       %u\n",	a->stripe_sectors);
+	if (bkey_val_bytes(k.k) > offsetof(struct bch_alloc_v4, stripe_sectors))
+		prt_printf(out, "stripe_sectors       %u\n",	a->stripe_sectors);
 	prt_printf(out, "cached_sectors       %u\n",	a->cached_sectors);
 	prt_printf(out, "stripe               %u\n",	a->stripe);
 	prt_printf(out, "stripe_redundancy    %u\n",	a->stripe_redundancy);
@@ -372,12 +376,12 @@ void bch2_alloc_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	struct bch_alloc_v4 _a;
 	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &_a);
 
-	__bch2_alloc_v4_to_text(out, c, k.k->p.inode, a);
+	__bch2_alloc_v4_to_text(out, c, k, a);
 }
 
 void bch2_alloc_v4_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
 {
-	__bch2_alloc_v4_to_text(out, c, k.k->p.inode, bkey_s_c_to_alloc_v4(k).v);
+	__bch2_alloc_v4_to_text(out, c, k, bkey_s_c_to_alloc_v4(k).v);
 }
 
 void __bch2_alloc_to_v4(struct bkey_s_c k, struct bch_alloc_v4 *out)
-- 
2.50.0

