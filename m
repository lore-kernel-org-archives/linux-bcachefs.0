Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C571A3BA1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912075; cv=none; b=SHB6K+3iteVTtIxL0eLdppMgYg+iG21I5nqh6f9tqd5Ku0rvqzTFcP3ETslFSmiUnWOO5+EJf7HJojZ82grK+dTkRWvSvRj9vTCzpsdf7T/fnQwnLVaXdeuLjmtBLGPZKgfEmXj23EFnluXW/KeqeLF6+qhG8opbEsYrBMZRV54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912075; c=relaxed/simple;
	bh=TtlnVwgMDFjuhNr++C/fuON9KqIsPYwcdEez2R0gZSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSZuuNXKQqtXGEl1UHoQLNyxuWZljxLAzoJurcFJO6pd6eTnfu4JV195bPa3tWh2D3VYRRLgW7bXlvYBmZq0uFmlJWMbt+/eXY8KJPx9xSUq58XvU9po4h3/GFRq1gCA+2WkrN/u62CpbJ/z61vSqPAXtIgd8k0cEYzLOH0cSjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/34] bcachefs: Bad btree roots are now autofix
Date: Fri, 29 Nov 2024 15:27:08 -0500
Message-ID: <20241129202736.2713679-10-kent.overstreet@linux.dev>
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
 fs/bcachefs/sb-errors_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index d45d0789f1b1..89d9dc2c859b 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -68,8 +68,8 @@ enum bch_fsck_flags {
 	x(btree_node_bkey_bad_format,				 55,	0)		\
 	x(btree_node_bad_bkey,					 56,	0)		\
 	x(btree_node_bkey_out_of_order,				 57,	0)		\
-	x(btree_root_bkey_invalid,				 58,	0)		\
-	x(btree_root_read_error,				 59,	0)		\
+	x(btree_root_bkey_invalid,				 58,	FSCK_AUTOFIX)	\
+	x(btree_root_read_error,				 59,	FSCK_AUTOFIX)	\
 	x(btree_root_bad_min_key,				 60,	0)		\
 	x(btree_root_bad_max_key,				 61,	0)		\
 	x(btree_node_read_error,				 62,	0)		\
-- 
2.45.2

