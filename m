Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C2221CA0D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283700; cv=none; b=GmWBNLFgdXFx75TUfTHO/LjVM5C4FQxKXlTM/YkpnKEA/DocULKWXQXTPAtDnx5czE9ewo1/4dtRgFbir6J7JbMxCG2nZXkKDSjUan+8v1w+i0VFuzUk80jWlTku1rJmNzDQ8FmE5M6o/gVWpuG2o7dxDXAeseb3/lQ3/JVbhOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283700; c=relaxed/simple;
	bh=66m4SQqUHgFiZT60IA3M7EKBPXvOvxo94TV8/T/jlQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/T7ZCqtpeh5wWLFPMEuVgE4pd9SfrbuYZxJeqnlFBstz7dPawkov9IOz+OrglGGoU6YqfZS2XWh2tGOX8Tw5oJ5am6IcQISZpjYJEr3KmmZ9Pyp900a+NqMmFcODe2XCpGL4NU6fM9oessfdoVhvXI+oNbxCsPagLSKXPmdgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hd9XNlSV; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hd9XNlSV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HO83IKiHUmlvALTtbeo6NqCd9ad76tjmwiHFDWHZxDg=;
	b=Hd9XNlSVGAYY9306b9OClC2tGEDx7B+XGRQ3upA0J8ymskcDV+QY3r7lHx/NUK2SQKFIya
	8EdSpNDpxAtb7wgw2sVJrD+u3nWpW8FNxewOzJQIBxqeXd6UGRNklv0/W9JKrjzjo7YE+r
	6I6NVR6zDAutexaQa8lPqSdfz60NkMU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 18/37] bcachefs: Move bset size check before csum check
Date: Wed, 18 Jun 2025 17:54:09 -0400
Message-ID: <20250618215431.738317-19-kent.overstreet@linux.dev>
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

In syzbot's crash, the bset's u64s is larger than the btree node.

Reported-by: syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index d8f3c4c65e90..005d5c94edd0 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -723,12 +723,11 @@ void bch2_btree_node_drop_keys_outside_node(struct btree *b)
 
 static int validate_bset(struct bch_fs *c, struct bch_dev *ca,
 			 struct btree *b, struct bset *i,
-			 unsigned offset, unsigned sectors, int write,
+			 unsigned offset, int write,
 			 struct bch_io_failures *failed,
 			 struct printbuf *err_msg)
 {
 	unsigned version = le16_to_cpu(i->version);
-	unsigned ptr_written = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
 	struct printbuf buf1 = PRINTBUF;
 	struct printbuf buf2 = PRINTBUF;
 	int ret = 0;
@@ -778,15 +777,6 @@ static int validate_bset(struct bch_fs *c, struct bch_dev *ca,
 		     btree_node_unsupported_version,
 		     "BSET_SEPARATE_WHITEOUTS no longer supported");
 
-	if (!write &&
-	    btree_err_on(offset + sectors > (ptr_written ?: btree_sectors(c)),
-			 -BCH_ERR_btree_node_read_err_fixable,
-			 c, ca, b, i, NULL,
-			 bset_past_end_of_btree_node,
-			 "bset past end of btree node (offset %u len %u but written %zu)",
-			 offset, sectors, ptr_written ?: btree_sectors(c)))
-		i->u64s = 0;
-
 	btree_err_on(offset && !i->u64s,
 		     -BCH_ERR_btree_node_read_err_fixable,
 		     c, ca, b, i, NULL,
@@ -1151,6 +1141,14 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 			     "unknown checksum type %llu", BSET_CSUM_TYPE(i));
 
 		if (first) {
+			sectors = vstruct_sectors(b->data, c->block_bits);
+			if (btree_err_on(b->written + sectors > (ptr_written ?: btree_sectors(c)),
+					 -BCH_ERR_btree_node_read_err_fixable,
+					 c, ca, b, i, NULL,
+					 bset_past_end_of_btree_node,
+					 "bset past end of btree node (offset %u len %u but written %zu)",
+					 b->written, sectors, ptr_written ?: btree_sectors(c)))
+				i->u64s = 0;
 			if (good_csum_type) {
 				struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, b->data);
 				bool csum_bad = bch2_crc_cmp(b->data->csum, csum);
@@ -1178,9 +1176,15 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 				     c, NULL, b, NULL, NULL,
 				     btree_node_unsupported_version,
 				     "btree node does not have NEW_EXTENT_OVERWRITE set");
-
-			sectors = vstruct_sectors(b->data, c->block_bits);
 		} else {
+			sectors = vstruct_sectors(bne, c->block_bits);
+			if (btree_err_on(b->written + sectors > (ptr_written ?: btree_sectors(c)),
+					 -BCH_ERR_btree_node_read_err_fixable,
+					 c, ca, b, i, NULL,
+					 bset_past_end_of_btree_node,
+					 "bset past end of btree node (offset %u len %u but written %zu)",
+					 b->written, sectors, ptr_written ?: btree_sectors(c)))
+				i->u64s = 0;
 			if (good_csum_type) {
 				struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, bne);
 				bool csum_bad = bch2_crc_cmp(bne->csum, csum);
@@ -1201,14 +1205,12 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 						"decrypting btree node: %s", bch2_err_str(ret)))
 					goto fsck_err;
 			}
-
-			sectors = vstruct_sectors(bne, c->block_bits);
 		}
 
 		b->version_ondisk = min(b->version_ondisk,
 					le16_to_cpu(i->version));
 
-		ret = validate_bset(c, ca, b, i, b->written, sectors, READ, failed, err_msg);
+		ret = validate_bset(c, ca, b, i, b->written, READ, failed, err_msg);
 		if (ret)
 			goto fsck_err;
 
@@ -2267,7 +2269,7 @@ static void btree_node_write_endio(struct bio *bio)
 }
 
 static int validate_bset_for_write(struct bch_fs *c, struct btree *b,
-				   struct bset *i, unsigned sectors)
+				   struct bset *i)
 {
 	int ret = bch2_bkey_validate(c, bkey_i_to_s_c(&b->key),
 				     (struct bkey_validate_context) {
@@ -2282,7 +2284,7 @@ static int validate_bset_for_write(struct bch_fs *c, struct btree *b,
 	}
 
 	ret = validate_bset_keys(c, b, i, WRITE, NULL, NULL) ?:
-		validate_bset(c, NULL, b, i, b->written, sectors, WRITE, NULL, NULL);
+		validate_bset(c, NULL, b, i, b->written, WRITE, NULL, NULL);
 	if (ret) {
 		bch2_inconsistent_error(c);
 		dump_stack();
@@ -2475,7 +2477,7 @@ void __bch2_btree_node_write(struct bch_fs *c, struct btree *b, unsigned flags)
 
 	/* if we're going to be encrypting, check metadata validity first: */
 	if (validate_before_checksum &&
-	    validate_bset_for_write(c, b, i, sectors_to_write))
+	    validate_bset_for_write(c, b, i))
 		goto err;
 
 	ret = bset_encrypt(c, i, b->written << 9);
@@ -2492,7 +2494,7 @@ void __bch2_btree_node_write(struct bch_fs *c, struct btree *b, unsigned flags)
 
 	/* if we're not encrypting, check metadata after checksumming: */
 	if (!validate_before_checksum &&
-	    validate_bset_for_write(c, b, i, sectors_to_write))
+	    validate_bset_for_write(c, b, i))
 		goto err;
 
 	/*
-- 
2.50.0

