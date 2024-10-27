Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1A3370
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990317; cv=none; b=W/BdJuQuJ3zOz/7HviV1igXwULQicVIxFJzHDzGXhVeCAdd8ZLOWEiKgSauASdVYz1m1FG1QOVLs79Jz17yu52dI8gDPUMCqjHhmrHBZp40tMaHQ9XPr9UcpgHrVeP5HTz8vH/jXujfZwffPydfelWOtkapnq5mTot6sOwC8vEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990317; c=relaxed/simple;
	bh=0Nsgr59337XubzZj1WImiq4uMlvgFC9s07DZfCDOTz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WBM3wqDPlLtibOE7ngGASij/y+PXnrGazrt0xGrIBz1QH1QRa7MZ5HxStR8B+odigMFAHQ3z0m4h7yM3U41/4FJ4uRytgSPbU5WNipi4pDLk3RShz/bw0WB/7cwikeMAlzhJgZU1LaQb+BgzQRvLInweo2T1nVa9N+GnM4DmYho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FjceqBLY; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FjceqBLY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8mIZq5rJ1WdZYsts8AEYssEqX+uL4JG8tacetP9vUFU=;
	b=FjceqBLYLnGTBfTw5lUJsrhsShEz4sBViQnU5zJ9FfG8N808kG7kZhXx7mae67rXj8E06U
	YUQ7EuGNJTaUd3+2zRPJHb7O/PZFX7KbYRpuMWKeovTBI1ABEBT4HeE9ksLAdGJpgCB7AF
	HPFwaWN9Z2dUADZ3SKyyDG02AhAvIuA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/9] transaction restarts and other iterator work
Date: Sat, 26 Oct 2024 20:51:29 -0400
Message-ID: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

batch of various btree iterator patches

- transaction restart injection, asserts: there were some mishandled
  transaction restarts, now all fixed, and this is the debug code I used
  to find them.

  The tests now run with transaction restart injection on, so any new
  bugs will be quickly caught in the future.

- btree_iter_peek_prev() improvements: it now works with the journal
  keys overlay, which means we now should have the option of doing
  journal replay in the background should we ever need to,

  More importantly it now supports an "end of iteration range" argument;
  this is required for correctness in BTREE_ITER_filter_snapshots mode,
  otherwise we could keep going into the next inode, which might belong
  to a different snapshot tree, and we never find any keys that are
  visible that we can return.

  This fixes a bug in reconstruct_inode(), in fsck.

Kent Overstreet (9):
  bcachefs: Assert we're not in a restart in bch2_trans_put()
  bcachefs: Better in_restart error
  bcachefs: CONFIG_BCACHEFS_INJECT_TRANSACTION_RESTARTS
  bcachefs: Assert that we're not violating key cache coherency rules
  bcachefs: Rename btree_iter_peek_upto() -> btree_iter_peek_max()
  bcachefs: Simplify btree_iter_peek() filter_snapshots
  bcachefs: Kill unnecessary iter_rewind() in bkey_get_empty_slot()
  bcachefs: Implement bch2_btree_iter_prev_min()
  bcachefs: peek_prev_min(): Search forwards for extents, snapshots

 fs/bcachefs/Kconfig              |   7 +
 fs/bcachefs/alloc_background.c   |   6 +-
 fs/bcachefs/btree_gc.c           |   2 +-
 fs/bcachefs/btree_iter.c         | 459 ++++++++++++++++++++-----------
 fs/bcachefs/btree_iter.h         |  60 ++--
 fs/bcachefs/btree_journal_iter.c |  50 +++-
 fs/bcachefs/btree_journal_iter.h |   4 +-
 fs/bcachefs/btree_key_cache.c    |  13 +-
 fs/bcachefs/btree_trans_commit.c |   4 +
 fs/bcachefs/btree_types.h        |   6 +
 fs/bcachefs/btree_update.c       |  13 +-
 fs/bcachefs/dirent.c             |   4 +-
 fs/bcachefs/ec.c                 |   2 +-
 fs/bcachefs/errcode.h            |   1 -
 fs/bcachefs/extent_update.c      |   2 +-
 fs/bcachefs/fs-io-pagecache.c    |   2 +-
 fs/bcachefs/fs-io.c              |   8 +-
 fs/bcachefs/fs.c                 |   2 +-
 fs/bcachefs/fsck.c               |  12 +-
 fs/bcachefs/inode.c              |   6 +-
 fs/bcachefs/io_misc.c            |   8 +-
 fs/bcachefs/io_write.c           |   4 +-
 fs/bcachefs/movinggc.c           |   2 +-
 fs/bcachefs/reflink.c            |   2 +-
 fs/bcachefs/str_hash.h           |   6 +-
 fs/bcachefs/subvolume.h          |  12 +-
 fs/bcachefs/tests.c              |  26 +-
 fs/bcachefs/xattr.c              |   2 +-
 28 files changed, 482 insertions(+), 243 deletions(-)

-- 
2.45.2

