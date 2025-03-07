Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F421ABDF
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355388; cv=none; b=X3dT9BLoQsrcSQOX6xMXBMZBJ1uqVuQOs8zuTJetTPO7OCz3TVH02rGyGGCqS3yoHyVKh13S04Cge6j9NpV3m8+8HSuuwJI8adfFM4p1r67yOQsmBRQR9NOLYaOUQYCIG0OJRxZKVhypzjrIbiC2B38wSdmMh6F8bA1inWTarbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355388; c=relaxed/simple;
	bh=InaRiDUojOac4guj1Yr+eepxCQXdYBLxgKV1QnPhPGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLRfB830pziYqlTnWh8cJ2ZjtK8tuS1xj4Bxix3wuvKr2Hdc6tWk5SBIPB3D61EN/4boPy6Fu32dByD9+Kuebi3iLxcLj89EWIiYqaI6OQAj+UOYY9zYLTFxbW3IdkEM/iqrenM7hEshI4hVRrTMvugmOoXp/uRTI+CiDMW4zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=laysMbSC; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="laysMbSC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HQZ/tKmcgdmcTNJfV9yVK+/0PpX1kq2uk26+/6rks2M=;
	b=laysMbSCva2OK953UNbnga084ukzXwuxisGIjtVp3dmqH+TIHS/mjh6ANu1R4TeOr8zA1f
	Ao2KFIXRt0DcjXPkUZudAAjYjXzu2TEnPu57ugqgOfP1jgqioV5LisMf1hcohoHC1Gy4ac
	Q93rEAOtiHSJNXqwGiBzvmjUkiioeew=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/7] bcachefs: Fix btree_node_scan io_ref handling
Date: Fri,  7 Mar 2025 08:49:29 -0500
Message-ID: <20250307134933.1033872-6-kent.overstreet@linux.dev>
In-Reply-To: <20250307134933.1033872-1-kent.overstreet@linux.dev>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This was completely fubar; it's now simplified a bit as well.
Note that for_each_online_member() takes and releases io_refs as it
iterates, so we need to release that if we break.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_node_scan.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index fb73ec77c099..678161321e42 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -270,7 +270,7 @@ static int read_btree_nodes_worker(void *p)
 err:
 	bio_put(bio);
 	free_page((unsigned long) buf);
-	percpu_ref_get(&ca->io_ref);
+	percpu_ref_put(&ca->io_ref);
 	closure_put(w->cl);
 	kfree(w);
 	return 0;
@@ -289,29 +289,28 @@ static int read_btree_nodes(struct find_btree_nodes *f)
 			continue;
 
 		struct find_btree_nodes_worker *w = kmalloc(sizeof(*w), GFP_KERNEL);
-		struct task_struct *t;
-
 		if (!w) {
 			percpu_ref_put(&ca->io_ref);
 			ret = -ENOMEM;
 			goto err;
 		}
 
-		percpu_ref_get(&ca->io_ref);
-		closure_get(&cl);
 		w->cl		= &cl;
 		w->f		= f;
 		w->ca		= ca;
 
-		t = kthread_run(read_btree_nodes_worker, w, "read_btree_nodes/%s", ca->name);
+		struct task_struct *t = kthread_create(read_btree_nodes_worker, w, "read_btree_nodes/%s", ca->name);
 		ret = PTR_ERR_OR_ZERO(t);
 		if (ret) {
 			percpu_ref_put(&ca->io_ref);
-			closure_put(&cl);
-			f->ret = ret;
-			bch_err(c, "error starting kthread: %i", ret);
+			kfree(w);
+			bch_err_msg(c, ret, "starting kthread");
 			break;
 		}
+
+		closure_get(&cl);
+		percpu_ref_get(&ca->io_ref);
+		wake_up_process(t);
 	}
 err:
 	closure_sync(&cl);
-- 
2.47.2

