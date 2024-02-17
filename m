Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822437CF19
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Feb 2024 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708194046; cv=none; b=DiQk+7Nnj1pzqZkQWRJJK2JuL+ZIlyR0JbrV1wrA3FEcMZmdCgvp+ujeRzBiwSHr9qpV7ndBfqDeiNo6/500hv3/GMoOc0ZT0cCOj7kbZTW73U4oz3TlbWyTelwuW/YNZIW1AQYEF/Z9sKldQ81o+v4zvj/DtFYXAlHJut+Prf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708194046; c=relaxed/simple;
	bh=3mblFLQ2pG6V39TD9gA/im1s0axSdRZ9P1D8KJqUmEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gjL9GyZ3baNK5WyubIHGmMSZWLTfTVBMzIROSkxQLNwaFrQDI2AIADJaOdTPsyj2VkIwAaS7G2xzb/qHPOChsZ4Frse201F+HhDKr3oROA3UbQcqt0De7+3BV8RJ+IyWLnnVIF4IP3og+GwqLL/4brFW/8iiUIcnNH6JCRagQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G8PaN0AZ; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G8PaN0AZ"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c490498729so149395439f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 17 Feb 2024 10:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708194041; x=1708798841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GbbmPlTYA7B7LaLG9bLohxu2FYGiGwGUVGgpSJfor1M=;
        b=G8PaN0AZd0LbyjapyHY5RjSCfSJLjOwMW7PEfFjZx7fpparKrJuwAeiCQUdbW+C3Rd
         GFY2SqqaXIz9Te3E8flrxunpAmtF5e5thguemVNyTiXKGs8eNZVvw1+OYL5Ti0HXrNh9
         UWlnrJFE5NPacTyx1CNgQwEr4KslxYkHlN2duOGLRBZ0ZwCDLDXpUiH5sWObThot4FiX
         F87yI/QT42wPaT/OjCNyrYpJ0F8j2dVuSWGMICO9rFskaDQDIXmLBJtJWGpiQI6GsjJF
         W7SILSomohjijLIPbTIvMpx4dpoiFG8dL2f9BZ9JgNF1k+07cZJJ7KxUboN54ug5v3M0
         8PJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708194041; x=1708798841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GbbmPlTYA7B7LaLG9bLohxu2FYGiGwGUVGgpSJfor1M=;
        b=S+H2b/fvX0tbbAznW2l/fuPpx2Z9iJnkOAwFjW54Ws1Lzm5SvV5FTzKRuxUAQyHmWu
         cBQ888Ui+GSJLrVZU5tehYEM8RWPgkDfVLdVwk9AFQGCspta76Ur8ok30FD1mnATGceP
         IQbSOQH+Bhw6DqlVzdTX27cW8ASrzi7T7+oayIxflIMjxd+FT5y4ihrZjxbV0o5vVATq
         WDh7mnjlULwv25k+4Khvt/wNGb4lhDdxOcu6Y0nVyCjSmZrZB4qZGdyW7tCvVk0f/Kyz
         DEbou6XqzHNlyWGJgm3Uga0ElEbPa/xtn6tH2ZZ4ndTkVRvdtdh+OFW5zH0BUnzFQndr
         CAgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYqcaaZ4FYlU+5MtkVxjuAgsjo62jAVkAQjMjVsycUZj6lhRpIBEKyj/qWwSTKlOihRLDJF1AHGCw0q9IU2a3aoUqnDf0UJI9Z0Hw25lM=
X-Gm-Message-State: AOJu0Yy0XAT1vaZ5KQYOxkAs/7f6Le81yyJyQa0opmg4rJpBz2iYLTsM
	kgKa779qNTfWAv1OgI7EawkSmopVOm21GtvX6OfG4fgyXEPBkAeV
X-Google-Smtp-Source: AGHT+IFecEuAlTos5lYEPDdgt5beyj6gvNDd0ZB7uwijbTUksckG/g+ODihTSwJgWNBVcy6mESGStA==
X-Received: by 2002:a6b:6b08:0:b0:7c4:9047:b9b8 with SMTP id g8-20020a6b6b08000000b007c49047b9b8mr8223281ioc.3.1708194041102;
        Sat, 17 Feb 2024 10:20:41 -0800 (PST)
Received: from fedora-laptop.. ([206.85.159.137])
        by smtp.gmail.com with ESMTPSA id k12-20020a056638140c00b00473c5fe7571sm622596jad.161.2024.02.17.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Feb 2024 10:20:40 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bch_bindgen: fix packed and aligned structs on i686, ppc64
