Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E3A28682
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283685; cv=none; b=s0Z4guqHBS5RaABtyOAWEDczFo84pKVPrJ/nB4eNRzIc5LkN+ZI8qKYwS/42OwI/cOVp4O8rc2/S23QwGF05nSLXbHxvrzo2MIjXFFL8WqQCSHUIlmSeMjWkh5Ds/0TNYDUsTJ9q2QMFrCtmrnBq8H/TwFxNk125xJ3zT7kpoqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283685; c=relaxed/simple;
	bh=NL6fSizwAzrEzgnFl9lXSz2wBDw7yThziHk1BwNeUJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZII5elrmzATuBvdNpdhhW23N5OM+G+KwsAezJZNHIoIp896QUnyOdN4eh5JSjJqJdIkSe4U7YU4wW4ly4gqmX+QunEb9y8TXY/2XWvBoY3MZ9MtdPofstI44Vu1ZOQhaFz5bjhoYuX34K+OKH7FOLySqKiPX4eNO1K+/1F+AIKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YoIXsDv0; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YoIXsDv0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JlItCNAaRsb1psz35igVJZ1HqJU3giZ4cUxoA1A1by4=;
	b=YoIXsDv007q+4O7AhI2dl+tq+cnA7cqGPDDrdcDoU66X0oedPJHe01PZUHbbORjh1GoFzI
	jimUoRe5qvda4hlyHTCgmpdkogbudeEi67pDX7DVQu4BHoXvcLlSII0h6ILAT/8I1ifnBY
	Pd8aAf4/9ygraCOxfj0NB9n7R/uHRRk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/37] 6.16-rc3 hotfixes series
Date: Wed, 18 Jun 2025 17:53:51 -0400
Message-ID: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Busy week...

We now have journal rewind, which one of the users (the one who didn't
have backups) who was bit by the subvolume deletion bug was able to use
to fully recover his filesystem.

Going to do some work on the discard path so we can have that as a
reliable disaster recovery mechanism.

Otherwise, mostly boring repair stuff, some tracepoints for tracking
down livelock-ish issues.

Alan Huang (6):
  bcachefs: Don't allocate new memory when mempool is exhausted
  bcachefs: Fix alloc_req use after free
  bcachefs: Add missing EBUG_ON
  bcachefs: Delay calculation of trans->journal_u64s
  bcachefs: Move bset size check before csum check
  bcachefs: Fix pool->alloc NULL pointer dereference

Bharadwaj Raju (1):
  bcachefs: don't return fsck_fix for unfixable node errors in
    __btree_err

Kent Overstreet (30):
  bcachefs: trace_extent_trim_atomic
  bcachefs: btree iter tracepoints
  bcachefs: Fix bch2_journal_keys_peek_prev_min()
  bcachefs: btree_iter: fix updates, journal overlay
  bcachefs: better __bch2_snapshot_is_ancestor() assert
  bcachefs: pass last_seq into fs_journal_start()
  bcachefs: Fix "now allowing incompatible features" message
  bcachefs: Fix snapshot_key_missing_inode_snapshot repair
  bcachefs: fsck: fix add_inode()
  bcachefs: fsck: fix extent past end of inode repair
  bcachefs: opts.journal_rewind
  bcachefs: Kill unused tracepoints
  bcachefs: mark more errors autofix
  bcachefs: fsck: Improve check_key_has_inode()
  bcachefs: Call bch2_fs_init_rw() early if we'll be going rw
  bcachefs: Fix __bch2_inum_to_path() when crossing subvol boundaries
  bcachefs: fsck: Print path when we find a subvol loop
  bcachefs: fsck: Fix remove_backpointer() for subvol roots
  bcachefs: fsck: Fix reattach_inode() for subvol roots
  bcachefs: fsck: check_directory_structure runs in reverse order
  bcachefs: fsck: additional diagnostics for reattach_inode()
  bcachefs: fsck: check_subdir_count logs path
  bcachefs: fsck: Fix check_path_loop() + snapshots
  bcachefs: Fix bch2_read_bio_to_text()
  bcachefs: Fix restart handling in btree_node_scrub_work()
  bcachefs: fsck: Fix check_directory_structure when no check_dirents
  bcachefs: fsck: fix unhandled restart in topology repair
  bcachefs: fsck: Fix oops in key_visible_in_snapshot()
  bcachefs: fix spurious error in read_btree_roots()
  bcachefs: Fix missing newlines before ero

 fs/bcachefs/bcachefs.h                 |   3 +-
 fs/bcachefs/btree_gc.c                 |   8 +-
 fs/bcachefs/btree_io.c                 |  74 +++---
 fs/bcachefs/btree_iter.c               | 169 ++++++++-----
 fs/bcachefs/btree_journal_iter.c       |  64 +++--
 fs/bcachefs/btree_journal_iter_types.h |   5 +-
 fs/bcachefs/btree_trans_commit.c       |  18 +-
 fs/bcachefs/btree_types.h              |   1 +
 fs/bcachefs/btree_update_interior.c    |  11 +-
 fs/bcachefs/btree_update_interior.h    |   3 +
 fs/bcachefs/btree_write_buffer.c       |   3 +
 fs/bcachefs/chardev.c                  |  29 ++-
 fs/bcachefs/data_update.c              |   1 +
 fs/bcachefs/errcode.h                  |   5 -
 fs/bcachefs/extent_update.c            |  13 +-
 fs/bcachefs/fsck.c                     | 317 +++++++++++++++++--------
 fs/bcachefs/inode.h                    |   5 +
 fs/bcachefs/io_read.c                  |   7 +-
 fs/bcachefs/journal.c                  |  18 +-
 fs/bcachefs/journal.h                  |   2 +-
 fs/bcachefs/journal_io.c               |  26 +-
 fs/bcachefs/namei.c                    |  30 ++-
 fs/bcachefs/opts.h                     |   5 +
 fs/bcachefs/recovery.c                 |  24 +-
 fs/bcachefs/recovery_passes.c          |   6 +-
 fs/bcachefs/recovery_passes.h          |   9 +
 fs/bcachefs/sb-errors_format.h         |  10 +-
 fs/bcachefs/snapshot.c                 |   8 +-
 fs/bcachefs/super.c                    |  13 +-
 fs/bcachefs/super.h                    |   1 +
 fs/bcachefs/trace.h                    | 125 +++-------
 31 files changed, 622 insertions(+), 391 deletions(-)

-- 
2.50.0

