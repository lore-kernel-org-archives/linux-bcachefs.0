Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72B1C77B60
	for <linux-bcachefs@archiver.kernel.org>; Fri, 28 Apr 2023 19:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346167AbjD1T2v (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 28 Apr 2023 15:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346225AbjD1T2u (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 28 Apr 2023 15:28:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4176249C8
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Apr 2023 12:28:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so172018a12.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Apr 2023 12:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682710123; x=1685302123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wU7a/Li2/cK6HSDMjoYbwY1aWdWumvEKY7jEN8k+ijI=;
        b=RsAG6P4lP6PWl+B8HOg9mdzYX5l2z2iSbvK5WsehulPXe44z3Zc6Semk49/lbBQCuj
         a1HwgObkTAd1FudJYMYIWYcTRGWjgBXPw5/UwbKcwDVWVqw7zcZow64hz85HaysHiVf+
         qXaW4yOVmePOtM8yK5rGequ+k2FxMu7TS7mVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682710123; x=1685302123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wU7a/Li2/cK6HSDMjoYbwY1aWdWumvEKY7jEN8k+ijI=;
        b=TRUmJBT4DOUJPLq6NVitgsFgr7rWYh/oeL991BhpVBhjvig/JSzcVXteEF36HhoY5+
         3dlnLE+AzYCeKCA2WiD+rvE8UOfP0BNZWfbmwLo63UPLI2g+FOYsH3frudmsMey6fc7p
         UMI5J3DX6oPKrc315OLC5zB8x4TYOsDklTgGFFprg1RKVu6kWZy2gpJTJBXPOfP/WT9R
         YGcTLeoka1fuh1292Od6hJrVJegFhqK+UWF9e9JYvr2iGi6xgKev0TR4dOC0QGnC0Xv0
         42oHaOrb9+QzLpqJsrmsI5KBVICR80iSlIjuR7aK9BbnTCF9LJJB04wfEsQLDp/7AOlc
         PDLw==
X-Gm-Message-State: AC+VfDyDPKX4P0rFyGvRjfl7mWkcPuy25HL4auQS/AWYyYeMwTJbp8xm
        1f+nb0dt2A/nTp3nhWOSmFJ4Z52kooK7OFTnzgxJiQ==
X-Google-Smtp-Source: ACHHUZ74JZCyL46GAeGV8v/i455uFTUDkLtEvD8rsLhFNZSu5+tGUSMawYXL9o8/yOEURptBKcFJpA==
X-Received: by 2002:a17:902:ec82:b0:1a9:7f45:8721 with SMTP id x2-20020a170902ec8200b001a97f458721mr7388170plg.48.1682710123155;
        Fri, 28 Apr 2023 12:28:43 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:4cd:5f70:7915:d7f9])
        by smtp.gmail.com with ESMTPSA id bf9-20020a170902b90900b001a19438336esm13621293plb.67.2023.04.28.12.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 12:28:42 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] chore(format): rewrite `read_one_super` in Rust
Date:   Fri, 28 Apr 2023 12:28:33 -0700
Message-Id: <20230428192833.86943-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This rewrite tries to be as close to C code as possible, thus almost the whole
block is in `unsafe {}`. After this commit is merge, there will be further
refactoring to make it more Rust-idiomatic. There are several things to note:

1. `read_one_super_result` return the result, with the Error formatting again
  closely matches C's counter-part. In the future, we may no longer need
  `return_code` inside the error.
2. There is only 1 `goto` statement, which can be easily rewritten into a loop
  with conditional break
3. There are several functions and const defined as C macro that are redefined
  as `fn_*` for functions and `BLK_.*`
4. This rewritten is aware for BCACHEFS_NO_RUST flag

Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
---
 libbcachefs/bcachefs_format.h  |   8 +-
 libbcachefs/checksum.c         |  10 ++
 libbcachefs/checksum.h         |   9 +-
 libbcachefs/super-io.c         |  40 ++++++
 libbcachefs/super-io.h         |  12 ++
 rust-src/bch_bindgen/build.rs  |   6 +
 rust-src/src/lib.rs            |   1 +
 rust-src/src/read_one_super.rs | 228 +++++++++++++++++++++++++++++++++
 8 files changed, 300 insertions(+), 14 deletions(-)
 create mode 100644 rust-src/src/read_one_super.rs

