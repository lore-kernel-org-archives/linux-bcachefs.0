Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721F228CA9
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505700; cv=none; b=JaAfIfWdElIYINkEDg0xOgQSoNfFr3peTjqxYrKtQ/eArOPJCUAJzmefgSIXx/2OzVVbwIiH1xvw4uYcMw8YD1BYrd5Q3mrAL7JIo4EImCWg1TYgQ/9FO2v5GOvb29+3RY9S3H11mE2hOWaly9OkcUyDdYNTbXNkJN6NBh8oYzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505700; c=relaxed/simple;
	bh=pZmcpUEz1u85/pZV3idy9GGG5RbYrdKnxscApsrl/nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGXxnlB2WZ39XpFxiflfqylWd2pmrQavSBU/tWXwA/RecDA8vQShvkPmkZx4J3LyIPbNdIKlIFOSmmK6cJusGmSFuQWIEzNq0LC+NoCqFaSq3Ql5osL5lLwEHMGeZDIl4rxq1nHcqSZZE3ixOKfcqHvxBB8jxAY/hDgdkhQ25QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vbAlD5lU; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vbAlD5lU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq5O8w7caek8lJJcukknUOXemltlSf2TCHpqZe+C0xY=;
	b=vbAlD5lUbvR87heZKkJO6DaxEwSgYb+fcmzPJEeM6rQoyhtoczWyS61grfK34rXJKMvxsy
	8OXO+Ag0qY+KqPI8OkMVWwIdRCQNAoOU3LBAaK5BbRWcgdwZyWYNHxWqxGZSKASNv314JA
	0A/fCyqsZvTzIkH0hT0CKs7iKJzUS1U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/5] bcachefs: Filesystem discard option now propagates to devices
Date: Thu, 20 Mar 2025 17:21:23 -0400
Message-ID: <20250320212125.3359155-6-kent.overstreet@linux.dev>
In-Reply-To: <20250320212125.3359155-1-kent.overstreet@linux.dev>
References: <20250320212125.3359155-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

the discard option is special, because it's both a filesystem and a
device option.

When set at the filesytsem level, it's supposed to propagate to (if set
persistently via sysfs) or override (if non persistently as a mount
option) the devices - that now works correctly.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 15 ++++++++++++++-
 fs/bcachefs/bcachefs.h         |  3 ++-
 fs/bcachefs/fs.c               |  3 +++
 fs/bcachefs/sysfs.c            |  9 +++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 4dfcf3e6fffd..54e0cc373bb1 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1806,6 +1806,19 @@ struct discard_buckets_state {
 	u64		discarded;
 };
 
+/*
+ * This is needed because discard is both a filesystem option and a device
+ * option, and mount options are supposed to apply to that mount and not be
+ * persisted, i.e. if it's set as a mount option we can't propagate it to the
+ * device.
+ */
+static inline bool discard_opt_enabled(struct bch_fs *c, struct bch_dev *ca)
+{
+	return test_bit(BCH_FS_discard_mount_opt_set, &c->flags)
+		? c->opts.discard
+		: ca->mi.discard;
+}
+
 static int bch2_discard_one_bucket(struct btree_trans *trans,
 				   struct bch_dev *ca,
 				   struct btree_iter *need_discard_iter,
@@ -1869,7 +1882,7 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 		s->discarded++;
 		*discard_pos_done = iter.pos;
 
-		if (ca->mi.discard && !c->opts.nochanges) {
+		if (discard_opt_enabled(c, ca) && !c->opts.nochanges) {
 			/*
 			 * This works without any other locks because this is the only
 			 * thread that removes items from the need_discard tree
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 0ea593e813f4..f52311017aee 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -627,7 +627,8 @@ struct bch_dev {
 	x(topology_error)		\
 	x(errors_fixed)			\
 	x(errors_not_fixed)		\
-	x(no_invalid_checks)
+	x(no_invalid_checks)		\
+	x(discard_mount_opt_set)	\
 
 enum bch_fs_flags {
 #define x(n)		BCH_FS_##n,
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 17ac9c55fb96..4453dd2f888e 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2172,6 +2172,9 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	if (ret)
 		goto err;
 
+	if (opt_defined(opts, discard))
+		set_bit(BCH_FS_discard_mount_opt_set, &c->flags);
+
 	/* Some options can't be parsed until after the fs is started: */
 	opts = bch2_opts_empty();
 	ret = bch2_parse_mount_opts(c, &opts, NULL, opts_parse->parse_later.buf);
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index e8a795578186..251ba8224c1f 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -664,6 +664,15 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 	    c->copygc_thread)
 		wake_up_process(c->copygc_thread);
 
+	if (id == Opt_discard && !ca) {
+		mutex_lock(&c->sb_lock);
+		for_each_member_device(c, ca)
+			opt->set_member(bch2_members_v2_get_mut(ca->disk_sb.sb, ca->dev_idx), v);
+
+		bch2_write_super(c);
+		mutex_unlock(&c->sb_lock);
+	}
+
 	ret = size;
 err:
 	up_write(&c->state_lock);
-- 
2.49.0

