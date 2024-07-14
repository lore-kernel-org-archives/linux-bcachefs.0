Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD87136E37
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987400; cv=none; b=ruZu3tZ1BmRV4A8nltN8S3G9yrps1kgEWPofGFc6jqm+sCS2ch6Y5s3/MTnwHMUuYWJSyDFxOBqVjqwqheJ+pHd663pCJNk5r9Cj1Vw6cFCOsRLGF7MzjDaRbD7mZqLlXOFsAd6e2nxsCJmhdE2QczLkPQKxIWb8KiSaGkQrkCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987400; c=relaxed/simple;
	bh=k/PTbmF5c9aUQ2yLx0X78B5uC34ZUUTGUk0HIRlWILM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcL6/4RrqefsyrHN/ivQvdpsehddXzTPyFiOZf08VCh4JVgZfcMbOeC0QN0YAsrlEow7KUOov5l/BpyI6vcPm/QJQpvbGyIjdrgyXF7OfcZQaVK8rERkK5qMHC0CDXlI5tYi1VT9c7DrKxi9XwCgtdhnFu7ChXCbi55MPE2fNyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/N1aRsQ; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/N1aRsQ"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7f70a708f8aso161764539f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987397; x=1721592197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NojEKfJfD6RjVAuOo25Wfoex1QuQPV6cg7fx9DTumis=;
        b=j/N1aRsQXCjueAgReQPrhMvuTA6n+OdNpMWwNRbfMM9VcV9oWJ7r+uXLrt5ea0ebiN
         liNBGOPOIhAcVvpKN0lSZ1uJWmvW2fVmcYj+Gg7Qnv9Ndc9TD6O+cW8WaQXgBXtiFtYg
         Ki26Ziv87bXQ6uNqUHD1FRGlAm+4QIF+DisCwP3yPi7xR7Ehgvetg3ga1rHg3wYoe0vi
         QqM/WvNZSPgwTL6yQd7xnDKKFEuLAO6EwqkwLKxVwnupynhO4EBKuj3sl00x6dLCt6Si
         kCtXDRABmXx2ak1gj6pwZoxHnNaC8/SHshyFqBDbEtaR5FMUQ0xqqSrktnysgoRSuryd
         ousg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987397; x=1721592197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NojEKfJfD6RjVAuOo25Wfoex1QuQPV6cg7fx9DTumis=;
        b=ED/MftnUetPNmwja2f0uZSIKCFO3jscr6dUd0syZjI13QUxkKojTAS9ggw8z+9Pk0J
         vnhN7ds31fuSBXMdiqXLduwBfrqdggaroPLr/53FvMKppsGAXlHAPELikAMwH6w3j4+v
         PpSWpVf99hJHtcncHtc8+rbgcdflZdiwM695dAWTsu7YXcYJdmh75LKDz2+CtK+nSBqq
         ZnOxcDQrzA72DPPco3J4rSSqFXHqhXiXDjjON+0bKSFosIH+H13mEdNDCcGYfsHh7k5F
         Cs7NZxuH3bQK0ClDL1Mgg7OXQtzkkHBe5IORhwmDZO5mnwDyifuCqGn20ndyhJcdqqXt
         zRWg==
X-Forwarded-Encrypted: i=1; AJvYcCUP7EKDtIPY0Zozk6L7bLvjj8HoXTmYychMwZac2zVg+JfNh3oH6S0/n/8yeQxFoI6+KBYbdcxp5VN1C/t73KYvL9oP1wZIDvsjMwB/qPc=
X-Gm-Message-State: AOJu0YwFuhSogph9KHUAqpt/c6cTaBoMYM8QojMASSBy7q8TQsTVtDo4
	kyLgbFMJRMOV3hmx6p7njJMBpvSi5DWxF+CXIx9iq5Mc7/w0Qq5Y
X-Google-Smtp-Source: AGHT+IGCrClb6XTxfiPmRmeI29t8F7VhXCiXUnn5cMAIt5Ko+/fYr2ctk+ty5NLuSmmQPfjKrmwivg==
X-Received: by 2002:a6b:5a19:0:b0:805:b510:92a2 with SMTP id ca18e2360f4ac-805b51093e0mr1308460839f.19.1720987397068;
        Sun, 14 Jul 2024 13:03:17 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:03:16 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 3/5] introduce "list_bkeys" command
