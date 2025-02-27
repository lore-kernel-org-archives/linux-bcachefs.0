Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1A13A1BA
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Feb 2025 00:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616657; cv=none; b=SDYeyYlBQnbGOq43Sb1o5HZ2h+2adNMh1OnqLQpnoDZ0LLZg7DkLOEDhVc1lBexd788/EqKq1XwovNsWCrbomu7lTe/Fn0Aq7gQG9ks1+5tzdchbDyubCS5sPj1SjRaJ0HpK8pKbLm/1oWI6Rw4kybtLosCPbvDXD2fOYjVsdmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616657; c=relaxed/simple;
	bh=4oR8/akrv9h99E5/0q46DrQwOgYl3Aj5OIoGH8fu7ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QNTiGVEIjte2ekA8zuWlusoJ2sTAjUodFRCzMNhKtMRIIPAPsRQokutfue/XO/xpICs3ObGQZxyinHTb/YMXSw2l6NAvvWXMoSULW7a3oMgXPDScYhQygwXOGEudGRU9akYE7Ss2VB/f5+98ix7Lt1LTIguwv9bIprM9CeZT8Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhCSHvPU; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhCSHvPU"
Date: Wed, 26 Feb 2025 19:37:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740616649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=8r7ZBWen2aHvNkU/gKusFsPhdVjQwKX/sY5JWKex0t8=;
	b=VhCSHvPUyGXE3MdpKB5c2Wm5RiQWHTmE85ttyz//taG++KnRsGN/TTAyQggL5DJoUVx87W
	LgaRXcxfZ9KDmZ1Qv6U/07Hdxw7lEjVHo/pAIfUimRyXscDgroNlW2b4klFRfw2wCLLeJh
	zYUh1/Dk2/smbftEOOHpMkqE38CwaWE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.14-rc5
Message-ID: <6xhke7esvj47xpl6ylxtcz5b2ol2ckwup2q3yunjo6zudthrtm@emmsdk3bpusy>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT


The following changes since commit b04974f759ac7574d8556deb7c602a8d01a0dcc6:

  bcachefs: Fix srcu lock warning in btree_update_nodes_written() (2025-02-19 18:52:42 -0500)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-02-26

for you to fetch changes up to eb54d2695b57426638fed0ec066ae17a18c4426c:

  bcachefs: Fix truncate sometimes failing and returning 1 (2025-02-26 19:31:05 -0500)

----------------------------------------------------------------
bcachefs fixes for 6.14-rc5

Couple small ones, the main user visible changes/fixes are:

- Fix a bug where truncate would rarely fail and return 1

- Revert the directory i_size code: this turned out to have a number of
  issues that weren't noticed because the fsck code wasn't correctly
  reporting errors (ouch), and we're late enough in the cycle that it
  can just wait until 6.15.

----------------------------------------------------------------
Alan Huang (2):
      bcachefs: Fix memmove when move keys down
      bcachefs: Fix deadlock

Kent Overstreet (5):
      bcachefs: print op->nonce on data update inconsistency
      bcachefs: fix bch2_extent_ptr_eq()
      bcachefs: Revert directory i_size
      bcachefs: Check for -BCH_ERR_open_buckets_empty in journal resize
      bcachefs: Fix truncate sometimes failing and returning 1

 fs/bcachefs/btree_cache.c     |  9 +++++----
 fs/bcachefs/btree_io.c        |  2 +-
 fs/bcachefs/btree_key_cache.c |  2 +-
 fs/bcachefs/btree_locking.c   |  5 +++--
 fs/bcachefs/btree_locking.h   |  2 +-
 fs/bcachefs/data_update.c     |  1 +
 fs/bcachefs/dirent.h          |  5 -----
 fs/bcachefs/extents.h         |  2 +-
 fs/bcachefs/fs-common.c       | 11 -----------
 fs/bcachefs/fs-io.c           |  1 +
 fs/bcachefs/fsck.c            | 21 ---------------------
 fs/bcachefs/journal.c         |  4 +++-
 fs/bcachefs/sb-downgrade.c    |  5 +----
 fs/bcachefs/six.c             |  5 +++--
 fs/bcachefs/six.h             |  7 ++++---
 15 files changed, 25 insertions(+), 57 deletions(-)
