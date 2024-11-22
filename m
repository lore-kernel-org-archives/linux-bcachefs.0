Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE59B4C62E
	for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 06:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732255326; cv=none; b=UQ8B5lwaLkaLhkW2PT32mxzvtGaMud6lS9/4rGEHird1/RGF1WTzO6TM1xiCmFhwTysUh0YYQRrfJJDDQE5UlwtDrtsY9JSlKSskjfxU8jseqAHJshf+wNxBgvjjihqbwGZsEkWLTEpUnjgB4kCTlxsMY84t5TFG4V+36DAffTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732255326; c=relaxed/simple;
	bh=bbpHaFhdC89+/71jgDgtYoOOP46/TDSs9XEMfBFMGRU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g15i25Vcl7lI7FWIXTAIzi6AmvjLzCjCBF+zaUcKWDpbjRIb9hooRimjrOW3krHejQuB9vO8ZZXYY3CP4MsBwhgDDxFNncUh3n2K5OXEw0hZv+VLjVBqH3bJIzoRIV/a8yIFmkKKIrHpiU6Sy6506L2mU4Cc4khtK8kYC2RSR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cPzKw/LF; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cPzKw/LF"
Date: Fri, 22 Nov 2024 01:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732255320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=X4EMPRVihhBPZNDl50g/NPmL6MJ9oqSD9ufmkNM0nD8=;
	b=cPzKw/LFWIQaj5ajckztxNHFugryjW5zSuBR1tsrbJsqT8S45xugDjOPOYBUhJG7g1PYzg
	nMAB3aw9kyrqIRMb24gDn2VUrpi5wZPU/E1W5iet6+PYl77bZ2QxHsA+8viaIqt+Vy5JtT
	bc0dxl/msmun1Ccr8Ov2qsF7mv+pzGo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs updates for 6.13, v2
Message-ID: <rfsnkjlcyl3tsegoov2j5xvxaueeiza6yds75g4s4znxax5gmk@ufugcnldtbuk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, this just has a few additional fixes over the last pull
request.

The following changes since commit 840c2fbcc5cd33ba8fab180f09da0bb7f354ea71:

  bcachefs: Fix assertion pop in bch2_ptr_swab() (2024-11-12 03:46:57 -0500)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-11-22

for you to fetch changes up to b2cc9c6fcee366ba4988ba0eec63bb2932cccadd:

  bcachefs: fix bp_pos_to_bucket_nodev_noerror (2024-11-21 20:11:29 -0500)

----------------------------------------------------------------
bcachefs updates for 6.13 v2

- Self healing work:
  Allocator and reflink now run the exact same check/repair code that
  fsck does at runtime, where applicable.

  The long term goal here is to remove inconsistent() errors (that cause
  us to go emergency read only) by lifting fsck code up to normal
  runtime paths; we should only go emergency read-only if we detect an
  inconsistency that was due to a runtime bug - or truly catastrophic
  damage (corrupted btree roots/interior nodes).

- Reflink repair no longer deletes reflink pointers: instead we flip an
  error bit and log the error, and they can still be deleted by file
  deletion. This means a temporary failure to find an indirect extent
  (perhaps repaired later by btree node scan) won't result in
  unnecessary data loss

- Improvements to rebalance data path option handling: we can now
  correctly apply changed filesystem-level io path options to pending
  rebalance work, and soon we'll be able to apply file-level io path
  option changes to indirect extents.

Additions from last pull request:

- Fixes for compression inconsistencies with superblock feature bits,
  found by sizbot

- Fix some O(n^2) issues in journal replay

- Fix the evacuate_bucket tracepoint

----------------------------------------------------------------
Alan Huang (1):
      bcachefs: Delete dead code

Colin Ian King (1):
      bcachefs: remove superfluous ; after statements

Dennis Lam (1):
      docs: filesystems: bcachefs: fixed some spelling mistakes in the bcachefs coding style page

Eric Biggers (1):
      bcachefs: Explicitly select CRYPTO from BCACHEFS_FS

Hongbo Li (2):
      bcachefs: remove write permission for gc_gens_pos sysfs interface
      bcachefs: use attribute define helper for sysfs attribute

Integral (1):
      bcachefs: add support for true/false & yes/no in bool-type options

