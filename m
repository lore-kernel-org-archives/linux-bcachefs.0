Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0A1A01B9
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 02:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749780655; cv=none; b=VszOssQgHYviCD54fR91nCzoHbNhh6/vnHBe359XFnFQ2HLPJpX2SA9qDSurw7pVsSh/ifmpneNNXZj50p7aP35qr0cT8C748N9Bpe7LhxOrOUZ0QTtos6jLStINS41gpW6KQUYqzdbXHw1sm/ddv0ZiQFUBSgkw8Brpd9Be1tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749780655; c=relaxed/simple;
	bh=AASYvjJY+a+e63K9/2ymTSWXr0lIeyAHE2bIYsoyJFY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XX+n1OBlQc1RWxNGICVH5CUQLN3u/bWC8B0iCiTuHLNC+L+z8Xb03gmfC7j/l64fEvmADDbmE9ZGfwUq072/rvMy5Vsn/cAq4sB6DD9psi047XEMp3qg4r8/B8VgVBbNZ9NJwWNUpoXpJuinuu4l9A5ohELcB9RKrMqroes7tIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vr3g1N1K; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vr3g1N1K"
Date: Thu, 12 Jun 2025 22:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749780651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YGhHosSHDbMOkNnQE2jm7PRGL2uaPimeOOlGmR/awso=;
	b=Vr3g1N1KHgEFvMhIUVkRQEqdhn4oBEPmGM/L3eveCLY8rEOqdLk1V93imqfPm6sxuZuBOT
	MNq97cuUXSker50b7j+CVZaAvrTp114OsLjTL+wTOiaHCv+yKU1x+km75wkNYd4glfrlNH
	rkmddDn8PAtMseaDz5S44/UwGl2oNEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.16-rc2
Message-ID: <oxjgqivjmn43zo5dj2u43u432gmfexxjc6xxqcig5jovna3fe3@youegmmszsip>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-06-12

for you to fetch changes up to aef22f6fe7a630d536f9eaa0a7a2ed0f90ea369e:

  bcachefs: Don't trace should_be_locked unless changing (2025-06-11 23:25:41 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.16-rc2

As usual, highlighting the ones users have been noticing:

- Fix a small issue with has_case_insensitive not being propagated on
  snapshot creation; this led to fsck errors, which we're harmless
  because we're not using this flag yet (it's for overlayfs +
  casefolding).

- Log the error being corrected in the journal when we're doing fsck
  repair: this was one of the "lessons learned" from the i_nlink 0 ->
  subvolume deletion bug, where reconstructing what had happened by
  analyzing the journal was a bit more difficult than it needed to be.

- Don't schedule btree node scan to run in the superblock: this fixes a
  regression from the 6.16 recovery passes rework, and let to it running
  unnecessarily.

  The real issue here is that we don't have online, "self healing" style
  topology repair yet: topology repair currently has to run before we go
  RW, which means that we may schedule it unnecessarily after a
  transient error. This will be fixed in the future.

- We now track, in btree node flags, the reason it was scheduled to be
  rewritten. We discovered a deadlock in recovery when many btree nodes
  need to be rewritten because they're degraded: fully fixing this will
  take some work but it's now easier to see what's going on.

  For the bug report where this came up, a device had been kicked RO due
  to transient errors: manually setting it back to RW was sufficient to
  allow recovery to succeed.

- Mark a few more fsck errors as autofix: as a reminder to users, please
  do keep reporting cases where something needs to be repaired and is
  not repaired automatically (i.e. cases where -o fix_errors or fsck -y
  is required).

- rcu_pending.c now works with PREEMPT_RT

- 'bcachefs device add', then umount, then remount wasn't working - we
  now emit a uevent so that the new device's new superblock is correctly
  picked up

- Assorted repair fixes: btree node scan will no longer incorrectly
  update sb->version_min,

- Assorted syzbot fixes

----------------------------------------------------------------
Alan Huang (1):
      bcachefs: Fix possible console lock involved deadlock

Arnd Bergmann (1):
      bcachefs: ioctl: avoid stack overflow warning

Kent Overstreet (21):
      bcachefs: Add missing restart handling to check_topology()
      bcachefs: Log fsck errors in the journal
      bcachefs: Add range being updated to btree_update_to_text()
      bcachefs: Add more flags to btree nodes for rewrite reason
      bcachefs: Update /dev/disk/by-uuid on device add
      bcachefs: Mark need_discard_freespace_key_bad autofix
      bcachefs: Only run 'increase_depth' for keys from btree node csan
      bcachefs: Read error message now prints if self healing
      bcachefs: Don't persistently run scan_for_btree_nodes
      bcachefs: mark more errors autofix
      bcachefs: Make sure opts.read_only gets propagated back to VFS
      bcachefs: Don't put rhashtable on stack
      bcachefs: Fix downgrade_table_extra()
      bcachefs: Fix rcu_pending for PREEMPT_RT
      bcachefs: Fix leak in bch2_fs_recovery() error path
      bcachefs: Don't pass trans to fsck_err() in gc_accounting_done
      bcachefs: Fix version checks in validate_bset()
      bcachefs: Don't trust sb->nr_devices in members_to_text()
      bcachefs: Print devices we're mounting on multi device filesystems
      bcachefs: Ensure that snapshot creation propagates has_case_insensitive
      bcachefs: Don't trace should_be_locked unless changing

 fs/bcachefs/bcachefs.h              |  1 -
 fs/bcachefs/btree_gc.c              | 95 +++++++++++++++++++++++--------------
 fs/bcachefs/btree_io.c              | 26 +++++++---
 fs/bcachefs/btree_locking.c         |  2 +-
 fs/bcachefs/btree_locking.h         |  6 ++-
 fs/bcachefs/btree_types.h           | 29 +++++++++++
 fs/bcachefs/btree_update_interior.c | 33 ++++++++++++-
 fs/bcachefs/btree_update_interior.h |  7 +++
 fs/bcachefs/chardev.c               |  4 +-
 fs/bcachefs/disk_accounting.c       |  4 +-
 fs/bcachefs/error.c                 |  5 +-
 fs/bcachefs/fs.c                    |  8 ++++
 fs/bcachefs/io_read.c               | 11 ++++-
 fs/bcachefs/io_read.h               |  1 +
 fs/bcachefs/movinggc.c              | 22 +++++----
 fs/bcachefs/namei.c                 | 10 ++++
 fs/bcachefs/rcu_pending.c           | 22 ++++-----
 fs/bcachefs/recovery.c              | 27 ++++++++---
 fs/bcachefs/recovery_passes.c       | 14 ++++--
 fs/bcachefs/sb-downgrade.c          |  5 +-
 fs/bcachefs/sb-errors_format.h      | 10 ++--
 fs/bcachefs/sb-members.c            | 34 +++++++++++--
 fs/bcachefs/super.c                 | 47 ++++++++++++------
 fs/bcachefs/util.c                  | 10 +---
 fs/bcachefs/util.h                  |  2 +-
 25 files changed, 319 insertions(+), 116 deletions(-)
