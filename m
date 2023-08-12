Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9E3C04E69
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjHLV0w (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjHLV0w (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:26:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70C10F8
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fe4a89e8c4so28049535e9.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691875612; x=1692480412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2nf/A0pBH1AzUsb4SZL/HH14VZ3xjlEuSr3p0cWGDU=;
        b=X9Wkyb13p6+8WqPZP2L0idZo5W32+XT1Fa02OHr2JWLauGOhrJfSOFLxw/beaDlDyk
         +4+72Xoz9AYC9Kn5ClGx0T7nEkVuElOuxKDxkmA9mynAlwPf7yLuuJY9irq+O2pZ8urc
         vhxb2+kbtk/VD5XlLj9LKjXOoY6+CIoXo+vk7rBaA9G2nDAqsytkl1P90V5/H/C/v4Wp
         dbm5z1lWix3CrxgEq9wB/YsOSyOdXhKkXEnYOwgnSNbKtVtiYvKX29er4N55XkAzfTlX
         3PdDtUfzyLS+7JSf6TdLFE7VMBe2+NsvTZzjz6IOMf0iWpM5yeUu8M7X2oKyaZnthv1z
         qykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691875612; x=1692480412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2nf/A0pBH1AzUsb4SZL/HH14VZ3xjlEuSr3p0cWGDU=;
        b=DgYdUK7I0gu4NDyrNxuBcQJ6Kj/Y01+M3qbBoAX3RwIaFGgsbK803nG4e+IlDkME1j
         E+yaCXP6Dk8w6AWzyrhzGDTThD3DgVIxmFN5wy/IYWGw4JwTH3oxRX157riN2/EjIXuD
         RCQ4v9Z9OyyaxSUZJsjeUzHl1TllZePurO3J04j5d8SvJlIfT/vEYouWJ8FJG2E/wjbm
         2LFs2RoyD+kXDbtb/6nNB5Tzv/zXWtnA78wIWLKP+7s1GKTR1cC1kwrPv+jOTqEzmQ4Z
         ckl0MSbTIxNayefw3hZsTw3huWDFImc7TOwjmVfnvs6iYWZQFbJ1ut4NyPtTxYTf/4H1
         1Nqg==
X-Gm-Message-State: AOJu0YwNJd4QpIT24CRBZjosDxUjZ+wRaVaKmT63rAeHqiv5pobZcyqm
        Sakgke6NRMJ/9qawYolrwlB/ct7g61lQkyfhSKc=
X-Google-Smtp-Source: AGHT+IGGNLG28kaZf9WCc7RJ1+7q+9Bw0Uhxf0kjmGYs6IEW+KP2WQB3cBK0aEvjIAfnpQNrUSu9uQ==
X-Received: by 2002:adf:fb4c:0:b0:317:5a3c:ed28 with SMTP id c12-20020adffb4c000000b003175a3ced28mr3722461wrs.6.1691875611584;
        Sat, 12 Aug 2023 14:26:51 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id p1-20020adfcc81000000b003179b3fd837sm9536481wrj.33.2023.08.12.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 14:26:51 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [v2 3/3] bcachefs: Implement casefolding
Date:   Sat, 12 Aug 2023 22:26:31 +0100
Message-ID: <20230812212647.490829-4-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812212647.490829-1-joshua@froggi.es>
References: <20230812212647.490829-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This patch implements support for case-insensitive file name lookups
in bcachefs.

The implementation uses the same UTF-8 lowering and normalization that
ext4 and f2fs is using currently.

It uses the regular CASEFOLD attributes and stores the casefolded name
contiguously with the regular name on disk and in memory if space
permits it.

Names that would be too long to fit contiguously are instead compared
using a folding strcmp.

There is currently no option provided for selecting the casefolding
encoding; ext4 and f2fs only support a single encoding per-superblock
(utf8 12.1), but it would be trivial to extend this on bcachefs on a
per-inode level using the opts system so it not provided in this patch.

More information is provided in Documentation/bcachefs/casefolding.rst

Signed-off-by: Joshua Ashton <joshua@froggi.es>

Cc: André Almeida <andrealmeid@igalia.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
---
 .../filesystems/bcachefs/casefolding.rst      |  61 +++++
 fs/bcachefs/bcachefs.h                        |   8 +
 fs/bcachefs/bcachefs_format.h                 |  29 ++-
 fs/bcachefs/dirent.c                          | 220 ++++++++++++++++--
 fs/bcachefs/dirent.h                          |   6 +-
 fs/bcachefs/fs-common.c                       |   4 +
 fs/bcachefs/fs-ioctl.c                        |  23 ++
 fs/bcachefs/fs-ioctl.h                        |  20 +-
 fs/bcachefs/fsck.c                            |   8 +-
 fs/bcachefs/str_hash.h                        |  84 ++++++-
 fs/bcachefs/super.c                           |  10 +
 fs/bcachefs/xattr.c                           |   6 +-
 12 files changed, 429 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
new file mode 100644
index 000000000000..112532a90a1b
--- /dev/null
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -0,0 +1,61 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Casefolding
+===========
+
+bcachefs has support for case-insensitive file and directory
+lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
+casefolding attributes.
+
+The main usecase for casefolding is compatibility with software written
+against other filesystems that rely on casefolded lookups
+(eg. NTFS and Wine/Proton).
+Taking advantage of file-system level casefolding can lead to great
+loading time gains in many applications and games.
+
+On the lookup/query side: casefolding is implemented by allocating a new
+string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
+casefold the query string.
+An allocation is required here as `BCH_NAME_MAX` is quite large ~1.9kb
+and would not be safe to put on the stack.
+
+On the dirent side: casefolding is implemented by ensuring the `bkey`'s
+hash is made from the casefolded string.
+If the dirent's regular name and the casefolded name (and lengths) will
+fit in the dirent key, then the casefolded string will be cached there.
+The structures looks like this:
+
+Regular:    [dirent data][regular name][nul][nul]...
+Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
+
+(Do note, the number of `NUL`s here is merely for illustration, they count can vary
+ per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
+
+If the names are too big to fit in the data of the `bkey`, it will fallback to not
+caching the name, and instead a casefolding strcmp (`utf8_strncasecmp_folded`)
+will be used at key comparison (`key_cmp`) time.
+
+This is efficient as it means that for 99.9% of typical file lookups
+that require casefolding, it has identical performance to a regular lookup:
+a hash comparison and a `memcmp` of the name.
+
+Rationale
+---------
+
+Several designs were considered for this system:
+One was to introduce a dirent_v2, however that would be painful especially as
+the hash system only has support for a single key type. This would also need
+`BCH_NAME_MAX` to change between versions, and a new feature bit.
+
+Another option was to store without the two lengths, and just take the length of
+the regular name and casefolded name contiguously / 2 as the length. This would
+assume that the regular length == casefolded length, but that could potentially
+not be true, if the uppercase unicode glyph had a different UTF-8 encoding than
+the lowercase unicode glyph.
+It would be possible to disregard the casefold cache for those cases, but it was
+decided to simply encode the two string lengths in the key to avoid random
+performance issues if this edgecase was ever hit.
+
+The option settled on was to use a free-bit in d_type to mark a dirent as having
+a casefold cache, and then treat the first 4 bytes the name block as lengths.
+You can see this in the `d_cf_name_block` member of union in `bch_dirent`.
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 30b3d7b9f9dc..47a633e40ee7 100644
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
+	struct unicode_map 	*cf_encoding;
+#endif
 
 	struct bch_sb_handle	disk_sb;
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 5ec218ee3569..159d5497c02a 100644
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
@@ -908,9 +911,24 @@ struct bch_dirent {
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
 
-	__u8			d_name[];
+	union {
+	struct {
+		__le16		d_name_len;
+		__le16		d_cf_name_len;
+		__u8		d_names[0];
+	} d_cf_name_block;
+	__u8			d_name[0];
+	};
 } __packed __aligned(8);
 
 #define DT_SUBVOL	16
@@ -920,6 +938,10 @@ struct bch_dirent {
 			 sizeof(struct bkey) -				\
 			 offsetof(struct bch_dirent, d_name)))
 
+#define BCH_CF_NAME_BLOCK_MAX	((unsigned) (U8_MAX * sizeof(__u64) -		\
+				sizeof(struct bkey) -				\
+				offsetof(struct bch_dirent, d_cf_name_block.d_names)))
+
 /* Xattrs */
 
 #define KEY_TYPE_XATTR_INDEX_USER			0
