Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1B11B9B50
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359813; cv=none; b=HucvXidDdqUcjKJvHqy+I4I6bhGzv5lUEWGQ/oqJGqIcl1K7c3AZ7zweYeleWZLHLs6WSiI2TpUwfYh2wZVp2c9rAQ2wqM1X+7dwSzvlUb4jysEaH318DXZH44frRV4M/Tz9/wT7P95pKhAXAMxRJ1Fo2ISK51xqfs0MNKHmdH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359813; c=relaxed/simple;
	bh=RxCfHVAoJtLJ3LAL4ukTXhKV5gS1K1PjQADAfwxT6N0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SjrTrA1o+XeyaxDAhVw4f2iJme2pFFGJTrlUDP3+85MaTzdyEtMytTPtwfySN+r1ZicI0p9m7w28cWr1JJwIwyevkKpOOsSvy/OAXC6a3WL5JRbClMEjwhorZMaQvht5bPR65g7Jg3IwckElVISCe6oviR6HNb5gKKP9IPRyqAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cbuyze4n; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cbuyze4n"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731359808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c0Vtmvh2m5pNm2gJqnyDfQRj5V05UkpxCW8j7bzEI60=;
	b=Cbuyze4nzTvI/hWjnkzvjaK9tE0wf9TLQlZQdF/rGchU+IEqE+eebsshiEhREOmnZZfOKx
	nZRW0/dozQ/8ueUvcl28ZlpRFnIwSH1MvZXw6avHjPgiW78e5JsD7aeb2H6CjYkhIXN/KK
	1rx2Q83GKqLDozKK6zaHL6PRgqZSFmQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+4f29c3f12f864d8a8d17@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix assertion pop in bch2_ptr_swab()
Date: Mon, 11 Nov 2024 16:16:40 -0500
Message-ID: <20241111211640.1437211-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This runs on extents that haven't yet been validated, so we don't want
to assert that we have a valid entry type.

Reported-by: syzbot+4f29c3f12f864d8a8d17@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 38cd9335df7d..98bb680b3860 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1409,7 +1409,7 @@ void bch2_ptr_swab(struct bkey_s k)
 	for (entry = ptrs.start;
 	     entry < ptrs.end;
 	     entry = extent_entry_next(entry)) {
-		switch (extent_entry_type(entry)) {
+		switch (__extent_entry_type(entry)) {
 		case BCH_EXTENT_ENTRY_ptr:
 			break;
 		case BCH_EXTENT_ENTRY_crc32:
@@ -1429,6 +1429,9 @@ void bch2_ptr_swab(struct bkey_s k)
 			break;
 		case BCH_EXTENT_ENTRY_rebalance:
 			break;
+		default:
+			/* Bad entry type: will be caught by validate() */
+			return;
 		}
 	}
 }
-- 
2.45.2

