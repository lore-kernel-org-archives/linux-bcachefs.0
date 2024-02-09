Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6A4C61
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Feb 2024 01:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441304; cv=none; b=R87PcoOZxoM/pRF1efoEbpMILL3PBVnxmAVG97bKJwNx4jyFxTvFmLH0Zzv/bJswQ273/wfSnPLzGtDVbhUgPzs3CHgIZzGYkcRPae0mKW1RPNn0Vv29xSTV0CzouUcqivuX3oCSyY7QwWAAVhEqH2yAcDUMjr/PGjhN/LxSuxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441304; c=relaxed/simple;
	bh=I74qNCNhSreLNW+mYNwoQ/ToNtGoMYC5nKBXJQwn+GM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IgA2nLW4lL9SJSdD4nLi2fsVUWqu1n4GsCKhYLtQCRn9G8byBFxxv8ctEntv3Ax6JTL34OD8yVJRNwQJAG3ksNSR9HlYPiYrMIkCuAsbcQ334TBMxulOSIFahRSuGUGrhe7GDERTb61k5y0w1iAexCjaIgVVt9xeGQZFg2DvWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fM8cqtJ9; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fM8cqtJ9"
Date: Thu, 8 Feb 2024 20:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707441298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=mIxdzPWyKD9wWhNpC+Vouu4n1L4gGXqIV3g6Ttx09jc=;
	b=fM8cqtJ9LtRwO5E1oGrh7DOM9/GT1DHRBm/uDgVMdIQ5exmq+sFQS5icI+eOiRj6PSVZKo
	rj8r8F6ks7sBGup/Jp6CuNIg3CCb/+0bwhaMypTDFgcRjXavXTpgOVAf2EpBas9Ck0AFod
	6gXeLkUwKXVrskSh9iKYb9UimnF3VVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: [GIT PULL] bcachefs stable updates for v6.7
Message-ID: <6yl6zvu2pa3mz7irsaax5ivp6kh3dae5kaslvst7yafmg6672g@mskleu2vjfp2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Greg, few stable updates for you -

Cheers,
Kent

The following changes since commit 0dd3ee31125508cd67f7e7172247f05b7fd1753a:

  Linux 6.7 (2024-01-07 12:18:38 -0800)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-for-v6.7-stable-20240208

for you to fetch changes up to f1582f4774ac7c30c5460a8c7a6e5a82b9ce5a6a:

  bcachefs: time_stats: Check for last_event == 0 when updating freq stats (2024-02-08 15:33:11 -0500)

----------------------------------------------------------------
bcachefs updates for v6.7 stable:

locking fixes in subvolume create, destroy paths - Al, Su Yue, Guoyu Ou
fix race in thread_with_file - Mathias Krause
small rebalance fixes - Daniel, myself
workaround for building with old clang (can't take a pointer to memcmp)
build fix on parisc
minor time_stats fix

----------------------------------------------------------------
Al Viro (2):
      new helper: user_path_locked_at()
      bch2_ioctl_subvolume_destroy(): fix locking

Christoph Hellwig (1):
      bcachefs: fix incorrect usage of REQ_OP_FLUSH

Daniel Hill (1):
      bcachefs: rebalance should wakeup on shutdown if disabled

Guoyu Ou (1):
      bcachefs: unlock parent dir if entry is not found in subvolume deletion

Helge Deller (1):
      bcachefs: Fix build on parisc by avoiding __multi3()

Kent Overstreet (4):
      bcachefs: Don't pass memcmp() as a pointer
      bcachefs: Add missing bch2_moving_ctxt_flush_all()
      bcachefs: bch2_kthread_io_clock_wait() no longer sleeps until full amount
      bcachefs: time_stats: Check for last_event == 0 when updating freq stats

Mathias Krause (1):
      bcachefs: install fd later to avoid race with close

Su Yue (2):
      bcachefs: kvfree bch_fs::snapshots in bch2_fs_snapshots_exit
      bcachefs: grab s_umount only if snapshotting

 fs/bcachefs/chardev.c           |  3 +--
 fs/bcachefs/clock.c             |  4 ++--
 fs/bcachefs/fs-io.c             |  2 +-
 fs/bcachefs/fs-ioctl.c          | 42 +++++++++++++++++++++--------------------
 fs/bcachefs/journal_io.c        |  3 ++-
 fs/bcachefs/mean_and_variance.h |  2 +-
 fs/bcachefs/move.c              |  2 +-
 fs/bcachefs/move.h              |  1 +
 fs/bcachefs/rebalance.c         | 13 +++++++++++--
 fs/bcachefs/replicas.c          | 10 ++++++++--
 fs/bcachefs/snapshot.c          |  2 +-
 fs/bcachefs/util.c              |  5 +++--
 fs/namei.c                      | 16 +++++++++++++---
 include/linux/namei.h           |  1 +
 14 files changed, 68 insertions(+), 38 deletions(-)