@@ -1843,7 +1865,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(new_varint,			15)	\
 	x(journal_no_flush,		16)	\
 	x(alloc_v2,			17)	\
-	x(extents_across_btree_nodes,	18)
+	x(extents_across_btree_nodes,	18)	\
+	x(casefolding,			19)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	((1ULL << BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 6f9eb88c7dba..01836881d53c 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -12,6 +12,7 @@
 #include "subvolume.h"
 
 #include <linux/dcache.h>
+#include <linux/unicode.h>
 
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
@@ -25,13 +26,34 @@ static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 #endif
 
 	return bkey_bytes -
-		offsetof(struct bch_dirent, d_name) -
+		(d.v->d_casefold
+		? offsetof(struct bch_dirent, d_cf_name_block.d_names)
+		: offsetof(struct bch_dirent, d_name)) -
 		trailing_nuls;
 }
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
 {
-	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	unsigned block_len = bch2_dirent_name_bytes(d);
+	if (d.v->d_casefold) {
+		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);
+		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[0], name_len);
+	} else {
+		unsigned name_len = block_len;
+		return (struct qstr) QSTR_INIT(d.v->d_name, name_len);
+	}
+}
+
+struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
+{
+	unsigned block_len = bch2_dirent_name_bytes(d);
+	if (d.v->d_casefold) {
+		unsigned name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_name_len), block_len);
+		unsigned cf_name_len = min_t(unsigned, le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len), block_len - name_len);
+		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[name_len], cf_name_len);
+	} else {
+		return (struct qstr) QSTR_INIT(NULL, 0);
+	}
 }
 
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
@@ -46,25 +68,65 @@ static u64 bch2_dirent_hash(const struct bch_hash_info *info,
 	return max_t(u64, bch2_str_hash_end(&ctx, info), 2);
 }
 
