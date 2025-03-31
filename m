Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E18D22333A
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431729; cv=none; b=kHJpSFCGWyWFgOrKzx1KeC38Ppp070alVzcFoXbEX+1qlNUEpGKSUiiCGmBf+t5KBqb+/B/B+3iUuNz10cgTU6UtFsb4/VYCZoK2lvHNqAJDVmgYbY/x9OXOGbUmopLOjUpPEQDBLjgikSjYwnBJ0msimMxAfuOcQ8y2m1LwJhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431729; c=relaxed/simple;
	bh=oWz8mMuCo3aCAHEJmNC1xGTOkxm/u1A/93Nre8kpc8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=td8Eh5gizKB+FdXmKQbsk3SCyyodkeJandweE/Xg8TRTFY1aFMsISeVl2kOlxz0mLViW8RjlAfgnyBYz/fYAIcMgkyUWbQVcTWYT0Pxt5aoRWSZO/nCgWTswY1Waty3NgVHWc3vO96IIN/wB+tT+ntRyGrpMAPjTyuBx3YLaU08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=pS6l2dBI; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="pS6l2dBI"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id F34D9240103
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:35:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743431719; bh=oWz8mMuCo3aCAHEJmNC1xGTOkxm/u1A/93Nre8kpc8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=pS6l2dBIhZZ6v3YXq0WGiQc83k+jmJv7TsDvWE4kmwv4VbrcAFTNBl/Io2jt24CBF
	 ZF9FuywFdoZtfFjCRaVdNVaDwfbLbXrlB/8h50sfSHjOv1CHdBsrlp7vRKKY3OqpVt
	 Aq+s5M3Kbh0hbww9ZLHmN4ECfIyG4Z6SZC+YCrOskik8dencHYPjMbC6Mfu2+RPsem
	 AeKxuHBTfxhNS8trekhB3hTsfgkd/r8oMGmduavtsioq6dUYX8oiBqx1xzE7SkTaBS
	 l46wSoz4MBFUAYcGb0YohSyzVnzr5cMqOGVoQCfB/Eokrijv41f0hoRILsF3/nPKWe
	 LWgtuA3mTBFyw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRDF32nMdz9rxG;
	Mon, 31 Mar 2025 16:35:19 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 3/5] refactor: `cargo clippy --fix && cargo fmt`
Date: Mon, 31 Mar 2025 14:35:07 +0000
Message-ID: <20250331143509.157528-4-tmuehlbacher@posteo.net>
In-Reply-To: <20250331143509.157528-1-tmuehlbacher@posteo.net>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 bch_bindgen/src/bkey.rs  |  2 +-
 bch_bindgen/src/btree.rs | 24 ++++++++++++------------
 bch_bindgen/src/lib.rs   | 15 ++++-----------
 src/commands/mount.rs    | 19 ++++++++++++++-----
 4 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
index 2a012508..77e05900 100644
--- a/bch_bindgen/src/bkey.rs
+++ b/bch_bindgen/src/bkey.rs
@@ -129,7 +129,7 @@ pub struct BkeySCToText<'a, 'b> {
     fs: &'b Fs,
 }
 
