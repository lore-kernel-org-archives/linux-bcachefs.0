Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C9080034
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 May 2024 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715289258; cv=none; b=P0GT706iOl1ke0ECWBObLzAIT0EN0FKE6sVTDId/3DhBtS/0uh+5kqMAcTMe5LUankUrcBIMw0ABsx3LLFOeXkLsVIc4Da2NbxZT9y16rka56wkSPpUoAWF6y7kA5u5YwZVHv/AJSKrizVRS8EDAE1G8bmKxVxQ1Rh4gsfRLUWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715289258; c=relaxed/simple;
	bh=IISzqa5CtLE1dbhRTi3YZI/guW/1kbzwq+DFrmQ1mH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AefIkdI6u9SA6Xfr0HMMHIS9R0306NAfl5mXHYD6a0U8WAOX8iDHOfS/fqwIRyLkKQGtF9FuJ8+5BxJzPMhebplz+sjEc97rw80ciEraIRH6CGt6iRGYRyxqlz/pnY/MfTyoZcjkNNjE1MXrvuiSk4ZYLKsU5Mi86r7ToL+KzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfZJQoLl; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfZJQoLl"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6edc61d0ff6so1216219b3a.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 May 2024 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715289255; x=1715894055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kc2l2zP95uesMkdDVK6tu1Yzr91y/P93YywTiKj+VRc=;
        b=gfZJQoLlv1CkWRgadvf/gBw1sSI7mJ7PavKhPDJit8X2VfSnWvpx1Xtnzpa2ENKwcI
         spqScOaGu3v4OJfczgwFK8y2/NoQolAfvyRGic6rjv6BhyXjNxmdWpzUFGimuJVxNS8Z
         K69FBknUR/x9HDeodLsx77/a66w39SeGExsE3+fTM4FHY35iGS42Gz8Z3Q65MJvfbH0Z
         45Qil+PlZ4ywzkj0jD99qmfqKi8VeZQ4+QcERGV+1hPd2dJVqFWxKY3b6zfnI28fKgVp
         +DENtV89kMrdoYINGePyc3Kfd2iN4tgE4JK1JgrmYQRfQPGnmKtUUhMP+2Nxtc7SaKxZ
         R+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715289255; x=1715894055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kc2l2zP95uesMkdDVK6tu1Yzr91y/P93YywTiKj+VRc=;
        b=r5BaWh12al9qNPk1D9CcOQ9eKNomaKhzQmDkWHOF5YDOBEQKU9snpJCkSeThCxzVDZ
         RgNdM3OLou2bwIeQZNUpFITIIVpU2Tj3t+bWmolzvV9Myo+/Ns61scvQybS+UxZsMJU1
         aBNuDm1iWVbiZfvPe18ZG/CUPeu603qyFGFCYnGYIhgHIcC40U2KKpyzPls4/6sM4Djf
         FufbieO3ntSWiCtakcSKnqMy4Mmlhs1cbBvOBHm11PTRnDBG0ifHSEQD90IdR6YUVXRP
         wfSIVrOQDiqbk5oK4/azxkGPrP2J/7RiaFX9duraEectB9u3W7dPv5O/kngoG5JwwF+S
         OJ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9RxtuDO6RgNB56C33Lc3cRg/fhO8Tj/AHB/FIuHK0ETwV5wcDYFxujcUZPcy/V1mEdqKC4dPC/cPOILUzoIqXg8VGYmfCxxn2aPaRv50=
X-Gm-Message-State: AOJu0Ywe0rO4QPopy8pvbykpWrPUZZgB5al3yk8EpDYsVtCODvI+xaCA
	BOBqgmfP0dXxxBVLz8w9CuouMi23okSPKwtdK35R9J9JNMol9pJUSRS5IA==
X-Google-Smtp-Source: AGHT+IHNIjlK4G6m17I7ZTnnZT2KRmVmdUPaNKCRlHVPNMwAbpC1AjvzvrGFstMGLHj7R8TTVi4kag==
X-Received: by 2002:a05:6a00:178a:b0:6ed:435f:ec9b with SMTP id d2e1a72fcca58-6f4e02cec87mr675587b3a.20.1715289255387;
        Thu, 09 May 2024 14:14:15 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2af2a42sm1786973b3a.149.2024.05.09.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 14:14:14 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] add "bkey-type" option to list command
Date: Thu,  9 May 2024 15:14:06 -0600
Message-ID: <20240509211406.41846-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only bkeys of the specified type will be printed.

