Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB5A1E376C
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745256375; cv=none; b=XzWu8psO72RMIvS4Sh352jvqs3t/E3nboDg0aNTlhMDES5TymbxwxFNq8yETn3phVMDrl6FdTy4Ls4EQaE+/NfkIDct4mswgm+yIdSVE9UKmJGdEe8nc+pVY9EizzvBr41aZVIROn37cbWSPSGoexVgvNk3g6xUQYV3XdX5nTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745256375; c=relaxed/simple;
	bh=b73IQeqVSXeEuCteEboOl8z9yQadjr4QrRIFp8EIWaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W3ZR9GQkzLwEAbD4jPjeJLDrzasNVVTmuOYd8kXe/1CDi91lHsOVGxZemFNTHx9ucGqz7cglfc48FXRnuR2A4tZqHDmOCB2CG9Da1x6bKHn3kORZcAGZOlqXrBCXBUTUpvL9Y32N9OZ+3xlVIYwushwnMFNBGS44nfhIk2OoyJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q9XnrfQX; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q9XnrfQX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745256371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UWY/5x4OXNc5RfOjLxARF1zs/ala7v6pVKi6wbtQN6U=;
	b=q9XnrfQXIPOjgRID3AfOELNKRugGnLy0HATwRdCVBP8SKV6CdRMSm0IiX4ShrXc+nOMXmB
	MlP/Wqm/Fs/hhosTRyYYOyIHyL8glIHgyB6Nj5vi9dIFxSZMN0pdZLDkawSh8mJH1dN2XI
	Atqi4ExwS6W6rG9609gQRqJJ8NSfIL4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] bcachefs async object debugging
Date: Mon, 21 Apr 2025 13:26:00 -0400
Message-ID: <20250421172607.1781982-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

More debugging infrastructure that might perhaps be of wider interest.

Currently, when an asynchronous op gets stuck and never completes, it's
a real problem to debug: all our normal introspection (e.g.
/proc/pid/stack) doesn't work.

e.g. if a bio doesn't (seem to) complete - what happened to it?
Difficult question to answer. We have giant state machines, and
debugging issues where we stop making forward progress requires
visibility into the whole thing.

(basic question: did the bio complete and the endio not funtion not flip
the correct state bit, or did it get lost?)

In the reports/test failures I look at, I've been seeing these the most
in or at the boundary of mm - compaction/migration, writeback...

This series introduces infrastructure that'll allow us to debug these
kinds of issues in production:

- fast_list, which is a high-enough performance "list" to track these
  kinds of objects (radix tree + percpu buffer)

- infrastructure for making them visible in debugfs, hooking them up to
  pretty printers

- and the last patch hooks into just some of the bcachefs paths where
  we we need this

Kent Overstreet (5):
  bcachefs: bch2_bio_to_text()
  bcachefs: bch2_read_bio_to_text
  bcachefs: fast_list
  bcachefs: Async object debugging
  bcachefs: Make various async objs visible in debugfs

 fs/bcachefs/Kconfig            |   5 ++
 fs/bcachefs/Makefile           |   3 +
 fs/bcachefs/async_objs.c       | 126 +++++++++++++++++++++++++++++
 fs/bcachefs/async_objs.h       |  39 +++++++++
 fs/bcachefs/async_objs_types.h |  24 ++++++
 fs/bcachefs/bcachefs.h         |   7 ++
 fs/bcachefs/btree_io.c         |  12 +++
 fs/bcachefs/btree_io.h         |   8 ++
 fs/bcachefs/data_update.c      |  18 ++++-
 fs/bcachefs/data_update.h      |  15 ++++
 fs/bcachefs/debug.c            |  52 +++++-------
 fs/bcachefs/debug.h            |  18 +++++
 fs/bcachefs/errcode.h          |   1 +
 fs/bcachefs/fast_list.c        | 140 +++++++++++++++++++++++++++++++++
 fs/bcachefs/fast_list.h        |  41 ++++++++++
 fs/bcachefs/io_read.c          |  76 +++++++++++++++---
 fs/bcachefs/io_read.h          |  14 ++++
 fs/bcachefs/super.c            |   3 +
 fs/bcachefs/util.c             |  10 +++
 fs/bcachefs/util.h             |   2 +
 20 files changed, 566 insertions(+), 48 deletions(-)
 create mode 100644 fs/bcachefs/async_objs.c
 create mode 100644 fs/bcachefs/async_objs.h
 create mode 100644 fs/bcachefs/async_objs_types.h
 create mode 100644 fs/bcachefs/fast_list.c
 create mode 100644 fs/bcachefs/fast_list.h

-- 
2.49.0

