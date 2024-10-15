Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F8C14F12F
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Oct 2024 01:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728955688; cv=none; b=ex9SKTeU/RorvY5v5fl5AqYk5usm3xbUYJNCQXBxnGR5rouZ/hV1M5aDDLNXnfjfChM63NqzWY5A//ri68yOOt1FZ/f5fevOifmVa44wWNV+B/1A5He1FyhAHUkN/sjc0dZPyVNQWbvMrQp9PRe2C1/d+GpIcOOSKjGKd5pUxqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728955688; c=relaxed/simple;
	bh=gS0yxpQN86jLAWvfeaNTzay/a4WG+ypSZ9NOBXk/+n4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hhMqwhT0fZK/vpC0PFRCgVYaCx0KyQekCk/KV/MpA0iws6kxLqji9K7of1BK+O7woP1fRlwMib18MCJDVl5ppxYFZ26HfjxurX4663jIJqVqv3CtSWGBPGRVIbZqWCdOQp7bPdCVOFkdK6b2M2mpue5lGSrbq5HR5Qkx6ZbZfmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PMW2WQcC; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PMW2WQcC"
Date: Mon, 14 Oct 2024 21:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728955677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EBKI0jhPyCaBxpT3oWhn2T9UWRj8G6nH6l3Lm03f80A=;
	b=PMW2WQcCGq9D7z5wsVzgbyMkEULuGdNp9Z842hnrWFvOhxt1uHtMS0OtcCk589Q1NFxD+q
	anrTGChpKmbhG1dZHzGoVjWCMR28+yedykBqGWLsrg0Mpfv2aeVAz1g1lFL/xFWKLEq8wl
	VrQAF5NSdHhvUALMkK16DtS40eUuTRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.12-rc4
Message-ID: <lazo4f4eueknrlk5odp37fboznvfxnizhdeqttnmxkbgp7szjj@m3sjqp7mxm5d>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit 0f25eb4b60771f08fbcca878a8f7f88086d0c885:

  bcachefs: Rework logged op error handling (2024-10-04 20:25:32 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-10-14

for you to fetch changes up to 5e3b72324d32629fa013f86657308f3dbc1115e1:

  bcachefs: Fix sysfs warning in fstests generic/730,731 (2024-10-14 05:43:01 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.12-rc4

- New metadata version inode_has_child_snapshots
  This fixes bugs with handling of unlinked inodes + snapshots, in
  particular when an inode is reattached after taking a snapshot;
  deleted inodes now get correctly cleaned up across snapshots.

- Disk accounting rewrite fixes
  - validation fixes for when a device has been removed
  - fix journal replay failing with "journal_reclaim_would_deadlock"

- Some more small fixes for erasure coding + device removal

- Assorted small syzbot fixes

----------------------------------------------------------------
Alan Huang (2):
      bcachefs: Release transaction before wake up
      bcachefs: Fix state lock involved deadlock

Kent Overstreet (23):
      bcachefs: Fix lockdep splat in bch2_accounting_read
      bcachefs: Split out check_unreachable_inodes() pass
      bcachefs: reattach_inode() now correctly handles interior snapshot nodes
      bcachefs: btree_iter_peek_upto() now handles BTREE_ITER_all_snapshots
      bcachefs: Delete vestigal check_inode() checks
      bcachefs: bcachefs_metadata_version_inode_has_child_snapshots
      bcachefs: Kill bch2_propagate_key_to_snapshot_leaves()
      bcachefs: bch2_inode_or_descendents_is_open()
      bcachefs: Disk accounting device validation fixes
      closures: Add closure_wait_event_timeout()
      bcachefs: Check if stuck in journal_res_get()
      bcachefs: __wait_for_freeing_inode: Switch to wait_bit_queue_entry
      bcachefs: Fix bch2_have_enough_devs() for BCH_SB_MEMBER_INVALID
      bcachefs: Fix invalid shift in member_to_text()
      bcachefs: Fix accounting replay flags
      bcachefs: Fix bkey_nocow_lock()
      bcachefs: Improve check_snapshot_exists()
      bcachefs: fix uaf in bch2_dio_write_done()
      bcachefs: Fix missing bounds checks in bch2_alloc_read()
      bcachefs: Add missing validation for bch_stripe.csum_granularity_bits
      bcachefs: Fix kasan splat in new_stripe_alloc_buckets()
      bcachefs: Handle race between stripe reuse, invalidate_stripe_to_dev
      bcachefs: Fix sysfs warning in fstests generic/730,731

Mohammed Anees (1):
      bcachefs: Fix NULL pointer dereference in bch2_opt_to_text

Piotr Zalewski (1):
      bcachefs: add check for btree id against max in try read node

 fs/bcachefs/alloc_background.c      |  10 +
 fs/bcachefs/bcachefs_format.h       |   3 +-
 fs/bcachefs/btree_gc.c              |  15 +-
 fs/bcachefs/btree_io.c              |   5 +-
 fs/bcachefs/btree_iter.c            |   6 +-
 fs/bcachefs/btree_iter.h            |   8 +
 fs/bcachefs/btree_node_scan.c       |   3 +
 fs/bcachefs/data_update.c           |   1 +
 fs/bcachefs/disk_accounting.c       | 149 ++++++++++----
 fs/bcachefs/ec.c                    |  94 ++++++---
 fs/bcachefs/errcode.h               |   3 +-
 fs/bcachefs/extents.h               |  10 +
 fs/bcachefs/fs-io-direct.c          |   3 +-
 fs/bcachefs/fs.c                    | 102 +++++++++-
 fs/bcachefs/fs.h                    |   9 +-
 fs/bcachefs/fsck.c                  | 384 ++++++++++++++++++++++--------------
 fs/bcachefs/fsck.h                  |   1 +
 fs/bcachefs/inode.c                 | 275 ++++++++++++++++++++++----
 fs/bcachefs/inode.h                 |  10 +
 fs/bcachefs/inode_format.h          |   3 +-
 fs/bcachefs/journal.c               |  13 ++
 fs/bcachefs/opts.c                  |   4 +-
 fs/bcachefs/recovery.c              |   3 +-
 fs/bcachefs/recovery_passes_types.h |   1 +
 fs/bcachefs/replicas.c              |  39 +++-
 fs/bcachefs/sb-downgrade.c          |   5 +-
 fs/bcachefs/sb-errors_format.h      |   6 +-
 fs/bcachefs/sb-members.c            |  10 +-
 fs/bcachefs/snapshot.c              | 129 +++---------
 fs/bcachefs/snapshot.h              |   3 -
 fs/bcachefs/super.c                 |  34 +++-
 include/linux/closure.h             |  35 ++++
 32 files changed, 976 insertions(+), 400 deletions(-)