-impl<'a, 'b> fmt::Display for BkeySCToText<'a, 'b> {
+impl fmt::Display for BkeySCToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         unsafe {
             printbuf_to_formatter(f, |buf| {
diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
index 1aaf3018..ed563b95 100644
--- a/bch_bindgen/src/btree.rs
+++ b/bch_bindgen/src/btree.rs
@@ -25,7 +25,7 @@ impl<'f> BtreeTrans<'f> {
     }
 }
 
-impl<'f> Drop for BtreeTrans<'f> {
+impl Drop for BtreeTrans<'_> {
     fn drop(&mut self) {
         unsafe { c::bch2_trans_put(&mut *self.raw) }
     }
@@ -81,7 +81,7 @@ impl<'t> BtreeIter<'t> {
         }
     }
 
-    pub fn peek_max<'i>(&'i mut self, end: c::bpos) -> Result<Option<BkeySC<'i>>, bch_errcode> {
+    pub fn peek_max(&mut self, end: c::bpos) -> Result<Option<BkeySC<'_>>, bch_errcode> {
         unsafe {
             let k = c::bch2_btree_iter_peek_max(&mut self.raw, end);
             errptr_to_result_c(k.k).map(|_| {
@@ -127,7 +127,7 @@ impl<'t> BtreeIter<'t> {
     }
 }
 
-impl<'t> Drop for BtreeIter<'t> {
+impl Drop for BtreeIter<'_> {
     fn drop(&mut self) {
         unsafe { c::bch2_trans_iter_exit(self.raw.trans, &mut self.raw) }
     }
@@ -166,27 +166,27 @@ impl<'t> BtreeNodeIter<'t> {
         }
     }
 
-    pub fn peek<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
+    pub fn peek(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
         unsafe {
             let b = c::bch2_btree_iter_peek_node(&mut self.raw);
             errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
         }
     }
 
-    pub fn peek_and_restart<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
+    pub fn peek_and_restart(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
         unsafe {
             let b = c::bch2_btree_iter_peek_node_and_restart(&mut self.raw);
             errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
         }
     }
 
-    pub fn advance<'i>(&'i mut self) {
+    pub fn advance(&mut self) {
         unsafe {
             c::bch2_btree_iter_next_node(&mut self.raw);
         }
     }
 
-    pub fn next<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
+    pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
         unsafe {
             let b = c::bch2_btree_iter_next_node(&mut self.raw);
             errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
@@ -194,7 +194,7 @@ impl<'t> BtreeNodeIter<'t> {
     }
 }
 
-impl<'t> Drop for BtreeNodeIter<'t> {
+impl Drop for BtreeNodeIter<'_> {
     fn drop(&mut self) {
         unsafe { c::bch2_trans_iter_exit(self.raw.trans, &mut self.raw) }
     }
@@ -202,11 +202,11 @@ impl<'t> Drop for BtreeNodeIter<'t> {
 
 impl<'b, 'f> c::btree {
     pub fn to_text(&'b self, fs: &'f Fs) -> BtreeNodeToText<'b, 'f> {
-        BtreeNodeToText { b: &self, fs }
+        BtreeNodeToText { b: self, fs }
     }
 
     pub fn ondisk_to_text(&'b self, fs: &'f Fs) -> BtreeNodeOndiskToText<'b, 'f> {
-        BtreeNodeOndiskToText { b: &self, fs }
+        BtreeNodeOndiskToText { b: self, fs }
     }
 }
 
@@ -215,7 +215,7 @@ pub struct BtreeNodeToText<'b, 'f> {
     fs: &'f Fs,
 }
 
-impl<'b, 'f> fmt::Display for BtreeNodeToText<'b, 'f> {
+impl fmt::Display for BtreeNodeToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         printbuf_to_formatter(f, |buf| unsafe {
             c::bch2_btree_node_to_text(buf, self.fs.raw, self.b)
@@ -228,7 +228,7 @@ pub struct BtreeNodeOndiskToText<'b, 'f> {
     fs: &'f Fs,
 }
 
-impl<'b, 'f> fmt::Display for BtreeNodeOndiskToText<'b, 'f> {
+impl fmt::Display for BtreeNodeOndiskToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         printbuf_to_formatter(f, |buf| unsafe {
             c::bch2_btree_node_ondisk_to_text(buf, self.fs.raw, self.b)
diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
index b68f2d9b..7825cde1 100644
--- a/bch_bindgen/src/lib.rs
+++ b/bch_bindgen/src/lib.rs
@@ -109,13 +109,8 @@ impl FromStr for c::btree_id {
         let s = CString::new(s).unwrap();
         let p = s.as_ptr();
 
-        let v = unsafe {
-            c::match_string(
-                c::__bch2_btree_ids[..].as_ptr(),
-                (-(1 as isize)) as usize,
-                p,
-            )
-        };
+        let v =
+            unsafe { c::match_string(c::__bch2_btree_ids[..].as_ptr(), (-1_isize) as usize, p) };
         if v >= 0 {
             Ok(unsafe { std::mem::transmute(v) })
         } else {
@@ -131,9 +126,7 @@ impl FromStr for c::bch_bkey_type {
         let s = CString::new(s).unwrap();
         let p = s.as_ptr();
 
-        let v = unsafe {
-            c::match_string(c::bch2_bkey_types[..].as_ptr(), (-(1 as isize)) as usize, p)
-        };
+        let v = unsafe { c::match_string(c::bch2_bkey_types[..].as_ptr(), (-1_isize) as usize, p) };
         if v >= 0 {
             Ok(unsafe { std::mem::transmute(v) })
         } else {
@@ -192,7 +185,7 @@ impl FromStr for c::bpos {
 
         let ino: u64 = ino_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
         let off: u64 = off_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
-        let snp: u32 = snp_str.map(|s| s.parse().ok()).flatten().unwrap_or(0);
+        let snp: u32 = snp_str.and_then(|s| s.parse().ok()).unwrap_or(0);
 
         Ok(c::bpos {
             inode:    ino,
diff --git a/src/commands/mount.rs b/src/commands/mount.rs
index 1b8f444a..148d686e 100644
--- a/src/commands/mount.rs
+++ b/src/commands/mount.rs
@@ -35,7 +35,9 @@ fn mount_inner(
     // convert to pointers for ffi
     let c_src = c_src.as_ptr();
     let c_target = c_target.as_ptr();
-    let data_ptr = data.as_ref().map_or(ptr::null(), |data| data.as_ptr().cast());
+    let data_ptr = data
+        .as_ref()
+        .map_or(ptr::null(), |data| data.as_ptr().cast());
     let fstype = fstype.as_ptr();
 
     let mut ret;
@@ -66,7 +68,11 @@ fn mount_inner(
         let e = crate::ErrnoError(err);
 
         if err.0 == libc::EBUSY {
-            eprintln!("mount: {}: {} already mounted or mount point busy", target.to_string_lossy(), src);
+            eprintln!(
+                "mount: {}: {} already mounted or mount point busy",
+                target.to_string_lossy(),
+                src
+            );
         } else {
             eprintln!("mount: {}: {}", src, e);
         }
@@ -248,7 +254,10 @@ fn devs_str_sbs_from_device(
     let dev_sb = read_super_silent(device, *opts)?;
 
     if dev_sb.sb().number_of_devices() == 1 {
-        Ok((device.as_os_str().to_str().unwrap().to_string(), vec![dev_sb]))
+        Ok((
+            device.as_os_str().to_str().unwrap().to_string(),
+            vec![dev_sb],
+        ))
     } else {
         let uuid = dev_sb.sb().uuid();
 
@@ -390,8 +399,8 @@ pub fn mount(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> std::process::
     logging::setup(cli.verbose, cli.colorize);
 
     match cmd_mount_inner(&cli) {
-        Ok(_)   => std::process::ExitCode::SUCCESS,
-        Err(e)   => {
+        Ok(_) => std::process::ExitCode::SUCCESS,
+        Err(e) => {
             error!("Mount failed: {e}");
             std::process::ExitCode::FAILURE
         }
-- 
2.48.1

