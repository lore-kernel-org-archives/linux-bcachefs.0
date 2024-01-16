Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F3E10A05
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZhRBk2w"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bf0f3bf331so149076039f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 22:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705387304; x=1705992104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVE2oGoI4hMgQuELb+wwG5219XnncHsdOwFbGi4c1YE=;
        b=PZhRBk2wn38LXVrxYgpz8a70YLsknItyQufoZZGlyNJKZs+aj2I3qO343t0UMNLlHm
         Eu+S1i7CzkXCnnq5yaPGXsMg8HtoipV32RVJ3Xh/6atNmsGXrfY7SZ2QuC7Sdmz9YMBV
         Ej265tXgka0SNOvCJJcW5hGm3460lIdhr1AuHG1usx+hSk58AiJCYIoSBEaZufwQfAsg
         i2f7eu0CavRtyzz5mSffptVoF/9ofwyUXafdDx5Zld/PvYg2uo+vkEPjwboZuPVk8W5W
         4FmE9qHZHDHbKb7dI42IWRmP6jXusL5gofqRmAJAbDybxuOVFElXU7d9D5sDVc/UvXz2
         Ur3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705387304; x=1705992104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVE2oGoI4hMgQuELb+wwG5219XnncHsdOwFbGi4c1YE=;
        b=mjkBfbCPBioMk1qMxLNaNyu7JwbQ7phmGhVb9ddex7gIr3c3SYWFuUVCeoO72fum5D
         cDnsGtOicNYaxRbN/rbyzhkBVKHss9BKcoM20+kr1f8t6lqr6I7V/Z3gWH/wC8HHR1yU
         19mgWmnWYqOQ2NM8KxnVCdEIg/aeevERMMTtYCbVc7QfWIrZdr8TYs4WMXhT+NwzYuIN
         PRaOCZHpb7DgH5hn3nUvphh2qgIzRcTc/TDoapB3XP1K/cd3EifRzw3UVSkeKQTeiZ8M
         16Qv120TQ5w5xtMGFtMrJes+RBtmgslruL4upg/9WOz++cbQghPGpnmo2Kd9GC+k1Xnv
         NNxw==
X-Gm-Message-State: AOJu0YyyTNiDiHpc1a3nJd7r8CWeXFfHH4uvZjMLp1lyFdHTnJb6BBdL
	t7QBs6ArrGAHDIrSv6O2JXJ+QXItDYimdQ==
X-Google-Smtp-Source: AGHT+IFp/QLK46xL635JXLjQupWr489K8L47nPHDtyFoB9VZhyFbJJMArkT5sOXc+wFwb6F7UDeXfw==
X-Received: by 2002:a5e:8918:0:b0:7bb:bca0:7670 with SMTP id k24-20020a5e8918000000b007bbbca07670mr8308328ioj.23.1705387304088;
        Mon, 15 Jan 2024 22:41:44 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id t24-20020a6bdb18000000b007bf3d8f13c6sm1124309ioc.6.2024.01.15.22.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 22:41:43 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 2/3] remove library from bcachefs-tools Rust package
Date: Mon, 15 Jan 2024 23:41:01 -0700
Message-ID: <20240116064102.193643-3-tahbertschinger@gmail.com>
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

When bcachefs was a C program that had some functions implemented in
Rust, it was necessary to make a static library containing the Rust
functions available for the C program to link.

Now that bcachefs is a Rust program, that library is no longer needed.
Instead, the Rust executable links in libbachefs.a.

This patch updates the crate structure to reflect that. The command
functions are moved into their own module.

There could be a need to create a "libbachefs-tools" library in the
future that exposes an API for bcachefs functionality to other
userspace programs. That will be a different, external API as opposed to
the previous library functions which were an internal API for the
bcachefs tool itself.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 rust-src/Cargo.toml                           |  3 ---
 rust-src/src/bcachefs.rs                      | 21 +++++++++++++++----
 .../src/{ => commands}/cmd_completions.rs     |  0
 rust-src/src/{ => commands}/cmd_list.rs       |  0
 rust-src/src/{ => commands}/cmd_mount.rs      |  0
 rust-src/src/{ => commands}/logger.rs         |  0
 rust-src/src/{lib.rs => commands/mod.rs}      | 10 ---------
 7 files changed, 17 insertions(+), 17 deletions(-)
 rename rust-src/src/{ => commands}/cmd_completions.rs (100%)
 rename rust-src/src/{ => commands}/cmd_list.rs (100%)
 rename rust-src/src/{ => commands}/cmd_mount.rs (100%)
 rename rust-src/src/{ => commands}/logger.rs (100%)
 rename rust-src/src/{lib.rs => commands/mod.rs} (72%)

