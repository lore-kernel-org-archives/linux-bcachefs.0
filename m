Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526064C8D;
	Mon,  9 Sep 2024 00:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725843497; cv=none; b=YWNbJdT4xITvKSABPapZlW4J8jhWc2lpltiMaD5m3rdl3hNNyiBNKTaAAODLzKYWaH7T6uHE4aXRPuJ8JZaHOCDmfn26OllIF/d3BQ2SMtLQUBmhRcrGfe3a4Eblz2+ULRVNmKTks2Y5+liTwiAcKmLc/oBfCMFhnIDY/Hl8H8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725843497; c=relaxed/simple;
	bh=iE+6ZVQEpduPJZ0EQWoxP4+QOWd4RQ2I7AxeVxCK/B0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Dzh1taZXSPhStqta0XczppCCTpT8HI4tzgxUjDcnEAos9DLGgzWCREsPox6Fuo4ueABnaE/0fcCWx0Y9XLn32GGESDlQu2NIZs0QcKWopyepk5qxj6gbDaKZJgianlCFCzO55ZZ5d4Ri2Y7hcKl4Pl2xLo1abqwnckx0LW+RFCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m9SMqLH/; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m9SMqLH/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725843486; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=e7NFhvT4ecuuBq5k6KKrq/vr6KQwGdLAJzyV/MhRLD0=;
	b=m9SMqLH/RNUTSbK0qZ41OacqVGvrqI26gXqRtsG0M1YVnIWZGL/gp6Fc9mRshzTdSlbDC32VihUZLytlQgOSmDPfVwBbYxvmHti0kik3snoj7qa1nkvFiJwSDUmx134f82kFof4TpyLElY1ue3G8tQ8YTcv1Lf6r0kbfZZs9co0=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WEVePk1_1725843485)
          by smtp.aliyun-inc.com;
          Mon, 09 Sep 2024 08:58:05 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove duplicated include in backpointers.c
Date: Mon,  9 Sep 2024 08:58:02 +0800
Message-Id: <20240909005802.14125-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header files bbpos.h is included twice in backpointers.c,
so one inclusion of each can be removed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=10783
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/backpointers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 21fdcde7e522..974f3464cd14 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -3,7 +3,6 @@
 #include "bbpos.h"
 #include "alloc_background.h"
 #include "backpointers.h"
-#include "bbpos.h"
 #include "bkey_buf.h"
 #include "btree_cache.h"
 #include "btree_update.h"
-- 
2.32.0.3.g01195cf9f

