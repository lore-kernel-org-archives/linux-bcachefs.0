Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8B227E05C
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283701; cv=none; b=Hg41USG2lAebtk6mQdnF7S4yt3CCDPaYhUw4hTENL2hK88SryYT5vDtVkjm7Oi/xMqEaZcqJugREFiAo6h0H/FFWFxCz7/1zQ/l/k5KEd5GDZlSfj9NO3SOgNSnLaWI65adGJaF0s+sGV0hxGuEQVGAjl/3nC+DqYQKIWRbkdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283701; c=relaxed/simple;
	bh=plZOj4kagiFIt5TCh+ozVJczAE9rsBxoCjQiD+bwfbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCMJ+IF9sUpBpZLE71F+rcmIT7Ufi1oft/fx4aIAlCV243k6O/SgBSuixb7Q9SrmnkbcgFSVfrCI4Q1XRnIUwATSdH620/Kzrc8UK5uynZGhRDFqOpFau0N3RT2Xzf4oTjz3frETXVJ22/rUM/EMyVaeJ8h2frJkszOKTJgOsuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fLDO5+Hy; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fLDO5+Hy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PxhZuGX3PNc6wjm/mVFFIA9KCukCFFcnGFq6/5/BRrU=;
	b=fLDO5+HyOd8UPNfU682Xn6OsfWajsn68jrsMd+hIIry/THDjs0Apf2602rXtVWiEkytZoR
	L6RvTsGEdIIWpHjNQYyDSjKxmZChfQhWl55tAneFl+5P2ObPzPYqeVr7MDSUaHIvu9bNwG
	Gcukzk1nlA33swQZz2hLnMrYA3D9O6I=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 19/37] bcachefs: Fix pool->alloc NULL pointer dereference
Date: Wed, 18 Jun 2025 17:54:10 -0400
Message-ID: <20250618215431.738317-20-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Alan Huang <mmpgouride@gmail.com>

btree_interior_update_pool has not been initialized before the
filesystem becomes read-write, thus mempool_alloc in bch2_btree_update_start
will trigger pool->alloc NULL pointer dereference in mempool_alloc_noprof

Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |  3 ++-
 fs/bcachefs/chardev.c  | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 5a1cede2febf..8043943cdf6a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -767,7 +767,8 @@ struct btree_trans_buf {
 	x(sysfs)							\
 	x(btree_write_buffer)						\
 	x(btree_node_scrub)						\
-	x(async_recovery_passes)
+	x(async_recovery_passes)					\
+	x(ioctl_data)
 
 enum bch_write_ref {
 #define x(n) BCH_WRITE_REF_##n,
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index fde3c2380e28..5ea89aa2b0c4 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -319,6 +319,7 @@ static int bch2_data_thread(void *arg)
 		ctx->stats.ret = BCH_IOCTL_DATA_EVENT_RET_done;
 		ctx->stats.data_type = (int) DATA_PROGRESS_DATA_TYPE_done;
 	}
+	enumerated_ref_put(&ctx->c->writes, BCH_WRITE_REF_ioctl_data);
 	return 0;
 }
 
@@ -378,15 +379,24 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	struct bch_data_ctx *ctx;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!enumerated_ref_tryget(&c->writes, BCH_WRITE_REF_ioctl_data))
+		return -EROFS;
 
-	if (arg.op >= BCH_DATA_OP_NR || arg.flags)
-		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto put_ref;
+	}
+
+	if (arg.op >= BCH_DATA_OP_NR || arg.flags) {
+		ret = -EINVAL;
+		goto put_ref;
+	}
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto put_ref;
+	}
 
 	ctx->c = c;
 	ctx->arg = arg;
@@ -395,7 +405,12 @@ static long bch2_ioctl_data(struct bch_fs *c,
 			&bcachefs_data_ops,
 			bch2_data_thread);
 	if (ret < 0)
-		kfree(ctx);
+		goto cleanup;
+	return ret;
+cleanup:
+	kfree(ctx);
+put_ref:
+	enumerated_ref_put(&c->writes, BCH_WRITE_REF_ioctl_data);
 	return ret;
 }
 
-- 
2.50.0

