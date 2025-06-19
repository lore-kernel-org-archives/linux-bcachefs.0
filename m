Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D5B26FA58
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351051; cv=none; b=OnvBuvVxTDz+FIPmMQJwijb9xWgfFaxNux/QIGE91dIH1n65n4C60Ulz1b29zUsreHD/aoxfgP0FZuXjWh13dAq+RbJLl/+8cAe/DJtA0CGdaqh23lKyHDKQnJFxpCSZ3Ck8hI+PMKKzmCo/tlK/IQyGngwxYyD0vwcic0vklUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351051; c=relaxed/simple;
	bh=+vR22OKHKMjX9J7oKFb0bWllMp3I4hVZZ2CtattV+Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFXX/RjU2GxAeNYEohjk2RNnn0+7+xaWIqhhICCBt353XktHsl+0hvogSwWZcOkqMcdy9qFD+AI8r25ye9LHbJOG1Z2Q/E/PzDqABcLzJT+bgIHgucd9WAFd5lhAjNIV2axDKVgizm3VqtnGRVI8+T2cgOsMURQZJObi1sdfSHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T3JxWryJ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T3JxWryJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750351043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOnaTKoqHw3sNDa6mgKIPP3GwZVD9GEB0Cb4zmyVnKs=;
	b=T3JxWryJySKSR75YD5ySum2Wa0nO341Yg6TOF+jKfsiq7Ajc6uZ/SIFDkgEuLNE57CFVht
	PbK1QBURDgtY2sg1gm9SDQbMMlQ++HiuOMSwLbIe2fQ/uLQgZ1bYAacnQTbM+bfk2NOlFY
	gd4EIN1Idmq9Ksnm03+RuX8pe/jEPQk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: WARN() in bch2_trans_put() if we have pending updates
Date: Thu, 19 Jun 2025 12:37:14 -0400
Message-ID: <20250619163714.767851-3-kent.overstreet@linux.dev>
In-Reply-To: <20250619163714.767851-1-kent.overstreet@linux.dev>
References: <20250619163714.767851-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we exit from a btree transaction with uncommitted updates, that's
probably not what we intended to do.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c         | 2 ++
 fs/bcachefs/btree_trans_commit.c | 4 +---
 fs/bcachefs/btree_update.h       | 7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index bc3f38f7044c..7ce2ed4ac509 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3551,6 +3551,8 @@ void bch2_trans_put(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
 
+	WARN_ON(bch2_trans_has_updates(trans));
+
 	if (trans->restarted)
 		bch2_trans_in_restart_error(trans);
 
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 639ef75b3dbd..454b4c5c1808 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -1015,9 +1015,7 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 	if (unlikely(ret))
 		goto out_reset;
 
-	if (!trans->nr_updates &&
-	    !trans->journal_entries.u64s &&
-	    !trans->accounting.u64s)
+	if (!bch2_trans_has_updates(trans))
 		goto out_reset;
 
 	ret = bch2_trans_commit_run_triggers(trans);
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index e4b6e7d51a2e..54c71e3bad63 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -272,6 +272,13 @@ static inline int bch2_trans_commit(struct btree_trans *trans,
 	     (_i) < (_trans)->updates + (_trans)->nr_updates;		\
 	     (_i)++)
 
+static inline bool bch2_trans_has_updates(struct btree_trans *trans)
+{
+	return trans->nr_updates ||
+		trans->journal_entries.u64s ||
+		trans->accounting.u64s;
+}
+
 static inline void bch2_trans_reset_updates(struct btree_trans *trans)
 {
 	trans_for_each_update(trans, i)
-- 
2.50.0

