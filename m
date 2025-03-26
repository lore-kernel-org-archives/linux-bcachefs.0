Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A5E1A4F21
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742978131; cv=none; b=OBGPDTS23ubCxo9kN7Qh2VPcTK4PAvPqvFm8rThQkf6EmwGUxCjYV8Mw+/d63ctHB90AiwvpLxj0wZ3M/3TELaKDfEj7MOP0MHeiVuwiBDggkqARMDuPgmZI0mpFqd4B0VUGwk1qxqLPvbG0CznB2DVunPm5qN6rHz9uVgJRwRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742978131; c=relaxed/simple;
	bh=KEfgYuDFkB30zARczmocUqC+sxKXpbuQhuidX7epxjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NfL74JR/oPbUBPUO0spnoUTs9j2XKBXXS2se+uTBfNUUuRJT5Q9p1oGonaSz+RrmeS2FCXqf+yepfFjFwSnnzjmJWqL+o+uzvXNCU42oHWvnuqsjAdNqDYQ4cQ5DYTkPurghW852O4swhLZSJngclracvfO5mq4EhwZJEY7kWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=OFHGneNh; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="OFHGneNh"
DKIM-Signature: a=rsa-sha256; bh=Q2ohQ+qErCBRsFwvMDY25z5XWU/SNtJ4lujozgvNZnw=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1742977182; v=1; x=1743409182;
 b=OFHGneNhkVPSDUsZyj3bOqxNjntmUkBdHWyiP+aOzL1XUdwPReJZoOqFgqD63Jp+JWLW/GIP
 Xrv/rBm25ygmt2/vhT+EFrLhu1c+t1YfPCqo6hdrTvEjfj3wg+Hvgc8qQ9WO/Zkkcep3adHkFqo
 VX5zNGl5zpva1dEPtqrpjWgkyk+jWM+OTariuVL/hH1X4UfsbTsfIgmSCL1SgzVqD+hb7yRMEto
 CjYoAb0Hu3UuFiWRIP5RQxZGOSpR6x+EFj0a5KD0Ct41LcQXk5GRC7zjfd4PJzVA5tT3ART31SV
 xGw2xzAFXtiVr5kA5FBMC+J1aLAxxJANTxb1AB6eXDkaA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 0b1804e9; Wed, 26 Mar 2025
 16:19:42 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: linux-bcachefs@vger.kernel.org,
	mmpgouride@gmail.com,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: fix build failure by fixing of C header filename
Date: Wed, 26 Mar 2025 16:18:28 +0800
Message-ID: <20250326081828.120893-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

C header filename in `c_src/cmd_fusemount.c` hasn't been updated after renaming
`libbcachefs/fs-common.h`. Updating the filename to fix build failure.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/cmd_fusemount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
index 158f748d..a9033d79 100644
--- a/c_src/cmd_fusemount.c
+++ b/c_src/cmd_fusemount.c
@@ -19,7 +19,7 @@
 #include "libbcachefs/dirent.h"
 #include "libbcachefs/errcode.h"
 #include "libbcachefs/error.h"
-#include "libbcachefs/fs-common.h"
+#include "libbcachefs/namei.h"
 #include "libbcachefs/inode.h"
 #include "libbcachefs/io_read.h"
 #include "libbcachefs/io_write.h"
-- 
2.49.0

