Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23A1A38EC
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912068; cv=none; b=Xe93Ta015DxJufwSKxUqrrJxWaEgoqJVdb/rcH7h4TKmoAwA8gDFaNkaZR4xVsd8Do+/xbJNAxkLnyiphWxa0mUDQiDh4rhAklvm9EMnk8xQkzujdcU177vkzvmz+GA5oben9KM5DsMWWbmkZxUHbVIUrEksG2Vofs+W28xFMYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912068; c=relaxed/simple;
	bh=JQSRE5rvlEm7EZ74hmhWce1gnHwZZ0RO9+Vz5ZRPxg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FKpgOvxBKKf7MiIJR1qq2tBJ2YK+9Ftl4Yc14jXvZADGX6yZP9N9N3io5B/gB4IdJPpbQAli9O/ucoz215daXs1bOkhRb5UDiAscPPXOfqtRFzTiLjJG80me/tesGZtuaQgAKHtyjYG8a9GQqJj3DgPcqZAtT2Mq1cQ2YhWQwuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/34] a whole raft of bugfixes
Date: Fri, 29 Nov 2024 15:26:59 -0500
Message-ID: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mostly syzbot stuff

"use separate rhltable for inode_or_descendents is open" addresses
livelocks people were seeing when something scanned all their snapshots

"Change "disk accounting version 0" check to commit only" addresses
"invalid bkey" errors some people have been seeing after upgrading to
6.12

Kent Overstreet (34):
  bcachefs: BCH_ERR_btree_node_read_error_cached
  bcachefs: Use separate rhltable for
    bch2_inode_or_descendents_is_open()
  bcachefs: errcode cleanup: journal errors
  bcachefs: disk_accounting: bch2_dev_rcu -> bch2_dev_rcu_noerror
  bcachefs: Fix accounting_read when we rewind
  bcachefs: backpointer_to_missing_ptr is now autofix
  bcachefs: Fix btree node scan when unknown btree IDs are present
  bcachefs: Kill bch2_bucket_alloc_new_fs()
  bcachefs: Bad btree roots are now autofix
  bcachefs: Fix dup/misordered check in btree node read
  bcachefs: Don't try to en/decrypt when encryption not available
  bcachefs: Change "disk accounting version 0" check to commit only
  bcachefs: Fix bch2_btree_node_update_key_early()
  bcachefs: Go RW earlier, for normal rw mount
  bcachefs: Fix null ptr deref in btree_path_lock_root()
  bcachefs: Ignore empty btree root journal entries
  bcachefs: struct bkey_validate_context
  bcachefs: Make topology errors autofix
  bcachefs: BCH_FS_recovery_running
  bcachefs: dio write: Take ref on mm_struct when using asynchronously
  bcachefs: Guard against journal seq overflow
  bcachefs: Issue a transaction restart after commit in repair
  bcachefs: Guard against backpointers to unknown btrees
  bcachefs: Fix journal_iter list corruption
  bcachefs: add missing printbuf_reset()
  bcachefs: mark more errors AUTOFIX
  bcachefs: Don't error out when logging fsck error
  bcachefs: do_fsck_ask_yn()
  bcachefs: Check for bucket journal seq in the future
  bcachefs: Check for inode journal seq in the future
  bcachefs: cryptographic MACs on superblock are not (yet?) supported
  bcachefs: bch2_trans_relock() is trylock for lockdep
  bcachefs: Check for extent crc uncompressed/compressed size mismatch
  bcachefs: Don't recurse in check_discard_freespace_key

 fs/bcachefs/alloc_background.c      | 153 ++++++++++++++++++-------
 fs/bcachefs/alloc_background.h      |  18 +--
 fs/bcachefs/alloc_foreground.c      |  42 +++----
 fs/bcachefs/alloc_foreground.h      |   2 -
 fs/bcachefs/backpointers.c          |   9 +-
 fs/bcachefs/backpointers.h          |   3 +-
 fs/bcachefs/bcachefs.h              |   4 +-
 fs/bcachefs/bkey.h                  |   7 --
 fs/bcachefs/bkey_methods.c          |  29 ++---
 fs/bcachefs/bkey_methods.h          |  15 +--
 fs/bcachefs/bkey_types.h            |  26 +++++
 fs/bcachefs/btree_cache.c           |  19 ++--
 fs/bcachefs/btree_cache.h           |   9 +-
 fs/bcachefs/btree_gc.c              |   3 +-
 fs/bcachefs/btree_io.c              | 170 +++++++++++++++++-----------
 fs/bcachefs/btree_iter.c            |  19 ++--
 fs/bcachefs/btree_locking.c         |   2 +-
 fs/bcachefs/btree_locking.h         |   4 +-
 fs/bcachefs/btree_node_scan.c       |  10 +-
 fs/bcachefs/btree_trans_commit.c    |   7 +-
 fs/bcachefs/btree_update_interior.c |  21 ++--
 fs/bcachefs/buckets.c               |  25 ++++
 fs/bcachefs/buckets.h               |  21 +---
 fs/bcachefs/checksum.c              |  10 +-
 fs/bcachefs/data_update.c           |   7 +-
 fs/bcachefs/dirent.c                |   4 +-
 fs/bcachefs/dirent.h                |   4 +-
 fs/bcachefs/disk_accounting.c       |  24 +++-
 fs/bcachefs/disk_accounting.h       |   5 +-
 fs/bcachefs/ec.c                    |   4 +-
 fs/bcachefs/ec.h                    |   5 +-
 fs/bcachefs/errcode.h               |   5 +
 fs/bcachefs/error.c                 | 110 +++++++++++-------
 fs/bcachefs/error.h                 |  18 +--
 fs/bcachefs/extents.c               |  40 ++++---
 fs/bcachefs/extents.h               |   9 +-
 fs/bcachefs/fs-io-direct.c          |  42 ++++++-
 fs/bcachefs/fs-io.c                 |  35 +++++-
 fs/bcachefs/fs.c                    |  39 +++++--
 fs/bcachefs/fs.h                    |   1 +
 fs/bcachefs/fsck.c                  |  13 ++-
 fs/bcachefs/inode.c                 |  16 +--
 fs/bcachefs/inode.h                 |   9 +-
 fs/bcachefs/io_read.c               |  14 ++-
 fs/bcachefs/journal.c               |  47 ++++----
 fs/bcachefs/journal.h               |   2 +-
 fs/bcachefs/journal_io.c            |  35 +++---
 fs/bcachefs/journal_reclaim.c       |   3 +
 fs/bcachefs/journal_types.h         |   3 +
 fs/bcachefs/lru.c                   |   2 +-
 fs/bcachefs/lru.h                   |   2 +-
 fs/bcachefs/quota.c                 |   2 +-
 fs/bcachefs/quota.h                 |   4 +-
 fs/bcachefs/recovery.c              |  55 +++++----
 fs/bcachefs/recovery_passes.c       |   2 +-
 fs/bcachefs/reflink.c               |   8 +-
 fs/bcachefs/reflink.h               |  10 +-
 fs/bcachefs/sb-errors_format.h      |  35 +++---
 fs/bcachefs/snapshot.c              |   4 +-
 fs/bcachefs/snapshot.h              |   7 +-
 fs/bcachefs/subvolume.c             |   2 +-
 fs/bcachefs/subvolume.h             |   5 +-
 fs/bcachefs/super-io.c              |   3 +-
 fs/bcachefs/super.c                 |  12 +-
 fs/bcachefs/xattr.c                 |   2 +-
 fs/bcachefs/xattr.h                 |   3 +-
 66 files changed, 822 insertions(+), 458 deletions(-)

-- 
2.45.2