Kent Overstreet (85):
      bcachefs: kill retry_estale() in bch2_ioctl_subvolume_create()
      Merge branch 'bcachefs-kill-retry-estale' into HEAD
      bcachefs: Fix racy use of jiffies
      bcachefs: bch2_inode_should_have_bp -> bch2_inode_should_have_single_bp
      bcachefs: remove_backpointer() now uses dirent_get_by_pos()
      bcachefs: __bch2_key_has_snapshot_overwrites uses for_each_btree_key_reverse_norestart()
      bcachefs: rcu_pending: don't invoke __call_rcu() under lock
      bcachefs: bch_verbose_ratelimited
      bcachefs: Pull disk accounting hooks out of trans_commit.c
      bcachefs: Remove unnecessary peek_slot()
      bcachefs: kill btree_trans_restart_nounlock()
      bcachefs: add more path idx debug asserts
      bcachefs: bch2_run_explicit_recovery_pass() returns different error when not in recovery
      bcachefs: lru, accounting are alloc btrees
      bcachefs: Add locking for bch_fs.curr_recovery_pass
      bcachefs: bch2_btree_lost_data() now uses run_explicit_rceovery_pass_persistent()
      bcachefs: improved bkey_val_copy()
      bcachefs: Factor out jset_entry_log_msg_bytes()
      bcachefs: better error message in check_snapshot_tree()
      bcachefs: Avoid bch2_btree_id_str()
      bcachefs: Refactor new stripe path to reduce dependencies on ec_stripe_head
      bcachefs: -o norecovery now bails out of recovery earlier
      bcachefs: bch2_journal_meta() takes ref on c->writes
      bcachefs: Fix warning about passing flex array member by value
      bcachefs: Add block plugging to read paths
      bcachefs: Add version check for bch_btree_ptr_v2.sectors_written validate
      bcachefs: avoid 'unsigned flags'
      bcachefs: use bch2_data_update_opts_to_text() in trace_move_extent_fail()
      bcachefs: bch2_io_opts_fixups()
      bcachefs: small cleanup for extent ptr bitmasks
      bcachefs: kill bch2_bkey_needs_rebalance()
      bcachefs: kill __bch2_bkey_sectors_need_rebalance()
      bcachefs: rename bch_extent_rebalance fields to match other opts structs
      bcachefs: io_opts_to_rebalance_opts()
      bcachefs: Add bch_io_opts fields for indicating whether the opts came from the inode
      bcachefs: copygc_enabled, rebalance_enabled now opts.h options
      bcachefs: bch2_prt_csum_opt()
      bcachefs: New bch_extent_rebalance fields
      bcachefs: bch2_write_inode() now checks for changing rebalance options
      bcachefs: get_update_rebalance_opts()
      bcachefs: Simplify option logic in rebalance
      bcachefs: Improve trace_rebalance_extent
      bcachefs: Move bch_extent_rebalance code to rebalance.c
      bcachefs: Add assert for use of journal replay keys for updates
      bcachefs: Kill BCH_TRANS_COMMIT_lazy_rw
      bcachefs: Improved check_topology() assert
      bcachefs: Fix unhandled transaction restart in evacuate_bucket()
      bcachefs: Assert we're not in a restart in bch2_trans_put()
      bcachefs: Better in_restart error
      bcachefs: bch2_trans_verify_not_unlocked_or_in_restart()
      bcachefs: Assert that we're not violating key cache coherency rules
      bcachefs: Rename btree_iter_peek_upto() -> btree_iter_peek_max()
      bcachefs: Simplify btree_iter_peek() filter_snapshots
      bcachefs: Kill unnecessary iter_rewind() in bkey_get_empty_slot()
      bcachefs: Move fsck ioctl code to fsck.c
      bcachefs: Add support for FS_IOC_GETFSUUID
      bcachefs: Add support for FS_IOC_GETFSSYSFSPATH
      bcachefs: Don't use page allocator for sb_read_scratch
      bcachefs: Fix shutdown message
      bcachefs: delete dead code
      bcachefs: bch2_btree_bit_mod_iter()
      bcachefs: Delete dead code from bch2_discard_one_bucket()
      bcachefs: lru errors are expected when reconstructing alloc
      bcachefs: Kill FSCK_NEED_FSCK
      bcachefs: Reserve 8 bits in bch_reflink_p
      bcachefs: Reorganize reflink.c a bit
      bcachefs: Don't delete reflink pointers to missing indirect extents
      bcachefs: kill inconsistent err in invalidate_one_bucket()
      bcachefs: rework bch2_bucket_alloc_freelist() freelist iteration
      bcachefs: try_alloc_bucket() now uses bch2_check_discard_freespace_key()
      bcachefs: bch2_bucket_do_index(): inconsistent_err -> fsck_err
      bcachefs: discard_one_bucket() now uses need_discard_or_freespace_err()
      bcachefs: Implement bch2_btree_iter_prev_min()
      bcachefs: peek_prev_min(): Search forwards for extents, snapshots
      bcachefs: Delete backpointers check in try_alloc_bucket()
      bcachefs: Kill bch2_get_next_backpointer()
      bcachefs: add missing BTREE_ITER_intent
      bcachefs: compression workspaces should be indexed by opt, not type
      bcachefs: Don't use a shared decompress workspace mempool
      bcachefs: Don't BUG_ON() when superblock feature wasn't set for compressed data
      bcachefs: kill bch2_journal_entries_free()
      bcachefs: journal keys: sort keys for interior nodes first
      bcachefs: btree_and_journal_iter: don't iterate over too many whiteouts when prefetching
      bcachefs: fix O(n^2) issue with whiteouts in journal keys
      bcachefs: fix bp_pos_to_bucket_nodev_noerror

