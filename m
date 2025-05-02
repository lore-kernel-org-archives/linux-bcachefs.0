Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C9D20F09B
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216024; cv=none; b=CXzGj8iKymIK17WZrcnv98vIzJkAOUEmBPnHiVUJN9mPNtthSbm9TDoSYzvmpp/upwu/V+T5id7v283Gsm1o0pZkQMG8mFgl352D42ceKuvasSIXWV1uxwqLxCxdzx6cmC13BckT/n7Z9JVAuTfoc3J9f8wJIr0x4LN59ZvaOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216024; c=relaxed/simple;
	bh=I9SwFbrtRWKX2ZsYdPFL+nf7nKWVBpP+JglUGQIeJM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ClTkxwdvDoUdskxX0wgnnrgqkU2xivNmX7TjWqE0JV5Spjvego1P9Tu1RG15Y9rRHCmwobmKYRG8A/Lhb4R4o93T3InXW+mLcfG7wW5TzUjswuOTJ525jDQLSAUSw4Kdovdcd/NQ9LiQzaXq19PboS8A65ennYQRLtGzfsXPDpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oe6MWpQK; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oe6MWpQK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XoEtgqo5bU+LrFpL4T5N4OMBk97KHcDuit0Dt9DEnrY=;
	b=oe6MWpQKR4W4ZUf/4brbnpE8ePQ6lglCrkAXBjjq0ouJAdpfjlgfk/XHTn8PGfdVLBGqom
	A4OG5oUhki+WIvVXKjXA8jSeGvJ/FlyFbGjdXaTBlyelIuASZmA0ukaNreztrq5MWa7uaK
	9IX6Pj7XQW1tVa4PKbPSHj8TID06rTk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/8] Snapshot deletion improvements
Date: Fri,  2 May 2025 15:59:52 -0400
Message-ID: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Snapshot deletion performance has been reported to be an issue, so this
patch series should address that.

The important optimization relies on the fact that if an
extent/dirent/xattr exists, a version of that inode must exist in that
specific snapshot. We can make use of that to avoid a lot of scanning.

Previously only fsck relied on this, so it would spit out a warning and
correct the issue in its in memory data structures if this occurred.
Now, it's turned into a proper fsck_err() with on-disk repair if
detected.

We also want some additional safety with this: if snapshot deletion ever
screws up and doesn't delete all the keys it was supposed to, we want to
be able to automatically repair.

So there's a new on disk format version with an incompatible (i.e. must
be expliticly enabled) feature, where we never delete snapshot keys - we
just mark them as deleted.

This allows fsck to differentiate between "key for deleted snapshot, I
know how to repair this" vs. "key for missing snapshot, we're not sure
what happened and someone should probably take a look".

And snapshot deletion status is now present in sysfs, currently with
btree and position in that btree. We do have per-snapshot-id accounting,
so it might be possible to turn that into a proper progress indicator
later.

Kent Overstreet (8):
  bcachefs: snapshot delete progress indicator
  bcachefs: Add comments for inode snapshot requirements
  bcachefs: kill inode_walker_entry.snapshot
  bcachefs: BCH_FSCK_ERR_snapshot_key_missing_inode_snapshot
  bcachefs: Skip unrelated snapshot trees in snapshot deletion
  bcachefs: BCH_SNAPSHOT_DELETED -> BCH_SNAPSHOT_WILL_DELETE
  bcachefs: bcachefs_metadata_version_snapshot_deletion_v2
  bcachefs: delete_dead_snapshot_keys_v2()

 fs/bcachefs/bcachefs.h         |   3 +-
 fs/bcachefs/bcachefs_format.h  |   3 +-
 fs/bcachefs/fsck.c             |  78 ++++---
 fs/bcachefs/io_write.c         |   6 +
 fs/bcachefs/sb-errors_format.h |   4 +-
 fs/bcachefs/snapshot.c         | 389 +++++++++++++++++++++++++--------
 fs/bcachefs/snapshot.h         |  32 ++-
 fs/bcachefs/snapshot_format.h  |   4 +-
 fs/bcachefs/snapshot_types.h   |  56 +++++
 fs/bcachefs/subvolume.c        |   2 -
 fs/bcachefs/subvolume.h        |   3 -
 fs/bcachefs/subvolume_types.h  |  27 ---
 fs/bcachefs/super.c            |   1 +
 fs/bcachefs/sysfs.c            |   5 +
 fs/bcachefs/xattr.c            |   5 +
 15 files changed, 445 insertions(+), 173 deletions(-)
 create mode 100644 fs/bcachefs/snapshot_types.h

-- 
2.49.0

