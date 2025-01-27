Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04774146D40
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951177; cv=none; b=L72F1izI3gZy74lDtYLzhwh4LoynCdTcti3T8nmJURGXJfBrCJj6LTp9aD4vVvCsMG3TTA3D+LyjkBNIXte8jfsUNatKvL11QbLhvrnPkKEKU4FmROg4d8zbrvUcSchELCqXX0IrkYnEoqw1sMuAdkBkpOjo3QUd64iw5p6T7sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951177; c=relaxed/simple;
	bh=96lc0fx8rLgLURSRCEswazzrR8h9+Qov7nB3o0sZNQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNZSwzfSEdIHwf0fN66NP3hshvxn53svKReq5tz4BxDJe3jaqoo3rafoolRzzSmiX+CvUVxMz10d+TXkoaiNGKfKat5i469eai8KIqGOCHFYYDPc44HIvs6ZdfQYo90DLJvXi0PXBDeoRyx/1fXclyfDWAuc2jHuGl51SG/CF3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m3dOF2O4; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m3dOF2O4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q237ejiA4UtonOVUfDXi1I9+RXkdhA1ISiJL8jFWyHo=;
	b=m3dOF2O40Te3YEQzaCQwk1hq8irMmNRQsnQtFVHpYY6uqEPS0rxKqM0VwKaVKR9JqTS81J
	acWUHfGtu7DV4KQn2YiBCRaDdfAMrU/cIezmECxGBoeTtHgE4oT2Yk/n/VPKvDEDn5CVnW
	781IKhtInBK+0iPfOmArltKIA+WU52g=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/11] bcachefs: bset_blacklisted_journal_seq is now AUTOFIX
Date: Sun, 26 Jan 2025 23:12:30 -0500
Message-ID: <20250127041239.2693707-5-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
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
index 0b4fe899209b..ea0a18364751 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -57,7 +57,7 @@ enum bch_fsck_flags {
 	x(bset_wrong_sector_offset,				 44,	0)		\
 	x(bset_empty,						 45,	0)		\
 	x(bset_bad_seq,						 46,	0)		\
-	x(bset_blacklisted_journal_seq,				 47,	0)		\
+	x(bset_blacklisted_journal_seq,				 47,	FSCK_AUTOFIX)	\
 	x(first_bset_blacklisted_journal_seq,			 48,	FSCK_AUTOFIX)	\
 	x(btree_node_bad_btree,					 49,	0)		\
 	x(btree_node_bad_level,					 50,	0)		\
-- 
2.45.2

