Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0392918B03;
	Wed,  2 Apr 2025 04:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743569129; cv=none; b=p52eQ97V9DNvwiTEVomxAVq42TncsTtJ80n4vn9/R98ytJdvsAfbp3gXwuyye3VZ0wDnH9a0Q85hLXu0dLH4P9efntWY34sLrjpWraOBrD4G/Pzwkiyhr3iIYxpGtsNvYa54zr4phOXzc7HSK6VM1TVco+K7ZpNjqYlTI/Hhnqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743569129; c=relaxed/simple;
	bh=8jiscLUsTEpumKGIO66DHGG7asGYJg7880fLninpAtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oi3XT0ZClvMNGVHuIWNCheMf2tUKB/QP3VTcQWXr60TOdPXmcIlMQgQToI90AttDcUbUYwTkIILfCe/QE0EVEswpP49Da9f7m1Os8XDvcdQm0u+n+v8Xc3J4HxdLRc5zt8ZXh9JRPFtWxoiW1EMF+TJIKV1TuFdkugurEewVbu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtPo39nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtPo39nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52317C4CEDD;
	Wed,  2 Apr 2025 04:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743569128;
	bh=8jiscLUsTEpumKGIO66DHGG7asGYJg7880fLninpAtE=;
	h=From:To:Cc:Subject:Date:From;
	b=DtPo39nwykiBHWFGgXJiuduNyg1sByc5Vwv/DsST2bFAlPJQiTLGy9jt4HBJ6RkgO
	 x7vnMyk1ipJ2GnVnNNMrmiwrru0owXWnO+2Hk/EDqVMMeAhoJKN936medo7WsHi93U
	 mn3YabVw6kxWsXAhVSpm1Qk+/MCBiHFkBWhC1V27UnXEVxRASRz8ULTzuITOagu3Nc
	 ZN0ZIvFkjlxoEj1gBotufb4tpYX65232miujniO7GXEAQAzwFfv9hzgSsWL5sd6EkJ
	 Rp685o4dFQb8nscTNyOxjLY+Hom5nBuzMZjOvpmelMm/4/FPnySDR+4tWjoLxiV/MV
	 54vY5B3xHEMMQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] bcachefs: use library APIs for ChaCha20 and Poly1305
Date: Tue,  1 Apr 2025 21:33:33 -0700
Message-ID: <20250402043333.352723-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Just use the ChaCha20 and Poly1305 libraries instead of the clunky
crypto API.  This is much simpler.  It is also slightly faster, since
the libraries provide more direct access to the same
architecture-optimized ChaCha20 and Poly1305 code.

I've tested that existing encrypted bcachefs filesystems can be continue
to be accessed with this patch applied.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/Kconfig           |   5 +-
 fs/bcachefs/bcachefs.h        |   4 +-
 fs/bcachefs/btree_node_scan.c |   2 +-
 fs/bcachefs/checksum.c        | 236 ++++++++--------------------------
 fs/bcachefs/checksum.h        |   3 +-
 fs/bcachefs/io_read.c         |   3 +-
 fs/bcachefs/super.c           |   3 -
 7 files changed, 61 insertions(+), 195 deletions(-)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index c9798750202d3..65f3645056683 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -13,14 +13,13 @@ config BCACHEFS_FS
 	select LZ4HC_DECOMPRESS
 	select ZLIB_DEFLATE
 	select ZLIB_INFLATE
 	select ZSTD_COMPRESS
 	select ZSTD_DECOMPRESS
-	select CRYPTO
 	select CRYPTO_LIB_SHA256
