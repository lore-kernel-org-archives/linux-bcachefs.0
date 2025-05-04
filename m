Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1951D9A79
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 May 2025 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746388336; cv=none; b=AvnHyScEyugEl+yWwMu4WwB8/K7MaH8RRWMnUxvvN1z9BdjgNVCijejqdJbS/ksLQWh0bgU57plKDU74FagO5AyEp38bbF3/tHIujjOIfE33xKiBXd+XmvHfGuBogf5+zCD8YBCyuvRbte3qxv8JU/CBpGYzHza0b2IgDEOlPok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746388336; c=relaxed/simple;
	bh=mIfKpJsh+4J65+m3dH51Nx9vf97Euf9KxtqW7mm4hPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn1eNT3v2y/8ejTjcuhaqHvO3vBy+PEafBM/7yiBOVlN35axChrOlXGt20atDTjIw+ziRpuYz3cCZmGmZnB5M5asqtnIEU+Lbaz47D8dLOE1J2J2fZ+q6dqmY35XgXzkUb1d/GIu0DYv4kZj7BxMeW5TrEvuogPj1ECb7uf2a7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iE29vh/M; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iE29vh/M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746388330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L06YYM37qAsmv+sz8lv6TnAcf8TcaD/ar1OKLxnr2u8=;
	b=iE29vh/M4E/oqMUlVXJph4s3GqSMUaRfZO24u72Sire7qq1/Qopb54r1D5WPW9QgJzeRI6
	Bkaz3bzrKFgR7ZL0sBIi4RiqL7/ErF1NMjPpA0ZZ1iNCBxHn6yLLNPNHNbIlxMaP4gSoAx
	A96DQe5QP5Ma6oWO087PSkzNkIT1Y5Q=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: BCH_SB_MEMBER_DELETED_UUID
Date: Sun,  4 May 2025 15:51:57 -0400
Message-ID: <20250504195202.2073437-2-kent.overstreet@linux.dev>
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

Add a sentinal value for devices that have been removed, but don't want
to reuse their index until a fsck has completed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_gc.c          |  4 ++++
 fs/bcachefs/sb-members.c        | 29 ++++++++++++++++++++++++++++-
 fs/bcachefs/sb-members.h        |  4 +++-
 fs/bcachefs/sb-members_format.h |  4 ++++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 92ae31737a24..dd08ec080313 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1079,6 +1079,10 @@ int bch2_check_allocations(struct bch_fs *c)
 	 * allocator thread - issue wakeup in case they blocked on gc_lock:
 	 */
 	closure_wake_up(&c->freelist_wait);
+
+	if (!ret && !test_bit(BCH_FS_errors_not_fixed, &c->flags))
+		bch2_sb_members_clean_deleted(c);
+
 	bch_err_fn(c, ret);
 	return ret;
 }
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 9c383d9a5f4d..e5c68c2f1655 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -525,6 +525,7 @@ int bch2_sb_member_alloc(struct bch_fs *c)
 	unsigned u64s;
 	int best = -1;
 	u64 best_last_mount = 0;
+	unsigned nr_deleted = 0;
 
 	if (dev_idx < BCH_SB_MEMBERS_MAX)
 		goto have_slot;
@@ -535,7 +536,10 @@ int bch2_sb_member_alloc(struct bch_fs *c)
 			continue;
 
 		struct bch_member m = bch2_sb_member_get(c->disk_sb.sb, dev_idx);
-		if (bch2_member_alive(&m))
+
+		nr_deleted += uuid_equal(&m.uuid, &BCH_SB_MEMBER_DELETED_UUID);
+
+		if (!bch2_is_zero(&m.uuid, sizeof(m.uuid)))
 			continue;
 
 		u64 last_mount = le64_to_cpu(m.last_mount);
@@ -549,6 +553,10 @@ int bch2_sb_member_alloc(struct bch_fs *c)
 		goto have_slot;
 	}
 
+	if (nr_deleted)
+		bch_err(c, "unable to allocate new member, but have %u deleted: run fsck",
+			nr_deleted);
+
 	return -BCH_ERR_ENOSPC_sb_members;
 have_slot:
 	nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
@@ -564,3 +572,22 @@ int bch2_sb_member_alloc(struct bch_fs *c)
 	c->disk_sb.sb->nr_devices = nr_devices;
 	return dev_idx;
 }
+
+void bch2_sb_members_clean_deleted(struct bch_fs *c)
+{
+	mutex_lock(&c->sb_lock);
+	bool write_sb = false;
+
+	for (unsigned i = 0; i < c->sb.nr_devices; i++) {
+		struct bch_member *m = bch2_members_v2_get_mut(c->disk_sb.sb, i);
+
+		if (uuid_equal(&m->uuid, &BCH_SB_MEMBER_DELETED_UUID)) {
+			memset(&m->uuid, 0, sizeof(m->uuid));
+			write_sb = true;
+		}
+	}
+
+	if (write_sb)
+		bch2_write_super(c);
+	mutex_unlock(&c->sb_lock);
+}
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index c9cb8f7657b0..6bd9b86aee5b 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -320,7 +320,8 @@ extern const struct bch_sb_field_ops bch_sb_field_ops_members_v2;
 
 static inline bool bch2_member_alive(struct bch_member *m)
 {
-	return !bch2_is_zero(&m->uuid, sizeof(m->uuid));
+	return  !bch2_is_zero(&m->uuid, sizeof(m->uuid)) &&
+		!uuid_equal(&m->uuid, &BCH_SB_MEMBER_DELETED_UUID);
 }
 
 static inline bool bch2_member_exists(struct bch_sb *sb, unsigned dev)
@@ -381,5 +382,6 @@ bool bch2_dev_btree_bitmap_marked(struct bch_fs *, struct bkey_s_c);
 void bch2_dev_btree_bitmap_mark(struct bch_fs *, struct bkey_s_c);
 
 int bch2_sb_member_alloc(struct bch_fs *);
+void bch2_sb_members_clean_deleted(struct bch_fs *);
 
 #endif /* _BCACHEFS_SB_MEMBERS_H */
diff --git a/fs/bcachefs/sb-members_format.h b/fs/bcachefs/sb-members_format.h
index 472218a59102..fb72ad730518 100644
--- a/fs/bcachefs/sb-members_format.h
+++ b/fs/bcachefs/sb-members_format.h
@@ -13,6 +13,10 @@
  */
 #define BCH_SB_MEMBER_INVALID		255
 
+#define BCH_SB_MEMBER_DELETED_UUID					\
+	UUID_INIT(0xffffffff, 0xffff, 0xffff,				\
+		  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)
+
 #define BCH_MIN_NR_NBUCKETS	(1 << 6)
 
 #define BCH_IOPS_MEASUREMENTS()			\
-- 
2.49.0

