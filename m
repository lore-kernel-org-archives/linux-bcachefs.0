Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F521CC74
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 23:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743464884; cv=none; b=DaY6NzML+3v+zahEDd6r0TguKc5X9ghU39rmPtv2kbaomzbEH2yjlNiMStRM4CujrhO4CXC9fu4gtHM1u2helXZLe/qLSdIQ6cxSfqNlNhSOKn46zagVfNmvmE1uoxIcgre4w8W22O0kqqaB041cc7fPlR0sqfMTwSz8h6Bb+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743464884; c=relaxed/simple;
	bh=ypl2TPoJIfPctqu8Bq4Tut6As3Y9mNSFz7dNKuLz9zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ka38tnKnYePVXJgYeJP4tu0Q4Y86ahtbF8bLmQDaAe0PfagMjFPJ3cqbs0rA+QkLWzU9KHV/Kbud1toS/PahpnSWHsz+c/aNXlPPlXq1JE512bpPXMACKSVY82QtaKKhmUlvFk5+aDkUJ5PVJCqczoUftd4yr/vbERcxVnRk/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=nRDp0CwX; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="nRDp0CwX"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 510E2240101
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Apr 2025 01:47:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743464879; bh=ypl2TPoJIfPctqu8Bq4Tut6As3Y9mNSFz7dNKuLz9zE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=nRDp0CwX0gV/KX6t98HX4h+G6Cit7pvJAia8LXkL5TNWV3Se122Lh2IDd9D3vbrQT
	 w/w45JgurX1fVmsTSg2x+wlgYb7tAdK1jTGLUg+XWni9uFhtQwGN6vB5Dhay23Zq5N
	 ZIk/aNHBOA3NYNdGrUwfdxgSF5FzvT0OfnK6PhsLrNJfgeGHYa4KC4aryPmlTCTAC1
	 McRTbvOUrEmQoW6Uv64zD/mrO+qlrQPghk5UCl0xNpVom/u9A3g79498CClz71zh5I
	 XfrG8W+uRkNrn81mywNNCH0V80BzB4zdk7xbO01IkpLALM3qPsWgDfjjcKh8AVF+1i
	 6q7OQfBCKuRIg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRSVk67RBz6v0K;
	Tue,  1 Apr 2025 01:47:58 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 2/2] refactor: make bch_bindgen pass clippy
Date: Mon, 31 Mar 2025 23:47:44 +0000
Message-ID: <20250331234744.428142-3-tmuehlbacher@posteo.net>
In-Reply-To: <20250331234744.428142-1-tmuehlbacher@posteo.net>
References: <20250331234744.428142-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do only what is minimally necessary for these checks to pass, I guess.

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 bch_bindgen/src/bcachefs.rs |  5 +++++
 bch_bindgen/src/bkey.rs     |  3 ++-
 bch_bindgen/src/btree.rs    | 25 +++++++++++++------------
 bch_bindgen/src/fs.rs       |  2 +-
 bch_bindgen/src/lib.rs      | 19 ++++++-------------
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
index 8f6d41a4..8c510544 100644
--- a/bch_bindgen/src/bcachefs.rs
+++ b/bch_bindgen/src/bcachefs.rs
@@ -1,3 +1,8 @@
+#![allow(clippy::missing_safety_doc)]
+#![allow(clippy::too_many_arguments)]
+#![allow(clippy::transmute_int_to_bool)]
+#![allow(clippy::unnecessary_cast)]
+#![allow(clippy::useless_transmute)]
 #![allow(non_upper_case_globals)]
 #![allow(non_camel_case_types)]
 #![allow(non_snake_case)]
diff --git a/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
index 2a012508..a7fdad2e 100644
--- a/bch_bindgen/src/bkey.rs
+++ b/bch_bindgen/src/bkey.rs
@@ -65,6 +65,7 @@ impl<'a, 'b> BkeySC<'a> {
         BkeySCToText { k: self, fs }
     }
 
