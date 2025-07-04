Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8953FD1
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Jul 2025 00:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751589226; cv=none; b=XQbmwNZzJSSKhOOva6+vkUlBb9Od4Dxt5Emvfi46e5plE6RN2YyHn7LRFVowrysL26DfYOGI5VQI/F6umcWWS9ECsw8YvRgt1yRBfFBvovw0tAJvQ1xkigqUr8A6ULi7Ub0LwFuFzqwgn+TimlPpKXUPc6UlQFqG9RE/4QeRTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751589226; c=relaxed/simple;
	bh=SQHumXJp+1vjc9XdMyHv3Z7Kng9W/lq4tdKIObkgl/o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZpFiJhAqufATivcvBFjH4T93DhUOnFEeNhu5RF1+Ex2rlnfWIBAR8d4kFM1YFBH2+Wf7F8j8zR6Ndvb4/EKY6Z9J8Px1nNtqAPHqPViXhYJUsMwQUinplCws/eCwz5LaydtRwyK9d37wEzD7MjMKvXCVE6TE0axFUpp3mdm8OpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ryGIHM8C; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ryGIHM8C"
Date: Thu, 3 Jul 2025 20:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751589212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LrKJgII5vo01us9GWWKMPE5trzfVfwg1PZ6Ps7Y1ju0=;
	b=ryGIHM8CzpBuL237PQstdb0l6bI0RfHyOEEBdRe8qKYJyRIvgEXfNSF74UyTK2HYfFqJ+n
	H2RQKXX8/v1hnCiUDBoYhCG4wjl23KjSU+m30UNDPJtTZfQkNnd9q63aOk4BiS+22fkkEl
	hGjzS7QPb8Y4mxhY5a2Rl3+nINygHCs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.16-rc5
Message-ID: <b3o4rbii2ni4h67fbahnriodyhodomrd6qxdquxkpm2k5sdjmn@hr74xtmqtoeo>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit ef6fac0f9e5d0695cee1d820c727fe753eca52d5:

  bcachefs: Plumb correct ip to trans_relock_fail tracepoint (2025-06-26 00:01:16 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-07-03

for you to fetch changes up to 94426e4201fbb1c5ea4a697eb62a8b7cd7dfccbf:

  bcachefs: opts.casefold_disabled (2025-07-01 19:33:46 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.16-rc5

----------------------------------------------------------------
Alan Huang (1):
      bcachefs: Fix incorrect transaction restart handling

Bharadwaj Raju (1):
      bcachefs: mark invalid_btree_id autofix

Kent Overstreet (3):
      bcachefs: fix btree_trans_peek_prev_journal()
      bcachefs: Work around deadlock to btree node rewrites in journal replay
      bcachefs: opts.casefold_disabled

 fs/bcachefs/bcachefs.h         | 11 +++++++++--
 fs/bcachefs/btree_io.c         | 43 ++++++++++++++++++++++++++++++++++--------
 fs/bcachefs/btree_iter.c       |  2 +-
 fs/bcachefs/dirent.c           | 19 +++++++++----------
 fs/bcachefs/dirent.h           |  3 ++-
 fs/bcachefs/fs.c               |  7 +++----
 fs/bcachefs/fsck.c             |  4 +---
 fs/bcachefs/inode.c            | 13 ++++++++-----
 fs/bcachefs/opts.h             |  5 +++++
 fs/bcachefs/sb-errors_format.h |  2 +-
 fs/bcachefs/str_hash.c         |  5 +++--
 fs/bcachefs/str_hash.h         |  2 --
 fs/bcachefs/super.c            | 31 +++++++++++++++---------------
 13 files changed, 93 insertions(+), 54 deletions(-)
