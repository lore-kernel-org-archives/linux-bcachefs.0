Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D1127E048
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283699; cv=none; b=J6rSZxHBSBhXC8YSh0uohDgbZY3ArLNeJYYQ7VPLd8eyMLr5X1gNxxShh+FhS0WU7ysScYRMHv33mRgZwKyB9aGKAw0BXL+COSmRLXFgb/eHtNsi5TaoGqFeHn2qf/m0m++PZTWxyFB8fT4v3t+uh3uXHgAhbsMgVn3X8DHaakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283699; c=relaxed/simple;
	bh=zvcIBhWDx1mWnpmMV1dQcifwy0WN1UXl3QK59+pvtE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUPuBmGf1AYasLBvU10Pv3Wk0EDOuGfOZpkeg9IPL0YvfwbnreyiJQG7gdiNJvmidADXn99k65euZbTmjxcTWl99dapUURii1FR3FvleCAlRxtnIMvOtgAmNxj2iRx+DwccLVzl2bbQyXH6pMaMtmbv8QMOKjyXHsbOAXH04zLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GefYgXTK; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GefYgXTK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Buhgx0wgCLLhmXrC2CQEMNi59Z7RaXBfEcg3riSIfOk=;
	b=GefYgXTKhqZHuRv6cYNrnkgPSgUcRSKWRrNRalaXiUmjLaV8BWZxOrEHQqXDpOEGWx4cpC
	bnW8guEcOq9W1QYYxbNXz/lLwNcoUS2AtSHkocCXAMOFpKEQi5iV53BEG2XpLB2AecdvB7
	Ew+Zln2lOuFwu5KbY5aLXkwuGOxFgP0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 17/37] bcachefs: mark more errors autofix
Date: Wed, 18 Jun 2025 17:54:08 -0400
Message-ID: <20250618215431.738317-18-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-errors_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index d06e73884871..56971ebe0f78 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -217,7 +217,7 @@ enum bch_fsck_flags {
 	x(inode_str_hash_invalid,				194,	0)		\
 	x(inode_v3_fields_start_bad,				195,	0)		\
 	x(inode_snapshot_mismatch,				196,	0)		\
-	x(snapshot_key_missing_inode_snapshot,			314,	0)		\
+	x(snapshot_key_missing_inode_snapshot,			314,	FSCK_AUTOFIX)	\
 	x(inode_unlinked_but_clean,				197,	0)		\
 	x(inode_unlinked_but_nlink_nonzero,			198,	0)		\
 	x(inode_unlinked_and_not_open,				281,	0)		\
@@ -253,18 +253,18 @@ enum bch_fsck_flags {
 	x(extent_overlapping,					215,	0)		\
 	x(key_in_missing_inode,					216,	0)		\
 	x(key_in_wrong_inode_type,				217,	0)		\
-	x(extent_past_end_of_inode,				218,	0)		\
+	x(extent_past_end_of_inode,				218,	FSCK_AUTOFIX)	\
 	x(dirent_empty_name,					219,	0)		\
 	x(dirent_val_too_big,					220,	0)		\
 	x(dirent_name_too_long,					221,	0)		\
 	x(dirent_name_embedded_nul,				222,	0)		\
 	x(dirent_name_dot_or_dotdot,				223,	0)		\
 	x(dirent_name_has_slash,				224,	0)		\
-	x(dirent_d_type_wrong,					225,	0)		\
+	x(dirent_d_type_wrong,					225,	FSCK_AUTOFIX)	\
 	x(inode_bi_parent_wrong,				226,	0)		\
 	x(dirent_in_missing_dir_inode,				227,	0)		\
 	x(dirent_in_non_dir_inode,				228,	0)		\
-	x(dirent_to_missing_inode,				229,	0)		\
+	x(dirent_to_missing_inode,				229,	FSCK_AUTOFIX)	\
 	x(dirent_to_overwritten_inode,				302,	0)		\
 	x(dirent_to_missing_subvol,				230,	0)		\
 	x(dirent_to_itself,					231,	0)		\
-- 
2.50.0

