Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F000126F2A
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 07:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728716792; cv=none; b=ibz6QB6jUP5qeMUTKC+rph32zc4wzvmuWc675CNFbSyakSiXnAuiG/aqzqVkxxmlEPxGs0qNOiN7Vw/XnCWNl40oUlunYyBH+2q5VPb9XzvUQ3cusC6Be4DelTPnPqv0ri581c/J9rYQxHZg+5jZAEd9PTub++H6OH+srWdnuCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728716792; c=relaxed/simple;
	bh=4XMKtH3LPVzH9501264ETLT2xHXvHWVtRLZl0j+buzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Eb0N2+2xKUErWSJDtgbKMraxGHELbepQtZxyYpWU/xLrb+FkUvO2dCthXoe9HUHoPrzgJVD/S4v5lAIgTkm/geL6Zn/5iT3N8PPLfpo6h0SNWrzRD4nvGYByYM2Ggawr3sLAEeMvgZnM/LzJ3YZezXliSaaiMMu0p3dPIfXEVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jVIVkqe3; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jVIVkqe3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728716786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ltSZ06tkxjZxT/p/YN5rIjzLXem/XTaNApc6EGO2eOM=;
	b=jVIVkqe3VUkN6T7mpCnEleis9UN91jqKPqL08uHPirqbY4wBh0y0ouyyjubK2XssY/xBCP
	TwlQ3vCL6WxhZvXrt5pDqNZHUNvFizVE4v4itOmpeM0G6wKYbeIxvqvBTD1fbpnTg+S/xu
	qDDGm0lsINdhe/yaug25Q8fXo5L0ZOw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix accounting replay flags
Date: Sat, 12 Oct 2024 03:06:17 -0400
Message-ID: <20241012070617.3487080-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

BCH_TRANS_COMMIT_journal_reclaim without BCH_WATERMARK_reclaim means
"return an error if low on journal space" - but accounting replay must
succeed.

Fixes https://github.com/koverstreet/bcachefs/issues/656

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 6db72d3bad7d..55e1504a8130 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -287,7 +287,8 @@ int bch2_journal_replay(struct bch_fs *c)
 				BCH_TRANS_COMMIT_no_enospc|
 				BCH_TRANS_COMMIT_journal_reclaim|
 				BCH_TRANS_COMMIT_skip_accounting_apply|
-				BCH_TRANS_COMMIT_no_journal_res,
+				BCH_TRANS_COMMIT_no_journal_res|
+				BCH_WATERMARK_reclaim,
 			     bch2_journal_replay_accounting_key(trans, k));
 		if (bch2_fs_fatal_err_on(ret, c, "error replaying accounting; %s", bch2_err_str(ret)))
 			goto err;
-- 
2.45.2

