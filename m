Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1138DD3
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XvqxpSwa"
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bd])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B486A3EB03
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eL7F0RRAVm57qfSnRMW/Yx4ILZqDUZWhPoYYBugk5hI=;
	b=XvqxpSwaUt0QSbsKZZ/uj+yV4e7TB9B3ERIoBrInNEvRZr+lqIJYe+4pvL00nS/qeuzhsj
	RRYDJ3oDu1tbznuEOUsJaQabnPL4qW0jzk3Ws1P8SNhZDpBh+zF1ZA7ay91bqLtrjn3hCg
	XmGrRtyHQnZU8aix5zN5YOlTlaNA4pg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/17] btree write buffer & journal optimizations
Date: Fri, 10 Nov 2023 11:31:37 -0500
Message-ID: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Large stack of changes - performance optimizations and improvements to
related code.

The first big one, killing journal pre-reservations, is already merged:
besides being a performance improvement it turned out to fix a few tests
that were sporadically failing with "journal stuck" - nice. The idea
with that patch is that instead of reserving space in the journal ahead
of time (for journal reservations that must succeed or risk deadlock),
we instead rely on watermarks and tracking which operations are
necessary for reclaim - when we're low on space in the journal and
flushing things for reclaim, we're able to flush things in order, or
track when we're not flushing things in order and allow it to fail

Most of the other patches are prep work leading up to the big btree
write buffer rewrite, which changes the btree write buffer to pull keys
from the journal, instead of having the tranaction commit path directly
add keys to the btree write buffer.

btree write buffer performance is pretty important for multithreaded
update workloads - it's an amdahl's law situation, flushing it is single
threaded. More performance optimizations there would still be
worthwhile, and I've been looking at it because I'm sketching out a
rewrite of disk space accounting (which will allow for per snapshot Id
accounting) that will lean heavily on the btree write buffer.


Kent Overstreet (17):
  bcachefs: Kill journal pre-reservations
  bcachefs: track_event_change()
  bcachefs: Journal pins must always have a flush_fn
  bcachefs: BTREE_INSERT_JOURNAL_REPLAY now "don't init
    trans->journal_res"
  bcachefs: Kill BTREE_UPDATE_PREJOURNAL
  bcachefs: Go rw before journal replay
  bcachefs: Make journal replay more efficient
  bcachefs: Don't flush journal after replay
  bcachefs: Unwritten journal buffers are always dirty
  bcachefs: journal->buf_lock
  bcachefs: bch2_journal_block_reservations()
  bcachefs: Clean up btree write buffer write ref handling
  bcachefs: bch2_btree_write_buffer_flush_locked()
  bcachefs: bch2_btree_write_buffer_flush() ->
    bch2_btree_write_buffer_tryflush()
  bcachefs: Improve btree write buffer tracepoints
  bcachefs: btree write buffer now slurps keys from journal
  bcachefs: Inline btree write buffer sort

 fs/bcachefs/alloc_background.c         |   2 +-
 fs/bcachefs/bcachefs.h                 |  18 +-
 fs/bcachefs/bcachefs_format.h          |   3 +-
 fs/bcachefs/bkey_methods.h             |   2 -
 fs/bcachefs/btree_iter.c               |   2 -
 fs/bcachefs/btree_key_cache.c          |  14 -
 fs/bcachefs/btree_trans_commit.c       | 123 ++----
 fs/bcachefs/btree_types.h              |   4 -
 fs/bcachefs/btree_update.c             |  23 -
 fs/bcachefs/btree_update_interior.c    |  46 +-
 fs/bcachefs/btree_update_interior.h    |   1 -
 fs/bcachefs/btree_write_buffer.c       | 584 +++++++++++++++++--------
 fs/bcachefs/btree_write_buffer.h       |  48 +-
 fs/bcachefs/btree_write_buffer_types.h |  37 +-
 fs/bcachefs/ec.c                       |   2 +-
 fs/bcachefs/errcode.h                  |   2 -
 fs/bcachefs/inode.c                    |  10 +-
 fs/bcachefs/journal.c                  | 120 +++--
 fs/bcachefs/journal.h                  | 102 +----
 fs/bcachefs/journal_io.c               |  57 ++-
 fs/bcachefs/journal_reclaim.c          |  66 +--
 fs/bcachefs/journal_reclaim.h          |   1 +
 fs/bcachefs/journal_types.h            |  40 +-
 fs/bcachefs/move.c                     |   7 +-
 fs/bcachefs/movinggc.c                 |   4 +-
 fs/bcachefs/recovery.c                 | 106 +++--
 fs/bcachefs/super.c                    |   6 +-
 fs/bcachefs/trace.h                    |  42 +-
 fs/bcachefs/util.c                     | 140 +++---
 fs/bcachefs/util.h                     |  33 +-
 30 files changed, 925 insertions(+), 720 deletions(-)

-- 
2.42.0

