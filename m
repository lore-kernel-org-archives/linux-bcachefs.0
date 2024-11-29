Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCBD1A302E
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912092; cv=none; b=X6STMGALnNd2n8sVsSCGtC4sXqYcSc18VIDMJCdDstI8/DUxAOUhpzCuhZYpkiSUDyP4dYPkTE+rE5TMQwn3JTeW5ux+00KWEuPwyEAMDIWpIaJZuCPtxqaeIBUdktOxtYEkKedkgrCPJhTvRmdY5gMIgVmxCstkATiirY7dxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912092; c=relaxed/simple;
	bh=AQmLNXnVEDy/sfxikjwwJIZPwYYWMWpgfyyS277HAg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiSvGvKg/eFx6cNg9hJMqCJ8b5w97gi3LsUgBRe8PuVYCvjkn9ZgQ6zhWyBMmDzfYZKv6eWfmngg+bGHzYW8uMOfPAd1KcqcuiD0J/uooixOOtzYW3rTi2FRfX4r2mQLpv8plFCjH0m6HqFLHMiWL05Q/gJ0H/qC4nUMKn63olo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 26/34] bcachefs: mark more errors AUTOFIX
Date: Fri, 29 Nov 2024 15:27:25 -0500
Message-ID: <20241129202736.2713679-27-kent.overstreet@linux.dev>
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

mark errors as autofix where syzbot has hit the repair paths

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-errors_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index e73d1c60198e..382fcafa815a 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -124,9 +124,9 @@ enum bch_fsck_flags {
 	x(alloc_key_stripe_redundancy_wrong,			111,	FSCK_AUTOFIX)	\
 	x(bucket_sector_count_overflow,				112,	0)		\
 	x(bucket_metadata_type_mismatch,			113,	0)		\
-	x(need_discard_key_wrong,				114,	0)		\
-	x(freespace_key_wrong,					115,	0)		\
-	x(freespace_hole_missing,				116,	0)		\
+	x(need_discard_key_wrong,				114,	FSCK_AUTOFIX)	\
+	x(freespace_key_wrong,					115,	FSCK_AUTOFIX)	\
+	x(freespace_hole_missing,				116,	FSCK_AUTOFIX)	\
 	x(bucket_gens_val_size_bad,				117,	0)		\
 	x(bucket_gens_key_wrong,				118,	FSCK_AUTOFIX)	\
 	x(bucket_gens_hole_wrong,				119,	FSCK_AUTOFIX)	\
@@ -288,7 +288,7 @@ enum bch_fsck_flags {
 	x(btree_root_unreadable_and_scan_found_nothing,		263,	0)		\
 	x(snapshot_node_missing,				264,	0)		\
 	x(dup_backpointer_to_bad_csum_extent,			265,	0)		\
-	x(btree_bitmap_not_marked,				266,	0)		\
+	x(btree_bitmap_not_marked,				266,	FSCK_AUTOFIX)	\
 	x(sb_clean_entry_overrun,				267,	0)		\
 	x(btree_ptr_v2_written_0,				268,	0)		\
 	x(subvol_snapshot_bad,					269,	0)		\
-- 
2.45.2

