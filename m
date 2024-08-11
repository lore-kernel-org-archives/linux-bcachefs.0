Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B32158A25
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Aug 2024 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723412545; cv=none; b=lGW+27Rw38QgCO02atbWBatjR8n+UHssWuVvrTpdnPy7wY7kvkKkm9hTtrgfC3OOm95wuRMJDZWWmYpAC/sU33jxWrTlMYIOPcdUweQPFEM7BX7cikp0ssjk1V3iLfN45dFK5tvHuQGarThQMQWCzxwaay4wTU7yafnd8+0UjsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723412545; c=relaxed/simple;
	bh=DkrKXzoeKZ0U476jcq1fXBY3iG4bim55MsKBNLzL9Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d42ClC2udYTCYywn/UMBtTxy/MXsyUIMpgFeNn6mqmL7+qH91bqQuZcwLabpFDeXgazlwMsaPI9rGtSq4Wv0beR+obGGFwVVFic2vr5aMxX4DDZBxon5c8mQeY6dh/H7PG/IG2gx/YdGq8YuadvnmO0LYHwp8zTIr0o31u4LrXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=jLOwelIP; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="jLOwelIP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723412539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bGCUssTCjHSlgsA8YIrqKFvt8gcomSGF+5jWxiCS+oU=;
	b=jLOwelIPJ+TEZ+hgllKPNV8G9sndsyxuXwBk8WhzusSjmNKKu8qYLJTsJcO4gYOMtbNbEG
	zLBR4myG21QN7BzOB9Q1qPrty8W7eJXQpzxmxvtaM4vtpbw0NpaZ4jLU49sIoxr7uOQ8/X
	Z+m+XprYrbWlfZLak+dUpEspqStpZiThLZ0VepPpkwoTFGeVSNjMNAD4mQPBvOwe/qhdmv
	CKgC5jxCVtM0xrHb3PiPVeRILUTF/vCF5XAOS3XoJXQlpL0nQKaeVSA3XPaXBeUIKT1BM+
	Rbzpsnj6IfucPAXWHpv6eCMuev4VKo+S4rYoMZdaNs30+KX/lqitFj7srVl4DA==
From: Mae Kasza <git@badat.dev>
To: linux-bcachefs@vger.kernel.org
Cc: mae <git@badat.dev>
Subject: [PATCH] cmd_set_passphrase: initialize KDF parameters
Date: Sun, 11 Aug 2024 23:40:38 +0200
Message-ID: <20240811214152.86593-3-git@badat.dev>
In-Reply-To: <20240811214152.86593-2-git@badat.dev>
References: <20240811214152.86593-2-git@badat.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: mae <git@badat.dev>

The set-passphrase command failed to derive the key for disks initially
formatted with --encrypted and --no_passphrase.

This happened because bch_sb_crypt_init only configures the KDF params
if a passphrase is specified.
This commit makes the command initialize the KDF with the same parameters
as bch_sb_crypt_init if the key wasn't encrypted before.

Signed-off-by: Mae Kasza <git@badat.dev>
---
 c_src/cmd_key.c |  9 +++++++--
 c_src/crypto.c  | 13 ++++++++-----
 c_src/crypto.h  |  1 +
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/c_src/cmd_key.c b/c_src/cmd_key.c
index adb0ac8d..2da83758 100644
--- a/c_src/cmd_key.c
+++ b/c_src/cmd_key.c
@@ -104,7 +104,8 @@ int cmd_set_passphrase(int argc, char *argv[])
 	if (IS_ERR(c))
 		die("Error opening %s: %s", argv[1], bch2_err_str(PTR_ERR(c)));
 
-	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
+	struct bch_sb *sb = c->disk_sb.sb;
+	struct bch_sb_field_crypt *crypt = bch2_sb_field_get(sb, crypt);
 	if (!crypt)
 		die("Filesystem does not have encryption enabled");
 
@@ -116,9 +117,13 @@ int cmd_set_passphrase(int argc, char *argv[])
 		die("Error getting current key");
 
 	char *new_passphrase = read_passphrase_twice("Enter new passphrase: ");
+	if (!bch2_key_is_encrypted(&crypt->key)) {
+		bch_crypt_default_kdf_init(crypt);
+	}
+
 	struct bch_key passphrase_key = derive_passphrase(crypt, new_passphrase);
 
-	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(c->disk_sb.sb),
+	if (bch2_chacha_encrypt_key(&passphrase_key, __bch2_sb_key_nonce(sb),
 				    &new_key, sizeof(new_key)))
 		die("error encrypting key");
 	crypt->key = new_key;
diff --git a/c_src/crypto.c b/c_src/crypto.c
index 32671bd8..30ad92d4 100644
--- a/c_src/crypto.c
+++ b/c_src/crypto.c
@@ -180,11 +180,7 @@ void bch_sb_crypt_init(struct bch_sb *sb,
 	get_random_bytes(&crypt->key.key, sizeof(crypt->key.key));
 
 	if (passphrase) {
-
-		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
-		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
-		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
-		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
+		bch_crypt_default_kdf_init(crypt);
 
 		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
 
@@ -199,3 +195,10 @@ void bch_sb_crypt_init(struct bch_sb *sb,
 		memzero_explicit(&passphrase_key, sizeof(passphrase_key));
 	}
 }
+
+void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *crypt) {
+		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
+		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
+		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
+		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
+}
diff --git a/c_src/crypto.h b/c_src/crypto.h
index baea6d86..846a8931 100644
--- a/c_src/crypto.h
+++ b/c_src/crypto.h
@@ -18,5 +18,6 @@ void bch2_passphrase_check(struct bch_sb *, const char *,
 void bch2_add_key(struct bch_sb *, const char *, const char *, const char *);
 void bch_sb_crypt_init(struct bch_sb *sb, struct bch_sb_field_crypt *,
 		       const char *);
+void bch_crypt_default_kdf_init(struct bch_sb_field_crypt *);
 
 #endif /* _CRYPTO_H */
-- 
2.45.2

