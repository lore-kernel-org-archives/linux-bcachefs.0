Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABD910A05
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDVREaFA"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bed9f5d35dso242060139f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 22:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705387300; x=1705992100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eko8Wlx1XQK1Pbwi6a+bI+viS2tScsJergxyAITrlus=;
        b=UDVREaFAlE4F20LN1/KTYTeMyJFjVELMvaw3ennmL6NNz8X58CuVViSSexX7zauoYA
         5tqbTb7jzLgr3JoHUZ8WskTd125NAAs3zXf5QBmekPaWA1iTF5wOPtpv6V+XOpG8y5Vc
         ZZx4aAjJazkXsoym1UfFIIWXV44SyhALYQEsVFDsvL2PkH6/STHmqiS+ID6FtKk/xPz7
         rfwsQHxqWefA3n2urNy63d9uvoCRse4iJUFC3JaSMUSVN4FFvLwKA6pPCs6UmP0wjf1I
         B37ANTmQTQsZ6193EX1emgR6ugoufuJM4R/TytSKEHITXyDkDPkuWxGEZsU1PPHEUYk/
         i1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705387300; x=1705992100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eko8Wlx1XQK1Pbwi6a+bI+viS2tScsJergxyAITrlus=;
        b=UkI2UkEBjT8iSr56HIggeBBBcmF1IrZFX9vsIt40w3FsgrV08109WNnJTS9O9Sg1v3
         ViwaeX2Glc9as6mOsSS83DAPv2J6CP5PTzl9mGXQO9pyFbg9q16YJB0MEv+dPkPdfdHz
         zaDHOzSirWsATx9gzGMFYvwozFx81DHbzeLk5lDf+sgCoIDwe9Dq07dgxMKIlQTY6prr
         yMrK+CHNO4eIHnAdzNweQd1xp1fC0aiXZdpipJ+6VbfUxRYQjdx4q7sVu+ySlikTn4+Z
         flWB/euNCWSm+0lK8kwoRwfPiByZdrZ5qqe3+ppy1T/aURVhmpT/VyDHzY/RdbY2FHD0
         gBBQ==
X-Gm-Message-State: AOJu0Yzx1QwRk5M/xGsyDv0ycnm1zX5afoh6JqNGqjzpmdzwe/i7ETSd
	Uj7u6ncVikYsgmL7YycXcgo=
X-Google-Smtp-Source: AGHT+IFhHXr5xqAJWt5AT23Su9/lvwaxHrP1FxB4p2IA33BaTop8jiXuGhc31gvc3dnIq0wUjXLiLQ==
X-Received: by 2002:a05:6602:2776:b0:7bb:f2d0:10b4 with SMTP id l22-20020a056602277600b007bbf2d010b4mr6656966ioe.34.1705387299748;
        Mon, 15 Jan 2024 22:41:39 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id t24-20020a6bdb18000000b007bf3d8f13c6sm1124309ioc.6.2024.01.15.22.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 22:41:39 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 1/3] convert main() from C to Rust
Date: Mon, 15 Jan 2024 23:41:00 -0700
Message-ID: <20240116064102.193643-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240116064102.193643-1-tahbertschinger@gmail.com>
References: <20240116064102.193643-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This moves the main() function from C to Rust. It also updates the name
of the Rust package from "bcachefs-rust" to "bcachefs-tools".

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
V2: update GitHub workflow to account for new rust package name

 .github/workflows/build-packages.yml          |   2 +-
 Makefile                                      |  21 +--
 bcachefs.c                                    | 127 +-----------------
 cmds.h                                        |   6 +-
 rust-src/Cargo.lock                           |   2 +-
 rust-src/Cargo.toml                           |   8 +-
 rust-src/bch_bindgen/build.rs                 |   6 +
 .../bch_bindgen/src/libbcachefs_wrapper.h     |   2 +
 rust-src/build.rs                             |  21 +++
 rust-src/src/bcachefs.rs                      | 107 +++++++++++++++
 rust-src/src/cmd_completions.rs               |   3 +-
 rust-src/src/cmd_list.rs                      |   3 +-
 rust-src/src/cmd_main.rs                      |  34 -----
 rust-src/src/cmd_mount.rs                     |  11 +-
 rust-src/src/lib.rs                           |  13 --
 tests/util.py                                 |   2 +-
 16 files changed, 173 insertions(+), 195 deletions(-)
 create mode 100644 rust-src/build.rs
 create mode 100644 rust-src/src/bcachefs.rs
 delete mode 100644 rust-src/src/cmd_main.rs

