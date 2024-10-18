Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811C176AB5
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226426; cv=none; b=qCaf8/i/rwV/eSGIuXCoVsZaS0NkHg62TzJVA1GZvIaTb9JFHCMNQX8qodMTXOfEwGAwp+kCqx6dxuKFUw3JRtpOibwrTnsKPrrvHmJfsfHEYWz1gz2KIQ+Q89uzV+mS4zFfLlUPvk2lHUo7lsnmbwkSb25boH4sUEogfhVPS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226426; c=relaxed/simple;
	bh=DGWRzam+l45Hytc4+SmFYguxqlr36lRtPaRWeoG5oqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEBTvCSp3MSw/HRB2gD5CETPEv3ahtfbjihnKfjHc99cSpo2hb1C+7yTlOFMCLdh8GxABYrWOV16iOd7QHPNIDxYMS+QxcMaBeYJvmrDQhsjcUcOGbh5fo9HPrAzd+UlbKK/zGEBHlQeyZfky+CEF0CPbKmmQCrFGU0y0wdK9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C22r/tzO; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C22r/tzO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4auIEaqQtjxB09SwMeQ6SEZ2NekbyifCjJveASvGTnA=;
	b=C22r/tzOTD/hrD5uSxx+Fn9U+hb+K0Cv/rzlWeHphVFsY6i3TMKO7QaPESrKdx6/jqKLvf
	QChx/ZcW9QiD0AyicSG/YIviOIdZq9GjsgI0Nchd98tIntGT3Pz0g4L7cqhcfrBSdmO9oF
	7C+Kv21f8/M1tAsDDddAYOfnAbG6xRw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: bch2_folio_reservation_get_partial() is now better behaved
Date: Fri, 18 Oct 2024 00:40:02 -0400
Message-ID: <20241018044006.4067521-3-kent.overstreet@linux.dev>
In-Reply-To: <20241018044006.4067521-1-kent.overstreet@linux.dev>
References: <20241018044006.4067521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_folio_reservation_get_partial(), on partial success, will now
return a reservation that's aligned to the filesystem blocksize.

