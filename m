Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116592AF09
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 22:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715639001; cv=none; b=pmKxrcZ07IVCfWCF9Nwqf5UCLOM3zBJysYCJFMfd6ZRfqFqc6urCGPJ3EcerEaFzS75xqPRXBc+Xfq5upI7qFhSr5f2FmdIQV9nz3WMaQkC+FbdYTScr6Vi437TSIZVDRvxOURx+jKDclt1UCG1aqnDiOLnkzH6tyUCmY9jXk8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715639001; c=relaxed/simple;
	bh=ZUupXOUFBW1Kacrrxd0Dxl+tVOA1QgzkmkDvAMXZr0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZvOnniBj5J0lCOQ6x5ti05nKksDX1q6VEzjrPPidkPz0BckjeGRngI7VtATJSLnFO14ZQiKF7KZejaWilFBqopHuYYZCp9Q9oQ082tPXVneRTo95nsOOynzF4oYemZy/tTQT7dyC0o8EE8R8S5MDr+HKqJqqb/GO5BSHWQxk8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDvEpqPS; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDvEpqPS"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c9a604e367so1190554b6e.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715638998; x=1716243798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXsVWGEnobgz7ijuzI63u04P9+QR/qDBMnb5rWKyFmI=;
        b=eDvEpqPSsIyWURSYDrvkfzB+BJBkzIJbCZZRwDbkXYa1frQKAFX1i4ftDqPWw7aUEv
         ioJ4bgpOFe3b75pXaPRLOeQXZukhPaBJ0+6r6tuqu0ZWowkifWHHE+t80/7DVqTKwtgQ
         S+UkiVFBE6NbLFycu7357w6nXQp17BvgbPnD6vu2uYiMqkZblgBOJNSaucyiAojrgV7A
         IV6iqtHkM47SfDmjw8d2Y+WFaerqf2PSlrF4k/QjDBBQ0fdYtpK+NnDggjaDPw7WxPZM
         SnhkT4CChrKKXPjtviaDlQuMU9KJ3E7MFD+QBQwthTL+ZuvNmIH1qbFv0uxN9jUfMqyz
         ZYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715638998; x=1716243798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXsVWGEnobgz7ijuzI63u04P9+QR/qDBMnb5rWKyFmI=;
        b=ulPxdRjPkCapsOcGB9p2KbT5AM/GIvncTh/cc3NU7lP3mPguGAAERWBGkiTXjpDLQy
         AZViyJxv0OnW3MjW7pxE1zdQvxwEx1Kh+WYamBFomCc5A55qYJ2d8978h7aKfY7caEGe
         PJ369M/OoeSpq/5xoyTXqa1AqReKAqMlCW/XL4OKBmL+1VxtxnhhWQqFdUULKePt5HVy
         GtMy6KdofV12O0E2rZuPjfMZBm6fI1nvsD4D1sq2yUl4on0vcvy67O0HKSBGz0TY+Am2
         ZyvttHxhr8kMNSvT6Iw4FS5nhPWDMqXsPZ+EBBJO82R4FIu8+O0i78CrQJRV3D3Mw9fy
         uS2g==
X-Forwarded-Encrypted: i=1; AJvYcCWkom3D3kDCxX3M8hVuQxVWMyR/U6g1zBjwp/SgPvNMv3/DWRL5g7IH1TNdk5hd6lHN5ts+ZXP2CP5+ZHVqGeNOGScXB9A1gp+hJiA9iVU=
X-Gm-Message-State: AOJu0Yy+fXHb6exSEmK8iFmuBYGKVcxoBAQhwj2mBpqfvdaVjBQHVrTv
	aThVjTOnLLWs9WI70e/TLY+dkopDu3SONeP2zJPOueGsSfb1K5QD
X-Google-Smtp-Source: AGHT+IGnfT+ENP3zT1UpfRlR+d6cnQ8Me+OqIOaMaZv/AB00HfZOMrSU2+qDY94/7hy7NRgyKmTv8g==
X-Received: by 2002:a54:4e89:0:b0:3c9:6e80:8ea2 with SMTP id 5614622812f47-3c99706a6fbmr11758649b6e.32.1715638997267;
        Mon, 13 May 2024 15:23:17 -0700 (PDT)