Date: Sat, 17 Feb 2024 11:20:25 -0700
Message-ID: <20240217182025.10698-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch addresses build issues with bch_bindgen on architectures
where the natural alignment of u64 is 4 instead of 8, such as i686 and
ppc64. The issue arises from rustc's refusing to compile structs with a
"packed" attribute that have members with an explicit "align(N)"
attribute.

rust-bindgen generally does not place "align(N)" attributes on types
when it is redundant with the type's natural alignment. There are a few
types in bcachefs with "__aligned(8)" in C where the type's natural
alignment is 8 except on architectures like those mentioned above where
it is 4. rust-bindgen places the "align(8)" attribute on these types,
for those architectures. The affected types include:

- bch_csum
- bch_sb_layout
- bch_ioctl_data_progress

bch_ioctl_data_progress, and all types that depend on it, are not used
on the Rust side currently and bindings are only generated for them
because they are covered by `.allowlist_type("bch_.*")` in
bch_bindgen/build.rs. This patch resolves the build failure for this
type by excluding it from bch_bindgen. If/when accessing this type in
Rust is needed, a decision can be made then about how to represent its
layout in Rust.

bch_csum and bch_sb_layout, and types that depend on them, are currently
used in Rust so they can't be excluded. This patch addresses these types
by stripping off the "packed" attribute in Rust on types that embed
these types, since that attribute happens to not be necessary for proper
layout.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---

As noted in the TODO item in the comments below, it would be nice to
make arch-specific modifications only occur when compiling for that
target arch. This isn't strictly required: the layout of the affected
types remains correct on x86_64 and aarch64 (this can be verified by
running `cargo test --manifest-path bch_bindgen/Cargo.toml).

It is likely possible to do this by referencing some enviroment
variables set by Cargo for the target arch, but I want to test that more
fully before I submit a patch that adds that in. In the meantime, this
patch as-is should hopefully resolve the build failures and hopefully
the impact to already working arches is acceptable.

 bch_bindgen/build.rs | 45 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/bch_bindgen/build.rs b/bch_bindgen/build.rs
index 1baa266..0329f1a 100644
--- a/bch_bindgen/build.rs
+++ b/bch_bindgen/build.rs
@@ -64,6 +64,7 @@ fn main() {
         .allowlist_function("printbuf.*")
         .blocklist_type("rhash_lock_head")
         .blocklist_type("srcu_struct")
+        .blocklist_type("bch_ioctl_data.*")
         .allowlist_var("BCH_.*")
         .allowlist_var("KEY_SPEC_.*")
         .allowlist_var("Fix753_.*")
@@ -121,14 +122,42 @@ fn main() {
 }
 
 // rustc has a limitation where it does not allow structs with a "packed" attribute to contain a
-// member with an "align(N)" attribute. There is one type in bcachefs with this issue:
-// struct btree_node.
+// member with an "align(N)" attribute. There are a few types in bcachefs with this problem. We can
+// "fix" these types by stripping off "packed" from the outer type, or "align(N)" from the inner
+// type. For all of the affected types, stripping "packed" from the outer type happens to preserve
+// the same layout in Rust as in C.
 //
-// Luckily, it happens that this type does not need the "packed(N)" attribute in Rust to have the
-// same ABI as C, so we can strip it off the bindgen output.
+// Some types are only affected on attributes on architectures where the natural alignment of u64
+// is 4 instead of 8, for example i686 or ppc64: struct bch_csum and struct bch_sb_layout have
+// "align(8)" added on such architecutres. These types are included by several "packed" types:
+//   - bch_extent_crc128
+//   - jset
+//   - btree_node_entry
+//   - bch_sb
+//
+// TODO: find a way to conditionally include arch-specific modifications when compiling for that
+// target arch. Regular conditional compilation won't work here since build scripts are always
+// compiled for the host arch, not the target arch, so that won't work when cross-compiling.
 fn packed_and_align_fix(bindings: std::string::String) -> std::string::String {
-    bindings.replace(
-        "#[repr(C, packed(8))]\npub struct btree_node {",
-        "#[repr(C, align(8))]\npub struct btree_node {",
-    )
+    bindings
+        .replace(
+            "#[repr(C, packed(8))]\npub struct btree_node {",
+            "#[repr(C, align(8))]\npub struct btree_node {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc128 {",
+            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc128 {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\npub struct jset {",
+            "#[repr(C, align(8))]\npub struct jset {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\npub struct btree_node_entry {",
+            "#[repr(C, align(8))]\npub struct btree_node_entry {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\npub struct bch_sb {",
+            "#[repr(C, align(8))]\npub struct bch_sb {",
+        )
 }
-- 
2.43.0

