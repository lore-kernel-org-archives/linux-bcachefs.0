Received: from mail-dl2-f42.google.com (mail-dl2-f42.google.com [74.125.229.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF748395AF0
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413447; cv=none; b=iCTjg4V0hU6Hd0tYZMffysB2UZnU0GgKGxNvraO/PDdTi0X4KDKB8XzzRkBpVnCAglbjrUqyf0Xom8YOAvY8zFDZ0HQYPqWta+IjVZix015enZVFTl6KC5X1H0Bca2rwdDZlzRIN7uYtddP9ys2DC+o1ggsMVgO7Ni8RhbL6NjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413447; c=relaxed/simple;
	bh=FJwaA2Tu4+HeVjd0ju+aWwG75wIfrPp63SI6Dsi/yVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6Y9+HijS/ucebDpG2NGypKXHFjjgPLbKoOQdfFJDDYuPCcsN4WwSK++6HcnmTxK2JRu+6PRPwoE8uLJ+MPLw1grhOewGljfBoeuGdvjZHeK2lFljsZizzwhcWXIuLRA//gKcixEB87PpZsXAVu164bXqwD3SkqqW3r4ibmhKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCD4hzxe; arc=none smtp.client-ip=74.125.229.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCD4hzxe"
Received: by mail-dl2-f42.google.com with SMTP id a92af1059eb24-144ee9debe9so1534033c88.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 02:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790413445; x=1791018245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4X+5bXxEmz+98THRWmaw5KORAEvBclAgH6y5t5s3VMQ=;
        b=GCD4hzxeTBsyInJYIE+O64HQ3WYJNm6MlCy8sDaVlBJdLMzKLnrvKD6FgiKKMT5/py
         BAwgXkytORdgqa/NJGaCA3Ke3GcTfPRElUazNlYnWrtsi1M/FhphVYMXBMQGUrfl55XC
         G9Ahz80ryAi37j3sNhOZ0y81EamZO3ZsZxwkLOb5j326seicaRrdvYRJL46/V3dLSity
         nH2Vxijwy59pC6KkdWv7WnTDbzbWwBkE7wBwPI4BOQ7W8nuwYiOaKlS23vgxFff/t69p
         uHJ40QYtp9oc3JVioeaHCNT/8Gr8cltNIDr0Hx4vdAepR7QqRvl/5MKGTlvW1rZErk0v
         JvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790413445; x=1791018245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4X+5bXxEmz+98THRWmaw5KORAEvBclAgH6y5t5s3VMQ=;
        b=K6yot3UJSOMJ9xsLFU2jk3Q7/+8hkXwUDAIiYqgvdpHCU2trKm3g1L+dgcNRhdkrtp
         SIhcn/x6wYjME2djcXu2vmogv1sJDzQclm36T07+jFkiupvvw9Qio7k1x/+RBolkLZkp
         VDCFL5HYDCTB3ZFqThWTA7H56sQn2wDafB51wsEj2vME8fThHZ025BCMENoeCXUPRXqc
         ctoCAlm+6DYAA3GiWj7C85SnGQYFWpZlxxv+bg6UsalM/3kHc67TZ/5xqP2qijihhfB6
         2A66dxx6IQ9mMqIwzkn4lJ1wASZVrhKPZylaVTmdQq77yJZs5XtbfPADMjKbt1jIhR0J
         1kDg==
X-Gm-Message-State: AFuF++mEOIJF/2bKb2mqgUr9qZMzeQTAXIZLDMdobiTnJIj5ohbfyHYz
	VurQfE1MkFMNhdgwL58p6urqgLVjhv/8kUXj7oESi84OQ5HzNlZbE+MQWq+npcK22Afdnv/+
X-Gm-Gg: AYBFou27McFttmn9Ixr36G2RJDsYfnfaUgvGJpRviicP/whzXXdNjv7P/i3gmNCUyzC
	I+sV/awHePPw7IeK5kMFVE9y1RPPNqRjE3bEGoEMkv924YSGElcZlOxEX0r+d61cHsjk3wwnevx
	Yu/w6Bu7sTuvpvqsDyMPs7Pv4TxuMtZdBKi4hp78jEbzJ8c8yDlAFfio1yMtNoDJcWEAMESd6NH
	XB744msY0Ta8Rq7A/NJQCsLl43T1IaO9NReTN3xWVqD4LAr1FOhUiYe637tzYewQfBLncgEqdBU
	l5CVqbMn+88SgNqKAwd5dn7z5avvz1ZDfMCTE+0/7gqfa0GtonGfxWPy/gDxcat0cjKH/EAhRUv
	UQpz1vuK7diwWdxCMZLdppB14V0P3cZh7yqBpREoapOB/kQoFSQH7xYiAybxFjWFuL8kNWKbm/v
	whSqK38KQjlXTxN4ufjMvj9yX3e2uYHnmfAqurcCuQA0r2Ieis5mBDcsw08cR4SIKdsDtaFxB0K
	mgHPbCmJlIAqM6CDNYYTa/UjeZyqDoIDWArbElC/yrXX7XjGVJzjWzIfwl9e537jDsMypopvOV/
	LB6l/digV235aLwIQKOOLn73OBjK2nX01roJyDBMZ79q5wckIYuWnCGPzJc=
X-Received: by 2002:a05:7022:7e85:b0:144:ff47:60d2 with SMTP id a92af1059eb24-146ce2a0697mr3086231c88.13.1790413444623;
        Sat, 26 Sep 2026 02:04:04 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145aa0cb7bcsm10004898c88.2.2026.09.26.02.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 02:04:03 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [RFC PATCH 1/1] bcachefs: make btree bitmap GC crash safe
Date: Sat, 26 Sep 2026 17:03:58 +0800
Message-ID: <20260926090358.603911-2-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926090358.603911-1-matthias.goergens@gmail.com>
References: <20260926090358.603911-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bitmap GC rebuilds the member bitmaps from the current in-memory btree
topology. An interior update can install new pointers before its new
nodes and parent update are durable, while the old nodes remain
reachable after a crash. Publishing the rebuilt bitmap in that window
drops coverage for the old nodes.

Drain pending interior updates before the scan. Take gc.lock for write
and recheck the pending list after the drain, so an update that starts
between the two steps makes the pass retry. Hold gc.lock across the scan
to stop new interior updates from changing the topology being walked.

Flush the journal after the scan and before publishing the bitmap. The
flush is outside gc.lock because journal reclaim can split btree nodes.
Check the journal error before changing the member bitmap.

The asynchronous recovery worker already holds a writes reference. Do
not take state_lock here: going read-only holds it for write while
waiting for those references to drain.

A dm-delay ktest held 71 evacuation-driven interior updates. On upstream
testing, bitmap GC published early and offline fsck rejected both the
held and post-pass crash images with 57 instances of reachable nodes
missing from the bitmap. With this change, bitmap GC waited and both
images passed fsck. Three further runs forced an update into the
drain/recheck gap; each retried once and then published once after the
held writes were released.

Fixes: 2de6594be103 ("bcachefs: bch2_btree_bitmap_gc()")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 fs/sb/members.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/sb/members.c b/fs/sb/members.c
index 271f4b788..2aa64bef8 100644
--- a/fs/sb/members.c
+++ b/fs/sb/members.c
@@ -7,8 +7,11 @@
 #include "alloc/replicas.h"
 
 #include "btree/cache.h"
+#include "btree/interior.h"
 #include "btree/iter.h"
 
+#include "journal/journal.h"
+
 #include "sb/members.h"
 #include "sb/io.h"
 
@@ -737,10 +740,8 @@ static int btree_bitmap_gc_btree_level(struct btree_trans *trans,
 	return 0;
 }
 
-int bch2_btree_bitmap_gc(struct bch_fs *c)
+static int btree_bitmap_gc_mark(struct bch_fs *c)
 {
-	bch2_progress_init(&c->recovery.progress, __func__, c, 0, ~0ULL);
-
 	scoped_guard(mutex_noio, &c->sb_lock) {
 		guard(rcu)();
 		for_each_member_device_rcu(c, ca, NULL)
@@ -764,6 +765,35 @@ int bch2_btree_bitmap_gc(struct bch_fs *c)
 		}
 	}
 
+	return 0;
+}
+
+static int btree_bitmap_gc_run(struct bch_fs *c, bool *retry)
+{
+	*retry = false;
+	{
+		guard(rwsem_write)(&c->gc.lock);
+		if (bch2_btree_interior_updates_pending(c)) {
+			*retry = true;
+			return 0;
+		}
+
+		/* No unwritten update may hide an old, still reachable node. */
+		try(btree_bitmap_gc_mark(c));
+	}
+
+	/*
+	 * The walk can observe committed pointer removals that are not yet
+	 * durable. Flush them before dropping their old bitmap coverage.
+	 *
+	 * Release gc.lock first: journal reclaim can need to split nodes.
+	 * Updates started after the walk retain their marked old nodes and
+	 * mark new nodes before committing the parent pointers.
+	 */
+	try(bch2_journal_flush(&c->journal));
+	/* A failed interior update may have left only the old topology durable. */
+	try(bch2_journal_error(&c->journal));
+
 	u64 sectors_marked_old = 0, sectors_marked_new = 0;
 
 	scoped_guard(mutex_noio, &c->sb_lock) {
@@ -790,6 +820,23 @@ int bch2_btree_bitmap_gc(struct bch_fs *c)
 	return 0;
 }
 
+int bch2_btree_bitmap_gc(struct bch_fs *c)
+{
+	lockdep_assert_held(&c->recovery.run_lock);
+	bch2_progress_init(&c->recovery.progress, __func__, c, 0, ~0ULL);
+
+	for (;;) {
+		/* Completion can split nodes, so wait without holding gc.lock. */
+		bch2_btree_interior_updates_flush(c);
+
+		bool retry;
+		int ret = btree_bitmap_gc_run(c, &retry);
+
+		if (!retry)
+			return ret;
+	}
+}
+
 static void bch2_maybe_schedule_btree_bitmap_gc_work(struct work_struct *work)
 {
 	struct bch_fs *c = container_of(work, struct bch_fs, maybe_schedule_btree_bitmap_gc.work);