Piotr Zalewski (1):
      bcachefs: Fix evacuate_bucket tracepoint

Thomas Bertschinger (1):
      bcachefs: move bch2_xattr_handlers to .rodata

Thorsten Blum (6):
      bcachefs: Remove duplicate included headers
      bcachefs: Use FOREACH_ACL_ENTRY() macro to iterate over acl entries
      bcachefs: Use str_write_read() helper function
      bcachefs: Use str_write_read() helper in ec_block_endio()
      bcachefs: Use str_write_read() helper in write_super_endio()
      bcachefs: Annotate struct bucket_gens with __counted_by()

Youling Tang (4):
      bcachefs: Correct the description of the '--bucket=size' options
      bcachefs: Removes NULL pointer checks for __filemap_get_folio return values
      bcachefs: Remove redundant initialization in bch2_vfs_inode_init()
      bcachefs: Simplify code in bch2_dev_alloc()

 Documentation/filesystems/bcachefs/CodingStyle.rst |   2 +-
 fs/bcachefs/Kconfig                                |   1 +
 fs/bcachefs/acl.c                                  |  11 +-
 fs/bcachefs/alloc_background.c                     | 286 +++++-------
 fs/bcachefs/alloc_background.h                     |   2 +
 fs/bcachefs/alloc_foreground.c                     | 154 ++-----
 fs/bcachefs/backpointers.c                         | 149 ++----
 fs/bcachefs/backpointers.h                         |  13 +-
 fs/bcachefs/bbpos.h                                |   2 +-
 fs/bcachefs/bcachefs.h                             |  44 +-
 fs/bcachefs/bcachefs_format.h                      |  15 +-
 fs/bcachefs/btree_cache.c                          |  37 +-
 fs/bcachefs/btree_cache.h                          |   3 +-
 fs/bcachefs/btree_gc.c                             | 141 ++----
 fs/bcachefs/btree_io.c                             |  13 +-
 fs/bcachefs/btree_iter.c                           | 501 +++++++++++++--------
 fs/bcachefs/btree_iter.h                           | 105 ++---
 fs/bcachefs/btree_journal_iter.c                   | 237 ++++++++--
 fs/bcachefs/btree_journal_iter.h                   |  22 +-
 fs/bcachefs/btree_journal_iter_types.h             |  36 ++
 fs/bcachefs/btree_key_cache.c                      |  13 +-
 fs/bcachefs/btree_locking.h                        |   2 +-
 fs/bcachefs/btree_node_scan.c                      |  10 +-
 fs/bcachefs/btree_trans_commit.c                   |  79 +---
 fs/bcachefs/btree_types.h                          |   3 +
 fs/bcachefs/btree_update.c                         |  55 +--
 fs/bcachefs/btree_update.h                         |  28 +-
 fs/bcachefs/btree_update_interior.c                |  71 +--
 fs/bcachefs/btree_update_interior.h                |   2 +-
 fs/bcachefs/buckets.c                              |  43 +-
 fs/bcachefs/buckets_types.h                        |   2 +-
 fs/bcachefs/chardev.c                              | 219 +--------
 fs/bcachefs/checksum.h                             |   2 +-
 fs/bcachefs/compress.c                             |  96 ++--
 fs/bcachefs/data_update.c                          |  67 ++-
 fs/bcachefs/debug.c                                |   4 +-
 fs/bcachefs/dirent.c                               |   4 +-
 fs/bcachefs/disk_accounting.c                      |  13 +-
 fs/bcachefs/disk_accounting.h                      |  38 ++
 fs/bcachefs/ec.c                                   | 244 +++++-----
 fs/bcachefs/errcode.h                              |   8 +-
 fs/bcachefs/error.c                                |  28 +-
 fs/bcachefs/error.h                                |  38 +-
 fs/bcachefs/extent_update.c                        |   4 +-
 fs/bcachefs/extents.c                              | 231 +++-------
 fs/bcachefs/extents.h                              |   9 -
 fs/bcachefs/extents_format.h                       |  15 +-
 fs/bcachefs/fs-io-buffered.c                       |  26 +-
 fs/bcachefs/fs-io-direct.c                         |   5 +
 fs/bcachefs/fs-io-pagecache.c                      |   4 +-
 fs/bcachefs/fs-io.c                                |  10 +-
 fs/bcachefs/fs-ioctl.c                             |   7 +-
 fs/bcachefs/fs.c                                   |  42 +-
 fs/bcachefs/fsck.c                                 | 260 ++++++++++-
 fs/bcachefs/fsck.h                                 |   3 +
 fs/bcachefs/inode.c                                |  21 +-
 fs/bcachefs/inode.h                                |  10 +-
 fs/bcachefs/io_misc.c                              |  10 +-
 fs/bcachefs/io_read.c                              |  55 +--
 fs/bcachefs/io_read.h                              |  28 +-
 fs/bcachefs/io_write.c                             |   7 +-
 fs/bcachefs/journal.c                              |  27 +-
 fs/bcachefs/journal_io.c                           |  10 +-
 fs/bcachefs/journal_reclaim.c                      |   6 +-
 fs/bcachefs/lru.c                                  |   2 +-
 fs/bcachefs/move.c                                 | 126 +++---
 fs/bcachefs/move.h                                 |   5 +-
 fs/bcachefs/movinggc.c                             |   6 +-
 fs/bcachefs/opts.c                                 |  26 +-
 fs/bcachefs/opts.h                                 |  51 ++-
 fs/bcachefs/rcu_pending.c                          |   2 +
 fs/bcachefs/rebalance.c                            | 266 +++++++++--
 fs/bcachefs/rebalance.h                            |  10 +
 fs/bcachefs/rebalance_format.h                     |  53 +++
 fs/bcachefs/rebalance_types.h                      |   2 -
 fs/bcachefs/recovery.c                             | 103 +++--
 fs/bcachefs/recovery.h                             |   2 +-
 fs/bcachefs/recovery_passes.c                      |  90 +++-
 fs/bcachefs/recovery_passes.h                      |   1 +
 fs/bcachefs/reflink.c                              | 476 +++++++++++++++-----
 fs/bcachefs/reflink.h                              |   7 +
 fs/bcachefs/reflink_format.h                       |   5 +-
 fs/bcachefs/sb-errors_format.h                     |   9 +-
 fs/bcachefs/snapshot.c                             |  42 +-
 fs/bcachefs/str_hash.h                             |   6 +-
 fs/bcachefs/subvolume.c                            |   2 +-
 fs/bcachefs/subvolume.h                            |  12 +-
 fs/bcachefs/super-io.c                             |  10 +-
 fs/bcachefs/super-io.h                             |   2 +
 fs/bcachefs/super.c                                |  27 +-
 fs/bcachefs/super.h                                |  10 -
 fs/bcachefs/sysfs.c                                |  46 +-
 fs/bcachefs/tests.c                                |  26 +-
 fs/bcachefs/trace.h                                |  10 +-
 fs/bcachefs/xattr.c                                |  11 +-
 fs/bcachefs/xattr.h                                |   2 +-
 fs/fs_parser.c                                     |   3 +-
 include/linux/fs_parser.h                          |   2 +
 98 files changed, 2876 insertions(+), 2210 deletions(-)
 create mode 100644 fs/bcachefs/btree_journal_iter_types.h
 create mode 100644 fs/bcachefs/rebalance_format.h
