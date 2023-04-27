Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06105C77B73
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 18:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbjD0SCO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 14:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjD0SCN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 14:02:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0A40F0
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 11:02:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24b89b9a72cso4515277a91.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 11:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682618529; x=1685210529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bfSLOPSeqv7G1iMtammBHFsScWOiu9CTUhPofnPTh3k=;
        b=coZH1TT2QIUJqiGTgO07GJx3uecgmkUr1bk4+Tfhtn9Zidy5oW65B4vMZyxI8Hu08y
         pGxEC6aY2IwQsgxwom6ilUpez0EeGuhSeTBaxkbHiP7BAudDk0ZXwhCn+JSyiXedW5wd
         /RF4blV73kZ0PRYRN1pJWqrMuDq447EKin6TQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618529; x=1685210529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfSLOPSeqv7G1iMtammBHFsScWOiu9CTUhPofnPTh3k=;
        b=TsGO1QzYj4QXdaZQWJjYMH6Q8PiRXOCNQtSgFJSsRETuI4UkKlgZrhiuuwRKdtZy2+
         y7vM9/PgzEcOiahuO7UlirUrCokiGTnDoY0/Yst16OeczgaaYDCu3bAqmBFT2NpZbkou
         SAmkUg4kBBdm7LL0J1RU6lri/6/1J4t5PBesTnK5yKYzwaaR1G2uxMMyLrrEdXFWnSiH
         86lNqtM4fTnmieh/3oRl5nxgUA2KmfApQCalwebXqb6Oy6sdq+xKrDCTSy3jpu0xstzk
         lzX3ZboRgSX+y37hmSvm9Zd4o6EfhzaRj8r3hjNSpduePDEXggUFvR3F6tm9yCU6jLl9
         LjfA==
X-Gm-Message-State: AC+VfDyjmWWISERvYyThlx/Cbc/A/QKgHpzj4JwsbeE86hhDNgmaoB2U
        h1s5s/ayyddSUejdeyF7P6YXgrGDGEqbfRN15+tbKA==
X-Google-Smtp-Source: ACHHUZ4E0HDHM4Tayokg0wLx/FVQlhQ1W0LQkN5gdPkZSL9w3KjkwvVurtPQNfXrygYDAswgMAd5Zg==
X-Received: by 2002:a17:90a:7bc2:b0:247:9422:62b4 with SMTP id d2-20020a17090a7bc200b00247942262b4mr2742941pjl.14.1682618528971;
        Thu, 27 Apr 2023 11:02:08 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:4cd:5f70:7915:d7f9])
        by smtp.gmail.com with ESMTPSA id dw3-20020a17090b094300b00233df90227fsm13492362pjb.18.2023.04.27.11.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:02:08 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] chore(rust): add opt_get! and expose some FMODE_* as Rust const
Date:   Thu, 27 Apr 2023 11:02:00 -0700
Message-Id: <20230427180200.18965-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

In an effort to rewrite `bch2_read_super` from C to Rust,
it is neccessary to have `opt_get!` macro defined, and some
FMODE_* consts (defined as macro in `include/linux/blkdev.h`)
defined as Rust const.

Bindgen is currently unable to exapnd C functional macro [1],
this this commit use the workaround as introduced in [2].

[1] https://github.com/rust-lang/rust-bindgen/issues/753
[2] https://github.com/rust-lang/rust-bindgen/issues/753#issuecomment-608546390

Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
---
 rust-src/bch_bindgen/build.rs                 | 11 +++++++
 .../bch_bindgen/src/libbcachefs_wrapper.h     |  7 +++++
 rust-src/bch_bindgen/src/opts.rs              | 30 +++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/rust-src/bch_bindgen/build.rs b/rust-src/bch_bindgen/build.rs
index f426316..92ec3ce 100644
--- a/rust-src/bch_bindgen/build.rs
+++ b/rust-src/bch_bindgen/build.rs
@@ -1,3 +1,12 @@
+
+#[derive(Debug)]
+pub struct Fix753 {}
+impl bindgen::callbacks::ParseCallbacks for Fix753 {
+    fn item_name(&self, original_item_name: &str) -> Option<String> {
+        Some(original_item_name.trim_start_matches("Fix753_").to_owned())
+    }
+}
+
 fn main() {
     use std::path::PathBuf;
 
@@ -49,6 +58,7 @@ fn main() {
         .blocklist_type("srcu_struct")
         .allowlist_var("BCH_.*")
         .allowlist_var("KEY_SPEC_.*")
+        .allowlist_var("Fix753_FMODE_.*")
         .allowlist_var("bch.*")
         .allowlist_var("__BTREE_ITER.*")
         .allowlist_var("BTREE_ITER.*")
@@ -69,6 +79,7 @@ fn main() {
         .no_partialeq("bkey")
         .no_partialeq("bpos")
         .generate_inline_functions(true)
+        .parse_callbacks(Box::new(Fix753 {}))
         .generate()
         .expect("BindGen Generation Failiure: [libbcachefs_wrapper]");
     bindings
diff --git a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
index d1ebf4b..e7bcfcf 100644
--- a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
+++ b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
@@ -10,4 +10,11 @@
 #include "../libbcachefs.h"
 #include "../crypto.h"
 #include "../include/linux/bio.h"
+#include "../include/linux/blkdev.h"
 
+
+#define MARK_FIX_753(req_name) const fmode_t Fix753_##req_name = req_name;
+
+MARK_FIX_753(FMODE_READ);
+MARK_FIX_753(FMODE_WRITE);
+MARK_FIX_753(FMODE_EXCL);
\ No newline at end of file
diff --git a/rust-src/bch_bindgen/src/opts.rs b/rust-src/bch_bindgen/src/opts.rs
index e226199..d38d469 100644
--- a/rust-src/bch_bindgen/src/opts.rs
+++ b/rust-src/bch_bindgen/src/opts.rs
@@ -3,7 +3,33 @@ macro_rules! opt_set {
     ($opts:ident, $n:ident, $v:expr) => {
         bch_bindgen::paste! {
             $opts.$n = $v;
-            $opts.[<set_ $n _defined>](1);
+            $opts.[<set_ $n _defined>](1)
         }
-    }
+    };
+}
+
+#[macro_export]
+macro_rules! opt_defined {
+    ($opts:ident, $n:ident) => {
+        bch_bindgen::paste! {
+            $opts.[< $n _defined>]()
+        }
+    };
+}
+
+#[macro_export]
+macro_rules! opt_get {
+    ($opts:ident, $n:ident) => {
+        if bch_bindgen::opt_defined!($opts, $n) == 0 {
+            bch_bindgen::paste! {
+                unsafe {
+                    bch_bindgen::bcachefs::bch2_opts_default.$n
+                }
+            }
+        } else {
+            bch_bindgen::paste! {
+                $opts.$n
+            }
+        }
+    };
 }
-- 
2.30.2