diff --git a/.github/workflows/build-packages.yml b/.github/workflows/build-packages.yml
index ff8044a..08a6827 100644
--- a/.github/workflows/build-packages.yml
+++ b/.github/workflows/build-packages.yml
@@ -79,7 +79,7 @@ jobs:
       - name: Extract MSRV
         run: |
           MSRV=$(cargo metadata --format-version 1 --no-deps --manifest-path rust-src/Cargo.toml |
-                  jq -r '.packages[] | select(.name == "bcachefs-rust") | .rust_version')
+                  jq -r '.packages[] | select(.name == "bcachefs-tools") | .rust_version')
           echo "MSRV=$MSRV" >> $GITHUB_ENV
       - name: Install Rust ${{ env.MSRV }} toolchain
         run: |
diff --git a/Makefile b/Makefile
index a38f074..d283c7b 100644
--- a/Makefile
+++ b/Makefile
@@ -77,6 +77,7 @@ PKGCONFIG_LIBS="blkid uuid liburcu libsodium zlib liblz4 libzstd libudev libkeyu
 ifdef BCACHEFS_FUSE
 	PKGCONFIG_LIBS+="fuse3 >= 3.7"
 	CFLAGS+=-DBCACHEFS_FUSE
+	export RUSTFLAGS=--cfg fuse
 endif
 
 PKGCONFIG_CFLAGS:=$(shell $(PKG_CONFIG) --cflags $(PKGCONFIG_LIBS))
@@ -172,25 +173,15 @@ OBJS:=$(SRCS:.c=.o)
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
 
 BCACHEFS_DEPS=libbcachefs.a
+RUST_SRCS:=$(shell find rust-src/src rust-src/bch_bindgen/src -type f -iname '*.rs')
 
-ifndef NO_RUST
-	BCACHEFS_DEPS+=rust-src/target/release/libbcachefs_rust.a
-else
-	CFLAGS+=-DBCACHEFS_NO_RUST
-endif
-
-bcachefs: $(BCACHEFS_DEPS)
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(LDFLAGS) -Wl,--whole-archive $+ $(LOADLIBES) -Wl,--no-whole-archive $(LDLIBS) -o $@
+bcachefs: $(BCACHEFS_DEPS) $(RUST_SRCS)
+	$(CARGO_BUILD)
 
 libbcachefs.a: $(filter-out ./tests/%.o, $(OBJS))
 	@echo "    [AR]     $@"
 	$(Q)ar -rc $@ $+
 
-RUST_SRCS:=$(shell find rust-src/src rust-src/bch_bindgen/src -type f -iname '*.rs')
-rust-src/target/release/libbcachefs_rust.a: $(RUST_SRCS)
-	$(CARGO_BUILD)
-
 tests/test_helper: $(filter ./tests/%.o, $(OBJS))
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(LDFLAGS) $+ $(LOADLIBES) $(LDLIBS) -o $@
@@ -210,7 +201,7 @@ cmd_version.o : .version
 install: INITRAMFS_HOOK=$(INITRAMFS_DIR)/hooks/bcachefs
 install: INITRAMFS_SCRIPT=$(INITRAMFS_DIR)/scripts/local-premount/bcachefs
 install: bcachefs $(optional_install)
