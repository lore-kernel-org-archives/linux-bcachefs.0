Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67307245B10
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472387; cv=none; b=sfGWIARoUdU5hV1OODN4T61HmAj1t+yUR/YVI88yIjjLrA8mAw/iVLh3XXbndwZ3/7K4zsNwSRqqf40vjDHiY40T7TIOo5uXiW+ljrY8XNzZbPbxd61R9qtkN58mZ/WwzKIy8p3YpqAjXaze/PL0eGlAUb2XjIlHA0QJtkXEKFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472387; c=relaxed/simple;
	bh=4xUbaIukKQw4U8Qkqt2gcUSnkS4XW+aMj/PW5Q2pB48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9JlSyp86HO6u1VG8GXQwgRkz28agvVGo/27p4xu2Rapr1ktW8aCKQ/8H7hfWoF2H4ydLjaF6BMGNSryiyxMXhh2TM/iw9cCiy2o3l6xOr/luUaPQV7+YRmf0UPjsM1sgnjHL2S5OA70eJ0y7Z2Z8WrYvugTPco0fc+VKEUEJxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gXWe05/N; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gXWe05/N"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zc3gr/WporDQjGCaBLOa+eFRVOC45VfOHPhP4gGoiyM=;
	b=gXWe05/N1We/IPWiNLnRofkrf5AeTEuzDLWsNBcaqM0EKIiC5ZRiYGF9DsLrUhuk4ust1E
	nfZvbFm+88ev3Qq0KSOeeh75oasT2Oj5CpbK8WY4AmfSCjL1cUWczQLmyI17Mqdc9BNgHx
	7HVOQa2OGJMXzKRLJSEaqfQg05tyO80=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/18] bcachefs: Advance bch_alloc.oldest_gen if no stale pointers
Date: Thu, 13 Feb 2025 13:45:55 -0500
Message-ID: <20250213184607.18237-11-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that we've got cached backpointers and aren't leaving around stale
pointers on bucket invalidation, we no longer need the periodic (rare)
gc_gens - which recalculates each bucket's oldest gen to avoid wraparound.

We can't delete that code because we've got to support existing
filesystems that will still have stale pointers, but this gets rid of
another scalability limit.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 97c2df18dfa4..c5c8497a6339 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -871,6 +871,9 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 		if (data_type_is_empty(new_a->data_type) &&
 		    BCH_ALLOC_V4_NEED_INC_GEN(new_a) &&
 		    !bch2_bucket_is_open_safe(c, new.k->p.inode, new.k->p.offset)) {
+			if (new_a->oldest_gen == new_a->gen &&
+			    !bch2_bucket_sectors_total(*new_a))
+				new_a->oldest_gen++;
 			new_a->gen++;
 			SET_BCH_ALLOC_V4_NEED_INC_GEN(new_a, false);
 			alloc_data_type_set(new_a, new_a->data_type);
-- 
2.45.2

