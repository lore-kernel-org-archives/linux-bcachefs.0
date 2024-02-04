Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA052556E
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Feb 2024 20:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707079773; cv=none; b=do/zBNXC1kDSTd0G5u4zIHXt9i68HiOqbHMSNsAJq7Dd+kUrU3RbCz8zF8XOhbrbF8lyhdpLFHypCZDgbE5P6ig2X0jFuItZPo8cie72afgtgQub+NqfRdZ4W1sNOt1y4IQi+TUfJJPRHt5Qv4xMGHC/ZBSKiF6LM+wNC30TFuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707079773; c=relaxed/simple;
	bh=EBqDNcRoP3kUPXU7ERLjpqpFP2Hde1D+DEqfs87HQXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eRvpEgeOZ5Ru8WcAe7Yxsrkff0Xttf5tte44R1ZgKpKZ5/cCPiiV0J7w+r42PB851q48h3xfvEWJlE9aHKKgONsT9SN1WdHC4HAs/Lf7MONBWULwLbSQUh9MJW+PSVorC4SaRBvOnu9kNegIwnI8wKxkABIWBVzwtNdzQmk/Iu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DX6/cOM9; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DX6/cOM9"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bed9f5d35dso159703239f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 04 Feb 2024 12:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707079769; x=1707684569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C9vNtKM8DqygIqAKl16TYUucp9p/LzvgLyz6f5GCjAs=;
        b=DX6/cOM9uoRfvLzjW1XvQnczxw2lj9NS0y9TIfKAc/VpV+KMRxG04daulp5OR7vr/4
         jvSdd2BhmmozVTyGGzKMJlbD5lQkPbIsrOTXnxx1MorsK30R7JKkc+oM9t8eDeO2+14T
         E6nCzYSJzBRVygWF+JWlZ1a4uOf+xSZlgy3T1XmUc95o1uUzpa13fWuQ9LiaNYmiYP4Z
         Pg46/c09r7vgk4AOvxmlosWXJIydXhbvAVdN4HvEk1VNbiNEA+M/SHIG+1b3Qjv3grak
         GUIJA3OhMb6hRGBi1B14OVHRVE9saMAxCvizdtgRjRVv3NwSOpxorrZ9GQ6IWePc6r2o
         Gj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707079769; x=1707684569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9vNtKM8DqygIqAKl16TYUucp9p/LzvgLyz6f5GCjAs=;
        b=jqpNv9aPS3hMkypBqk+ysCs9YVZWktF6jF7IMCR5HGc4obmJGgQt3D3sVA1Xi1HTN3
         a8YUojEGZjYR+Piek/b66b9nuVNmEZFz2JA+LWyVL+9AhC/l1fRcN7HzfZgb+QdUHcwZ
         vVHVVlSF5xk81nhc1ACOjhxIcKQpBQYrpcmWqkqpVsKlty6ncbB72mAJ3+WNzOUEIiXZ
         Cq52expclb4L5KNKPFgJ3GmuxX6eWld2SjAYllJjMcV6KXQ9ISN8GR8FHIPhWWXECiwq
         ZONj0XfNWbYzAXQiBuHi8xCoY6lMWS9w34MU/VUmWANCj7WV/stiKpGZmXPNgP7DCh1e
         w9sQ==
X-Gm-Message-State: AOJu0Yy0JJZQPEyWZngcMHJ+avncZtvqutwxR6xOx3YHZhjCG0N4VY9D
	CXiF9RCOF0DUcSsrNA01B2/xpeyCN9F3nILYwUtQLkYieauzlNSIDn2JYaFiFlM=
X-Google-Smtp-Source: AGHT+IG0kIKQkKoNf11oeFseORSsEdlQKDOao2TBSYggURRgs4gEgeP9RdDC0uycTRngHbPeX7iXiA==
X-Received: by 2002:a5e:a617:0:b0:7bf:5458:51a3 with SMTP id q23-20020a5ea617000000b007bf545851a3mr11686693ioi.6.1707079769403;
        Sun, 04 Feb 2024 12:49:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV8y9XSENBbzSRd2jksg00gue54hvwhk3CX3EB9WO5VvpqBPdXDMylCEUgFRtFqdoCJK+FnGKPiHMPwrEhS9G44+iVaIMNN2hH0gxIACtYKYzW0wqDb48qnbgIlJClo5P672g==
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id z135-20020a6bc98d000000b007bf3754d792sm1847546iof.19.2024.02.04.12.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 12:49:29 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] rust: update bindgen to 0.69.4; remove custom type modifications
Date: Sun,  4 Feb 2024 13:49:23 -0700
Message-ID: <20240204204923.332908-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This updates rust-bindgen to version 0.69.4 which includes the patch
199bee441ad0: "try to avoid #[repr(packed)] when align is needed". With
this patch, bindgen generates code that is both ABI-correct and can be
compiled by rustc, for 3 bcachefs types:

