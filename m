Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724A314A0AB
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 21:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729371679; cv=none; b=bU9q7/VW4eA6BKguRHny/UDOwF7N5pF6e8pcgTO542zgO+t9pLx4NjwJaLaEJPQl66HZ/fx7+j1VlokhMIWjaGPxeQtcLxJNmUy/gwvgrMvQo3wHLCdQoFHOF5xsEQrS/HE/CoO8/KMtvXMXmWkpgvXtRTn3SlSatpRVAEnC25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729371679; c=relaxed/simple;
	bh=/iQWasV3TMK5T6R7D1ek7Si0Th4ECdXFmD5siYYr2ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DRbFNrJC0OegxM5Rf0klQgpZNHL6Qt8VlKmNQUGbjMb2qyo+lmDQe7KH+e2iG1WbQ44MukTdlFaROe5ZguenIg+ju/1Ytnub+fGBUkASHwXm5M951TQpgijqXezhbi0iGEr7t6egOHIDFhkAp3tBuod8A17Ztbh+yUSIim1Nbg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vRv+si35; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vRv+si35"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729371671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pEIDIRoh6F6ashFanYNpQIOpsglJrEZdQ2icFJowamQ=;
	b=vRv+si35LfF2ciGUvniLf6L1wb5tTA/9aE/9fhCV2jSH7yznXkdec70BqdmI6V5igvKffM
	E4tS9jlCIt+/HbZLxXmRI8QmzR0rhHKeJSpKGVRpJqL3HB7sgnMHf1wxzNdPHKH8c6ZWi7
	biI3uzfi8Xuu0un2GZV0M9XUybJqbYM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-mm@kvack.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Date: Sat, 19 Oct 2024 17:00:37 -0400
Message-ID: <20241019210037.146825-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A user with a 75 TB filesystem reported the following journal replay
error:
https://github.com/koverstreet/bcachefs/issues/769

In journal replay we have to sort and dedup all the keys from the
journal, which means we need a large contiguous allocation. Given that
the user has 128GB of ram, the 2GB limit on allocation size has become
far too small.

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 mm/util.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 4f1275023eb7..c60df7723096 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -665,12 +665,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
 	if (!gfpflags_allow_blocking(flags))
 		return NULL;
 
-	/* Don't even allow crazy sizes */
-	if (unlikely(size > INT_MAX)) {
-		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
-		return NULL;
-	}
-
 	/*
 	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
 	 * since the callers already cannot assume anything
-- 
2.45.2

