Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B3C15AAD6
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153010; cv=none; b=Ux5/nCEiGdMCtH1IwBXQrX2/RylRJJ0unBQtdiYSwZDJ9wDLg/j622zLgfplyFkOUy9Hw1LOXh0qMHz5iFCE+mY0ImbIE3a8tNhdxUu9RdU2WaI6lsj1fLM+oWHfYxYdM6+9BTmyjsvu7p+IAiBfgi3XjxIwsCHbJUnliIYu/sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153010; c=relaxed/simple;
	bh=yCtEnSzT7le1Bo2lN4IaWIUs79OKvrVeO9xfS6L9PME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ey6JjPnNVEbjQtT8JaHt1lyLZSNe6cPwwWbQs0jo95Pz2sr9cofigUqREO47ohXxz/uF1UZrqcHWLAqfI3fMvY5WSZaP5jhNxDB2JnO5lVwkav2WpEFYZaHrMcoMJVUBkttx4FPtaUos0WhftHejvCbNuJE4VQGFDNxETxBROZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CjQvMQP7; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CjQvMQP7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LO8637Se1Q8C4mKvEkUmNkcsBXGDwsDN/b2s4YU6DbA=;
	b=CjQvMQP7txuJTzGS4r33a8EjXcg6prmnrTpFHUz3wNaJ3CpZCGE7+SLaD95tgkVMNEIKnv
	A2ohfwBksfp5PwWjiRv/5KXi/336HW0M7X81CfXo1RPri6fbXn58BZUZ6ySzUD4ntXpBlP
	a7qmHNz6urXy9Ntd40NTAw/sEgpEL/I=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] Fixes for snapshots + unlink
Date: Sat,  5 Oct 2024 14:29:47 -0400
Message-ID: <20241005182955.1588763-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The handling of unlinked files with snapshots was a bit fubar -
especially if an unlinked file was then reattached in a newer snapshot.
This adds an inode flag so that we can track when an inode should, or
should not be deleted due to snapshots, when a newer snapshot still
refers to data in an unlinked file.

Kent Overstreet (5):
  bcachefs: Split out check_unreachable_inodes() pass
  bcachefs: reattach_inode() now correctly handles interior snapshot
    nodes
  bcachefs: btree_iter_peek_upto() now handles BTREE_ITER_all_snapshots
  bcachefs: Delete vestigal check_inode() checks
  bcachefs: bcachefs_metadata_version_inode_has_child_snapshots

 fs/bcachefs/bcachefs_format.h       |   3 +-
 fs/bcachefs/btree_iter.c            |   6 +-
 fs/bcachefs/btree_iter.h            |   8 +
 fs/bcachefs/fs.c                    |  21 +-
 fs/bcachefs/fs.h                    |   9 +-
 fs/bcachefs/fsck.c                  | 377 +++++++++++++++++-----------
 fs/bcachefs/fsck.h                  |   1 +
 fs/bcachefs/inode.c                 | 233 ++++++++++++++---
 fs/bcachefs/inode.h                 |  10 +
 fs/bcachefs/inode_format.h          |   3 +-
 fs/bcachefs/recovery_passes_types.h |   1 +
 fs/bcachefs/sb-downgrade.c          |   5 +-
 fs/bcachefs/sb-errors_format.h      |   4 +-
 13 files changed, 482 insertions(+), 199 deletions(-)

-- 
2.45.2

