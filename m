Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BD247DE1
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=TtkB2SV+o0x0E2blpL29yX2WmEOKtmrORiOVdCKZNZlko3t7OM1IqiqCDts5lQ76g1eruFRoYmuvHKA9cpjg91ZtL+8YkNIgBBmGGqrk709doJfHsa6HVX8dGvxhJPJyLccpr3hS9/ynMSsM3FWUimvGNxgyxaWisLd7lDcUylM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=sd+aLu9t3h6P3San180B4CXgz1i7bJ3bA8mbF9L5qao=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=eqPju5rNCAcV6Pgmt1LRVGETCIMIQwUUghf09LSOBpdlCSitkD/zd8BKvW23zViNDhUAwQCe4IM3+wFzj93K9nx7N8KAZA+W6wUEQJI+OpfyEDQCPA2y/fRd1ueqTn5acbpQ1da37cEvzhtzmkVRKm8KVdmuwx55pIHvKqXyC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nG99aqbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nG99aqbf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED162C4CEED;
	Thu, 28 Aug 2025 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=sd+aLu9t3h6P3San180B4CXgz1i7bJ3bA8mbF9L5qao=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=nG99aqbfCfJG+Lhfmt/g62lqIMxsOA0PpO6vGFORzJS8vQAi/w6tCFzw/++7NQJYd
	 4RsyxkUktywJstteVFGSm6AO/tKgynxYsm5Aqop8KPqgmr7to5HWyI7NnVzOx+wkRx
	 ecuTGrUQ4F19Wdm/pOU1jg/mTTB27b802wMzEMxz3XuZdgv1YC4GMpyO9QjRfZTx6u
	 BMfo0IpURhYkRUDJGaYaGB4C2DiCjnOLnvxqem+V3rhx/1/QGFFkKWBWA1qjXkY8Bm
	 Q1GllBvSvsTc2hwop4zo4QYolvHkrY+0aJ/b/c6zVZJ2QwXkovGfxWjFGe+vurvJC0
	 LNnjw0qwDPogw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CEBCA0FFB;
	Thu, 28 Aug 2025 14:16:36 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Subject: [PATCH v2 00/15] Accounting for accurate progress reporting
Date: Thu, 28 Aug 2025 17:16:02 +0300
Message-Id: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKNksGgC/2WNyw6CMBBFf4XM2ppSHi2u/A/DopaxTCKUTAnRk
 P67lcSVy3OSe+4OEZkwwqXYgXGjSGHOoE4FuNHOHgUNmUFJ1UijWnHHdUUWCwfPGKMwVTN0dWs
 rVxnIq4XxQa+jeOszjxTXwO/jYCu/9tfSf62tFFLo2ql6QN0ZY69+svQ8uzBBn1L6AFruW+quA
 AAA
X-Change-ID: 20250826-better-progress-835d946a3c38
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3158; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=sd+aLu9t3h6P3San180B4CXgz1i7bJ3bA8mbF9L5qao=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDm41e/upH8r3HVa19xP+idxt0Zj4vpvfdxb9W79P
 j5T86HJjo5SFgYxLgZZMUWWD0u+/lmTaf3HUmivIcwcViaQIQxcnAIwkR3VDH/48pW5HUSObuBP
 T15zwEh3qWTg4W4rjWndPFUWBpNnbC9j+J92ZIb/7WtNTncNzD81dhntujbbmJlxevJ3qaBpQW2
 5MgwA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

This patch series introduces new per-btree accounting counters and uses
them for (hopefully) accurate progress reporting in recovery passes.
Also includes various assorted bugfixes.

The commit "Relax restrictions on the number of accounting 
counters" is optional, but will likely greatly improve the 
upgrade/tools version mismatch experience. Without it, all bree usage 
accounting will be thrown out and rebuilt on any version mismatch.

The commit "bcachefs_metadata_version_btree_node_accounting"
introduces the format change along with upgrade/downgrade table entries.

The first ten commits are drive-by fixes/improvements, especially 
"Improve check_allocations pass speed not in fsck", which should make
future accounting upgrades much faster (including this one).

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
Changes in v2:
- Reordered the format-change-dependent commits to the end
- Added the new metadata version, upgrade and downgrade entries
- Fixed an issue with hidden usage calculation after device removal
- Link to v1: https://lore.kernel.org/r/20250827-better-progress-v1-0-74c24de7988a@gmail.com

---
Nikita Ofitserov (15):
      bcachefs: Introduce btree_leaf_has_triggers_mask
      bcachefs: Refactor bch2_gc_btree/bch2_gc_btrees
      bcachefs: Improve check_allocations pass speed when not in fsck
      bcachefs: Refactor/rename btree_type_has_ptrs
      bcachefs: Fix progress reporting for unknown btrees
      bcachefs: Partially fix old device removal with unknown btrees
      bcachefs: Fix missing c->usage updates from early recovery
      bcachefs: Optimize/fix bch2_dev_usage_remove
      bcachefs: Fix online hidden (sb+journal) data accounting
      bcachefs: Fix outdated documentation comment
      bcachefs: Relax restrictions on the number of accounting counters
      bcachefs: bcachefs_metadata_version_btree_node_accounting
      bcachefs: Use explicit node counts in progress reporting
      bcachefs: Better progress reporting for btree iteration without leaves
      bcachefs: More accurate progress reporting for inner node iteration

 fs/bcachefs/alloc_background.c       |  2 +-
 fs/bcachefs/backpointers.c           |  6 ++--
 fs/bcachefs/bcachefs_format.h        |  4 +--
 fs/bcachefs/btree_gc.c               | 28 ++++++++++-----
 fs/bcachefs/btree_trans_commit.c     |  3 ++
 fs/bcachefs/btree_types.h            | 11 +++---
 fs/bcachefs/buckets.c                | 16 ++++++---
 fs/bcachefs/disk_accounting.c        | 70 ++++++++++++++++++++++++++----------
 fs/bcachefs/disk_accounting.h        | 16 +++++----
 fs/bcachefs/disk_accounting_format.h | 10 +++++-
 fs/bcachefs/migrate.c                | 18 ++++++----
 fs/bcachefs/move.c                   |  2 +-
 fs/bcachefs/progress.c               | 41 +++++++++++++++++----
 fs/bcachefs/progress.h               | 12 ++++++-
 fs/bcachefs/sb-downgrade.c           | 11 ++++--
 15 files changed, 184 insertions(+), 66 deletions(-)
---
base-commit: 753b29cc79897dd7f776fa09654196f5b25f8b96
change-id: 20250826-better-progress-835d946a3c38

Best regards,
-- 
Nikita Ofitserov


