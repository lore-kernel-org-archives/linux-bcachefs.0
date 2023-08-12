Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4545C04E69
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 14:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjHLOuZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjHLOuY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 10:50:24 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C30E62
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3fe501e0b4cso26739335e9.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691851825; x=1692456625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySHjw62N1N8TOT+ycGmeiFE1Q5Mkqvf9ntkBgWt+pDA=;
        b=PA4tBLibBe8mojXsGYoRh+MpsFE9rLDvpU7nnfZrau6hZWA6lskEec6ylBxrRPB5cH
         ul38AfT24s0GQMrgGqOJdtZHLm2//sO6zSSB+gGRFDdtcRz2PbRjOg+9YDgj65BCzdu0
         yMNqOBMcoDR11PCeLatEr8krD/vnDAmcpMn3JnMuaEyRJiCv7DKR/0iVBccVI4M3RyJ0
         FiTr5TBbtmFCWk9ImKaSY9Gf3sRUgMjkMwU43oMj0cTxBekHyohR9CJQ8/7uYyPtDZ4W
         je0+YYrgDw2Q2YRNrWxyYFQj+MGUIQHQD1i+G3E/KkkQoSFhI4PF21EPXfOltV4kx6be
         537A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691851825; x=1692456625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySHjw62N1N8TOT+ycGmeiFE1Q5Mkqvf9ntkBgWt+pDA=;
        b=eK7sDHyhfulwUkf3fGpdu8tld7dyDbxDmi5AJpBb5lRFU/+Gohyrj+4jSI82a71194
         +I5HGmbdhnYbre5P88wsiXNB23lBrFfYXc8URhjcpibAig4LpGP9xOoOxyo68xBEbl0G
         qxl92xbq96qhpcZ1qFZYu/mTvyMmloGMrM7dyhvHeYh/FZi5CQa7byS0HgMr3RZhsdIH
         ac9oIOMNmVcZMCejuAkKpiURXBwf9GCJ1q6vbz758wZFzmcbUDmeoQLIpPCtOJH/EWkw
         VRHUK8e/R0RUu2Vd9lCyowlMhvMp7AFpymYuSxR8vnjA27Rr1rcArVBKq7MyQe2WC/ia
         9R6g==
X-Gm-Message-State: AOJu0YxNZNNCjSK1gaFx2d/9cuZn6N4sHy/bU60AKHaN+QAYhJyFCSDM
        Y5tgRZEk4U5x5lWoD7yHvtkjPFQ29xvCqqv3kYM=
X-Google-Smtp-Source: AGHT+IFpmBc7Zf7mjYydGZxbNpuhj3pqr/RSSrqW0Xpft614Ex7mjoPSQdqJvMYGa7DNuyGN00kBqw==
X-Received: by 2002:a7b:cc85:0:b0:3fe:108d:7f88 with SMTP id p5-20020a7bcc85000000b003fe108d7f88mr3640283wma.36.1691851824748;
        Sat, 12 Aug 2023 07:50:24 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id w17-20020adfee51000000b00317eee26bf0sm8771784wro.69.2023.08.12.07.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 07:50:24 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 4/4] bcachefs: Implement casefolding
Date:   Sat, 12 Aug 2023 15:47:48 +0100
Message-ID: <20230812145017.259609-4-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812145017.259609-1-joshua@froggi.es>
References: <20230812145017.259609-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This patch implements support for case-insensitive file name lookups
in bcachefs.

The implementation the same utf8 lowering and normalization that ext4
and f2fs is using currently.

It uses the regular CASEFOLD attributes and stores the casefolded name
contiguously with the regular name on disk and in memory if space
permits it.

Names that would be too long to fit contiguously are instead compared
using a folding strcmp.

The crux of the implementation, is that cached casefolded names are
twice the length of uncasefolded names.
In the case that they are not (which I don't believe is possible in
the current UTF-8 spec for any cased glyphs), it again, falls back to
a folding strcmp.

There is currently no option provided for selecting the casefolding
encoding; ext4 and f2fs only support a single encoding per-superblock
(utf8 12.1), but it would be trivial to extend this on bcachefs on a
per-inode level using the opts system so it not provided in this patch.

