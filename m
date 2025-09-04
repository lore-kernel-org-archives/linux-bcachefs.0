Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09B23814D
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=L2ptSDrbf7YlViYyIZFhkaSuwvhZd61MavX6F5XQU5FbRpDM+STPM4Oc9VMVNrBnNtkwveW7jUnY52ldCI+MwnfOb2HOXoggoMDHXvmEziqUFUHeyvWQMGt775c/H09WQ3OBu4+Cwtg8xUoa+NlJ1yHAStpuWdTmMhuayPCiSzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=tEilySZIzzg/utCPi/DUhTpiv2r8lWfAh2Lf9phQYvE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nTtuXb4pkOQuKPFe4G/hK7Ay5+iHLDRaSJJkfMpqXNk+B97VV5cM/TbmSNFp9AX0/v5aDQ3ic31LKeVu33fqJswH1gaOKF4UYTXRN8UfiB++hzLOOGgMZ5LqF4Zont8XDAuxHuMkv1+LFt6aGFJSHgwhY8/EW3iGcMEIX8lXKO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+Jp7KWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+Jp7KWp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A77BC4CEF0;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=tEilySZIzzg/utCPi/DUhTpiv2r8lWfAh2Lf9phQYvE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=o+Jp7KWpGXzdYZzh+VH6R/R5a6gTwl5pq8Cx5BuDRC+tHjdURvfvX4agpJt/6Ljcl
	 H+eM00JvghAa1OjC7ns766UucMnuT3MuXFgJM1nX7csVFnpbxRHK20dDhX5BGZjusD
	 TtOn3rotnpIyCTehhrcb9Tbf+dRH0JN8srWhDiaqM9svRiMrjdI93Z2VZjoK0xWomI
	 WBltGtum57qRDj04TXOVp7O0MzjJ2zy5FQAQO9PEHeAX/yTBDEDgrYtdf/sQMgaY5q
	 4sP/l3HvPv9/Evt22Xpn5Hpcr1RDGZcRszE+oMETWSha1riM3fpSuefxL15yIznLYE
	 isJZSSZzCfXqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D5DCA1012;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Subject: [PATCH v3 0/7] Accounting for accurate progress reporting
Date: Thu, 04 Sep 2025 08:20:31 +0300
Message-Id: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ8huWgC/2XNQQqDMBCF4avIrJsSJ1Gjq96jdJHGqQaqkURCi
 3j3RqEguHwD3z8LBPKWAjTZAp6iDdaNaYhLBqbXY0fMtmkDciy4wpI9aZ7Js8m7zlMITImirWW
 phREKkpo8vexnL94fafc2zM5/9wcx367/VnVqxZxxVkmDsqWqVkrfukHb99W4AbZWxKNXZ4/JG
 54gci5qyY9+Xdcf+2bFLO4AAAA=
X-Change-ID: 20250826-better-progress-835d946a3c38
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2624; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=tEilySZIzzg/utCPi/DUhTpiv2r8lWfAh2Lf9phQYvE=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPxx5ddLiR/ipR2x86vXffepjwgOknrt8OnZT+P79
 45MPOI8taOUhUGMi0FWTJHlw5Kvf9ZkWv+xFNprCDOHlQlkCAMXpwBM5KUqw1+xmY3zdPIrFhrF
 2y+fZXHWLPxe1tRUll/3a1vTntzkVBZiZFjDOKlGstP/SrL38aPW9U/KJLayPLFL8Fp8f2tizGG
 NRwwA
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

The first two commits are drive-by fixes/improvements.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
Changes in v3:
- Removed already merged patches
- Fixed a locking issue in do_bch2_trans_commit_to_journal_replay
- Link to v2: https://lore.kernel.org/r/20250828-better-progress-v2-0-c088a2003940@gmail.com

Changes in v2:
- Reordered the format-change-dependent commits to the end
- Added the new metadata version, upgrade and downgrade entries
- Fixed an issue with hidden usage calculation after device removal
- Link to v1: https://lore.kernel.org/r/20250827-better-progress-v1-0-74c24de7988a@gmail.com

---
Nikita Ofitserov (7):
      bcachefs: Fix missing c->usage updates from early recovery
      bcachefs: Fix online hidden (sb+journal) data accounting
      bcachefs: Relax restrictions on the number of accounting counters
      bcachefs: bcachefs_metadata_version_btree_node_accounting
      bcachefs: Use explicit node counts in progress reporting
      bcachefs: Better progress reporting for btree iteration without leaves
      bcachefs: More accurate progress reporting for inner node iteration

 fs/bcachefs/backpointers.c           |  4 +++-
 fs/bcachefs/bcachefs_format.h        |  3 ++-
 fs/bcachefs/btree_gc.c               |  2 +-
 fs/bcachefs/btree_trans_commit.c     |  4 ++++
 fs/bcachefs/buckets.c                | 16 ++++++++++-----
 fs/bcachefs/disk_accounting.c        | 23 ++++++++++++++-------
 fs/bcachefs/disk_accounting.h        | 14 ++++++++-----
 fs/bcachefs/disk_accounting_format.h | 10 ++++++++-
 fs/bcachefs/migrate.c                | 13 ++++++++----
 fs/bcachefs/progress.c               | 39 ++++++++++++++++++++++++++++++------
 fs/bcachefs/progress.h               | 12 ++++++++++-
 fs/bcachefs/sb-downgrade.c           | 11 ++++++++--
 12 files changed, 117 insertions(+), 34 deletions(-)
---
base-commit: 5b7f3db1969892f536be48e082a32095aa86042a
change-id: 20250826-better-progress-835d946a3c38

Best regards,
-- 
Nikita Ofitserov


