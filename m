Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5AA3A1BA
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707148019; cv=none; b=HVTLymwHW3qz4gBTyUbUprx/Ad/ggRC7U2q1YnwwVr3FlyD5wqBc8TU5YiBvtH3soyVtIJNjK09S5VIXjaOILEWbELjaTFphOxE7EpmkrFKpNf/YfRyDYcTMvT4zuK/H2f3wlAUN7hj+fUzCdacjjUBXVFqsCgYgT1btN4rIcsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707148019; c=relaxed/simple;
	bh=0nDW0nITt5r3zz9sCdbYfg8NrjbthAgzBOzP0WPEzM8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IDkZWrr1BR1D2AzUEJyVobRqBYph2p1lgLorOG191S8i9Sp0q0Yuen6bD3Truq+G2PkcekzYQ9o1683OK8CUqp8cTNI9eySsCPs4zOzf4idSSwhrgxeUvi158hJ8RgCoWXgmg3prV3B3WVqGhi52bushYmj7YodAE36/Oo0+eT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O02QGclm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O02QGclm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707148016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EgxVRO/EV4cmc+logi7e5aE8AEC+DyI6cpSWXfle/9I=;
	b=O02QGclm7bOQpWVpGwmi9HjcJkSVTpIq6XcYTHNORv14u56PYhAO2iKwX/H7zlYczL6UT3
	7B1h1h1Sz5pSBjv9ZJw2pHh8tkNePj5V9SOgb4sygZxxt/SK+iAySbLzJ44EPU+Q48suK8
	FI7btMsysMfYwpnGBToqTXEJczmEroE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-dhWsLGPXMF6UN-GZpyWDhA-1; Mon,
 05 Feb 2024 10:46:55 -0500
X-MC-Unique: dhWsLGPXMF6UN-GZpyWDhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E301F1C068C6
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 15:46:54 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C99F1C2590D
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Feb 2024 15:46:54 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: fix iov_iter count underflow on sub-block dio read
Date: Mon,  5 Feb 2024 10:48:14 -0500
Message-ID: <20240205154814.910664-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

bch2_direct_IO_read() checks the request offset and size for sector
alignment and then falls through to a couple calculations to shrink
the size of the request based on the inode size. The problem is that
these checks round up to the fs block size, which runs the risk of
underflowing iter->count if the block size happens to be large
enough. This is triggered by fstest generic/361 with a 4k block
size, which subsequently leads to a crash.

After some discussion, the original purpose of the shorten logic in this
path is not totally clear. It appears to be intended as an optimization
of limited value, so simplify things and avoid the underflow problem by
removing it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that I left the ret variable name alone because it seemed to
bother me less after we realized it is actually the dio return
value.

Brian

 fs/bcachefs/fs-io-direct.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index e3b219e19e10..53f6e8a939d5 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -72,7 +72,6 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	struct bio *bio;
 	loff_t offset = req->ki_pos;
 	bool sync = is_sync_kiocb(req);
-	size_t shorten;
 	ssize_t ret;
 
 	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
@@ -87,9 +86,6 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	if (!ret)
 		return ret;
 
-	shorten = iov_iter_count(iter) - round_up(ret, block_bytes(c));
-	iter->count -= shorten;
-
 	bio = bio_alloc_bioset(NULL,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
 			       REQ_OP_READ,
@@ -158,8 +154,6 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 		bch2_read(c, rbio_init(bio, opts), inode_inum(inode));
 	}
 
-	iter->count += shorten;
-
 	if (sync) {
 		closure_sync(&dio->cl);
 		closure_debug_destroy(&dio->cl);
-- 
2.42.0

