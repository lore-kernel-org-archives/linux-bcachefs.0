Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7423909C
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=GEDeNMPv55Fy110J84eY2ENOf0cfyvOBRfS2ssF2LpNt2H9OAlX3pwibmnHzOSz6p3Go8ObfnB8qWfJJqqs6T34HfZUO40YjilwnTJEd5hPJV+by6sHejdXlGeUt8YBWMI6965Lq6MXfdnaj48KZWH++pprLzqGhwMfUD7NzzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=trRBpX4ez0ulTl3WihV8BWVCQ+SwF1eKvVBi0G/k4sw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VcXJnho3AzPQ0GjRygc1feeH5JsAiu5mpoUumWqchDMqBabcc4T/PAQ8HvnHbtRyrq+ay78piICiRG57M6NAPhhld3gFefgFyvS8wfrnLvo/fbwiLisBX8Y6V7L68eBMteA4NB6IZ4nG94zUiolzhwup69kMaTp7jlUidmgBQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvjxRQjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvjxRQjc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A98DC4CEF8;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=trRBpX4ez0ulTl3WihV8BWVCQ+SwF1eKvVBi0G/k4sw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KvjxRQjcdNxOeIQZAZkbqh/L49d+iY8hG8MCM4Gz9bVd77TgWCDcJLcQMAZ3miLCx
	 q4zTyF/PONcvHvVepLNdUuI2wX3fRtaZ3h+qeknvGl4Oea0SfCiP/ju32Y2XKp2imU
	 NDdSl4nC603U+39IxCZZjI+FmWM4/frQWYh5r1IlRTW+5StCKRLxLaaPiM7V1q3DD9
	 COzbmPMLXmNRjAk11IOnBlDatF+dKXMP3OVwvjZDoYvQaLQLNM9c9uXOTG8HE6lg6e
	 XSPY2t9mAppQ5dVBQsotTxVjHBAGvdnzZL5Hd+RZc1DwwYByENVSlrapvlXvX0obtG
	 2UESmyDWJE7XA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F069CA1002;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:34 +0300
Subject: [PATCH v3 3/7] bcachefs: Relax restrictions on the number of
 accounting counters
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-3-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2585; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=JMDEcithTuURriAZkZpWhj4DluVxVEk4bXfsykzSmkQ=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPyx8+Dkpv6j3NskEso2ZDAxZN0Uf1G153Gmo8V2N
 Y97dzp/dZSyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJyO1mZHh77m3Zj8trHBaf
 Cfb5lbhj2/YncpdKM3QdjQX0QjJ4XD4xMtxNkJmdljNpLd+F0AqdAMu3sm1Lfu8qP2M/7V3Hj9+
 38tgA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Make adding/removing accounting counters easier when upgrading by
removing their exact number from bch_accounting key validity invariants.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/disk_accounting.c | 11 ++++++++---
 fs/bcachefs/disk_accounting.h |  4 ++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index f09e43f78f13fc424d9bf22d94566d4961c8ca8e..738678362c65df6de45ef685ddb97a7d1dbd2a08 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -239,10 +239,12 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 			 c, accounting_key_junk_at_end,
 			 "junk at end of accounting key");
 
-	bkey_fsck_err_on(bch2_accounting_counters(k.k) != bch2_accounting_type_nr_counters[acc_k.type],
+	const unsigned nr_counters = bch2_accounting_counters(k.k);
+
+	bkey_fsck_err_on(!nr_counters || nr_counters > BCH_ACCOUNTING_MAX_COUNTERS,
 			 c, accounting_key_nr_counters_wrong,
 			 "accounting key with %u counters, should be %u",
-			 bch2_accounting_counters(k.k), bch2_accounting_type_nr_counters[acc_k.type]);
+			 nr_counters, bch2_accounting_type_nr_counters[acc_k.type]);
 fsck_err:
 	return ret;
 }
@@ -359,10 +361,13 @@ static int __bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accoun
 			    accounting_pos_cmp, &a.k->p) < acc->k.nr)
 		return 0;
 
+	struct disk_accounting_pos acc_k;
+	bpos_to_disk_accounting_pos(&acc_k, a.k->p);
+
 	struct accounting_mem_entry n = {
 		.pos		= a.k->p,
 		.bversion	= a.k->bversion,
-		.nr_counters	= bch2_accounting_counters(a.k),
+		.nr_counters	= bch2_accounting_type_nr_counters[acc_k.type],
 		.v[0]		= __alloc_percpu_gfp(n.nr_counters * sizeof(u64),
 						     sizeof(u64), GFP_KERNEL),
 	};
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index c3f2dc5d0c14241f3c0ae2d367d6da504df2e1ab..c0d3d7e8fda6172eb04c8b0d9cd4cd879090e480 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -216,9 +216,9 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 
 	struct accounting_mem_entry *e = &acc->k.data[idx];
 
-	EBUG_ON(bch2_accounting_counters(a.k) != e->nr_counters);
+	const unsigned nr = min_t(unsigned, bch2_accounting_counters(a.k), e->nr_counters);
 
-	for (unsigned i = 0; i < bch2_accounting_counters(a.k); i++)
+	for (unsigned i = 0; i < nr; i++)
 		this_cpu_add(e->v[gc][i], a.v->d[i]);
 	return 0;
 }

-- 
2.50.1


