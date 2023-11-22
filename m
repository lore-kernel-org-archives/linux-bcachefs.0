Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jDpMb3vX"
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAA81B9
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 15:51:22 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700697080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vHBOI/gb4bP4f3pn2dixxtLUAGn+Uu9iktX/uif8nNw=;
	b=jDpMb3vXniSRNiceRApcxGTittUE4JUykbUub21puPF98jZaSg+n+YSIaMLhDk7jIYei8u
	A3qjWKKOSLQPNh5jnrN/+F9bhMlo/+I5B/RB1NT9Tih+aGJ2MWz0CfIppuiG8wxU6bTzgz
	HgHJ+8gka7zN2f3luU3FAwM3hMXzUjw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	peterz@infradead.org
Cc: boqun.feng@gmail.com,
	longman@redhat.com,
	will@kernel.org,
	mingo@redhat.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/6] lockdep enhancements for bcachefs
Date: Wed, 22 Nov 2023 18:51:07 -0500
Message-ID: <20231122235113.180132-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This adds:
 - lockdep_set_no_check_recursion(), which allows lockdep checking for
   bcachefs six locks

bcachefs has a cycle detector for deadlock avoidance; there is no lock
ordering for lockdep to check w.r.t. other btree node locks. However, we
do want held btree node locks to be tracked, and lock ordering to be
checked w.r.t. other locks.

 - lock_class_is_held(), which we use for some extra locking assertion

We want to assert e.g. that we're not blocking on IO with btree node
locks held.

Kent Overstreet (6):
  locking/lockdep: lock_class_is_held()
  locking/lockdep: lockdep_set_no_check_recursion()
  bcachefs: Assert that btree node locks aren't being leaked
  bcachefs: Use lock_class_is_held() for btree locking asserts
  bcachefs: Check for btree locks held on transaction init
  bcachefs: Switch to lockdep_set_no_check_recursion()

 fs/bcachefs/btree_gc.c        |  3 +++
 fs/bcachefs/btree_iter.c      |  2 ++
 fs/bcachefs/btree_locking.c   | 14 ++++++++---
 fs/bcachefs/btree_types.h     |  1 +
 include/linux/lockdep.h       | 10 ++++++++
 include/linux/lockdep_types.h |  2 +-
 kernel/locking/lockdep.c      | 46 +++++++++++++++++++++++++++++++++++
 7 files changed, 73 insertions(+), 5 deletions(-)

-- 
2.42.0