Signed-off-by: Joshua Ashton <joshua@froggi.es>

Cc: André Almeida <andrealmeid@igalia.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
---
 fs/bcachefs/bcachefs.h        |   8 ++
 fs/bcachefs/bcachefs_format.h |  18 +++-
 fs/bcachefs/dirent.c          | 167 ++++++++++++++++++++++++++++++----
 fs/bcachefs/fs-common.c       |   4 +
 fs/bcachefs/fs-ioctl.c        |  23 +++++
 fs/bcachefs/fs-ioctl.h        |  20 ++--
 fs/bcachefs/fsck.c            |   8 +-
 fs/bcachefs/str_hash.h        |  72 +++++++++++++--
 fs/bcachefs/super.c           |  10 ++
 fs/bcachefs/xattr.c           |   6 +-
 10 files changed, 297 insertions(+), 39 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 30b3d7b9f9dc..baf45b0e6cb9 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -202,6 +202,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/zstd.h>
+#include <linux/unicode.h>
 
 #include "bcachefs_format.h"
 #include "errcode.h"
@@ -657,6 +658,10 @@ enum bch_write_ref {
 	BCH_WRITE_REF_NR,
 };
 
+#if IS_ENABLED(CONFIG_UNICODE)
+#define BCH_FS_DEFAULT_UTF8_ENCODING UNICODE_AGE(12, 1, 0)
+#endif
+
 struct bch_fs {
 	struct closure		cl;
 
@@ -723,6 +728,9 @@ struct bch_fs {
 		u64		compat;
 	}			sb;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct unicode_map 	*s_encoding;
+#endif
 
 	struct bch_sb_handle	disk_sb;
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 5ec218ee3569..fb846aed8656 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -852,6 +852,8 @@ enum {
 	__BCH_INODE_UNLINKED		= 7,
 	__BCH_INODE_BACKPTR_UNTRUSTED	= 8,
 
+	__BCH_INODE_CASEFOLDED = 9,
+
 	/* bits 20+ reserved for packed fields below: */
 };
 
@@ -864,6 +866,7 @@ enum {
 #define BCH_INODE_I_SECTORS_DIRTY (1 << __BCH_INODE_I_SECTORS_DIRTY)
 #define BCH_INODE_UNLINKED	(1 << __BCH_INODE_UNLINKED)
 #define BCH_INODE_BACKPTR_UNTRUSTED (1 << __BCH_INODE_BACKPTR_UNTRUSTED)
+#define BCH_INODE_CASEFOLDED (1 << __BCH_INODE_CASEFOLDED)
 
 LE32_BITMASK(INODE_STR_HASH,	struct bch_inode, bi_flags, 20, 24);
 LE32_BITMASK(INODE_NR_FIELDS,	struct bch_inode, bi_flags, 24, 31);
@@ -908,7 +911,15 @@ struct bch_dirent {
 	 * Copy of mode bits 12-15 from the target inode - so userspace can get
 	 * the filetype without having to do a stat()
 	 */
-	__u8			d_type;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8			d_type:5,
+				d_unused:2,
+				d_casefold:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8			d_casefold:1,
+				d_unused:2,
+				d_type:5;
+#endif
 
 	__u8			d_name[];
 } __packed __aligned(8);
@@ -920,6 +931,8 @@ struct bch_dirent {
 			 sizeof(struct bkey) -				\
 			 offsetof(struct bch_dirent, d_name)))
 
+#define BCH_CF_NAME_MAX (BCH_NAME_MAX / 2)
+
 /* Xattrs */
 
 #define KEY_TYPE_XATTR_INDEX_USER			0
@@ -1843,7 +1856,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(new_varint,			15)	\
 	x(journal_no_flush,		16)	\
 	x(alloc_v2,			17)	\
-	x(extents_across_btree_nodes,	18)
+	x(extents_across_btree_nodes,	18)	\
+	x(casefolding,			19)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	((1ULL << BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 49b2f9b330e1..bd657f680137 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -12,6 +12,7 @@
 #include "subvolume.h"
 
 #include <linux/dcache.h>
+#include <linux/unicode.h>
 
 unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
@@ -31,9 +32,23 @@ unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
 {
-	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	unsigned len = bch2_dirent_name_bytes(d);
+	return (struct qstr) QSTR_INIT(d.v->d_name, d.v->d_casefold ? len / 2 : len);
 }
 
+#if IS_ENABLED(CONFIG_UNICODE)
+struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
+{
+	unsigned len;
+	if (!d.v->d_casefold)
+		return (struct qstr) QSTR_INIT(NULL, 0);
+
+	/* casefolded name is stored contiguously after the regular name */
+	len = bch2_dirent_name_bytes(d) / 2;
+	return (struct qstr) QSTR_INIT(d.v->d_name + len, len);
+}
+#endif
+
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
 			    const struct qstr *name)
 {
@@ -46,25 +61,65 @@ static u64 bch2_dirent_hash(const struct bch_hash_info *info,
 	return max_t(u64, bch2_str_hash_end(&ctx, info), 2);
 }
 
-static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
+static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key, struct bch_cf_lookup_cache *cf_cache)
 {
-	return bch2_dirent_hash(info, key);
+	const struct qstr *name = key;
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (cf_cache) {
+		int casefold_len = utf8_casefold(info->s_encoding, name,
+						 cf_cache->casefold_lookup_buf, BCH_CF_NAME_MAX + 1);
+		if (casefold_len < 0)
+			goto key_hash;
+
+		cf_cache->casefold_lookup = (struct qstr) QSTR_INIT(cf_cache->casefold_lookup_buf, casefold_len);
+		return bch2_dirent_hash(info, &cf_cache->casefold_lookup);
+	}
+key_hash:
+#endif
+	return bch2_dirent_hash(info, name);
 }
 
-static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
+static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k, struct bch_cf_lookup_cache *cf_cache)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr name = bch2_dirent_get_name(d);
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (cf_cache) {
+		struct qstr casefold_name = bch2_dirent_get_casefold_name(d);
+		if (casefold_name.len) {
+			cf_cache->casefold_lookup = casefold_name;
+		} else {
+			int casefold_len = utf8_casefold(info->s_encoding, &name,
+							 cf_cache->casefold_lookup_buf, BCH_CF_NAME_MAX + 1);
+			if (casefold_len < 0)
+				goto bkey_hash;
+
+			cf_cache->casefold_lookup = (struct qstr) QSTR_INIT(cf_cache->casefold_lookup_buf, casefold_len);
+		}
+		return bch2_dirent_hash(info, &cf_cache->casefold_lookup);
+	}
+bkey_hash:
+#endif
 	return bch2_dirent_hash(info, &name);
 }
 
