Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CB8C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 17:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjHMRil (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjHMRik (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 13:38:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F721709
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:40 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-31765aee31bso3026426f8f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691948319; x=1692553119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7D2HF61CFMNc+24hD50uUjqbEQtURNhhjNHW6th5cEs=;
        b=XTU45LUmjLq93UigF0DNbtq4MFy2i0HNGjJNmjPn9OSwBlxvq9c+X4q55X3VqGDHkP
         /46FfdkF4Rw8kEmwzbAf4M+tJZSeNDb6SV9uw/WREasSgT/F/8f+CiX7BKCJNHzp2SeG
         IsYWJTiHa8VRJCFaU63134GCTX4O7t4ANrnOKYtKwLimxXNFqIME8AkgDHL1Lh8MISYu
         a0UsRMfj1qlKqv5PrIr6oypCXePMIosH6BldZgG7Te5vInDB/no7pot/Tagy90y+z+QG
         qBP0SqweyB5odtcpm7blf4XWQW30cVuyc0birRh3cYN0jzyBB18dVBOd9DwX7NK3BG58
         29cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691948319; x=1692553119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7D2HF61CFMNc+24hD50uUjqbEQtURNhhjNHW6th5cEs=;
        b=GUTv1h1LXHxtXFO8XeGinDXBWhZJMmz1UhLMLiTTMvFKMzbGsF1aJOGm0Ev20wheYV
         kM/8hpuVNRvUkbh7sw4rPb/5e3GfQAi0aj6le1N7zXJATqFuqrOX/k5TFOGiGMMoxAQk
         JKiiZXoksMYOR3b+7CXHdemm1Fhdtzalpm83UhUiiKcO0XDSn1ftMc8n+RUrSy2L+otj
         bpHM4YYVfEj5M5G3Aq0cKMQgZKCRcauPPjthnt6igK3pSRIh0pfV1GoqbJYF8kdkfoP/
         GmwqeaCH0Fm0Fjm6NbmWuzJSUdQefnqDBzQhD+Ozk7z+5ChD5uM871t5MbtoTTNuQS2A
         JtFg==
X-Gm-Message-State: AOJu0Ywxxym+DJgrJKuuZUDTxAcgnZ/YEdvqJ+TF+Mee9OUC7xu27+52
        r4hFrf8zPmuL18OVdvbjVeaFfhIUbv5nDFUz4hA=
X-Google-Smtp-Source: AGHT+IEkhGviw+2nvLvAbIXBC6Q2lrxOfJ56eL2LHF3p9SZ0i7tmbRGUtI/IPrqKsiffCAQMuLXyRg==
X-Received: by 2002:adf:da49:0:b0:317:7af4:5294 with SMTP id r9-20020adfda49000000b003177af45294mr4524419wrl.44.1691948318809;
        Sun, 13 Aug 2023 10:38:38 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d5106000000b003141a3c4353sm11962115wrt.30.2023.08.13.10.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 10:38:38 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [v3 3/3] bcachefs: Implement casefolding
Date:   Sun, 13 Aug 2023 18:38:27 +0100
Message-ID: <20230813173835.195840-4-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813173835.195840-1-joshua@froggi.es>
References: <20230813173835.195840-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This patch implements support for case-insensitive file name lookups
in bcachefs.

The implementation uses the same UTF-8 lowering and normalization that
ext4 and f2fs is using.

More information is provided in Documentation/bcachefs/casefolding.rst

Signed-off-by: Joshua Ashton <joshua@froggi.es>

Cc: André Almeida <andrealmeid@igalia.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
---
 .../filesystems/bcachefs/casefolding.rst      |  73 +++++++++
 fs/bcachefs/bcachefs.h                        |   6 +
 fs/bcachefs/bcachefs_format.h                 |  26 ++-
 fs/bcachefs/dirent.c                          | 154 +++++++++++++++---
 fs/bcachefs/fs-common.c                       |   4 +
 fs/bcachefs/fs-ioctl.c                        |  22 +++
 fs/bcachefs/fs-ioctl.h                        |  20 ++-
 fs/bcachefs/str_hash.h                        |  18 ++
 fs/bcachefs/super.c                           |  19 +++
 9 files changed, 309 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/casefolding.rst

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
new file mode 100644
index 000000000000..c8580d892ae8
--- /dev/null
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -0,0 +1,73 @@
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
+Casefolding support requires a kernel with the `CONFIG_UNICODE` enabled.
+Once a directory has been flagged for casefolding, a feature bit
+is enabled on the superblock which marks the filesystem as using
+casefolding.
+When the feature bit for casefolding is enabled, it is no longer possible
+to mount that filesystem on kernels without `CONFIG_UNICODE` enabled.
+
+On the lookup/query side: casefolding is implemented by allocating a new
+string of `BCH_NAME_MAX` length using the `utf8_casefold` function to
+casefold the query string.
+
+On the dirent side: casefolding is implemented by ensuring the `bkey`'s
+hash is made from the casefolded string and storing the cached casefolded
+name with the regular name in the dirent.
+
+The structure looks like this:
+
+Regular:    [dirent data][regular name][nul][nul]...
+Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
+
+(Do note, the number of `NUL`s here is merely for illustration, they count can vary
+ per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
+
+This is efficient as it means that for all file lookups that require casefolding,
+it has identical performance to a regular lookup:
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
+
+The feature bit was used to allow casefolding support to be enabled for the majority
+of users, but some allow users who have no need for the feature to still use bcachefs as
+`CONFIG_UNICODE` can increase the kernel side a significant amount due to the tables used,
+which may be decider between using bcachefs for eg. embedded platforms.
+
+Other filesystems like ext4 and f2fs have a super-block level option for casefolding
+encoding, but bcachefs currently does not provide this. ext4 and f2fs do not expose
+any encodings than a single UTF-8 version. When future encodings are desirable,
+they will be added trivially using the opts mechanism.
+
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 30b3d7b9f9dc..0e1facdc7876 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -202,6 +202,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/zstd.h>
+#include <linux/unicode.h>
 
 #include "bcachefs_format.h"
 #include "errcode.h"
@@ -657,6 +658,8 @@ enum bch_write_ref {
 	BCH_WRITE_REF_NR,
 };
 
+#define BCH_FS_DEFAULT_UTF8_ENCODING UNICODE_AGE(12, 1, 0)
+
 struct bch_fs {
 	struct closure		cl;
 
@@ -723,6 +726,9 @@ struct bch_fs {
 		u64		compat;
 	}			sb;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct unicode_map 	*cf_encoding;
+#endif
 
 	struct bch_sb_handle	disk_sb;
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 23bae622309c..cc6797422977 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -852,6 +852,8 @@ enum {
 	__BCH_INODE_UNLINKED		= 7,
 	__BCH_INODE_BACKPTR_UNTRUSTED	= 8,
 
+	__BCH_INODE_CASEFOLDED		= 9,
+
 	/* bits 20+ reserved for packed fields below: */
 };
 
@@ -864,6 +866,7 @@ enum {
 #define BCH_INODE_I_SECTORS_DIRTY (1 << __BCH_INODE_I_SECTORS_DIRTY)
 #define BCH_INODE_UNLINKED	(1 << __BCH_INODE_UNLINKED)
 #define BCH_INODE_BACKPTR_UNTRUSTED (1 << __BCH_INODE_BACKPTR_UNTRUSTED)
+#define BCH_INODE_CASEFOLDED	(1 << __BCH_INODE_CASEFOLDED)
 
 LE32_BITMASK(INODE_STR_HASH,	struct bch_inode, bi_flags, 20, 24);
 LE32_BITMASK(INODE_NR_FIELDS,	struct bch_inode, bi_flags, 24, 31);
@@ -908,9 +911,25 @@ struct bch_dirent {
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
+		__u8		d_pad;
+		__le16		d_name_len;
+		__le16		d_cf_name_len;
+		__u8		d_names[0];
+	} d_cf_name_block __packed;
+	__u8			d_name[0];
+	} __packed;
 } __packed __aligned(8);
 
 #define DT_SUBVOL	16
@@ -1841,7 +1860,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(new_varint,			15)	\
 	x(journal_no_flush,		16)	\
 	x(alloc_v2,			17)	\
-	x(extents_across_btree_nodes,	18)
+	x(extents_across_btree_nodes,	18)	\
+	x(casefolding,			19)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	((1ULL << BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 6bdcccabd732..72478276402d 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -13,8 +13,12 @@
 
 #include <linux/dcache.h>
 
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
@@ -31,13 +35,41 @@ static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
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
+}
+
+static inline struct qstr bch2_dirent_get_lookup_name(struct bkey_s_c_dirent d)
+{
+	return d.v->d_casefold
+		? bch2_dirent_get_casefold_name(d)
+		: bch2_dirent_get_name(d);
 }
 
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
@@ -60,7 +92,7 @@ static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
 static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
-	struct qstr name = bch2_dirent_get_name(d);
+	struct qstr name = bch2_dirent_get_lookup_name(d);
 
 	return bch2_dirent_hash(info, &name);
 }
@@ -68,7 +100,7 @@ static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 static bool dirent_cmp_key(struct bkey_s_c _l, const void *_r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
-	const struct qstr l_name = bch2_dirent_get_name(l);
+	const struct qstr l_name = bch2_dirent_get_lookup_name(l);
 	const struct qstr *r_name = _r;
 
 	return l_name.len - r_name->len ?: memcmp(l_name.name, r_name->name, l_name.len);
@@ -78,8 +110,8 @@ static bool dirent_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
 	struct bkey_s_c_dirent r = bkey_s_c_to_dirent(_r);
-	const struct qstr l_name = bch2_dirent_get_name(l);
-	const struct qstr r_name = bch2_dirent_get_name(r);
+	const struct qstr l_name = bch2_dirent_get_lookup_name(l);
+	const struct qstr r_name = bch2_dirent_get_lookup_name(r);
 
 	return l_name.len - r_name.len ?: memcmp(l_name.name, r_name.name, l_name.len);
 }
@@ -109,15 +141,16 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr d_name = bch2_dirent_get_name(d);
+	struct qstr d_cf_name = bch2_dirent_get_casefold_name(d);
 
 	if (!d_name.len) {
 		prt_printf(err, "empty name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len)) {
+	if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len, d_cf_name.len)) {
 		prt_printf(err, "value too big (%zu > %u)",
-		       bkey_val_u64s(k.k), dirent_val_u64s(d_name.len));
+		       bkey_val_u64s(k.k), dirent_val_u64s(d_name.len, d_cf_name.len));
 		return -BCH_ERR_invalid_bkey;
 	}
 
@@ -157,6 +190,24 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 		return -BCH_ERR_invalid_bkey;
 	}
 
+	if (d.v->d_casefold) {
+#if !IS_ENABLED(CONFIG_UNICODE)
+		prt_printf(err, "dirent bkey with casefolding without CONFIG_UNICODE");
+		return -BCH_ERR_invalid_bkey;
+#endif
+
+		if ((flags & BKEY_INVALID_COMMIT) && d_cf_name.len > BCH_NAME_MAX) {
+			prt_printf(err, "dirent w/ cf name too big (%u > %u)",
+			d_cf_name.len, BCH_NAME_MAX);
+			return -BCH_ERR_invalid_bkey;
+		}
+
+		if (d_cf_name.len != strnlen(d_cf_name.name, d_cf_name.len)) {
+			prt_printf(err, "dirent has stray data after cf name's NUL");
+			return -BCH_ERR_invalid_bkey;
+		}
+	}
+
 	return 0;
 }
 