-	select CRYPTO_CHACHA20
-	select CRYPTO_POLY1305
+	select CRYPTO_LIB_CHACHA
+	select CRYPTO_LIB_POLY1305
 	select KEYS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select XXHASH
 	select SRCU
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index f52311017aeef..203cebdca186e 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -978,12 +978,12 @@ struct bch_fs {
 
 	mempool_t		compression_bounce[2];
 	mempool_t		compress_workspace[BCH_COMPRESSION_OPT_NR];
 	size_t			zstd_workspace_size;
 
-	struct crypto_sync_skcipher *chacha20;
-	struct crypto_shash	*poly1305;
+	struct bch_key		chacha20_key;
+	bool			chacha20_key_set;
 
 	atomic64_t		key_version;
 
 	mempool_t		large_bkey_pool;
 
diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 25d54b77cdc24..a4890d10bbca9 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -181,11 +181,11 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 
 	if (le64_to_cpu(bn->magic) != bset_magic(c))
 		return;
 
 	if (bch2_csum_type_is_encryption(BSET_CSUM_TYPE(&bn->keys))) {
-		if (!c->chacha20)
+		if (!c->chacha20_key_set)
 			return;
 
 		struct nonce nonce = btree_nonce(&bn->keys, 0);
 		unsigned bytes = (void *) &bn->keys - (void *) &bn->flags;
 
diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 3726689093e30..7d1e3b908eecd 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -5,21 +5,16 @@
 #include "error.h"
 #include "super.h"
 #include "super-io.h"
 
 #include <linux/crc32c.h>
-#include <linux/crypto.h>
 #include <linux/xxhash.h>
 #include <linux/key.h>
 #include <linux/random.h>
 #include <linux/ratelimit.h>
-#include <linux/scatterlist.h>
-#include <crypto/algapi.h>
 #include <crypto/chacha.h>
-#include <crypto/hash.h>
 #include <crypto/poly1305.h>
-#include <crypto/skcipher.h>
 #include <keys/user-type.h>
 
 /*
  * bch2_checksum state is an abstraction of the checksum state calculated over different pages.
  * it features page merging without having the checksum algorithm lose its state.
@@ -94,120 +89,44 @@ static void bch2_checksum_update(struct bch2_checksum_state *state, const void *
 	default:
 		BUG();
 	}
 }
 
-static inline int do_encrypt_sg(struct crypto_sync_skcipher *tfm,
-				struct nonce nonce,
-				struct scatterlist *sg, size_t len)
+static void bch2_chacha20_init(u32 state[CHACHA_STATE_WORDS],
+			       const struct bch_key *key, struct nonce nonce)
 {
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	u32 key_words[CHACHA_KEY_SIZE / sizeof(u32)];
 
-	skcipher_request_set_sync_tfm(req, tfm);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, len, nonce.d);
+	BUILD_BUG_ON(sizeof(key_words) != sizeof(*key));
+	memcpy(key_words, key, sizeof(key_words));
+	le32_to_cpu_array(key_words, ARRAY_SIZE(key_words));
 
-	int ret = crypto_skcipher_encrypt(req);
-	if (ret)
-		pr_err("got error %i from crypto_skcipher_encrypt()", ret);
+	BUILD_BUG_ON(sizeof(nonce) != CHACHA_IV_SIZE);
+	chacha_init(state, key_words, (const u8 *)nonce.d);
 
-	return ret;
+	memzero_explicit(key_words, sizeof(key_words));
 }
 
-static inline int do_encrypt(struct crypto_sync_skcipher *tfm,
-			      struct nonce nonce,
-			      void *buf, size_t len)
+static void bch2_chacha20(const struct bch_key *key, struct nonce nonce,
+			  void *data, size_t len)
 {
-	if (!is_vmalloc_addr(buf)) {
-		struct scatterlist sg = {};
-
-		sg_mark_end(&sg);
-		sg_set_page(&sg, virt_to_page(buf), len, offset_in_page(buf));
-		return do_encrypt_sg(tfm, nonce, &sg, len);
-	} else {
-		DARRAY_PREALLOCATED(struct scatterlist, 4) sgl;
-		size_t sgl_len = 0;
-		int ret;
-
-		darray_init(&sgl);
-
-		while (len) {
-			unsigned offset = offset_in_page(buf);
-			struct scatterlist sg = {
-				.page_link	= (unsigned long) vmalloc_to_page(buf),
-				.offset		= offset,
-				.length		= min(len, PAGE_SIZE - offset),
-			};
-
-			if (darray_push(&sgl, sg)) {
-				sg_mark_end(&darray_last(sgl));
-				ret = do_encrypt_sg(tfm, nonce, sgl.data, sgl_len);
-				if (ret)
-					goto err;
-
-				nonce = nonce_add(nonce, sgl_len);
-				sgl_len = 0;
-				sgl.nr = 0;
-				BUG_ON(darray_push(&sgl, sg));
-			}
-
-			buf += sg.length;
-			len -= sg.length;
-			sgl_len += sg.length;
-		}
-
-		sg_mark_end(&darray_last(sgl));
-		ret = do_encrypt_sg(tfm, nonce, sgl.data, sgl_len);
-err:
-		darray_exit(&sgl);
-		return ret;
-	}
-}
-
-int bch2_chacha_encrypt_key(struct bch_key *key, struct nonce nonce,
-			    void *buf, size_t len)
-{
-	struct crypto_sync_skcipher *chacha20 =
-		crypto_alloc_sync_skcipher("chacha20", 0, 0);
-	int ret;
+	u32 state[CHACHA_STATE_WORDS];
 
-	ret = PTR_ERR_OR_ZERO(chacha20);
-	if (ret) {
-		pr_err("error requesting chacha20 cipher: %s", bch2_err_str(ret));
-		return ret;
-	}
-
-	ret = crypto_skcipher_setkey(&chacha20->base,
-				     (void *) key, sizeof(*key));
-	if (ret) {
-		pr_err("error from crypto_skcipher_setkey(): %s", bch2_err_str(ret));
-		goto err;
-	}
-
-	ret = do_encrypt(chacha20, nonce, buf, len);
-err:
-	crypto_free_sync_skcipher(chacha20);
-	return ret;
+	bch2_chacha20_init(state, key, nonce);
+	chacha20_crypt(state, data, data, len);
+	memzero_explicit(state, sizeof(state));
 }
 
-static int gen_poly_key(struct bch_fs *c, struct shash_desc *desc,
-			struct nonce nonce)
+static void bch2_poly1305_init(struct poly1305_desc_ctx *desc,
+			       struct bch_fs *c, struct nonce nonce)
 {
-	u8 key[POLY1305_KEY_SIZE];
-	int ret;
+	u8 key[POLY1305_KEY_SIZE] = { 0 };
 
 	nonce.d[3] ^= BCH_NONCE_POLY;
 
-	memset(key, 0, sizeof(key));
-	ret = do_encrypt(c->chacha20, nonce, key, sizeof(key));
-	if (ret)
-		return ret;
-
-	desc->tfm = c->poly1305;
-	crypto_shash_init(desc);
-	crypto_shash_update(desc, key, sizeof(key));
-	return 0;
+	bch2_chacha20(&c->chacha20_key, nonce, key, sizeof(key));
+	poly1305_init(desc, key);
 }
 
 struct bch_csum bch2_checksum(struct bch_fs *c, unsigned type,
 			      struct nonce nonce, const void *data, size_t len)
 {
@@ -228,18 +147,17 @@ struct bch_csum bch2_checksum(struct bch_fs *c, unsigned type,
 		return (struct bch_csum) { .lo = cpu_to_le64(bch2_checksum_final(&state)) };
 	}
 
 	case BCH_CSUM_chacha20_poly1305_80:
 	case BCH_CSUM_chacha20_poly1305_128: {
-		SHASH_DESC_ON_STACK(desc, c->poly1305);
+		struct poly1305_desc_ctx dctx;
 		u8 digest[POLY1305_DIGEST_SIZE];
 		struct bch_csum ret = { 0 };
 
-		gen_poly_key(c, desc, nonce);
-
-		crypto_shash_update(desc, data, len);
-		crypto_shash_final(desc, digest);
+		bch2_poly1305_init(&dctx, c, nonce);
+		poly1305_update(&dctx, data, len);
+		poly1305_final(&dctx, digest);
 
 		memcpy(&ret, digest, bch_crc_bytes[type]);
 		return ret;
 	}
 	default:
@@ -251,15 +169,16 @@ int bch2_encrypt(struct bch_fs *c, unsigned type,
 		  struct nonce nonce, void *data, size_t len)
 {
 	if (!bch2_csum_type_is_encryption(type))
 		return 0;
 
-	if (bch2_fs_inconsistent_on(!c->chacha20,
+	if (bch2_fs_inconsistent_on(!c->chacha20_key_set,
 				    c, "attempting to encrypt without encryption key"))
 		return -BCH_ERR_no_encryption_key;
 
-	return do_encrypt(c->chacha20, nonce, data, len);
+	bch2_chacha20(&c->chacha20_key, nonce, data, len);
+	return 0;
 }
 
 static struct bch_csum __bch2_checksum_bio(struct bch_fs *c, unsigned type,
 					   struct nonce nonce, struct bio *bio,
 					   struct bvec_iter *iter)
@@ -294,30 +213,30 @@ static struct bch_csum __bch2_checksum_bio(struct bch_fs *c, unsigned type,
 		return (struct bch_csum) { .lo = cpu_to_le64(bch2_checksum_final(&state)) };
 	}
 
 	case BCH_CSUM_chacha20_poly1305_80:
 	case BCH_CSUM_chacha20_poly1305_128: {
-		SHASH_DESC_ON_STACK(desc, c->poly1305);
+		struct poly1305_desc_ctx dctx;
 		u8 digest[POLY1305_DIGEST_SIZE];
 		struct bch_csum ret = { 0 };
 
-		gen_poly_key(c, desc, nonce);
+		bch2_poly1305_init(&dctx, c, nonce);
 
 #ifdef CONFIG_HIGHMEM
 		__bio_for_each_segment(bv, bio, *iter, *iter) {
 			void *p = kmap_local_page(bv.bv_page) + bv.bv_offset;
 
-			crypto_shash_update(desc, p, bv.bv_len);
+			poly1305_update(&dctx, p, bv.bv_len);
 			kunmap_local(p);
 		}
 #else
 		__bio_for_each_bvec(bv, bio, *iter, *iter)
-			crypto_shash_update(desc,
+			poly1305_update(&dctx,
 				page_address(bv.bv_page) + bv.bv_offset,
 				bv.bv_len);
 #endif
-		crypto_shash_final(desc, digest);
+		poly1305_final(&dctx, digest);
 
 		memcpy(&ret, digest, bch_crc_bytes[type]);
 		return ret;
 	}
 	default:
@@ -336,47 +255,37 @@ struct bch_csum bch2_checksum_bio(struct bch_fs *c, unsigned type,
 int __bch2_encrypt_bio(struct bch_fs *c, unsigned type,
 		     struct nonce nonce, struct bio *bio)
 {
 	struct bio_vec bv;
 	struct bvec_iter iter;
-	DARRAY_PREALLOCATED(struct scatterlist, 4) sgl;
-	size_t sgl_len = 0;
+	u32 chacha_state[CHACHA_STATE_WORDS];
 	int ret = 0;
 
-	if (bch2_fs_inconsistent_on(!c->chacha20,
+	if (bch2_fs_inconsistent_on(!c->chacha20_key_set,
 				    c, "attempting to encrypt without encryption key"))
 		return -BCH_ERR_no_encryption_key;
 
-	darray_init(&sgl);
+	bch2_chacha20_init(chacha_state, &c->chacha20_key, nonce);
 
 	bio_for_each_segment(bv, bio, iter) {
-		struct scatterlist sg = {
-			.page_link	= (unsigned long) bv.bv_page,
-			.offset		= bv.bv_offset,
-			.length		= bv.bv_len,
-		};
-
-		if (darray_push(&sgl, sg)) {
-			sg_mark_end(&darray_last(sgl));
-			ret = do_encrypt_sg(c->chacha20, nonce, sgl.data, sgl_len);
-			if (ret)
-				goto err;
-
-			nonce = nonce_add(nonce, sgl_len);
-			sgl_len = 0;
-			sgl.nr = 0;
-
-			BUG_ON(darray_push(&sgl, sg));
+		void *p;
+
+		/*
+		 * chacha_crypt() assumes that the length is a multiple of
+		 * CHACHA_BLOCK_SIZE on any non-final call.
+		 */
+		if (!IS_ALIGNED(bv.bv_len, CHACHA_BLOCK_SIZE)) {
+			bch_err_ratelimited(c, "bio not aligned for encryption");
+			ret = -EIO;
+			break;
 		}
 
-		sgl_len += sg.length;
+		p = bvec_kmap_local(&bv);
+		chacha20_crypt(chacha_state, p, p, bv.bv_len);
+		kunmap_local(p);
 	}
-
-	sg_mark_end(&darray_last(sgl));
-	ret = do_encrypt_sg(c->chacha20, nonce, sgl.data, sgl_len);
-err:
-	darray_exit(&sgl);
+	memzero_explicit(chacha_state, sizeof(chacha_state));
 	return ret;
 }
 
 struct bch_csum bch2_checksum_merge(unsigned type, struct bch_csum a,
 				    struct bch_csum b, size_t b_len)
