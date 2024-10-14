Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72CA200A0
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728872414; cv=none; b=uIMduKd1WATrK8zCGdTjV7n6phhfuZsWZzsYo5O2IyVM7/xWSiDNzzzrK72s4WLlMjlhYkS53C+OwEVZtzEdSE2zyPTIZi/YYeRDEC0pWcxCThBAeZKri+XGqXsVthHD51aNzC3OOmXdCEmZj+h/MAMS8mLxSdEZWXDP+FPuoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728872414; c=relaxed/simple;
	bh=zbM9ykRYnW7JL25ms1vWQPnUkDmYbRh41FPAU7fPYIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sFUrP6rzz6N251Qe1ThAINUab1pdSOBsWiYj7/G/Dxrnb3UGgFkqUP1OGDgs+EvOTX0QPs6KoSA7y3sqoSWrgyFphEnxN1kZxsoYpsVeCJwKK7IygHXF/Dgi5JwjWi86aCX4S9abTBdKge7i5rPGIF0CzvJ9RQPrJU0zKGOU8eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PehwnhEs; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PehwnhEs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728872406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sQjN7ZzwYByw4pjbd15m1Z0FsS5st2MN2PL9RgsKKHk=;
	b=PehwnhEstr89XwLviufgW8Naw0b0BgT4ktbcAJzYXHDeLJVvKwO4QTYwzl2UCzJWdFfjk+
	IEqHoeKm3VVbsb7iDEinX50abjC2YOhHxKZGkDNmmvfswH2IcZpIehM4hGrSsMf5dCyA9H
	qWdDSScwvDLvJ7lRcgpe5p8A7tjpi3A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Fix kasan splat in new_stripe_alloc_buckets()
Date: Sun, 13 Oct 2024 22:19:56 -0400
Message-ID: <20241014021957.746617-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Update for BCH_SB_MEMBER_INVALID.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index b29838083f1f..668d013cc97f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1885,7 +1885,15 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans, struct ec_stripe_
 	bitmap_and(devs.d, devs.d, c->rw_devs[BCH_DATA_user].d, BCH_SB_MEMBERS_MAX);
 
 	for_each_set_bit(i, h->s->blocks_gotten, v->nr_blocks) {
-		__clear_bit(v->ptrs[i].dev, devs.d);
+		/*
+		 * Note: we don't yet repair invalid blocks (failed/removed
+		 * devices) when reusing stripes - we still need a codepath to
+		 * walk backpointers and update all extents that point to that
+		 * block when updating the stripe
+		 */
+		if (v->ptrs[i].dev != BCH_SB_MEMBER_INVALID)
+			__clear_bit(v->ptrs[i].dev, devs.d);
+
 		if (i < h->s->nr_data)
 			nr_have_data++;
 		else
-- 
2.45.2

