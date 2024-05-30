Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11337187558
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717084404; cv=none; b=SCyjemAoVd7giLnyiSKcD7j7nq1OAWLOVNFhNg5P2Jbs1gLttV1iZ5VAEx2JhhfE1FuHeJGP3DfDY+sPUxU6kDCnCuiTupq+5w9WjbcPA6xkGN6XtrVVcjrVYwHbrBbr4J/uAPs58bP/pngTY4i/uzL7FgM2GwcXHYmG+vqqles=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717084404; c=relaxed/simple;
	bh=NSONyl0eiFjI01Ei5b30Lbe/WtgsxxNI98rO5Yb71+o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QENVT4oIEX9xsocnCKi6oHqekQcJlsXRlqmEhJjz1R40sK00EJP08YEBuzed9lwCOsEzgCJ1yNONhZG83bgnIhZYs+gDbrZmV3E7Gp7fJXvC7PQUn+Lqe94pk7/W9Of1J6D6ZnPEwGzPb9WL/cvvJlRHGPayOFAS3nzcF1SPJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PmCK0WEa; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PmCK0WEa"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717084399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Lju3hqzSD9daaRrPNdpL2GJx8prw1cj6Sa0j8kjBSHc=;
	b=PmCK0WEa5bE3ivUVwP3VSqP/jXSOdD1oMKoA6CoUnF1SQ1R7amoJeoqX3eOB6Fq8SKJP09
	98Xv3/Gqic8sQ3Sj39Vw6zilSp708tj4Pc6GwSDyBemMvD/OMcrtG9Bkman7IWl9zI3ti0
	Th7l6zvsxSPxwSzPQXOPTrwFlAuoncI=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Thu, 30 May 2024 11:53:16 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.10-rc2
Message-ID: <wvw6rfvpz7nfq3dbvy2frovpzrqkgsyke6e45pgh2bntvubxqb@wjanieiymayi>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, assorted odds and ends...

important note for users: BCH_DATA_unstriped (accounting for unstriped
data in stripe buckets) is arriving next merge window (which requires
regenerating alloc info on mount if erasure coding is enabled), and the
disk accounting rewrite (at long last!) is also in my master branch and
arriving next merge window - which requires regenerating alloc info for
everyone.

disk accounting rewrite brings per-snapshot-id accounting, per-btree
accounting, accounting for pending rebalance work, compression
type/ratio accounting.

everything should be in place to make this a smooth upgrade progress,
except for getting a progress indicator plumbed through so users aren't
left wondering "why is my mount so slow? is it hung?" which we're going
to try to do as well.

The following changes since commit d93ff5fa40b9db5f505d508336bc171f54db862e:

  bcachefs: Fix race path in bch2_inode_insert() (2024-05-22 20:37:47 -0400)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-05-30

for you to fetch changes up to 7b038b564b3e2a752d2211e7b0c3c29fd2f6e197:

  bcachefs: Fix failure to return error on misaligned dio write (2024-05-29 16:40:30 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.10-rc2

- two downgrade fixes
- a couple snapshot deletion and repair fixes, thanks to noradtux for
  finding these and providing the image to debug them
- a couple assert fixes
- convert to folio helper, from Matthew
- some improved error messages
- bit of code reorganization (just moving things around); doing this
  while things are quiet so I'm not rebasing fixes past reorgs
- don't return -EROFS on inconsistency error in recovery, this confuses
  util-linux and has it retry the mount
- fix failure to return error on misaligned dio write; reported as an
  issue with coreutils shred

----------------------------------------------------------------
Jeff Johnson (1):
      bcachefs: add missing MODULE_DESCRIPTION()

Kent Overstreet (19):
      bcachefs: Fix debug assert
      bcachefs: Fix sb-downgrade validation
      bcachefs: Plumb bkey into __btree_err()
      bcachefs: Fix lookup_first_inode() when inode_generations are present
      bcachefs: Fix locking assert
      bcachefs: Refactor delete_dead_snapshots()
      bcachefs: Run check_key_has_snapshot in snapshot_delete_keys()
      bcachefs: Fix setting of downgrade recovery passes/errors
      bcachefs: btree_gc can now handle unknown btrees
      bcachefs: Better fsck error message for key version
      bcachefs: split out sb-members_format.h
      bcachefs: split out sb-downgrade_format.h
      bcachefs: Split out disk_groups_format.h
      bcachefs: Split out replicas_format.h
      bcachefs: Split out journal_seq_blacklist_format.h
      bcachefs: Split out sb-errors_format.h
      bcachefs: Fix uninitialized var warning
      bcachefs: Don't return -EROFS from mount on inconsistency error
      bcachefs: Fix failure to return error on misaligned dio write

Matthew Wilcox (Oracle) (1):
      bcachefs: Use copy_folio_from_iter_atomic()

 fs/bcachefs/backpointers.c                 |   2 +-
 fs/bcachefs/bcachefs.h                     |  44 +----
 fs/bcachefs/bcachefs_format.h              | 195 +------------------
 fs/bcachefs/btree_gc.c                     |  18 +-
 fs/bcachefs/btree_gc.h                     |  44 ++---
 fs/bcachefs/btree_gc_types.h               |  29 +++
 fs/bcachefs/btree_io.c                     |  85 +++++----
 fs/bcachefs/btree_key_cache.c              |  10 +-
 fs/bcachefs/buckets.c                      |   2 +-
 fs/bcachefs/disk_groups_format.h           |  21 ++
 fs/bcachefs/ec.c                           |   2 +-
 fs/bcachefs/fs-io-buffered.c               |   6 +-
 fs/bcachefs/fs-io-direct.c                 |   4 +-
 fs/bcachefs/fs.c                           |  12 +-
 fs/bcachefs/fsck.c                         |  51 ++---
 fs/bcachefs/journal_seq_blacklist_format.h |  15 ++
 fs/bcachefs/mean_and_variance_test.c       |   1 +
 fs/bcachefs/replicas_format.h              |  31 +++
 fs/bcachefs/sb-downgrade.c                 |  13 +-
 fs/bcachefs/sb-downgrade_format.h          |  17 ++
 fs/bcachefs/sb-errors_format.h             | 296 +++++++++++++++++++++++++++++
 fs/bcachefs/sb-errors_types.h              | 281 ---------------------------
 fs/bcachefs/sb-members_format.h            | 110 +++++++++++
 fs/bcachefs/snapshot.c                     |  88 +++++----
 fs/bcachefs/snapshot.h                     |   1 +
 fs/bcachefs/super-io.c                     |  12 +-
 fs/bcachefs/super.c                        |   2 +-
 27 files changed, 706 insertions(+), 686 deletions(-)
 create mode 100644 fs/bcachefs/btree_gc_types.h
 create mode 100644 fs/bcachefs/disk_groups_format.h
 create mode 100644 fs/bcachefs/journal_seq_blacklist_format.h
 create mode 100644 fs/bcachefs/replicas_format.h
 create mode 100644 fs/bcachefs/sb-downgrade_format.h
 create mode 100644 fs/bcachefs/sb-errors_format.h
 create mode 100644 fs/bcachefs/sb-members_format.h
