Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7085C7618E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 19:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjDZTum (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 15:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjDZTuk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 15:50:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244AF1731
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 12:50:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-24b3451b2fcso5471792a91.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682538638; x=1685130638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RoJyazszzdTDHEt7lRbUhf6PNouquHfcT6j5xN08C1w=;
        b=JeMci4CUT/ZIf1lb01Dr4PEiZO6oJwDQcec5VP464Sq2BriZmyDEs0xmBbGBilgEn3
         HIlaEMQ518M6aydsSWGH1BwbmRHvLmuVDjZdqPaVMmyJHaQqJqPqskrq7yH8YtH1KDd8
         Z2vUDY6fWbfTsPwoKpkRS9RI7nmo1rHJqJyBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538638; x=1685130638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RoJyazszzdTDHEt7lRbUhf6PNouquHfcT6j5xN08C1w=;
        b=SlFD9QkUkbc28F17A5kQRnzbsRXlIyPGNLBroLR8zSVbOlYLyFdJDhY0vdp5iRuwTG
         0y7AbS2TbnCpD5lX1lPQZp23pnRB+C/4XQi4iqwrNcKKtJu22j85vozG+4n9X20uSc6M
         LWgdao5YftypRzeRKsJJOgsNlfTac2j4r2+6jUOlOyxXsxZecnYKY3IbPDZQFqtpZNcr
         DFbqoNd1LJRO8mtfQ2/ljXbbXHI2nI7V2MTIKpFHWpG5UebpMt5/TlUVaRVWVmUZpy+e
         fUomWR6fCXkAjI4+cON1M7SSnc9yuit0att6UWQlx1RA1qrKzDngjym7+ofmUbdEDWOK
         SzRw==
X-Gm-Message-State: AAQBX9cFQPaOZsSQI3F4SOy4+AOzdGag5qgV8G4Io3XWuPmNqx7DzS2B
        Hq06zLIhDerCwlWQzAnE2F3gCZKovOrFwXGQHK6bdw==
X-Google-Smtp-Source: AKy350YqNmzQIetDX4aBWk7J+Rw25cejFeUyDhVsXmYHpq43WfCV0lTjD/FgQeM//XvrHgbmSD7C8Q==
X-Received: by 2002:a17:90b:2289:b0:246:97d2:dc0d with SMTP id kx9-20020a17090b228900b0024697d2dc0dmr21517606pjb.39.1682538638116;
        Wed, 26 Apr 2023 12:50:38 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:6450:e55b:77e8:267b])
        by smtp.gmail.com with ESMTPSA id gg8-20020a17090b0a0800b002466e601ab8sm12041852pjb.3.2023.04.26.12.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 12:50:37 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] chore: logger for idiomatic style and expanded logging levels
Date:   Wed, 26 Apr 2023 12:50:16 -0700
Message-Id: <20230426195016.27561-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Improve the Rust logger by adhering to idiomatic Rust conventions and
incorporating additional logging levels: warn, debug, and trace.

Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
---
 rust-src/Cargo.toml             |  2 +-
 rust-src/bch_bindgen/src/lib.rs |  1 -
 rust-src/bch_bindgen/src/log.rs | 57 ---------------------------------
 rust-src/src/cmd_list.rs        |  3 +-
 rust-src/src/cmd_mount.rs       | 19 +++++++++--
 rust-src/src/key.rs             |  3 +-
 rust-src/src/lib.rs             |  1 +
 rust-src/src/logger.rs          | 28 ++++++++++++++++
 8 files changed, 48 insertions(+), 66 deletions(-)
 delete mode 100644 rust-src/bch_bindgen/src/log.rs
 create mode 100644 rust-src/src/logger.rs

diff --git a/rust-src/Cargo.toml b/rust-src/Cargo.toml
index 64b195c..92a3853 100644
--- a/rust-src/Cargo.toml
+++ b/rust-src/Cargo.toml
@@ -9,7 +9,7 @@ crate-type = ["staticlib"]
 
 [dependencies]
 atty = "0.2.14"
-log = "0.4"
+log = { version = "0.4", features = ["std"] }
 chrono = "0.4"
 colored = "2"
 clap = { version = "4.0.32", features = ["derive", "wrap_help"] }
diff --git a/rust-src/bch_bindgen/src/lib.rs b/rust-src/bch_bindgen/src/lib.rs
index 86592c6..73aeef6 100644
--- a/rust-src/bch_bindgen/src/lib.rs
+++ b/rust-src/bch_bindgen/src/lib.rs
@@ -3,7 +3,6 @@ pub mod btree;
 pub mod bkey;
 pub mod errcode;
 pub mod keyutils;
-pub mod log;
 pub mod rs;
 pub mod fs;
 pub mod opts;
