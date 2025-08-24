Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751A4274658
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039103; cv=none; b=TH3NPahA6n/JGR7GzF9e0Rl4RqPxyeAI33FvQ5mWo7b/ogPjvSsMfAgCs3+uQ4miSwRVyOOtfOXowICv/okEvfb7UBGi00AUrOTjDVxr4pxBQHtVQLSAgMeDIIkgi5K4FsXJKKVQ022yTuR1vv9/cxX0zLeAYkvOV5dPrmjjn78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039103; c=relaxed/simple;
	bh=PQI9af9OTjIIwa4+7K2uEx/YtfyoXpTIK0H5Ac5VZA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK0OpdToKp5oqqcC4OQbtwIsku7Awd20laylfUfOB1+HHHXpbXY/TK0DztimIy2vYjmimisTIZhB/tRpdkDeaAPRAQEj9ndGVjiq7EU1IMcJKOxLRxjj3wvwx8QZF6X1W4Qa1K9tKG66v2m38Ubb8VoTr4I4tZOpAPfFsPZGP1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cj0/Fzfu; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cj0/Fzfu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HS0LPQVJ1VaaCpDms1AzF/YuW/oPzkwm0/WNVhV7maM=;
	b=cj0/FzfuZSLVwZvujmki9NH7k0fikDEyGn4FHZsg9zMuyWESMzACZIruDkwxRTmIC87kUM
	/nq3xWFHTgAmzcB/bprspXLRA4etqg90BQ5cTtaKwbgoGVE8aOrCXT+2eVf+A67twHd8Pk
	nDchI9qTEb/WhqCbpHb4vJgIf/8IAHw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 19/21] bcachefs: next_rebalance_extent() now handles replicas changes
Date: Sun, 24 Aug 2025 08:37:56 -0400
Message-ID: <20250824123800.1617669-20-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This obsoletes BCH_DATA_OP_drop_extra_replicas, BCH_DATA_OP_rereplicate.

(And the code is taken from drop_extra_replicas_pred() and
rereplicate_pred() in move.c).

Changes to the data_replicas setting will now automatically be applied
to existing data without any additional user action.

NOTE: we don't yet have a mechanism for guessing how much space an
option change will require (and reserving said space), until we have
that users will have to be careful not to run a filesystem out of free
space with an option change.

XXX: support metadata

XXX: BCH_DATA_OP_rereplicate additionally calls bch2_replicas_gc2():
this clears out stale replicas entries from the superblock (based on the
accounting btree), ensuring the "can we mount degraded without missing
data?" table is accurate.

We'll need to figure out a new place to plumb this.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 7ebd1c982810..29e12dbf3710 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -593,6 +593,48 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	data_opts->target		= opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_only_specified_devs;
 
+	if (r.need_rb & BIT(BCH_REBALANCE_data_replicas)) {
+		unsigned durability = bch2_bkey_durability(c, k);
+		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+		unsigned ptr_bit = 1;
+
+		guard(rcu)();
+		if (durability <= opts->data_replicas) {
+			bkey_for_each_ptr(ptrs, ptr) {
+				struct bch_dev *ca = bch2_dev_rcu_noerror(c, ptr->dev);
+				if (ca && !ptr->cached && !ca->mi.durability)
+					data_opts->kill_ptrs |= ptr_bit;
+				ptr_bit <<= 1;
+			}
+
+			data_opts->extra_replicas = opts->data_replicas - durability;
+		} else {
+			const union bch_extent_entry *entry;
+			struct extent_ptr_decoded p;
+
+			bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+				unsigned d = bch2_extent_ptr_durability(c, &p);
+
+				if (d && durability - d >= opts->data_replicas) {
+					data_opts->kill_ptrs |= ptr_bit;
+					durability -= d;
+				}
+
+				ptr_bit <<= 1;
+			}
+
+			ptr_bit = 1;
+			bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+				if (p.has_ec && durability - p.ec.redundancy >= opts->data_replicas) {
+					data_opts->kill_ec_ptrs |= ptr_bit;
+					durability -= p.ec.redundancy;
+				}
+
+				ptr_bit <<= 1;
+			}
+		}
+	}
+
 	if (!data_opts->rewrite_ptrs &&
 	    !data_opts->kill_ptrs &&
 	    !data_opts->kill_ec_ptrs &&
-- 
2.50.1

