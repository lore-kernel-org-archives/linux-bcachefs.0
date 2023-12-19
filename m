Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030591D53E
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNQcDQVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702994484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWzNI8UGGU2DDy+Abz1cGToH+TDaZ/Dp42vXcj5wMqs=;
	b=FNQcDQVjnz49kufAS1f8pgaY+nomZ7GFmKDcAVEWVWJE6na8NvyCoB/3R6ok2kld2ca0wo
	o2wRe48bzSevsCpgfxdN0onPcRhOdXtk4zjNw/2COkdnrqtojkxzjapWcxrrPpFpOWHA7q
	OD8u+df5jYHz2tHCy1JPb2CyZ+/Reng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-w2ZNYMpsP5SaSPstPxft0w-1; Tue, 19 Dec 2023 09:01:14 -0500
X-MC-Unique: w2ZNYMpsP5SaSPstPxft0w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E636385A58E
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C86B0492BF0
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: clean up some dead fallocate code
Date: Tue, 19 Dec 2023 09:02:15 -0500
Message-ID: <20231219140215.300753-3-bfoster@redhat.com>
In-Reply-To: <20231219140215.300753-1-bfoster@redhat.com>
References: <20231219140215.300753-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

The have_reservation local variable in bch2_extent_fallocate() is
initialized to false and set to true further down in the function.
Between this two points, one branch of code checks for negative
value and one for positive, and nothing ever checks the variable
after it is set to true. Clean up some of the unnecessary logic and
code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/io_misc.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index eab0c8c57785..521c32554dd0 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -34,8 +34,7 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 	struct open_buckets open_buckets = { 0 };
 	struct bkey_s_c k;
 	struct bkey_buf old, new;
-	unsigned sectors_allocated = 0;
-	bool have_reservation = false;
+	unsigned sectors_allocated = 0, new_replicas;
 	bool unwritten = opts.nocow &&
 	    c->sb.version >= bcachefs_metadata_version_unwritten_extents;
 	int ret;
@@ -50,28 +49,20 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 		return ret;
 
 	sectors = min_t(u64, sectors, k.k->p.offset - iter->pos.offset);
+	new_replicas = max(0, (int) opts.data_replicas -
+			   (int) bch2_bkey_nr_ptrs_fully_allocated(k));
 
-	if (!have_reservation) {
-		unsigned new_replicas =
-			max(0, (int) opts.data_replicas -
-			    (int) bch2_bkey_nr_ptrs_fully_allocated(k));
-		/*
-		 * Get a disk reservation before (in the nocow case) calling
-		 * into the allocator:
-		 */
-		ret = bch2_disk_reservation_get(c, &disk_res, sectors, new_replicas, 0);
-		if (unlikely(ret))
-			goto err;
-
-		bch2_bkey_buf_reassemble(&old, c, k);
-	}
+	/*
+	 * Get a disk reservation before (in the nocow case) calling
+	 * into the allocator:
+	 */
+	ret = bch2_disk_reservation_get(c, &disk_res, sectors, new_replicas, 0);
+	if (unlikely(ret))
+		goto err;
 
-	if (have_reservation) {
-		if (!bch2_extents_match(k, bkey_i_to_s_c(old.k)))
-			goto err;
+	bch2_bkey_buf_reassemble(&old, c, k);
 
-		bch2_key_resize(&new.k->k, sectors);
-	} else if (!unwritten) {
+	if (!unwritten) {
 		struct bkey_i_reservation *reservation;
 
 		bch2_bkey_buf_realloc(&new, c, sizeof(*reservation) / sizeof(u64));
@@ -118,8 +109,6 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 			ptr->unwritten = true;
 	}
 
-	have_reservation = true;
-
 	ret = bch2_extent_update(trans, inum, iter, new.k, &disk_res,
 				 0, i_sectors_delta, true);
 err:
-- 
2.42.0

