Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9DA20D4E2;
	Sun, 20 Apr 2025 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745164777; cv=none; b=guoB6wVS6jqUGoXFDQv55zbZ0GBlEF8ZHTg0eIEAmiV4IwtZYCzbOqiIrC/1T2pfceTR7eRiv2Y5YXgPGERG4e++WiTuEiclDOF8WeZlUBxPfgrG/gyP7DbwJz9zOJOqipyg7yLeUMGkvlO2Q2h8h+a5TXPXCR6OxiF71uspKgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745164777; c=relaxed/simple;
	bh=wKlUb1F8NTcC7/zZh1idQgWvP2YToURObhBspAhowbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kbbFz7nNXfrEw3V0I2Tg5azfYzm88fskiImxh0eKzvogcNm/VaemQeP1iZuGhwSVAK9ReY11KudzyOKFO1Ox5Mfz4WMosLZVzXo9jzLI3HkwV4uFjjzCKUZ0BQdgVS0StUJst5XmOfdt+XeOf1PM+CSwf4pG3eG+1ldFtT+NYNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ruoCUaXP; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ruoCUaXP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745164764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gm2QNh0cFY4yFUAfxAONi9VjLhZasge2TNMhuJFHdOo=;
	b=ruoCUaXPTeEdySePBFvBGtxHFKlosxmXn/9XRmnQyj5O5/xHzOORJ/WtQkKqS2SeF/in4H
	Vf3DWi8sMI9rHuOtq6d0NoeC8qLSN9vlcNQBLDYeBBHrkFtIc/vz7V2HdkjRiDGGuio/5+
	qDgu/rD1J+B8yLuWICByISY3A0kA0lE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] enumarated refcounts, for debugging refcount issues
Date: Sun, 20 Apr 2025 11:59:13 -0400
Message-ID: <20250420155918.749455-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Not sure we have a list for library code, but this might be of interest
to anyone who's had to debug refcount issues on refs with lots of users
(filesystem people), and I know the hardening folks deal with refcounts
a lot.

In release mode, this is just a wrapper around percpu refcounts.

In debug mode, this provides separate sub-refcounts for each enumerated
user, and provides facilities for printing them.

Meaning, if you're debugging a refcount issue, you no longer have to go
searching through the entire codebase - it'll tell you the exact
codepath.

bcachefs patches are provided as example usage, for other subsystems.

Kent Overstreet (3):
  bcachefs: enumerated_ref.c
  bcachefs: bch_fs.writes -> enumerated_refs
  bcachefs: bch_dev.io_ref -> enumerated_ref

 fs/bcachefs/Makefile                |   1 +
 fs/bcachefs/alloc_background.c      |  41 ++++----
 fs/bcachefs/backpointers.c          |   6 +-
 fs/bcachefs/bcachefs.h              | 105 ++++++++++----------
 fs/bcachefs/btree_gc.c              |   7 +-
 fs/bcachefs/btree_io.c              |  29 +++---
 fs/bcachefs/btree_node_scan.c       |  10 +-
 fs/bcachefs/btree_trans_commit.c    |   5 +-
 fs/bcachefs/btree_update_interior.c |   7 +-
 fs/bcachefs/btree_write_buffer.c    |  11 ++-
 fs/bcachefs/buckets.c               |   4 +-
 fs/bcachefs/debug.c                 |  12 ++-
 fs/bcachefs/ec.c                    |  32 ++++---
 fs/bcachefs/enumerated_ref.c        | 144 ++++++++++++++++++++++++++++
 fs/bcachefs/enumerated_ref.h        |  66 +++++++++++++
 fs/bcachefs/enumerated_ref_types.h  |  19 ++++
 fs/bcachefs/fs-io-direct.c          |   7 +-
 fs/bcachefs/fs-io.c                 |  15 +--
 fs/bcachefs/io_read.c               |  17 ++--
 fs/bcachefs/io_write.c              |  20 ++--
 fs/bcachefs/journal.c               |  10 +-
 fs/bcachefs/journal_io.c            |  15 +--
 fs/bcachefs/journal_reclaim.c       |   2 +-
 fs/bcachefs/reflink.c               |   5 +-
 fs/bcachefs/sb-members.h            |  32 ++++---
 fs/bcachefs/snapshot.c              |   7 +-
 fs/bcachefs/subvolume.c             |   7 +-
 fs/bcachefs/super-io.c              |  18 ++--
 fs/bcachefs/super.c                 | 125 +++++++++++-------------
 fs/bcachefs/super.h                 |   3 +
 fs/bcachefs/sysfs.c                 |  46 ++++-----
 31 files changed, 540 insertions(+), 288 deletions(-)
 create mode 100644 fs/bcachefs/enumerated_ref.c
 create mode 100644 fs/bcachefs/enumerated_ref.h
 create mode 100644 fs/bcachefs/enumerated_ref_types.h

-- 
2.49.0

