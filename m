Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463B120330
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930775; cv=none; b=d8Vo3PWES6NDkQSkqHdXV+ARwOuridUJq4NgruR3tJiT4NUnTgZU5OzroWFiOrCE6mikt0xCxEn44/8jWyIOAdyIR/CAmh5uYAl/Px8wC1vgy4EidXXtj9xcFlrqRoYVIK/SjheN6fWaOQInbaubJ/mq+YQL97Nrhu/AHhBM+S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930775; c=relaxed/simple;
	bh=d4Gznby+wwct5ldwJRrbGIqZPj88fBm9c9gqMZC+su8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ix6BeUl26v2yk89pCD84oST5AMqrjfOt2TpCMXeF9iBWjhmS0+Yfwt71uBLxvm+aSoHJGWaX1bENMCk9/4/jSldX0I5UiMwXmpVwO2Ikx3Px1e4WXRlYv3mBM8peq6QT47YvbUEJjk1q19gKqeazbPOmAtwBdgnuwATgCNQm2KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j9E/ZmIE; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j9E/ZmIE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=35VDex5q73ktTr6Agr48ofOqrCak8b/+4E/16fJparc=;
	b=j9E/ZmIEwtYMaFh664+cDVUAmx3B0oTUGc0T/nzzf1P1gd+C2LfP/MgHAC/GWOYwuJVFLL
	+pEHv2PwrMWPvUf9dXX7SDCThQEvwvRdwXISKL1Hqj1Doxm7t0WVzIa6mM1Zbe74oVydRN
	Aj+cQTksa0xdozwiQpVrDC2wU4ZJ1XU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/8] new on disk format versions, backpointers fsck scalability
Date: Fri, 29 Nov 2024 20:39:12 -0500
Message-ID: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

- the sort order of disk accounting keys was screwed up, making disk
  accounting read way more expensive than it needs to be

  this is an expensive forced version upgrade, but necessary because we
  now have counters for every inode for tracking fragmentation - we
  can't be scanning all of those at startup time

backpointers fsck has been the limiting factor on fsck scalability:
checking every extent <-> backpointer reference inherently doesn't
scale, since the references we follow do nearly random cross-btree
access so we have to pin in ram, or run in multiple passes.

so:

- change bch_backpointer to include the bucket generation number

  with this, we can sum up backpointers in a bucket and check against
  the bucket sector counts to determine if there's missing backpointers;
  we need the generation number to avoid counting stale backpointers
  since the backpointers btree uses the btree write buffer (updates are
  much faster, reads are always potentially stale).

  having done so, we can mark out a bitmap and then only check extents
  -> backpointers references for those specific buckets.

for backpointers -> extents, those checks can be deferred until when the
backpointer is used: the overall self healing project is "run fsck
check/repair code at runtime whenever appropriate", so with that done we
can switch that pass to only run in debug mode.

Kent Overstreet (8):
  bcachefs: bcachefs_metadata_version_backpointer_bucket_gen
  bcachefs: bcachefs_metadata_version_disk_accounting_big_endian
  bcachefs: bch2_extent_ptr_to_bp() no longer depends on device
  bcachefs: kill __bch2_extent_ptr_to_bp()
  bcachefs: check_extents_to_backpointers() now only checks buckets with
    mismatches
  bcachefs: Add write buffer flush param to backpointer_get_key()
  bcachefs: bch2_backpointer_get_key() now repairs dangling backpointers
  bcachefs: Only run check_backpointers_to_extents in debug mode

 fs/bcachefs/backpointers.c          | 394 +++++++++++++++++++++-------
 fs/bcachefs/backpointers.h          |  32 +--
 fs/bcachefs/bcachefs.h              |   2 +
 fs/bcachefs/bcachefs_format.h       |   7 +-
 fs/bcachefs/btree_cache.c           |   1 -
 fs/bcachefs/buckets.c               |  10 +-
 fs/bcachefs/disk_accounting.c       |  25 +-
 fs/bcachefs/disk_accounting.h       |  25 +-
 fs/bcachefs/ec.c                    |  14 +-
 fs/bcachefs/errcode.h               |   1 +
 fs/bcachefs/move.c                  |   8 +-
 fs/bcachefs/recovery_passes_types.h |  92 ++++---
 fs/bcachefs/sb-downgrade.c          |  26 +-
 fs/bcachefs/sb-errors_format.h      |   4 +-
 fs/bcachefs/util.h                  |   9 +
 15 files changed, 452 insertions(+), 198 deletions(-)

-- 
2.45.2