- bkey
- bch_extent_crc32
- bch_extent_ptr

This allows us to remove the custom treatment for these three types.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock             | 21 ++++++++++++---------
 bch_bindgen/Cargo.toml |  2 +-
 bch_bindgen/build.rs   | 43 +++++++++---------------------------------
 3 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/Cargo.lock b/Cargo.lock
index bcbdbc5..9987974 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -119,17 +119,17 @@ dependencies = [
 
 [[package]]
 name = "bindgen"
-version = "0.69.2"
+version = "0.69.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a4c69fae65a523209d34240b60abe0c42d33d1045d445c0839d8a4894a736e2d"
+checksum = "a00dc851838a2120612785d195287475a3ac45514741da670b735818822129a0"
 dependencies = [
  "bitflags 2.4.2",
  "cexpr",
  "clang-sys",
+ "itertools",
  "lazy_static",
  "lazycell",
  "log",
- "peeking_take_while",
  "prettyplease",
  "proc-macro2",
  "quote",
@@ -332,6 +332,15 @@ dependencies = [
  "windows-sys 0.52.0",
 ]
 
+[[package]]
+name = "itertools"
+version = "0.12.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ba291022dbbd398a455acf126c1e341954079855bc60dfdda641363bd6922569"
+dependencies = [
+ "either",
+]
+
 [[package]]
 name = "lazy_static"
 version = "1.4.0"
@@ -425,12 +434,6 @@ version = "1.0.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "de3145af08024dea9fa9914f381a17b8fc6034dfb00f3a84013f7ff43f29ed4c"
 
-[[package]]
-name = "peeking_take_while"
-version = "0.1.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "19b17cddbe7ec3f8bc800887bab5e717348c95ea2ca0b1bf0837fb964dc67099"
-
 [[package]]
 name = "pkg-config"
 version = "0.3.29"
diff --git a/bch_bindgen/Cargo.toml b/bch_bindgen/Cargo.toml
index fcc4668..63be4f3 100644
--- a/bch_bindgen/Cargo.toml
+++ b/bch_bindgen/Cargo.toml
@@ -19,4 +19,4 @@ paste = "1.0.11"
 
 [build-dependencies]
 pkg-config = "0.3"
-bindgen = "0.69.2"
+bindgen = "0.69.4"
diff --git a/bch_bindgen/build.rs b/bch_bindgen/build.rs
index c9a90fc..1baa266 100644
--- a/bch_bindgen/build.rs
+++ b/bch_bindgen/build.rs
@@ -120,40 +120,15 @@ fn main() {
         .expect("Writing to output file failed for: `keyutils.rs`");
 }
 
-// rustc has a limitation where it does not allow structs to have both a "packed" and "align"
-// attribute. This means that bindgen cannot copy all attributes from some C types, like struct
-// bkey, that are both packed and aligned.
+// rustc has a limitation where it does not allow structs with a "packed" attribute to contain a
+// member with an "align(N)" attribute. There is one type in bcachefs with this issue:
+// struct btree_node.
 //
-// bindgen tries to handle this situation smartly and for many types it will only apply a
-// "packed(N)" attribute if that is good enough. However, there are a few types where bindgen
-// does end up generating both a packed(N) and align(N) attribute. These types can't be compiled
-// by rustc.
-//
-// To work around this, we can remove either the "packed" or "align" attribute. It happens that
-// for all the types with this problem in bcachefs, removing the "packed" attribute and keeping
-// the "align" attribute results in a type with the correct ABI.
-//
-// This function applies that transformation to the following bcachefs types that need it:
-//   - bkey
-//   - bch_extent_crc32
-//   - bch_extent_ptr
-//   - btree_node
+// Luckily, it happens that this type does not need the "packed(N)" attribute in Rust to have the
+// same ABI as C, so we can strip it off the bindgen output.
 fn packed_and_align_fix(bindings: std::string::String) -> std::string::String {
-    bindings
-        .replace(
-            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bkey {",
-            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bkey {",
-        )
-        .replace(
-            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc32 {",
-            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc32 {",
-        )
-        .replace(
-            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_ptr {",
-            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_ptr {",
-        )
-        .replace(
-            "#[repr(C, packed(8))]\npub struct btree_node {",
-            "#[repr(C, align(8))]\npub struct btree_node {",
-        )
+    bindings.replace(
+        "#[repr(C, packed(8))]\npub struct btree_node {",
+        "#[repr(C, align(8))]\npub struct btree_node {",
+    )
 }
-- 
2.43.0

