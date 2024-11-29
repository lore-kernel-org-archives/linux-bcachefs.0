Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E051A38EC
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912078; cv=none; b=hvdCuaBfFQCZSuX2zdrpThYXUvyEjxMhlqNftsXY8CO0cIofAdDCfTf//pQGY/zoeMIEiNx1p4LWbZw2zG5veGrE5xiwsWbK/f3VxlchhVXrwwtjdXvlcKmlO1Kh2i6UcKewX2p4DjKqjW3qN79gATjnH6fl0WvCMYssREIPDXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912078; c=relaxed/simple;
	bh=dqutSfNWcvt+XpEy1R3ExCiY9aiz37Uhz4hgxEUwPqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzr3BssQzZ8fXQ3On4jtJLhL9e6efSdd96zFBtgqUINuiTZhsme8t5OGj2y5BAA1N5hYEjpKXDf0kJipX3GHTwwR347zuTciOmMz3e/AqoCXtsdHZBM2sQEssieEUvFasDJiuRqqKpFSLsReyG5i/zlCbGxbp32aeyrDU/7qPh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/34] bcachefs: Change "disk accounting version 0" check to commit only
Date: Fri, 29 Nov 2024 15:27:11 -0500
Message-ID: <20241129202736.2713679-13-kent.overstreet@linux.dev>
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

6.11 had a bug where we'd sometimes create disk accounting keys with
version 0, which causes issues for journal replay - but we don't need to
delete existing accounting keys with version 0.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index bb5dbbf71d04..c5e61265b709 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -134,7 +134,8 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 	void *end = &acc_k + 1;
 	int ret = 0;
 
-	bkey_fsck_err_on(bversion_zero(k.k->bversion),
+	bkey_fsck_err_on((flags & BCH_VALIDATE_commit) &&
+			 bversion_zero(k.k->bversion),
 			 c, accounting_key_version_0,
 			 "accounting key with version=0");
 
-- 
2.45.2

