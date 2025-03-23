Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5BE2AE77
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739296; cv=none; b=iKRKUkwJGKtZhwOh70HLHJwcdcwRuDfiPA/sXDQubTzPvFF8t9yceH1uSyRGvS78kKo0ncNwZOgY2MPBuTxODox3Qa/GUPvN2KdFkUilfgHmxJrXoTajmumtgTOCFk7RWHIuJotFRPY1Ddudfg6Xv6m+JW3Fd9WLiJVE/qvYjwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739296; c=relaxed/simple;
	bh=znQKUQY6I5cQ5ELFfd5rIMPBvLZ00P5qOPgdM8I4ljE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LA4yJf8EV+FcUyxNv/aXqL/YniiskZxhh9fpafjSxJdF+aoQSFKPr0r+7xbYjukobAIBXKkgWsyZtiTG0emjfGfn0WNlzpLv3ooNq0X1g0JrcSWLkHCchVgboy3zoeSY68wy5VyzNMmaXe1IQMMHrAn23cBkTix86lV9OZeLJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uiDliMCE; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uiDliMCE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=paz9SdPE/Lq+v/04ArKFCmNnXNBkhpJo8FUUx9noM9o=;
	b=uiDliMCESHYoxErfO+tN5POAaGSNsflWu1oCq5UrkbNu6uEqR6ARCZUr+AY1kdcFf9pBls
	ulG/1SlLpigGYQO7GGwEP6MOAKuzDoziywAC0hfMwjiFpNd9OmWJ86dQwqrbxYIUDybKqy
	EGy3BN0TudywntyEmWkscgDm5600kig=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/8] bcachefs stack usage improvements
Date: Sun, 23 Mar 2025 10:14:34 -0400
Message-ID: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We overran the stack in a kmsan replication test.

Stack usage in non kmsan builds isn't critical; it appears that our
kmsan builds are particularly bad for stack usage because it inserts
additional function calls between each real function call, and we do
have some very deeply nested call stacks. The deepest I observed was:

- transaction commit
- btree split
- btree node allocation
- sector allocator, bucket allocator
- runtime alloc info fsck checks (we don't actually do repair inline,
  fortunately).
- btree_iter_peek_slot
- key cache traverse, fill
- btree_iter_peek_slot and pathwalk for normal btree lookup

This series is sufficient for now, and might go into 6.15 if I'm happy
with how the test dashboard looks. Later on I'll be moving more things
into alloc_request and moving it off the stack entirely, allocating it
with the btree_trans bump allocator.

Some items for btree node pathwalk might get moved into btree_trans as
well.

Kent Overstreet (8):
  bcachefs: Kill unnecessary bch2_dev_usage_read()
  bcachefs: Kill btree_iter.trans
  bcachefs: do_trace_key_cache_fill()
  bcachefs: bch2_alloc_to_v4() no longer converts on stack
  bcachefs: Move cycle detector state to btree_trans
  bcachefs: struct alloc_request
  bcachefs: alloc_request.data_type
  bcachefs: bch2_bucket_alloc_trans() takes alloc_request

 fs/bcachefs/acl.c                   |   4 +-
 fs/bcachefs/alloc_background.c      | 132 ++++++-----
 fs/bcachefs/alloc_background.h      |  23 +-
 fs/bcachefs/alloc_foreground.c      | 342 +++++++++++-----------------
 fs/bcachefs/alloc_foreground.h      |  25 +-
 fs/bcachefs/backpointers.c          |  12 +-
 fs/bcachefs/btree_gc.c              |   8 +-
 fs/bcachefs/btree_io.c              |   3 +-
 fs/bcachefs/btree_iter.c            | 184 +++++++--------
 fs/bcachefs/btree_iter.h            | 122 +++++-----
 fs/bcachefs/btree_key_cache.c       |  32 +--
 fs/bcachefs/btree_locking.c         |  43 +---
 fs/bcachefs/btree_locking_types.h   |  28 +++
 fs/bcachefs/btree_types.h           |   3 +-
 fs/bcachefs/btree_update.c          |  26 +--
 fs/bcachefs/btree_update_interior.c |  12 +-
 fs/bcachefs/btree_write_buffer.c    |  10 +-
 fs/bcachefs/buckets.c               |   2 +-
 fs/bcachefs/data_update.c           |   8 +-
 fs/bcachefs/dirent.c                |  16 +-
 fs/bcachefs/disk_accounting.c       |   4 +-
 fs/bcachefs/ec.c                    |  64 +++---
 fs/bcachefs/extent_update.c         |   6 +-
 fs/bcachefs/fs-io-buffered.c        |   6 +-
 fs/bcachefs/fs-io.c                 |  10 +-
 fs/bcachefs/fs.c                    |  22 +-
 fs/bcachefs/fsck.c                  |  30 +--
 fs/bcachefs/inode.c                 |  18 +-
 fs/bcachefs/io_misc.c               |  18 +-
 fs/bcachefs/io_read.c               |   8 +-
 fs/bcachefs/io_write.c              |  12 +-
 fs/bcachefs/io_write.h              |  28 ---
 fs/bcachefs/io_write_types.h        |  28 +++
 fs/bcachefs/lru.c                   |   9 +-
 fs/bcachefs/migrate.c               |   4 +-
 fs/bcachefs/move.c                  |  12 +-
 fs/bcachefs/movinggc.c              |   2 +-
 fs/bcachefs/namei.c                 |  38 ++--
 fs/bcachefs/quota.c                 |   2 +-
 fs/bcachefs/rebalance.c             |  12 +-
 fs/bcachefs/recovery.c              |   6 +-
 fs/bcachefs/reflink.c               |  23 +-
 fs/bcachefs/snapshot.c              |  10 +-
 fs/bcachefs/str_hash.c              |   2 +-
 fs/bcachefs/str_hash.h              |   8 +-
 fs/bcachefs/subvolume.c             |   4 +-
 fs/bcachefs/subvolume.h             |  14 +-
 fs/bcachefs/tests.c                 |  30 +--
 fs/bcachefs/xattr.c                 |   2 +-
 49 files changed, 736 insertions(+), 731 deletions(-)
 create mode 100644 fs/bcachefs/btree_locking_types.h

-- 
2.49.0

