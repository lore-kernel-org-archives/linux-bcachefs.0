Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E0822CBE4
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575252; cv=none; b=qK47yZSJxT07xL1PMoXfHNeVlaL3ux/vhcOiaBMohi1JHPt6amBpq8iQjFmWgesvCwMFyVvtpwsWyVgJM3IxMYMfj6I8nixID/xhCalYl9AnKN+P82569cnc3c4UN8VCQiWq07hZFuqALxg2ihts0WfKYQNvULiO3IlOHGfc644=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575252; c=relaxed/simple;
	bh=Ab5eQ9T4yP9f/JrqCONmdcr2bTvwLGi6U52XgTdUsHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4cOHjvKi6ne9sY+FEJr6cj/a+hy1BygoZjL5MtlGeSeQKWP/dAzo92ThuHlJpHszFwHgis7OciG3WuBI4AfEQZtavvwfG/2U96fnzYCrSQd/JWNKp70WRRBwsB0d2AHWTgHJRRIAuOxG3YLR60m8oh4DK7w5g3CtdMnzQA8OGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=i0Ng4XiB; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="i0Ng4XiB"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 3F967240028
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574868; bh=Ab5eQ9T4yP9f/JrqCONmdcr2bTvwLGi6U52XgTdUsHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=i0Ng4XiBX7gZRzU5Ey+HMQcZ3Vjn0DP5SABX6WhB75J2+Yds7JEobQD28W3QN2XYQ
	 lOa9/QMTvnBnSfuPcE6rSys7LT28wZpTeXyfBhvsyI3f6ifm/EWg2d/n8lNal2ZSIs
	 Wa4r4vJDrABP7mvCHKVXm7JmJ8tasjzPtYI/BDU7D45q9vviqo3biQvNJR/fb2Q0ao
	 lmaiWM5lXHepkd/lcNz6GLX7HaDDiFhMfk/8AZVLHuwDgeZbTmZF59gaRbY7IEavIx
	 yGfOlurHHUUaEQvig2GyJqhBSCKTFRhg3uGAX+U8SZ+/hzvyQjM4vFcme0v30JBysU
	 i+NGc58+LKsRg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M42qRlz9rxB;
	Fri, 21 Mar 2025 17:34:24 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 05/10] fix(key): replace c_str macro with `c""` literal
Date: Fri, 21 Mar 2025 16:33:59 +0000
Message-ID: <20250321163404.353334-6-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the MSRV in Cargo.toml, we can use this now.
---
 src/commands/mod.rs | 25 -------------------------
 src/key.rs          | 15 ++++++++-------
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/src/commands/mod.rs b/src/commands/mod.rs
index 7f466f92..fd15bb38 100644
--- a/src/commands/mod.rs
+++ b/src/commands/mod.rs
@@ -25,28 +25,3 @@ enum Subcommands {
     #[command(visible_aliases = ["subvol"])]
     Subvolume(subvolume::Cli),
 }
-
-// FIXME: Can be removed after bumping MSRV >= 1.77 in favor of `c""` literals
-#[macro_export]
-macro_rules! c_str {
-    ($lit:expr) => {
-        ::std::ffi::CStr::from_bytes_with_nul(concat!($lit, "\0").as_bytes())
-            .unwrap()
-            .as_ptr()
-    };
-}
-
-#[cfg(test)]
-mod tests {
-    use std::ffi::CStr;
-
-    #[test]
-    fn check_cstr_macro() {
-        let literal = c_str!("hello");
-
-        assert_eq!(
-            literal,
-            CStr::from_bytes_with_nul(b"hello\0").unwrap().as_ptr()
-        );
-    }
-}
diff --git a/src/key.rs b/src/key.rs
index 0043095c..8cf4f124 100644
--- a/src/key.rs
+++ b/src/key.rs
@@ -4,10 +4,11 @@ use std::{
     io::{stdin, IsTerminal},
     mem,
     path::Path,
+    process::{Command, Stdio},
     ptr, thread,
     time::Duration,
 };
-use std::process::{Command, Stdio};
+
 use anyhow::{anyhow, ensure, Result};
 use bch_bindgen::{
     bcachefs::{self, bch_key, bch_sb_handle},
@@ -19,7 +20,7 @@ use rustix::termios;
 use uuid::Uuid;
 use zeroize::{ZeroizeOnDrop, Zeroizing};
 
-use crate::{c_str, ErrnoError};
+use crate::ErrnoError;
 
 const BCH_KEY_MAGIC: &[u8; 8] = b"bch**key";
 
@@ -72,13 +73,13 @@ impl KeyHandle {
     pub fn new(sb: &bch_sb_handle, passphrase: &Passphrase) -> Result<Self> {
         let key_name = Self::format_key_name(&sb.sb().uuid());
         let key_name = CStr::as_ptr(&key_name);
-        let key_type = c_str!("user");
+        let key_type = c"user";
 
         let (passphrase_key, _sb_key) = passphrase.check(sb)?;
 
         let key_id = unsafe {
             keyutils::add_key(
-                key_type,
+                key_type.as_ptr(),
                 key_name,
                 ptr::addr_of!(passphrase_key).cast(),
                 mem::size_of_val(&passphrase_key),
@@ -99,9 +100,9 @@ impl KeyHandle {
 
     fn search_keyring(keyring: i32, key_name: &CStr) -> Result<c_long> {
         let key_name = CStr::as_ptr(key_name);
-        let key_type = c_str!("user");
+        let key_type = c"user";
 
-        let key_id = unsafe { keyctl_search(keyring, key_type, key_name, 0) };
+        let key_id = unsafe { keyctl_search(keyring, key_type.as_ptr(), key_name, 0) };
 
         if key_id > 0 {
             info!("Found key in keyring");
@@ -165,7 +166,7 @@ impl Passphrase {
         Ok(if output.status.success() {
             match CString::new(output.stdout) {
                 Ok(cstr) => Ok(Self(cstr)),
-                Err(e) => Err(e.into())
+                Err(e) => Err(e.into()),
             }
         } else {
             Err(anyhow!("systemd-ask-password returned an error"))
-- 
2.48.1