Date: Sun, 14 Jul 2024 14:02:24 -0600
Message-ID: <20240714200226.746471-4-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240714200226.746471-1-tahbertschinger@gmail.com>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces a new command, "list_bkeys", which is used to list the
known bkey types as well as their fields. This will be used by debug
tooling introduced in a subsequent change.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock                       | 141 ++++++++++++++
 Cargo.toml                       |   4 +
 src/bcachefs.rs                  |   4 +-
 src/commands/debug/bkey_types.rs | 320 +++++++++++++++++++++++++++++++
 src/commands/debug/mod.rs        |   9 +
 src/commands/mod.rs              |   2 +
 6 files changed, 478 insertions(+), 2 deletions(-)
 create mode 100644 src/commands/debug/bkey_types.rs
 create mode 100644 src/commands/debug/mod.rs

diff --git a/Cargo.lock b/Cargo.lock
index 9b781755..b9e35816 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2,6 +2,12 @@
 # It is not intended for manual editing.
 version = 3
 
+[[package]]
+name = "adler"
+version = "1.0.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f26201604c87b1e01bd3d98f8d5d9a8fcbb815e8cedb41ffccbeb4bf593a35fe"
+
 [[package]]
 name = "aho-corasick"
 version = "1.1.3"
@@ -84,8 +90,12 @@ dependencies = [
  "either",
  "env_logger",
  "errno 0.2.8",
+ "gimli",
  "libc",
  "log",
+ "memmap2",
+ "nom",
+ "object",
  "rpassword",
  "strum",
  "strum_macros",
@@ -244,6 +254,26 @@ version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "0b6a852b24ab71dffc585bcb46eaf7959d175cb865a7152e35b348d1b2960422"
 
+[[package]]
+name = "crc32fast"
+version = "1.4.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a97769d94ddab943e4510d138150169a2758b5ef3eb191a9ee688de3e23ef7b3"
+dependencies = [
+ "cfg-if",
+]
+
+[[package]]
+name = "derive_more"
+version = "0.99.18"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5f33878137e4dafd7fa914ad4e259e18a4e8e532b9617a2d0150262bf53abfce"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "syn",
+]
+
 [[package]]
 name = "either"
 version = "1.13.0"
@@ -261,6 +291,12 @@ dependencies = [
  "termcolor",
 ]
 
+[[package]]
+name = "equivalent"
+version = "1.0.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5443807d6dff69373d433ab9ef5378ad8df50ca6298caf15de6e52e24aaf54d5"
+
 [[package]]
 name = "errno"
 version = "0.2.8"
@@ -292,12 +328,45 @@ dependencies = [
  "libc",
 ]
 
+[[package]]
+name = "fallible-iterator"
+version = "0.3.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "2acce4a10f12dc2fb14a218589d4f1f62ef011b2d0cc4b3cb1bba8e94da14649"
+
+[[package]]
+name = "flate2"
+version = "1.0.30"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5f54427cfd1c7829e2a139fcefea601bf088ebca651d2bf53ebc600eac295dae"
+dependencies = [
+ "crc32fast",
+ "miniz_oxide",
+]
+
+[[package]]
+name = "gimli"
+version = "0.29.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "40ecd4077b5ae9fd2e9e169b102c6c330d0605168eb0e8bf79952b256dbefffd"
+dependencies = [
+ "fallible-iterator",
+ "indexmap",
+ "stable_deref_trait",
+]
+
 [[package]]
 name = "glob"
 version = "0.3.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "d2fabcfbdc87f4758337ca535fb41a6d701b65693ce38287d856d1674551ec9b"
 
+[[package]]
+name = "hashbrown"
+version = "0.14.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "e5274423e17b7c9fc20b6e7e208532f9b19825d82dfd615708b70edd83df41f1"
+
 [[package]]
 name = "heck"
 version = "0.5.0"
@@ -319,6 +388,16 @@ dependencies = [
  "windows-sys 0.52.0",
 ]
 