-static bool dirent_cmp_key(struct bkey_s_c _l, const void *_r)
+static bool dirent_cmp_key(const struct bch_hash_info *info, struct bkey_s_c _l, const void *_r, struct bch_cf_lookup_cache *cf_cache)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
 	const struct qstr l_name = bch2_dirent_get_name(l);
 	const struct qstr *r_name = _r;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (cf_cache && cf_cache->casefold_lookup.len) {
+		struct qstr l_casefold_name = bch2_dirent_get_casefold_name(l);
+		if (l_casefold_name.len)
+			return l_casefold_name.len - cf_cache->casefold_lookup.len
+				?: memcmp(l_casefold_name.name, cf_cache->casefold_lookup.name, l_casefold_name.len);
+		else
+			return utf8_strncasecmp_folded(info->s_encoding, &cf_cache->casefold_lookup, &l_name);
+	}
+#endif
 	return l_name.len - r_name->len ?: memcmp(l_name.name, r_name->name, l_name.len);
 }
 
@@ -75,6 +130,8 @@ static bool dirent_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 	const struct qstr l_name = bch2_dirent_get_name(l);
 	const struct qstr r_name = bch2_dirent_get_name(r);
 
+	/* bkey to bkey comparisons do not need casefolding. */
+
 	return l_name.len - r_name.len ?: memcmp(l_name.name, r_name.name, l_name.len);
 }
 
