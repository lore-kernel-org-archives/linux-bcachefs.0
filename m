Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94F320398
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390598; cv=none; b=tE4n04UKTuKDGC60fYg+XQ1j/KUsGCulJ9FzKXHf7k+ECPY0fnOfue/REZUJ5q3YLksuc0VvfG+LueDpdHMJZDgxMuxp1pbPkdCVC/WQvlwcTCfQDy5T9SKpcpAdGlmuawT1LS0o4UXLhylLwz29Wbg2Yz03G+wUVSCy+qmJtMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390598; c=relaxed/simple;
	bh=tkNzwHQi8Pq+D4A/S+q+RzawiElYViLbNHBom9KO3UU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mXpN2jRqdZ3NtrfhomaYy30WFA3h+lWnA3mDBSCsmQgPaqj3KmNRBIJDGA6s0Jxhq6PD05W/wVXZlXoJx0Zqi9MeQkXawk/kdWjvlo1hFWJCEY/XUgD2osaST+nu+j8R6J2BilP4HDsTV/QHH785jXigY5k+4iOq9qhc0VfGgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rg3p7G7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rg3p7G7I"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFEB7C4CEFB;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=tkNzwHQi8Pq+D4A/S+q+RzawiElYViLbNHBom9KO3UU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rg3p7G7IsymBqMfEBzfkUq8xob/tuB3EVEmYgB5a6yXhjhed8s3Jn9OF0USIUcEIZ
	 kJ63AaTaiiq+HyiyjTI4NeOoYG6cfSuOeqwUd5AIHKl6IIn9C71Ts0p0Vt4A0w6yxE
	 L0TtoPRVylbL5bOJq5TXEU4VWDrNaGPF/o9/ajAjuaT5gp41TYVl1Vh4rHFjtKCPHb
	 wZkgkbtyncxH3OROiJiIi7WGedf8hED43bOX3x4Zdz0kzdButnsY+g35pdua+W6bd4
	 DM7h43i/PPHzXOV8Zji8a/UOMejGonWTzX4ZtjyGUjzFF46BNjoMWJcepJoS4Td1r7
	 QZRMMpr+f7VQA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80B9CA0FF7;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:17 +0300
Subject: [PATCH v2 15/15] bcachefs: More accurate progress reporting for
 inner node iteration
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-15-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2418; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=2Gi9QvTlP0kPo5mlJKbmm3EH65uDXG8So4G6gHv9ydM=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDmUeLl6j+bDX7lqgc9W/A1oTlmk+IvpQb0r54ZFJ
 /gNlW+ldZSyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJOC5i+KeS3lPjLxyeE3G/
 98+03y9zTlXeNm/dwx7zrNnI+EjL+n+MDF8FORrjsv4/OPN8T5r5kjsr3p/1c6mIvz3No8wn7sK
 CaQwA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/backpointers.c |  4 +++-
 fs/bcachefs/btree_gc.c     |  2 +-
 fs/bcachefs/migrate.c      | 13 +++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 0d585e5662be3f02580558e9a590075ea73193d5..42370aebb7a442ee368df323eb1f4970f2e5f949 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -804,7 +804,9 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	struct progress_indicator_state progress;
 	int ret = 0;
 
-	bch2_progress_init(&progress, trans->c, BIT_ULL(BTREE_ID_extents)|BIT_ULL(BTREE_ID_reflink));
+	bch2_progress_init_inner(&progress, trans->c,
+		btree_has_data_ptrs_mask,
+		~0ULL);
 
 	for (enum btree_id btree_id = 0;
 	     btree_id < btree_id_nr_alive(c);
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2338feb8d8ed4bad85a01a6b9181116d918636b5..c04e88ec5c0ac73c21f01db597b19d1b0c798299 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -780,7 +780,7 @@ static int bch2_gc_btrees(struct bch_fs *c)
 	int ret = 0;
 
 	struct progress_indicator_state progress;
-	bch2_progress_init(&progress, c, ~0ULL);
+	bch2_progress_init_inner(&progress, c, ~0ULL, ~0ULL);
 
 	enum btree_id ids[BTREE_ID_NR];
 	for (unsigned i = 0; i < BTREE_ID_NR; i++)
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 4aa7dd483cab5a400974b5824bfaf0c0af2e9331..d67ca56d3f431980b104ea5528cce79be88f93fb 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -266,10 +266,15 @@ int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsig
 int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx, unsigned flags)
 {
 	struct progress_indicator_state progress;
+	int ret;
+
 	bch2_progress_init(&progress, c,
-			   BIT_ULL(BTREE_ID_extents)|
-			   BIT_ULL(BTREE_ID_reflink));
+			   btree_has_data_ptrs_mask & ~BIT_ULL(BTREE_ID_stripes));
+
+	if ((ret = bch2_dev_usrdata_drop(c, &progress, dev_idx, flags)))
+		return ret;
+
+	bch2_progress_init_inner(&progress, c, 0, ~0ULL);
 
-	return bch2_dev_usrdata_drop(c, &progress, dev_idx, flags) ?:
-		bch2_dev_metadata_drop(c, &progress, dev_idx, flags);
+	return bch2_dev_metadata_drop(c, &progress, dev_idx, flags);
 }

-- 
2.50.1


