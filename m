Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A3F23A2
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBeXNk8t"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3606e2120bdso62085435ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jan 2024 21:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705296407; x=1705901207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvXuSpy5YKjYW81sOUGoAIrrPJBmmOoGfghkqqukG7g=;
        b=IBeXNk8tLg7PoQAOxjagjkj1RnXdLyCRMoJ4b7v0tXqcfmxB47jmk1zYrSUbDY9x/e
         rQpKT2Cc71lhzxHBXhAqmCrgx5WLpa3jryPptv9yg2azzQSOyK0Ui8hiUTIXHeC13SvG
         0Paf5oNwUu/1NisaA29BXX4O7iSSmkVjsAk1aZjFByIGp+kUQaehXiUDShDcig1kMSiF
         b5RpWYBCUEYhQ/Zy7AutY97m365NvjuzLzx59JRcgR2mGse/ZPfNJmdNsLDJGS3h8TwT
         VNoqy02/PSXufhAXtqK0bDZDnf8R9HawF0g7K8STcxp1lYmSeBZdfm5uCMGkmPhL73dI
         R6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705296407; x=1705901207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvXuSpy5YKjYW81sOUGoAIrrPJBmmOoGfghkqqukG7g=;
        b=d7yoIHqSPOKk8JwWIM7n2WLzUEpsfG4gaqsJdKNFTxVADFkG+zdz2wVZnOBjSkpgYf
         zB653mLdp4MX0EKPyYvuHrnIl4iFqMy/Ki4qJJYO2YyWc4yfsjy86vzlwulr53bCqRp/
         K/+RJfwAt+JB4BFyAMQ1xkhf1NmLk9ExKGe5voSZa4LMcGHRIGsSySkk9ft+mUYoqAE+
         D38cEfCYsK38eAYG6zjCZwmefdS7jliqOL9zSu9kyFvCneiiJdP3eUHK+yY8cgDjLB+c
         ym57MeyfFPM8ZzK4IlpswExdUxanoTmnAjKVR3122X5jtYQNRiy1IJIsT9SbTEwuw1sI
         YJrw==
X-Gm-Message-State: AOJu0Yykokwq0Nf5+vHQ2aftyzECRDPskQZBQ4YL2iE9OGVBwpe7wSKG
	yXbOq48Kjy43t7V6njY48BI=
X-Google-Smtp-Source: AGHT+IEeJQ5miYMi0tO5P8M7R8Y26W0gpmVY+CVHcRtlmp8j8nwm5OSZRBfmDPNiomrgUTQfRJV2pA==
X-Received: by 2002:a05:6e02:683:b0:35f:f383:ac7a with SMTP id o3-20020a056e02068300b0035ff383ac7amr6376880ils.127.1705296406477;
        Sun, 14 Jan 2024 21:26:46 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id i2-20020a056e020ec200b0035faf00c555sm2704129ilk.31.2024.01.14.21.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jan 2024 21:26:46 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS 2/2] remove library from bcachefs-tools Rust package
Date: Sun, 14 Jan 2024 22:24:51 -0700
Message-ID: <20240115052451.145611-3-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115052451.145611-1-tahbertschinger@gmail.com>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When bcachefs was a C program that had some functions implemented in
Rust, it was necessary to make a static library containing the Rust
functions for the C program to link.

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
index 1e96f85..f50523b 100644
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
index ed5fd1d..0a76a92 100644
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

