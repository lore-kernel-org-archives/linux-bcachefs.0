Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F109112C549
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 21:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728767237; cv=none; b=g2zTopeE28b/1F5FGS73dwGOJVTA4QO/89kbwxliWusSn33bLqkBWbghGp7d9s8EifYSfMcx+A9yB3xJl+eEFxeNhBXQ+56Gt38M2G0vlo8VdYRVRqKCZI72MOwkIQQU9CZnrDjcWCRmWeTTuLCcazwqjIjLGPP4fb/nurlxIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728767237; c=relaxed/simple;
	bh=gMPqwE1Mp3jKe6GstRPRklu67JvTDuIY1X1RheQ7iv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oh20vP6sIFRxT5MKgNj+vRxUWvrD6Pp2nKeYEXGS+A/i2FDfZ+3AQcrLIjDy8s+MH+fGOmnWxF+LgUoqDEJ53TW0Ck9WPm4N7T5Nokdsu+pEra78MvBkGgysDq+nzcMsKxDerEegq2u5kOg43GnhNpqKGUsGUBiaiJdLI6Emrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rcQLv03B; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rcQLv03B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728767231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FivJ6sdcgft3r0DZh18EdMg+kOdEdegextuJtnTaBGU=;
	b=rcQLv03Bm8+8khCWMAdpAXFLj+HiLq+SMv7Y61lu48adXZwM4UZWowF8TJ285rXUSumNDr
	PuutrKJ3ZGdLeLBl53SsS8SVfnLqvnDfHG+Fga0Mo3TiFo6H8/KDbHII/Yv4OHuE2pflqY
	Ab9QgDUZo6IvsO8B7LYTFTZoac3eEMI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+a1b59c8e1a3f022fd301@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix missing bounds checks in bch2_alloc_read()
Date: Sat, 12 Oct 2024 17:07:03 -0400
Message-ID: <20241012210703.3913506-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We were checking that the alloc key was for a valid device, but not a
valid bucket.

This is the upgrade path from versions prior to bcachefs being mainlined.

Reported-by: syzbot+a1b59c8e1a3f022fd301@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 4e4a448f6931..6e161f8ffe8d 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -639,6 +639,16 @@ int bch2_alloc_read(struct bch_fs *c)
 				continue;
 			}
 
+			if (k.k->p.offset < ca->mi.first_bucket) {
+				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode, ca->mi.first_bucket));
+				continue;
+			}
+
+			if (k.k->p.offset >= ca->mi.nbuckets) {
+				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode + 1, 0));
+				continue;
+			}
+
 			struct bch_alloc_v4 a;
 			*bucket_gen(ca, k.k->p.offset) = bch2_alloc_to_v4(k, &a)->gen;
 			0;
-- 
2.45.2

