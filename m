Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1634C85
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749892695; cv=none; b=Cs9L8B5D2Pja7HsZop+XkQjqbwDFR9A4PBaWRGU600ObHCOVXWxcr5ZjdgC7w363IAPhrwfXzQXMBJGP4RsV4wL1pw+LGxEpFsKhPWJOzIdNg1YMU6tXzZ9wWTMcDDf8hzEf2NoOi/s0GjasZBxX9bI1jFNcVtT9lU1/i6/6imc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749892695; c=relaxed/simple;
	bh=JzPUoSplFpDLbMYCNcUF58dQgwkcQDgCYx7LR74f7Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ge8hQHOfehzUpxucQLGd5gFOf4eCMFjPS0MAiJaXEVD/87ye68dk/yeYETO5mceGcnwxH3GfbFOtLMNcjhh/wNzakMrE36YvmIQ7pIBFs3Zdsr4MTEXEOZa/k5SoJoCo8WYYwR77Sxp5ON+FBoXSEqqy6+HUJg/i94jC544s6YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwz1io3Q; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwz1io3Q"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748764d8540so2650994b3a.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749892693; x=1750497493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A/NGTUvwGymM18RRmkvUJ7Nfp7e12hXyCfUjr+6F31Y=;
        b=cwz1io3QZdv2OmSStqKzxZqwn48DxUH+bs0zo6lJA1On2v6oDtdm6bAVI0PLCsrMlb
         vqrGXSBQrZ1jdgtDbjDRqI3/8TilGJj/ni5UXUKT6Std41eGaiVxk4doLGmciR+OegkJ
         UA39xSfr6nn9mZ6mVy3ClAjvOMVRfQ1X66z7QRZwX20jQ/8rYZ5IJpMFenji/Q28YnNo
         9Phfr9Y9SSobFiePJLzyHoBB/tcgrUqXV7XVefWZ59Y8UoPAG2mQAjPnI5kixY59I4Bp
         DleyHd42dMQ7u+HrzKivP6QnAtCJC8gyntSH5af3FzTiazKgHAn2BGJlY2TEqn1Hgluv
         /sEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749892693; x=1750497493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A/NGTUvwGymM18RRmkvUJ7Nfp7e12hXyCfUjr+6F31Y=;
        b=JktsbBsjg9ljKwnztJjWUB//0XirIlvgvuKYmHslGr5WLajOBYJ7PaYwT/CYlSzz/t
         sVfcZ6hckBVvvf2uaaO7Gk7Lg48rfolovO/jvWRS9/a63dKJ80HWb0ypRZGv80dS0IHz
         9hPWrZaP5HThvOTc5Ki/HQdddIFcfBU4Z2XBaKzjjxiErKcIOIFtdhgE8vsnmLfzV0zT
         JWcSwYz7xdov5DI9LEmLvW6bKKC2/e/XC4nvBUFdwl5WHNdKOip8PpMtRiyQ7Q8uWgpd
         kUh/Xa/jI623r1N8S3nNe7SIuwSQo4YYGxW7LUupO6n5Off0ecyTF2Bx7KU3+r/L06Gf
         aLZA==
X-Gm-Message-State: AOJu0YyvbqRKsRZk4+gLEmsN9dXXPRc5JyDknx63c0wUnl08dYfLG+IQ
	k4V6L5A1N6YDXG6WAi+EpZFnDZWH2eNKi6cHHvJq1utixLArUwah7efxi4MNdA==
X-Gm-Gg: ASbGnctXqipQQ+BQsWHF2YLpPdUZFh1qBVSYnTRvEW8SK7nSD9zF2uaGkcLy6eCtMrz
	ou18UZxCXijws/Sd8oWqqRvY3F4MyBM0F42+9No01Ww6hHoYxZtfZaeT/+IxjoBRVFqt3MXEEiG
	gXK+5NFmrghqQ1PYS0r2ReoeU1SJ7vS42h/bTOW5V3xVWulUsMml03y47NeOneu79tjOFLJWyIx
	SglUJ0Nkhv89bnqc7B2orkWjn2QDsl5NZ+r0SJOMSUByexFCriBYx89tt9WPUQrGdUhWIect6lQ
	gn+nfHvNOtAh7H5Zh5ihf5HUAZk3MGkTlxMC
X-Google-Smtp-Source: AGHT+IEOoMWyeDxjiZzu3Xj5/UWDZ3nWozEiDZfX1q7WLEckTT0mAxU3SfG/KjtI7yMlHcsiWMHjqw==
X-Received: by 2002:a05:6a00:3c8f:b0:73c:c11:b42e with SMTP id d2e1a72fcca58-7489d0309f3mr3300164b3a.20.1749892692696;
        Sat, 14 Jun 2025 02:18:12 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b374csm3068469b3a.137.2025.06.14.02.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 02:18:11 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Move bset size check before csum check
Date: Sat, 14 Jun 2025 17:18:07 +0800
Message-ID: <20250614091807.111674-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In syzbot's crash, the bset's u64s is larger than the btree node.

Reported-by: syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
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
2.48.1

