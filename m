Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C9E14D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912084; cv=none; b=rbuYsnOKkaOZXWwQrVpkZBnO08ZrifV0aQ7Q4+gEUKbXjlPHWvZQPcz2jjf9/n2K2N9y11bUMpHoVmDY3mej+OA+vwZ+/PQvsuagHJVMRBQjkkrmFeJlX+5i4FAuWjfgrkzv7rLeGvKpxYd+juJXH2yO2UbFNoQBHuWB2/bZcgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912084; c=relaxed/simple;
	bh=ZiOioyMud0AlI0CGYsyCYSdKwOKdCMchf+JAWmahlfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrZ+Ox9lAQgzJvSNR3AAReoaLf7mA8hws+1ju0eCcYfjW0UZLqJxTlbL/JwJ20y6xriwsTb+WoKDP6qNT4qQdX3f8avOVODu8GHkNokMsppIzUS9WoXNyIcfpBJpYkyeNLSVqGQkN+rhCam86iuGqi40KDLBP2WuTfaJq4dIT+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 19/34] bcachefs: BCH_FS_recovery_running
Date: Fri, 29 Nov 2024 15:27:18 -0500
Message-ID: <20241129202736.2713679-20-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we're autofixing topology errors, we shouldn't shutdown if we're
still in recovery.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h | 1 +
 fs/bcachefs/error.c    | 2 +-
 fs/bcachefs/recovery.c | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index a85b3bcc6383..d88129503bc5 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -614,6 +614,7 @@ struct bch_dev {
 	x(going_ro)			\
 	x(write_disable_complete)	\
 	x(clean_shutdown)		\
+	x(recovery_running)		\
 	x(fsck_running)			\
 	x(initial_gc_unfixed)		\
 	x(need_delete_dead_snapshots)	\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 9a695322b33c..5b67361b0cf1 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -34,7 +34,7 @@ bool bch2_inconsistent_error(struct bch_fs *c)
 int bch2_topology_error(struct bch_fs *c)
 {
 	set_bit(BCH_FS_topology_error, &c->flags);
-	if (!test_bit(BCH_FS_fsck_running, &c->flags)) {
+	if (!test_bit(BCH_FS_recovery_running, &c->flags)) {
 		bch2_inconsistent_error(c);
 		return -BCH_ERR_btree_need_topology_repair;
 	} else {
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 64bb330eac86..c50dede64785 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -774,6 +774,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		set_bit(BCH_FS_fsck_running, &c->flags);
 	if (c->sb.clean)
 		set_bit(BCH_FS_clean_recovery, &c->flags);
+	set_bit(BCH_FS_recovery_running, &c->flags);
 
 	ret = bch2_blacklist_table_initialize(c);
 	if (ret) {
@@ -925,6 +926,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 	 */
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 	clear_bit(BCH_FS_fsck_running, &c->flags);
+	clear_bit(BCH_FS_recovery_running, &c->flags);
 
 	/* in case we don't run journal replay, i.e. norecovery mode */
 	set_bit(BCH_FS_accounting_replay_done, &c->flags);
-- 
2.45.2

