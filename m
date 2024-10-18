Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD3F1714C0
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226175; cv=none; b=lEq77pqNxZLHT72AU964KxVjAhLh+9czYcxr5q6WAsJqhatmT6f+709hBzxh1kKPsi0hruTS33zYjmo0NSLnH9Msu3HF3anVwBNf+jKMW+nAt3IcezD065Cisi0Fr7wgWksRYIbADqc/JMstMaUWyLjnkFBhDy8hvnBbq+6trb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226175; c=relaxed/simple;
	bh=eDCO29bxTXscdqEI0xaSgUvskmWDRMGeMSe8TiE0bz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3TlBsBFS3jwm28g8t9+AHDuaVTm7A5oaF1wHRgUEHfcEFWdr+R4QZZrDthoaBfHPYNLBFV3Tmdr7wBPtQf8NH0TchHV4ghTmicNy3Geyu9XhmRCcjiAQknI4LAPREVsi1GECxnWSsY9GLF4lbE4P36hQz4iQ8f6FRFCx6VNnGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b23QXUy6; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b23QXUy6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jbEKiTalwL/Wp2SjjgmRJXuhxQaV9Y9Wc4Uufsg2xE=;
	b=b23QXUy6S0VJHnVDlKuUv3KviqwwtvzOFP6zsnsxsO/OZvER5tG8gAbtO4KNUotjEY1EZw
	2BfK4C+uZVNbryNlnMCzvIy/dMIGQBgNCz7jN9eAIClyLYszxXIxCe2C7ipDJBCqM2ZUEx
	W9VipcZSft3012JMOxDlIIAf18CfeI0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/9] bcachefs: fix bch2_hash_delete() error path
Date: Fri, 18 Oct 2024 00:35:52 -0400
Message-ID: <20241018043602.4067344-3-kent.overstreet@linux.dev>
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

we were exiting an iterator that hadn't been initialized

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/str_hash.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index 215eed4cce6d..cc2084e9f1cc 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -363,8 +363,11 @@ int bch2_hash_delete(struct btree_trans *trans,
 	struct btree_iter iter;
 	struct bkey_s_c k = bch2_hash_lookup(trans, &iter, desc, info, inum, key,
 					     BTREE_ITER_intent);
-	int ret = bkey_err(k) ?:
-		  bch2_hash_delete_at(trans, desc, info, &iter, 0);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	ret = bch2_hash_delete_at(trans, desc, info, &iter, 0);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
-- 
2.45.2

