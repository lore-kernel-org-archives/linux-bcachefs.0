Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097FA320F
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 03:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729913668; cv=none; b=nnR4/tnnGhdIQMoib8AX4CKudYdv7ts4TpWBHZEKTnERAgEcIcqjjLmhL028h/lAenrQ/s5/xpJMUjvMUbi1b7pSrE3HEB2HHau9vDD7GuljUz48z8j7ZJz/44W0bw4N8oPRdD2W8xoKC7nxK1YuLhnFueRuyn5Zfho3d2EqmJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729913668; c=relaxed/simple;
	bh=FjJrfvHvB7XwnmnTHJbU76jfQb3hQRxhxA/QFFbiudk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJcFV4nV10Rxn/3mNxN2SJMaSGVwiyuF6RRfR6vXyZ7zI5zk392NhEckv6jtn/TRFh1usOEJESv5FfvHUWx7/cf6LHB7sZqA/XdCWJQhwHmERNcAwlRFreKICMWGJJo7s8KA9uAVjCp5hewrha69CgvgBLGtanYeNuSmfefxTHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lailvjqd; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lailvjqd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729913653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ycROh7+0EEo+ldI+qdZj8wxIgi9WU452xhDOufYhy4I=;
	b=LailvjqdTUlBTaWsnyU1LQ0zRiqxP1ZQYBbvyXvsj8XsQL0orHaYAxG9RFwMJDWxoXG/dc
	Hp7ovR8IfJO40/65yAQVkUjYLzICf/T7rdigMYDa7yQ/3mqhbOeamSVo2GyLf3PjXVqX5n
	4j4tMfZSNOv60H/slzhdbuUW5b6Gekw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix unhandled transaction restart in fallocate
Date: Fri, 25 Oct 2024 23:34:04 -0400
Message-ID: <20241026033404.2207609-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This used to not matter, but now we're being more strict.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 15d3f073b824..8cfd17beb171 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -634,12 +634,15 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 			if (bch2_clamp_data_hole(&inode->v,
 						 &hole_start,
 						 &hole_end,
-						 opts.data_replicas, true))
+						 opts.data_replicas, true)) {
 				ret = drop_locks_do(trans,
 					(bch2_clamp_data_hole(&inode->v,
 							      &hole_start,
 							      &hole_end,
 							      opts.data_replicas, false), 0));
+				if (ret)
+					goto bkey_err;
+			}
 			bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, hole_start));
 
 			if (ret)
-- 
2.45.2