diff --git a/rust-src/Cargo.toml b/rust-src/Cargo.toml
index 2786fc7..66d7bc6 100644
--- a/rust-src/Cargo.toml
+++ b/rust-src/Cargo.toml
@@ -9,9 +9,6 @@ rust-version = "1.65"
 name = "bcachefs"
 path = "src/bcachefs.rs"
 
-[lib]
-name = "bcachefs"
-
 [dependencies]
 atty = "0.2.14"
 log = { version = "0.4", features = ["std"] }
diff --git a/rust-src/src/bcachefs.rs b/rust-src/src/bcachefs.rs
index 3d7af3d..95f5e1f 100644
--- a/rust-src/src/bcachefs.rs
+++ b/rust-src/src/bcachefs.rs
@@ -1,11 +1,24 @@
+mod commands;
+mod key;
+
 use std::ffi::CString;
 
-use bcachefs::cmd_completions::cmd_completions;
-use bcachefs::cmd_list::cmd_list;
-use bcachefs::cmd_mount::cmd_mount;
-use bcachefs::logger::SimpleLogger;
+use commands::cmd_completions::cmd_completions;
+use commands::cmd_list::cmd_list;
+use commands::cmd_mount::cmd_mount;
+use commands::logger::SimpleLogger;
 use bch_bindgen::c;
 
+#[derive(Debug)]
+pub struct ErrnoError(pub errno::Errno);
+impl std::fmt::Display for ErrnoError {
+    fn fmt(&self, f: &mut std::fmt::Formatter) -> Result<(), std::fmt::Error> {
+        self.0.fmt(f)
+    }
+}
+
+impl std::error::Error for ErrnoError {}
+
 fn handle_c_command(args: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
     let mut argv: Vec<_> = args.clone();
 
diff --git a/rust-src/src/cmd_completions.rs b/rust-src/src/commands/cmd_completions.rs
similarity index 100%
rename from rust-src/src/cmd_completions.rs
rename to rust-src/src/commands/cmd_completions.rs
diff --git a/rust-src/src/cmd_list.rs b/rust-src/src/commands/cmd_list.rs
similarity index 100%
rename from rust-src/src/cmd_list.rs
rename to rust-src/src/commands/cmd_list.rs
diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/commands/cmd_mount.rs
similarity index 100%
rename from rust-src/src/cmd_mount.rs
rename to rust-src/src/commands/cmd_mount.rs
diff --git a/rust-src/src/logger.rs b/rust-src/src/commands/logger.rs
similarity index 100%
rename from rust-src/src/logger.rs
rename to rust-src/src/commands/logger.rs
diff --git a/rust-src/src/lib.rs b/rust-src/src/commands/mod.rs
similarity index 72%
rename from rust-src/src/lib.rs
rename to rust-src/src/commands/mod.rs
index f8b508d..e05a084 100644
--- a/rust-src/src/lib.rs
+++ b/rust-src/src/commands/mod.rs
@@ -1,6 +1,5 @@
 use clap::Subcommand;
 
-pub mod key;
 pub mod logger;
 pub mod cmd_mount;
 pub mod cmd_list;
@@ -30,12 +29,3 @@ macro_rules! c_str {
         }
     };
 }
-
-#[derive(Debug)]
-struct ErrnoError(errno::Errno);
-impl std::fmt::Display for ErrnoError {
-    fn fmt(&self, f: &mut std::fmt::Formatter) -> Result<(), std::fmt::Error> {
-        self.0.fmt(f)
-    }
-}
-impl std::error::Error for ErrnoError {}
-- 
2.43.0

