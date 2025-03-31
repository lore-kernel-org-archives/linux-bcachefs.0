Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A872223311
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431728; cv=none; b=kITUVpn3053YoxcceLelHI0mPdsK7NMH4aONfn3ZFXCSxfv5KmQHixArV9VQCCf5tkEdHXuNdV/z2b13a6+AHIfb9addickPWx+rcy0/WFQq+kD4rfbY4jTcUuKFBia1US6CVzjWH3b00i9U2F4she/QljrZei/DutwDBsE1dmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431728; c=relaxed/simple;
	bh=qAwJlKlSRmzO74Uhk/cNUuGKiedbHTQHBBWDy3qnA9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+hDXaalAgQtQnX46pShy8B5hdR2RKII9MZYBCkKyKZjMUMJCrcsnTiFWQPtpxjL2zRM5uDljLmrYGbd+Ys3eLPaBE2zf+/SD9ENIK2UrJAHwrh0DdNXu4/VRaiXLCpBTp9RL75Vrx4/NmijPldN1qRzjEMLumiIAHcmGFtmS9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=HeW5Df4f; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="HeW5Df4f"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id DEB25240028
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:35:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743431723; bh=qAwJlKlSRmzO74Uhk/cNUuGKiedbHTQHBBWDy3qnA9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=HeW5Df4fOzfTOYg0cIzKF9AxgjMV0x/8M/RFMrRAXJEKsH7o3as+tQkAHmAcHP2bN
	 lLqSPhefMcI+1dm5nuO4nKVSZ0/9FnEtKP4jCcSyU9v+2Xe5q1RtRWZMv0OxZzTCc1
	 Lr+uX9lEuVhmNrR3I/6ewr2tWmpxRqyOrquC9Zi+fgjDeCfQJnwwec237BznUBy97D
	 s+UlLYrVCN3dFfPwOwfLLPFMCh1l1LxhTkC/sy9jx5xJRt7SYZ+Je2iMIZtzMUMfQi
	 kBMdpISYi4LsGZXC4RKYYDCcHVPNGaSfhA3urFp11a2LXRJlJ1oB+OjtNLsLhtqhmR
	 lbAbzC9uc//7w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRDF457vZz9rxG;
	Mon, 31 Mar 2025 16:35:20 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 5/5] refactor: make bch_bindgen pass clippy
Date: Mon, 31 Mar 2025 14:35:09 +0000
Message-ID: <20250331143509.157528-6-tmuehlbacher@posteo.net>
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

Done through suppressing clippy lints in the generated bindings module,
adding some transmute type annotations, changing a vec to slice type.

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 bch_bindgen/src/bcachefs.rs |   5 ++
 bch_bindgen/src/bkey.rs     | 151 ++++++++++++++++++++++++++++--------
 bch_bindgen/src/btree.rs    |   1 +
 bch_bindgen/src/fs.rs       |   2 +-
 bch_bindgen/src/lib.rs      |   4 +-
 5 files changed, 127 insertions(+), 36 deletions(-)

diff --git a/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
index fbbac5ed..3fa0060e 100644
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
index af109167..9d38a0b9 100644
--- a/bch_bindgen/src/bkey.rs
+++ b/bch_bindgen/src/bkey.rs
@@ -1,9 +1,9 @@
 #![allow(non_camel_case_types)]
 
 use crate::btree::BtreeIter;
-use crate::c;
 use crate::fs::Fs;
 use crate::printbuf_to_formatter;
+use crate::{bcachefs, c};
 use std::fmt;
 use std::marker::PhantomData;
 use std::mem::transmute;
@@ -96,39 +96,124 @@ impl<'a, 'b> BkeySC<'a> {
                 KEY_TYPE_deleted => deleted,
                 KEY_TYPE_whiteout => whiteout,
                 KEY_TYPE_error => error,