This is a partial fix for fstests generic/299 - fio verify is badly
behaved in the presence of short writes that aren't aligned to its
blocksize.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/buckets.c         |  7 +++-
 fs/bcachefs/buckets.h         | 12 +++---
 fs/bcachefs/fs-io-pagecache.c | 70 ++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 32 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 546cd01a72e3..ec7d9a59bea9 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1160,11 +1160,11 @@ int bch2_trans_mark_dev_sbs(struct bch_fs *c)
 #define SECTORS_CACHE	1024
 
 int __bch2_disk_reservation_add(struct bch_fs *c, struct disk_reservation *res,
-			      u64 sectors, int flags)
+				u64 sectors, enum bch_reservation_flags flags)
 {
 	struct bch_fs_pcpu *pcpu;
 	u64 old, get;
-	s64 sectors_available;
+	u64 sectors_available;
 	int ret;
 
 	percpu_down_read(&c->mark_lock);
@@ -1202,6 +1202,9 @@ int __bch2_disk_reservation_add(struct bch_fs *c, struct disk_reservation *res,
 	percpu_u64_set(&c->pcpu->sectors_available, 0);
 	sectors_available = avail_factor(__bch2_fs_usage_read_short(c).free);
 
+	if (sectors_available && (flags & BCH_DISK_RESERVATION_PARTIAL))
+		sectors = min(sectors, sectors_available);
+
 	if (sectors <= sectors_available ||
 	    (flags & BCH_DISK_RESERVATION_NOFAIL)) {
 		atomic64_set(&c->sectors_available,
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index e2cb7b24b220..fd5e6ccad45e 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -344,14 +344,16 @@ static inline void bch2_disk_reservation_put(struct bch_fs *c,
 	}
 }
 
-#define BCH_DISK_RESERVATION_NOFAIL		(1 << 0)
+enum bch_reservation_flags {
+	BCH_DISK_RESERVATION_NOFAIL	= 1 << 0,
+	BCH_DISK_RESERVATION_PARTIAL	= 1 << 1,
+};
 
-int __bch2_disk_reservation_add(struct bch_fs *,
-				struct disk_reservation *,
-				u64, int);
+int __bch2_disk_reservation_add(struct bch_fs *, struct disk_reservation *,
+				u64, enum bch_reservation_flags);
 
 static inline int bch2_disk_reservation_add(struct bch_fs *c, struct disk_reservation *res,
-					    u64 sectors, int flags)
+					    u64 sectors, enum bch_reservation_flags flags)
 {
 #ifdef __KERNEL__
 	u64 old, new;
diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index cde3a0445ee9..1d4910ea0f1d 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -399,14 +399,17 @@ void bch2_folio_reservation_put(struct bch_fs *c,
 	bch2_quota_reservation_put(c, inode, &res->quota);
 }
 
-int bch2_folio_reservation_get(struct bch_fs *c,
+static int __bch2_folio_reservation_get(struct bch_fs *c,
 			struct bch_inode_info *inode,
 			struct folio *folio,
 			struct bch2_folio_reservation *res,
-			size_t offset, size_t len)
+			size_t offset, size_t len,
+			bool partial)
 {
 	struct bch_folio *s = bch2_folio_create(folio, 0);
 	unsigned i, disk_sectors = 0, quota_sectors = 0;
+	struct disk_reservation disk_res = {};
+	size_t reserved = len;
 	int ret;
 
 	if (!s)
@@ -422,48 +425,65 @@ int bch2_folio_reservation_get(struct bch_fs *c,
 	}
 
 	if (disk_sectors) {
-		ret = bch2_disk_reservation_add(c, &res->disk, disk_sectors, 0);
+		ret = bch2_disk_reservation_add(c, &disk_res, disk_sectors,
+				partial ? BCH_DISK_RESERVATION_PARTIAL : 0);
 		if (unlikely(ret))
 			return ret;
+
+		if (unlikely(disk_res.sectors != disk_sectors)) {
+			disk_sectors = quota_sectors = 0;
+
+			for (i = round_down(offset, block_bytes(c)) >> 9;
+			     i < round_up(offset + len, block_bytes(c)) >> 9;
+			     i++) {
+				disk_sectors += sectors_to_reserve(&s->s[i], res->disk.nr_replicas);
+				if (disk_sectors > disk_res.sectors) {
+					/*
+					 * Make sure to get a reservation that's
+					 * aligned to the filesystem blocksize:
+					 */
+					unsigned reserved_offset = round_down(i << 9, block_bytes(c));
+					reserved = clamp(reserved_offset, offset, offset + len) - offset;
+
+					if (!reserved) {
+						bch2_disk_reservation_put(c, &disk_res);
+						return -BCH_ERR_ENOSPC_disk_reservation;
+					}
+					break;
+				}
+				quota_sectors += s->s[i].state == SECTOR_unallocated;
+			}
+		}
 	}
 
 	if (quota_sectors) {
 		ret = bch2_quota_reservation_add(c, inode, &res->quota, quota_sectors, true);
 		if (unlikely(ret)) {
-			struct disk_reservation tmp = { .sectors = disk_sectors };
-			res->disk.sectors -= disk_sectors;
-
-			bch2_disk_reservation_put(c, &tmp);
+			bch2_disk_reservation_put(c, &disk_res);
 			return ret;
 		}
 	}
 
-	return 0;
+	res->disk.sectors += disk_res.sectors;
+	return partial ? reserved : 0;
 }
 
-ssize_t bch2_folio_reservation_get_partial(struct bch_fs *c,
+int bch2_folio_reservation_get(struct bch_fs *c,
 			struct bch_inode_info *inode,
 			struct folio *folio,
 			struct bch2_folio_reservation *res,
 			size_t offset, size_t len)
 {
-	size_t l, reserved = 0;
-	int ret;
-
-	while ((l = len - reserved)) {
-		while ((ret = bch2_folio_reservation_get(c, inode, folio, res, offset, l))) {
-			if ((offset & (block_bytes(c) - 1)) + l <= block_bytes(c))
-				return reserved ?: ret;
-
-			len = reserved + l;
-			l /= 2;
-		}
-
-		offset += l;
-		reserved += l;
-	}
+	return __bch2_folio_reservation_get(c, inode, folio, res, offset, len, false);
+}
 
-	return reserved;
+ssize_t bch2_folio_reservation_get_partial(struct bch_fs *c,
+			struct bch_inode_info *inode,
+			struct folio *folio,
+			struct bch2_folio_reservation *res,
+			size_t offset, size_t len)
+{
+	return __bch2_folio_reservation_get(c, inode, folio, res, offset, len, true);
 }
 
 static void bch2_clear_folio_bits(struct folio *folio)
-- 
2.45.2

