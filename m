Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E373D544;
	Mon, 22 Jan 2024 14:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705934232; cv=none; b=umHEDo1fRuK7YdokQzocU43TyaKYN4Rb05kl/QbIwXL05Yqvgct/esh6lEu5ImsIjB8TtgHtb6/N4CTrCTnQqSHapZmMWMyBVvnUiHEWaKN4cjJCXrCxGaD19NoXaGUNzKjVyd1GRUaUUPKOpklNjwtgHT8E1t71iUfMMDN3h4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705934232; c=relaxed/simple;
	bh=opW9FIuZZ49ACe81On1jgyUEfJi/YtkwHyGMvlSpna0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LVfJWD9Mli542IBHqjkkwfRnlCSPxG3BZAjYl3dgiiG9rfMxuXAjT5u4/lYfCPTs9cXxd60zD0tNo1uqVFSL7VpRje8s8mIQUujhNokmddtZqlAIC/+mDMOF3/Hozv8LG1rmL2D9y5YYyRk1MkcwHmxXKEyhaXtk4sf9yGnykms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyFWcUHQ; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyFWcUHQ"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bed9f0ea20so149909039f.2;
        Mon, 22 Jan 2024 06:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705934229; x=1706539029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yGsvFnDD/YlgjTTOTVCnT6i6Is6I7Y6FHAa2/8dqptY=;
        b=kyFWcUHQzTcIozkPJXY8gx4nl+KFhB8fr7/jP04/Fcs5IY3V3/6w0K5P7SbHr3xtRW
         Svk+G+xj6xBkNC+zr+42n5L9ymZm+udk8zeVhzLWdwD1D9xyyMfUzQAp47fa6WIDsfja
         FijfeNChPdmCkcs2QmTsy3/gBeTDTvdEmdLEvOO6VYLZdL27ue0avpmZCn0k/CIBT8JF
         1WnzMmo84Ks75Q/O+vrK1iL7ydI9zTGjsTZLOX0doN4tbOPsazAtK2TFEuOhfU+Jap1I
         GRazPOU7dPRkm50U3ni3ta5vTrLJZsMSLyNq8LJ4BXRHmJa/IJ/Boe8DVIGllj0Pl6EK
         FOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705934229; x=1706539029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGsvFnDD/YlgjTTOTVCnT6i6Is6I7Y6FHAa2/8dqptY=;
        b=J7OsQRGK9y1Ub0KZA4oay7hwiVXX3oME+KJNCe4VvLhMdg+VWS2I0EJ9wIL7vm/8tz
         kqm9LHT+Fl3Sn9zCt1G5peU3/5wsYiMv2b3O7h9G2aLuQ0QVGk36IGIe8yg1ccKk64ka
         n/rzY7hQasnxWqcICkQvmT7au7TJrIOadgFjtMBwLwUNwga4Pn7hBJmiIq6n6DKMriwv
         NE3gkHr1gjFJl5TpLpeMEWX7069Zrr1KgB+Q/7ov2pd5bG4Q5rDChpwXo499Uqw2dalc
         gEpB+1v6f1zwknco32PbXTBvYMAEfTHi6UYpGZ2aI3QLI6cb0pY2VlzELbW8rY13uIJS
         SAfg==
X-Gm-Message-State: AOJu0YzvhIcdeclTWKXFVIkA3CTBR+rAqJH8RhW4r+apInONc39tSWqp
	Vqwa/mSV+yItbDQ/eg+CLPl/NZJITDwFs6uTS61euaWvG1y5gVUd
X-Google-Smtp-Source: AGHT+IE5d5NROUuxjZ9sLL0+4goUTGKvadeiAIdP00cjXYbNUFFKb3qoP/7SxQ5QpCLgJpaS3g9bdw==
X-Received: by 2002:a6b:c9d1:0:b0:7bf:9996:32d1 with SMTP id z200-20020a6bc9d1000000b007bf999632d1mr1364956iof.39.1705934228590;
        Mon, 22 Jan 2024 06:37:08 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id c14-20020a056602334e00b007bc102fb67asm5998245ioz.10.2024.01.22.06.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:37:08 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com,
	rust-for-linux@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH BCACHEFS-TOOLS] use upstream bindgen; fix packed and aligned types
