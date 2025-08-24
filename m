Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098B02045B5
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039092; cv=none; b=E+d7pczsYiSuKPhv4UNc7HwDqZa9N+4RPicrqEsz1MhyTvMfvrtwlGqKHCRkE4hk1GJYcPmSY2zCUdHf5JpCcafdujZQ6luKs3OxErKeYQR63RUPifMFLsNgk3c/B/pFaHsiajje4FGosqaHvvmSnCyu/RZPWbudQe8IiEFoiQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039092; c=relaxed/simple;
	bh=zk2mgzssOi4Cg2Cdn9T8V/YgNi+HU4ZltRVkN5bLyhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lgaay2JAD/+ROgbM7arsrhooS0zA06HnWzHvlMNjFt42En/+56Xg5tI2Frio9//jTiHhX8R2FDqBeBmnxNsIZQyM8IFRw1tklnxR/+hd2uXuXUoKNhNk1YqWHm2cZIaD6VWw/0XRPVkbdyylxCwTar48BsyeZa5dklsLPrOg7QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ev67UnkG; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ev67UnkG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yjT51QIHzr85VCmfNOvdcmWdqEE5OahguLYkTZyjgh8=;
	b=ev67UnkGfTU8F01huLRGbPXfpKQxT6Nu/hQCyZs+UHMqD9hyfTHj9i4n/OI7cddMTWUyqP
	Y1fYAo1AetztuiMKg00X582pzXJFtiyie0Ju1Kp3OCgR+v1Cop+Cm/pGylLxrtWNWXr2MT
	cp8e6OSOq+UoJxtVAah1kW1F9NJrEf0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/21] Big rebalance changes
Date: Sun, 24 Aug 2025 08:37:37 -0400
Message-ID: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is a WIP patch series: there's still lots of unfinished bits, but
there's big user visible changes happening so it's time to give people a
heads up and start circulating for comments and ideas.

This series originated with a debugging session where we noticed that
there were extents that had been written with the wrong checksum type.
That's pretty bad - the extent we noticed was written with _no_
checksum, meaning IO path options got screwed up somewhere and we had no
way of detecting it.

So - that means we need to be able to check and enforce that data is
correctly written according to the specified IO path options from the
filesystem and inode; something we've been needing for awhile.

IO path options -> extent handling is rebalance's responsibility (and
one of these days I'm going to rename that, that name has become quite
the inaccurate description for what it does). We already have the
ability to store IO path options in the extent itself (struct
bch_extent_rebalance); this is necessary for e.g. indirect extents where
we don't know what inode it came from when doing background processing,
as well as for the triggers so that we can do accounting for pending
rebalance work.

So a large part of the series is reworking how we apply IO path options
to extents (bch2_bkey_set_needs_rebalance()), so that we can strictly
enforce that the extent does match the IO path options and record an
error if it does not.

Additionally, in the current code rebalance only really handles the
compression/background_compression/background_target options; it now
needs to handle (enforce, apply, correct existing data) all the IO path
options - that means we need to add support for the data_checksum,
data_replicas and erasure_code option.

Supporting data_replicas requires reworking bch_extent_rebalance
(compatibility notes in that patch), since the triggers that update the
rebalance_work accounting and btrees (now btrees) need to be pure
functions of the extents - they can't be functions of device state or
durability, since those can change.

So bch_extent_rebalance now has flags for "extent needs to be
rebalanced"; the trigger only looks at those (and this will benefit
extent btree update performance); this centralizes looking at the entire
extent and deciding what needs to be done in
bch2_bkey_set_needs_rebalance(), which now has the new consistency
checks. We now clearly define under what conditions and codepaths an
extent is allowed to deviate: option changes, or a foreground write that
only needs background_compression or background_target applied.

The fun stuff:

Now that rebalance can react to any IO path option changes,

- It's no longer required to run 'bcachefs data rereplicate/bcachefs
  data op drop_extra_replicas' after replicas setting changes,
  BCH_DATA_OP_rereplicate and BCH_DATA_OP_drop_extra_replicas are
  obsoleted.