+    #[allow(clippy::missing_transmute_annotations)]
     pub fn v(&'a self) -> BkeyValC<'a> {
         unsafe {
             let ty: c::bch_bkey_type = transmute(self.k.type_ as u32);
@@ -129,7 +130,7 @@ pub struct BkeySCToText<'a, 'b> {
     fs: &'b Fs,
 }
 
-impl<'a, 'b> fmt::Display for BkeySCToText<'a, 'b> {
+impl fmt::Display for BkeySCToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         unsafe {
             printbuf_to_formatter(f, |buf| {
diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
index 1aaf3018..81699429 100644
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
@@ -166,27 +166,28 @@ impl<'t> BtreeNodeIter<'t> {
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
+    #[allow(clippy::should_implement_trait)]
+    pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
         unsafe {
             let b = c::bch2_btree_iter_next_node(&mut self.raw);
             errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
@@ -194,7 +195,7 @@ impl<'t> BtreeNodeIter<'t> {
     }
 }
 
-impl<'t> Drop for BtreeNodeIter<'t> {
+impl Drop for BtreeNodeIter<'_> {
     fn drop(&mut self) {
         unsafe { c::bch2_trans_iter_exit(self.raw.trans, &mut self.raw) }
     }
@@ -202,11 +203,11 @@ impl<'t> Drop for BtreeNodeIter<'t> {
 
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
 
@@ -215,7 +216,7 @@ pub struct BtreeNodeToText<'b, 'f> {
     fs: &'f Fs,
 }
 
-impl<'b, 'f> fmt::Display for BtreeNodeToText<'b, 'f> {
+impl fmt::Display for BtreeNodeToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         printbuf_to_formatter(f, |buf| unsafe {
             c::bch2_btree_node_to_text(buf, self.fs.raw, self.b)
@@ -228,7 +229,7 @@ pub struct BtreeNodeOndiskToText<'b, 'f> {
     fs: &'f Fs,
 }
 
-impl<'b, 'f> fmt::Display for BtreeNodeOndiskToText<'b, 'f> {
+impl fmt::Display for BtreeNodeOndiskToText<'_, '_> {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         printbuf_to_formatter(f, |buf| unsafe {
             c::bch2_btree_node_ondisk_to_text(buf, self.fs.raw, self.b)
diff --git a/bch_bindgen/src/fs.rs b/bch_bindgen/src/fs.rs
index e44fca25..2997ed8f 100644
--- a/bch_bindgen/src/fs.rs
+++ b/bch_bindgen/src/fs.rs
@@ -9,7 +9,7 @@ pub struct Fs {
 }
 
 impl Fs {
-    pub fn open(devs: &Vec<PathBuf>, opts: c::bch_opts) -> Result<Fs, bch_errcode> {
+    pub fn open(devs: &[PathBuf], opts: c::bch_opts) -> Result<Fs, bch_errcode> {
         let devs: Vec<_> = devs
             .iter()
             .map(|i| CString::new(i.as_os_str().as_bytes()).unwrap().into_raw())
diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
index b68f2d9b..67eb14e7 100644
--- a/bch_bindgen/src/lib.rs
+++ b/bch_bindgen/src/lib.rs
@@ -109,15 +109,10 @@ impl FromStr for c::btree_id {
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
-            Ok(unsafe { std::mem::transmute(v) })
+            Ok(unsafe { std::mem::transmute::<i32, bcachefs::btree_id>(v) })
         } else {
             Err(BchToolsErr::InvalidBtreeId)
         }
@@ -131,11 +126,9 @@ impl FromStr for c::bch_bkey_type {
         let s = CString::new(s).unwrap();
         let p = s.as_ptr();
 
-        let v = unsafe {
-            c::match_string(c::bch2_bkey_types[..].as_ptr(), (-(1 as isize)) as usize, p)
-        };
+        let v = unsafe { c::match_string(c::bch2_bkey_types[..].as_ptr(), (-1_isize) as usize, p) };
         if v >= 0 {
-            Ok(unsafe { std::mem::transmute(v) })
+            Ok(unsafe { std::mem::transmute::<i32, bcachefs::bch_bkey_type>(v) })
         } else {
             Err(BchToolsErr::InvalidBkeyType)
         }
@@ -192,7 +185,7 @@ impl FromStr for c::bpos {
 
         let ino: u64 = ino_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
         let off: u64 = off_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
-        let snp: u32 = snp_str.map(|s| s.parse().ok()).flatten().unwrap_or(0);
+        let snp: u32 = snp_str.and_then(|s| s.parse().ok()).unwrap_or(0);
 
         Ok(c::bpos {
             inode:    ino,
-- 
2.48.1

