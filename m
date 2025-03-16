Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D32E3364
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742096898; cv=none; b=gOuUhTJ49p7jbc9q4jSUXaHBiSgz61oPPcN2j6Q/5ZH7stqbL78v8rT1qbuwgL7PW8bXkFzsAWUjCRe3mOoROupFEMgTYPaF6DtsUSqV5PJknsLmrUuULGtZaFHS2VpHQLCDGHp5z8+h6pETZLGFohPqt1atYAxZk2ZWbL5WjJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742096898; c=relaxed/simple;
	bh=xDlkLCFqLu0VMlxw6w5oNgrKxN1AlkNxkYXgQ/NKsrw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Y6kBxXOMvOZigbzxZQoFnDIcZgWoRFKyRaFmF/t7v9E9nI1Kp/cAW2Tf2/gUMd0rzowWptP4ewGjrq0XBh4wiCPCSL+GAFCdHKWwnfwF+iOCHE9wrJ6HD14oPP/XvdPAoOgCop2z4pDmG3kZBCXayZSanPW/XtD4cwVTQkZr2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcF9SeSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcF9SeSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3A2C4CEDD
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742096896;
	bh=xDlkLCFqLu0VMlxw6w5oNgrKxN1AlkNxkYXgQ/NKsrw=;
	h=From:To:Subject:Date:From;
	b=tcF9SeSqK3asTg+YqToRTVXE9jSQR0v9ClMqWqNGl/RbTCajnRIu9FOgscs4fms7J
	 1io82RG8QiFGd8uKoNiddRNjBvStipybCpdObgiBO6P9Qm/zUjfQQmN6OJlc9JaecO
	 y99GI5wAOlxfnFmBGF7p7rmQqpQKAAMZaXaZYfRGUc4TExCQDoSwWFHDy1uZ1XxQOB
	 t2huSNrXY2+tsFsvtraG0xWFbOMB6b4mp2u1eQyc5JBj2Rm0s3CjAdd5xYv/6g3oPQ
	 Ry3QQSAWkggHQLzoS6MZj0us+YPpx5NGr/udLntna5ecOUWzWMH00x0iR9Aqr+azVK
	 Y4HxRcYqhPaEA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: use sha256() instead of crypto_shash API
Date: Sat, 15 Mar 2025 20:47:17 -0700
Message-ID: <20250316034717.154288-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Just use sha256() instead of the clunky crypto API.  This is much
simpler.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/Kconfig    |  2 +-
 fs/bcachefs/bcachefs.h |  1 -
 fs/bcachefs/checksum.c | 10 ----------
 fs/bcachefs/str_hash.h |  8 ++------
 fs/bcachefs/super.c    |  1 -
 5 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index fc7efd0a7525e..c9798750202d3 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -14,11 +14,11 @@ config BCACHEFS_FS
 	select ZLIB_DEFLATE
 	select ZLIB_INFLATE
 	select ZSTD_COMPRESS
 	select ZSTD_DECOMPRESS
 	select CRYPTO
-	select CRYPTO_SHA256
+	select CRYPTO_LIB_SHA256
 	select CRYPTO_CHACHA20
 	select CRYPTO_POLY1305
 	select KEYS
 	select RAID6_PQ
 	select XOR_BLOCKS
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index b432bb6e6f6e0..0ea593e813f43 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -977,11 +977,10 @@ struct bch_fs {
 
 	mempool_t		compression_bounce[2];
 	mempool_t		compress_workspace[BCH_COMPRESSION_OPT_NR];
 	size_t			zstd_workspace_size;
 
-	struct crypto_shash	*sha256;
 	struct crypto_sync_skcipher *chacha20;
 	struct crypto_shash	*poly1305;
 
 	atomic64_t		key_version;
 
diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 23a383577d4c7..208e13e308084 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -786,28 +786,18 @@ void bch2_fs_encryption_exit(struct bch_fs *c)
 {
 	if (c->poly1305)
 		crypto_free_shash(c->poly1305);
 	if (c->chacha20)
 		crypto_free_sync_skcipher(c->chacha20);
-	if (c->sha256)
-		crypto_free_shash(c->sha256);
 }
 
 int bch2_fs_encryption_init(struct bch_fs *c)
 {
 	struct bch_sb_field_crypt *crypt;
 	struct bch_key key;
 	int ret = 0;
 
-	c->sha256 = crypto_alloc_shash("sha256", 0, 0);
-	ret = PTR_ERR_OR_ZERO(c->sha256);
-	if (ret) {
-		c->sha256 = NULL;
-		bch_err(c, "error requesting sha256 module: %s", bch2_err_str(ret));
-		goto out;
-	}
-
 	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
 	if (!crypt)
 		goto out;
 
 	ret = bch2_alloc_ciphers(c);
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index f645a4547b049..575ad1e039040 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -10,11 +10,10 @@
 #include "siphash.h"
 #include "subvolume.h"
 #include "super.h"
 
 #include <linux/crc32c.h>
-#include <crypto/hash.h>
 #include <crypto/sha2.h>
 
 static inline enum bch_str_hash_type
 bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
 {
@@ -53,17 +52,14 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 #endif
 		.siphash_key = { .k0 = bi->bi_hash_seed }
 	};
 
 	if (unlikely(info.type == BCH_STR_HASH_siphash_old)) {
-		SHASH_DESC_ON_STACK(desc, c->sha256);
 		u8 digest[SHA256_DIGEST_SIZE];
 
-		desc->tfm = c->sha256;
-
-		crypto_shash_digest(desc, (void *) &bi->bi_hash_seed,
-				    sizeof(bi->bi_hash_seed), digest);
+		sha256((const u8 *)&bi->bi_hash_seed,
+		       sizeof(bi->bi_hash_seed), digest);
 		memcpy(&info.siphash_key, digest, sizeof(info.siphash_key));
 	}
 
 	return info;
 }
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 6de3a5751561e..8e928b3d8ef4a 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -73,11 +73,10 @@
 #include <crypto/hash.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
 MODULE_DESCRIPTION("bcachefs filesystem");
-MODULE_SOFTDEP("pre: sha256");
 MODULE_SOFTDEP("pre: chacha20");
 MODULE_SOFTDEP("pre: poly1305");
 MODULE_SOFTDEP("pre: xxhash");
 
 const char * const bch2_fs_flag_strs[] = {

base-commit: da920b7df701770e006928053672147075587fb2
prerequisite-patch-id: 500a8dddbef9cb497eecaf59c0cb8fc7f2e4380e
-- 
2.49.0