-                KEY_TYPE_cookie => cookie(transmute(self.v)),
-                KEY_TYPE_hash_whiteout => hash_whiteout(transmute(self.v)),
-                KEY_TYPE_btree_ptr => btree_ptr(transmute(self.v)),
-                KEY_TYPE_extent => extent(transmute(self.v)),
-                KEY_TYPE_reservation => reservation(transmute(self.v)),
-                KEY_TYPE_inode => inode(transmute(self.v)),
-                KEY_TYPE_inode_generation => inode_generation(transmute(self.v)),
-                KEY_TYPE_dirent => dirent(transmute(self.v)),
-                KEY_TYPE_xattr => xattr(transmute(self.v)),
-                KEY_TYPE_alloc => alloc(transmute(self.v)),
-                KEY_TYPE_quota => quota(transmute(self.v)),
-                KEY_TYPE_stripe => stripe(transmute(self.v)),
-                KEY_TYPE_reflink_p => reflink_p(transmute(self.v)),
-                KEY_TYPE_reflink_v => reflink_v(transmute(self.v)),
-                KEY_TYPE_inline_data => inline_data(transmute(self.v)),
-                KEY_TYPE_btree_ptr_v2 => btree_ptr_v2(transmute(self.v)),
-                KEY_TYPE_indirect_inline_data => indirect_inline_data(transmute(self.v)),
-                KEY_TYPE_alloc_v2 => alloc_v2(transmute(self.v)),
-                KEY_TYPE_subvolume => subvolume(transmute(self.v)),
-                KEY_TYPE_snapshot => snapshot(transmute(self.v)),
-                KEY_TYPE_inode_v2 => inode_v2(transmute(self.v)),
-                KEY_TYPE_alloc_v3 => inode_v3(transmute(self.v)),
+                KEY_TYPE_cookie => cookie(transmute::<&bcachefs::bch_val, &bcachefs::bch_cookie>(
+                    self.v,
+                )),
+                KEY_TYPE_hash_whiteout => hash_whiteout(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_hash_whiteout,
+                >(self.v)),
+                KEY_TYPE_btree_ptr => btree_ptr(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_btree_ptr,
+                >(self.v)),
+                KEY_TYPE_extent => extent(transmute::<&bcachefs::bch_val, &bcachefs::bch_extent>(
+                    self.v,
+                )),
+                KEY_TYPE_reservation => reservation(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_reservation,
+                >(self.v)),
+                KEY_TYPE_inode => inode(transmute::<&bcachefs::bch_val, &bcachefs::bch_inode>(
+                    self.v,
+                )),
+                KEY_TYPE_inode_generation => inode_generation(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inode_generation,
+                >(self.v)),
+                KEY_TYPE_dirent => dirent(transmute::<&bcachefs::bch_val, &bcachefs::bch_dirent>(
+                    self.v,
+                )),
+                KEY_TYPE_xattr => xattr(transmute::<&bcachefs::bch_val, &bcachefs::bch_xattr>(
+                    self.v,
+                )),
+                KEY_TYPE_alloc => alloc(transmute::<&bcachefs::bch_val, &bcachefs::bch_alloc>(
+                    self.v,
+                )),
+                KEY_TYPE_quota => quota(transmute::<&bcachefs::bch_val, &bcachefs::bch_quota>(
+                    self.v,
+                )),
+                KEY_TYPE_stripe => stripe(transmute::<&bcachefs::bch_val, &bcachefs::bch_stripe>(
+                    self.v,
+                )),
+                KEY_TYPE_reflink_p => reflink_p(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_reflink_p,
+                >(self.v)),
+                KEY_TYPE_reflink_v => reflink_v(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_reflink_v,
+                >(self.v)),
+                KEY_TYPE_inline_data => inline_data(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inline_data,
+                >(self.v)),
+                KEY_TYPE_btree_ptr_v2 => btree_ptr_v2(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_btree_ptr_v2,
+                >(self.v)),
+                KEY_TYPE_indirect_inline_data => indirect_inline_data(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_indirect_inline_data,
+                >(self.v)),
+                KEY_TYPE_alloc_v2 => alloc_v2(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_alloc_v2,
+                >(self.v)),
+                KEY_TYPE_subvolume => subvolume(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_subvolume,
+                >(self.v)),
+                KEY_TYPE_snapshot => snapshot(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_snapshot,
+                >(self.v)),
+                KEY_TYPE_inode_v2 => inode_v2(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inode_v2,
+                >(self.v)),
+                KEY_TYPE_alloc_v3 => inode_v3(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inode_v3,
+                >(self.v)),
                 KEY_TYPE_set => set,
