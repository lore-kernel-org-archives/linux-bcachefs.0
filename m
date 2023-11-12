Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9E45235
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.de header.i=@kloenk.de header.b="PXjOE1ta"
Received: from gimli.kloenk.de (gimli.kloenk.de [IPv6:2a01:4f8:c012:b874::])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496DA2D59
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 01:19:21 -0800 (PST)
From: Finn Behrens <me@kloenk.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.de; s=mail;
	t=1699780757; bh=Pn67NMfj3fGIdwtYqsAXxzvLNQcxCOnPmxdtTUeQ9cA=;
	h=From:To:Cc:Subject:Date;
	b=PXjOE1taCvteV5eBqgvIL5TAUvhoKk/aTsYeYpuisWKha0p71gYmMh965eiByH1sd
	 ve/3DU8ykU22VG44hMG1frUa2fsgBAp0LQiy3XtmP0IOBWwasJSTHjmMM50ZR/GNzt
	 VfzOy6UTflf1zMKe4XMcpBgsiVbPinPBXtftEpgQ=
To: linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev
Cc: Finn Behrens <me@kloenk.de>
Subject: [PATCH TOOLS] rust keylocation add none variant and implement ValueEnum
Date: Sun, 12 Nov 2023 10:19:09 +0100
Message-Id: <20231112091909.29868-1-me@kloenk.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This enables a possible values help in the clap help text.

Signed-Off-By: Finn Behrens <me@kloenk.de>
---
 rust-src/src/cmd_mount.rs | 11 +++-------
 rust-src/src/key.rs       | 44 ++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index bb23c1a..e045a3c 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -5,7 +5,7 @@ use clap::Parser;
 use uuid::Uuid;
 use std::path::PathBuf;
 use crate::key;
-use crate::key::KeyLoc;
+use crate::key::KeyLocation;
 use crate::logger::SimpleLogger;
 use std::ffi::{CStr, CString, OsStr, c_int, c_char, c_void};
 use std::os::unix::ffi::OsStrExt;
@@ -137,7 +137,7 @@ struct Cli {
     /// "wait" - wait for password to become available before mounting;
     /// "ask" -  prompt the user for password;
     #[arg(short, long, default_value = "ask", verbatim_doc_comment)]
-    key_location:   KeyLoc,
+    key_location:   KeyLocation,
 
     /// Device, or UUID=<UUID>
     dev:            String,
@@ -199,12 +199,7 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     if sbs.len() == 0 {
         Err(anyhow::anyhow!("No device found from specified parameters"))?;
     } else if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
-        let key = opt
-            .key_location
-            .0
-            .ok_or_else(|| anyhow::anyhow!("no keyoption specified for locked filesystem"))?;
-
-        key::prepare_key(&sbs[0], key)?;
+        key::prepare_key(&sbs[0], opt.key_location)?;
     }
 
     if let Some(mountpoint) = opt.mountpoint {
diff --git a/rust-src/src/key.rs b/rust-src/src/key.rs
index 9319351..93daa26 100644
--- a/rust-src/src/key.rs
+++ b/rust-src/src/key.rs
@@ -1,37 +1,50 @@
 use log::{info};
 use bch_bindgen::bcachefs::bch_sb_handle;
+use clap::builder::PossibleValue;
 use crate::c_str;
 use anyhow::anyhow;
 
 #[derive(Clone, Debug)]
 pub enum KeyLocation {
+    None,
     Fail,
     Wait,
     Ask,
 }
 
-#[derive(Clone, Debug)]
-pub struct KeyLoc(pub Option<KeyLocation>);
-impl std::ops::Deref for KeyLoc {
-    type Target = Option<KeyLocation>;
-    fn deref(&self) -> &Self::Target {
-        &self.0
-    }
-}
-
-impl std::str::FromStr for KeyLoc {
+impl std::str::FromStr for KeyLocation {
     type Err = anyhow::Error;
     fn from_str(s: &str) -> anyhow::Result<Self> {
         match s {
-            ""      => Ok(KeyLoc(None)),
-            "fail"  => Ok(KeyLoc(Some(KeyLocation::Fail))),
-            "wait"  => Ok(KeyLoc(Some(KeyLocation::Wait))),
-            "ask"   => Ok(KeyLoc(Some(KeyLocation::Ask))),
-            _       => Err(anyhow!("invalid password option")),
+            ""|"none" => Ok(KeyLocation::None),
+            "fail"    => Ok(KeyLocation::Fail),
+            "wait"    => Ok(KeyLocation::Wait),
+            "ask"     => Ok(KeyLocation::Ask),
+            _         => Err(anyhow!("invalid password option")),
         }
     }
 }
 
+impl clap::ValueEnum for KeyLocation {
+    fn value_variants<'a>() -> &'a [Self] {
+        &[
+            KeyLocation::None,
+            KeyLocation::Fail,
+            KeyLocation::Wait,
+            KeyLocation::Ask,
+        ]
+    }
+
+    fn to_possible_value(&self) -> Option<PossibleValue> {
+        Some(match self {
+            Self::None => PossibleValue::new("none").alias(""),
+            Self::Fail => PossibleValue::new("fail"),
+            Self::Wait => PossibleValue::new("wait"),
+            Self::Ask => PossibleValue::new("ask"),
+        })
+    }
+}
+
 fn check_for_key(key_name: &std::ffi::CStr) -> anyhow::Result<bool> {
     use bch_bindgen::keyutils::{self, keyctl_search};
     let key_name = key_name.to_bytes_with_nul().as_ptr() as *const _;
@@ -126,5 +139,6 @@ pub fn prepare_key(sb: &bch_sb_handle, password: KeyLocation) -> anyhow::Result<
         KeyLocation::Fail => Err(anyhow!("no key available")),
         KeyLocation::Wait => Ok(wait_for_key(&sb.sb().uuid())?),
         KeyLocation::Ask => ask_for_key(sb),
+        _ => Err(anyhow!("no keyoption specified for locked filesystem")),
     }
 }
-- 
2.39.3 (Apple Git-145)