@@ -648,14 +557,11 @@ int bch2_decrypt_sb_key(struct bch_fs *c,
 		bch_err(c, "error requesting encryption key: %s", bch2_err_str(ret));
 		goto err;
 	}
 
 	/* decrypt real key: */
-	ret = bch2_chacha_encrypt_key(&user_key, bch2_sb_key_nonce(c),
-				      &sb_key, sizeof(sb_key));
-	if (ret)
-		goto err;
+	bch2_chacha20(&user_key, bch2_sb_key_nonce(c), &sb_key, sizeof(sb_key));
 
 	if (bch2_key_is_encrypted(&sb_key)) {
 		bch_err(c, "incorrect encryption key");
 		ret = -EINVAL;
 		goto err;
@@ -666,35 +572,10 @@ int bch2_decrypt_sb_key(struct bch_fs *c,
 	memzero_explicit(&sb_key, sizeof(sb_key));
 	memzero_explicit(&user_key, sizeof(user_key));
 	return ret;
 }
 
-static int bch2_alloc_ciphers(struct bch_fs *c)
-{
-	if (c->chacha20)
-		return 0;
-
-	struct crypto_sync_skcipher *chacha20 = crypto_alloc_sync_skcipher("chacha20", 0, 0);
-	int ret = PTR_ERR_OR_ZERO(chacha20);
-	if (ret) {
-		bch_err(c, "error requesting chacha20 module: %s", bch2_err_str(ret));
-		return ret;
-	}
-
-	struct crypto_shash *poly1305 = crypto_alloc_shash("poly1305", 0, 0);
-	ret = PTR_ERR_OR_ZERO(poly1305);
-	if (ret) {
-		bch_err(c, "error requesting poly1305 module: %s", bch2_err_str(ret));
-		crypto_free_sync_skcipher(chacha20);
-		return ret;
-	}
-
-	c->chacha20	= chacha20;
-	c->poly1305	= poly1305;
-	return 0;
-}
-
 #if 0
 
 /*
  * This seems to be duplicating code in cmd_remove_passphrase() in
  * bcachefs-tools, but we might want to switch userspace to use this - and
@@ -795,14 +676,11 @@ int bch2_enable_encryption(struct bch_fs *c, bool keyed)
 }
 #endif
 
 void bch2_fs_encryption_exit(struct bch_fs *c)
 {
-	if (c->poly1305)
-		crypto_free_shash(c->poly1305);
-	if (c->chacha20)
-		crypto_free_sync_skcipher(c->chacha20);
+	memzero_explicit(&c->chacha20_key, sizeof(c->chacha20_key));
 }
 
 int bch2_fs_encryption_init(struct bch_fs *c)
 {
 	struct bch_sb_field_crypt *crypt;
@@ -811,21 +689,13 @@ int bch2_fs_encryption_init(struct bch_fs *c)
 
 	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
 	if (!crypt)
 		goto out;
 
-	ret = bch2_alloc_ciphers(c);
-	if (ret)
-		goto out;
-
-	ret = bch2_decrypt_sb_key(c, crypt, &key);
-	if (ret)
-		goto out;
-
-	ret = crypto_skcipher_setkey(&c->chacha20->base,
-			(void *) &key.key, sizeof(key.key));
+	ret = bch2_decrypt_sb_key(c, crypt, &c->chacha20_key);
 	if (ret)
 		goto out;
+	c->chacha20_key_set = true;
 out:
 	memzero_explicit(&key, sizeof(key));
 	return ret;
 }
diff --git a/fs/bcachefs/checksum.h b/fs/bcachefs/checksum.h
index 4ac251c8fcd83..1310782d3ae93 100644
--- a/fs/bcachefs/checksum.h
+++ b/fs/bcachefs/checksum.h
@@ -67,11 +67,10 @@ static inline void bch2_csum_err_msg(struct printbuf *out,
 	bch2_csum_to_text(out, type, got);
 	prt_str(out, " should be ");
 	bch2_csum_to_text(out, type, expected);
 }
 
-int bch2_chacha_encrypt_key(struct bch_key *, struct nonce, void *, size_t);
 int bch2_request_key(struct bch_sb *, struct bch_key *);
 #ifndef __KERNEL__
 int bch2_revoke_key(struct bch_sb *);
 #endif
 
@@ -154,11 +153,11 @@ static inline bool bch2_checksum_type_valid(const struct bch_fs *c,
 					   unsigned type)
 {
 	if (type >= BCH_CSUM_NR)
 		return false;
 
-	if (bch2_csum_type_is_encryption(type) && !c->chacha20)
+	if (bch2_csum_type_is_encryption(type) && !c->chacha20_key_set)
 		return false;
 
 	return true;
 }
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index fd01e67b3e843..415d9927ab35c 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -975,11 +975,12 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		bch_err_ratelimited(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 		goto err;
 	}
 
-	if (unlikely(bch2_csum_type_is_encryption(pick.crc.csum_type)) && !c->chacha20) {
+	if (unlikely(bch2_csum_type_is_encryption(pick.crc.csum_type)) &&
+	    !c->chacha20_key_set) {
 		struct printbuf buf = PRINTBUF;
 		bch2_read_err_msg_trans(trans, &buf, orig, read_pos);
 		prt_printf(&buf, "attempting to read encrypted data without encryption key\n  ");
 		bch2_bkey_val_to_text(&buf, c, k);
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 20208f3c5d8b0..a450245714937 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -68,17 +68,14 @@
 #include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/random.h>
 #include <linux/sysfs.h>
-#include <crypto/hash.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
 MODULE_DESCRIPTION("bcachefs filesystem");
-MODULE_SOFTDEP("pre: chacha20");
-MODULE_SOFTDEP("pre: poly1305");
 MODULE_SOFTDEP("pre: xxhash");
 
 const char * const bch2_fs_flag_strs[] = {
 #define x(n)		#n,
 	BCH_FS_FLAGS()

base-commit: acc4d5ff0b61eb1715c498b6536c38c1feb7f3c1
-- 
2.49.0

