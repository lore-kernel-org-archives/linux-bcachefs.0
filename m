Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D218192589
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355385; cv=none; b=WUrhfvvmYjtrNUgBtGO7+AQE1HgWSGj3aRcpFoqOIN/USgwaHKPKQ+CI0x7JoJCePXnb96gHR5nF5uEQtxN5vUbfHCIvmI30VZSwPFAzMUgjeb4MNJwNpHwuhEkH+d3cLkOE4galSGnAd3aazRsuOI6FvEDdheJhcrMvwDziut8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355385; c=relaxed/simple;
	bh=JjXVgfl4z2OzE6D7Il8Bs32DEv8QhkgN5BubGGf159s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G6r5FI3t6uah0aiyLQKZPHQGrPS+qhX2BROeeJ+u0r4t0QLHIky4VWIhrJgxWsSuZlqp/QFP+Op6lt9E+sH0ufppjU+Vg4y5sXCGcokT1pfehnCoxZV0htPgdY/pZpa9qfrBkukGE7eUwczdMsL4+jZPSjlT2GrtOC2gXgxumw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=asCGPA5Y; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="asCGPA5Y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3ji2IkkcmXjR0mZGki7gGaLPjSa8LMyofwipW+tIfP8=;
	b=asCGPA5YCSan70df+CMuf6QOaR+mHcaZgP82o6SYIC8ZqVorlv0/rmRtT/kG08es9ZQZHP
	/GK5+SCmE3LTBImWp5yolUJt7I00lxg0+cadZ1d3nsUvx7ML5ibiLe9xuBq9c1cw2u3HW8
	TMVbPL5iPnZV1IRqwsYVovk+ni6whZ0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/7] blk_holder_ops, freeze/thaw
Date: Fri,  7 Mar 2025 08:49:24 -0500
Message-ID: <20250307134933.1033872-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Until now, it turns out bcachefs has been lacking freeze/thaw support,
which is important for hibernate.

We thought we had freeze/thaw support, but it turns out that when
.freeze_fs and .unfreeze_fs were implemented in super_operations, they
were never being called - those functions are only called from the
blk_holder callbacks, and the engineer implementing them never thought
to check that.

So - there's a lesson here, and this is why I keep harping on testing.
It's not enough to just fire off the automated test suite and call it a
day, you do have to put actual thought into checking that your code is
behaving as expected :)

It turns out the method we were originally talking about for freeze/thaw
of just using our existing read-only/read-write paths doesn't work, for
reasons that I neglected to remember when hooking up blk_holder_ops
(locking and conflicting state management, I assume), so we need to
block IOs at a lower level - which conveniently we can do with our
existing per-device IO references.

This patchset also implements the other blk holder ops - the big one
being mark_dead, which now offlines a single device from the filesystem
if possible (leaving the filesystem read-write), or if not possible to
run in degraded mode, sets the entire filesystem read only.

Kent Overstreet (7):
  fs: export invalidate_inodes()
  bcachefs: Stash a pointer to the filesystem for blk_holder_ops
  bcachefs: Make sure c->vfs_sb is set before starting fs
  bcachefs: Implement blk_holder_ops
  bcachefs: Fix btree_node_scan io_ref handling
  bcachefs: bch2_dev_get_ioref() may now sleep
  bcachefs: Implement freeze/thaw

 fs/bcachefs/bcachefs.h        |   3 +
 fs/bcachefs/btree_node_scan.c |  17 ++-
 fs/bcachefs/fs.c              |  11 +-
 fs/bcachefs/journal_io.c      |   7 +-
 fs/bcachefs/sb-members.c      |  49 +++++++++
 fs/bcachefs/sb-members.h      |  18 +---
 fs/bcachefs/super-io.c        |   5 +-
 fs/bcachefs/super.c           | 191 +++++++++++++++++++++++++++++++++-
 fs/bcachefs/super.h           |   2 +
 fs/bcachefs/super_types.h     |   8 +-
 fs/inode.c                    |   1 +
 fs/internal.h                 |   1 -
 include/linux/fs.h            |   1 +
 13 files changed, 272 insertions(+), 42 deletions(-)

-- 
2.47.2

