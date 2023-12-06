Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M+s0wIND"
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [IPv6:2001:41d0:203:375::b8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890EB8F
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:22 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AH+5UqcUTENRSdtd2h2p+NMPQ5eQ1y6bqzLI6h8XRuA=;
	b=M+s0wINDzXC6QDelqA+dPcy6ZDGpkgqCwLQUfGJhu0OmAB0FqeCBdC1K5TDglzYpbNfpGW
	pkjAlzo+OkgsxyaaUJepgpFR1PQxzuPSwUVw/m0WH7v2C5xyf7lLVUZp5X8MQqyvLFQwgt
	dPJwbMbSoXS5ZaBp5/ptcz+FbdFuPzI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 0/6] [RFC WIP] bcachefs: online fsck
Date: Wed,  6 Dec 2023 15:33:04 -0500
Message-ID: <20231206203313.2197302-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Spent a couple days hacking code with Darrick, and online fsck seems to
be coming _way_ sooner than I expected/realized - various threads coming
together nicely.

What works - most of checking alloc info:

All but the original btree_gc.c code already runs while we're RW, and
various internal processes are actively modifying the filesystem:
copygc, rebalance, the do_discard worker. This means that in particular
the check alloc info passes are already well tested in RW mode with
active use.

There's one known concurrency bug in that part of fsck, which is that we
process gaps in the alloc btree all at once, which is incorrect since we
don't have any way of taking range locks on the key cache, but that bug
doesn't affect online fsck any more than regular fsck.

Still debating how to fix that one, just dropping the "process a gap all
at once" and going back to key-by-key is a serious regression on mkfs
performance on huge filesystems, and fsck performance when the fs is
still mostly empty.

Todo: btree_gc.c

The old btree_gc code used to run while the fs was in use and RW (before
bcachefs was a fs); it was well tested and relied upon then, but the
traversal order meant that it had to block btree topology changes,
effectively any interior btree node update. As filesystems keep getting
bigger that is definitely no longer feasible, so that code will all need
to be reworked and modernized (and possibly split into multiple passes,
i.e. splitting out checking of indirect extent refcounts).

Todo: fsck.c

The passes that check filesystem-level structure were written assuming
the filesystem was not in use and being modified; they use the normal
btree transaction API that handles locking w.r.t. other transactions,
but not "correctly"; they do things like build up state (walking a btree
path, tracking where extents end in different snapshots), but the btree
transactions (trans_begin() -> trans_commit()) are smaller than they
should be to protect that state as they're walking things.

The main reason for this is that currently, there's a fixed limit on the
number of btree_paths (it's a fixed array) in the btree_trans object -
64. I've started looking at lifting that limit and making the array of
paths dynamically growable, and I think that's going to be the way to go
- the alternative would be introducing extra outside locking to all the
filesystem paths that touch that stuff, and we don't want to do that.

Fortunately other developments have happened that make growing the max
btree_paths look a lot more reasonable than when last I was considering
it, and fsck should be a good place for testing that out and seeing what
growing pains we encounter.

other misc todo:
 - the thread_with_file stuff can probably use further cleanup and
   refactoring; also the f_ops we implement needs a .poll() so userspace
   doesn't spin when using O_NONBLOCK

 - ???

 - profit!

Kent Overstreet (6):
  bcachefs: thread_with_file
  bcachefs: Add ability to redirect log output
  bcachefs: Mark recovery passses that are safe to run online
  bcachefs: bch2_run_online_recovery_passes()
  bcachefs: BCH_IOCTL_FSCK_OFFLINE
  bcachefs: BCH_IOCTL_FSCK_ONLINE

 fs/bcachefs/bcachefs.h       |  61 ++++--
 fs/bcachefs/bcachefs_ioctl.h |  24 +++
 fs/bcachefs/chardev.c        | 376 ++++++++++++++++++++++++++++++-----
 fs/bcachefs/opts.h           |   5 +
 fs/bcachefs/recovery.c       |  51 +++--
 fs/bcachefs/recovery.h       |   1 +
 fs/bcachefs/recovery_types.h |  73 +++----
 fs/bcachefs/super.c          |  28 +++
 8 files changed, 506 insertions(+), 113 deletions(-)

-- 
2.42.0

