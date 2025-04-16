Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0858122087
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810793; cv=none; b=DwdrOGGa6An4VvlTGi6XmJXDD69jwqJKLfG3gVNup35hNN8SdMHNvTNwiCJ1YK452EjbiwY/IFneF6MPA79jeW0f6Wl1Wr3CydXBc0p8mp32h8KO71yDSQoQvMF6mZuw1gP+/onY3MDlVkW1dtykjmo775v+HBRkkEpuuOSTQXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810793; c=relaxed/simple;
	bh=FEO48PdftRFon7NxVgUxWUroJJI7tlZSTKkdzhAsAxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doS2TPVDjHOvRG9syUHVtkCECMVYHnn8aqSHcWNT36uw56HqmxEUcfojVuQnG8qfoY9FraNsPnesIn+L3jY8m9mIxW3dJjnzy3fFDY9zdIFur3qJDQbpVtRKJR+0lMun2vvp+9JAW7yXHSrCbxOGqhT/Gy0VMMY8G6GecJBVJGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iKibuS5t; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iKibuS5t"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Au9Ma2BxVY9Ro0tBwGJ13d9+2jvx73eirdYQDnvMo1w=;
	b=iKibuS5tKxFa7i+cd3pvdzb5p2Ez5uZyrloDovpQ0tT7ryT4PWVSHlfygZdZFpzXNYwBrH
	SWI364qiT5wo5n36MqMLZ80uC7BRvOhpGgxV6CTK3oiUz2bIWMGqshimEO1p+hNoxTKfq3
	Cym3HLLXQt3xrNB7xvGxe606YSMSMvg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: BCH_MEMBER_RESIZE_ON_MOUNT
Date: Wed, 16 Apr 2025 09:39:43 -0400
Message-ID: <20250416133943.3654046-3-kent.overstreet@linux.dev>
In-Reply-To: <20250416133943.3654046-1-kent.overstreet@linux.dev>
References: <20250416133943.3654046-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c          |  4 ++
 fs/bcachefs/sb-members.c        |  1 +
 fs/bcachefs/sb-members.h        |  1 +
 fs/bcachefs/sb-members_format.h |  2 +
 fs/bcachefs/sb-members_types.h  |  1 +
 fs/bcachefs/super.c             | 67 +++++++++++++++++++++++++++++----
 fs/bcachefs/super.h             |  1 +
 7 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index fbe2e6406f53..f7b4b659069e 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -949,6 +949,10 @@ int bch2_fs_recovery(struct bch_fs *c)
 
 	ret = bch2_sb_set_upgrade_extra(c);
 
+	ret = bch2_fs_resize_on_mount(c);
+	if (ret)
+		goto err;
+
 	ret = bch2_run_recovery_passes(c);
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 9a82ed3f18f5..b2f9cb2d2b6b 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -292,6 +292,7 @@ static void member_to_text(struct printbuf *out,
 
 	prt_printf(out, "Discard:\t%llu\n", BCH_MEMBER_DISCARD(&m));
 	prt_printf(out, "Freespace initialized:\t%llu\n", BCH_MEMBER_FREESPACE_INITIALIZED(&m));
+	prt_printf(out, "Resize on mount:\t%llu\n", BCH_MEMBER_RESIZE_ON_MOUNT(&m));
 
 	printbuf_indent_sub(out, 2);
 }
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index 99d15e54726b..e2a8d03a1fa1 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -350,6 +350,7 @@ static inline struct bch_member_cpu bch2_mi_to_cpu(struct bch_member *mi)
 			? BCH_MEMBER_DURABILITY(mi) - 1
 			: 1,
 		.freespace_initialized = BCH_MEMBER_FREESPACE_INITIALIZED(mi),
+		.resize_on_mount	= BCH_MEMBER_RESIZE_ON_MOUNT(mi),
 		.valid		= bch2_member_alive(mi),
 		.btree_bitmap_shift	= mi->btree_bitmap_shift,
 		.btree_allocated_bitmap = le64_to_cpu(mi->btree_allocated_bitmap),
diff --git a/fs/bcachefs/sb-members_format.h b/fs/bcachefs/sb-members_format.h
index 3affec823b3f..472218a59102 100644
--- a/fs/bcachefs/sb-members_format.h
+++ b/fs/bcachefs/sb-members_format.h
@@ -88,6 +88,8 @@ LE64_BITMASK(BCH_MEMBER_GROUP,		struct bch_member, flags, 20, 28)
 LE64_BITMASK(BCH_MEMBER_DURABILITY,	struct bch_member, flags, 28, 30)
 LE64_BITMASK(BCH_MEMBER_FREESPACE_INITIALIZED,
 					struct bch_member, flags, 30, 31)
+LE64_BITMASK(BCH_MEMBER_RESIZE_ON_MOUNT,
+					struct bch_member, flags, 31, 32)
 
 #if 0
 LE64_BITMASK(BCH_MEMBER_NR_READ_ERRORS,	struct bch_member, flags[1], 0,  20);