Date: Mon, 22 Jan 2024 07:36:43 -0700
Message-ID: <20240122143643.201936-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bcachefs-tools has been using a patched bindgen to work around a
limitation of rustc that prevents compiling structs with
both #[repr(packed(N)] and #[repr(align(N)] attributes. The patch:
e8168ceda507 "codegen: Don't generate conflicting packed() and align()
representation hints." discards the "align" attribute in cases where
bindgen produces a type with both.

This may be correct for some types, but it turns out that for each
bcachefs type with this problem, keeping the "align" attribute and
discarding the "packed" attribute generates a type with the same ABI as
the original C type.

This can be tested automatically by running:
$ cargo test --manifest-path bch_bindgen/Cargo.toml
in the bcachefs-tools tree.

There has been pressure recently to start using upstream bindgen; both
externally, from distribution maintainers who want to build
bcachefs-tools with standard dependencies, and internally, in order to
enable using Rust for bcachefs in-kernel.

This patch updates bcachefs-tools to use upstream bindgen. It works
around the rustc limitation with a post-processing step in the bindgen
build that adjusts the attributes to include "#[repr(C, align(N))]" and
exclude #[repr(packed(N)] only for the 4 types that need it.

Some types that had been manually implemented in
bch_bindgen/src/bcachefs.rs are now automatically generated by bindgen,
so that they will be covered by the ABI compatibility testing mentioned
above.

I intentionally targeted the post-processing to the exact 4 types with
the issue currently, so that any changes to bcachefs that result in this
issue appearing for a new type will require manual intervention. I
figured any such changes should require careful consideration.

Ideally, bindgen can be updated to handle situations where "align(N)"
is needed and "packed(N)" can be safely discarded. If a patch for this
is accepted into bindgen, the post-processing hack can be removed.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock                  | 186 +++++++++++++++++-------------------
 bch_bindgen/Cargo.toml      |   2 +-
 bch_bindgen/build.rs        |  51 ++++++++--
 bch_bindgen/src/bcachefs.rs |  27 ------
 4 files changed, 133 insertions(+), 133 deletions(-)