- We can now react to device state changes: durability setting changes,
  and more importantly, state changes when a device switches to
  BCH_MEMBER_STATE_failed - this will automatically evacuate the device
  (and evacuate will resume if we crash or shutdown and restart).

  Currently, we only mark devices read-only on excessive IO errors, we
  don't automatically mark devices as failed - that only happens in
  response to a 'bcachefs device set-state' command. But in the future
  we'll want to add configuration and policy for making this happen
  automatically when a device appears to be unhealthy.

  If you have a huge disk array, this will mean no wearing a pager to
  respond to hardware failures: we'll do everything required to keep
  data at the appropriate replication level and on healthy devices, just
  swap the bad devices at your leisure.

Other good stuff:

- rebalance_work accounting is now broken out into subcounters for each
  IO path option so you can better see what background processing is
  happening

- new btrees for rebalance_work_hipri, to ensure that evacuating failed
  devices runs first, and rebalance_work_pending for data we'd like to
  move but can't because the target is full - this will solve the
  "rebalance is spinning because I tried to stuff more data into
  background_target than fits" bug reports.


Kent Overstreet (21):
  bcachefs: s/bch_io_opts/bch_inode_opts
  bcachefs: Inode opt helper refactoring
  bcachefs: opt_change_cookie
  bcachefs: Transactional consistency for set_needs_rebalance
  bcachefs: Plumb bch_inode_opts.change_cookie
  bcachefs: enum set_needs_rebalance_ctx
  bcachefs: do_rebalance_scan() now responsible for indirect extents
  bcachefs: Rename, split out bch2_extent_get_io_opts()
  bcachefs: do_rebalance_extent() uses bch2_extent_get_apply_io_opts()
  bcachefs: Correct propagation of io options to indirect extents
  bcachefs: bkey_should_have_rb_opts()
  bcachefs: bch2_bkey_needs_rebalance()
  bcachefs: rebalance now supports changing checksum type
  bcachefs: Consistency checking for bch_extent_rebalance opts
  bcachefs: check_rebalance_work checks option inconsistency
  bcachefs: bch2_bkey_set_needs_rebalance() now takes
    per_snapshot_io_opts
  bcachefs: bch_extent_rebalance changes
  bcachefs: bch2_set_rebalance_needs_scan_device()
  bcachefs: next_rebalance_extent() now handles replicas changes
  bcachefs: rebalance: erasure_code opt change now handled
  bcachefs: rebalance_work_(hipri|pending) btrees

 fs/bcachefs/bcachefs.h               |   2 +
 fs/bcachefs/bcachefs_format.h        |   8 +
 fs/bcachefs/buckets.c                |  28 +-
 fs/bcachefs/checksum.h               |   2 +-
 fs/bcachefs/data_update.c            |  44 +-
 fs/bcachefs/data_update.h            |   8 +-
 fs/bcachefs/disk_accounting_format.h |   1 +
 fs/bcachefs/extents.c                |  16 +-
 fs/bcachefs/extents.h                |  15 +-
 fs/bcachefs/fs-io-buffered.c         |  12 +-
 fs/bcachefs/fs-io-direct.c           |   8 +-
 fs/bcachefs/fs-io.c                  |   4 +-
 fs/bcachefs/inode.c                  |  45 +-
 fs/bcachefs/inode.h                  |   9 +-
 fs/bcachefs/io_misc.c                |  14 +-
 fs/bcachefs/io_misc.h                |   2 +-
 fs/bcachefs/io_read.c                |   2 +-
 fs/bcachefs/io_read.h                |   4 +-
 fs/bcachefs/io_write.c               |  50 +-
 fs/bcachefs/io_write.h               |   4 +-
 fs/bcachefs/io_write_types.h         |   2 +-
 fs/bcachefs/move.c                   | 194 +------
 fs/bcachefs/move.h                   |  34 +-
 fs/bcachefs/opts.c                   |  15 +-
 fs/bcachefs/opts.h                   |   9 +-
 fs/bcachefs/rebalance.c              | 823 +++++++++++++++++++++------
 fs/bcachefs/rebalance.h              |  80 ++-
 fs/bcachefs/rebalance_format.h       |  62 +-
 fs/bcachefs/reflink.c                |  16 +-
 fs/bcachefs/sb-errors_format.h       |   3 +-
 fs/bcachefs/super.c                  |   4 +
 fs/bcachefs/sysfs.c                  |   4 +
 fs/bcachefs/trace.h                  |   5 -
 fs/bcachefs/xattr.c                  |   3 +
 34 files changed, 945 insertions(+), 587 deletions(-)

-- 
2.50.1

