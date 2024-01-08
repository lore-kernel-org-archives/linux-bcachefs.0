Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF7EA5
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 01:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FwQzj/ZA"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3607828cbf2so5304745ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 07 Jan 2024 17:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704677825; x=1705282625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=73L4ZO3xl3R/TvtaTTvHEnfGxcsKAZBrwEAstGKzn2I=;
        b=FwQzj/ZAga7O+TIX/GLWo6faZcs68o0KbFygIUXI7/Ihe3JiF2BkPy0qDxw7/2VVFS
         VQx+yHgtkeElthh1Ek5DYJGkOnH9KiHlYeRd7/dh5gMO9m+x55xASv5RcAjCChInmRff
         6ySRFtl2sGvmtcHC4Gp88tXcZdkpe/0RXOVA0V00OvM1G/hNC1Ke2L0sj34y7zOVjKiT
         ar9Qv1RXts/EM66MDGTnqQZ9Fx1tDap8BB9e0K138NZscjq3n8HTVFgCC7zYHuh3VS2V
         VPBLjqikFaRC2cBqWsTpz2fuTSYeS+rJvUtOCief1FWbZV7jT+MRDys2WAt1Z8yCRaM3
         gupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704677825; x=1705282625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73L4ZO3xl3R/TvtaTTvHEnfGxcsKAZBrwEAstGKzn2I=;
        b=LxKnOdIp6qh6KM7DUnA27RblN8nwVjCX8MQg5X8XlgNiFEiXEe6gderufboGM8dCXN
         GqixVDfUuxj74iYoI8rRqaWgATAQmk6/3nhcBS9OHk1KVeyOqHpOjuEc7uqlfL68vRw9
         sv0htjk3udgXN1UP0dkGDQrMdvbv42QSwJyw9Iyt7mkP7kr15kwcPOmWXTCoDOvthV3i
         hzDlqd5pSqJsdrn1NgB4D1RTGUsNcsOqyLnlvLiUEBD4GAbfXN4nmYt1tYvTtFcNPMzA
         06eyDl3qD2fikKNasXXrxKtTcIROjqk577db5ScLUgcLsvqoyyQShywOVXXnp8ocuzU4
         AFNg==
X-Gm-Message-State: AOJu0YxISIMVFDAhliJanCMh7kk9v473TKWzWpxUCHtecug8syKeNJWc
	k1ragiAKapZv7OUL800qGew=
X-Google-Smtp-Source: AGHT+IFZkh1FkjyPDI/OiwnnPncm6WbWlKmrSSfW34Gsxs6+hGYo8cw8GCtXibuuGS4auU6T6GAosw==
X-Received: by 2002:a05:6e02:20e6:b0:35f:efcb:162b with SMTP id q6-20020a056e0220e600b0035fefcb162bmr2573416ilv.16.1704677824635;
        Sun, 07 Jan 2024 17:37:04 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id ck14-20020a056e02370e00b003608a649906sm766678ilb.43.2024.01.07.17.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 17:37:04 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] create common entry point for Rust commands
Date: Sun,  7 Jan 2024 18:36:33 -0700
Message-ID: <20240108013633.119160-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bcachefs sub-commands that are implemented in Rust (completions,
list, and mount) had separate entrypoints and thus had some differences
in behavior.

This introduces a common entry point for the Rust sub-commands. This
reduces duplicate boilerplate code like parsing argv and setting up
logging, and will facilitate converting more sub-commands to Rust in
the future.

An immediate benefit is that this fixes an issue with `bcachefs list`
not reporting errors:

before:

$ bcachefs list /dev/typo
$ echo $?
0

after:

$ bcachefs list /dev/typo
ERROR - bcachefs_rust::cmd_list: Fatal error: "No such file or directory"
$ echo $?
1

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 bcachefs.c                      | 14 +++++---------
 cmds.h                          |  5 ++---
 rust-src/src/cmd_completions.rs |  8 ++------
 rust-src/src/cmd_list.rs        | 11 +++++------
 rust-src/src/cmd_main.rs        | 34 +++++++++++++++++++++++++++++++++
 rust-src/src/cmd_mount.rs       | 12 +++---------
 rust-src/src/lib.rs             |  1 +
 7 files changed, 52 insertions(+), 33 deletions(-)
 create mode 100644 rust-src/src/cmd_main.rs

