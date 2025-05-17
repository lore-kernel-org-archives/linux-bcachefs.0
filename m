Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ECC8248C
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509958; cv=none; b=grVoH1XqkQWm6aFLuGzxzoZqnYC4wzCkcHfsAyombw3Y5hicmo7JbugbF40ptyrjdD/gu0PcNvoh4B4JBd5dnyVOHFT+Dnd28rrsv5b5rTydXzAzT6QlpwLI9tG23rZyZXLIRKYmNqy6AWWBHexwm4dQEzFSbR7FNR/tMmSBze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509958; c=relaxed/simple;
	bh=ie3AXHlFDCHSoKUJHpvtizZzcn3JF4S6M1vyOqx6R4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CcJADqO0qmQ7p+TX6CoCvEyVlGOj4p3YYiA/xEu5C3wL9UulTfm00cy/K3xZDFB41nDMQrzFPj2Zi9DvKD/D4cAKpQBWvEZbD9y8g6NUcljLOd5e+h/9R18fTTLprs/qQ0RmvbZYLZxiPWbbwqmQssLYjOR/kA4hYahYtMwZ3ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dIABG5YX; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dIABG5YX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QROfmqrcbjq8VhOzsEXv5Or2Ckn1cMid9FfCTuFE4tU=;
	b=dIABG5YX5AaYDcA8kB42sme0PaDE6KGCBS0PjNqBVRzjiiOIdfINjJMTZODNWd5/b51z/x
	lMOtzfldNd1S5OPNenwz4u3TBvIDanJMVjUNzziRts8qvtzRXWQACHFJuwVa5bAZf80twR
	us8xLItDnICwYvCy47ao+d+W/3qjZlQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/8] Runtime self healing for missing backpointers
Date: Sat, 17 May 2025 15:25:37 -0400
Message-ID: <20250517192547.3849149-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Post 6.14 upgrade, there have been some reports of copygc spinning
without making any progress, where it turns out it's been attempting to
evacuate buckets with missing backpointers. 

6.14 made backpointers fsck much faster, partly by deferring the "does
this backpointer point to a matching extent" checks until backpointers
are used. This means that bad backpointers that haven't yet been cleaned
up can cause the "sum up backpointers in a bucket to check if we need to
scan for missing backpointers" code to not detect missing backpointers.

Doh.

The solution is to re-run the "do backpointers in a bucket sum up to the
bucket sector counts?" checks _after_ we've walked backpointers in a
bucket at runtime, by codepaths that use backpointer_get_key() - e.g.
move_data_phys. backpointer_get_key() will have then cleaned up bad
backpointers, and if there are any missing backpointers we'll be able to
reliably detect them.

Note that the "do backpointers sum up to bucket sector counts" check is
quite cheap to do at runtime, particularly here where we've just touched
these keys.

Then, if we do detect missing backpointers, we can kick off
check_extents_to_backpointers. This is also much cheaper than it used to
be, since the scan only walks extent -> backpointer for buckets that we
know have missing backpointers.

Most of the patch series is the new infrastructure for running recovery
passes automatically and asynchronously. We'll be using this for more
things in the future, as other recovery passes become online passes -
this is one of the last missing pieces for "full runtime self healing
from anything".

To avoid unfortunate situations where something is triggering a recovery
pass continuously, there's ratelimiting, using the new superblock
section for "runtime, time of last run" for each recovery pass. Copygc
doesn't need to be able to evacuate any given bucket right away, it can
wait until a moderate percentage of buckets have missing backpointers
before kicking it off.

Kent Overstreet (8):
  bcachefs: struct bch_fs_recovery
  bcachefs: __bch2_run_recovery_passes()
  bcachefs: Reduce usage of recovery.curr_pass
  bcachefs: bch2_recovery_pass_status_to_text()
  bcachefs: bch2_run_explicit_recovery_pass() cleanup
  bcachefs: Run recovery passes asynchronously
  bcachefs: Improve bucket_bitmap code
  bcachefs: bch2_check_bucket_backpointer_mismatch()

 fs/bcachefs/alloc_background.c      |  10 +-
 fs/bcachefs/alloc_foreground.c      |   6 +-
 fs/bcachefs/backpointers.c          | 197 +++++++++----
 fs/bcachefs/backpointers.h          |  10 +-
 fs/bcachefs/bcachefs.h              |  23 +-
 fs/bcachefs/btree_cache.c           |   2 +-
 fs/bcachefs/btree_io.c              |   7 +-
 fs/bcachefs/btree_node_scan.c       |   2 +-
 fs/bcachefs/btree_update_interior.c |   2 +-
 fs/bcachefs/buckets.c               |  33 +--
 fs/bcachefs/errcode.h               |   1 -
 fs/bcachefs/error.c                 |   2 +-
 fs/bcachefs/fsck.c                  |   9 +-
 fs/bcachefs/move.c                  |  21 +-
 fs/bcachefs/movinggc.c              |  11 +-
 fs/bcachefs/rebalance.c             |   2 +-
 fs/bcachefs/recovery.c              |  46 ++-
 fs/bcachefs/recovery_passes.c       | 431 ++++++++++++++++++----------
 fs/bcachefs/recovery_passes.h       |  23 +-
 fs/bcachefs/recovery_passes_types.h |  27 ++
 fs/bcachefs/sb-members.c            |   4 +-
 fs/bcachefs/snapshot.c              |   4 +-
 fs/bcachefs/subvolume.c             |   6 +-
 fs/bcachefs/super.c                 |  10 +-
 fs/bcachefs/sysfs.c                 |   6 +
 25 files changed, 579 insertions(+), 316 deletions(-)
 create mode 100644 fs/bcachefs/recovery_passes_types.h

-- 
2.49.0

