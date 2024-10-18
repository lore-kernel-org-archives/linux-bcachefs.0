Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDD71714C0
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226177; cv=none; b=mkfOvR1kDceAt68Ma7zjZEmGubwqrzJNxH3l2gw6YF6UsCT+1Dsv8x4qVjma1cVjm6g1VCILBpODKhn8ZleMeautJxjDEJxM4p3xEjQ1Grsmz+YcmqgApHxeMtYcVmPX/yA5RWFFvLFqS/nus4iubEOVpIFKWuMLLtSEzppjEXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226177; c=relaxed/simple;
	bh=VoYzFNsxlmPYdcRPnGT9uCYy/eqXNexAs4sVOO8BjcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijScZ36F4PzU2qJI8oS32dH+3GxhxFV4dCNMexTs0lLRF5E5o99eQwvOCNw47zIpEFURBKq/WakZzL2my6SSzee+dSfH1AZIlaSPWs4UcXFll+AX39JtlDQXCl+/gQhcHDp/WyBOgaJk6uX7Bx1dnZTojiGskPgQGv8WkAW9n90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lGUjotip; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lGUjotip"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGFYCA7RJTfLVEKaON6D2l2lM3CzdRZqkGX8ZZLvgNk=;
	b=lGUjotipU2Raz+lLP5GzNwQNs2NHHHoBknJ2676aZ2fecMNbp+LPJfHVD7xmBP2oBb4kgV
	lp8OcMA6JO4FVjQLnu5EKJncu0F2rdF4psmGANmTAuwE0bytxJGRWknQIz5i98qTu1AOu/
	TP/EdYezO6zV9GBdz/7ZaVE7muyCl1U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/9] bcachefs: fix restart handling in __bch2_resume_logged_op_finsert()
Date: Fri, 18 Oct 2024 00:35:57 -0400
Message-ID: <20241018043602.4067344-8-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/io_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 307ed0a45184..f283051758d6 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -377,7 +377,7 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	 * check for missing subvolume before fpunch, as in resume we don't want
 	 * it to be a fatal error
 	 */
-	ret = __bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot, warn_errors);
+	ret = lockrestart_do(trans, __bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot, warn_errors));
 	if (ret)
 		return ret;
 
-- 
2.45.2