-static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
+static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key, struct bch_cf_cache *cf_cache)
 {
-	return bch2_dirent_hash(info, key);
+	const struct qstr *name = key;
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (cf_cache) {
+		int casefold_len = utf8_casefold(info->cf_encoding, name,
+						 cf_cache->casefold_lookup_buf, BCH_NAME_MAX + 1);
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
+static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k, struct bch_cf_cache *cf_cache)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr name = bch2_dirent_get_name(d);
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (cf_cache) {
+		struct qstr casefold_name = bch2_dirent_get_casefold_name(d);
+		if (casefold_name.len) {
+			cf_cache->casefold_lookup = casefold_name;
+		} else {
+			int casefold_len = utf8_casefold(info->cf_encoding, &name,
+							 cf_cache->casefold_lookup_buf, BCH_NAME_MAX + 1);
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
+static bool dirent_cmp_key(const struct bch_hash_info *info, struct bkey_s_c _l, const void *_r, struct bch_cf_cache *cf_cache)
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
+			return utf8_strncasecmp_folded(info->cf_encoding, &cf_cache->casefold_lookup, &l_name);
+	}
+#endif
 	return l_name.len - r_name->len ?: memcmp(l_name.name, r_name->name, l_name.len);
 }
 
@@ -75,6 +137,8 @@ static bool dirent_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 	const struct qstr l_name = bch2_dirent_get_name(l);
 	const struct qstr r_name = bch2_dirent_get_name(r);
 
+	/* bkey to bkey comparisons do not need casefolding. */
+
 	return l_name.len - r_name.len ?: memcmp(l_name.name, r_name.name, l_name.len);
 }
 
@@ -103,16 +167,43 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr d_name = bch2_dirent_get_name(d);
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct qstr d_cf_name = bch2_dirent_get_casefold_name(d);
+#endif
 
 	if (!d_name.len) {
 		prt_printf(err, "empty name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len)) {
-		prt_printf(err, "value too big (%zu > %u)",
-		       bkey_val_u64s(k.k), dirent_val_u64s(d_name.len));
+	if (d.v->d_casefold) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len, d_cf_name.len)) {
+			prt_printf(err, "value too big (%zu > %u)",
+			bkey_val_u64s(k.k), dirent_val_u64s(d_name.len, d_cf_name.len));
+			return -BCH_ERR_invalid_bkey;
+		}
+
+		if (d_name.len + d_cf_name.len > BCH_CF_NAME_BLOCK_MAX) {
+			prt_printf(err, "dirent w/ casefolding cache name too big (%u > %u)",
+			d_name.len + d_cf_name.len, BCH_CF_NAME_BLOCK_MAX);
+			return -BCH_ERR_invalid_bkey;
+		}
+
+		if (d_cf_name.len != strnlen(d_cf_name.name, d_cf_name.len)) {
+			prt_printf(err, "dirent has stray data after cf name's NUL");
+			return -BCH_ERR_invalid_bkey;
+		}
+#else
+		prt_printf(err, "dirent bkey with casefolding without CONFIG_UNICODE");
 		return -BCH_ERR_invalid_bkey;
