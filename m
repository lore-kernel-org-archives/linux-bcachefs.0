Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F205A1E833F
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 May 2025 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746838989; cv=none; b=mdlr08/VfrW71Ew5gKIA5TELAya8N8ZzOINomNA7/hjoXzF4UFsn0GVuih7VPtTmokvBRBYOF/E6zwcd4i0FFCkm3sVrxaKRWwjuhVziFFIXcX7eCWuQIWhmVlwZpROKxwTSiSxppkqWavEhKIPZppGpMLskKQf7Uc3If9qwQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746838989; c=relaxed/simple;
	bh=mb2Nw309NfyJmlR7NkTBr9sJcXAFkDsqrOfE9jb6jms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BDe0k/pXP96h1D61zB58SK+bZ/xyBv6ZtpCMc+npqZ9I9UojQBU955xpX1tY+dWOtbowEfNid6/7GqkMTsRKeJvZmWnT83GGzGorDLeea25XBy7A5zb3dZSLWd/ahrBYNu+JmTIKLYNEr7pmdRZQMgN5y/Bwi1gPMlPx1z/TkGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/KTjQGo; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/KTjQGo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746838980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5UW+4LeWkkA7lb9z+DGQvulCcL0EegKeiMCb4hkDeSo=;
	b=Q/KTjQGoejvHLiW1HnjLhLiVB5m4TYjzVMUnInMua1n4ilsDV4kBWamohO46sFgMDu2yve
	JVLjoDUC0UXNijWjNn0WBlDPWGxc4/IJNhKkFFAc8R9EUCDXqURn5WMDx4qucgMng3StAV
	KqKf8dNaHeUeKVC4ekBa1s2lD3BvLPo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: recovery_passes_types.h -> recovery_passes_format.h
Date: Fri,  9 May 2025 21:02:53 -0400
Message-ID: <20250510010254.3790016-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/bcachefs.h                                      | 1 -
 fs/bcachefs/bcachefs_format.h                               | 1 +
 .../{recovery_passes_types.h => recovery_passes_format.h}   | 6 +++---
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename fs/bcachefs/{recovery_passes_types.h => recovery_passes_format.h} (95%)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index fe9710522419..84cd38a89159 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -213,7 +213,6 @@
 #include "fifo.h"
 #include "nocow_locking_types.h"
 #include "opts.h"
-#include "recovery_passes_types.h"
 #include "sb-errors_types.h"
 #include "seqmutex.h"
 #include "snapshot_types.h"
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index a483d440fa39..df5a4d4df640 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -510,6 +510,7 @@ struct bch_sb_field {
 #include "logged_ops_format.h"
 #include "lru_format.h"
 #include "quota_format.h"
+#include "recovery_passes_format.h"
 #include "reflink_format.h"
 #include "replicas_format.h"
 #include "snapshot_format.h"
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_format.h
similarity index 95%
rename from fs/bcachefs/recovery_passes_types.h
rename to fs/bcachefs/recovery_passes_format.h
index be3185fc6ef4..291f58dfbd24 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_format.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _BCACHEFS_RECOVERY_PASSES_TYPES_H
-#define _BCACHEFS_RECOVERY_PASSES_TYPES_H
+#ifndef _BCACHEFS_RECOVERY_PASSES_FORMAT_H
+#define _BCACHEFS_RECOVERY_PASSES_FORMAT_H
 
 #define PASS_SILENT		BIT(0)
 #define PASS_FSCK		BIT(1)
@@ -81,4 +81,4 @@ enum bch_recovery_pass_stable {
 #undef x
 };
 
-#endif /* _BCACHEFS_RECOVERY_PASSES_TYPES_H */
+#endif /* _BCACHEFS_RECOVERY_PASSES_FORMAT_H */
-- 
2.49.0

