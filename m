Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9431A302E
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912072; cv=none; b=bS/6SC8JoqaJrV4ptN7fRl7QOcLgXiO9CjBnHZbSi0rk58rJHGzXvs7bWsVlgdK2azwBatBBsORuk5mYHk1C8YKBrZdqhK3MTkR85wiAxukMNdCkHnav7Z6+Ci2/2NkyuC0HYyGCByQTdXezoEerWjWMBDBgEAr2Xzi8GbBj38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912072; c=relaxed/simple;
	bh=WmffHkSy+CkZ1a1ftiiDFIJLoCdmitg+b8qE5j0rBRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tO3ouCjUMv+CZH2K6bcbuUnpTp+Pd+f7GhGTF8IUVuRHWL78IkuwsX1iu3dTzcuTo2AFCnELPKqhM//seiGkdGA5inTpEugEj7bTuUxa9MmlQ1AnWjNOAwvoDGirAEdVEA/zwNcUQzrMl5s/WdvH2U+mu4ZLNWuyXc9+B6iDX1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/34] bcachefs: backpointer_to_missing_ptr is now autofix
Date: Fri, 29 Nov 2024 15:27:05 -0500
Message-ID: <20241129202736.2713679-7-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-errors_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 9e3425f533bc..d45d0789f1b1 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -141,7 +141,7 @@ enum bch_fsck_flags {
 	x(backpointer_dev_bad,					297,	0)		\
 	x(backpointer_to_missing_device,			126,	0)		\
 	x(backpointer_to_missing_alloc,				127,	0)		\
-	x(backpointer_to_missing_ptr,				128,	0)		\
+	x(backpointer_to_missing_ptr,				128,	FSCK_AUTOFIX)	\
 	x(lru_entry_at_time_0,					129,	FSCK_AUTOFIX)	\
 	x(lru_entry_to_invalid_bucket,				130,	FSCK_AUTOFIX)	\
 	x(lru_entry_bad,					131,	FSCK_AUTOFIX)	\
-- 
2.45.2