Also, this reworks the error type in bch_bindgen to be able to
represent other kinds of error than just "invalid btree id".

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 bch_bindgen/src/lib.rs | 46 ++++++++++++++++++++++++++++++++----------
 src/commands/list.rs   | 11 ++++++++++
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
index d903735e..b31b1a61 100644
--- a/bch_bindgen/src/lib.rs
+++ b/bch_bindgen/src/lib.rs
@@ -79,19 +79,27 @@ pub fn path_to_cstr<P: AsRef<Path>>(p: P) -> CString {
 use std::error::Error;
 
 #[derive(Debug)]
-pub struct InvalidBtreeId;
+pub enum BchToolsErr {
+    InvalidBtreeId,
+    InvalidBkeyType,
+    InvalidBpos,
+}
 
-impl fmt::Display for InvalidBtreeId {
+impl fmt::Display for BchToolsErr {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
-        write!(f, "invalid btree id")
+        match self {
+            BchToolsErr::InvalidBtreeId => write!(f, "invalid btree id"),
+            BchToolsErr::InvalidBkeyType => write!(f, "invalid bkey type"),
+            BchToolsErr::InvalidBpos => write!(f, "invalid bpos"),
+        }
     }
 }
 
-impl Error for InvalidBtreeId {
+impl Error for BchToolsErr {
 }
 
 impl FromStr for c::btree_id {
-    type Err = InvalidBtreeId;
+    type Err = BchToolsErr;
 
     fn from_str(s: &str) -> Result<Self, Self::Err> {
         let s = CString::new(s).unwrap();
@@ -101,7 +109,23 @@ impl FromStr for c::btree_id {
         if v >= 0 {
             Ok(unsafe { std::mem::transmute(v) })
         } else {
-            Err(InvalidBtreeId)
+            Err(BchToolsErr::InvalidBtreeId)
+        }
+    }
+}
+
+impl FromStr for c::bch_bkey_type {
+    type Err = BchToolsErr;
+
+    fn from_str(s: &str) -> Result<Self, Self::Err> {
+        let s = CString::new(s).unwrap();
+        let p = s.as_ptr();
+
+        let v = unsafe {c::match_string(c::bch2_bkey_types[..].as_ptr(), (-(1 as isize)) as usize, p)};
+        if v >= 0 {
+            Ok(unsafe { std::mem::transmute(v) })
+        } else {
+            Err(BchToolsErr::InvalidBkeyType)
         }
     }
 }
@@ -134,7 +158,7 @@ impl fmt::Display for Bpos {
 }
 
 impl FromStr for c::bpos {
-    type Err = InvalidBtreeId;
+    type Err = BchToolsErr;
 
     fn from_str(s: &str) -> Result<Self, Self::Err> {
         if s == "POS_MIN" {
@@ -150,12 +174,12 @@ impl FromStr for c::bpos {
         }
 
         let mut fields = s.split(':');
-        let ino_str = fields.next().ok_or(InvalidBtreeId)?;
-        let off_str = fields.next().ok_or(InvalidBtreeId)?;
+        let ino_str = fields.next().ok_or(BchToolsErr::InvalidBpos)?;
+        let off_str = fields.next().ok_or(BchToolsErr::InvalidBpos)?;
         let snp_str = fields.next();
 
-        let ino: u64    = ino_str.parse().map_err(|_| InvalidBtreeId)?;
-        let off: u64    = off_str.parse().map_err(|_| InvalidBtreeId)?;
+        let ino: u64    = ino_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
+        let off: u64    = off_str.parse().map_err(|_| BchToolsErr::InvalidBpos)?;
         let snp: u32    = snp_str.map(|s| s.parse().ok()).flatten().unwrap_or(0);
 
         Ok(c::bpos { inode: ino, offset: off, snapshot: snp })
diff --git a/src/commands/list.rs b/src/commands/list.rs
index 0ed6be05..fd61a516 100644
--- a/src/commands/list.rs
+++ b/src/commands/list.rs
@@ -21,6 +21,13 @@ fn list_keys(fs: &Fs, opt: Cli) -> anyhow::Result<()> {
             break;
         }
 
+        if let Some(ty) = opt.bkey_type {
+            if k.k.type_ != ty as u8 {
+                iter.advance();
+                continue;
+            }
+        }
+
         println!("{}", k.to_text(fs));
         iter.advance();
     }
@@ -97,6 +104,10 @@ pub struct Cli {
     #[arg(short, long, default_value_t=bcachefs::btree_id::BTREE_ID_extents)]
     btree:      bcachefs::btree_id,
 
+    /// Bkey type to list
+    #[arg(short='k', long)]
+    bkey_type:      Option<bcachefs::bch_bkey_type>,
+
     /// Btree depth to descend to (0 == leaves)
     #[arg(short, long, default_value_t=0)]
     level:      u32,
-- 
2.44.0