diff --git a/bcachefs.c b/bcachefs.c
index e132d91..7b8d4d6 100644
--- a/bcachefs.c
+++ b/bcachefs.c
@@ -207,7 +207,7 @@ int main(int argc, char *argv[])
 
 #ifndef BCACHEFS_NO_RUST
 	if (strstr(full_cmd, "mount"))
-		return cmd_mount(argc, argv);
+		return rust_main(argc, argv, "mount");
 #endif
 
 	setvbuf(stdout, NULL, _IOLBF, 0);
@@ -265,10 +265,6 @@ int main(int argc, char *argv[])
 
 	if (!strcmp(cmd, "dump"))
 		return cmd_dump(argc, argv);
-#ifndef BCACHEFS_NO_RUST
-	if (!strcmp(cmd, "list"))
-		return cmd_list(argc, argv);
-#endif
 	if (!strcmp(cmd, "list_journal"))
 		return cmd_list_journal(argc, argv);
 	if (!strcmp(cmd, "kill_btree_node"))
@@ -277,10 +273,10 @@ int main(int argc, char *argv[])
 	if (!strcmp(cmd, "setattr"))
 		return cmd_setattr(argc, argv);
 #ifndef BCACHEFS_NO_RUST
-	if (!strcmp(cmd, "mount"))
-		return cmd_mount(argc, argv);
-    if (strstr(cmd, "completions"))
-        return cmd_completions(argc, argv);
+	if (!strcmp(cmd, "list") ||
+	    !strcmp(cmd, "mount") ||
+	    !strcmp(cmd, "completions"))
+		return rust_main(argc, argv, cmd);
 #endif
 
 #ifdef BCACHEFS_FUSE
diff --git a/cmds.h b/cmds.h
index 76a7613..88b03f3 100644
--- a/cmds.h
+++ b/cmds.h
@@ -37,7 +37,6 @@ int cmd_remove_passphrase(int argc, char *argv[]);
 int cmd_fsck(int argc, char *argv[]);
 
 int cmd_dump(int argc, char *argv[]);
-int cmd_list(int argc, char *argv[]);
 int cmd_list_journal(int argc, char *argv[]);
 int cmd_kill_btree_node(int argc, char *argv[]);
 
@@ -54,7 +53,7 @@ int cmd_subvolume_delete(int argc, char *argv[]);
 int cmd_subvolume_snapshot(int argc, char *argv[]);
 
 int cmd_fusemount(int argc, char *argv[]);
-int cmd_mount(int argc, char *argv[]);
-int cmd_completions(int argc, char *argv[]);
+
+int rust_main(int argc, char *argv[], char *cmd);
 
 #endif /* _CMDS_H */
diff --git a/rust-src/src/cmd_completions.rs b/rust-src/src/cmd_completions.rs
index 5185969..3e839fe 100644
--- a/rust-src/src/cmd_completions.rs
+++ b/rust-src/src/cmd_completions.rs
@@ -1,7 +1,6 @@
-use crate::transform_c_args;
 use clap::{Command, CommandFactory, Parser};
 use clap_complete::{generate, Generator, Shell};
-use std::ffi::{c_char, c_int};
+use std::ffi::{c_int, OsStr};
 use std::io;
 
 /// Generate shell completions
@@ -14,10 +13,7 @@ fn print_completions<G: Generator>(gen: G, cmd: &mut Command) {
     generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
 }
 
