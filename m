Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6529718B478
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Nov 2024 22:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673146; cv=none; b=Me2GDsbG5pc0JvwqmgWPVmbQezPMN6cWydBzvQg8kHxgz6qfpvlm4zzcYOJEvqM+wyawu1fvSMGnVcTmlYyRWm4GeqVOzhXH35JUNUqltRV4wRg3Z/4++GDAbkfS/GQz9huDnpGTqIBEzkXus4E7OghkLMIZedhj1D6EyZik0WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673146; c=relaxed/simple;
	bh=3LSlVPmkV3weIvOD/mrjxYa84oIi8n12UfUYqFiZuG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmXYvUSeVMYLAXIhaZPvF4AfNh1ydI4DdLrn44cMflpKHyVRNdlJmbCsn3OFV9837l1pO0J6irEZGMbR4iIXdDDwWrmvv+h2POYgXI43MutqY7XE4vkjr3lCBUa2aBzvi3QuU6TsA6sD0qwcSjF5uRbLV+nqgN5CBWqhFFEcvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QjGr86u7; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QjGr86u7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730673142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zl2CK5d5fICepHcsWQ06zBpqJAp2P2q0p7SDhkblb78=;
	b=QjGr86u70eeoEW2NFY/9eAZiMphBrDeSe0fDCK1GSxNNOEPnZGhQd8ds7QYMSzzEjdhjm/
	2BpsyMIbnUJfikC8qZ29rwtE8YHSytLSmrKMoeTPNBxmyeUgNkRz7GRbUqsyiHS60Z4N5y
	MIhDY3X4cW5oNl9eowSBUn+Qd+yrMlI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/5] bcachefs: Ensure BCH_FS_may_go_rw is set before exiting recovery
Date: Sun,  3 Nov 2024 17:32:03 -0500
Message-ID: <20241103223205.176754-6-kent.overstreet@linux.dev>
In-Reply-To: <20241103223205.176754-1-kent.overstreet@linux.dev>
References: <20241103223205.176754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If BCH_FS_may_go_rw is not yet set, it indicates to the transaction
commit path that updates should be done via the list of journal replay
keys.

This must be set before multithreaded use commences.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c        | 7 +++++++
 fs/bcachefs/recovery_passes.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 32d15aacc069..3c7f941dde39 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -862,6 +862,13 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
+	/*
+	 * Normally set by the appropriate recovery pass: when cleared, this
+	 * indicates we're in early recovery and btree updates should be done by
+	 * being applied to the journal replay keys. _Must_ be cleared before
+	 * multithreaded use:
+	 */
+	set_bit(BCH_FS_may_go_rw, &c->flags);
 	clear_bit(BCH_FS_fsck_running, &c->flags);
 
 	/* in case we don't run journal replay, i.e. norecovery mode */
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 735b8adc8f9d..4bbeac9e0526 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -221,6 +221,12 @@ int bch2_run_recovery_passes(struct bch_fs *c)
 {
 	int ret = 0;
 
+	/*
+	 * We can't allow set_may_go_rw to be excluded; that would cause us to
+	 * use the journal replay keys for updates where it's not expected.
+	 */
+	c->opts.recovery_passes_exclude &= ~BCH_RECOVERY_PASS_set_may_go_rw;
+
 	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
 		if (c->opts.recovery_pass_last &&
 		    c->curr_recovery_pass > c->opts.recovery_pass_last)
-- 
2.46.0

