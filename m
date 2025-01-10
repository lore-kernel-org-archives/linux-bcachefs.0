Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D921CA17
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549390; cv=none; b=o3O2zKyjz9XlMmdS29mzjfSdgpf5h3ufGY6bFWnl62bPxx0BGcRgW8JC+zv6dUPIo4I5IUUzyM3MSzMrypf6aesBACjfsW22pcRXYaWft85g+6YXGW87Ve6iUUuNGzbXaYpOgcN1v3TkdhbBOXTNQwZOFoOXiuHeQmjGDw3AlV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549390; c=relaxed/simple;
	bh=MRvkUB8YPDsUQq2WcBk3ArAAuM7Tqac2gkNkjGY+EqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTF8wbAsRM1x3i10REvp4YkB9B+s2rN4o29h6FnqirQ/f6Q0RbjbCgoEIFSxIbbc1nYnlzwRZtrVyqBtUAaLDlH2stBI+z6CUxi02zZFaJPk1xnVyiTXv7Wok8TxdFCWgcfifLIXhTW6m+7Ca+582wqFj1kleKW2XjeXZuYEVmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=UmHhOQ0f; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="UmHhOQ0f"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 88FC8240029
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549386; bh=MRvkUB8YPDsUQq2WcBk3ArAAuM7Tqac2gkNkjGY+EqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=UmHhOQ0f4dhhm2GYoNtuNJk1zlM7jC25Z4hjgHekWkNkECTcfVkPbDzQtrvkj8IW/
	 SEq/ylRQ2OUSkRAYL0glbfq7Ww5bBi/OP5ph0MblBGCmZBwC3d8W8faj08MBFaeDoe
	 7YgyRZ5ofQ0k0/yh8RK/QN9giww+HxoK1TJ3QhMpvX8BKW69BsN6sLjEImo5YcXyUX
	 WS8Y3wJKFJLO/R0PG/WUWJDSd7wiEhC3ubwW1n4s9S25cA2z68G+q4MYc/40Y//06j
	 n+rReL1uho9hHPTDw4bRdH1D6KDdTLOxkcKSBwFxlNyKWiTYpwbR+nrgQ9D9ntOTOq
	 /VnCaeJ/lRouw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0T73jHz6tvd;
	Fri, 10 Jan 2025 23:49:45 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 5/9] fix(key): replace c_str macro with `c""` literal
Date: Fri, 10 Jan 2025 22:49:08 +0000
Message-ID: <20250110224912.445491-6-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
2.47.0