-#[no_mangle]
-#[allow(clippy::not_unsafe_ptr_arg_deref)]
-pub extern "C" fn cmd_completions(argc: c_int, argv: *const *const c_char) -> c_int {
-    transform_c_args!(argv, argc, argv);
+pub fn cmd_completions(argv: Vec<&OsStr>) -> c_int {
     let cli = Cli::parse_from(argv);
     print_completions(cli.shell, &mut super::Cli::command());
     0
diff --git a/rust-src/src/cmd_list.rs b/rust-src/src/cmd_list.rs
index 5540514..fa9c2f2 100644
--- a/rust-src/src/cmd_list.rs
+++ b/rust-src/src/cmd_list.rs
@@ -9,8 +9,7 @@ use bch_bindgen::btree::BtreeIter;
 use bch_bindgen::btree::BtreeNodeIter;
 use bch_bindgen::btree::BtreeIterFlags;
 use clap::{Parser};
-use std::ffi::{c_int, c_char};
-use crate::transform_c_args;
+use std::ffi::{c_int, OsStr};
 
 fn list_keys(fs: &Fs, opt: Cli) -> anyhow::Result<()> {
     let trans = BtreeTrans::new(fs);
@@ -158,13 +157,13 @@ fn cmd_list_inner(opt: Cli) -> anyhow::Result<()> {
     }
 }
 
-#[no_mangle]
-#[allow(clippy::not_unsafe_ptr_arg_deref)]
-pub extern "C" fn cmd_list(argc: c_int, argv: *const *const c_char) {
-    transform_c_args!(argv, argc, argv);
+pub fn cmd_list(argv: Vec<&OsStr>) -> c_int {
     let opt = Cli::parse_from(argv);
     colored::control::set_override(opt.colorize);
     if let Err(e) = cmd_list_inner(opt) {
         error!("Fatal error: {}", e);
+        1
+    } else {
+        0
     }
 }
diff --git a/rust-src/src/cmd_main.rs b/rust-src/src/cmd_main.rs
new file mode 100644
index 0000000..baedc85
--- /dev/null
+++ b/rust-src/src/cmd_main.rs
@@ -0,0 +1,34 @@
+use log::{error, LevelFilter};
+use std::ffi::{CStr, c_int, c_char};
+use crate::transform_c_args;
+use crate::logger::SimpleLogger;
+use crate::cmd_completions::cmd_completions;
+use crate::cmd_list::cmd_list;
+use crate::cmd_mount::cmd_mount;
+
+#[no_mangle]
+pub extern "C" fn rust_main(argc: c_int, argv: *const *const c_char, cmd: *const c_char) -> c_int {
+    transform_c_args!(argv, argc, argv);
+
+    log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
+    log::set_max_level(LevelFilter::Warn);
+
+    let cmd: &CStr = unsafe { CStr::from_ptr(cmd) };
+    let cmd = match cmd.to_str() {
+        Ok(c) => c,
+        Err(e) => {
+            error!("could not parse command: {}", e);
+            return 1;
+        }
+    };
+
+    match cmd {
+        "completions" => cmd_completions(argv),
+        "list" => cmd_list(argv),
+        "mount" => cmd_mount(argv),
+        _ => {
+            error!("unknown command: {}", cmd);
+            1
+        }
+    }
+}
diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index a75dd21..3f8253f 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -4,10 +4,9 @@ use log::{info, debug, error, LevelFilter};
 use clap::{Parser};
 use uuid::Uuid;
 use std::path::PathBuf;
-use crate::{key, transform_c_args};
+use crate::key;
 use crate::key::KeyLocation;
-use crate::logger::SimpleLogger;
-use std::ffi::{CString, c_int, c_char, c_void};
+use std::ffi::{CString, c_int, c_char, c_void, OsStr};
 use std::os::unix::ffi::OsStrExt;
 
 fn mount_inner(
@@ -222,14 +221,9 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     Ok(())
 }
 
-#[no_mangle]
-#[allow(clippy::not_unsafe_ptr_arg_deref)]
-pub extern "C" fn cmd_mount(argc: c_int, argv: *const *const c_char) -> c_int {
-    transform_c_args!(argv, argc, argv);
+pub fn cmd_mount(argv: Vec<&OsStr>) -> c_int {
     let opt = Cli::parse_from(argv);
 
-    log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
-
     // @TODO : more granular log levels via mount option
     log::set_max_level(match opt.verbose {
         0 => LevelFilter::Warn,
diff --git a/rust-src/src/lib.rs b/rust-src/src/lib.rs
index 64297b4..026cca4 100644
--- a/rust-src/src/lib.rs
+++ b/rust-src/src/lib.rs
@@ -2,6 +2,7 @@ use clap::Subcommand;
 
 pub mod key;
 pub mod logger;
+pub mod cmd_main;
 pub mod cmd_mount;
 pub mod cmd_list;
 pub mod cmd_completions;
-- 
2.43.0