diff --git a/rust-src/bch_bindgen/src/log.rs b/rust-src/bch_bindgen/src/log.rs
deleted file mode 100644
index 32927f1..0000000
--- a/rust-src/bch_bindgen/src/log.rs
+++ /dev/null
@@ -1,57 +0,0 @@
-use std::sync::atomic::{AtomicU8, Ordering};
-
-pub const MUTE: u8 = 0;
-pub const ERROR: u8 = 1;
-pub const INFO: u8 = 2;
-pub const DEBUG: u8 = 3;
-
-// error level by default
-pub static VERBOSE: AtomicU8 = AtomicU8::new(ERROR);
-
-#[inline]
-pub fn set_verbose_level(level: u8) {
-    VERBOSE.store(level, Ordering::SeqCst);
-}
-
-pub fn max_level() -> u8 {
-    VERBOSE.load(Ordering::SeqCst)
-}
-
-#[macro_export]
-macro_rules! info {
-    ($($arg:tt)*) => {
-        if 2 <= $crate::log::max_level() {
-            println!("{} {} {}",
-                " INFO".green(),
-                format!("{}:", module_path!()).bright_black(),
-                format_args!($($arg)*)
-            );
-        }
-    }
-}
-
-#[macro_export]
-macro_rules! debug {
-    ($($arg:tt)*) => {
-        if 3 <= $crate::log::max_level() {
-            println!("{} {} {}",
-                "DEBUG".bright_blue(),
-                format!("{}:", module_path!()).bright_black(),
-                format_args!($($arg)*)
-            );
-        }
-    }
-}
-
-#[macro_export]
-macro_rules! error {
-    ($($arg:tt)*) => {
-        if 1 <= $crate::log::max_level() {
-            println!("{} {} {}",
-                "ERROR".bright_red(),
-                format!("{}:", module_path!()).bright_black(),
-                format_args!($($arg)*)
-            );
-        }
-    }
-}
diff --git a/rust-src/src/cmd_list.rs b/rust-src/src/cmd_list.rs
index f04efa2..2dc8d71 100644
--- a/rust-src/src/cmd_list.rs
+++ b/rust-src/src/cmd_list.rs
@@ -1,5 +1,5 @@
 use atty::Stream;
-use bch_bindgen::error;
+use log::{error};
 use bch_bindgen::bcachefs;
 use bch_bindgen::opt_set;
 use bch_bindgen::fs::Fs;
@@ -9,7 +9,6 @@ use bch_bindgen::btree::BtreeIter;
 use bch_bindgen::btree::BtreeNodeIter;
 use bch_bindgen::btree::BtreeIterFlags;
 use clap::Parser;
-use colored::Colorize;
 use std::ffi::{CStr, OsStr, c_int, c_char};
 use std::os::unix::ffi::OsStrExt;
 
diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index 1251d0d..af370ef 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -1,11 +1,13 @@
 use atty::Stream;
-use bch_bindgen::{bcachefs, bcachefs::bch_sb_handle, debug, error, info};
+use bch_bindgen::{bcachefs, bcachefs::bch_sb_handle};
+use log::{info, warn, debug, error, trace, LevelFilter};
 use clap::Parser;
-use colored::Colorize;
 use uuid::Uuid;
+use std::convert::TryInto;
 use std::path::PathBuf;
 use crate::key;
 use crate::key::KeyLoc;
+use crate::logger::SimpleLogger;
 use std::ffi::{CStr, CString, OsStr, c_int, c_char, c_void};
 use std::os::unix::ffi::OsStrExt;
 
@@ -202,9 +204,20 @@ pub extern "C" fn cmd_mount(argc: c_int, argv: *const *const c_char) {
         .collect();
 
     let opt = Cli::parse_from(argv);
-    bch_bindgen::log::set_verbose_level(opt.verbose + bch_bindgen::log::ERROR);
+    
+    log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
+
+    // @TODO : more granular log levels via mount option
+    log::set_max_level(match opt.verbose {
+        0 => LevelFilter::Warn,
+        1 => LevelFilter::Trace,
+        2_u8..=u8::MAX => todo!(),
+    });
+
     colored::control::set_override(opt.colorize);
     if let Err(e) = cmd_mount_inner(opt) {
         error!("Fatal error: {}", e);
+    } else {
+        info!("Successfully mounted");
     }
 }
diff --git a/rust-src/src/key.rs b/rust-src/src/key.rs
index abea584..2af34b1 100644
--- a/rust-src/src/key.rs
+++ b/rust-src/src/key.rs
@@ -1,6 +1,5 @@
-use bch_bindgen::info;
+use log::{info};
 use bch_bindgen::bcachefs::bch_sb_handle;
-use colored::Colorize;
 use crate::c_str;
 use anyhow::anyhow;
 
diff --git a/rust-src/src/lib.rs b/rust-src/src/lib.rs
index a33e391..159d049 100644
--- a/rust-src/src/lib.rs
+++ b/rust-src/src/lib.rs
@@ -1,4 +1,5 @@
 pub mod key;
+pub mod logger;
 pub mod cmd_mount;
 pub mod cmd_list;
 
diff --git a/rust-src/src/logger.rs b/rust-src/src/logger.rs
new file mode 100644
index 0000000..2cd7b36
--- /dev/null
+++ b/rust-src/src/logger.rs
@@ -0,0 +1,28 @@
+use colored::Colorize;
+use log::{Level, Metadata, Record};
+
+pub struct SimpleLogger;
+
+impl log::Log for SimpleLogger {
+    fn enabled(&self, _: &Metadata) -> bool {
+        true
+    }
+
+    fn log(&self, record: &Record) {
+        let debug_prefix = match record.level() {
+            Level::Error => "ERROR".bright_red(),
+            Level::Warn => "WARN".bright_yellow(),
+            Level::Info => "INFO".green(),
+            Level::Debug => "DEBUG".bright_blue(),
+            Level::Trace => "TRACE".into(),
+        };
+        println!(
+            "{} - {}: {}",
+            debug_prefix,
+            record.module_path().unwrap_or_default().bright_black(),
+            record.args()
+        );
+    }
+
+    fn flush(&self) {}
+}
-- 
2.33.1

