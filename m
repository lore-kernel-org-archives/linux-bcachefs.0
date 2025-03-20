Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F059374BED
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506270; cv=none; b=XbJVAoMmbifQ0iSx5dGcaQDgqDysYMU0907LUI74iKUBP0n7MxiLygfPRm++U3xahdTQFi/32L1OKelw7KCCe/nTQAyEx65jt9bppaeUpKHCeSyxL39PzhBWP8rL0QBCV6SPdLsbcBv1HuM821edxhYL35vFmGDNENEw9n6ejvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506270; c=relaxed/simple;
	bh=wbzfCtPQJBrDyz1SLI229LTxK+j8/rXwAYvNa+xglos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tniXkebSh9SRJVAlg+/X09ZdOU5dUnBVG/11dXZhmi2U8GL5FagBMGwcpeCAQMN0XqMDH6M/DDun+Pf9LI31uzXHJEMBXaVsfg45Hg5pGqhRiMozMj2xKmihJBjsxOvfU4BwQVvHKzYPBUrscIaYYt0hJoAPUVHF8/2UcXYUWh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=csvrIlNu; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="csvrIlNu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuQTtbGmSmod+4syTEpGtag8nnvZc9dZkhL5RXn441I=;
	b=csvrIlNuzDRiQnay1RoHuSLKSvXJ+LqxXgEHLh5qXpE6Kyu2O2sBTNhVFb3/+cceGrWmoE
	tsb0LN6ppasGtA0VK0oJeJSyjqLCPo1OrJ9vGNOeNEYvaff4r3W9gqChlR+YDPMdYY2A8z
	Gzyq4DBIxZWz5JFxtj9mutsFVwe66SA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+3a290f5ff67ca3023834@syzkaller.appspotmail.com
Subject: [PATCH 2/2] bcachefs: Handle backpointers with unknown data types
Date: Thu, 20 Mar 2025 17:30:56 -0400
Message-ID: <20250320213056.3359690-2-kent.overstreet@linux.dev>
In-Reply-To: <20250320213056.3359690-1-kent.overstreet@linux.dev>
References: <20250320213056.3359690-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

New data types might be added later, so we don't want to disallow
unknown data types - that'll be a compatibility hassle later. Instead,
ignore them.

Reported-by: syzbot+3a290f5ff67ca3023834@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 8da1b68821a0..20c497f0c2cb 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -784,7 +784,7 @@ enum alloc_sector_counter {
 	ALLOC_SECTORS_NR
 };
 
-static enum alloc_sector_counter data_type_to_alloc_counter(enum bch_data_type t)
+static int data_type_to_alloc_counter(enum bch_data_type t)
 {
 	switch (t) {
 	case BCH_DATA_btree:
@@ -796,7 +796,7 @@ static enum alloc_sector_counter data_type_to_alloc_counter(enum bch_data_type t
 	case BCH_DATA_parity:
 		return ALLOC_stripe;
 	default:
-		BUG();
+		return -1;
 	}
 }
 
@@ -847,7 +847,11 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 		if (bp.v->bucket_gen != a->gen)
 			continue;
 
-		sectors[data_type_to_alloc_counter(bp.v->data_type)] += bp.v->bucket_len;
+		int alloc_counter = data_type_to_alloc_counter(bp.v->data_type);
+		if (alloc_counter < 0)
+			continue;
+
+		sectors[alloc_counter] += bp.v->bucket_len;
 	};
 	bch2_trans_iter_exit(trans, &iter);
 	if (ret)
-- 
2.49.0

