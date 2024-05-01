Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BF2FB2
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 May 2024 00:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714523537; cv=none; b=cYsEk4gLgE8pZ1N6MZ/FpZV2PjwWey1Zd7xEePEscSgjXPGMLAbw4uCJ9wLxFF2gHGpZjuu+A3I4Dqz6aD8briZxwkMCPMDCa4yMtSZHiiTfV4yXph3Tw70kdjJBJR7R5aPJWO1I4nbVXOrUmjqYs+sM4QrWG50T1Kl517To0tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714523537; c=relaxed/simple;
	bh=ivoCOO4LbA20ASa83OJ6YMwVduKxwHHgiyTaXOgGJg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMi7YmJAek8dJeIUMTco110sOHABxt1/mokINuMHnbBqOAmJ2AY8yl1g3GFz0VX0cQfef/nuAyOb4LQioYgze2qS4zG7ZkNvT0ZBs+gHBG80X6/OMGYIB17BHDUJ3d2RLPhw8C/mGBTfk0rRvvug4JOBw1uIwjXYufIfUNkNWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W7gVR8uV; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7gVR8uV"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7daa6bfe4c8so271671339f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 17:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714523535; x=1715128335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VqpdcMv+iiz5n7j5KO27d3o7Dl75mkEgBj8NS2TITUw=;
        b=W7gVR8uVmdPzdD5tfifoNY0Uhm39zq7aAW7ovw2vDVF6aJDG2NvHdo2T9icjLFXSmk
         UzSNi5RgknqpUWQTS9SHlpGDojh7i1HSdtH2PcsRKN00B68A6kcFzAmCYGe74mzeWoTR
         KcKXC7CIygifrKxI/TbuJ1DG3SrrkW/6I+RJMsw+wKi9Uut3p2tI/Uci+TasG7R0yomt
         9KJ8I5zBPKnBrBhRgDtnZaLqmeLxLQ/1h09H8tN2t/AknQ+sFQbETR24sc2oQNqZtlEy
         9mmqHtyphE84jY0c8MdJTAYAyUax+4IRFcCcMpvm/aGFmmGsuYyol5d41wKR4fh4TTRE
         ePKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714523535; x=1715128335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VqpdcMv+iiz5n7j5KO27d3o7Dl75mkEgBj8NS2TITUw=;
        b=wdcQNeAHdZ+GPHRp7w4uIAy+nBZEqE8znBnYQidMsIeonxy7CUhXl8imMGTbRIquwG
         tXxj6G6CSSfWk38tqUAtyrAE8TWvw6KSLuBzlM6+U02ySjyuSc15IHxWCIr7GGd7dwCy
         8QG7pWxRUSiIWu4+AuFbLXROV/gHCVRPar3IGYFjjq6Cejx1VZpbZbDYRRHLVzy6O3i+
         Hrfb8cW0Fd61ZeTaLZp0/rcXWr0I23TX/c3+udGuzYsbRwClJ1nxFgfRd5ICUBlqip13
         2493H5g4xLN0ctf0KnvB8qekSpl5HG+78/CXwxHUaLjnj+Wp6YNqD7Y1RsyBNWN6sthS
         2LQw==
X-Forwarded-Encrypted: i=1; AJvYcCXud1yoHWOCm257tXM4v87Xp1TZ7Kh6KTGh44oOOGJbBGaxocn0Vhp/vHLl5I8/6TP57IEQ1fr4Enk3b7+foXFIlD4wgO6KoqQFr/tf3t8=
X-Gm-Message-State: AOJu0YyDCRwSCupMuH+XbctknCYqbIqeSgQTfGotZdAWnC1V0iFPfZQf
	zLonnbxFn1tO4VxKDucxpIlKoEEHplXfoDQigZYN32FObQIhBrdw6/RGlw==
X-Google-Smtp-Source: AGHT+IHCfBsxJxQrVziOcPeh2PnBO+VemWCm9boUpV7C+4oa68DBjNm8JE8dHB5yU8vm+DcVtuRdjQ==
X-Received: by 2002:a05:6602:13cc:b0:7da:1802:12b9 with SMTP id o12-20020a05660213cc00b007da180212b9mr1986562iov.3.1714523534372;
        Tue, 30 Apr 2024 17:32:14 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id w17-20020a0566022c1100b007dea5e4e80asm2847242iov.37.2024.04.30.17.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 17:32:13 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] remove redundant "cmd_" prefix from functions in "commands"
Date: Tue, 30 Apr 2024 18:32:07 -0600
Message-ID: <20240501003207.56864-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is more idiomatic to use `commands::mount` than
`commands::cmd_mount`.

No functionality changes intended by this patch.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 src/bcachefs.rs                               | 12 ++++-------
 .../{cmd_completions.rs => completions.rs}    |  2 +-
 src/commands/{cmd_list.rs => list.rs}         |  2 +-
 src/commands/mod.rs                           | 21 ++++++++++++-------
 src/commands/{cmd_mount.rs => mount.rs}       |  6 +++---
 .../{cmd_subvolume.rs => subvolume.rs}        |  2 +-
 6 files changed, 23 insertions(+), 22 deletions(-)
 rename src/commands/{cmd_completions.rs => completions.rs} (89%)
 rename src/commands/{cmd_list.rs => list.rs} (99%)
 rename src/commands/{cmd_mount.rs => mount.rs} (98%)
 rename src/commands/{cmd_subvolume.rs => subvolume.rs} (97%)

diff --git a/src/bcachefs.rs b/src/bcachefs.rs
index 079a4155..e8099ffa 100644
--- a/src/bcachefs.rs
+++ b/src/bcachefs.rs
@@ -4,10 +4,6 @@ mod key;
 
 use std::ffi::{c_char, CString};
 