-                KEY_TYPE_lru => lru(transmute(self.v)),
-                KEY_TYPE_alloc_v4 => alloc_v4(transmute(self.v)),
-                KEY_TYPE_backpointer => backpointer(transmute(self.v)),
-                KEY_TYPE_inode_v3 => inode_v3(transmute(self.v)),
-                KEY_TYPE_bucket_gens => bucket_gens(transmute(self.v)),
-                KEY_TYPE_snapshot_tree => snapshot_tree(transmute(self.v)),
-                KEY_TYPE_logged_op_truncate => logged_op_truncate(transmute(self.v)),
-                KEY_TYPE_logged_op_finsert => logged_op_finsert(transmute(self.v)),
-                KEY_TYPE_accounting => accounting(transmute(self.v)),
-                KEY_TYPE_inode_alloc_cursor => inode_alloc_cursor(transmute(self.v)),
+                KEY_TYPE_lru => lru(transmute::<&bcachefs::bch_val, &bcachefs::bch_lru>(self.v)),
+                KEY_TYPE_alloc_v4 => alloc_v4(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_alloc_v4,
+                >(self.v)),
+                KEY_TYPE_backpointer => backpointer(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_backpointer,
+                >(self.v)),
+                KEY_TYPE_inode_v3 => inode_v3(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inode_v3,
+                >(self.v)),
+                KEY_TYPE_bucket_gens => bucket_gens(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_bucket_gens,
+                >(self.v)),
+                KEY_TYPE_snapshot_tree => snapshot_tree(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_snapshot_tree,
+                >(self.v)),
+                KEY_TYPE_logged_op_truncate => logged_op_truncate(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_logged_op_truncate,
+                >(self.v)),
+                KEY_TYPE_logged_op_finsert => logged_op_finsert(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_logged_op_finsert,
+                >(self.v)),
+                KEY_TYPE_accounting => accounting(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_accounting,
+                >(self.v)),
+                KEY_TYPE_inode_alloc_cursor => inode_alloc_cursor(transmute::<
+                    &bcachefs::bch_val,
+                    &bcachefs::bch_inode_alloc_cursor,
+                >(self.v)),
                 KEY_TYPE_MAX => unreachable!(),
             }
         }
diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
index 99c2a5b5..0d8d7303 100644
--- a/bch_bindgen/src/btree.rs
+++ b/bch_bindgen/src/btree.rs
@@ -189,6 +189,7 @@ impl<'t> BtreeNodeIter<'t> {
         }
     }
 
+    #[allow(clippy::should_implement_trait)]
     pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
         unsafe {
             let b = c::bch2_btree_iter_next_node(&mut self.raw);
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
index 7c313921..cc56c298 100644
--- a/bch_bindgen/src/lib.rs
+++ b/bch_bindgen/src/lib.rs
@@ -114,7 +114,7 @@ impl FromStr for c::btree_id {
         let v =
             unsafe { c::match_string(c::__bch2_btree_ids[..].as_ptr(), (-1_isize) as usize, p) };
         if v >= 0 {
-            Ok(unsafe { std::mem::transmute(v) })
+            Ok(unsafe { std::mem::transmute::<i32, bcachefs::btree_id>(v) })
         } else {
             Err(BchToolsErr::InvalidBtreeId)
         }
@@ -130,7 +130,7 @@ impl FromStr for c::bch_bkey_type {
 
         let v = unsafe { c::match_string(c::bch2_bkey_types[..].as_ptr(), (-1_isize) as usize, p) };
         if v >= 0 {
-            Ok(unsafe { std::mem::transmute(v) })
+            Ok(unsafe { std::mem::transmute::<i32, bcachefs::bch_bkey_type>(v) })
         } else {
             Err(BchToolsErr::InvalidBkeyType)
         }
-- 
2.48.1

