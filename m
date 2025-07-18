Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D71C5D53
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752863986; cv=none; b=PEsXL17c5hlPJXbAW3T3epYf2StUFmEinQ2RurPcoBCQsHwNpkzkpZJ0OxdhXlNNtOKdWndrB7EYgHenHBJDO5qLn+21LhZxarlduV+rytErvNjaL/wABR6CBPxWaHpyKovDu4yHid0RbV9m1JqGyy5lD4WPmbofnrfWblRXIEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752863986; c=relaxed/simple;
	bh=2VnncmH5aVFdhT+i1vfI//ppgpBOICA78IVIn5MUkgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L6FRBy/3YHSFvYPy+wFDxrR6XapwrbLyN/ZaOt4BLhMmZ9awutiJe/HfpV0gHJOfdLHGqHyETHLCa66na/3ezz8aMW0kUe6z6tNn9Oe/IFpjYj18j7Grst5cGyGjwldbVQji6y+fSyv+LDxTcXIGmmOPAl1sEpYXahl4D9xJ0mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lG6nmCeu; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lG6nmCeu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752863981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QqRI6mU/0tEkqV/Eub65kMbPbuwHZSmVZ4r3fNNjyLQ=;
	b=lG6nmCeuaHGnYszNOdASpZGqy101RzNBoGvMQEoQOijqrMer8VgbU0LqavzWzgM9Ddl904
	GRk9NFtCHyt662OMApw2dXIp3I5DeK1TwVPJAtBlN5QtMZgX7k8rSd+utUY+CUFRlC4UkR
	aKp3yy6h9Fb/gRKGEcEQeX+eJ40DJsA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: fix check_extent_overbig() call
Date: Fri, 18 Jul 2025 14:39:35 -0400
Message-ID: <20250718183935.556111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We can't access btree key values after a transaction commit.

Reported-by: syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index df0aa2522b18..183b88bbd402 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1975,6 +1975,10 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 		}
 	}
 
+	ret = check_extent_overbig(trans, iter, k);
+	if (ret)
+		goto err;
+
 	ret = bch2_trans_commit(trans, res, NULL, BCH_TRANS_COMMIT_no_enospc);
 	if (ret)
 		goto err;
@@ -2021,8 +2025,7 @@ int bch2_check_extents(struct bch_fs *c)
 				POS(BCACHEFS_ROOT_INO, 0),
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k, ({
 			bch2_disk_reservation_put(c, &res);
-			check_extent(trans, &iter, k, &w, &s, &extent_ends, &res) ?:
-			check_extent_overbig(trans, &iter, k);
+			check_extent(trans, &iter, k, &w, &s, &extent_ends, &res);
 		})) ?:
 		check_i_sectors_notnested(trans, &w);
 
-- 
2.50.0