-	$(INSTALL) -m0755 -D bcachefs      -t $(DESTDIR)$(ROOT_SBINDIR)
+	$(INSTALL) -m0755 -D rust-src/target/release/bcachefs -t $(DESTDIR)$(ROOT_SBINDIR)
 	$(INSTALL) -m0644 -D bcachefs.8    -t $(DESTDIR)$(PREFIX)/share/man/man8/
 	$(INSTALL) -m0755 -D initramfs/script $(DESTDIR)$(INITRAMFS_SCRIPT)
 	$(INSTALL) -m0755 -D initramfs/hook   $(DESTDIR)$(INITRAMFS_HOOK)
@@ -233,7 +224,7 @@ install_systemd: $(systemd_services) $(systemd_libexecfiles)
 .PHONY: clean
 clean:
 	@echo "Cleaning all"
-	$(Q)$(RM) bcachefs libbcachefs.a tests/test_helper .version *.tar.xz $(OBJS) $(DEPS) $(DOCGENERATED)
+	$(Q)$(RM) libbcachefs.a tests/test_helper .version *.tar.xz $(OBJS) $(DEPS) $(DOCGENERATED)
 	$(Q)$(CARGO_CLEAN)
 	$(Q)$(RM) -f $(built_scripts)
 
diff --git a/bcachefs.c b/bcachefs.c
index 7ca79ad..70af2c3 100644
--- a/bcachefs.c
+++ b/bcachefs.c
@@ -25,7 +25,7 @@
 
 #include "cmds.h"
 
-static void usage(void)
+void bcachefs_usage(void)
 {
 	puts("bcachefs - tool for managing bcachefs filesystems\n"
 	     "usage: bcachefs <command> [<args>]\n"
@@ -36,11 +36,9 @@ static void usage(void)
 	     "  set-option               Set a filesystem option\n"
 	     "  reset-counters           Reset all counters on an unmounted device\n"
 	     "\n"
-#ifndef BCACHEFS_NO_RUST
 	     "Mount:\n"
 	     "  mount                    Mount a filesystem\n"
 	     "\n"
-#endif
 	     "Repair:\n"
 	     "  fsck                     Check an existing filesystem for errors\n"
 	     "\n"
@@ -89,18 +87,14 @@ static void usage(void)
 	     "Debug:\n"
 	     "These commands work on offline, unmounted filesystems\n"
 	     "  dump                     Dump filesystem metadata to a qcow2 image\n"
-#ifndef BCACHEFS_NO_RUST
 	     "  list                     List filesystem metadata in textual form\n"
-#endif
 	     "  list_journal             List contents of journal\n"
 	     "\n"
 	     "FUSE:\n"
 	     "  fusemount                Mount a filesystem via FUSE\n"
 	     "\n"
 	     "Miscellaneous:\n"
-#ifndef BCACHEFS_NO_RUST
          "  completions              Generate shell completions\n"
-#endif
 	     "  version                  Display the version of the invoked bcachefs tool\n");
 }
 
@@ -115,12 +109,12 @@ static char *pop_cmd(int *argc, char *argv[])
 	return cmd;
 }
 
-static int fs_cmds(int argc, char *argv[])
+int fs_cmds(int argc, char *argv[])
 {
 	char *cmd = pop_cmd(&argc, argv);
 
 	if (argc < 1) {
-		usage();
+		bcachefs_usage();
 		exit(EXIT_FAILURE);
 	}
 	if (!strcmp(cmd, "usage"))
@@ -129,7 +123,7 @@ static int fs_cmds(int argc, char *argv[])
 	return 0;
 }
 
-static int device_cmds(int argc, char *argv[])
+int device_cmds(int argc, char *argv[])
 {
 	char *cmd = pop_cmd(&argc, argv);
 
@@ -155,7 +149,7 @@ static int device_cmds(int argc, char *argv[])
 	return 0;
 }
 
-static int data_cmds(int argc, char *argv[])
+int data_cmds(int argc, char *argv[])
 {
 	char *cmd = pop_cmd(&argc, argv);
 
@@ -169,7 +163,7 @@ static int data_cmds(int argc, char *argv[])
 	return 0;
 }
 
