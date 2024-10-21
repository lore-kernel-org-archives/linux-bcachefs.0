Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB10B193435
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482090; cv=none; b=VVFsA4whdOOorHrC9xDpT9T550k6WeguFdiRn55wpYWbeUhjoWANebwsYvuP7I24veSs/FcEj3CMqGH4pwEOGoR3IKwHm4eHzzcqsm+1lI75pMqrscJMwDChECGXFtiljYPnLS6+wCM+/aeXgx2EY0yhp4X310az7QHjQx7qnOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482090; c=relaxed/simple;
	bh=H0bQEulDKWwxx7/z8faNSZQix7gDiCKp+KYBqSVJ3SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1LOoTbkLzHIRz18b+szmV53eHGUaG83feEmHLlDttcDMTVl3J01O2/rN8/tVhb8nrOTxBo9+OADbdZg0eUIjUeCmIG7pxNmALul00qC4ED2BUbDBAdDNYITy3jM5SMNnEAnTXsiZaQMbeBBHSw1VE+hYtvmf72qwiGyTZF0PPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PflkUeKY; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PflkUeKY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ONgxaGU/b8L95qhfJplwv3y7PuDw9ClxFuS4KKRI1I0=;
	b=PflkUeKY1WYi93x+jEBOkWvr0dfX6pXviBFV1gxfhGkqXxRBTzIBmXhuFOfPN76/X8Wyg8
	5QGY7XGzXZ9dx8ANA1Y/9nNsBF0S5eqyNxtpUpo4o6us2AUzrPQh7olhhATgA4T9kydRzr
	7wFMJxi9fbuN9iwmTIptOre8jHoQlIc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/12] bcachefs: Add bch_io_opts fields for indicating whether the opts came from the inode
Date: Sun, 20 Oct 2024 23:41:00 -0400
Message-ID: <20241021034106.384756-10-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is going to be used in the bch_extent_rebalance improvements, which
propagate io_path options into the extent (important for rebalance,
which needs something present in the extent for transactionally tagging
them in the rebalance_work btree, and also for indirect extents).

By tracking in bch_extent_rebalance whether the option came from the
filesystem or the inode we can correctly handle options being changed on
indirect extents.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/inode.c | 8 +++++++-
 fs/bcachefs/opts.h  | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 3af6029ea9b7..62fcc3a0bf69 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1142,7 +1142,13 @@ struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *inode)
 void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
 			 struct bch_inode_unpacked *inode)
 {
-#define x(_name, _bits)		opts->_name = inode_opt_get(c, inode, _name);
+#define x(_name, _bits)							\
+	if ((inode)->bi_##_name) {					\
+		opts->_name = inode->bi_##_name - 1;			\
+		opts->_name##_from_inode = true;			\
+	} else {							\
+		opts->_name = c->opts._name;				\
+	}
 	BCH_INODE_OPTS()
 #undef x
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 13555bc35f00..918eb6730117 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -624,6 +624,9 @@ struct bch_io_opts {
 #define x(_name, _bits)	u##_bits _name;
 	BCH_INODE_OPTS()
 #undef x
+#define x(_name, _bits)	u64 _name##_from_inode:1;
+	BCH_INODE_OPTS()
+#undef x
 };
 
 static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
-- 
2.45.2