-use commands::cmd_completions::cmd_completions;
-use commands::cmd_list::cmd_list;
-use commands::cmd_mount::cmd_mount;
-use commands::cmd_subvolume::cmd_subvolumes;
 use commands::logger::SimpleLogger;
 use bch_bindgen::c;
 
@@ -110,10 +106,10 @@ fn main() {
     };
 
     let ret = match cmd {
-        "completions" => cmd_completions(args[1..].to_vec()),
-        "list" => cmd_list(args[1..].to_vec()),
-        "mount" => cmd_mount(args, symlink_cmd),
-        "subvolume" => cmd_subvolumes(args[1..].to_vec()),
+        "completions" => commands::completions(args[1..].to_vec()),
+        "list" => commands::list(args[1..].to_vec()),
+        "mount" => commands::mount(args, symlink_cmd),
+        "subvolume" => commands::subvolume(args[1..].to_vec()),
         _ => handle_c_command(args, symlink_cmd),
     };
 
diff --git a/src/commands/cmd_completions.rs b/src/commands/completions.rs
similarity index 89%
rename from src/commands/cmd_completions.rs
rename to src/commands/completions.rs
index 81ee719f..d4e98569 100644
--- a/src/commands/cmd_completions.rs
+++ b/src/commands/completions.rs
@@ -12,7 +12,7 @@ fn print_completions<G: Generator>(gen: G, cmd: &mut Command) {
     generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
 }
 
-pub fn cmd_completions(argv: Vec<String>) -> i32 {
+pub fn completions(argv: Vec<String>) -> i32 {
     let cli = Cli::parse_from(argv);
     print_completions(cli.shell, &mut super::Cli::command());
     0
diff --git a/src/commands/cmd_list.rs b/src/commands/list.rs
similarity index 99%
rename from src/commands/cmd_list.rs
rename to src/commands/list.rs
index 8af075af..0ed6be05 100644
--- a/src/commands/cmd_list.rs
+++ b/src/commands/list.rs
@@ -157,7 +157,7 @@ fn cmd_list_inner(opt: Cli) -> anyhow::Result<()> {
     }
 }
 
-pub fn cmd_list(argv: Vec<String>) -> i32 {
+pub fn list(argv: Vec<String>) -> i32 {
     let opt = Cli::parse_from(argv);
     colored::control::set_override(opt.colorize);
     if let Err(e) = cmd_list_inner(opt) {
diff --git a/src/commands/mod.rs b/src/commands/mod.rs
index 70fef82c..c7645926 100644
--- a/src/commands/mod.rs
+++ b/src/commands/mod.rs
@@ -1,10 +1,15 @@
 use clap::Subcommand;
 
 pub mod logger;
-pub mod cmd_mount;
-pub mod cmd_list;
-pub mod cmd_completions;
-pub mod cmd_subvolume;
+pub mod mount;
+pub mod list;
+pub mod completions;
+pub mod subvolume;
+
+pub use mount::mount;
+pub use list::list;
+pub use completions::completions;
+pub use subvolume::subvolume;
 
 #[derive(clap::Parser, Debug)]
 #[command(name = "bcachefs")]
@@ -15,11 +20,11 @@ pub struct Cli {
 
 #[derive(Subcommand, Debug)]
 enum Subcommands {
-    List(cmd_list::Cli),
-    Mount(cmd_mount::Cli),
-    Completions(cmd_completions::Cli),
+    List(list::Cli),
+    Mount(mount::Cli),
+    Completions(completions::Cli),
     #[command(visible_aliases = ["subvol"])]
-    Subvolume(cmd_subvolume::Cli),
+    Subvolume(subvolume::Cli),
 }
 
 #[macro_export]
diff --git a/src/commands/cmd_mount.rs b/src/commands/mount.rs
similarity index 98%
rename from src/commands/cmd_mount.rs
rename to src/commands/mount.rs
index 8d0e2e90..3cca0a4c 100644
--- a/src/commands/cmd_mount.rs
+++ b/src/commands/mount.rs
@@ -86,7 +86,7 @@ fn parse_mount_options(options: impl AsRef<str>) -> (Option<String>, libc::c_ulo
     )
 }
 
-fn mount(
+fn do_mount(
     device: String,
     target: impl AsRef<std::path::Path>,
     options: impl AsRef<str>,
@@ -276,7 +276,7 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
             &opt.options
         );
 
-        mount(devices, mountpoint, &opt.options)?;
+        do_mount(devices, mountpoint, &opt.options)?;
     } else {
         info!(
             "would mount with params: device: {}, options: {}",
@@ -288,7 +288,7 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     Ok(())
 }
 
-pub fn cmd_mount(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
+pub fn mount(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
     // If the bcachefs tool is being called as "bcachefs mount dev ..." (as opposed to via a
     // symlink like "/usr/sbin/mount.bcachefs dev ...", then we need to pop the 0th argument
     // ("bcachefs") since the CLI parser here expects the device at position 1.
diff --git a/src/commands/cmd_subvolume.rs b/src/commands/subvolume.rs
similarity index 97%
rename from src/commands/cmd_subvolume.rs
rename to src/commands/subvolume.rs
index c77eaacd..5f7cdc76 100644
--- a/src/commands/cmd_subvolume.rs
+++ b/src/commands/subvolume.rs
@@ -36,7 +36,7 @@ enum Subcommands {
     }
 }
 
-pub fn cmd_subvolumes(argv: Vec<String>) -> i32 {
+pub fn subvolume(argv: Vec<String>) -> i32 {
     let args = Cli::parse_from(argv);
 
     match args.subcommands {
-- 
2.44.0

