Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48F4154C08
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673143; cv=none; b=XsboNjdNDmsxcRhSDFy78ziJEFLT0NmOwNiYW22BTx1ssMjoYrk2RjjpQveA1Of60XC2UYdRGoYeamWX1T67+p6GNg/nCYjgcKYMMa7size//aq5Zxxb2je86OuUDOmo709Oa2Z5xzvd8825fFJVr0QGCicyAH0fZ1qMBZLd6Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673143; c=relaxed/simple;
	bh=b+bUlIY4lIz9eXeJMuLWqgYQhRSOxCYClzFB+CJoTeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QWL8LMXIZuclUfZLOyStzTm85d1s+9DdNXvfeULNWtTNdp4wei+1g1FFN6Y1OyFVUL/T9pw+IoI//czMkKJZTShdRiRIuxX7Ao1MBTj5NObPJt1dq+ny6q2wic7QwwyNkNWHsBGueNNaCMyQ5umc2YmpzwqVClz98sleMPsHYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XEa1sjWE; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XEa1sjWE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ei81wNpUqN+uJBVVTv5NK9wUdy7HDLOLcJp4t+Wyt/A=;
	b=XEa1sjWETrH3pQU/MXvGDZ6elIlZSeqISfWxIyHGybh/Ajlz9YCEXYJzZ0WqisuDFaAIVI
	RLxbVHpQuohgoRzPhzZyT0x2wmSCxiS1Ebj4s2fzddwObmhE+nL8RoKqnNBSX/8xBF7qxI
	bLZA8YFQXdMFszLcesvW94N1CTFXCAg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] bcachefs hotfixes
Date: Sun,  3 Nov 2024 17:31:58 -0500
Message-ID: <20241103223205.176754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

couple hotfixes to be sent to Linus this week: mostly syzbot, but the
"topology errors on split after merge" was found by looping the
single_device small_nodes test

Kent Overstreet (5):
  bcachefs: Fix null ptr deref in bucket_gen_get()
  bcachefs: Fix error handling in bch2_btree_node_prefetch()
  bcachefs: Ancient versions with bad bkey_formats are no longer
    supported
  bcachefs: Fix topology errors on split after merge
  bcachefs: Ensure BCH_FS_may_go_rw is set before exiting recovery

 fs/bcachefs/bkey.c                  |  7 +++----
 fs/bcachefs/btree_cache.c           |  7 +++++--
 fs/bcachefs/btree_node_scan.c       |  2 +-
 fs/bcachefs/btree_update_interior.c | 17 ++++++++++++++---
 fs/bcachefs/buckets.h               | 19 +++++++++++--------
 fs/bcachefs/io_read.c               |  7 +++----
 fs/bcachefs/io_write.c              |  7 ++-----
 fs/bcachefs/recovery.c              |  7 +++++++
 fs/bcachefs/recovery_passes.c       |  6 ++++++
 9 files changed, 52 insertions(+), 27 deletions(-)

-- 
2.46.0