-static int subvolume_cmds(int argc, char *argv[])
+int subvolume_cmds(int argc, char *argv[])
 {
 	char *cmd = pop_cmd(&argc, argv);
 	if (argc < 1)
@@ -183,112 +177,3 @@ static int subvolume_cmds(int argc, char *argv[])
 
 	return 0;
 }
-
-int main(int argc, char *argv[])
-{
-	raid_init();
-
-	char *full_cmd = argv[0];
-
-	/* Are we being called via a symlink? */
-
-	if (strstr(full_cmd, "mkfs"))
-		return cmd_format(argc, argv);
-
-	if (strstr(full_cmd, "fsck"))
-		return cmd_fsck(argc, argv);
-
-#ifdef BCACHEFS_FUSE
-	if (strstr(full_cmd, "mount.fuse"))
-		return cmd_fusemount(argc, argv);
-#endif
-
-#ifndef BCACHEFS_NO_RUST
-	if (strstr(full_cmd, "mount"))
-		return rust_main(argc, argv, "mount");
-#endif
-
-	setvbuf(stdout, NULL, _IOLBF, 0);
-
-	char *cmd = pop_cmd(&argc, argv);
-	if (!cmd) {
-		puts("missing command\n");
-		goto usage;
-	}
-
-	/* these subcommands display usage when argc < 2 */
-	if (!strcmp(cmd, "device"))
-		return device_cmds(argc, argv);
-	if (!strcmp(cmd, "fs"))
-		return fs_cmds(argc, argv);
-	if (!strcmp(cmd, "data"))
-		return data_cmds(argc, argv);
-	if (!strcmp(cmd, "subvolume"))
-		return subvolume_cmds(argc, argv);
-	if (!strcmp(cmd, "format"))
-		return cmd_format(argc, argv);
-	if (!strcmp(cmd, "fsck"))
-		return cmd_fsck(argc, argv);
-	if (!strcmp(cmd, "version"))
-		return cmd_version(argc, argv);
-	if (!strcmp(cmd, "show-super"))
-		return cmd_show_super(argc, argv);
-	if (!strcmp(cmd, "set-option"))
-		return cmd_set_option(argc, argv);
-	if (!strcmp(cmd, "reset-counters"))
-		return cmd_reset_counters(argc, argv);
-
-#if 0
-	if (!strcmp(cmd, "assemble"))
-		return cmd_assemble(argc, argv);
-	if (!strcmp(cmd, "incremental"))
-		return cmd_incremental(argc, argv);
-	if (!strcmp(cmd, "run"))
-		return cmd_run(argc, argv);
-	if (!strcmp(cmd, "stop"))
-		return cmd_stop(argc, argv);
-#endif
-
-	if (!strcmp(cmd, "unlock"))
-		return cmd_unlock(argc, argv);
-	if (!strcmp(cmd, "set-passphrase"))
-		return cmd_set_passphrase(argc, argv);
-	if (!strcmp(cmd, "remove-passphrase"))
-		return cmd_remove_passphrase(argc, argv);
-
-	if (!strcmp(cmd, "migrate"))
-		return cmd_migrate(argc, argv);
-	if (!strcmp(cmd, "migrate-superblock"))
-		return cmd_migrate_superblock(argc, argv);
-
-	if (!strcmp(cmd, "dump"))
-		return cmd_dump(argc, argv);
-	if (!strcmp(cmd, "list_journal"))
-		return cmd_list_journal(argc, argv);
-	if (!strcmp(cmd, "kill_btree_node"))
-		return cmd_kill_btree_node(argc, argv);
-
-	if (!strcmp(cmd, "setattr"))
-		return cmd_setattr(argc, argv);
-#ifndef BCACHEFS_NO_RUST
-	if (!strcmp(cmd, "list") ||
-	    !strcmp(cmd, "mount") ||
-	    !strcmp(cmd, "completions"))
-		return rust_main(argc, argv, cmd);
-#endif
-
-#ifdef BCACHEFS_FUSE
-	if (!strcmp(cmd, "fusemount"))
-		return cmd_fusemount(argc, argv);
-#endif
-
-	if (!strcmp(cmd, "--help")) {
-		usage();
-		return 0;
-	}
-
-	printf("Unknown command %s\n", cmd);
-usage:
-	usage();
-	exit(EXIT_FAILURE);
-}
diff --git a/cmds.h b/cmds.h
index 88b03f3..64267dc 100644
--- a/cmds.h
+++ b/cmds.h
@@ -54,6 +54,10 @@ int cmd_subvolume_snapshot(int argc, char *argv[]);
 
 int cmd_fusemount(int argc, char *argv[]);
 
