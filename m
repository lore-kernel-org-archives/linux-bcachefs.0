Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4001953AD
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 21:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747342820; cv=none; b=TolLC0700GzBVNmVydObaYMnpshSD4LUghBOvHvlkfwrq6lz4b294U1pz5BgIola1WJiSm2O5OHozPhjASFs8oS2y1MwfZG6Ld4xlYsUCuf5vQNubJeHqJ2k+vy/GxX0zcc2mukCBSlZHAd83TFJq7UiAfclNgqcZLxHQzHtdMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747342820; c=relaxed/simple;
	bh=aUxZ1sVHnSoUqzLt/UGwPofaAYd0lM/6ZlFSeuH4kDU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K27uQld0+FMjZpHyCDbIEAsYwStAW4AW8vkbCFQNgieBLxVCMGPw32PryZxq0C3/qzKO7U54eeh9J60qgPm1xoX/gaEnqX1Jq1eZcXKdYFtRUdRWIyIS0WiQj2Fa3IX6JldYwV1iCV+GVB9+7KmRzYekCYoLkqplY7ZVo+4sUwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CjRPjFMJ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CjRPjFMJ"
Date: Thu, 15 May 2025 17:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747342814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6FYNwq0NzkVileKreHYNyrcAEBMpC0kZeoc70azx1Nk=;
	b=CjRPjFMJyB2tR6z6IhkoQZJkgBxgg/9E3TuZg/24EA0iDMHjTFb0r0TnkwOc3Go3RV3Sg0
	Ezk6kRNvgyF9M2TKpBDErOfmGD6xvP1cRrWgpdQXmYQg8vFOi9b5qujYjk0wvBw+R+nQS3
	E5lvDiFcwTP1EwmKsiXKBa7mllOsJbs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.15-rc7
Message-ID: <2xklzlq5qc54lhpq7qnp5p6ou4kc56mglrvwg6omwd4gsz4mjg@da4pvcv3v5aj>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit 8e4d28036c293241b312b1fceafb32b994f80fcc:

  bcachefs: Don't aggressively discard the journal (2025-05-07 17:10:10 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-05-15

for you to fetch changes up to 9c09e59cc55cdf7feb29971fd792fc1947010b79:

  bcachefs: fix wrong arg to fsck_err() (2025-05-14 18:59:15 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.15-rc7

The main user reported ones are:

- Fix a btree iterator locking inconsistency that's been causing us to
  go emergency read-only in evacuate: "Fix broken btree_path lock
  invariants in next_node()"

- Minor btree noed cache reclaim tweak that should help with OOMs: don't
  set btree nodes as accessed on fill

- Fix a bch2_bkey_clear_rebalance() issue that was causing rebalance to
  do needless work

----------------------------------------------------------------
Alan Huang (1):
      bcachefs: Fix self deadlock

Kent Overstreet (8):
      bcachefs: Don't strip rebalance_opts from indirect extents
      bcachefs: Fix broken btree_path lock invariants in next_node()
      bcachefs: Fix livelock in journal_entry_open()
      bcachefs: Don't set btree nodes as accessed on fill
      bcachefs: Fix set_should_be_locked() call in peek_slot()
      bcachefs: Fix accidental O(n^2) in fiemap
      bcachefs: Fix missing commit in backpointer to missing target
      bcachefs: fix wrong arg to fsck_err()

 fs/bcachefs/backpointers.c    | 117 ++++++++++++++++++++++++++++--------------
 fs/bcachefs/btree_cache.c     |   9 ++--
 fs/bcachefs/btree_iter.c      |  22 +++++---
 fs/bcachefs/disk_accounting.c |  17 +++++-
 fs/bcachefs/disk_accounting.h |  16 ++++--
 fs/bcachefs/fs.c              |   4 +-
 fs/bcachefs/fsck.c            |   2 +-
 fs/bcachefs/journal_reclaim.c |  17 ++++--
 fs/bcachefs/rebalance.c       |   2 +-
 9 files changed, 140 insertions(+), 66 deletions(-)
