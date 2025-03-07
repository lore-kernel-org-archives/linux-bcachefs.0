Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0534021ADBC
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355388; cv=none; b=EPj9Gu8G9mBO3r8PhGXAGThWghpOWQn9oj30h4NFdzqs/6ujRgnYyZrV4dZTaYiPx9J07zPxqlujVQH5dJmH7moTVs5SZxOAf1yfh3vPrVSl2DP/i9YQBQEOPzsgOHHDI1O5kqcNB3qkGizGOxqLIJIFLj9aX4E5eGS/DLDmdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355388; c=relaxed/simple;
	bh=0vfisFvZWc3TDxf4KIuWvz9VwUXntUOyx5Jk2l0flEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMQ3YQuJN+PTbyvMxMoCjrbGShM3I9HuKvaprODLj38Ve5qO7ORuJE6epSPttKuG1VGeF2VGMHkrdp2CosUBTbJ75PTQ4IWh1+akl8yz0JVTBcvh+1Mmgz4F3WMO1AuNO9lDNWL7tLhPiKWs9LnSCCIUGelh87VgnxzjLEQqK3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rwlOVxqD; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rwlOVxqD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ye5CJIiV8Oaaj1k0e6DO2I7TmbvLc9zR2A4Ic21USE=;
	b=rwlOVxqDV671pBOSsM93GOO29n2esNhmcXQc9hpku4/najYGui5glqSdppYp79fKF1mLGY
	q/vou2LPuDXesclL9G8On57PeuFJkKzaQKwkGbnIvfarSODaJlgUdGYuZCkvGvL0q1huBd
	jVhgH6HOWTBnjmLFnNotqSD/Sfgrq/U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/7] bcachefs: bch2_dev_get_ioref() may now sleep
Date: Fri,  7 Mar 2025 08:49:30 -0500
Message-ID: <20250307134933.1033872-7-kent.overstreet@linux.dev>
In-Reply-To: <20250307134933.1033872-1-kent.overstreet@linux.dev>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The next patch implementing freezing will change bch2_dev_get_ioref() to
sleep if a device is currently frozen.

Add an annotation and fix the journal code accordingly.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal_io.c | 5 ++++-
 fs/bcachefs/sb-members.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index c12d9f9bd536..a510755a8364 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1664,6 +1664,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 	}
 
 	bool completed = false;
+	bool do_discards = false;
 
 	for (seq = journal_last_unwritten_seq(j);
 	     seq <= journal_cur_seq(j);
@@ -1676,7 +1677,6 @@ static CLOSURE_CALLBACK(journal_write_done)
 			j->flushed_seq_ondisk = seq;
 			j->last_seq_ondisk = w->last_seq;
 
-			bch2_do_discards(c);
 			closure_wake_up(&c->freelist_wait);
 			bch2_reset_alloc_cursors(c);
 		}
@@ -1727,6 +1727,9 @@ static CLOSURE_CALLBACK(journal_write_done)
 	 */
 	bch2_journal_do_writes(j);
 	spin_unlock(&j->lock);
+
+	if (do_discards)
+		bch2_do_discards(c);
 }
 
 static void journal_write_endio(struct bio *bio)
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index b29b6c6c21dd..df91b02ce575 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -283,6 +283,8 @@ static inline struct bch_dev *bch2_dev_iterate(struct bch_fs *c, struct bch_dev
 
 static inline struct bch_dev *bch2_dev_get_ioref(struct bch_fs *c, unsigned dev, int rw)
 {
+	might_sleep();
+
 	rcu_read_lock();
 	struct bch_dev *ca = bch2_dev_rcu(c, dev);
 	if (ca && !percpu_ref_tryget(&ca->io_ref))
-- 
2.47.2

