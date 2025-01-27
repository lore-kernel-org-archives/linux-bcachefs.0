Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2F12907
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951177; cv=none; b=K3M6FmeX8/PGryCpo0DwZ/44TmQmuyVIayDobiV/1bRgBKUzi5gcUyTSsgTuJ/xwKqUOwknr5Lv8UqEnKDXpTvpB0deLlp+31feSoX28xXaTrkpUvF4Ut/VkPM0Vpwu8L3yDN0mVWySx0qEq1t1wxw9nJqp8hDr/kIfUJ5CVkCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951177; c=relaxed/simple;
	bh=sSZI4+VoJt8cUyPSHKnw1itvqpr3tpZqoZxg1bt3A3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h1qs7m8DjSvhM2EVfZmJIKnwxTGryh+gcGYPhrd4HwHXvLgdDJzNIvoY8+mDd8fSid+vxHCBdRE+BnoYtcnmYLLGd7mWqT5UxOKsMM67+nm3O//pinHi5S9+bJAv303ihqYHR6+yMQKTe80SJU6dc6VGUeXX/pM2V+l+NdHTzJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aKQ/xvsP; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aKQ/xvsP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9s6JEEzcp6tcNV6iq7GebJkAH2a38IvGW+DkoXttXVM=;
	b=aKQ/xvsPXjEESg0Y9JV4gXMfjcF18SrCB7b9YBxHiJqaszl+8EMO0G+2IVfW64MMj/U312
	R1YQjbAkmb2WtkOEOo5/wSEbKz2cRTzlw5h+bgX1EgvFGSUOpMTUXXmiz5oABdiCqrfe63
	tS62DSwiTOY/XNXmMHvWG67g+NoHvDY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/11] bcahcefs fixes for rc2
Date: Sun, 26 Jan 2025 23:12:26 -0500
Message-ID: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nothing terribly exciting, things have been stabilizing nicely...

the btree_trans_peek_key_cache fix finishes fixing an oops that I've had
reports of from a few people

'journal stuck timeout' change addresses another source of SRCU lock
hold time warnings; the main remaining one? I'm not seeing it in the CI
anymore with that fix.

'improve journal pin flushing' addresses slow & hanging unmounts

'trace_move_extent_finish' improvement is to help us debug the
'rebalance not making progress' issues

Kent Overstreet (11):
  bcachefs: Fix btree_trans_peek_key_cache()
  bcachefs: Reduce stack frame size of __bch2_str_hash_check_key()
  bcachefs: "Journal stuck" timeout now takes into account device
    latency
  bcachefs: bset_blacklisted_journal_seq is now AUTOFIX
  bcachefs: Improve decompression error messages
  bcachefs: rebalance, copygc enabled are runtime opts
  bcachefs: fix bch2_btree_node_flags
  bcachefs: Improve journal pin flushing
  bcachefs: Journal writes are now IOPRIO_CLASS_RT
  bcachefs: Fix trace_copygc
  bcachefs: Improve trace_move_extent_finish

 fs/bcachefs/btree_cache.c        |   5 +-
 fs/bcachefs/btree_iter.c         |   3 +-
 fs/bcachefs/btree_key_cache.c    |   4 +-
 fs/bcachefs/btree_trans_commit.c |   2 +-
 fs/bcachefs/compress.c           |  31 +++++--
 fs/bcachefs/compress.h           |   4 +-
 fs/bcachefs/data_update.c        |  50 +++++++----
 fs/bcachefs/debug.c              |   1 +
 fs/bcachefs/io_write.c           |   4 +-
 fs/bcachefs/io_write.h           |   2 +
 fs/bcachefs/journal.c            |  92 +++++++-------------
 fs/bcachefs/journal.h            |   9 +-
 fs/bcachefs/journal_io.c         |   2 +
 fs/bcachefs/journal_reclaim.c    | 142 ++++++++++++++++++++++++++-----
 fs/bcachefs/journal_reclaim.h    |   3 +
 fs/bcachefs/journal_types.h      |  13 +--
 fs/bcachefs/movinggc.c           |  11 ++-
 fs/bcachefs/opts.h               |   4 +-
 fs/bcachefs/sb-errors_format.h   |   2 +-
 fs/bcachefs/str_hash.c           |  24 +++---
 fs/bcachefs/trace.h              |  26 +++---
 21 files changed, 275 insertions(+), 159 deletions(-)

-- 
2.45.2