@@ -97,24 +154,62 @@ const struct bch_hash_desc bch2_dirent_hash_desc = {
 	.is_visible	= dirent_is_visible,
 };
 
+#if IS_ENABLED(CONFIG_UNICODE)
+static bool bch2_cf_modify_name_block_len(int *name_len, bool casefold)
+{
+	if (casefold && *name_len && *name_len <= BCH_CF_NAME_MAX) {
+		/*
+		 * Use the remaining space to store the casefolded name,
+		 * which has the same length as the regular name.
+		 */
+		*name_len = *name_len * 2;
+		return true;
+	}
+
+	return false;
+}
+#endif
+
 int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 			enum bkey_invalid_flags flags,
 			struct printbuf *err)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr d_name = bch2_dirent_get_name(d);
+	int name_block_len = d_name.len;
+
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct qstr d_cf_name = bch2_dirent_get_casefold_name(d);
+	bool use_casefold_cache = bch2_cf_modify_name_block_len(&name_block_len,
+								d.v->d_casefold);
+#endif
 
 	if (!d_name.len) {
 		prt_printf(err, "empty name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len)) {
+	if (bkey_val_u64s(k.k) > dirent_val_u64s(name_block_len)) {
 		prt_printf(err, "value too big (%zu > %u)",
-		       bkey_val_u64s(k.k), dirent_val_u64s(d_name.len));
+		       bkey_val_u64s(k.k), dirent_val_u64s(name_block_len));
 		return -BCH_ERR_invalid_bkey;
 	}
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (use_casefold_cache) {
+		if (d_name.len > BCH_CF_NAME_MAX) {
+			prt_printf(err, "dirent w/ casefolding cache name too big (%u > %u)",
+			d_name.len, BCH_CF_NAME_MAX);
+			return -BCH_ERR_invalid_bkey;
+		}
+
+		if (d_cf_name.len > BCH_CF_NAME_MAX) {
+			prt_printf(err, "dirent w/ casefolding cache cf name too big (%u > %u)",
+			d_cf_name.len, BCH_CF_NAME_MAX);
+			return -BCH_ERR_invalid_bkey;
+		}
+	}
+#endif
 	if (d_name.len > BCH_NAME_MAX) {
 		prt_printf(err, "dirent name too big (%u > %u)",
 		       d_name.len, BCH_NAME_MAX);
@@ -161,13 +256,38 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 }
 
 static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
-				subvol_inum dir, u8 type,
+				subvol_inum dir,
+				const struct bch_hash_info *hash_info,
+				u8 type,
 				const struct qstr *name, u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name->len);
+	int name_block_len = name->len;
+	unsigned u64s;
+#if IS_ENABLED(CONFIG_UNICODE)
+	int casefold_len;
+	bool use_casefold_cache = bch2_cf_modify_name_block_len(&name_block_len,
+								hash_info->s_encoding != NULL);
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf) =
+		use_casefold_cache ? bch2_hash_create_cf(hash_info) : NULL;
+
+	if (use_casefold_cache) {
+		casefold_len = utf8_casefold(hash_info->s_encoding, name,
+					     cf_cache->casefold_lookup_buf, BCH_CF_NAME_MAX + 1);
+
+		if (casefold_len != name->len) {
+			/*
+			 * In the event the casefold len does not match the name's
+			 * length, fallback to using casefolding without a cache.
+			 */
+			use_casefold_cache = false;
+			name_block_len = name->len;
+		}
+	}
+#endif
+	u64s = BKEY_U64s + dirent_val_u64s(name_block_len);
 
-	if (name->len > BCH_NAME_MAX)
+	if (name_block_len > BCH_NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	BUG_ON(u64s > U8_MAX);
@@ -187,14 +307,29 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 	}
 
 	dirent->v.d_type = type;
+	dirent->v.d_unused = 0;
+	dirent->v.d_casefold = 0;
 
 	memcpy(dirent->v.d_name, name->name, name->len);
