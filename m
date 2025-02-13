Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5628A2D5
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472380; cv=none; b=FexvB/UJhIRGwHwqTMOF8CVdC7w0ma7IPZ1w3XY27mqJaD/wCuZuRsQSBBO/whc+3gQKYbbNy4C2s/v7ihQ6/BmUb9MYebQ/XEVhxUZKCsOpDIcc9O7yIva3C6Djfhpp5bnvNs325jnDAMrl4dlirwhY7B0b80KWhqm+xxcjh1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472380; c=relaxed/simple;
	bh=EYuRV79A6yHh97HgZ3vOYSgXOng0WeParG/OCTyts1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R9fCDHC4XVANObR08FqnwpS8uXAtSMCBiYoAUtDOo7cq0Apq1KuRlZp/9qCZ4ooVYNB9EeiI6tACGVW3vzOAketdwBAx65oiT9AwzR4v3jiZL57xVd+OA5RlhkVUlO0KEocCPZZqAIMHbxoQEFw1Vw6me63GqUm6zVgYq20q760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bn/YKI06; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bn/YKI06"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0CIXAhN/B92y8bRF6z2zOWUios10f3Qd44Zj03QJK0c=;
	b=Bn/YKI06RM+gZL7Z3qBPxVe2nq5amHl2VI0xPWqj8Lu1lUTM4Oy4DGO4D0hiP4uHurcwoG
	3Kpon1DMGeo4x3dGaJFGiAHZsg4OlD2RShV9LvtHVFi+DGCI0moWbp/UFjWL9PRqUrn3Ne
	TKWBPvljxF4CA8b0JUMJxzVUF6CuUTc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Joshua Ashton <joshua@froggi.es>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH 00/18] last on disk format changes before freeze
Date: Thu, 13 Feb 2025 13:45:45 -0500
Message-ID: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

These are the last of the on disk format changes that will be required
upgrades. Future on disk format changes will be optional - meaning
they'll require more compat code.

- metadata_version_cached_backpointers: scrub can now check cached data,
  and (more importantly) the gc_gens pass for recalculating
  bucket.oldest_gen is no longer required - necessary scalability item.

- metadata_version_stripe_backpointers: needed for scrub to properly
  support erasure coding, and for future stripe repair code

- metadata_version_stripe_lru: we no longer have to read stripes into
  memory at startup for the stripes heap, for reusing partially empty
  stripes

- metadata_version_casefolding: I think this one will make some people
  happy :)

Joshua, the casefolding patches needed some work to rebase, could you
look them over? Hongbo, I had to tweak your directory i_size code as
well.

Joshua Ashton (2):
  bcachefs: Split out dirent alloc and name initialization
  bcachefs: bcachefs_metadata_version_casefolding

Kent Overstreet (16):
  bcachefs: bch2_lru_change() checks for no-op
  bcachefs: s/BCH_LRU_FRAGMENTATION_START/BCH_LRU_BUCKET_FRAGMENTATION/
  bcachefs: decouple bch2_lru_check_set() from alloc btree
  bcachefs: Rework bch2_check_lru_key()
  bcachefs: bch2_trigger_stripe_ptr() no longer uses
    ec_stripes_heap_lock
  bcachefs: Better trigger ordering
  bcachefs: rework bch2_trans_commit_run_triggers()
  bcachefs: bcachefs_metadata_version_cached_backpointers
  bcachefs: Invalidate cached data by backpointers
  bcachefs: Advance bch_alloc.oldest_gen if no stale pointers
  bcachefs: bcachefs_metadata_version_stripe_backpointers
  bcachefs: bcachefs_metadata_version_stripe_lru
  bcachefs: ec_stripe_delete() uses new stripe lru
  bcachefs: get_existing_stripe() uses new stripe lru
  bcachefs: We no longer read stripes into memory at startup
  bcachefs: Kill dirent_occupied_size()

 .../filesystems/bcachefs/casefolding.rst      |  87 ++++
 fs/bcachefs/alloc_background.c                | 147 ++++--
 fs/bcachefs/backpointers.c                    |  14 +-
 fs/bcachefs/backpointers.h                    |  15 +-
 fs/bcachefs/bcachefs.h                        |  10 +-
 fs/bcachefs/bcachefs_format.h                 |   9 +-
 fs/bcachefs/btree_trans_commit.c              |  89 ++--
 fs/bcachefs/btree_types.h                     |  13 +
 fs/bcachefs/btree_update.c                    |   3 +-
 fs/bcachefs/buckets.c                         |  14 +-
 fs/bcachefs/buckets.h                         |  27 --
 fs/bcachefs/buckets_types.h                   |  27 ++
 fs/bcachefs/dirent.c                          | 223 +++++++--
 fs/bcachefs/dirent.h                          |  18 +-
 fs/bcachefs/dirent_format.h                   |  20 +-
 fs/bcachefs/ec.c                              | 429 ++++++------------
 fs/bcachefs/ec.h                              |  46 +-
 fs/bcachefs/ec_types.h                        |  12 +-
 fs/bcachefs/fs-common.c                       |  42 +-
 fs/bcachefs/fs-ioctl.c                        |  25 +
 fs/bcachefs/fs-ioctl.h                        |  20 +-
 fs/bcachefs/fs.c                              |  17 +
 fs/bcachefs/fsck.c                            |   5 +-
 fs/bcachefs/inode_format.h                    |   3 +-
 fs/bcachefs/lru.c                             | 100 ++--
 fs/bcachefs/lru.h                             |  22 +-
 fs/bcachefs/lru_format.h                      |   6 +-
 fs/bcachefs/move.c                            |   3 +
 fs/bcachefs/movinggc.c                        |   4 +-
 fs/bcachefs/recovery_passes_types.h           |   2 +-
 fs/bcachefs/sb-downgrade.c                    |   6 +
 fs/bcachefs/sb-errors_format.h                |   4 +-
 fs/bcachefs/str_hash.c                        |   2 +-
 fs/bcachefs/str_hash.h                        |   4 +
 fs/bcachefs/super.c                           |  19 +
 fs/bcachefs/sysfs.c                           |   5 -
 36 files changed, 904 insertions(+), 588 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

-- 
2.45.2

