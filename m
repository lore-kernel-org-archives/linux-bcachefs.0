Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C910E4
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 13:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740231119; cv=none; b=skdRt4TotO46t+9qKRvmbSCyFsdc5+RRUVm3nXEED3t6f/9n9V+jOdhPc441/8j+yshjKlqJKudLU38Iy7RWzmwn9aC5a7ZW28fG0wHmdhENGH2//zs//oHLQnoE/HSkUPUecGVOZPXb+RVbENE5+QbX4cVVNjWEMhLHj2vCD+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740231119; c=relaxed/simple;
	bh=a3q033m9QDXf96Rc4CGugVqhTq8k4H9SG+ued1hT5Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PUoJv7mvqpjeTtyb013pS3VBWQHPr06MZqrR75LZPMX2uzRDgc7WjHJImobj21xKyvK3G+ERlHV6c8fTd1pwOy1csJDffPqSEsZDRZPJWlYXYnMZHAdGUBmDF1K8iFRDIihZ/zFIXg8xIvrrpA4PGxtkct6Sfziyr488qYO74PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kRSdjKgm; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kRSdjKgm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740231114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RdvTTP7qcW2YqZWjmufUDVNenWR1tHKSuIW1RDRTnoA=;
	b=kRSdjKgmCbk6uoQN/VhJtbqgTzEC3Mf0OCu+FMNO9/e7R4xIpWvCcs1ewTkFW9ggepqJrV
	3u8Jw1Rmf6KdXkGlTH7Dl+k9pmoYyjqpMdaxPV6kNszN4TtJm6tSexh7ns4nmhVkc/VZD+
	6Tl/XLL39XofEbLRa/yArMIynnLDcC8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Remove duplicate condition in return statement
Date: Sat, 22 Feb 2025 14:31:01 +0100
Message-ID: <20250222133100.369710-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last two conditions in the return statement are identical. Remove
one of them.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/extents.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 620b284aa34f..8afcf2c75015 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -703,7 +703,6 @@ static inline bool bch2_extent_ptr_eq(struct bch_extent_ptr ptr1,
 	return (ptr1.cached	== ptr2.cached &&
 		ptr1.unwritten	== ptr2.unwritten &&
 		ptr1.offset	== ptr2.offset &&
-		ptr1.dev	== ptr2.dev &&
 		ptr1.dev	== ptr2.dev);
 }
 
-- 
2.48.1