diff --git a/Cargo.lock b/Cargo.lock
index c1a98e3..bcbdbc5 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -13,51 +13,50 @@ dependencies = [
 
 [[package]]
 name = "anstream"
-version = "0.3.2"
+version = "0.6.11"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0ca84f3628370c59db74ee214b3263d58f9aadd9b4fe7e711fd87dc452b7f163"
+checksum = "6e2e1ebcb11de5c03c67de28a7df593d32191b44939c482e97702baaaa6ab6a5"
 dependencies = [
  "anstyle",
  "anstyle-parse",
  "anstyle-query",
  "anstyle-wincon",
  "colorchoice",
- "is-terminal",
  "utf8parse",
 ]
 
 [[package]]
 name = "anstyle"
-version = "1.0.2"
+version = "1.0.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "15c4c2c83f81532e5845a733998b6971faca23490340a418e9b72a3ec9de12ea"
+checksum = "7079075b41f533b8c61d2a4d073c4676e1f8b249ff94a393b0595db304e0dd87"
 
 [[package]]
 name = "anstyle-parse"
-version = "0.2.1"
+version = "0.2.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "938874ff5980b03a87c5524b3ae5b59cf99b1d6bc836848df7bc5ada9643c333"
+checksum = "c75ac65da39e5fe5ab759307499ddad880d724eed2f6ce5b5e8a26f4f387928c"
 dependencies = [
  "utf8parse",
 ]
 
 [[package]]
 name = "anstyle-query"
-version = "1.0.0"
+version = "1.0.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5ca11d4be1bab0c8bc8734a9aa7bf4ee8316d462a08c6ac5052f888fef5b494b"
+checksum = "e28923312444cdd728e4738b3f9c9cac739500909bb3d3c94b43551b16517648"
 dependencies = [
- "windows-sys 0.48.0",
+ "windows-sys 0.52.0",
 ]
 
 [[package]]
 name = "anstyle-wincon"
-version = "1.0.2"
+version = "3.0.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c677ab05e09154296dd37acecd46420c17b9713e8366facafa8fc0885167cf4c"
+checksum = "1cd54b81ec8d6180e24654d0b371ad22fc3dd083b6ff8ba325b72e00c87660a7"
 dependencies = [
  "anstyle",
- "windows-sys 0.48.0",
+ "windows-sys 0.52.0",
 ]
 
 [[package]]
@@ -72,7 +71,7 @@ version = "0.2.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "d9b39be18770d11421cdb1b9947a45dd3f37e93092cbf377614828a319d5fee8"
 dependencies = [
- "hermit-abi 0.1.19",
+ "hermit-abi",
  "libc",
  "winapi",
 ]
@@ -120,21 +119,25 @@ dependencies = [
 
 [[package]]
 name = "bindgen"
-version = "0.64.0"
-source = "git+https://evilpiepirate.org/git/rust-bindgen.git#f773267b090bf16b9e8375fcbdcd8ba5e88806a8"
+version = "0.69.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a4c69fae65a523209d34240b60abe0c42d33d1045d445c0839d8a4894a736e2d"
 dependencies = [
- "bitflags 1.3.2",
+ "bitflags 2.4.2",
  "cexpr",
  "clang-sys",
  "lazy_static",
  "lazycell",
+ "log",
  "peeking_take_while",
+ "prettyplease",
  "proc-macro2",
  "quote",
  "regex",
  "rustc-hash",
  "shlex",
- "syn 1.0.109",
+ "syn",
+ "which",
 ]
 
 [[package]]
@@ -179,6 +182,12 @@ dependencies = [
  "nom",
 ]
 
+[[package]]
+name = "cfg-if"
+version = "1.0.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"
+
 [[package]]
 name = "clang-sys"
 version = "1.7.0"
@@ -187,24 +196,24 @@ checksum = "67523a3b4be3ce1989d607a828d036249522dd9c1c8de7f4dd2dae43a37369d1"
 dependencies = [
  "glob",
  "libc",
+ "libloading",
 ]
 
 [[package]]
 name = "clap"
-version = "4.3.24"
+version = "4.4.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fb690e81c7840c0d7aade59f242ea3b41b9bc27bcd5997890e7702ae4b32e487"
+checksum = "1e578d6ec4194633722ccf9544794b71b1385c3c027efe0c55db226fc880865c"
 dependencies = [
  "clap_builder",
  "clap_derive",
- "once_cell",
 ]
 
 [[package]]
 name = "clap_builder"
-version = "4.3.24"
+version = "4.4.18"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5ed2e96bc16d8d740f6f48d663eddf4b8a0983e79210fd55479b7bcd0a69860e"
+checksum = "4df4df40ec50c46000231c914968278b1eb05098cf8f1b3a518a95030e71d1c7"
 dependencies = [
  "anstream",
  "anstyle",
@@ -215,30 +224,30 @@ dependencies = [
 
 [[package]]
 name = "clap_complete"
-version = "4.3.2"
+version = "4.4.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5fc443334c81a804575546c5a8a79b4913b50e28d69232903604cada1de817ce"
+checksum = "eaf7dcb7c21d8ca1a2482ee0f1d341f437c9a7af6ca6da359dc5e1b164e98215"
 dependencies = [
  "clap",
 ]
 
 [[package]]
 name = "clap_derive"
-version = "4.3.12"
+version = "4.4.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "54a9bb5758fc5dfe728d1019941681eccaf0cf8a4189b692a0ee2f2ecf90a050"
+checksum = "cf9804afaaf59a91e75b022a30fb7229a7901f60c755489cc61c9b423b836442"
 dependencies = [
  "heck",
  "proc-macro2",
  "quote",
- "syn 2.0.48",
+ "syn",
 ]
 
 [[package]]
 name = "clap_lex"
-version = "0.5.0"
+version = "0.6.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2da6da31387c7e4ef160ffab6d5e7f00c42626fe39aea70a7b0f1773f7dd6c1b"
+checksum = "702fc72eb24e5a1e48ce58027a675bc24edd52096d5397d4aea7c6dd9eca0bd1"
 
 [[package]]
 name = "colorchoice"
@@ -248,11 +257,10 @@ checksum = "acbf1af155f9b9ef647e42cdc158db4b64a1b61f743629225fde6f3e0be2a7c7"
 
 [[package]]
 name = "colored"
-version = "2.0.4"
+version = "2.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2674ec482fbc38012cf31e6c42ba0177b431a0cb6f15fe40efa5aab1bda516f6"
+checksum = "cbf2150cce219b664a8a70df7a1f933836724b503f8a413af9365b4dcc4d90b8"
 dependencies = [
- "is-terminal",
  "lazy_static",
  "windows-sys 0.48.0",
 ]
@@ -316,30 +324,11 @@ dependencies = [
 ]
 
 [[package]]
-name = "hermit-abi"
-version = "0.3.4"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5d3d0e0f38255e7fa3cf31335b3a56f05febd18025f4db5ef7a0cfb4f8da651f"
-
-[[package]]
-name = "io-lifetimes"
-version = "1.0.11"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "eae7b9aee968036d54dce06cebaefd919e4472e753296daccd6d344e3e2df0c2"
-dependencies = [
- "hermit-abi 0.3.4",
- "libc",
- "windows-sys 0.48.0",
-]
-
-[[package]]
-name = "is-terminal"
-version = "0.4.10"
+name = "home"
+version = "0.5.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0bad00257d07be169d870ab665980b06cdb366d792ad690bf2e76876dc503455"
+checksum = "e3d1354bf6b7235cb4a0576c2619fd4ed18183f689b12b006a0ee7329eeff9a5"
 dependencies = [
- "hermit-abi 0.3.4",
- "rustix 0.38.30",
  "windows-sys 0.52.0",
 ]
 
@@ -361,6 +350,16 @@ version = "0.2.152"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "13e3bf6590cbc649f4d1a3eefc9d5d6eb746f5200ffb04e5e142700b8faa56e7"
 
+[[package]]
+name = "libloading"
+version = "0.8.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c571b676ddfc9a8c12f1f3d3085a7b163966a8fd8098a90640953ce5f6170161"
+dependencies = [
+ "cfg-if",
+ "windows-sys 0.48.0",
+]
+
 [[package]]
 name = "libudev-sys"
 version = "0.1.4"
@@ -371,12 +370,6 @@ dependencies = [
  "pkg-config",
 ]
 
-[[package]]
-name = "linux-raw-sys"
-version = "0.3.8"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ef53942eb7bf7ff43a617b3e2c1c4a5ecf5944a7c1bc12d7ee39bbb15e5c1519"
-
 [[package]]
 name = "linux-raw-sys"
 version = "0.4.13"
@@ -444,11 +437,21 @@ version = "0.3.29"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "2900ede94e305130c13ddd391e0ab7cbaeb783945ae07a279c268cb05109c6cb"
 
+[[package]]
+name = "prettyplease"
+version = "0.2.16"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a41cf62165e97c7f814d2221421dbb9afcbcdb0a88068e5ea206e19951c2cbb5"
+dependencies = [
+ "proc-macro2",
+ "syn",
+]
+
 [[package]]
 name = "proc-macro2"
-version = "1.0.77"
+version = "1.0.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9f9b1511a24c627ab3e92b48be4b32f8d0ea91ee351edd87fbf650aadd336340"
+checksum = "e2422ad645d89c99f8f3e6b88a9fdeca7fabeac836b1002371c4367c8f984aae"
 dependencies = [
  "unicode-ident",
 ]
@@ -464,9 +467,9 @@ dependencies = [
 
 [[package]]
 name = "regex"
-version = "1.10.2"
+version = "1.10.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "380b951a9c5e80ddfd6136919eef32310721aa4aacd4889a8d39124b026ab343"
+checksum = "b62dbe01f0b06f9d8dc7d49e05a0785f153b00b2c227856282f671e0318c9b15"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -476,9 +479,9 @@ dependencies = [
 
 [[package]]
 name = "regex-automata"
-version = "0.4.3"
+version = "0.4.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5f804c7828047e88b2d32e2d7fe5a105da8ee3264f01902f796c8e067dc2483f"
+checksum = "3b7fa1134405e2ec9353fd416b17f8dacd46c473d7d3fd1cf202706a14eb792a"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -518,20 +521,6 @@ version = "1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2"
 
-[[package]]
-name = "rustix"
-version = "0.37.27"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fea8ca367a3a01fe35e6943c400addf443c0f57670e6ec51196f71a4b8762dd2"
-dependencies = [
- "bitflags 1.3.2",
- "errno 0.3.8",
- "io-lifetimes",
- "libc",
- "linux-raw-sys 0.3.8",
- "windows-sys 0.48.0",
-]
-
 [[package]]
 name = "rustix"
 version = "0.38.30"
@@ -541,15 +530,15 @@ dependencies = [
  "bitflags 2.4.2",
  "errno 0.3.8",
  "libc",
- "linux-raw-sys 0.4.13",
+ "linux-raw-sys",
  "windows-sys 0.52.0",
 ]
 
 [[package]]
 name = "shlex"
-version = "1.2.0"
+version = "1.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a7cee0529a6d40f580e7a5e6c495c8fbfe21b7b52795ed4bb5e62cdf92bc6380"
+checksum = "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"
 
 [[package]]
 name = "strsim"
@@ -557,17 +546,6 @@ version = "0.10.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "73473c0e59e6d5812c5dfe2a064a6444949f089e20eec9a2e5506596494e4623"
 
-[[package]]
-name = "syn"
-version = "1.0.109"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "72b64191b275b66ffe2469e8af2c1cfe3bafa67b529ead792a6d0160888b4237"
-dependencies = [
- "proc-macro2",
- "quote",
- "unicode-ident",
-]
-
 [[package]]
 name = "syn"
 version = "2.0.48"
@@ -581,11 +559,11 @@ dependencies = [
 
 [[package]]
 name = "terminal_size"
-version = "0.2.6"
+version = "0.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8e6bf6f19e9f8ed8d4048dc22981458ebcf406d67e94cd422e5ecd73d63b3237"
+checksum = "21bebf2b7c9e0a515f6e0f8c51dc0f8e4696391e6f1ff30379559f8365fb0df7"
 dependencies = [
- "rustix 0.37.27",
+ "rustix",
  "windows-sys 0.48.0",
 ]
 
@@ -618,6 +596,18 @@ version = "1.7.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "f00cc9702ca12d3c81455259621e676d0f7251cec66a21e98fe2e9a37db93b2a"
 
+[[package]]
+name = "which"
+version = "4.4.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "87ba24419a2078cd2b0f2ede2691b6c66d8e47836da3b6db8265ebad47afbfc7"
+dependencies = [
+ "either",
+ "home",
+ "once_cell",
+ "rustix",
+]
+
 [[package]]
 name = "winapi"
 version = "0.3.9"
diff --git a/bch_bindgen/Cargo.toml b/bch_bindgen/Cargo.toml
index 33090ae..fcc4668 100644
--- a/bch_bindgen/Cargo.toml
+++ b/bch_bindgen/Cargo.toml
@@ -19,4 +19,4 @@ paste = "1.0.11"
 
 [build-dependencies]
 pkg-config = "0.3"
-bindgen = { git = "https://evilpiepirate.org/git/rust-bindgen.git", default-features = false }
+bindgen = "0.69.2"
diff --git a/bch_bindgen/build.rs b/bch_bindgen/build.rs
index 5395807..68dfbd9 100644
--- a/bch_bindgen/build.rs
+++ b/bch_bindgen/build.rs
@@ -1,4 +1,3 @@
-
 #[derive(Debug)]
 pub struct Fix753 {}
 impl bindgen::callbacks::ParseCallbacks for Fix753 {
@@ -60,9 +59,6 @@ fn main() {
         .allowlist_function("keyctl_search")
         .allowlist_function("match_string")
         .allowlist_function("printbuf.*")
-        .blocklist_type("bch_extent_ptr")
-        .blocklist_type("btree_node")
-        .blocklist_type("bch_extent_crc32")
         .blocklist_type("rhash_lock_head")
         .blocklist_type("srcu_struct")
         .allowlist_var("BCH_.*")
@@ -92,9 +88,12 @@ fn main() {
         .parse_callbacks(Box::new(Fix753 {}))
         .generate()
         .expect("BindGen Generation Failiure: [libbcachefs_wrapper]");
-    bindings
-        .write_to_file(out_dir.join("bcachefs.rs"))
-        .expect("Writing to output file failed for: `bcachefs.rs`");
+
+    std::fs::write(
+        out_dir.join("bcachefs.rs"),
+        packed_and_align_fix(bindings.to_string()),
+    )
+    .expect("Writing to output file failed for: `bcachefs.rs`");
 
     let keyutils = pkg_config::probe_library("libkeyutils").expect("Failed to find keyutils lib");
     let bindings = bindgen::builder()
@@ -117,3 +116,41 @@ fn main() {
         .write_to_file(out_dir.join("keyutils.rs"))
         .expect("Writing to output file failed for: `keyutils.rs`");
 }
+
+// rustc has a limitation where it does not allow structs to have both a "packed" and "align"
+// attribute. This means that bindgen cannot copy all attributes from some C types, like struct
+// bkey, that are both packed and aligned.
+//
+// bindgen tries to handle this situation smartly and for many types it will only apply a
+// "packed(N)" attribute if that is good enough. However, there are a few types where bindgen
+// does end up generating both a packed(N) and align(N) attribute. These types can't be compiled
+// by rustc.
+//
+// To work around this, we can remove either the "packed" or "align" attribute. It happens that
+// for all the types with this problem in bcachefs, removing the "packed" attribute and keeping
+// the "align" attribute results in a type with the correct ABI.
+//
+// This function applies that transformation to the following bcachefs types that need it:
+//   - bkey
+//   - bch_extent_crc32
+//   - bch_extent_ptr
+//   - btree_node
+fn packed_and_align_fix(bindings: std::string::String) -> std::string::String {
+    bindings
+        .replace(
+            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bkey {",
+            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bkey {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc32 {",
+            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_crc32 {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\n#[repr(align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_ptr {",
+            "#[repr(C, align(8))]\n#[derive(Debug, Default, Copy, Clone)]\npub struct bch_extent_ptr {",
+        )
+        .replace(
+            "#[repr(C, packed(8))]\npub struct btree_node {",
+            "#[repr(C, align(8))]\npub struct btree_node {",
+        )
+}
diff --git a/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
index 8e897c0..837b027 100644
--- a/bch_bindgen/src/bcachefs.rs
+++ b/bch_bindgen/src/bcachefs.rs
@@ -80,33 +80,6 @@ impl bch_sb_handle {
     }
 }
 
-#[repr(C)]
-// #[repr(align(8))]
-#[derive(Debug, Default, Copy, Clone)]
-pub struct bch_extent_ptr {
-    pub _bitfield_1: __BindgenBitfieldUnit<[u8; 8usize]>,
-}
-
-#[repr(C, packed(8))]
-pub struct btree_node {
-    pub csum: bch_csum,
-    pub magic: __le64,
-    pub flags: __le64,
-    pub min_key: bpos,
-    pub max_key: bpos,
-    pub _ptr: bch_extent_ptr,
-    pub format: bkey_format,
-    pub __bindgen_anon_1: btree_node__bindgen_ty_1,
-}
-
-#[repr(C, packed(8))]
-// #[repr(align(8))]
-#[derive(Debug, Default, Copy, Clone)]
-pub struct bch_extent_crc32 {
-    pub _bitfield_1: __BindgenBitfieldUnit<[u8; 4usize]>,
-    pub csum: __u32,
-}
-
 // #[repr(u8)]
 pub enum rhash_lock_head {}
 pub enum srcu_struct {}
-- 
2.43.0