-	memset(dirent->v.d_name + name->len, 0,
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (use_casefold_cache) {
+		EBUG_ON(casefold_len != name->len);
+		dirent->v.d_casefold = 1;
+		memcpy(&dirent->v.d_name[name->len], cf_cache->casefold_lookup_buf, casefold_len);
+	}
+#endif
+	memset(dirent->v.d_name + name_block_len, 0,
 	       bkey_val_bytes(&dirent->k) -
 	       offsetof(struct bch_dirent, d_name) -
-	       name->len);
+	       name_block_len);
 
-	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
+	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name_block_len);
+	EBUG_ON(bch2_dirent_get_name(dirent_i_to_s_c(dirent)).len != name->len);
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (use_casefold_cache) {
+		EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != name->len);
+	}
+#endif
 
 	return dirent;
 }
@@ -207,7 +342,7 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
 	struct bkey_i_dirent *dirent;
 	int ret;
 
-	dirent = dirent_create_key(trans, dir, type, name, dst_inum);
+	dirent = dirent_create_key(trans, dir, hash_info, type, name, dst_inum);
 	ret = PTR_ERR_OR_ZERO(dirent);
 	if (ret)
 		return ret;
@@ -333,7 +468,7 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		*src_offset = dst_iter.pos.offset;
 
 	/* Create new dst key: */
-	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name, 0);
+	new_dst = dirent_create_key(trans, dst_dir, dst_hash, 0, dst_name, 0);
 	ret = PTR_ERR_OR_ZERO(new_dst);
 	if (ret)
 		goto out;
