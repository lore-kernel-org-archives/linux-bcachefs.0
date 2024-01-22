Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DFAEA4
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jan 2024 04:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705898332; cv=none; b=eh1qm8XnumVsZeukaSYSyMMggMURtx8pMEt/jm9HOAz71Wb1lXLGuyX8OkvHJE9EATRf6OKPRMz70Nr32I0WCMd+S0/ya3LMk2tEYpPlBVTkgfu4zq0nFy4w+7BUgsj3Ct6jVl1izrI3frx9WUbL3BWu0sC7DtBfnkFiBJRITf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705898332; c=relaxed/simple;
	bh=LWCao6tcVLmAiLYGJ0foR/GDQ1kVOMQyJ38imtrObNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TCOwr+LcdwwlyM+2k8xm9ud7IFy9sFFC1i+iCDQOYMGt3vZwSZmTwwS7KXJ4PylKb+sEj5iENR8MouGFDTB9gXq83engY3AHrEYPZ53TkJWpF4nSfDpAqoQDHDTQLvveHxJX4LfHJsF+Kib3mL8Vjk80gpJCYyA8m5/WA6KDuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g62UlzwL; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g62UlzwL"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3608402ab93so11806495ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 20:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705898329; x=1706503129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HXLwedzoYS5MctfcdLLBAXQm33W5HBIslizIA8B8Khc=;
        b=g62UlzwLGdtlvu9IA/oJtVqyjvMWW9+DLKKofBZubieZo5gaXGZ8aoBKt13zkqHp3p
         QpYf9yaOgiZT2iUmlo8JIEBb8I0FiXH0oFD564btcu+nhjrWrTY6ksZ9eKdcgPvUd91X
         EABz7giGyvVjZ/ldk+un+0mvMoP+YRWXGeETLKgR6ojg9oHjb/6r4WbRPpR0iEHQ+R13
         2SHo7Kn9rV9UthGYi8sO2RTUbQVAXnmJin3KMqKJTi4lg6eFp6yvpZf8vRHoq9yJi2g5
         DTU6ebaI//hDfldRaQcM+5zuGj9LUlMXwm8nKVFr3F9p48nUEiLaAwCDA9batqLFSnFu
         LsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705898329; x=1706503129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HXLwedzoYS5MctfcdLLBAXQm33W5HBIslizIA8B8Khc=;
        b=lM0Tq7uG9F61OkSZ1bA0yqT1s+jy5x3x0xDhZkOGoRVANcw8Ka8rNUrmUj+TOJ21Cr
         YXDionT3alF+WLfpEWXrnToaGdr8vpXtYkcgsKSpFwX2pFT/BCeh2VzbjxNm9H81/Io9
         zJUbiTjSCoCjhBgynWDTAzEsREq6CUm+F195MN4YwyUM3MYly02YFvbW/ZQmuhSkl97c
         sPyjccUQ7NEgxYcqvtExhv2L5drqfa0TgusSxRAH0fI76NP4RHVD8FpWTcnDmOZlCngf
         VSouAB2dldi/Gkx/hEY2a0JOxnS3GwlKAR2I/4dVRynxw1uLI4r0G3qpkAZH6E1hln6A
         SKdw==
X-Gm-Message-State: AOJu0YyX3qcZzGPhOwDMc7aZo3VUq+mS7hY9Ln4IgX5ohx4Koowdi4GN
	64Dv3swswdwi9oSfhpxFD1xAmJ5z6Bw2CzAWC8YnfQCJzWyMQVKs
X-Google-Smtp-Source: AGHT+IGmJepQhpc6OJCQbnQ66G6bglrBmhdPoDDVm1RuQh59YIVXqBrtTHStS6yKPWl3xgDeVpgq2Q==
X-Received: by 2002:a92:ca8e:0:b0:361:a8ab:e924 with SMTP id t14-20020a92ca8e000000b00361a8abe924mr3446811ilo.48.1705898329334;
        Sun, 21 Jan 2024 20:38:49 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id a5-20020a92c545000000b00361b2dee4c2sm1463654ilj.78.2024.01.21.20.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 20:38:48 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] remove bch_bindgen/Cargo.lock from version control
Date: Sun, 21 Jan 2024 21:38:37 -0700
Message-ID: <20240122043837.187375-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is redundant with the root level Cargo.lock. Any changes made to
the bch_bindgen dependencies will be duplicated in both Cargo.lock
files. Removing this from version control will reduce the noise in the
git diffs for such changes.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 .gitignore             |   2 +
 bch_bindgen/Cargo.lock | 250 -----------------------------------------
 2 files changed, 2 insertions(+), 250 deletions(-)
 delete mode 100644 bch_bindgen/Cargo.lock

diff --git a/.gitignore b/.gitignore
index cf86eab..b7ba3f8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -21,6 +21,8 @@ tests/__pycache__/
 
 bcachefs-principles-of-operation.*
 
+bch_bindgen/Cargo.lock
+
 # will have compiled files and executables
 debug/
 target/