-int rust_main(int argc, char *argv[], char *cmd);
+void bcachefs_usage(void);
+int device_cmds(int argc, char *argv[]);
+int fs_cmds(int argc, char *argv[]);
+int data_cmds(int argc, char *argv[]);
+int subvolume_cmds(int argc, char *argv[]);
 
 #endif /* _CMDS_H */
diff --git a/rust-src/Cargo.lock b/rust-src/Cargo.lock
index 2fb6871..3e7eea9 100644
--- a/rust-src/Cargo.lock
+++ b/rust-src/Cargo.lock
@@ -84,7 +84,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"
 
 [[package]]
-name = "bcachefs-rust"
+name = "bcachefs-tools"
 version = "0.3.1"
 dependencies = [
  "anyhow",
diff --git a/rust-src/Cargo.toml b/rust-src/Cargo.toml
index 061d064..2786fc7 100644
--- a/rust-src/Cargo.toml
+++ b/rust-src/Cargo.toml
@@ -1,12 +1,16 @@
 [package]
-name = "bcachefs-rust"
+name = "bcachefs-tools"
 version = "0.3.1"
 authors = ["Yuxuan Shui <yshuiv7@gmail.com>", "Kayla Firestack <dev@kaylafire.me>", "Kent Overstreet <kent.overstreet@linux.dev>" ]
 edition = "2021"
 rust-version = "1.65"
 
+[[bin]]
+name = "bcachefs"
+path = "src/bcachefs.rs"
+
 [lib]
-crate-type = ["staticlib"]
+name = "bcachefs"
 
 [dependencies]
 atty = "0.2.14"
diff --git a/rust-src/bch_bindgen/build.rs b/rust-src/bch_bindgen/build.rs
index 79337a0..d9805a8 100644
--- a/rust-src/bch_bindgen/build.rs
+++ b/rust-src/bch_bindgen/build.rs
@@ -10,6 +10,8 @@ impl bindgen::callbacks::ParseCallbacks for Fix753 {
 fn main() {
     use std::path::PathBuf;
 
+    println!("cargo:rerun-if-changed=src/libbcachefs_wrapper.h");
+
     let out_dir: PathBuf = std::env::var_os("OUT_DIR")
         .expect("ENV Var 'OUT_DIR' Expected")
         .into();
@@ -44,6 +46,10 @@ fn main() {
         .default_enum_style(bindgen::EnumVariation::Rust {
             non_exhaustive: true,
         })
+        .allowlist_function("bcachefs_usage")
+        .allowlist_function("raid_init")
+        .allowlist_function("cmd_.*")
+        .allowlist_function(".*_cmds")
         .allowlist_function(".*bch2_.*")
         .allowlist_function("bio_.*")
         .allowlist_function("derive_passphrase")
diff --git a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
index e68de66..5fb4261 100644
--- a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
+++ b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
@@ -11,6 +11,8 @@
 #include "../crypto.h"
 #include "../include/linux/bio.h"
 #include "../include/linux/blkdev.h"
+#include "../cmds.h"
+#include "../raid/raid.h"
 
 
 #define MARK_FIX_753(req_name) const blk_mode_t Fix753_##req_name = req_name;
diff --git a/rust-src/build.rs b/rust-src/build.rs
new file mode 100644
index 0000000..e4662bd
--- /dev/null
+++ b/rust-src/build.rs
@@ -0,0 +1,21 @@
+fn main() {
+    println!("cargo:rustc-link-search=..");
+    println!("cargo:rerun-if-changed=../libbcachefs.a");
+    println!("cargo:rustc-link-lib=static:+whole-archive=bcachefs");
+
+    println!("cargo:rustc-link-lib=urcu");
+    println!("cargo:rustc-link-lib=zstd");
+    println!("cargo:rustc-link-lib=blkid");
+    println!("cargo:rustc-link-lib=uuid");
+    println!("cargo:rustc-link-lib=sodium");
+    println!("cargo:rustc-link-lib=z");
+    println!("cargo:rustc-link-lib=lz4");
+    println!("cargo:rustc-link-lib=zstd");
+    println!("cargo:rustc-link-lib=udev");
+    println!("cargo:rustc-link-lib=keyutils");
+    println!("cargo:rustc-link-lib=aio");
+
+    if std::env::var("BCACHEFS_FUSE").is_ok() {
+        println!("cargo:rustc-link-lib=fuse3");
+    }
+}
diff --git a/rust-src/src/bcachefs.rs b/rust-src/src/bcachefs.rs
new file mode 100644
index 0000000..3d7af3d
--- /dev/null
+++ b/rust-src/src/bcachefs.rs
@@ -0,0 +1,107 @@
+use std::ffi::CString;
+
+use bcachefs::cmd_completions::cmd_completions;
+use bcachefs::cmd_list::cmd_list;
+use bcachefs::cmd_mount::cmd_mount;
+use bcachefs::logger::SimpleLogger;
+use bch_bindgen::c;
+
+fn handle_c_command(args: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
+    let mut argv: Vec<_> = args.clone();
+
+    let cmd = match symlink_cmd {
+        Some(s) => s.to_string(),
+        None => argv.remove(1),
+    };
+
+    let argc: i32 = argv.len().try_into().unwrap();
+
+    let argv: Vec<_> = argv
+        .iter()
+        .map(|s| CString::new(s.as_str()).unwrap())
+        .collect();
+    let argv: Vec<_> = argv.iter().map(|s| s.as_ptr()).collect();
+    let argv = argv.as_ptr() as *mut *mut i8;
+
+    // The C functions will mutate argv. It shouldn't be used after this block.
+    unsafe {
+        match cmd.as_str() {
+            "--help" => {
+                c::bcachefs_usage();
+                0
+            },
+            "data" => c::data_cmds(argc, argv),
+            "device" => c::device_cmds(argc, argv),
+            "dump" => c::cmd_dump(argc, argv),
+            "format" => c::cmd_format(argc, argv),
+            "fs" => c::fs_cmds(argc, argv),
+            "fsck" => c::cmd_fsck(argc, argv),
+            "list_journal" => c::cmd_list_journal(argc, argv),
+            "kill_btree_node" => c::cmd_kill_btree_node(argc, argv),
+            "migrate" => c::cmd_migrate(argc, argv),
+            "migrate-superblock" => c::cmd_migrate_superblock(argc, argv),
+            "mkfs" => c::cmd_format(argc, argv),
+            "remove-passphrase" => c::cmd_remove_passphrase(argc, argv),
+            "reset-counters" => c::cmd_reset_counters(argc, argv),
+            "set-option" => c::cmd_set_option(argc, argv),
+            "set-passphrase" => c::cmd_set_passphrase(argc, argv),
+            "setattr" => c::cmd_setattr(argc, argv),
+            "show-super" => c::cmd_show_super(argc, argv),
+            "subvolume" => c::subvolume_cmds(argc, argv),
+            "unlock" => c::cmd_unlock(argc, argv),
+            "version" => c::cmd_version(argc, argv),
+
+            #[cfg(fuse)]
+            "fusemount" => c::cmd_fusemount(argc, argv),
+
+            _ => {
+                println!("Unknown command {}", cmd);
+                c::bcachefs_usage();
+                1
+            }
+        }
+    }
+}
+
+fn main() {
+    let args: Vec<String> = std::env::args().collect();
+
+    let symlink_cmd: Option<&str> = if args[0].contains("mkfs") {
+        Some("mkfs")
+    } else if args[0].contains("fsck") {
+        Some("fsck")
+    } else if args[0].contains("mount.fuse") {
+        Some("fusemount")
+    } else if args[0].contains("mount") {
+        Some("mount")
+    } else {
+        None
+    };
+
+    if symlink_cmd.is_none() && args.len() < 2 {
+        println!("missing command");
+        unsafe { c::bcachefs_usage() };
+        std::process::exit(1);
+    }
+
+    unsafe { c::raid_init() };
+
+    log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
+    log::set_max_level(log::LevelFilter::Warn);
+
+    let cmd = match symlink_cmd {
+        Some(s) => s,
+        None => args[1].as_str(),
+    };
+
+    let ret = match cmd {
+        "completions" => cmd_completions(args[1..].to_vec()),
+        "list" => cmd_list(args[1..].to_vec()),
+        "mount" => cmd_mount(args, symlink_cmd),
+        _ => handle_c_command(args, symlink_cmd),
+    };
+
+    if ret != 0 {
+        std::process::exit(1);
+    }
+}
diff --git a/rust-src/src/cmd_completions.rs b/rust-src/src/cmd_completions.rs
index 3e839fe..53cdd64 100644
--- a/rust-src/src/cmd_completions.rs
+++ b/rust-src/src/cmd_completions.rs
@@ -1,6 +1,5 @@
 use clap::{Command, CommandFactory, Parser};
 use clap_complete::{generate, Generator, Shell};
-use std::ffi::{c_int, OsStr};
 use std::io;
 
 /// Generate shell completions
@@ -13,7 +12,7 @@ fn print_completions<G: Generator>(gen: G, cmd: &mut Command) {
     generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
 }
 
-pub fn cmd_completions(argv: Vec<&OsStr>) -> c_int {
+pub fn cmd_completions(argv: Vec<String>) -> i32 {
     let cli = Cli::parse_from(argv);
     print_completions(cli.shell, &mut super::Cli::command());
     0
diff --git a/rust-src/src/cmd_list.rs b/rust-src/src/cmd_list.rs
index fa9c2f2..cb35291 100644
--- a/rust-src/src/cmd_list.rs
+++ b/rust-src/src/cmd_list.rs
@@ -9,7 +9,6 @@ use bch_bindgen::btree::BtreeIter;
 use bch_bindgen::btree::BtreeNodeIter;
 use bch_bindgen::btree::BtreeIterFlags;
 use clap::{Parser};
-use std::ffi::{c_int, OsStr};
 
 fn list_keys(fs: &Fs, opt: Cli) -> anyhow::Result<()> {
     let trans = BtreeTrans::new(fs);
@@ -157,7 +156,7 @@ fn cmd_list_inner(opt: Cli) -> anyhow::Result<()> {
     }
 }
 
-pub fn cmd_list(argv: Vec<&OsStr>) -> c_int {
+pub fn cmd_list(argv: Vec<String>) -> i32 {
     let opt = Cli::parse_from(argv);
     colored::control::set_override(opt.colorize);
     if let Err(e) = cmd_list_inner(opt) {
diff --git a/rust-src/src/cmd_main.rs b/rust-src/src/cmd_main.rs
deleted file mode 100644
index baedc85..0000000
--- a/rust-src/src/cmd_main.rs
+++ /dev/null
@@ -1,34 +0,0 @@
-use log::{error, LevelFilter};
-use std::ffi::{CStr, c_int, c_char};
-use crate::transform_c_args;
-use crate::logger::SimpleLogger;
-use crate::cmd_completions::cmd_completions;
-use crate::cmd_list::cmd_list;
-use crate::cmd_mount::cmd_mount;
-
-#[no_mangle]
-pub extern "C" fn rust_main(argc: c_int, argv: *const *const c_char, cmd: *const c_char) -> c_int {
-    transform_c_args!(argv, argc, argv);
-
-    log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
-    log::set_max_level(LevelFilter::Warn);
-
-    let cmd: &CStr = unsafe { CStr::from_ptr(cmd) };
-    let cmd = match cmd.to_str() {
-        Ok(c) => c,
-        Err(e) => {
-            error!("could not parse command: {}", e);
-            return 1;
-        }
-    };
-
-    match cmd {
-        "completions" => cmd_completions(argv),
-        "list" => cmd_list(argv),
-        "mount" => cmd_mount(argv),
-        _ => {
-            error!("unknown command: {}", cmd);
-            1
-        }
-    }
-}
diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index eccfe6d..b120c91 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -6,7 +6,7 @@ use uuid::Uuid;
 use std::path::PathBuf;
 use crate::key;
 use crate::key::KeyLocation;
-use std::ffi::{CString, c_int, c_char, c_void, OsStr};
+use std::ffi::{CString, c_char, c_void};
 use std::os::unix::ffi::OsStrExt;
 
 fn mount_inner(
@@ -223,7 +223,14 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     Ok(())
 }
 
-pub fn cmd_mount(argv: Vec<&OsStr>) -> c_int {
+pub fn cmd_mount(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
+    // If the bcachefs tool is being called as "bcachefs mount dev ..." (as opposed to via a
+    // symlink like "/usr/sbin/mount.bcachefs dev ...", then we need to pop the 0th argument
+    // ("bcachefs") since the CLI parser here expects the device at position 1.
+    if symlink_cmd.is_none() {
+        argv.remove(0);
+    }
+
     let opt = Cli::parse_from(argv);
 
     // @TODO : more granular log levels via mount option
diff --git a/rust-src/src/lib.rs b/rust-src/src/lib.rs
index 026cca4..f8b508d 100644
--- a/rust-src/src/lib.rs
+++ b/rust-src/src/lib.rs
@@ -2,7 +2,6 @@ use clap::Subcommand;
 
 pub mod key;
 pub mod logger;
-pub mod cmd_main;
 pub mod cmd_mount;
 pub mod cmd_list;
 pub mod cmd_completions;
@@ -32,18 +31,6 @@ macro_rules! c_str {
     };
 }
 
-#[macro_export]
-macro_rules! transform_c_args {
-    ($var:ident, $argc:expr, $argv:expr) => {
-        // TODO: `OsStr::from_bytes` only exists on *nix
-        use ::std::os::unix::ffi::OsStrExt;
-        let $var: Vec<_> = (0..$argc)
-        .map(|i| unsafe { ::std::ffi::CStr::from_ptr(*$argv.add(i as usize)) })
-        .map(|i| ::std::ffi::OsStr::from_bytes(i.to_bytes()))
-        .collect();
-    };
-}
-
 #[derive(Debug)]
 struct ErrnoError(errno::Errno);
 impl std::fmt::Display for ErrnoError {
diff --git a/tests/util.py b/tests/util.py
index 00314f4..3ec38b2 100644
--- a/tests/util.py
+++ b/tests/util.py
@@ -11,7 +11,7 @@ import time
 from pathlib import Path
 
 BASE_PATH= os.path.dirname(__file__)
-BCH_PATH = os.path.abspath(os.path.join(BASE_PATH, '..', 'bcachefs'))
+BCH_PATH = os.path.abspath(os.path.join(BASE_PATH, '../rust-src/target/release', 'bcachefs'))
 VALGRIND_PATH= os.path.abspath(os.path.join(BASE_PATH,
     'valgrind-suppressions.txt'))
 
-- 
2.43.0

