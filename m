Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0D427F012
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283705; cv=none; b=HlzsXG1kst5iCbAQnafQCawI5AjtTIwnS4OqeZyAlfz7DfDFkLboKSigGaKiyQPRuuj+Fhzsp5KWGnvYQ6vI+q4zpa3raVZEhL4YcMe2hici4JwvNcwaDwMRZYNJFBCjwh5Uos0XvLHFRJ3scEu7vM6GskEKn2IO7RwReeA4qoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283705; c=relaxed/simple;
	bh=QLXMe5bDMT0v9bnUj8EfNbdcaMkUqjdC/832x9UwtuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAH87nJxwZZlrmr9Nu5q5Kx6xVkJyiVpuLjDAKDfko4yLjZABDDUbVIIGXwHxP4+Ypx3E/U6TLX18ec+XJL1ZyQcwywXxBEIe0n/15BOVs9Xi2oZ+YSss4G63SbHMLVngDClgTKADX3H76OeNYWNRkppzlxXLdC1i/hvWH71cHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GhWWGpL6; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GhWWGpL6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xnVz3P3MWKelrNVpmRit5TYlUTECbnJtCpj1sL89O4=;
	b=GhWWGpL6BgqJVT4BBik8cIIqFAcNVESxqxHeWTCaPFdvcqV5Eb6vzPGHht+Ov3Z7qj4hJY
	ni597nA4rDD/+d4t0LPm6ywjK4jwFTmMtyt7Q2h4kOw7MqW7a31inI5gIL9Nxm1CRA4gdj
	fn8GfV4t6auLfrbrEcYd7ARe7M4Bnts=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 22/37] bcachefs: Call bch2_fs_init_rw() early if we'll be going rw
Date: Wed, 18 Jun 2025 17:54:13 -0400
Message-ID: <20250618215431.738317-23-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kthread creation checks for pending signals, which is _very_ annoying if
we have to do a long recovery and don't go rw until we've done
significant work.

Check if we'll be going rw and pre-allocate kthreads/workqueues.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c        | 10 ++++++++++
 fs/bcachefs/recovery_passes.c |  6 +-----
 fs/bcachefs/recovery_passes.h |  9 +++++++++
 fs/bcachefs/super.c           | 13 +++++++++++--
 fs/bcachefs/super.h           |  1 +
 5 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 37f2cc1ec2f8..fa5d1ef5bea6 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -762,6 +762,16 @@ int bch2_fs_recovery(struct bch_fs *c)
 		c->opts.fsck = true;
 	}
 
+	if (go_rw_in_recovery(c)) {
+		/*
+		 * start workqueues/kworkers early - kthread creation checks for
+		 * pending signals, which is _very_ annoying
+		 */
+		ret = bch2_fs_init_rw(c);
+		if (ret)
+			goto err;
+	}
+
 	mutex_lock(&c->sb_lock);
 	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 	bool write_sb = false;
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 35ac0d64d73a..c2c18c0a5429 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -217,11 +217,7 @@ static int bch2_set_may_go_rw(struct bch_fs *c)
 
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 
-	if (keys->nr ||
-	    !c->opts.read_only ||
-	    !c->sb.clean ||
-	    c->opts.recovery_passes ||
-	    (c->opts.fsck && !(c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)))) {
+	if (go_rw_in_recovery(c)) {
 		if (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)) {
 			bch_info(c, "mounting a filesystem with no alloc info read-write; will recreate");
 			bch2_reconstruct_alloc(c);
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 260571c7105e..2117f0ce1922 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -17,6 +17,15 @@ enum bch_run_recovery_pass_flags {
 	RUN_RECOVERY_PASS_ratelimit	= BIT(1),
 };
 
+static inline bool go_rw_in_recovery(struct bch_fs *c)
+{
+	return (c->journal_keys.nr ||
+		!c->opts.read_only ||
+		!c->sb.clean ||
+		c->opts.recovery_passes ||
+		(c->opts.fsck && !(c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info))));
+}
+
 int bch2_run_print_explicit_recovery_pass(struct bch_fs *, enum bch_recovery_pass);
 
 int __bch2_run_explicit_recovery_pass(struct bch_fs *, struct printbuf *,
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a5b97c9c5163..69c097ff54e7 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -210,7 +210,6 @@ static int bch2_dev_alloc(struct bch_fs *, unsigned);
 static int bch2_dev_sysfs_online(struct bch_fs *, struct bch_dev *);
 static void bch2_dev_io_ref_stop(struct bch_dev *, int);
 static void __bch2_dev_read_only(struct bch_fs *, struct bch_dev *);
-static int bch2_fs_init_rw(struct bch_fs *);
 
 struct bch_fs *bch2_dev_to_fs(dev_t dev)
 {
@@ -794,7 +793,7 @@ static int bch2_fs_online(struct bch_fs *c)
 	return ret;
 }
 
-static int bch2_fs_init_rw(struct bch_fs *c)
+int bch2_fs_init_rw(struct bch_fs *c)
 {
 	if (test_bit(BCH_FS_rw_init_done, &c->flags))
 		return 0;
@@ -1015,6 +1014,16 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts *opts,
 	if (ret)
 		goto err;
 
+	if (go_rw_in_recovery(c)) {
+		/*
+		 * start workqueues/kworkers early - kthread creation checks for
+		 * pending signals, which is _very_ annoying
+		 */
+		ret = bch2_fs_init_rw(c);
+		if (ret)
+			goto err;
+	}
+
 #ifdef CONFIG_UNICODE
 	/* Default encoding until we can potentially have more as an option. */
 	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
index dc52f06cb2b9..e90bab9afe78 100644
--- a/fs/bcachefs/super.h
+++ b/fs/bcachefs/super.h
@@ -46,6 +46,7 @@ void __bch2_fs_stop(struct bch_fs *);
 void bch2_fs_free(struct bch_fs *);
 void bch2_fs_stop(struct bch_fs *);
 
+int bch2_fs_init_rw(struct bch_fs *);
 int bch2_fs_start(struct bch_fs *);
 struct bch_fs *bch2_fs_open(darray_const_str *, struct bch_opts *);
 
-- 
2.50.0