+[[package]]
+name = "indexmap"
+version = "2.2.6"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "168fb715dda47215e360912c096649d23d58bf392ac62f73919e831745e40f26"
+dependencies = [
+ "equivalent",
+ "hashbrown",
+]
+
 [[package]]
 name = "is-terminal"
 version = "0.4.12"
@@ -401,6 +480,15 @@ version = "2.7.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "78ca9ab1a0babb1e7d5695e3530886289c18cf2f87ec19a575a0abdce112e3a3"
 
+[[package]]
+name = "memmap2"
+version = "0.9.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "fe751422e4a8caa417e13c3ea66452215d7d63e19e604f4980461212f3ae1322"
+dependencies = [
+ "libc",
+]
+
 [[package]]
 name = "memoffset"
 version = "0.8.0"
@@ -416,6 +504,15 @@ version = "0.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a"
 
+[[package]]
+name = "miniz_oxide"
+version = "0.7.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b8a240ddb74feaf34a79a7add65a741f3167852fba007066dcac1ca548d89c08"
+dependencies = [
+ "adler",
+]
+
 [[package]]
 name = "nom"
 version = "7.1.3"
@@ -426,6 +523,17 @@ dependencies = [
  "minimal-lexical",
 ]
 
+[[package]]
+name = "object"
+version = "0.35.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b8ec7ab813848ba4522158d5517a6093db1ded27575b070f4177b8d12b41db5e"
+dependencies = [
+ "flate2",
+ "memchr",
+ "ruzstd",
+]
+
 [[package]]
 name = "once_cell"
 version = "1.19.0"
@@ -547,12 +655,35 @@ version = "1.0.17"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "955d28af4278de8121b7ebeb796b6a45735dc01436d898801014aced2773a3d6"
 
+[[package]]
+name = "ruzstd"
+version = "0.6.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5174a470eeb535a721ae9fdd6e291c2411a906b96592182d05217591d5c5cf7b"
+dependencies = [
+ "byteorder",
+ "derive_more",
+ "twox-hash",
+]
+
 [[package]]
 name = "shlex"
 version = "1.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"
 
+[[package]]
+name = "stable_deref_trait"
+version = "1.2.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a8f112729512f8e442d81f95a8a7ddf2b7c6b8a1a6f509a95864142b30cab2d3"
+
+[[package]]
+name = "static_assertions"
+version = "1.1.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a2eb9349b6444b326872e140eb1cf5e7c522154d69e7a0ffb0fb81c06b37543f"
+
 [[package]]
 name = "strsim"
 version = "0.11.1"
@@ -611,6 +742,16 @@ dependencies = [
  "windows-sys 0.48.0",
 ]
 
+[[package]]
+name = "twox-hash"
+version = "1.6.3"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "97fee6b57c6a41524a810daee9286c02d7752c4253064d0b05472833a438f675"
+dependencies = [
+ "cfg-if",
+ "static_assertions",
+]
+
 [[package]]
 name = "udev"
 version = "0.7.0"
diff --git a/Cargo.toml b/Cargo.toml
index d3b0e753..50527ea7 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -25,6 +25,10 @@ byteorder = "1.3"
 strum = { version = "0.26", features = ["derive"] }
 strum_macros = "0.26"
 zeroize = { version = "1", features = ["std", "zeroize_derive"] }
+gimli = "0.29.0"
+object = "0.35.0"
+memmap2 = "0.9.4"
+nom = "7.1.3"
 
 [dependencies.env_logger]
 version = "0.10"
