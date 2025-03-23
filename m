Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0236D51C
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 16:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742748282; cv=none; b=kqyWBWWuZs1KrzZOWPSQ2S8YrOKonYXxwTrVmafbUJ1gubmltbjOCnmEKcsfbYq0LZZZxbrcGamb2/V7nLZ1tlRaHa0EODW/4HNdtYoh5YxmN3R/e5x+TpLpOHwE/ep/4U9A6I/QFBU45Y0e0EbdgDUkBuJSNrIWMdubpUy54/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742748282; c=relaxed/simple;
	bh=p/haBVJ8IpRtmiwSWRowSWTHWreCUaBz/b8rJVV8/TU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kjDS+GP5rQ9mqiSzNH633+YhTNqV6Ac1mRFCk5ZcUIJjtzLpNLObE1sgwEqwwYswi1T4twY4IEJYwmwu9zRBzu33S3BWRNl3/6C0EC/nuuIGACDkMQ+lUsWe1Q1ZhW3W+cAi4dK758CLCwAtxmLrowC96mGrzpncPHrjFq9YgLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JN39KeZn; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JN39KeZn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742748276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0fvnVLq8FCBBFobbClwtZj06+bo/w44XLu4EpffBDNk=;
	b=JN39KeZnT7fmjUo4fGZJFlnDoU/3wutjTzZbTrXODoUOGVc88ReKU1Y+HZv7pKV5XhwalC
	PRZ/SkrUntnMWZF9mgdJZwqcjqm/uFgz52jFbpQmv3kY7crcqNR7ik/zFMmgPBa5UoT/Vc
	wZvujRXYrKPkWoyU7UVq1IiEuHXz3iU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: __bchfs_fallocate() now checks for pending signals
Date: Sun, 23 Mar 2025 12:44:32 -0400
Message-ID: <20250323164432.640979-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This can be an operation with very long latenc, if terabytes are
requested.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 717e7b94c66f..3dcb0a165401 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -626,6 +626,10 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 		u64 hole_start, hole_end;
 		u32 snapshot;
 
+		ret = unlikely(signal_pending(current)) ? -ERESTARTSYS : 0;
+		if (ret)
+			break;
+
 		bch2_trans_begin(trans);
 
 		if (bkey_ge(iter.pos, end_pos))
-- 
2.49.0