diff --git a/fs/bcachefs/sb-members_types.h b/fs/bcachefs/sb-members_types.h
index c0eda888fe39..d6443e186872 100644
--- a/fs/bcachefs/sb-members_types.h
+++ b/fs/bcachefs/sb-members_types.h
@@ -13,6 +13,7 @@ struct bch_member_cpu {
 	u8			data_allowed;
 	u8			durability;
 	u8			freespace_initialized;
+	u8			resize_on_mount;
 	u8			valid;
 	u8			btree_bitmap_shift;
 	u64			btree_allocated_bitmap;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 29c4204d2e50..3fa4706cfffd 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1110,6 +1110,7 @@ int bch2_fs_start(struct bch_fs *c)
 	for_each_online_member(c, ca)
 		bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx)->last_mount = cpu_to_le64(now);
 
+	bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
 	for_each_rw_member(c, ca)
@@ -2045,6 +2046,18 @@ int bch2_dev_offline(struct bch_fs *c, struct bch_dev *ca, int flags)
 	return 0;
 }
 
+static int __bch2_dev_resize_alloc(struct bch_dev *ca, u64 old_nbuckets, u64 new_nbuckets)
+{
+	struct bch_fs *c = ca->fs;
+	u64 v[3] = { new_nbuckets - old_nbuckets, 0, 0 };
+
+	return bch2_trans_commit_do(ca->fs, NULL, NULL, 0,
+			bch2_disk_accounting_mod2(trans, false, v, dev_data_type,
+						  .dev = ca->dev_idx,
+						  .data_type = BCH_DATA_free)) ?:
+		bch2_dev_freespace_init(c, ca, old_nbuckets, new_nbuckets);
+}
+
 int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 {
 	struct bch_member *m;
@@ -2092,13 +2105,7 @@ int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 	mutex_unlock(&c->sb_lock);
 
 	if (ca->mi.freespace_initialized) {
-		u64 v[3] = { nbuckets - old_nbuckets, 0, 0 };
-
-		ret   = bch2_trans_commit_do(ca->fs, NULL, NULL, 0,
-				bch2_disk_accounting_mod2(trans, false, v, dev_data_type,
-							  .dev = ca->dev_idx,
-							  .data_type = BCH_DATA_free)) ?:
-			bch2_dev_freespace_init(c, ca, old_nbuckets, nbuckets);
+		ret = __bch2_dev_resize_alloc(ca, old_nbuckets, nbuckets);
 		if (ret)
 			goto err;
 	}
@@ -2109,6 +2116,52 @@ int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 	return ret;
 }
 
+int bch2_fs_resize_on_mount(struct bch_fs *c)
+{
+	down_write(&c->state_lock);
+
+	for_each_online_member(c, ca) {
+		u64 old_nbuckets = ca->mi.nbuckets;
+		u64 new_nbuckets = div64_u64(get_capacity(ca->disk_sb.bdev->bd_disk),
+					 ca->mi.bucket_size);
+
+		if (ca->mi.resize_on_mount &&
+		    new_nbuckets > ca->mi.nbuckets) {
+			bch_info(ca, "resizing to size %llu", new_nbuckets * ca->mi.bucket_size);
+			int ret = bch2_dev_buckets_resize(c, ca, new_nbuckets);
+			bch_err_fn(ca, ret);
+			if (ret) {
+				percpu_ref_put(&ca->io_ref[READ]);
+				up_write(&c->state_lock);
+				return ret;
+			}
+
+			mutex_lock(&c->sb_lock);
+			struct bch_member *m =
+				bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
+			m->nbuckets = cpu_to_le64(new_nbuckets);
+			SET_BCH_MEMBER_RESIZE_ON_MOUNT(m, false);
+
+			c->disk_sb.sb->features[0] &= ~BIT_ULL(BCH_FEATURE_small_image);
+			bch2_write_super(c);
+			mutex_unlock(&c->sb_lock);
+
+			if (ca->mi.freespace_initialized) {
+				ret = __bch2_dev_resize_alloc(ca, old_nbuckets, new_nbuckets);
+				if (ret) {
+					percpu_ref_put(&ca->io_ref[READ]);
+					up_write(&c->state_lock);
+					return ret;
+				}
+			}
+		}
+	}
+
+	bch2_recalc_capacity(c);
+	up_write(&c->state_lock);
+	return 0;
+}
+
 /* return with ref on ca->ref: */
 struct bch_dev *bch2_dev_lookup(struct bch_fs *c, const char *name)
 {
diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
index 23533bce5709..502d6c57ebb2 100644
--- a/fs/bcachefs/super.h
+++ b/fs/bcachefs/super.h
@@ -26,6 +26,7 @@ int bch2_dev_add(struct bch_fs *, const char *);
 int bch2_dev_online(struct bch_fs *, const char *);
 int bch2_dev_offline(struct bch_fs *, struct bch_dev *, int);
 int bch2_dev_resize(struct bch_fs *, struct bch_dev *, u64);
+int bch2_fs_resize_on_mount(struct bch_fs *);
 struct bch_dev *bch2_dev_lookup(struct bch_fs *, const char *);
 
 bool bch2_fs_emergency_read_only(struct bch_fs *);
-- 
2.49.0

