Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC6715AACA
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153011; cv=none; b=Ji8a+VH48lt8RoGfk9u790iwcnnW/bu5SHludgfQwoKmPTovgshTZE08orMqizGZNC2fEK6LWZdxsYivOAXO9F2Euz2hrTZrudHVNgEot8DoIrX5w3eXdq3MdqL1yS5qTGMKddXKsGd2QK1J5qlbDHjOqoMtp1MvEV5HBo/Q2SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153011; c=relaxed/simple;
	bh=kvXG40ak4Z/Z/z8NOkDQnILIkonzlj/QE8RgDa+F8iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooC4mI9Rg5txXka+ZxmldbPEhb17sBijv/F8VOKThrZNjt0HEoy4FWu/UVD8zd0c5T/cdAc5uSKE5fLHT1Wv8PwFMfzXBIm8RJ3/2zdjIMri54QWonfxQwSxpxHu6s7TBgWEQ/Ih/XIKeoHpqAFdEdKhzsknNQdW64+A7AxZMtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AV+C0NU3; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AV+C0NU3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0/gtJ/ihBL1xznnegDLC7AzP/kxQYXGJlQDOnKZoBI=;
	b=AV+C0NU3g4W1y7gejhQlAUb6ozmFjv3mw9ODW4Bo+qxSpRfGpoIdUyhcBWM/mmD/Lota5U
	aKSIbDeJjJr54Wm+L1DTTt1upH9LDAGVRTnYy4Igt11TcL0mB3nLteG7L8bFIVh7CnP6vf
	3T1Dir5G00WeqceHgxbauaPYSSzxAH8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/5] bcachefs: btree_iter_peek_upto() now handles BTREE_ITER_all_snapshots
Date: Sat,  5 Oct 2024 14:29:50 -0400
Message-ID: <20241005182955.1588763-4-kent.overstreet@linux.dev>
In-Reply-To: <20241005182955.1588763-1-kent.overstreet@linux.dev>
References: <20241005182955.1588763-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

end_pos now compares against snapshot ID when required

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index bfe9f0c1e1be..0883cf6e1a3e 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2381,9 +2381,9 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
 		else
 			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
 
-		if (unlikely(!(iter->flags & BTREE_ITER_is_extents)
-			     ? bkey_gt(iter_pos, end)
-			     : bkey_ge(iter_pos, end)))
+		if (unlikely(iter->flags & BTREE_ITER_all_snapshots	? bpos_gt(iter_pos, end) :
+			     iter->flags & BTREE_ITER_is_extents	? bkey_ge(iter_pos, end) :
+									  bkey_gt(iter_pos, end)))
 			goto end;
 
 		break;
-- 
2.45.2

