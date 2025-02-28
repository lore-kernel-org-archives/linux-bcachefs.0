Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E9323F38C
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Feb 2025 21:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776503; cv=none; b=sgIUxYPVuhgsCrkUZ3fp6YWOSkdMFnDG/mKg/meEemjfKRubgavzjBG+Su2MklYSe93uZ5vRe+wfdTtWmzVzz94Z8FXJY0kDiuxOs1mBo2dWj5VFQxfDcfsTZONy3g+37AtqAYn5qxDcImqzU6dBj0jj+pLU5WsxZ/6Ro2pD0og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776503; c=relaxed/simple;
	bh=EBYY53aM4Bq/qROOGLqBpbOmYoBYVG4eSNMmw0o1Cu0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=USiK50WJ6H6u1NDn2BvuMO3wOcM7zPJ8/xsX1K1r07IjMfsY+Ew3pNs/+cfxtq2j9MXmWKizyVWdW0ES4Z19QjNBTaGVX0fektOTDsOj49WejXfX5vKJLFH6HWWvzGqpyyvOtFhlevNzCsEa46cNjpXckmwRFEAQ2i6VxTAZESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qw73rYW9; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qw73rYW9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740776497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gTGCLvxVr+rO35mSwTRoMPma8uED/FKA1yroojFvUGk=;
	b=Qw73rYW9M3lqsGyKbhLtvztNXi7VLsZ+zfKUHpInEZC0hfskU/+xLHXw4rbg6WroOMUZdh
	plZ04KJd4bxPyUOSzg7BtgBZEYX4YhRPMOYyrf/26iaNPB8qjWXvA4E04Zz8K0CCFnPe3O
	EBlyEh9CCSdYpRRMZczopTZf1uJmUOI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH] bcachefs: Don't set BCH_FEATURE_incompat_version_field unless requested
Date: Fri, 28 Feb 2025 16:01:20 -0500
Message-ID: <20250228210120.144386-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We shouldn't be setting incompatible bits or the incompatible version
field unless explicitly request or allowed - otherwise we break mounting
with old kernels or userspace.

Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super-io.c | 25 +++++++++++++++++--------
 fs/bcachefs/super-io.h | 11 ++++-------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 877edc9efb15..000c283f6504 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -69,14 +69,21 @@ enum bcachefs_metadata_version bch2_latest_compatible_version(enum bcachefs_meta
 	return v;
 }
 
-void bch2_set_version_incompat(struct bch_fs *c, enum bcachefs_metadata_version version)
+int bch2_set_version_incompat(struct bch_fs *c, enum bcachefs_metadata_version version)
 {
-	mutex_lock(&c->sb_lock);
-	SET_BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb,
-		max(BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb), version));
-	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_FEATURE_incompat_version_field);
-	bch2_write_super(c);
-	mutex_unlock(&c->sb_lock);
+	int ret = (c->sb.features & BIT_ULL(BCH_FEATURE_incompat_version_field)) &&
+		version <= c->sb.version_incompat_allowed;
+
+	if (!ret) {
+		mutex_lock(&c->sb_lock);
+		SET_BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb,
+			max(BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb), version));
+		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_FEATURE_incompat_version_field);
+		bch2_write_super(c);
+		mutex_unlock(&c->sb_lock);
+	}
+
+	return ret;
 }
 
 const char * const bch2_sb_fields[] = {
@@ -1210,9 +1217,11 @@ void bch2_sb_upgrade(struct bch_fs *c, unsigned new_version, bool incompat)
 	c->disk_sb.sb->version = cpu_to_le16(new_version);
 	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 
-	if (incompat)
+	if (incompat) {
 		SET_BCH_SB_VERSION_INCOMPAT_ALLOWED(c->disk_sb.sb,
 			max(BCH_SB_VERSION_INCOMPAT_ALLOWED(c->disk_sb.sb), new_version));
+		c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_FEATURE_incompat_version_field);
+	}
 }
 
 static int bch2_sb_ext_validate(struct bch_sb *sb, struct bch_sb_field *f,
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index 6158b2cd5a1c..167dd98f893e 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -21,17 +21,14 @@ static inline bool bch2_version_compatible(u16 version)
 void bch2_version_to_text(struct printbuf *, enum bcachefs_metadata_version);
 enum bcachefs_metadata_version bch2_latest_compatible_version(enum bcachefs_metadata_version);
 
-void bch2_set_version_incompat(struct bch_fs *, enum bcachefs_metadata_version);
+int bch2_set_version_incompat(struct bch_fs *, enum bcachefs_metadata_version);
 
 static inline int bch2_request_incompat_feature(struct bch_fs *c,
 						enum bcachefs_metadata_version version)
 {
-	if (unlikely(version > c->sb.version_incompat)) {
-		if (version > c->sb.version_incompat_allowed)
-			return -BCH_ERR_may_not_use_incompat_feature;
-		bch2_set_version_incompat(c, version);
-	}
-	return 0;
+	return likely(version <= c->sb.version_incompat)
+		? 0
+		: bch2_set_version_incompat(c, version);
 }
 
 static inline size_t bch2_sb_field_bytes(struct bch_sb_field *f)
-- 
2.47.2

