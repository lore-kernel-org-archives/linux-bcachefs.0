Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6178C15B0FE
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226175; cv=none; b=h+7UCtENdGPJVvMtdQWJxyUDoxE4IQjyRYVxsfNyG20rqBOJeqXXBT/9Qgyd1+0mwGATUa9HgqPgQSwRYRW2SD3/wxz+as4jFVFAisQb94c9BpB/K0Cd6vLQBSYXC7Jk0mSubY3sVxRnmrjzXHdaNhgRXjmbsakXIxjwkkbceok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226175; c=relaxed/simple;
	bh=sqi1YdWk+9POB3fKfpFloYsSdgBv0Mtv8JRjlLQky7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YfhWnMvZop/tyOZmqobdVJVXeQJBFseetHgeO8Rf6qpBR20X+j9OdCxoz/YcAo/dyJ9j+9qjzdNAGm3xHOttRjFYqAOVuzLGm7ylgHhj347MH5s1gM7rDitkQ1ie7zGUfpF39IQa+vsckxZZgcefTp0NsiCx40kXlZWcc3IFuqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nw21b9nD; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nw21b9nD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/qEd1KDQkb6sMNtMzQL7ycIkN7+JDuDJ/aXkKa/uZPw=;
	b=nw21b9nDmXo3EMniMFanIK2fsUvO9eDvcujZmUG/nkMCyxkZWlp/r+SrH0Jn9pcguk8/mm
	J5XiVkLmCfwt2Z2rAKgAbuxUjN52+ZlMdv+R1RsL1B9Q9u8CKLrPFsUZsKFJkhr4K/xD39
	wnCAYCTMySslSsu98XA1dKagNDX/CxQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/9] transaction restart handling fixes
Date: Fri, 18 Oct 2024 00:35:50 -0400
Message-ID: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I just started doing automated testing with transaction restarts
randomly injected, and that's been shaking out a few bugs. Here's fixes
for most of them:

Kent Overstreet (9):
  bcachefs: fix restart handling in bch2_rename2()
  bcachefs: fix bch2_hash_delete() error path
  bcachefs: fix restart handling in bch2_fiemap()
  bcachefs: fix missing restart handling in bch2_read_retry_nodecode()
  bcachefs: fix restart handling in bch2_do_invalidates_work()
  bcachefs: fix restart handling in bch2_alloc_write_key()
  bcachefs: fix restart handling in __bch2_resume_logged_op_finsert()
  bcachefs: handle restarts in bch2_bucket_io_time_reset()
  bcachefs: Don't use commit_do() unnecessarily

 fs/bcachefs/alloc_background.c      | 37 ++++++++++++++++-------------
 fs/bcachefs/alloc_foreground.c      |  2 +-
 fs/bcachefs/btree_gc.c              | 12 +++++++++-
 fs/bcachefs/btree_io.c              |  2 +-
 fs/bcachefs/btree_iter.h            |  2 ++
 fs/bcachefs/btree_update.c          |  4 ++--
 fs/bcachefs/btree_update.h          |  2 +-
 fs/bcachefs/btree_update_interior.c |  4 +---
 fs/bcachefs/disk_accounting.c       |  6 +++--
 fs/bcachefs/ec.c                    | 18 +++++++-------
 fs/bcachefs/fs.c                    | 16 +++++--------
 fs/bcachefs/fsck.c                  |  2 +-
 fs/bcachefs/inode.c                 |  3 +--
 fs/bcachefs/io_misc.c               |  2 +-
 fs/bcachefs/io_read.c               |  8 +++----
 fs/bcachefs/io_write.c              |  4 ++--
 fs/bcachefs/quota.c                 |  2 +-
 fs/bcachefs/rebalance.c             |  4 +++-
 fs/bcachefs/recovery.c              |  2 +-
 fs/bcachefs/str_hash.h              |  7 ++++--
 fs/bcachefs/subvolume.c             |  7 +++---
 fs/bcachefs/super.c                 |  2 +-
 fs/bcachefs/tests.c                 |  4 ++--
 fs/bcachefs/xattr.c                 |  2 +-
 24 files changed, 85 insertions(+), 69 deletions(-)

-- 
2.45.2

