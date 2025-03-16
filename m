Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E312E3361
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742094109; cv=none; b=G9FJHXVe772rIwICGZ+8yZ4mDNBqTdcKOdn3+hWBQMCc8NziRPI+NPgTOuu7C1Ls5rYcEEJINyd3NbArNXsk6xMeVaeFTSIeGVhOwxXDG/cKx//NFp9Cxyg3BVdUDsNtC1dP5JLWIjjjv4kkyDEOWIrVX3So12cYqTivO764IuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742094109; c=relaxed/simple;
	bh=+pXQFus7n+ijptHyfdRNNuQZ+fuzgvlyKY03J/RBkh0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=N6MvQNfYNItTWbI/bA2Oi/poXt4c9r/c9MV9D4XQ/stsGE/WJKv5EesoPqiSORqXNiwfwWTou8lB3Q0+AWqGOYMVwByXhCU+e2uKwC6d1ru0HPIjJVj8L4RkD0Zx7E4X0UEblyYn9jjLS7+YfLVk6jGwKiOYR5H1gHqQ1p/tZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AejTf4g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AejTf4g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28E4C4CEEC
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742094108;
	bh=+pXQFus7n+ijptHyfdRNNuQZ+fuzgvlyKY03J/RBkh0=;
	h=From:To:Subject:Date:From;
	b=AejTf4g3Ce6uN7qFeVZAx4VeRp34tcMyhwqpjM0iJHkbPmE5M8bfdVVk7DVpIq/ec
	 3c0d1eQuyHi67CyhyufRPST3+4I2DNyBB7K0CW50gSB3v+uNRBbMJItkL092pEe1ox
	 C19gA842xdUPhD1cmB7I5fk+42dO4+2YAawv/617FgEgCXsuC2zGUDSpjVUhW8Iinm
	 8Juaay1+SW3rWhOO4IfIodL1UIgTgUeZdBmacM2xbAafI/UXF5W4fnlQc/HSPzaVC4
	 9Ia6tTF+2xR8HYX8mZGD5NrVGgukOgdPkAvImzjW1mSMok8yZEABbK14ha93+SdnY6
	 heqA+LRgczRJg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Remove bch2_enable_encryption() and bch2_disable_encryption()
Date: Sat, 15 Mar 2025 20:01:37 -0700
Message-ID: <20250316030137.90673-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

These functions are never called, so remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/checksum.c | 90 ------------------------------------------
 fs/bcachefs/checksum.h |  3 --
 2 files changed, 93 deletions(-)

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 23a383577d4c7..3b6de913f45b9 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -8,11 +8,10 @@
 
 #include <linux/crc32c.h>
 #include <linux/crypto.h>
 #include <linux/xxhash.h>
 #include <linux/key.h>
-#include <linux/random.h>
 #include <linux/ratelimit.h>
 #include <linux/scatterlist.h>
 #include <crypto/algapi.h>
 #include <crypto/chacha.h>
 #include <crypto/hash.h>
@@ -691,99 +690,10 @@ static int bch2_alloc_ciphers(struct bch_fs *c)
 	c->chacha20	= chacha20;
 	c->poly1305	= poly1305;
 	return 0;
 }
 
-int bch2_disable_encryption(struct bch_fs *c)
-{
-	struct bch_sb_field_crypt *crypt;
-	struct bch_key key;
-	int ret = -EINVAL;
-
-	mutex_lock(&c->sb_lock);
-
-	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
-	if (!crypt)
-		goto out;
-
-	/* is key encrypted? */
-	ret = 0;
-	if (bch2_key_is_encrypted(&crypt->key))
-		goto out;
-
-	ret = bch2_decrypt_sb_key(c, crypt, &key);
-	if (ret)
-		goto out;
-
-	crypt->key.magic	= cpu_to_le64(BCH_KEY_MAGIC);
-	crypt->key.key		= key;
-
-	SET_BCH_SB_ENCRYPTION_TYPE(c->disk_sb.sb, 0);
-	bch2_write_super(c);
-out:
-	mutex_unlock(&c->sb_lock);
-
-	return ret;
-}
-
-int bch2_enable_encryption(struct bch_fs *c, bool keyed)
-{
-	struct bch_encrypted_key key;
-	struct bch_key user_key;
-	struct bch_sb_field_crypt *crypt;
-	int ret = -EINVAL;
-
-	mutex_lock(&c->sb_lock);
-
-	/* Do we already have an encryption key? */
-	if (bch2_sb_field_get(c->disk_sb.sb, crypt))
-		goto err;
-
-	ret = bch2_alloc_ciphers(c);
-	if (ret)
-		goto err;
-
-	key.magic = cpu_to_le64(BCH_KEY_MAGIC);
-	get_random_bytes(&key.key, sizeof(key.key));
-
-	if (keyed) {
-		ret = bch2_request_key(c->disk_sb.sb, &user_key);
-		if (ret) {
-			bch_err(c, "error requesting encryption key: %s", bch2_err_str(ret));
-			goto err;
-		}
-
-		ret = bch2_chacha_encrypt_key(&user_key, bch2_sb_key_nonce(c),
-					      &key, sizeof(key));
-		if (ret)
-			goto err;
-	}
-
-	ret = crypto_skcipher_setkey(&c->chacha20->base,
-			(void *) &key.key, sizeof(key.key));
-	if (ret)
-		goto err;
-
-	crypt = bch2_sb_field_resize(&c->disk_sb, crypt,
-				     sizeof(*crypt) / sizeof(u64));
-	if (!crypt) {
-		ret = -BCH_ERR_ENOSPC_sb_crypt;
-		goto err;
-	}
-
-	crypt->key = key;
-
-	/* write superblock */
-	SET_BCH_SB_ENCRYPTION_TYPE(c->disk_sb.sb, 1);
-	bch2_write_super(c);
-err:
-	mutex_unlock(&c->sb_lock);
-	memzero_explicit(&user_key, sizeof(user_key));
-	memzero_explicit(&key, sizeof(key));
-	return ret;
-}
-
 void bch2_fs_encryption_exit(struct bch_fs *c)
 {
 	if (c->poly1305)
 		crypto_free_shash(c->poly1305);
 	if (c->chacha20)
diff --git a/fs/bcachefs/checksum.h b/fs/bcachefs/checksum.h
index 43b9d71f2f2b4..5137bbfa0e352 100644
--- a/fs/bcachefs/checksum.h
+++ b/fs/bcachefs/checksum.h
@@ -101,13 +101,10 @@ static inline int bch2_encrypt_bio(struct bch_fs *c, unsigned type,
 extern const struct bch_sb_field_ops bch_sb_field_ops_crypt;
 
 int bch2_decrypt_sb_key(struct bch_fs *, struct bch_sb_field_crypt *,
 			struct bch_key *);
 
-int bch2_disable_encryption(struct bch_fs *);
-int bch2_enable_encryption(struct bch_fs *, bool);
-
 void bch2_fs_encryption_exit(struct bch_fs *);
 int bch2_fs_encryption_init(struct bch_fs *);
 
 static inline enum bch_csum_type bch2_csum_opt_to_type(enum bch_csum_opt type,
 						       bool data)

base-commit: da920b7df701770e006928053672147075587fb2
-- 
2.49.0

