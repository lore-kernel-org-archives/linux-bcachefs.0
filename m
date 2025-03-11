Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0B7264A6E
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724136; cv=none; b=LBs0+AX4TNPawcIleB81Pp75N0iNEpXayodjLS9B2KytAwMGpnXEcJcsO/Xwd4r9KbBbJCEkLYtoibdnozuIOwfoljhCFNZ9oIeqlEsT5MJYvVxqgvq8sogxG+Zqrz23LFqfTckvSmQz7KwnBmMuOn4CR61k8Fy2OxRFc3AsUSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724136; c=relaxed/simple;
	bh=p2Vnc1o/etYbK4dCWKB2wq+1EEZJf1xIRv0s+d21KD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfjJWOpkDc4r59skpbK4UE3mfkW1ZiVpttTEZuJ610vAj7o/f9XnxS/j+7JteozZCg+kct3Hp6mQu/rEbCtkRTMyDTjUzAgWgD2VJM4fSv2Kp6+/O8qhMz8YpjfKe55XIi3GjkCa7vZyg6qZxpJyX0+Sol+ZpwXWlFGqqyR0PkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sPF9OeOW; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sPF9OeOW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pf4OIIOH2jgDTIw3Is6+GRegBK8yC+G1TlAotRAJYUE=;
	b=sPF9OeOW4kb6qPRmBw6elE0axVsaRzkQnXD2ZgxkYJ8ADmAEFQ2l7rRee8qqu35tNKIsT+
	j5qV6sejr6mIcvbkxNrTex4jZQ6qRuwWj7jxlHYHhYBidn8PFA5VxziW0rXBt7DeAUn2Wq
	fE2oDG/ZNPH5cVgBCupWRlQCrYUg+Kk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/14] bcachefs: Return errors to top level bch2_rbio_retry()
Date: Tue, 11 Mar 2025 16:15:07 -0400
Message-ID: <20250311201518.3573009-6-kent.overstreet@linux.dev>
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

Next patch will be adding an additional retry loop for checksum errors,
so that we can rule out transient errors before marking an extent as
poisoned.

Prerequisite to this is returning errors to bch2_rbio_retry(); this will
also let us add a "successful retry" message.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 41 ++++++++++++++++++++++++++---------------
 fs/bcachefs/io_read.h |  4 ++--
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 8f514d7e4021..8764e88ef574 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -416,7 +416,7 @@ static void bch2_rbio_done(struct bch_read_bio *rbio)
 	bio_endio(&rbio->bio);
 }
 
-static noinline void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_bio *rbio,
+static noinline int bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_bio *rbio,
 				     struct bvec_iter bvec_iter,
 				     struct bch_io_failures *failed,
 				     unsigned flags)
@@ -451,12 +451,16 @@ static noinline void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_
 
 	if (bch2_err_matches(ret, BCH_ERR_data_read_retry))
 		goto retry;
-	if (ret)
-		rbio->bio.bi_status = BLK_STS_IOERR;
+
+	if (ret) {
+		rbio->bio.bi_status	= BLK_STS_IOERR;
+		rbio->ret		= ret;
+	}
 
 	BUG_ON(atomic_read(&rbio->bio.__bi_remaining) != 1);
-	bch2_rbio_done(rbio);
 	bch2_trans_put(trans);
+
+	return ret;
 }
 
 static void bch2_rbio_retry(struct work_struct *work)
@@ -491,10 +495,16 @@ static void bch2_rbio_retry(struct work_struct *work)
 	flags &= ~BCH_READ_last_fragment;
 	flags |= BCH_READ_must_clone;
 
-	if (flags & BCH_READ_data_update)
-		bch2_read_retry_nodecode(c, rbio, iter, &failed, flags);
-	else
-		__bch2_read(c, rbio, iter, inum, &failed, flags);
+	int ret = flags & BCH_READ_data_update
+		? bch2_read_retry_nodecode(c, rbio, iter, &failed, flags)
+		: __bch2_read(c, rbio, iter, inum, &failed, flags);
+
+	if (ret) {
+		rbio->ret = ret;
+		rbio->bio.bi_status = BLK_STS_IOERR;
+	}
+
+	bch2_rbio_done(rbio);
 }
 
 static void bch2_rbio_error(struct bch_read_bio *rbio,
@@ -1183,9 +1193,6 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		if (bch2_err_matches(ret, BCH_ERR_data_read_retry_avoid))
 			bch2_mark_io_failure(failed, &pick);
 
-		if (!ret)
-			goto out_read_done;
-
 		return ret;
 	}
 
@@ -1210,12 +1217,13 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 
 	zero_fill_bio_iter(&orig->bio, iter);
 out_read_done:
-	if (flags & BCH_READ_last_fragment)
+	if ((flags & BCH_READ_last_fragment) &&
+	    !(flags & BCH_READ_in_retry))
 		bch2_rbio_done(orig);
 	return 0;
 }
 
-void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
+int __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		 struct bvec_iter bvec_iter, subvol_inum inum,
 		 struct bch_io_failures *failed, unsigned flags)
 {
@@ -1305,18 +1313,21 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		lockrestart_do(trans,
 			bch2_inum_offset_err_msg_trans(trans, &buf, inum,
 						       bvec_iter.bi_sector << 9));
-		prt_printf(&buf, "read error %s from btree lookup", bch2_err_str(ret));
+		prt_printf(&buf, "read error: %s", bch2_err_str(ret));
 		bch_err_ratelimited(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 
 		rbio->bio.bi_status	= BLK_STS_IOERR;
 		rbio->ret		= ret;
 
-		bch2_rbio_done(rbio);
+		if (!(flags & BCH_READ_in_retry))
+			bch2_rbio_done(rbio);
 	}
 
 	bch2_trans_put(trans);
 	bch2_bkey_buf_exit(&sk, c);
+
+	return ret;
 }
 
 void bch2_fs_io_read_exit(struct bch_fs *c)
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index b29fedd85a9c..6e5ea5b45a54 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -140,8 +140,8 @@ static inline void bch2_read_extent(struct btree_trans *trans,
 			   data_btree, k, offset_into_extent, NULL, flags, -1);
 }
 
-void __bch2_read(struct bch_fs *, struct bch_read_bio *, struct bvec_iter,
-		 subvol_inum, struct bch_io_failures *, unsigned flags);
+int __bch2_read(struct bch_fs *, struct bch_read_bio *, struct bvec_iter,
+		subvol_inum, struct bch_io_failures *, unsigned flags);
 
 static inline void bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 			     subvol_inum inum)
-- 
2.47.2

