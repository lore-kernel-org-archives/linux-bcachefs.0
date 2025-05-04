Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056801DF98B
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 May 2025 19:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746388336; cv=none; b=EXf0EYYcrsr27PYGpmqfcnCasvhEn5tnXRLQ2UHMd1jJ7olvS6XAKl5Ke3PHP9+Y0wHPWVTW1HcNb///ObQ+QArmTsu6/hcBt/sFYMpHea5PPh7Ur/iulNmdG2CbDp1Z1mkjs+4Lev0YLCiLMd3O93NKZDGykkPN6jUoovUfdS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746388336; c=relaxed/simple;
	bh=/895FQEZorwGqq6iNyLyNRZv5w2vfn1omG7NTQJV80U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwXcpU5gW7TzS32m/eX8BO3djwVKph68MGiJc2lus2vmFwMR8w2THVmndXJ+7tJrlWUeq71/O7JpLbreGzX3MNOpELxU/xNm6vo0FSGKo03IZVTIdCAk72C9ZEIYVDq5UZfj/jb6fpaBdvd4BYbPFpmh+7QZkIrLFQwo8rznSdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=klC9jWHa; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="klC9jWHa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746388331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpWIlkpu6YCtARZsMlSNeAomJkcf/0xQNFgvarHbtEs=;
	b=klC9jWHa80vVBY+YYwNOEtlmNWbxsPAoGd24eWKrOudSXOjKrcfUJ0yZCLAHmkhd0W9d7k
	WfiIIwhMXMGNhcijKEgMCO+gYdNqQB+j68Gwlr+yeBcEKjqMKm6ahCkSsN8gURXJzBBiXd
	/vYEsvQQgjjSLBbu6yG83PMBeHAb/nk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: bcachefs_metadata_version_fast_device_removal
Date: Sun,  4 May 2025 15:51:59 -0400
Message-ID: <20250504195202.2073437-4-kent.overstreet@linux.dev>
In-Reply-To: <20250504195202.2073437-1-kent.overstreet@linux.dev>
References: <20250504195202.2073437-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fast device removal, that uses backpointers to find pointers to the
device being removed instead of a full metadata scan.

This requires BCH_SB_MEMBER_DELETED_UUID, which is an incompatible
change - hence the version number bump. We don't fully trust
backpointers, so we don't want to reuse device indexes until after a
fsck has verified that there aren't any pointers to removed devices.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  3 ++-
 fs/bcachefs/super.c           | 25 ++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 0beff6af7ecf..baaf9786238b 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -696,7 +696,8 @@ struct bch_sb_field_ext {
 	x(stripe_lru,			BCH_VERSION(1, 23))		\
 	x(casefolding,			BCH_VERSION(1, 24))		\
 	x(extent_flags,			BCH_VERSION(1, 25))		\
-	x(snapshot_deletion_v2,		BCH_VERSION(1, 26))
+	x(snapshot_deletion_v2,		BCH_VERSION(1, 26))		\
+	x(fast_device_removal,		BCH_VERSION(1, 27))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 35b07410a8c6..18d8823cdb79 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1719,6 +1719,8 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 {
 	struct bch_member *m;
 	unsigned dev_idx = ca->dev_idx, data;
+	bool fast_device_removal = !bch2_request_incompat_feature(c,
+					bcachefs_metadata_version_fast_device_removal);
 	int ret;
 
 	down_write(&c->state_lock);
@@ -1737,11 +1739,24 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 
 	__bch2_dev_read_only(c, ca);
 
-	ret = bch2_dev_data_drop(c, ca->dev_idx, flags);
-	bch_err_msg(ca, ret, "bch2_dev_data_drop()");
+	ret = fast_device_removal
+		? bch2_dev_data_drop_by_backpointers(c, ca->dev_idx, flags)
+		: bch2_dev_data_drop(c, ca->dev_idx, flags);
 	if (ret)
 		goto err;
 
+	/* Check if device still has data */
+	struct bch_dev_usage usage = bch2_dev_usage_read(ca);
+	for (unsigned i = 0; i < BCH_DATA_NR; i++)
+		if (!data_type_is_empty(i) &&
+		    !data_type_is_hidden(i) &&
+		    usage.buckets[i]) {
+			bch_err(ca, "Remove failed: still has data (%s, %llu buckets)",
+				__bch2_data_types[i], usage.buckets[i]);
+			ret = -EBUSY;
+			goto err;
+		}
+
 	ret = bch2_dev_remove_alloc(c, ca);
 	bch_err_msg(ca, ret, "bch2_dev_remove_alloc()");
 	if (ret)
@@ -1805,7 +1820,11 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 	 */
 	mutex_lock(&c->sb_lock);
 	m = bch2_members_v2_get_mut(c->disk_sb.sb, dev_idx);
-	memset(&m->uuid, 0, sizeof(m->uuid));
+
+	if (fast_device_removal)
+		m->uuid = BCH_SB_MEMBER_DELETED_UUID;
+	else
+		memset(&m->uuid, 0, sizeof(m->uuid));
 
 	bch2_write_super(c);
 
-- 
2.49.0