@@ -343,7 +478,7 @@ int bch2_dirent_rename(struct btree_trans *trans,
 
 	/* Create new src key: */
 	if (mode == BCH_RENAME_EXCHANGE) {
-		new_src = dirent_create_key(trans, src_dir, 0, src_name, 0);
+		new_src = dirent_create_key(trans, src_dir, src_hash, 0, src_name, 0);
 		ret = PTR_ERR_OR_ZERO(new_src);
 		if (ret)
 			goto out;
diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
index bb5305441f27..9649872797da 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/fs-common.c
@@ -46,6 +46,10 @@ int bch2_create_trans(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
+	/* Inherit casefold state from parent. */
+	if (dir_type == DT_DIR && (dir_u->bi_flags & BCH_INODE_CASEFOLDED))
+		new_inode->bi_flags |= BCH_INODE_CASEFOLDED;
+
 	if (!(flags & BCH_CREATE_SNAPSHOT)) {
 		/* Normal create path - allocate a new inode: */
 		bch2_inode_init_late(new_inode, now, uid, gid, mode, rdev, dir_u);
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 141bcced031e..9ead754a24b9 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -6,6 +6,7 @@
 #include "dirent.h"
 #include "fs.h"
 #include "fs-common.h"
+#include "str_hash.h"
 #include "fs-ioctl.h"
 #include "quota.h"
 
@@ -54,6 +55,28 @@ static int bch2_inode_flags_set(struct btree_trans *trans,
 	    (newflags & (BCH_INODE_NODUMP|BCH_INODE_NOATIME)) != newflags)
 		return -EINVAL;
 
+	if ((newflags ^ oldflags) & BCH_INODE_CASEFOLDED) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		int ret = 0;
+		/* Not supported on individual files. */
+		if (!S_ISDIR(bi->bi_mode))
+			return -EOPNOTSUPP;
+
+		/*
+		 * Make sure the dir is empty, as otherwise we'd need to
+		 * rehash everything and update the dirent keys.
+		 */
+		ret = bch2_empty_dir_trans(trans, inode_inum(inode));
+		if (ret < 0)
+			return ret;
+
+		bch2_check_set_feature(c, BCH_FEATURE_casefolding);
+#else
+		printk(KERN_ERR "Cannot use casefolding on a kernel without CONFIG_UNICODE\n");
+		return -EINVAL;
+#endif
+	}
+
 	if (s->set_projinherit) {
 		bi->bi_fields_set &= ~(1 << Inode_opt_project);
 		bi->bi_fields_set |= ((int) s->projinherit << Inode_opt_project);
diff --git a/fs/bcachefs/fs-ioctl.h b/fs/bcachefs/fs-ioctl.h
index f201980ef2c3..2950091b5ac6 100644
--- a/fs/bcachefs/fs-ioctl.h
+++ b/fs/bcachefs/fs-ioctl.h
@@ -6,19 +6,21 @@
 
 /* bcachefs inode flags -> vfs inode flags: */
 static const unsigned bch_flags_to_vfs[] = {
-	[__BCH_INODE_SYNC]	= S_SYNC,
-	[__BCH_INODE_IMMUTABLE]	= S_IMMUTABLE,
-	[__BCH_INODE_APPEND]	= S_APPEND,
-	[__BCH_INODE_NOATIME]	= S_NOATIME,
+	[__BCH_INODE_SYNC]		= S_SYNC,
+	[__BCH_INODE_IMMUTABLE]		= S_IMMUTABLE,
+	[__BCH_INODE_APPEND]		= S_APPEND,
+	[__BCH_INODE_NOATIME]		= S_NOATIME,
+	[__BCH_INODE_CASEFOLDED]	= S_CASEFOLD,
 };
 
 /* bcachefs inode flags -> FS_IOC_GETFLAGS: */
 static const unsigned bch_flags_to_uflags[] = {
-	[__BCH_INODE_SYNC]	= FS_SYNC_FL,
-	[__BCH_INODE_IMMUTABLE]	= FS_IMMUTABLE_FL,
-	[__BCH_INODE_APPEND]	= FS_APPEND_FL,
-	[__BCH_INODE_NODUMP]	= FS_NODUMP_FL,
-	[__BCH_INODE_NOATIME]	= FS_NOATIME_FL,
+	[__BCH_INODE_SYNC]		= FS_SYNC_FL,
+	[__BCH_INODE_IMMUTABLE]		= FS_IMMUTABLE_FL,
+	[__BCH_INODE_APPEND]		= FS_APPEND_FL,
+	[__BCH_INODE_NODUMP]		= FS_NODUMP_FL,
+	[__BCH_INODE_NOATIME]		= FS_NOATIME_FL,
+	[__BCH_INODE_CASEFOLDED]	= FS_CASEFOLD_FL,
 };
 
 /* bcachefs inode flags -> FS_IOC_FSGETXATTR: */
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index d99c04af2c55..d060465ecca0 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -750,6 +750,7 @@ static int hash_check_key(struct btree_trans *trans,
 			  struct bch_hash_info *hash_info,
 			  struct btree_iter *k_iter, struct bkey_s_c hash_k)
 {
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf);
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter = { NULL };
 	struct printbuf buf = PRINTBUF;
@@ -760,7 +761,12 @@ static int hash_check_key(struct btree_trans *trans,
 	if (hash_k.k->type != desc.key_type)
 		return 0;
 
-	hash = desc.hash_bkey(hash_info, hash_k);
+	cf_cache = bch2_hash_create_cf(hash_info);
+	ret = PTR_ERR_OR_ZERO(cf_cache);
+	if (ret < 0)
+		return ret;
+
+	hash = desc.hash_bkey(hash_info, hash_k, cf_cache);
 
 	if (likely(hash == hash_k.k->p.offset))
 		return 0;
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index ae21a8cca1b4..61010405baa5 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -12,6 +12,7 @@
 #include "super.h"
 
 #include <linux/crc32c.h>
+#include <linux/cleanup.h>
 #include <crypto/hash.h>
 #include <crypto/sha2.h>
 
@@ -34,6 +35,9 @@ bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
 
 struct bch_hash_info {
 	u8			type;
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct unicode_map 	*s_encoding;
+#endif
 	/*
 	 * For crc32 or crc64 string hashes the first key value of
 	 * the siphash_key (k0) is used as the key.
@@ -48,6 +52,9 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	struct bch_hash_info info = {
 		.type = (bi->bi_flags >> INODE_STR_HASH_OFFSET) &
 			~(~0U << INODE_STR_HASH_BITS),
+#if IS_ENABLED(CONFIG_UNICODE)
+		.s_encoding = !!(bi->bi_flags & BCH_INODE_CASEFOLDED) ? c->s_encoding : NULL,
+#endif
 		.siphash_key = { .k0 = bi->bi_hash_seed }
 	};
 
@@ -65,6 +72,31 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	return info;
 }
 
+/* Fed back from hashing operations. */
+struct bch_cf_lookup_cache {
+	struct qstr		casefold_lookup;
+	unsigned char		casefold_lookup_buf[BCH_NAME_MAX + 1];
+};
+
+static __always_inline struct bch_cf_lookup_cache *
+bch2_hash_create_cf(const struct bch_hash_info *info)
+{
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (info->s_encoding) {
+		struct bch_cf_lookup_cache *cf_cache =
+			kmalloc(sizeof(struct bch_cf_lookup_cache), GFP_KERNEL);
+		if (!cf_cache)
+			return ERR_PTR(-ENOMEM);
+
+		cf_cache->casefold_lookup = (struct qstr) QSTR_INIT(NULL, 0);
+		return cf_cache;
+	}
+#endif
+	return NULL;
+}
+
+DEFINE_FREE(bch2_hash_free_cf, struct bch_cf_lookup_cache *, if (_T) kfree(_T))
+
 struct bch_str_hash_ctx {
 	union {
 		u32		crc32c;
@@ -134,9 +166,9 @@ struct bch_hash_desc {
 	enum btree_id	btree_id;
 	u8		key_type;
 
-	u64		(*hash_key)(const struct bch_hash_info *, const void *);
-	u64		(*hash_bkey)(const struct bch_hash_info *, struct bkey_s_c);
-	bool		(*cmp_key)(struct bkey_s_c, const void *);
+	u64		(*hash_key)(const struct bch_hash_info *, const void *, struct bch_cf_lookup_cache *cf_cache);
+	u64		(*hash_bkey)(const struct bch_hash_info *, struct bkey_s_c, struct bch_cf_lookup_cache *cf_cache);
+	bool		(*cmp_key)(const struct bch_hash_info *, struct bkey_s_c, const void *, struct bch_cf_lookup_cache *cf_cache);
 	bool		(*cmp_bkey)(struct bkey_s_c, struct bkey_s_c);
 	bool		(*is_visible)(subvol_inum inum, struct bkey_s_c);
 };
@@ -157,6 +189,7 @@ bch2_hash_lookup(struct btree_trans *trans,
 		 subvol_inum inum, const void *key,
 		 unsigned flags)
 {
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf);
 	struct bkey_s_c k;
 	u32 snapshot;
 	int ret;
@@ -165,12 +198,17 @@ bch2_hash_lookup(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
+	cf_cache = bch2_hash_create_cf(info);
+	ret = PTR_ERR_OR_ZERO(cf_cache);
+	if (ret < 0)
+		return ret;
+
 	for_each_btree_key_upto_norestart(trans, *iter, desc.btree_id,
-			   SPOS(inum.inum, desc.hash_key(info, key), snapshot),
+			   SPOS(inum.inum, desc.hash_key(info, key, cf_cache), snapshot),
 			   POS(inum.inum, U64_MAX),
 			   BTREE_ITER_SLOTS|flags, k, ret) {
 		if (is_visible_key(desc, inum, k)) {
-			if (!desc.cmp_key(k, key))
+			if (!desc.cmp_key(info, k, key, cf_cache))
 				return 0;
 		} else if (k.k->type == KEY_TYPE_hash_whiteout) {
 			;
@@ -191,6 +229,7 @@ bch2_hash_hole(struct btree_trans *trans,
 	       const struct bch_hash_info *info,
 	       subvol_inum inum, const void *key)
 {
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf);
 	struct bkey_s_c k;
 	u32 snapshot;
 	int ret;
@@ -199,8 +238,13 @@ bch2_hash_hole(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
+	cf_cache = bch2_hash_create_cf(info);
+	ret = PTR_ERR_OR_ZERO(cf_cache);
+	if (ret < 0)
+		return ret;
+
 	for_each_btree_key_upto_norestart(trans, *iter, desc.btree_id,
-			   SPOS(inum.inum, desc.hash_key(info, key), snapshot),
+			   SPOS(inum.inum, desc.hash_key(info, key, cf_cache), snapshot),
 			   POS(inum.inum, U64_MAX),
 			   BTREE_ITER_SLOTS|BTREE_ITER_INTENT, k, ret)
 		if (!is_visible_key(desc, inum, k))
@@ -216,6 +260,7 @@ int bch2_hash_needs_whiteout(struct btree_trans *trans,
 			     const struct bch_hash_info *info,
 			     struct btree_iter *start)
 {
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf);
 	struct btree_iter iter;
 	struct bkey_s_c k;
 	int ret;
@@ -224,13 +269,18 @@ int bch2_hash_needs_whiteout(struct btree_trans *trans,
 
 	bch2_btree_iter_advance(&iter);
 
+	cf_cache = bch2_hash_create_cf(info);
+	ret = PTR_ERR_OR_ZERO(cf_cache);
+	if (ret < 0)
+		return ret;
+
 	for_each_btree_key_continue_norestart(iter, BTREE_ITER_SLOTS, k, ret) {
 		if (k.k->type != desc.key_type &&
 		    k.k->type != KEY_TYPE_hash_whiteout)
 			break;
 
 		if (k.k->type == desc.key_type &&
-		    desc.hash_bkey(info, k) <= start->pos.offset) {
+		    desc.hash_bkey(info, k, cf_cache) <= start->pos.offset) {
 			ret = 1;
 			break;
 		}
@@ -250,13 +300,19 @@ int bch2_hash_set_snapshot(struct btree_trans *trans,
 			   int update_flags)
 {
 	struct btree_iter iter, slot = { NULL };
+	struct bch_cf_lookup_cache *cf_cache __free(bch2_hash_free_cf);
 	struct bkey_s_c k;
 	bool found = false;
 	int ret;
 
+	cf_cache = bch2_hash_create_cf(info);
+	ret = PTR_ERR_OR_ZERO(cf_cache);
+	if (ret < 0)
+		return ret;
+
 	for_each_btree_key_upto_norestart(trans, iter, desc.btree_id,
 			   SPOS(insert->k.p.inode,
-				desc.hash_bkey(info, bkey_i_to_s_c(insert)),
+				desc.hash_bkey(info, bkey_i_to_s_c(insert), cf_cache),
 				snapshot),
 			   POS(insert->k.p.inode, U64_MAX),
 			   BTREE_ITER_SLOTS|BTREE_ITER_INTENT, k, ret) {
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 5c62fcf3afdb..204a337728ad 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -757,6 +757,16 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	if (ret)
 		goto err;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	/* Default encoding until we can potentially have more as an option. */
+	c->s_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
+#else
+	if (c->sb.features & (1ULL << BCH_FEATURE_casefolding)) {
+		printk(KERN_ERR "Cannot mount a filesystem with casefolding on a kernel without CONFIG_UNICODE\n");
+		return ERR_PTR(-EINVAL);
+	}
+#endif
+
 	pr_uuid(&name, c->sb.user_uuid.b);
 	strscpy(c->name, name.buf, sizeof(c->name));
 	printbuf_exit(&name);
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 6f6b3caf0607..1010002f6282 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -27,12 +27,12 @@ static u64 bch2_xattr_hash(const struct bch_hash_info *info,
 	return bch2_str_hash_end(&ctx, info);
 }
 
-static u64 xattr_hash_key(const struct bch_hash_info *info, const void *key)
+static u64 xattr_hash_key(const struct bch_hash_info *info, const void *key, struct bch_cf_lookup_cache *cf_cache)
 {
 	return bch2_xattr_hash(info, key);
 }
 
-static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
+static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k, struct bch_cf_lookup_cache *cf_cache)
 {
 	struct bkey_s_c_xattr x = bkey_s_c_to_xattr(k);
 
@@ -40,7 +40,7 @@ static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 		 &X_SEARCH(x.v->x_type, x.v->x_name, x.v->x_name_len));
 }
 
-static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
+static bool xattr_cmp_key(const struct bch_hash_info *info, struct bkey_s_c _l, const void *_r, struct bch_cf_lookup_cache *cf_cache)
 {
 	struct bkey_s_c_xattr l = bkey_s_c_to_xattr(_l);
 	const struct xattr_search_key *r = _r;
-- 
2.41.0