diff --git a/libbcachefs/bcachefs_format.h b/libbcachefs/bcachefs_format.h
index 7d1c0b1..0f97b00 100644
--- a/libbcachefs/bcachefs_format.h
+++ b/libbcachefs/bcachefs_format.h
@@ -1900,12 +1900,8 @@ enum bch_compression_opts {
  * xored with the first part of the cache set's UUID
  */
 
-#define BCACHE_MAGIC							\
-	UUID_LE(0xf67385c6, 0x1a4e, 0xca45,				\
-		0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81)
-#define BCHFS_MAGIC							\
-	UUID_LE(0xf67385c6, 0xce66, 0xa990,				\
-		0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)
+extern const uuid_le BCACHE_MAGIC;
+extern const uuid_le BCHFS_MAGIC;
 
 #define BCACHEFS_STATFS_MAGIC		0xca451a4e
 
diff --git a/libbcachefs/checksum.c b/libbcachefs/checksum.c
index 843e138..6734d39 100644
--- a/libbcachefs/checksum.c
+++ b/libbcachefs/checksum.c
@@ -33,6 +33,16 @@ struct bch2_checksum_state {
 	unsigned int type;
 };
 
+/* returns true if not equal */
+bool bch2_crc_cmp(struct bch_csum l, struct bch_csum r)
+{
+	/*
+	 * XXX: need some way of preventing the compiler from optimizing this
+	 * into a form that isn't constant time..
+	 */
+	return ((l.lo ^ r.lo) | (l.hi ^ r.hi)) != 0;
+}
+
 static void bch2_checksum_init(struct bch2_checksum_state *state)
 {
 	switch (state->type) {
diff --git a/libbcachefs/checksum.h b/libbcachefs/checksum.h
index 409ad53..fea193a 100644
--- a/libbcachefs/checksum.h
+++ b/libbcachefs/checksum.h
@@ -139,14 +139,7 @@ static inline bool bch2_checksum_type_valid(const struct bch_fs *c,
 }
 
 /* returns true if not equal */
-static inline bool bch2_crc_cmp(struct bch_csum l, struct bch_csum r)
-{
-	/*
-	 * XXX: need some way of preventing the compiler from optimizing this
-	 * into a form that isn't constant time..
-	 */
-	return ((l.lo ^ r.lo) | (l.hi ^ r.hi)) != 0;
-}
+bool bch2_crc_cmp(struct bch_csum l, struct bch_csum r);
 
 /* for skipping ahead and encrypting/decrypting at an offset: */
 static inline struct nonce nonce_add(struct nonce nonce, unsigned offset)
diff --git a/libbcachefs/super-io.c b/libbcachefs/super-io.c
index 519df09..95339d9 100644
--- a/libbcachefs/super-io.c
+++ b/libbcachefs/super-io.c
@@ -31,6 +31,17 @@ const char * const bch2_sb_fields[] = {
 	NULL
 };
 
+const uint BLK_REQ_SYNC = REQ_SYNC;
+const uint BLK_REQ_META = REQ_META;
+
+const uuid_le BCACHE_MAGIC =
+	UUID_LE(0xf67385c6, 0x1a4e, 0xca45,				\
+		0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81);
+const uuid_le BCHFS_MAGIC =
+	UUID_LE(0xf67385c6, 0xce66, 0xa990,				\
+		0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef);
+
+
 static int bch2_sb_field_validate(struct bch_sb *, struct bch_sb_field *,
 				  struct printbuf *);
 
@@ -508,10 +519,38 @@ int bch2_sb_from_fs(struct bch_fs *c, struct bch_dev *ca)
 	return __copy_super(&ca->disk_sb, c->disk_sb.sb);
 }
 
+struct bch_csum fn_csum_from_sb(struct bch_sb *sb) {
+	return csum_vstruct(NULL, BCH_SB_CSUM_TYPE(sb),
+			    null_nonce(), sb);
+}
+u64 fn_BCH_SB_CSUM_TYPE(struct bch_sb *sb) {
+	return BCH_SB_CSUM_TYPE(sb);
+}
+
+bool fn_uuid_le_cmp(const uuid_le a, const uuid_le b) {
+	return uuid_le_cmp(a, b);
+}
+uint fn_le16_to_cpu(const u16 i) {
+	return le16_to_cpu(i);
+}
+uint fn_le32_to_cpu(const u32 i) {
+	return le32_to_cpu(i);
+}
+u64 fn_le64_to_cpu(const u64 i) {
+	return le64_to_cpu(i);
+}
+size_t fn_vstruct_bytes(const struct bch_sb *sb) {
+	return vstruct_bytes(sb);
+}
+
+
 /* read superblock: */
 
 static int read_one_super(struct bch_sb_handle *sb, u64 offset, struct printbuf *err)
 {
+	#ifndef BCACHEFS_NO_RUST
+	return read_one_super_rust(sb, offset, err);
+	#else
 	struct bch_csum csum;
 	u32 version, version_min;
 	size_t bytes;
@@ -582,6 +621,7 @@ reread:
 	sb->seq = le64_to_cpu(sb->sb->seq);
 
 	return 0;
+	#endif
 }
 
 int bch2_read_super(const char *path, struct bch_opts *opts,
diff --git a/libbcachefs/super-io.h b/libbcachefs/super-io.h
index 14a25f6..bdc1fa0 100644
--- a/libbcachefs/super-io.h
+++ b/libbcachefs/super-io.h
@@ -66,6 +66,18 @@ void bch2_free_super(struct bch_sb_handle *);
 int bch2_sb_realloc(struct bch_sb_handle *, unsigned);
 
 int bch2_read_super(const char *, struct bch_opts *, struct bch_sb_handle *);
+int read_one_super_rust(struct bch_sb_handle *sb, u64 offset, struct printbuf *err);
+
+struct bch_csum fn_csum_from_sb(struct bch_sb *sb);
+u64 fn_BCH_SB_CSUM_TYPE(struct bch_sb *sb);
+bool fn_uuid_le_cmp(const uuid_le a, const uuid_le b);
+uint fn_le16_to_cpu(const u16 i);
+uint fn_le32_to_cpu(const u32 i);
+u64 fn_le64_to_cpu(const u64 i);
+size_t fn_vstruct_bytes(const struct bch_sb *sb);
+extern const uint BLK_REQ_SYNC;
+extern const uint BLK_REQ_META;
+
 int bch2_write_super(struct bch_fs *);
 void __bch2_check_set_feature(struct bch_fs *, unsigned);
 
diff --git a/rust-src/bch_bindgen/build.rs b/rust-src/bch_bindgen/build.rs
index 92ec3ce..a28df8a 100644
--- a/rust-src/bch_bindgen/build.rs
+++ b/rust-src/bch_bindgen/build.rs
@@ -60,6 +60,12 @@ fn main() {
         .allowlist_var("KEY_SPEC_.*")
         .allowlist_var("Fix753_FMODE_.*")
         .allowlist_var("bch.*")
+        .allowlist_var(".*_MAGIC")
+        .allowlist_var("BLK_.*")
+        .allowlist_type("req_opf")
+        .allowlist_type("bcachefs_metadata_version")
+        .allowlist_function("fn_.*")
+        .allowlist_function("submit_bio_wait")
         .allowlist_var("__BTREE_ITER.*")
         .allowlist_var("BTREE_ITER.*")
         .blocklist_item("bch2_bkey_ops")
diff --git a/rust-src/src/lib.rs b/rust-src/src/lib.rs
index 159d049..dcf0219 100644
--- a/rust-src/src/lib.rs
+++ b/rust-src/src/lib.rs
@@ -2,6 +2,7 @@ pub mod key;
 pub mod logger;
 pub mod cmd_mount;
 pub mod cmd_list;
+pub mod read_one_super;
 
 #[macro_export]
 macro_rules! c_str {
diff --git a/rust-src/src/read_one_super.rs b/rust-src/src/read_one_super.rs
new file mode 100644
index 0000000..290c3e7
--- /dev/null
+++ b/rust-src/src/read_one_super.rs
@@ -0,0 +1,228 @@
+/* read superblock: */
+
+use std::{error::Error, ffi::CString, fmt};
+
+use anyhow::bail;
+use bch_bindgen::c::{
+    bcachefs_metadata_version::{
+        bcachefs_metadata_version_bkey_renumber, bcachefs_metadata_version_max,
+        bcachefs_metadata_version_min,
+    },
+    bch2_bio_map, bch2_prt_printf, bch2_sb_realloc, bch_csum,
+    bch_csum_type::BCH_CSUM_NR,
+    bch_errcode::{
+        BCH_ERR_invalid_sb_csum, BCH_ERR_invalid_sb_csum_type, BCH_ERR_invalid_sb_magic,
+        BCH_ERR_invalid_sb_too_big, BCH_ERR_invalid_sb_version,
+    },
+    bch_sb_handle, bio_reset, fn_BCH_SB_CSUM_TYPE, bch2_crc_cmp, fn_csum_from_sb,
+    fn_le16_to_cpu, fn_le32_to_cpu, fn_le64_to_cpu, fn_uuid_le_cmp, fn_vstruct_bytes, printbuf,
+    req_opf::REQ_OP_READ,
+    submit_bio_wait, BCACHE_MAGIC, BCHFS_MAGIC, BLK_REQ_META, BLK_REQ_SYNC,
+};
+use libc::{c_int, c_void, size_t};
+use log::trace;
+
+#[derive(Debug)]
+enum ReadOneSuperErrorType {
+    InvalidSuperBlockVersionError {
+        version: u32,
+        min_version: u32,
+        max_version: u32,
+    },
+    IOError,
+    NotABcachefsSuperBlockError,
+    InvalidSuperBlockTooBigError {
+        bytes: usize,
+        max_size_bits: u8,
+    },
+    CannotReallocError,
+    InvalidSuperBlockCsumType(u64),
+    InvalidSuperBlockCsum,
+}
+
+#[derive(Debug)]
+struct ReadOneSuperError {
+    return_code: c_int,
+    error: ReadOneSuperErrorType,
+}
+
+impl Error for ReadOneSuperError {}
+
+impl fmt::Display for ReadOneSuperError {
+    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
+        match self.error {
+            ReadOneSuperErrorType::InvalidSuperBlockVersionError {
+                version,
+                min_version,
+                max_version,
+            } => {
+                write!(
+                    f,
+                    "Unsupported superblock version {:?} (min {:?}, max {:?})",
+                    version, min_version, max_version
+                )
+            }
+            ReadOneSuperErrorType::IOError => {
+                write!(f, "IO error: {}", self.return_code)
+            }
+            ReadOneSuperErrorType::NotABcachefsSuperBlockError => {
+                write!(f, "Not a bcachefs superblock")
+            }
+            ReadOneSuperErrorType::InvalidSuperBlockTooBigError {
+                bytes,
+                max_size_bits,
+            } => {
+                write!(
+                    f,
+                    "Invalid superblock: too big (got {} bytes, layout max {}))",
+                    bytes,
+                    512u64 << max_size_bits
+                )
+            }
+            ReadOneSuperErrorType::CannotReallocError => Ok(()),
+            ReadOneSuperErrorType::InvalidSuperBlockCsumType(t) => {
+                write!(f, "unknown checksum type {}", t)
+            }
+            ReadOneSuperErrorType::InvalidSuperBlockCsum => {
+                write!(f, "bad checksum",)
+            }
+        }
+    }
+}
+
+#[no_mangle]
+pub extern "C" fn read_one_super_rust(sb: &mut bch_sb_handle, offset: u64, err: *mut printbuf) -> c_int {
+    match read_one_super_result(sb, offset) {
+        Ok(_) => 0,
+        Err(e) => match e.downcast::<ReadOneSuperError>() {
+            Ok(e) => {
+                let s = CString::new(format!("{}", e)).unwrap();
+                unsafe { bch2_prt_printf(err, s.as_ptr()) };
+                e.return_code
+            }
+            Err(_) => {
+                let s = CString::new("read_one_super unknown error").unwrap();
+                unsafe { bch2_prt_printf(err, s.as_ptr()) };
+                -1
+            }
+        },
+    }
+}
+fn read_one_super_result(sb: &mut bch_sb_handle, offset: u64) -> anyhow::Result<()> {
+    let csum: bch_csum;
+    let mut version: u32;
+    let mut version_min: u32;
+    let mut bytes: size_t;
+    let mut ret: c_int;
+
+    trace!("using Rust version of read_one_super");
+
+    unsafe {
+        loop {
+            // reread:
+            bio_reset(
+                sb.bio,
+                sb.bdev,
+                (REQ_OP_READ as u32) | BLK_REQ_SYNC | BLK_REQ_META,
+            );
+            (*sb.bio).bi_iter.bi_sector = offset;
+            bch2_bio_map(sb.bio, sb.sb as *mut c_void, sb.buffer_size);
+
+            ret = submit_bio_wait(sb.bio);
+            if ret != 0 {
+                bail!(ReadOneSuperError {
+                    return_code: ret,
+                    error: ReadOneSuperErrorType::IOError
+                })
+            }
+
+            if fn_uuid_le_cmp((*sb.sb).magic, BCACHE_MAGIC)
+                && fn_uuid_le_cmp((*sb.sb).magic, BCHFS_MAGIC)
+            {
+                bail!(ReadOneSuperError {
+                    return_code: -(BCH_ERR_invalid_sb_magic as c_int),
+                    error: ReadOneSuperErrorType::NotABcachefsSuperBlockError
+                })
+            }
+
+            version = fn_le16_to_cpu((*sb.sb).version);
+            version_min = if version >= bcachefs_metadata_version_bkey_renumber as u32 {
+                fn_le16_to_cpu((*sb.sb).version_min)
+            } else {
+                version
+            };
+
+            if version >= bcachefs_metadata_version_max as u32 {
+                bail!(ReadOneSuperError {
+                    return_code: -(BCH_ERR_invalid_sb_version as c_int),
+                    error: ReadOneSuperErrorType::InvalidSuperBlockVersionError {
+                        version: version as u32,
+                        min_version: bcachefs_metadata_version_min as u32,
+                        max_version: bcachefs_metadata_version_max as u32,
+                    }
+                })
+            }
+
+            if version_min < bcachefs_metadata_version_min as u32 {
+                bail!(ReadOneSuperError {
+                    return_code: -(BCH_ERR_invalid_sb_version as c_int),
+                    error: ReadOneSuperErrorType::InvalidSuperBlockVersionError {
+                        version: version,
+                        min_version: bcachefs_metadata_version_min as u32,
+                        max_version: bcachefs_metadata_version_max as u32,
+                    }
+                })
+            }
+
+            bytes = fn_vstruct_bytes(sb.sb);
+
+            if bytes > 512 << (*sb.sb).layout.sb_max_size_bits {
+                bail!(ReadOneSuperError {
+                    return_code: -(BCH_ERR_invalid_sb_too_big as c_int),
+                    error: ReadOneSuperErrorType::InvalidSuperBlockTooBigError {
+                        bytes: bytes,
+                        max_size_bits: (*sb.sb).layout.sb_max_size_bits
+                    }
+                })
+            }
+
+            if bytes > sb.buffer_size {
+                ret = bch2_sb_realloc(
+                    sb as *mut _ as *mut bch_sb_handle,
+                    fn_le32_to_cpu((*sb.sb).u64s),
+                );
+                if ret != 0 {
+                    bail!(ReadOneSuperError {
+                        return_code: ret,
+                        error: ReadOneSuperErrorType::CannotReallocError
+                    })
+                }
+            // goto reread;
+            } else {
+                break;
+            }
+        }
+
+        if fn_BCH_SB_CSUM_TYPE(sb.sb) >= BCH_CSUM_NR as u64 {
+            bail!(ReadOneSuperError {
+                return_code: -(BCH_ERR_invalid_sb_csum_type as c_int),
+                error: ReadOneSuperErrorType::InvalidSuperBlockCsumType(fn_BCH_SB_CSUM_TYPE(sb.sb))
+            })
+        }
+
+        /* XXX: verify MACs */
+        csum = fn_csum_from_sb(sb.sb);
+
+        if bch2_crc_cmp(csum, (*sb.sb).csum) {
+            // prt_printf(err, "bad checksum");
+            bail!(ReadOneSuperError {
+                return_code: -(BCH_ERR_invalid_sb_csum as c_int),
+                error: ReadOneSuperErrorType::InvalidSuperBlockCsum
+            })
+        }
+
+        sb.seq = fn_le64_to_cpu((*sb.sb).seq);
+    }
+
+    return Ok(());
+}
-- 
2.33.1

