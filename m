Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CED412E6A
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Feb 2024 02:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708828728; cv=none; b=EmyfnQWszZoX3jBjxyGzVBeNxLMuSqLg/jckf60ZAV7k39Z/dqsq5TbKFzbKbIs/n9jct9+CbATOOISqAZXZJ4HaH9WnukSZIumZTcnBwJfMhyHZQl9d8vDPGBGp+gBPdA8Ikih4GyIvgOBPjqhLNeIPlk2vooQzrY0D9lML91I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708828728; c=relaxed/simple;
	bh=DkSMbHGXD7jvgfcyN0h8VxzJwADDueaJ+dPGY9kVlEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmCkgsI+uOOFQThSN3hjB20YfJppfX/Gw8zGDVQ89te7cvzM2j8hsv0Q/mMMM6FZFLFe6gEs45DvZtCNZg272btDwnfy6xot1axIZDOA3EnIDoHLt6ChMxSJGor0kgfOVUZy69zgs5usEAk+qSowbUAbsckstwhgKKpHtUHp2Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iRFP2ifW; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iRFP2ifW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708828725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XxTvZ+w+R//l1/8+X2sA3MHcm6KcV5Vz+RJqp7UJC8=;
	b=iRFP2ifW2GoApeZJ1zZOyXzDJTb4hPXB2Bn1jIWeMOr8zpgWXdwf76Iuwyr4tE5SoWJgWj
	TBRmLrUg3wHfNe1Vd4J6EHDyAKHn7yD/44qN6d2rr0Ro2rh64NN4lRTfppGIturZovj2V5
	n0Fog7fhMrzvJqNAvbB89DYQBytzCcQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org,
	bfoster@redhat.com
Subject: [PATCH 12/21] bcachefs: Kill fs_usage_online
Date: Sat, 24 Feb 2024 21:38:14 -0500
Message-ID: <20240225023826.2413565-13-kent.overstreet@linux.dev>
In-Reply-To: <20240225023826.2413565-1-kent.overstreet@linux.dev>
References: <20240225023826.2413565-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

More dead code deletion.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/buckets.c       | 10 ----------
 fs/bcachefs/buckets.h       | 12 ------------
 fs/bcachefs/buckets_types.h |  5 -----
 3 files changed, 27 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index c261fa3a0273..5e2b9aa93241 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -37,16 +37,6 @@ static u64 reserve_factor(u64 r)
 	return r + (round_up(r, (1 << RESERVE_FACTOR)) >> RESERVE_FACTOR);
 }
 
-u64 bch2_fs_sectors_used(struct bch_fs *c, struct bch_fs_usage_online *fs_usage)
-{
-	return min(fs_usage->u.b.hidden +
-		   fs_usage->u.b.btree +
-		   fs_usage->u.b.data +
-		   reserve_factor(fs_usage->u.b.reserved +
-				  fs_usage->online_reserved),
-		   c->capacity);
-}
-
 static struct bch_fs_usage_short
 __bch2_fs_usage_read_short(struct bch_fs *c)
 {
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index ccf9813c65e7..f9d8d7b9fbd1 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -279,23 +279,11 @@ static inline unsigned fs_usage_u64s(struct bch_fs *c)
 	return __fs_usage_u64s(READ_ONCE(c->replicas.nr));
 }
 
-static inline unsigned __fs_usage_online_u64s(unsigned nr_replicas)
-{
-	return sizeof(struct bch_fs_usage_online) / sizeof(u64) + nr_replicas;
-}
-
-static inline unsigned fs_usage_online_u64s(struct bch_fs *c)
-{
-	return __fs_usage_online_u64s(READ_ONCE(c->replicas.nr));
-}
-
 static inline unsigned dev_usage_u64s(void)
 {
 	return sizeof(struct bch_dev_usage) / sizeof(u64);
 }
 
-u64 bch2_fs_sectors_used(struct bch_fs *, struct bch_fs_usage_online *);
-
 struct bch_fs_usage_short
 bch2_fs_usage_read_short(struct bch_fs *);
 
diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
index baa7e0924390..570acdf455bb 100644
--- a/fs/bcachefs/buckets_types.h
+++ b/fs/bcachefs/buckets_types.h
@@ -61,11 +61,6 @@ struct bch_fs_usage {
 	u64			replicas[];
 };
 
-struct bch_fs_usage_online {
-	u64			online_reserved;
-	struct bch_fs_usage	u;
-};
-
 struct bch_fs_usage_short {
 	u64			capacity;
 	u64			used;
-- 
2.43.0

