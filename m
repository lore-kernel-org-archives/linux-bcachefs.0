Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF552D3EC0
	for <linux-bcachefs@vger.kernel.org>; Fri, 11 Jul 2025 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752238929; cv=none; b=d7TVPJoluVnLT9ekjLJMDUdxFUmrYASynXsKIxxHCVMzxPOnR8sISx1McKn+aV6tgE0St7YsIRdqqRHW10i+M+DBfWtojp+ZvzObg69GOEJ+2dRmJqHUFbTN6RrG0NSJi82CcR5b1SfZvDDykRMP2MpxI1rfQdzIzodQzplHAMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752238929; c=relaxed/simple;
	bh=kaHpIrjthIMGw2TBEO1IrXfDZC1hZusz0sJu/um5pRg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L7AppgKNuff23knGdw0AuKJSQnYRkHC9vFxT3tdHW1Rr+TXKF6Bt93S3FOrkPwR8NIa7w6cNfPxTq2Kj87b0AZa840plXWeqsMV8l4fbq/0K4UA91PdyBWh2aeZ7AvWrXyQBWbrxvs0AjFXF3I7ctCTuhBsvtv6KH9OK5AEFYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OmYJ6K1Z; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OmYJ6K1Z"
Date: Fri, 11 Jul 2025 09:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752238913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Gwn/uM09PhMoKe21jSonSM0ZWV8k8BCb3km4eW+IlO8=;
	b=OmYJ6K1ZDMIByYcXvLJiEu8bmh/4AXez3IKKaQuCuDHMu4iuNer8/LjUdHG4eyuRCxMN75
	zCBDAqG17UPH9944D6gGeFygK3IVL3fdq31NaSRcva2hekl9tg1KHfFxt2l1IwGsA+z3Fx
	76hwoUzY8zxSzR0qFGQHsoiAKptXdEQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.16-rc6
Message-ID: <hmihnrl4tzezjnhp56c7eipq5ntgyadvy6uyfxgytenqfbzzov@swfpjfb2qkw5>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT


The following changes since commit 94426e4201fbb1c5ea4a697eb62a8b7cd7dfccbf:

  bcachefs: opts.casefold_disabled (2025-07-01 19:33:46 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-07-11

for you to fetch changes up to fec5e6f97dae5fbd628c444148b77728eae3bb93:

  bcachefs: Don't set BCH_FS_error on transaction restart (2025-07-08 15:24:15 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.16-rc6

----------------------------------------------------------------
Kent Overstreet (10):
      bcachefs: bch2_fpunch_snapshot()
      bcachefs: Fix bch2_io_failures_to_text()
      bcachefs: Fix btree for nonexistent tree depth
      bcachefs: Tweak btree cache helpers for use by btree node scan
      bcachefs: btree node scan no longer uses btree cache
      bcachefs: btree read retry fixes
      bcachefs: Fix bch2_btree_transactions_read() synchronization
      bcachefs: Don't schedule non persistent passes persistently
      bcachefs: Fix additional misalignment in journal space calculations
      bcachefs: Don't set BCH_FS_error on transaction restart

 fs/bcachefs/btree_cache.c     | 26 +++++++-------
 fs/bcachefs/btree_cache.h     |  1 +
 fs/bcachefs/btree_io.c        |  8 ++---
 fs/bcachefs/btree_node_scan.c | 84 +++++++++++++++++++++----------------------
 fs/bcachefs/debug.c           | 11 ++++--
 fs/bcachefs/errcode.h         |  1 -
 fs/bcachefs/error.c           |  6 ++--
 fs/bcachefs/extents.c         | 16 ++++-----
 fs/bcachefs/fsck.c            | 33 ++++-------------
 fs/bcachefs/io_misc.c         | 27 ++++++++++++++
 fs/bcachefs/io_misc.h         |  2 ++
 fs/bcachefs/journal_reclaim.c |  6 ++++
 fs/bcachefs/recovery.c        | 23 ++++++++----
 fs/bcachefs/recovery_passes.c |  2 +-
 14 files changed, 138 insertions(+), 108 deletions(-)