diff --git a/bch_bindgen/Cargo.lock b/bch_bindgen/Cargo.lock
deleted file mode 100644
index 5734843..0000000
--- a/bch_bindgen/Cargo.lock
+++ /dev/null
@@ -1,250 +0,0 @@
-# This file is automatically @generated by Cargo.
-# It is not intended for manual editing.
-version = 3
-
-[[package]]
-name = "aho-corasick"
-version = "1.1.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b2969dcb958b36655471fc61f7e416fa76033bdd4bfed0678d8fee1e2d07a1f0"
-dependencies = [
- "memchr",
-]
-
-[[package]]
-name = "anyhow"
-version = "1.0.79"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "080e9890a082662b09c1ad45f567faeeb47f22b5fb23895fbe1e651e718e25ca"
-
-[[package]]
-name = "autocfg"
-version = "1.1.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"
-
-[[package]]
-name = "bch_bindgen"
-version = "0.1.0"
-dependencies = [
- "anyhow",
- "bindgen",
- "bitfield",
- "bitflags",
- "byteorder",
- "memoffset",
- "paste",
- "pkg-config",
- "uuid",
-]
-
-[[package]]
-name = "bindgen"
-version = "0.64.0"
-source = "git+https://evilpiepirate.org/git/rust-bindgen.git#f773267b090bf16b9e8375fcbdcd8ba5e88806a8"
-dependencies = [
- "bitflags",
- "cexpr",
- "clang-sys",
- "lazy_static",
- "lazycell",
- "peeking_take_while",
- "proc-macro2",
- "quote",
- "regex",
- "rustc-hash",
- "shlex",
- "syn",
-]
-
-[[package]]
-name = "bitfield"
-version = "0.14.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2d7e60934ceec538daadb9d8432424ed043a904d8e0243f3c6446bce549a46ac"
-
-[[package]]
-name = "bitflags"
-version = "1.3.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"
-
-[[package]]
-name = "byteorder"
-version = "1.5.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1fd0f2584146f6f2ef48085050886acf353beff7305ebd1ae69500e27c67f64b"
-
-[[package]]
-name = "cexpr"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6fac387a98bb7c37292057cffc56d62ecb629900026402633ae9160df93a8766"
-dependencies = [
- "nom",
-]
-
-[[package]]
-name = "clang-sys"
-version = "1.7.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "67523a3b4be3ce1989d607a828d036249522dd9c1c8de7f4dd2dae43a37369d1"
-dependencies = [
- "glob",
- "libc",
-]
-
-[[package]]
-name = "glob"
-version = "0.3.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d2fabcfbdc87f4758337ca535fb41a6d701b65693ce38287d856d1674551ec9b"
-
-[[package]]
-name = "lazy_static"
-version = "1.4.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"
-
-[[package]]
-name = "lazycell"
-version = "1.3.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "830d08ce1d1d941e6b30645f1a0eb5643013d835ce3779a5fc208261dbe10f55"
-
-[[package]]
-name = "libc"
-version = "0.2.152"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "13e3bf6590cbc649f4d1a3eefc9d5d6eb746f5200ffb04e5e142700b8faa56e7"
-
-[[package]]
-name = "memchr"
-version = "2.7.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "523dc4f511e55ab87b694dc30d0f820d60906ef06413f93d4d7a1385599cc149"
-
-[[package]]
-name = "memoffset"
-version = "0.8.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d61c719bcfbcf5d62b3a09efa6088de8c54bc0bfcd3ea7ae39fcc186108b8de1"
-dependencies = [
- "autocfg",
-]
-
-[[package]]
-name = "minimal-lexical"
-version = "0.2.1"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a"
-
-[[package]]
-name = "nom"
-version = "7.1.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d273983c5a657a70a3e8f2a01329822f3b8c8172b73826411a55751e404a0a4a"
-dependencies = [
- "memchr",
- "minimal-lexical",
-]
-
-[[package]]
-name = "paste"
-version = "1.0.14"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "de3145af08024dea9fa9914f381a17b8fc6034dfb00f3a84013f7ff43f29ed4c"
-
-[[package]]
-name = "peeking_take_while"
-version = "0.1.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "19b17cddbe7ec3f8bc800887bab5e717348c95ea2ca0b1bf0837fb964dc67099"
-
-[[package]]
-name = "pkg-config"
-version = "0.3.29"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2900ede94e305130c13ddd391e0ab7cbaeb783945ae07a279c268cb05109c6cb"
-
-[[package]]
-name = "proc-macro2"
-version = "1.0.77"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9f9b1511a24c627ab3e92b48be4b32f8d0ea91ee351edd87fbf650aadd336340"
-dependencies = [
- "unicode-ident",
-]
-
-[[package]]
-name = "quote"
-version = "1.0.35"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "291ec9ab5efd934aaf503a6466c5d5251535d108ee747472c3977cc5acc868ef"
-dependencies = [
- "proc-macro2",
-]
-
-[[package]]
-name = "regex"
-version = "1.10.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "380b951a9c5e80ddfd6136919eef32310721aa4aacd4889a8d39124b026ab343"
-dependencies = [
- "aho-corasick",
- "memchr",
- "regex-automata",
- "regex-syntax",
-]
-
-[[package]]
-name = "regex-automata"
-version = "0.4.3"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5f804c7828047e88b2d32e2d7fe5a105da8ee3264f01902f796c8e067dc2483f"
-dependencies = [
- "aho-corasick",
- "memchr",
- "regex-syntax",
-]
-
-[[package]]
-name = "regex-syntax"
-version = "0.8.2"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c08c74e62047bb2de4ff487b251e4a92e24f48745648451635cec7d591162d9f"
-
-[[package]]
-name = "rustc-hash"
-version = "1.1.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2"
-
-[[package]]
-name = "shlex"
-version = "1.2.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a7cee0529a6d40f580e7a5e6c495c8fbfe21b7b52795ed4bb5e62cdf92bc6380"
-
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
-[[package]]
-name = "unicode-ident"
-version = "1.0.12"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b"
-
-[[package]]
-name = "uuid"
-version = "1.7.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f00cc9702ca12d3c81455259621e676d0f7251cec66a21e98fe2e9a37db93b2a"
-- 
2.43.0