Received: from moria.mynetworksettings.com (pool-100-6-165-19.pitbpa.fios.verizon.net. [100.6.165.19])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2a11e8sm494131685a.58.2024.05.13.15.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 15:23:16 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS 3/3] bcachefs: new "debug" and "list_bkeys" commands
Date: Mon, 13 May 2024 18:22:27 -0400
Message-ID: <20240513222227.3755093-3-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240513222227.3755093-1-tahbertschinger@gmail.com>
References: <20240513222227.3755093-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces two new commands to the bcachefs utility. The first,
"debug", is used for directly manipulating bkeys in the underlying
btrees. It has two subcommands, "dump" which takes a btree and bpos and
prints the data from that bkey, and "update" which is used to update a
given field of a key to a value. For example:

$ bcachefs debug ~/test-img -c "dump inodes 0:4096:U32_MAX"
u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
  flags= (16300000)
  journal_seq=9
  ...

$ bcachefs debug ~/test-img -c "update inodes 0:4096:U32_MAX bch_inode_unpacked.bi_nlink=2"

The second command, "list_bkeys", is used to list the known bkey types
as well as their fields. The types and fields listed are the ones that
can be accessed by the "debug" command.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock                       | 158 ++++++++++++++-
 Cargo.toml                       |   4 +
 c_src/bcachefs.c                 |   4 +-
 c_src/cmd_debug.c                | 143 +++++++++++++
 c_src/cmds.h                     |  12 ++
 src/bcachefs.rs                  |  14 +-
 src/commands/debug/bkey_types.rs | 337 +++++++++++++++++++++++++++++++
 src/commands/debug/mod.rs        | 179 ++++++++++++++++
 src/commands/debug/parser.rs     |  95 +++++++++
 src/commands/mod.rs              |   3 +
 10 files changed, 937 insertions(+), 12 deletions(-)
 create mode 100644 c_src/cmd_debug.c
 create mode 100644 src/commands/debug/bkey_types.rs
 create mode 100644 src/commands/debug/mod.rs
 create mode 100644 src/commands/debug/parser.rs

diff --git a/Cargo.lock b/Cargo.lock
index 94e40354..f6672bb1 100644
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
  "colored",
  "either",
  "errno 0.2.8",
+ "gimli",
  "libc",
  "log",
+ "memmap2",
+ "nom",
+ "object",
  "rpassword",
  "udev",
  "uuid",
@@ -125,7 +135,7 @@ dependencies = [
  "regex",
  "rustc-hash",
  "shlex",
- "syn",
+ "syn 2.0.63",
  "which",
 ]
 
@@ -226,7 +236,7 @@ dependencies = [
  "heck",
  "proc-macro2",
  "quote",
- "syn",
+ "syn 2.0.63",
 ]
 
 [[package]]
@@ -251,12 +261,38 @@ dependencies = [
  "windows-sys 0.48.0",
 ]
 
+[[package]]
+name = "crc32fast"
+version = "1.4.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b3855a8a784b474f333699ef2bbca9db2c4a1f6d9088a90a2d25b1eb53111eaa"
+dependencies = [
+ "cfg-if",
+]
+
+[[package]]
+name = "derive_more"
+version = "0.99.17"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "4fb810d30a7c1953f91334de7244731fc3f3c10d7fe163338a35b9f640960321"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "syn 1.0.109",
+]
+
 [[package]]
 name = "either"
 version = "1.11.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a47c1c47d2f5964e29c61246e81db715514cd532db6b5116a25ea3c03d6780a2"
 
+[[package]]
+name = "equivalent"
+version = "1.0.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5443807d6dff69373d433ab9ef5378ad8df50ca6298caf15de6e52e24aaf54d5"
+
 [[package]]
 name = "errno"
 version = "0.2.8"
