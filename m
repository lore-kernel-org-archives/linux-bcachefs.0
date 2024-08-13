Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A218C3D
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723570712; cv=none; b=UK145dBL/BaVSLIl8+NG6J3iBYtzBkOUnM+o5vVd9cJD2DCZdJn74SEUVoxNWsHeg8Hizy8o9fsm4y7W17uWp4LMxF9/hOExHvcxwAeyQbPJCQSAKD6TNZ19li74zJk8ODx9y1CUruMSaPrb9I1PT2hBxMNtVIDlzIfl/VR6fow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723570712; c=relaxed/simple;
	bh=/yDbOXrEBLNZHg6PaGN2M+EOFT9OMPnmDguoyMN/s04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAYr3Sp7EFtbGsxTGwTuYZCvVNE96VhCuUq+/5lHezhcaimMQ7wU9WGFGnY72pRYsmaWNmZsiCmp0X81yDQXDzlBzhJmXQETXIW0dpv+tnAROMPzqI0WsdydR82/I4v9pKP6wMPwUsOd1X35IwNIZ1YwWGvkAmCHH2JlJ+3vtzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=nrBHbKF4; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="nrBHbKF4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723570706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGV+2OHWBUnK2chzPEDahJnS+d5Q9cFp0pSMTgKOXps=;
	b=nrBHbKF49TL6huQ1UaRQzQ1zf7APCht6WyL3t1uei87g5Uc9u2wZhn++vTsURsKLCG7eSK
	Q9/COxi2vNDjRMYXR9Q93KOJe2qYsoQGN3eDP+0hYpuQue7u3r3uCjvAnochx1zWPJDRFK
	GOS+pOg7DtTra19LbMCiRxwmScZmo/nXXuEJ3tG3aLa/qqj54JA/KTYmb5YW5bGUrr1Whb
	q8lbuAGh/meGWtG8VKd76In6DZYOY+Ls0sW/xJP+QggoWYzeuW3j3VhVkryXcihBXoI9XR
	tBu7j5ZlzMAKKjxYpvetHrfjR/P/KxLCQtRIi5hhE7Y9213WOuKRxY48e+GjJA==
From: Mae Kasza <git@badat.dev>
To: git@badat.dev
Cc: kent.overstreet@linux.dev,
	lihongbo22@huawei.com,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] Extract bch_crypt_update_passphrase function
Date: Tue, 13 Aug 2024 19:37:35 +0200
Message-ID: <20240813173734.260952-2-git@badat.dev>
In-Reply-To: <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
References: <5252a768-7abe-4af1-8d78-9cbfbd1c9186@badat.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This also fixes a bug where the set-passphrase
command failed to derive the key for disks initially
formatted with --encrypted and --no_passphrase, due to
bch_sb_crypt_init not configuring the KDF params if
the passphrase wasn't specified during formatting.

Signed-off-by: Mae Kasza <git@badat.dev>
---
 c_src/cmd_key.c | 26 ++++++++++----------------
 c_src/crypto.c  | 43 ++++++++++++++++++++++++++++++++-----------
 c_src/crypto.h  |  3 +++
 3 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
index adb0ac8d..ac8a94a8 100644
--- a/c_src/cmd_key.c
+++ b/c_src/cmd_key.c
@@ -104,24 +104,19 @@ int cmd_set_passphrase(int argc, char *argv[])
 	if (IS_ERR(c))
 		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
 
-	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
+	struct bch_sb *sb = c->disk_sb.sb;
+	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
 	if (!crypt)
 		die("Filesystem does not have encryption enabled");
 
-	struct bch_encrypted_key new_key;
-	new_key.magic = BCH_KEY_MAGIC;
-
-	int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
+	struct bch_key key;
+	int ret = bch2_decrypt_sb_key(c, crypt, &key);
 	if (ret)
 		die("Error getting current key");
 
 	char *new_passphrase = read_passphrase_twice("Enter new passphrase: ");
-	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
 
-	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(c->disk_sb.sb),
-				    &new_key, sizeof(new_key)))
-		die("error encrypting key");
-	crypt->key = new_key;
+	bch_crypt_update_passphrase(sb, crypt, &key, new_passphrase);
 
 	bch2_revoke_key(c->disk_sb.sb);
 	bch2_write_super(c);
@@ -142,18 +137,17 @@ int cmd_remove_passphrase(int argc, char *argv[])
 	if (IS_ERR(c))
 		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
 
-	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
+	struct bch_sb *sb = c->disk_sb.sb;
+	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
 	if (!crypt)
 		die("Filesystem does not have encryption enabled");
 
-	struct bch_encrypted_key new_key;
-	new_key.magic = BCH_KEY_MAGIC;
-
-	int ret = bch2_decrypt_sb_key(c, crypt, &new_key.key);
+	struct bch_key key;
+	int ret = bch2_decrypt_sb_key(c, crypt, &key);
 	if (ret)
 		die("Error getting current key");
 
-	crypt->key = new_key;
+	bch_crypt_update_passphrase(sb, crypt, &key, NULL);
 
 	bch2_write_super(c);
 	bch2_fs_stop(c);
diff --git a/c_src/crypto.c b/c_src/crypto.c
index 32671bd8..301dbebe 100644
--- a/c_src/crypto.c
+++ b/c_src/crypto.c
@@ -176,26 +176,47 @@ void bch_sb_crypt_init(struct bch_sb *sb,
 		       struct bch_sb_field_crypt *crypt,
 		       const char *passphrase)
 {
+	struct bch_key key;
+	get_random_bytes(&key, sizeof(key));
+
 	crypt->key.magic = BCH_KEY_MAGIC;
-	get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
+	crypt->key.key = key;
 
-	if (passphrase) {
+	bch_crypt_update_passphrase(sb, crypt, &key, passphrase);
+}
 
+void bch_crypt_update_passphrase(
+			struct bch_sb *sb,
+			struct bch_sb_field_crypt *crypt,
+			struct bch_key *key,
+			const char *new_passphrase)
+{
+
+	struct bch_encrypted_key new_key;
+	new_key.magic = BCH_KEY_MAGIC;
+	new_key.key = *key;
+
+	if(!new_passphrase) {
+		crypt->key = new_key;
+		return;
+	}
+
+	// If crypt already has an encrypted key reuse it's encryption params
+	if (!bch2_key_is_encrypted(&crypt->key)) {
 		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
 		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
 		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
 		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
+	}
 
-		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
-
-		assert(!bch2_key_is_encrypted(&crypt->key));
+	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
 
-		if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
-					   &crypt->key, sizeof(crypt->key)))
-			die("error encrypting key");
+	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
+				    &new_key, sizeof(new_key)))
+		die("error encrypting key");
 
-		assert(bch2_key_is_encrypted(&crypt->key));
+	memzero_explicit(&passphrase_key, sizeof(passphrase_key));
 
-		memzero_explicit(&passphrase_key, sizeof(passphrase_key));
-	}
+	crypt->key = new_key;
+	assert(bch2_key_is_encrypted(&crypt->key));
 }
diff --git a/c_src/crypto.h b/c_src/crypto.h
index baea6d86..cd3baac8 100644
--- a/c_src/crypto.h
+++ b/c_src/crypto.h
@@ -19,4 +19,7 @@ void bch2_add_key(struct bch_sb *, const char *, const char *, const char *);
 void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
 		       const char *);
 
+void bch_crypt_update_passphrase(struct bch_sb *sb, struct bch_sb_field_crypt *crypt,
+			struct bch_key *key, const char *new_passphrase);
+
 #endif /* _CRYPTO_H */
-- 
2.45.2

