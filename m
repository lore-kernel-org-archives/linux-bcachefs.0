Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8041A38E1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912091; cv=none; b=lB0WsU7kFGVQg8gjCpauJXVGZvvJxgYiuGbSEN0RkjbbKeB0Gns2jLJH1ek4+RO4wQD+nsJfGNCyUWjm6yx/wmGrjGfaDvNBD3Tr/WiMJ8B+W8tDsb+D58ckCmaVCJcLitNkSZeUKvK3aZnU4V0bVTkFOmsyPGCivRGt0w36LGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912091; c=relaxed/simple;
	bh=zE6X4FgoxP3d/1zzkNR/Dd5NP++v/O2yWLG9tzRk6tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXvUtYGyf15zQqVHNz1+l1IGsgeMQFZD2CmqFfujkNZ/5DC1x6DT+CvVISESZqZJi5KvPVyRwurTKNL1hnCWkodPfDwConMUIIf677XJsq7L7AlvCw5Ngedm96nAOxqVgQO7teAnf1Ie5XI5vFszBJnFkuV3D4RvrB/JiH3wPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 25/34] bcachefs: add missing printbuf_reset()
Date: Fri, 29 Nov 2024 15:27:24 -0500
Message-ID: <20241129202736.2713679-26-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 19db4d8aca88..e59924cfe2bc 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -521,6 +521,7 @@ int bch2_check_topology(struct bch_fs *c)
 		struct btree_root *r = bch2_btree_id_root(c, i);
 		bool reconstructed_root = false;
 
+		printbuf_reset(&buf);
 		bch2_btree_id_to_text(&buf, i);
 
 		if (r->error) {
-- 
2.45.2