+#endif
+	} else {
+		if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len, 0)) {
+			prt_printf(err, "value too big (%zu > %u)",
+			bkey_val_u64s(k.k), dirent_val_u64s(d_name.len, 0));
+			return -BCH_ERR_invalid_bkey;
+		}
 	}
 
 	if (d_name.len > BCH_NAME_MAX) {
@@ -165,15 +256,14 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 	       bch2_d_type_str(d.v->d_type));
 }
 
-static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
-				subvol_inum dir, u8 type,
-				const struct qstr *name, u64 dst)
+static struct bkey_i_dirent *__dirent_alloc_key(struct btree_trans *trans,
+				subvol_inum dir,
+				const struct bch_hash_info *hash_info,
+				u8 type,
+				const struct qstr *name, const struct qstr *cf_name, u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name->len);
-
-	if (name->len > BCH_NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
+	unsigned u64s = BKEY_U64s + dirent_val_u64s(name->len, cf_name ? cf_name->len : 0);
 
 	BUG_ON(u64s > U8_MAX);
 
@@ -192,14 +282,94 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 	}
 
 	dirent->v.d_type = type;
+	dirent->v.d_unused = 0;
+	dirent->v.d_casefold = cf_name && cf_name->len > 0 ? 1 : 0;
+
+	return dirent;
+}
+
+static struct bkey_i_dirent *__dirent_create_key(struct btree_trans *trans,
+				subvol_inum dir,
+				const struct bch_hash_info *hash_info,
+				u8 type,
+				const struct qstr *name, u64 dst)
+{
+	struct bkey_i_dirent *dirent = __dirent_alloc_key(trans, dir, hash_info, type, name, NULL, dst);
+
+	memcpy(&dirent->v.d_name[0], name->name, name->len);
+	memset(&dirent->v.d_name[name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_name) -
+		name->len);
+	return dirent;
+}
+
+static struct bkey_i_dirent *__dirent_create_cf_key(struct btree_trans *trans,
+				subvol_inum dir,
+				const struct bch_hash_info *hash_info,
+				u8 type,
+				const struct qstr *name, const struct qstr *cf_name, u64 dst)
+{
+	struct bkey_i_dirent *dirent = __dirent_alloc_key(trans, dir, hash_info, type, name, cf_name, dst);
+
+	dirent->v.d_cf_name_block.d_name_len = cpu_to_le16(name->len);
+	dirent->v.d_cf_name_block.d_cf_name_len = cpu_to_le16(cf_name->len);
+
+	memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
+	memcpy(&dirent->v.d_cf_name_block.d_names[name->len], cf_name->name, cf_name->len);
+	memset(&dirent->v.d_cf_name_block.d_names[name->len + cf_name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_cf_name_block.d_names) -
+		name->len + cf_name->len);
+
+	EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != cf_name->len);
+
+	return dirent;
+}
+
+static struct bch_cf_cache *dirent_prepare_key_casefold(const struct bch_hash_info *hash_info,
+							const struct qstr *name)
+{
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (hash_info->cf_encoding != NULL) {
+		int casefold_len;
+		cf_cache = bch2_hash_create_cf(hash_info);
+		casefold_len = utf8_casefold(hash_info->cf_encoding, name,
+					     cf_cache->casefold_lookup_buf, BCH_NAME_MAX + 1);
+
+		/*
+		 * Don't use the casefold cache if the names are too long
+		 * to fit in the name block, or the name was uncasefoldable.
+		 */
+		if (casefold_len > 0 && name->len + casefold_len <= BCH_CF_NAME_BLOCK_MAX) {
+			cf_cache->casefold_lookup = (struct qstr) QSTR_INIT(cf_cache->casefold_lookup_buf, casefold_len);
+			return_ptr(cf_cache);
+		}
+	}
+#endif
+	return NULL;
+}
+
+static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
+				subvol_inum dir,
+				const struct bch_hash_info *hash_info,
+				u8 type,
+				const struct qstr *name, u64 dst)
+{
+	struct bkey_i_dirent *dirent = NULL;
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
+
+	if (name->len > BCH_NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	cf_cache = dirent_prepare_key_casefold(hash_info, name);
 
-	memcpy(dirent->v.d_name, name->name, name->len);
-	memset(dirent->v.d_name + name->len, 0,
-	       bkey_val_bytes(&dirent->k) -
-	       offsetof(struct bch_dirent, d_name) -
-	       name->len);
+	dirent = cf_cache
+		? __dirent_create_cf_key(trans, dir, hash_info, type, name, &cf_cache->casefold_lookup, dst)
+		: __dirent_create_key(trans, dir, hash_info, type, name, dst);
 
-	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
+	EBUG_ON(bch2_dirent_get_name(dirent_i_to_s_c(dirent)).len != name->len);
 
 	return dirent;
 }
@@ -212,7 +382,7 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
 	struct bkey_i_dirent *dirent;
 	int ret;
 
-	dirent = dirent_create_key(trans, dir, type, name, dst_inum);
+	dirent = dirent_create_key(trans, dir, hash_info, type, name, dst_inum);
 	ret = PTR_ERR_OR_ZERO(dirent);
 	if (ret)
 		return ret;
@@ -338,7 +508,7 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		*src_offset = dst_iter.pos.offset;
 
 	/* Create new dst key: */
-	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name, 0);
+	new_dst = dirent_create_key(trans, dst_dir, dst_hash, 0, dst_name, 0);
 	ret = PTR_ERR_OR_ZERO(new_dst);
 	if (ret)
 		goto out;