@@ -288,12 +324,45 @@ dependencies = [
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
@@ -309,6 +378,16 @@ dependencies = [
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
 name = "is_terminal_polyfill"
 version = "1.70.0"
@@ -380,6 +459,15 @@ version = "2.7.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "6c8640c5d730cb13ebd907d8d04b52f55ac9a2eec55b440c8892f40d56c76c1d"
 
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
@@ -395,6 +483,15 @@ version = "0.2.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a"
 
+[[package]]
+name = "miniz_oxide"
+version = "0.7.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9d811f3e15f28568be3407c8e7fdb6514c1cda3cb30683f15b6a1a1dc4ea14a7"
+dependencies = [
+ "adler",
+]
+
 [[package]]
 name = "nom"
 version = "7.1.3"
@@ -405,6 +502,17 @@ dependencies = [
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
@@ -430,7 +538,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "5f12335488a2f3b0a83b14edad48dca9879ce89b2edd10e80237e4e852dd645e"
 dependencies = [
  "proc-macro2",
- "syn",
+ "syn 2.0.63",
 ]
 
 [[package]]
@@ -520,18 +628,52 @@ dependencies = [
  "windows-sys 0.52.0",
 ]
 
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
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "7da8b5736845d9f2fcb837ea5d9e2628564b3b043a70948a3f0b778838c5fb4f"
 
+[[package]]
+name = "syn"
+version = "1.0.109"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "72b64191b275b66ffe2469e8af2c1cfe3bafa67b529ead792a6d0160888b4237"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "unicode-ident",
+]
+
 [[package]]
 name = "syn"
 version = "2.0.63"
@@ -553,6 +695,16 @@ dependencies = [
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
index 9c2513db..20f2e15f 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -23,6 +23,10 @@ either = "1.5"
 rpassword = "7"
 bch_bindgen = { path = "bch_bindgen" }
 byteorder = "1.3"
+gimli = "0.29.0"
+object = "0.35.0"
+memmap2 = "0.9.4"
+nom = "7.1.3"
 
 [profile.release]
 strip = "none"
diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index c5b61097..311de278 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -86,6 +86,7 @@ void bcachefs_usage(void)
 	     "\n"
 	     "Debug:\n"
 	     "These commands work on offline, unmounted filesystems\n"
+	     "  debug                    Operate directly on the underlying btrees of a filesystem\n"
 	     "  dump                     Dump filesystem metadata to a qcow2 image\n"
 	     "  list                     List filesystem metadata in textual form\n"
 	     "  list_journal             List contents of journal\n"
@@ -94,7 +95,8 @@ void bcachefs_usage(void)
 	     "  fusemount                Mount a filesystem via FUSE\n"
 	     "\n"
 	     "Miscellaneous:\n"
-         "  completions              Generate shell completions\n"
+	     "  completions              Generate shell completions\n"
+	     "  list_bkeys               List all bkey types known to the current bcachefs version\n"
 	     "  version                  Display the version of the invoked bcachefs tool\n");
 }
 
diff --git a/c_src/cmd_debug.c b/c_src/cmd_debug.c
new file mode 100644
index 00000000..f046fda1
--- /dev/null
+++ b/c_src/cmd_debug.c
@@ -0,0 +1,143 @@
+#include <stdio.h>
+
+#include "libbcachefs/bkey_types.h"
+#include "libbcachefs/btree_update.h"
+#include "libbcachefs/printbuf.h"
+#include "libbcachefs/inode.h"
+
+#include "cmds.h"
+
+void write_field(void *base, u64 size, u64 offset, u64 value)
+{
+	u8 *field8;
+	u16 *field16;
+	u32 *field32;
+	u64 *field64;
+
+	switch (size) {
+	case 1:
+		field8 = (u8 *) base + offset;
+		*field8 = (u8) value;
+		break;
+	case 2:
+		field16 = (u16 *) ((u8 *) base + offset);
+		*field16 = (u16) value;
+		break;
+	case 4:
+		field32 = (u32 *) ((u8 *) base + offset);
+		*field32 = (u32) value;
+		break;
+	case 8:
+		field64 = (u64 *) ((u8 *) base + offset);
+		*field64 = value;
+		break;
+	default:
+		fprintf(stderr, "can't handle size %llu\n", size);
+	}
+}
+
+int cmd_dump_bkey(struct bch_fs *c, enum btree_id id, struct bpos pos)
+{
+	struct btree_trans *trans = bch2_trans_get(c);
+	struct btree_iter iter = { NULL };
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	bch2_trans_iter_init(trans, &iter, id, pos, BTREE_ITER_all_snapshots);
+
+	struct bkey_s_c k = bch2_btree_iter_peek(&iter);
+	if ((ret = bkey_err(k))) {
+		fprintf(stderr, "bch2_btree_iter_peek() failed: %s\n", bch2_err_str(ret));
+		goto out;
+	}
+	if (!k.k || !bpos_eq(pos, k.k->p)) {
+		bch2_bpos_to_text(&buf, pos);
+		printf("no key at pos %s\n", buf.buf);
+		ret = 1;
+		goto out;
+	}
+
+	bch2_bkey_val_to_text(&buf, c, k);
+	printf("%s\n", buf.buf);
+
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	bch2_trans_put(trans);
+
+	return ret;
+}
+
+int cmd_update_bkey(struct bch_fs *c, struct bkey_update u, struct bpos pos)
+{
+	struct btree_trans *trans = bch2_trans_get(c);
+	struct btree_iter iter = { NULL };
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	set_bit(BCH_FS_no_invalid_checks, &c->flags);
+
+	bch2_trans_iter_init(trans, &iter, u.id, pos, BTREE_ITER_all_snapshots);
+
+	struct bkey_s_c k = bch2_btree_iter_peek(&iter);
+	if ((ret = bkey_err(k))) {
+		fprintf(stderr, "bch2_btree_iter_peek() failed: %s\n", bch2_err_str(ret));
+		goto out;
+	}
+	if (!k.k || !bpos_eq(pos, k.k->p)) {
+		bch2_bpos_to_text(&buf, pos);
+		printf("no key at pos %s\n", buf.buf);
+		ret = 1;
+		goto out;
+	}
+
+	if (u.inode_unpacked) {
+		if (k.k->type != KEY_TYPE_inode_v2 && k.k->type != KEY_TYPE_inode_v3) {
+			fprintf(stderr, "Wanted bch_inode_unpacked, got 'bch_%s'\n",
+				bch2_bkey_types[k.k->type]);
+			goto out;
+		}
+
+		struct bch_inode_unpacked inode;
+		ret = bch2_inode_unpack(k, &inode);
+		if (ret != 0) {
+			fprintf(stderr, "bch2_inode_unpack() failed: %s\n", bch2_err_str(ret));
+			goto out;
+		}
+
+		write_field(&inode, u.size, u.offset, u.value);
+
+		ret = bch2_inode_write(trans, &iter, &inode) ?:
+		      bch2_trans_commit(trans, NULL, NULL, 0);
+		if (ret != 0) {
+			fprintf(stderr, "inode update failed: %s\n", bch2_err_str(ret));
+		}
+	} else {
+		if (u.bkey != k.k->type) {
+			fprintf(stderr, "Wanted type 'bch_%s', got type 'bch_%s'\n",
+				bch2_bkey_types[u.bkey], bch2_bkey_types[k.k->type]);
+			goto out;
+		}
+
+		bch2_trans_unlock(trans);
+
+		struct bkey_i *n = bch2_bkey_make_mut_noupdate(trans, k);
+		if ((ret = PTR_ERR_OR_ZERO(n))) {
+			fprintf(stderr, "bch2_bkey_make_mut_noupdate() failed: %s\n",
+				bch2_err_str(ret));
+			goto out;
+		}
+
+		write_field(&n->v, u.size, u.offset, u.value);
+
+		ret = bch2_btree_insert(c, u.id, n, NULL, 0);
+		if (ret != 0) {
+			fprintf(stderr, "bch2_btree_insert() failed: %s\n", bch2_err_str(ret));
+		}
+	}
+
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	bch2_trans_put(trans);
+
+	return ret;
+}
diff --git a/c_src/cmds.h b/c_src/cmds.h
index 64267dc4..6c60ad7e 100644
--- a/c_src/cmds.h
+++ b/c_src/cmds.h
@@ -9,6 +9,15 @@
 
 #include "tools-util.h"
 
+struct bkey_update {
+	enum btree_id id;
+	enum bch_bkey_type bkey;
+	bool inode_unpacked;
+	u64 offset;
+	u64 size;
+	u64 value;
+};
+
 int cmd_format(int argc, char *argv[]);
 int cmd_show_super(int argc, char *argv[]);
 int cmd_reset_counters(int argc, char *argv[]);
@@ -54,6 +63,9 @@ int cmd_subvolume_snapshot(int argc, char *argv[]);
 
 int cmd_fusemount(int argc, char *argv[]);
 
+int cmd_dump_bkey(struct bch_fs *, enum btree_id, struct bpos);
+int cmd_update_bkey(struct bch_fs *, struct bkey_update, struct bpos);
+
 void bcachefs_usage(void);
 int device_cmds(int argc, char *argv[]);
 int fs_cmds(int argc, char *argv[]);
diff --git a/src/bcachefs.rs b/src/bcachefs.rs
index e8099ffa..f26bc275 100644
--- a/src/bcachefs.rs
+++ b/src/bcachefs.rs
@@ -1,11 +1,11 @@
-mod wrappers;
 mod commands;
 mod key;
+mod wrappers;
 
 use std::ffi::{c_char, CString};
 
-use commands::logger::SimpleLogger;
 use bch_bindgen::c;
+use commands::logger::SimpleLogger;
 
 #[derive(Debug)]
 pub struct ErrnoError(pub errno::Errno);
@@ -25,12 +25,8 @@ fn handle_c_command(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
 
     let argc: i32 = argv.len().try_into().unwrap();
 
-    let argv: Vec<_> = argv
-        .into_iter()
-        .map(|s| CString::new(s).unwrap())
-        .collect();
+    let argv = argv.into_iter().map(|s| CString::new(s).unwrap());
     let mut argv = argv
-        .into_iter()
         .map(|s| Box::into_raw(s.into_boxed_c_str()) as *mut c_char)
         .collect::<Box<[*mut c_char]>>();
     let argv = argv.as_mut_ptr();
@@ -41,7 +37,7 @@ fn handle_c_command(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> i32 {
             "--help" => {
                 c::bcachefs_usage();
                 0
-            },
+            }
             "data" => c::data_cmds(argc, argv),
             "device" => c::device_cmds(argc, argv),
             "dump" => c::cmd_dump(argc, argv),
@@ -106,8 +102,10 @@ fn main() {
     };
 
     let ret = match cmd {
+        "debug" => commands::debug(args[1..].to_vec()),
         "completions" => commands::completions(args[1..].to_vec()),
         "list" => commands::list(args[1..].to_vec()),
+        "list_bkeys" => commands::list_bkeys(),
         "mount" => commands::mount(args, symlink_cmd),
         "subvolume" => commands::subvolume(args[1..].to_vec()),
         _ => handle_c_command(args, symlink_cmd),
diff --git a/src/commands/debug/bkey_types.rs b/src/commands/debug/bkey_types.rs
new file mode 100644
index 00000000..19609b0c
--- /dev/null
+++ b/src/commands/debug/bkey_types.rs
@@ -0,0 +1,337 @@
+//! Representation of the bcachefs bkey types, derived from DWARF debug info.
+
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
+
+    /// Given a struct name and a member name, return the size and offset of
+    /// the member within the struct, or None if it does not exist.
+    pub fn get_member_layout(&self, outer: &str, member: &str) -> Option<(u64, u64)> {
+        self.0
+            .iter()
+            .find(|i| i.name == *outer)
+            .and_then(|i| i.member_layout(member))
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
+impl BchStruct {
+    /// Given a struct member name, return the size and offset of the member
+    /// within its parent, or None if there is no member with the given name.
+    pub fn member_layout(&self, name: &str) -> Option<(u64, u64)> {
+        self.members
+            .iter()
+            .find(|i| i.name == *name)
+            .map(|i| (i.size, i.offset))
+    }
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
+pub fn get_bkey_type_info() -> BkeyTypes {
+    let path = fs::read_link("/proc/self/exe").unwrap();
+    let file = fs::File::open(path).unwrap();
+    let mmap = unsafe { memmap2::Mmap::map(&file).unwrap() };
+    let object = object::File::parse(&*mmap).unwrap();
+
+    let mut struct_list = BkeyTypes::new();
+    process_file(&object, &mut struct_list).unwrap();
+
+    if struct_list.0.len() == 0 {
+        eprintln!("Warning: could not find bkey debug info.");
+        eprintln!("Was the bcachefs binary compiled with debug info?");
+    }
+    struct_list
+}
diff --git a/src/commands/debug/mod.rs b/src/commands/debug/mod.rs
new file mode 100644
index 00000000..1617196b
--- /dev/null
+++ b/src/commands/debug/mod.rs
@@ -0,0 +1,179 @@
+use clap::Parser;
+use std::io::{BufRead, Write};
+
+use bch_bindgen::bcachefs;
+use bch_bindgen::c;
+use bch_bindgen::fs::Fs;
+
+mod bkey_types;
+mod parser;
+
+use bch_bindgen::c::bpos;
+
+/// Debug a bcachefs filesystem.
+#[derive(Parser, Debug)]
+pub struct Cli {
+    #[arg(required(true))]
+    devices: Vec<std::path::PathBuf>,
+
+    #[arg(short, long)]
+    command: Option<String>,
+}
+
+#[derive(Debug)]
+enum DebugCommand {
+    Dump(DumpCommand),
+    Update(UpdateCommand),
+}
+
+#[derive(Debug)]
+struct DumpCommand {
+    btree: String,
+    bpos: bpos,
+}
+
+#[derive(Debug)]
+struct UpdateCommand {
+    btree: String,
+    bpos: bpos,
+    bkey: String,
+    field: String,
+    value: u64,
+}
+
+fn update(fs: &Fs, type_list: &bkey_types::BkeyTypes, cmd: UpdateCommand) {
+    let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
+        Ok(b) => b,
+        Err(_) => {
+            eprintln!("unknown btree '{}'", cmd.btree);
+            return;
+        }
+    };
+
+    let (bkey, inode_unpacked) = if cmd.bkey == "bch_inode_unpacked" {
+        (c::bch_bkey_type::KEY_TYPE_MAX, true)
+    } else {
+        let bkey = match cmd.bkey["bch_".len()..].parse() {
+            Ok(k) => k,
+            Err(_) => {
+                eprintln!("unknown bkey type '{}'", cmd.bkey);
+                return;
+            }
+        };
+
+        (bkey, false)
+    };
+
+    if let Some((size, offset)) = type_list.get_member_layout(&cmd.bkey, &cmd.field) {
+        let update = c::bkey_update {
+            id,
+            bkey,
+            inode_unpacked,
+            offset,
+            size,
+            value: cmd.value,
+        };
+        unsafe {
+            c::cmd_update_bkey(fs.raw, update, cmd.bpos);
+        }
+    } else {
+        println!("unknown field '{}'", cmd.field);
+    }
+}
+
+fn dump(fs: &Fs, cmd: DumpCommand) {
+    let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
+        Ok(b) => b,
+        Err(_) => {
+            eprintln!("unknown btree '{}'", cmd.btree);
+            return;
+        }
+    };
+
+    unsafe {
+        c::cmd_dump_bkey(fs.raw, id, cmd.bpos);
+    }
+}
+
+fn usage() {
+    println!("Usage:");
+    println!("    dump <btree_type> <bpos>");
+    println!("    update <btree_type> <bpos> <bkey_type>.<field>=<value>");
+}
+
+fn do_command(fs: &Fs, type_list: &bkey_types::BkeyTypes, cmd: &str) -> i32 {
+    match parser::parse_command(cmd) {
+        Ok(cmd) => {
+            match cmd {
+                    DebugCommand::Dump(cmd) => dump(fs, cmd),
+                    DebugCommand::Update(cmd) => update(fs, type_list, cmd),
+            };
+
+            0
+        }
+        Err(e) => {
+            println!("{e}");
+            usage();
+
+            1
+        }
+    }
+}
+
+pub fn debug(argv: Vec<String>) -> i32 {
+    fn prompt() {
+        print!("bcachefs> ");
+        std::io::stdout().flush().unwrap();
+    }
+
+    let opt = Cli::parse_from(argv);
+    let fs_opts: bcachefs::bch_opts = Default::default();
+    let type_list = bkey_types::get_bkey_type_info();
+
+    if let Some(cmd) = opt.command {
+        return match parser::parse_command(&cmd) {
+            Ok(cmd) => {
+                let fs = match Fs::open(&opt.devices, fs_opts) {
+                    Ok(fs) => fs,
+                    Err(_) => {
+                        return 1;
+                    }
+                };
+                match cmd {
+                    DebugCommand::Dump(cmd) => dump(&fs, cmd),
+                    DebugCommand::Update(cmd) => update(&fs, &type_list, cmd),
+                }
+
+                0
+            }
+            Err(e) => {
+                println!("{e}");
+                usage();
+
+                1
+            }
+        };
+    }
+
+    let fs = match Fs::open(&opt.devices, fs_opts) {
+        Ok(fs) => fs,
+        Err(_) => {
+            return 1;
+        }
+    };
+
+    prompt();
+    let stdin = std::io::stdin();
+    for line in stdin.lock().lines() {
+        do_command(&fs, &type_list, &line.unwrap());
+        prompt();
+    }
+
+    0
+}
+
+pub fn list_bkeys() -> i32 {
+    print!("{}", bkey_types::get_bkey_type_info());
+
+    0
+}
diff --git a/src/commands/debug/parser.rs b/src/commands/debug/parser.rs
new file mode 100644
index 00000000..f98152b3
--- /dev/null
+++ b/src/commands/debug/parser.rs
@@ -0,0 +1,95 @@
+use nom::branch::alt;
+use nom::bytes::complete::{tag, take_while};
+use nom::character::complete::{alpha1, char, space1, u32, u64};
+use nom::combinator::{all_consuming, value};
+use nom::sequence::tuple;
+use nom::IResult;
+
+use bch_bindgen::c::bpos;
+
+use crate::commands::debug::{DebugCommand, DumpCommand, UpdateCommand};
+
+fn parse_bpos(input: &str) -> IResult<&str, bpos> {
+    let (input, (inode, _, offset, _, snapshot)) = tuple((
+        u64,
+        char(':'),
+        u64,
+        char(':'),
+        alt((u32, value(u32::MAX, tag("U32_MAX")))),
+    ))(input)?;
+
+    Ok((
+        input,
+        bpos {
+            inode,
+            offset,
+            snapshot,
+        },
+    ))
+}
+
+fn parse_dump_cmd(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, (_, btree, _, bpos)) =
+        all_consuming(tuple((space1, alpha1, space1, parse_bpos)))(input)?;
+
+    Ok((
+        input,
+        DebugCommand::Dump(DumpCommand {
+            btree: btree.to_string(),
+            bpos,
+        }),
+    ))
+}
+
+fn bkey_name(input: &str) -> IResult<&str, &str> {
+    take_while(|c: char| c.is_alphanumeric() || c == '_')(input)
+}
+
+fn field_name(input: &str) -> IResult<&str, &str> {
+    take_while(|c: char| c.is_alphanumeric() || c == '_' || c == '.')(input)
+}
+
+fn parse_update_cmd(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, (_, btree, _, bpos, _, bkey, _, field, _, value)) = all_consuming(tuple((
+        space1,
+        alpha1,
+        space1,
+        parse_bpos,
+        space1,
+        bkey_name,
+        char('.'),
+        field_name,
+        char('='),
+        u64,
+    )))(input)?;
+
+    Ok((
+        input,
+        DebugCommand::Update(UpdateCommand {
+            btree: btree.to_string(),
+            bpos,
+            bkey: bkey.to_string(),
+            field: field.to_string(),
+            value,
+        }),
+    ))
+}
+
+fn parse_command_inner(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, cmd) = alt((tag("dump"), tag("update")))(input)?;
+
+    match cmd {
+        "dump" => parse_dump_cmd(input),
+        "update" => parse_update_cmd(input),
+        _ => unreachable!(),
+    }
+}
+
+/// Given an input string, tries to parse it into a valid
+/// command to the debug tool.
+pub fn parse_command(input: &str) -> anyhow::Result<DebugCommand> {
+    match parse_command_inner(input) {
+        Ok((_, c)) => Ok(c),
+        Err(e) => Err(anyhow::anyhow!("{e}")),
+    }
+}
diff --git a/src/commands/mod.rs b/src/commands/mod.rs
index c7645926..31257190 100644
--- a/src/commands/mod.rs
+++ b/src/commands/mod.rs
@@ -5,11 +5,14 @@ pub mod mount;
 pub mod list;
 pub mod completions;
 pub mod subvolume;
+pub mod debug;
 
 pub use mount::mount;
 pub use list::list;
 pub use completions::completions;
 pub use subvolume::subvolume;
+pub use debug::debug;
+pub use debug::list_bkeys;
 
 #[derive(clap::Parser, Debug)]
 #[command(name = "bcachefs")]
-- 
2.43.0