diff --git a/src/bcachefs.rs b/src/bcachefs.rs
index 26422abd..4b8cef49 100644
--- a/src/bcachefs.rs
+++ b/src/bcachefs.rs
@@ -28,9 +28,8 @@ fn handle_c_command(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
 
     let argc: i32 = argv.len().try_into().unwrap();
 
-    let argv: Vec<_> = argv.into_iter().map(|s| CString::new(s).unwrap()).collect();
+    let argv = argv.into_iter().map(|s| CString::new(s).unwrap());
     let mut argv = argv
-        .into_iter()
         .map(|s| Box::into_raw(s.into_boxed_c_str()).cast::<c_char>())
         .collect::<Box<[*mut c_char]>>();
     let argv = argv.as_mut_ptr();
@@ -108,6 +107,7 @@ fn main() -> ExitCode {
             ExitCode::SUCCESS
         }
         "list" => commands::list(args[1..].to_vec()).report(),
+        "list_bkeys" => commands::list_bkeys().report(),
         "mount" => commands::mount(args, symlink_cmd).report(),
         "subvolume" => commands::subvolume(args[1..].to_vec()).report(),
         _ => ExitCode::from(u8::try_from(handle_c_command(args, symlink_cmd)).unwrap()),
diff --git a/src/commands/debug/bkey_types.rs b/src/commands/debug/bkey_types.rs
new file mode 100644
index 00000000..680d4410
--- /dev/null
+++ b/src/commands/debug/bkey_types.rs
@@ -0,0 +1,320 @@
+//! Representation of the bcachefs bkey types, derived from DWARF debug info.
+
+use anyhow::{anyhow, Result};
+use object::{Object, ObjectSection};
+use std::collections::HashSet;
+use std::{borrow, error, fs};
+
+/// A list of the known bcachefs bkey types.
+#[derive(Debug)]
+pub struct BkeyTypes(Vec<BchStruct>);
+
+impl BkeyTypes {
+    pub fn new() -> Self {
+        BkeyTypes(Vec::new())
+    }
+}
+
+impl std::fmt::Display for BkeyTypes {
+    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
+        for bkey in self.0.iter() {
+            for memb in bkey.members.iter() {
+                writeln!(
+                    f,
+                    "{} {} {} {}",
+                    bkey.name, memb.name, memb.size, memb.offset
+                )?;
+            }
+            writeln!(f)?;
+        }
+        Ok(())
+    }
+}
+
+/// The representation of a struct type. The only information we need
+/// is the type's name and a list of its members.
+#[derive(Debug)]
+pub struct BchStruct {
+    name: String,
+    pub members: Vec<BchMember>,
+}
+
+/// The representation of a struct member. We need its name, size, and offset
+/// within the parent struct.
+#[derive(Debug)]
+pub struct BchMember {
+    name: String,
+    size: u64,
+    offset: u64,
+}
+
+// The section data that will be stored in `DwarfSections` and `DwarfPackageSections`.
+#[derive(Default)]
+struct Section<'data> {
+    data: borrow::Cow<'data, [u8]>,
+}
+
+type Reader<'data> = gimli::EndianSlice<'data, gimli::RunTimeEndian>;
+
+fn process_file(
+    object: &object::File,
+    struct_list: &mut BkeyTypes,
+) -> Result<(), Box<dyn error::Error>> {
+    let endian = if object.is_little_endian() {
+        gimli::RunTimeEndian::Little
+    } else {
+        gimli::RunTimeEndian::Big
+    };
+
+    fn load_section<'data>(
+        object: &object::File<'data>,
+        name: &str,
+    ) -> Result<Section<'data>, Box<dyn error::Error>> {
+        Ok(match object.section_by_name(name) {
+            Some(section) => Section {
+                data: section.uncompressed_data()?,
+            },
+            None => Default::default(),
+        })
+    }
+
+    let dwarf_sections = gimli::DwarfSections::load(|id| load_section(object, id.name()))?;
+
+    let dwarf = dwarf_sections
+        .borrow(|section| gimli::EndianSlice::new(borrow::Cow::as_ref(&section.data), endian));
+
+    let mut bkey_types = HashSet::new();
+    load_bkey_types(&mut bkey_types);
+
+    let mut iter = dwarf.units();
+    while let Some(header) = iter.next()? {
+        let unit = dwarf.unit(header)?;
+        process_unit(&dwarf, &unit, struct_list, &mut bkey_types)?;
+    }
+
+    Ok(())
+}
+
+fn load_bkey_types(bkey_types: &mut HashSet<String>) {
+    let mut ptr: *const *const i8 = unsafe { bch_bindgen::c::bch2_bkey_types.as_ptr() };
+    unsafe {
+        while !(*ptr).is_null() {
+            let mut bkey_name = String::from("bch_");
+            bkey_name.push_str(std::ffi::CStr::from_ptr(*ptr).to_str().unwrap());
+            bkey_types.insert(bkey_name);
+            ptr = ptr.offset(1);
+        }
+    }
+
+    // This key type is not included in BCH2_BKEY_TYPES.
+    bkey_types.insert("bch_inode_unpacked".to_string());
+}
+
+fn process_unit(
+    dwarf: &gimli::Dwarf<Reader>,
+    unit: &gimli::Unit<Reader>,
+    struct_list: &mut BkeyTypes,
+    bkey_types: &mut HashSet<String>,
+) -> Result<(), gimli::Error> {
+    let mut tree = unit.entries_tree(None)?;
+
+    process_tree(dwarf, unit, tree.root()?, struct_list, bkey_types)?;
+
+    Ok(())
+}
+
+#[derive(Clone, Copy)]
+enum CompType {
+    Union,
+    Struct,
+}
+
+/// Used to keep track of info needed for structs that contain
+/// other compound types.
+struct ParentInfo<'a> {
+    ty: CompType,
+    starting_offset: u64,
+    member_prefix: &'a str,
+}
+
+fn entry_name(
+    dwarf: &gimli::Dwarf<Reader>,
+    unit: &gimli::Unit<Reader>,
+    entry: &gimli::DebuggingInformationEntry<Reader>,
+) -> Option<String> {
+    entry.attr(gimli::DW_AT_name).ok()?.and_then(|name| {
+        Some(
+            dwarf
+                .attr_string(unit, name.value())
+                .ok()?
+                .to_string_lossy()
+                .into_owned(),
+        )
+    })
+}
+
+fn process_tree(
+    dwarf: &gimli::Dwarf<Reader>,
+    unit: &gimli::Unit<Reader>,
+    node: gimli::EntriesTreeNode<Reader>,
+    struct_list: &mut BkeyTypes,
+    bkey_types: &mut HashSet<String>,
+) -> gimli::Result<()> {
+    let entry = node.entry();
+    if entry.tag() == gimli::DW_TAG_structure_type {
+        let name = entry_name(dwarf, unit, entry);
+        let Some(name) = name else {
+            return Ok(());
+        };
+
+        if bkey_types.remove(&name) {
+            let mut members: Vec<BchMember> = Vec::new();
+            let parent_info = ParentInfo {
+                ty: CompType::Struct,
+                starting_offset: 0,
+                member_prefix: "",
+            };
+            process_compound_type(dwarf, unit, node, &mut members, &parent_info)?;
+            struct_list.0.push(BchStruct { name, members });
+        }
+    } else {
+        let mut children = node.children();
+        while let Some(child) = children.next()? {
+            process_tree(dwarf, unit, child, struct_list, bkey_types)?;
+        }
+    }
+    Ok(())
+}
+
+fn process_compound_type(
+    dwarf: &gimli::Dwarf<Reader>,
+    unit: &gimli::Unit<Reader>,
+    node: gimli::EntriesTreeNode<Reader>,
+    members: &mut Vec<BchMember>,
+    parent: &ParentInfo,
+) -> gimli::Result<()> {
+    let mut children = node.children();
+    while let Some(child) = children.next()? {
+        process_comp_member(dwarf, unit, child, members, parent)?;
+    }
+
+    Ok(())
+}
+
+/// Given a DIE, checks if that DIE has a reference to a compound type (i.e., struct or union) and
+/// if so, returns the offset in the DIE tree for that type, and the kind of compound type it is.
+fn get_comp_ref(
+    unit: &gimli::Unit<Reader>,
+    entry: &gimli::DebuggingInformationEntry<Reader>,
+) -> Option<(gimli::UnitOffset, CompType)> {
+    let ref_type = entry.attr(gimli::DW_AT_type).ok()??;
+    let ref_offset = match ref_type.value() {
+        gimli::AttributeValue::UnitRef(offset) => offset,
+        _ => return None,
+    };
+
+    let mut ty_entry = unit.entries_at_offset(ref_offset).ok()?;
+    ty_entry.next_entry().ok()??;
+    let ty_entry = ty_entry.current()?;
+
+    match ty_entry.tag() {
+        gimli::DW_TAG_structure_type => Some((ty_entry.offset(), CompType::Struct)),
+        gimli::DW_TAG_union_type => Some((ty_entry.offset(), CompType::Union)),
+        _ => None,
+    }
+}
+
+fn process_comp_member(
+    dwarf: &gimli::Dwarf<Reader>,
+    unit: &gimli::Unit<Reader>,
+    node: gimli::EntriesTreeNode<Reader>,
+    members: &mut Vec<BchMember>,
+    parent: &ParentInfo,
+) -> gimli::Result<()> {
+    let entry = node.entry().clone();
+
+    let Some(offset) = (match parent.ty {
+        CompType::Union => Some(0),
+        CompType::Struct => entry
+            .attr(gimli::DW_AT_data_member_location)?
+            .and_then(|offset| offset.value().udata_value()),
+    }) else {
+        return Ok(());
+    };
+
+    let name = entry_name(dwarf, unit, &entry);
+
+    if let Some((ref_type, comp)) = get_comp_ref(unit, &entry) {
+        let prefix = if let Some(ref name) = name {
+            let mut prefix = name.clone();
+            prefix.push('.');
+            prefix
+        } else {
+            String::from("")
+        };
+        let parent = ParentInfo {
+            ty: comp,
+            starting_offset: offset,
+            member_prefix: &prefix,
+        };
+        let mut tree = unit.entries_tree(Some(ref_type))?;
+        process_compound_type(dwarf, unit, tree.root()?, members, &parent)?;
+
+        return Ok(());
+    };
+
+    let Some(size) = get_size(unit, &entry) else {
+        return Ok(());
+    };
+
+    let Some(name) = name else { return Ok(()) };
+    let mut name_with_prefix = String::from(parent.member_prefix);
+    name_with_prefix.push_str(&name);
+
+    members.push(BchMember {
+        name: name_with_prefix,
+        offset: offset + parent.starting_offset,
+        size,
+    });
+
+    Ok(())
+}
+
+fn get_size(
+    unit: &gimli::Unit<Reader>,
+    entry: &gimli::DebuggingInformationEntry<Reader>,
+) -> Option<u64> {
+    if let Some(size) = entry.attr(gimli::DW_AT_byte_size).ok()? {
+        return size.udata_value();
+    }
+
+    let ref_type = entry.attr(gimli::DW_AT_type).ok()??;
+    if let gimli::AttributeValue::UnitRef(offset) = ref_type.value() {
+        let mut type_entry = unit.entries_at_offset(offset).ok()?;
+        type_entry.next_entry().ok()?;
+        if let Some(t) = type_entry.current() {
+            return get_size(unit, t);
+        }
+    }
+
+    None
+}
+
+/// Return a list of the known bkey types and information on their field layout.
+pub fn get_bkey_type_info() -> Result<BkeyTypes> {
+    let path = fs::read_link("/proc/self/exe").unwrap();
+    let file = fs::File::open(path).unwrap();
+    let mmap = unsafe { memmap2::Mmap::map(&file).unwrap() };
+    let object = object::File::parse(&*mmap).unwrap();
+
+    let mut struct_list = BkeyTypes::new();
+    process_file(&object, &mut struct_list).unwrap();
+
+    if struct_list.0.is_empty() {
+        Err(anyhow!(
+            "Could not find bkey debug info.\nWas the bcachefs binary compiled with debug info?"
+        ))
+    } else {
+        Ok(struct_list)
+    }
+}
diff --git a/src/commands/debug/mod.rs b/src/commands/debug/mod.rs
new file mode 100644
index 00000000..30ffd16b
--- /dev/null
+++ b/src/commands/debug/mod.rs
@@ -0,0 +1,9 @@
+mod bkey_types;
+
+use anyhow::Result;
+
+pub fn list_bkeys() -> Result<()> {
+    print!("{}", bkey_types::get_bkey_type_info()?);
+
+    Ok(())
+}
diff --git a/src/commands/mod.rs b/src/commands/mod.rs
index 7f466f92..9365f981 100644
--- a/src/commands/mod.rs
+++ b/src/commands/mod.rs
@@ -1,11 +1,13 @@
 use clap::Subcommand;
 
 pub mod completions;
+pub mod debug;
 pub mod list;
 pub mod mount;
 pub mod subvolume;
 
 pub use completions::completions;
+pub use debug::list_bkeys;
 pub use list::list;
 pub use mount::mount;
 pub use subvolume::subvolume;
-- 
2.45.2