@@ -178,10 +229,11 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 				subvol_inum dir,
 				u8 type,
-				int name_len, u64 dst)
+				int name_len, int cf_name_len,
+				u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len);
+	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len, cf_name_len);
 
 	BUG_ON(u64s > U8_MAX);
 
@@ -200,6 +252,8 @@ static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 	}
 
 	dirent->v.d_type = type;
+	dirent->v.d_unused = 0;
+	dirent->v.d_casefold = cf_name_len ? 1 : 0;
 
 	return dirent;
 }
@@ -207,6 +261,8 @@ static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
 static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
 				     const struct qstr *name)
 {
+	EBUG_ON(dirent->v.d_casefold);
+
 	memcpy(&dirent->v.d_name[0], name->name, name->len);
 	memset(&dirent->v.d_name[name->len], 0,
 		bkey_val_bytes(&dirent->k) -
@@ -214,10 +270,30 @@ static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
 		name->len);
 }
 
+static void dirent_init_casefolded_name(struct bkey_i_dirent *dirent,
+					const struct qstr *name,
+					const struct qstr *cf_name)
+{
+	EBUG_ON(!dirent->v.d_casefold);
+	EBUG_ON(!cf_name->len);
+
+	dirent->v.d_cf_name_block.d_name_len = name->len;
+	dirent->v.d_cf_name_block.d_cf_name_len = cf_name->len;
+	memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
+	memcpy(&dirent->v.d_cf_name_block.d_names[name->len], cf_name->name, cf_name->len);
+	memset(&dirent->v.d_cf_name_block.d_names[name->len + cf_name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_cf_name_block.d_names) -
+		name->len + cf_name->len);
+
+	EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != cf_name->len);
+}
+
 static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 				subvol_inum dir,
 				u8 type,
 				const struct qstr *name,
