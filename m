Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32A6264A69
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724135; cv=none; b=iXvP4Byf4YAtifjwS+ovyWJheDiyNYhCitua2NAQx9inuEdNcXHU4OhgEUfRWYxI6AWUglCRRykuSip4MiDY7xkmqCvVmSQD/bUj033Uj282RUJgjB5QknbtalejWDg6lrCOa3otNCTkNdkh6Ht6M0B+bYGpAP3pRWq6F7doOTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724135; c=relaxed/simple;
	bh=8RLDhBbptWDOjEJSu0VwvYsG+IUqddikGe0Q5xvmmzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCdWYPkm1t38xjIie4jWJ0+UD8OBN4d96XcISOo9CZNk4L41eANZ0cOyM1iUHhrf0ju5blwMYgQAbl59yIp3BxhrkbuOuE5UFXKugRzsWBesCmn4/j0Kl01YbnCc3ncS2yGGCjfQJ2kIwUr8CIkp3B5HPQ1SGSEB8pl3K4NYhrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wAHyBOqB; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wAHyBOqB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcpRiKs6VKjgplUQ8qXrJvD0fiFKnoWLicsnUPdLVdM=;
	b=wAHyBOqBiWD0ot4BdctXVGE6k3FE2h/M+GSMQHL1/PG8s6LXaTJDJO3pQsrZisrsePPTK+
	bkdddxplkWhdNvoNCZLdPj8p/OivCgs3rvN+xJ2Hq3G9nq1lZui5bXLqOJgNWb2UmMCxns
	3EG7eRXFa2YhguMsYrS2FSTjsMZNqAQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/14] bcachefs: BCH_ERR_data_read_buffer_too_small
Date: Tue, 11 Mar 2025 16:15:06 -0400
Message-ID: <20250311201518.3573009-5-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that the read path uses proper error codes, we can get rid of the
weird rbio->hole signalling to the move path that the read didn't
happen.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/errcode.h | 2 ++
 fs/bcachefs/io_read.c | 9 ++++-----
 fs/bcachefs/io_read.h | 1 -
 fs/bcachefs/move.c    | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 5050d978624b..afa16d58041e 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -295,6 +295,8 @@
 	x(BCH_ERR_data_read,		data_read_ptr_stale_race)		\
 	x(BCH_ERR_data_read_retry,	data_read_ptr_stale_retry)		\
 	x(BCH_ERR_data_read,		data_read_no_encryption_key)		\
+	x(BCH_ERR_data_read,		data_read_buffer_too_small)		\
+	x(BCH_ERR_data_read,		data_read_key_overwritten)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_fixable)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_want_retry)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_must_retry)		\
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 03baab542abb..8f514d7e4021 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -437,7 +437,7 @@ static noinline void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_
 
 	if (!bkey_and_val_eq(k, bkey_i_to_s_c(u->k.k))) {
 		/* extent we wanted to read no longer exists: */
-		rbio->hole = true;
+		rbio->ret = -BCH_ERR_data_read_key_overwritten;
 		goto err;
 	}
 
@@ -992,10 +992,10 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		 */
 		struct data_update *u = container_of(orig, struct data_update, rbio);
 		if (pick.crc.compressed_size > u->op.wbio.bio.bi_iter.bi_size) {
-			BUG();
 			if (ca)
 				percpu_ref_put(&ca->io_ref);
-			goto hole;
+			rbio->ret = -BCH_ERR_data_read_buffer_too_small;
+			goto out_read_done;
 		}
 
 		iter.bi_size	= pick.crc.compressed_size << 9;
@@ -1075,7 +1075,6 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	rbio->flags		= flags;
 	rbio->have_ioref	= ca != NULL;
 	rbio->narrow_crcs	= narrow_crcs;
-	rbio->hole		= 0;
 	rbio->ret		= 0;
 	rbio->context		= 0;
 	rbio->pick		= pick;
@@ -1207,7 +1206,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	 * to read no longer exists we have to signal that:
 	 */
 	if (flags & BCH_READ_data_update)
-		orig->hole = true;
+		orig->ret = -BCH_ERR_data_read_key_overwritten;
 
 	zero_fill_bio_iter(&orig->bio, iter);
 out_read_done:
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index dd6694c2cf3f..b29fedd85a9c 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -40,7 +40,6 @@ struct bch_read_bio {
 				split:1,
 				have_ioref:1,
 				narrow_crcs:1,
-				hole:1,
 				saw_error:1,
 				context:2;
 	};
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 0787d04a5fc3..8cfd842a86cf 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -125,8 +125,8 @@ static void move_write(struct moving_io *io)
 				     &ctxt->stats->sectors_error_corrected);
 	}
 
-	if (unlikely(io->write.rbio.bio.bi_status ||
-		     io->write.rbio.hole ||
+	if (unlikely(io->write.rbio.ret ||
+		     io->write.rbio.bio.bi_status ||
 		     io->write.data_opts.scrub)) {
 		move_free(io);
 		return;
-- 
2.47.2