@@ -348,7 +518,7 @@ int bch2_dirent_rename(struct btree_trans *trans,
 
 	/* Create new src key: */
 	if (mode == BCH_RENAME_EXCHANGE) {
-		new_src = dirent_create_key(trans, src_dir, 0, src_name, 0);
+		new_src = dirent_create_key(trans, src_dir, src_hash, 0, src_name, 0);
 		ret = PTR_ERR_OR_ZERO(new_src);
 		if (ret)
 			goto out;
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index e9fa1df38232..1f7c32c50668 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -26,8 +26,12 @@ struct bch_inode_info;
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d);
 
-static inline unsigned dirent_val_u64s(unsigned len)
+static inline unsigned dirent_val_u64s(unsigned len, unsigned cf_len)
 {
+	if (cf_len > 0) {
+		return DIV_ROUND_UP(offsetof(struct bch_dirent, d_cf_name_block.d_names) + len + cf_len,
+				    sizeof(u64));
+	}
 	return DIV_ROUND_UP(offsetof(struct bch_dirent, d_name) + len,
 			    sizeof(u64));
 }
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
index d99c04af2c55..ab13e24b0f24 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -750,6 +750,7 @@ static int hash_check_key(struct btree_trans *trans,
 			  struct bch_hash_info *hash_info,
 			  struct btree_iter *k_iter, struct bkey_s_c hash_k)
 {
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
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
index ae21a8cca1b4..51e7f95dd591 100644
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
+	struct unicode_map 	*cf_encoding;
+#endif
 	/*
 	 * For crc32 or crc64 string hashes the first key value of
 	 * the siphash_key (k0) is used as the key.
@@ -48,6 +52,9 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	struct bch_hash_info info = {
 		.type = (bi->bi_flags >> INODE_STR_HASH_OFFSET) &
 			~(~0U << INODE_STR_HASH_BITS),
+#if IS_ENABLED(CONFIG_UNICODE)
+		.cf_encoding = !!(bi->bi_flags & BCH_INODE_CASEFOLDED) ? c->cf_encoding : NULL,
+#endif
 		.siphash_key = { .k0 = bi->bi_hash_seed }
 	};
 
@@ -65,6 +72,43 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	return info;
 }
 
+/*
+ * The bch_cf_cache structure contains a string pointer and space
+ * for a casefold cache.
+ *
+ * The buffer is used when looking up/querying in a casefolded directory
+ * to hold the casefolded version of the lookup name so it can be hashed
+ * or cmp'ed.
+ *
+ * casefold_lookup is either:
+ *  - (NULL, 0) when empty or non-existant;
+ *  - (casefold_lookup_buf, len) for regular lookups or dirent creation;
+ *  - (dirent_casefold_name, len) when hashing/cmp'ing bkeys.
+ *  */
+struct bch_cf_cache {
+	struct qstr		casefold_lookup;
+	unsigned char		casefold_lookup_buf[BCH_NAME_MAX + 1];
+};
+
+static __always_inline struct bch_cf_cache *
+bch2_hash_create_cf(const struct bch_hash_info *info)
+{
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (info->cf_encoding) {
+		struct bch_cf_cache *cf_cache =
+			kmalloc(sizeof(struct bch_cf_cache), GFP_KERNEL);
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
+DEFINE_FREE(bch2_hash_free_cf, struct bch_cf_cache *, if (_T) kfree(_T))
+
 struct bch_str_hash_ctx {
 	union {
 		u32		crc32c;
@@ -134,9 +178,9 @@ struct bch_hash_desc {
 	enum btree_id	btree_id;
 	u8		key_type;
 
-	u64		(*hash_key)(const struct bch_hash_info *, const void *);
-	u64		(*hash_bkey)(const struct bch_hash_info *, struct bkey_s_c);
-	bool		(*cmp_key)(struct bkey_s_c, const void *);
+	u64		(*hash_key)(const struct bch_hash_info *, const void *, struct bch_cf_cache *cf_cache);
+	u64		(*hash_bkey)(const struct bch_hash_info *, struct bkey_s_c, struct bch_cf_cache *cf_cache);
+	bool		(*cmp_key)(const struct bch_hash_info *, struct bkey_s_c, const void *, struct bch_cf_cache *cf_cache);
 	bool		(*cmp_bkey)(struct bkey_s_c, struct bkey_s_c);
 	bool		(*is_visible)(subvol_inum inum, struct bkey_s_c);
 };
@@ -157,6 +201,7 @@ bch2_hash_lookup(struct btree_trans *trans,
 		 subvol_inum inum, const void *key,
 		 unsigned flags)
 {
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
 	struct bkey_s_c k;
 	u32 snapshot;
 	int ret;
@@ -165,12 +210,17 @@ bch2_hash_lookup(struct btree_trans *trans,
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
@@ -191,6 +241,7 @@ bch2_hash_hole(struct btree_trans *trans,
 	       const struct bch_hash_info *info,
 	       subvol_inum inum, const void *key)
 {
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
 	struct bkey_s_c k;
 	u32 snapshot;
 	int ret;
@@ -199,8 +250,13 @@ bch2_hash_hole(struct btree_trans *trans,
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
@@ -216,6 +272,7 @@ int bch2_hash_needs_whiteout(struct btree_trans *trans,
 			     const struct bch_hash_info *info,
 			     struct btree_iter *start)
 {
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
 	struct btree_iter iter;
 	struct bkey_s_c k;
 	int ret;
@@ -224,13 +281,18 @@ int bch2_hash_needs_whiteout(struct btree_trans *trans,
 
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
@@ -250,13 +312,19 @@ int bch2_hash_set_snapshot(struct btree_trans *trans,
 			   int update_flags)
 {
 	struct btree_iter iter, slot = { NULL };
+	struct bch_cf_cache *cf_cache __free(bch2_hash_free_cf) = NULL;
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
index 5c62fcf3afdb..9d9b8b470fbd 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -757,6 +757,16 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	if (ret)
 		goto err;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	/* Default encoding until we can potentially have more as an option. */
+	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
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
index 6f6b3caf0607..e423a1a24e31 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -27,12 +27,12 @@ static u64 bch2_xattr_hash(const struct bch_hash_info *info,
 	return bch2_str_hash_end(&ctx, info);
 }
 
-static u64 xattr_hash_key(const struct bch_hash_info *info, const void *key)
+static u64 xattr_hash_key(const struct bch_hash_info *info, const void *key, struct bch_cf_cache *cf_cache)
 {
 	return bch2_xattr_hash(info, key);
 }
 
-static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
+static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k, struct bch_cf_cache *cf_cache)
 {
 	struct bkey_s_c_xattr x = bkey_s_c_to_xattr(k);
 
@@ -40,7 +40,7 @@ static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 		 &X_SEARCH(x.v->x_type, x.v->x_name, x.v->x_name_len));
 }
 
-static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
+static bool xattr_cmp_key(const struct bch_hash_info *info, struct bkey_s_c _l, const void *_r, struct bch_cf_cache *cf_cache)
 {
 	struct bkey_s_c_xattr l = bkey_s_c_to_xattr(_l);
 	const struct xattr_search_key *r = _r;
-- 
2.41.0