+				const struct qstr *cf_name,
 				u64 dst)
 {
 	struct bkey_i_dirent *dirent;
@@ -225,13 +301,16 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 	if (name->len > BCH_NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	dirent = dirent_alloc_key(trans, dir, type, name->len, dst);
+	dirent = dirent_alloc_key(trans, dir, type, name->len, cf_name ? cf_name->len : 0, dst);
 	if (IS_ERR(dirent))
 		return dirent;
 
-	dirent_init_regular_name(dirent, name);
+	if (cf_name)
+		dirent_init_casefolded_name(dirent, name, cf_name);
+	else
+		dirent_init_regular_name(dirent, name);
 
-	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
+	EBUG_ON(bch2_dirent_get_name(dirent_i_to_s_c(dirent)).len != name->len);
 
 	return dirent;
 }
@@ -241,10 +320,19 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
 		       u8 type, const struct qstr *name, u64 dst_inum,
 		       u64 *dir_offset, int flags)
 {
+	char cf_name_buf[BCH_NAME_MAX + 1];
 	struct bkey_i_dirent *dirent;
 	int ret;
 
-	dirent = dirent_create_key(trans, dir, type, name, dst_inum);
+	if (hash_info->cf_encoding) {
+		struct qstr cf_name = bch2_casefold(hash_info, name, cf_name_buf, BCH_NAME_MAX + 1);
+		if (!cf_name.len)
+			return -EINVAL;
+		dirent = dirent_create_key(trans, dir, type, name, &cf_name, dst_inum);
+	} else {
+		dirent = dirent_create_key(trans, dir, type, name, NULL, dst_inum);
+	}
+
 	ret = PTR_ERR_OR_ZERO(dirent);
 	if (ret)
 		return ret;
@@ -294,6 +382,10 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
 		enum bch_rename_mode mode)
 {
+	char src_cf_name[BCH_NAME_MAX + 1];
+	char dst_cf_name[BCH_NAME_MAX + 1];
+	struct qstr src_name_lookup;
+	struct qstr dst_name_lookup;
 	struct btree_iter src_iter = { NULL };
 	struct btree_iter dst_iter = { NULL };
 	struct bkey_s_c old_src, old_dst = bkey_s_c_null;
@@ -310,8 +402,13 @@ int bch2_dirent_rename(struct btree_trans *trans,
 	memset(dst_inum, 0, sizeof(*dst_inum));
 
 	/* Lookup src: */
+	src_name_lookup = src_hash->cf_encoding
+		? bch2_casefold(src_hash, src_name, src_cf_name, BCH_NAME_MAX + 1)
+		: *src_name;
+	if (!src_name_lookup.len)
+		return -EINVAL;
 	ret = bch2_hash_lookup(trans, &src_iter, bch2_dirent_hash_desc,
-			       src_hash, src_dir, src_name,
+			       src_hash, src_dir, &src_name_lookup,
 			       BTREE_ITER_INTENT);
 	if (ret)
 		goto out;
@@ -333,6 +430,11 @@ int bch2_dirent_rename(struct btree_trans *trans,
 
 
 	/* Lookup dst: */
+	dst_name_lookup = dst_hash->cf_encoding
+		? bch2_casefold(dst_hash, dst_name, dst_cf_name, BCH_NAME_MAX + 1)
+		: *dst_name;
+	if (!dst_name_lookup.len)
+		return -EINVAL;
 	if (mode == BCH_RENAME) {
 		/*
 		 * Note that we're _not_ checking if the target already exists -
@@ -340,12 +442,12 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		 * correctness:
 		 */
 		ret = bch2_hash_hole(trans, &dst_iter, bch2_dirent_hash_desc,
-				     dst_hash, dst_dir, dst_name);
+				     dst_hash, dst_dir, &dst_name_lookup);
 		if (ret)
 			goto out;
 	} else {
 		ret = bch2_hash_lookup(trans, &dst_iter, bch2_dirent_hash_desc,
-				       dst_hash, dst_dir, dst_name,
+				       dst_hash, dst_dir, &dst_name_lookup,
 				       BTREE_ITER_INTENT);
 		if (ret)
 			goto out;
@@ -370,7 +472,8 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		*src_offset = dst_iter.pos.offset;
 
 	/* Create new dst key: */
-	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name, 0);
+	new_dst = dirent_create_key(trans, dst_dir, 0, dst_name,
+				    dst_hash->cf_encoding ? &dst_name_lookup : NULL, 0);
 	ret = PTR_ERR_OR_ZERO(new_dst);
 	if (ret)
 		goto out;
@@ -380,7 +483,8 @@ int bch2_dirent_rename(struct btree_trans *trans,
 
 	/* Create new src key: */
 	if (mode == BCH_RENAME_EXCHANGE) {
-		new_src = dirent_create_key(trans, src_dir, 0, src_name, 0);
+		new_src = dirent_create_key(trans, src_dir, 0, src_name,
+					    src_hash->cf_encoding ? &src_name_lookup : NULL, 0);
 		ret = PTR_ERR_OR_ZERO(new_src);
 		if (ret)
 			goto out;
@@ -507,16 +611,24 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
 		       const struct bch_hash_info *hash_info,
 		       const struct qstr *name, subvol_inum *inum)
 {
+	char cf_name[BCH_NAME_MAX + 1];
+	struct qstr lookup_name;
 	struct btree_trans trans;
 	struct btree_iter iter;
 	int ret;
 
+	lookup_name = hash_info->cf_encoding
+		? bch2_casefold(hash_info, name, cf_name, BCH_NAME_MAX + 1)
+		: *name;
+	if (!lookup_name.len)
+		return -EINVAL;
+
 	bch2_trans_init(&trans, c, 0, 0);
 retry:
 	bch2_trans_begin(&trans);
 
 	ret = __bch2_dirent_lookup_trans(&trans, &iter, dir, hash_info,
-					  name, inum, 0);
+					 &lookup_name, inum, 0);
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		goto retry;
 	if (!ret)
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
index 141bcced031e..d0bac39e2326 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -54,6 +54,28 @@ static int bch2_inode_flags_set(struct btree_trans *trans,
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
+		return -EOPNOTSUPP;
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
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index ae21a8cca1b4..29d6c286d672 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -34,6 +34,7 @@ bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
 
 struct bch_hash_info {
 	u8			type;
+	struct unicode_map 	*cf_encoding;
 	/*
 	 * For crc32 or crc64 string hashes the first key value of
 	 * the siphash_key (k0) is used as the key.
@@ -48,6 +49,9 @@ bch2_hash_info_init(struct bch_fs *c, const struct bch_inode_unpacked *bi)
 	struct bch_hash_info info = {
 		.type = (bi->bi_flags >> INODE_STR_HASH_OFFSET) &
 			~(~0U << INODE_STR_HASH_BITS),
+#if IS_ENABLED(CONFIG_UNICODE)
+		.cf_encoding = !!(bi->bi_flags & BCH_INODE_CASEFOLDED) ? c->cf_encoding : NULL,
+#endif
 		.siphash_key = { .k0 = bi->bi_hash_seed }
 	};
 
@@ -367,4 +371,18 @@ int bch2_hash_delete(struct btree_trans *trans,
 	return ret;
 }
 
+static __always_inline
+struct qstr bch2_casefold(const struct bch_hash_info *info, const struct qstr *str,
+			  unsigned char *dest, size_t dlen)
+{
+#if IS_ENABLED(CONFIG_UNICODE)
+	int len = utf8_casefold(info->cf_encoding, str, dest, dlen);
+	if (len <= 0)
+		return (struct qstr) QSTR_INIT(NULL, 0);
+	return (struct qstr) QSTR_INIT(dest, len);
+#else
+	return (struct qstr) QSTR_INIT(NULL, 0);
+#endif
+}
+
 #endif /* _BCACHEFS_STR_HASH_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 5c62fcf3afdb..78d19cfb966a 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -757,6 +757,25 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	if (ret)
 		goto err;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+	/* Default encoding until we can potentially have more as an option. */
+	c->cf_encoding = utf8_load(BCH_FS_DEFAULT_UTF8_ENCODING);
+	if (IS_ERR(c->cf_encoding)) {
+		printk(KERN_ERR "Cannot load UTF-8 encoding for filesystem. Version: %u.%u.%u",
+			unicode_major(BCH_FS_DEFAULT_UTF8_ENCODING),
+			unicode_minor(BCH_FS_DEFAULT_UTF8_ENCODING),
+			unicode_rev(BCH_FS_DEFAULT_UTF8_ENCODING));
+		ret = -EINVAL;
+		goto err;
+	}
+#else
+	if (c->sb.features & (1ULL << BCH_FEATURE_casefolding)) {
+		printk(KERN_ERR "Cannot mount a filesystem with casefolding on a kernel without CONFIG_UNICODE\n");
+		ret = -EINVAL;
+		goto err;
+	}
+#endif
+
 	pr_uuid(&name, c->sb.user_uuid.b);
 	strscpy(c->name, name.buf, sizeof(c->name));
 	printbuf_exit(&name);
-- 
2.41.0

