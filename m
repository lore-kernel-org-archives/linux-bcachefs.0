Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC827492
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987393; cv=none; b=ea4MHCWg7OgAZ5EZ0MEbOB3lkqZzC/BBqI/cTbnL4O49SNzrs8xs5E8HmX1A629DOK45p2P1iWi4Dz5Ns0Lb++IliKcChuM7Cvpj8f3W5LtH7dbsJOzawjZuFIb0svv81RSpLbO7rfHHIm9S2Nid7yoi8av+YqPOqR61xv8gAeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987393; c=relaxed/simple;
	bh=WWOp3kZbg1VcrL5UAXa9xj19DYDcBAyd0mLCQxU6xGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tU1Ez/wnF7OgfNvQYo6BHuGsFh2RYnNvHHae5lcpBPzrOXeuFLMFzYZED5KIYv9/H4Z1mx7hJ+cS/T1E0Q9m5SVtqX7z4goGVXme7mU+0moBicNoR/MdQ7pf3G2Sg/i8ZEQ+PDMSgX6Cr7nQz2o8GWc/L3+Y1zKFevQZiytJ7F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fx5dI7gp; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fx5dI7gp"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7fd3dbc01deso175118939f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987390; x=1721592190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWhXUYl00dhkYFDDz8rO68TnvxAkfCWQAKs0UYkiD3A=;
        b=fx5dI7gp4JFC4G3VeKdt7QMT6Na8m84P/kfb4bSQMDGjePZetKKObKpFEcJERfM7oz
         1d0M9gRm5keDL33/kBk3K4S2LPabPcxXjW8gRGQr6eBLqcHid/3ov7AmXu2YP5T41oIV
         q576AMrOcPme77Z5amSyP/IaFxXeBzaIfug2UWo4CZq4KOsUEDvebPTSIiWcfXkLcupj
         t0XrbYqvqIrnoIuzOCxz7Ujir3FoNNr3+7mq2/RRRazJEPK9bGlUmAMOaKVVKBd2p2JV
         hD+LWKRr8x9LjhBMrH69CsfyKTJ4mDPdP4BWpxbGDWqY3Sb0u2ou99akQ+S0DfF9clx3
         Te0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987390; x=1721592190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWhXUYl00dhkYFDDz8rO68TnvxAkfCWQAKs0UYkiD3A=;
        b=VFLokG1Q8g1//dSyYtd5u2ZU6mUUdDjBFTXrHZ+8x7C6aeDul9NtAoHIqdmjiQSVoX
         GiLUPrewzJNqWc3CbAkxaVCSxvar292/WeKNeAVy+WdIIzGEuGGfAb4pUWXG+7+vvfdf
         DyyQnr2zbCKb5CIa7b+iDWTgyKVYBrMWRgmYZEcxBecZ+iO9crVqerpYTYk3PYsrJdHQ
         Bg1fmUFR8hFkaZmyyIeQPJrdsPxYlM25atUGY1Qw0XtIMdt5zn/d91spLrUNQnK2vRIc
         1OAXJvvEUQoyPeU9zoUkDA3DH/h/WMCRI28JkCGluVPAS8uzyUXz/KodxtogBBghAiU3
         j3GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIj0Wd7ZXh+pQ3njcIfL8A9AsCvbtLKICfmlGO0bbs5QY2MaeO2a3mAN79OURhZDg4b+cpq1/C0ZvVg9zci/Zsshe0fozmdgylQtNVO5Y=
X-Gm-Message-State: AOJu0YxwcD1jySjjpz3IrgB1x1UjxKcDJNk08e0npg3M/PJZHRgkHqyt
	ephe17Ctc7K4xnFlCumVOVUtB0wpDb+vHq5OWxFEQCIcSzSfEiYo
X-Google-Smtp-Source: AGHT+IGolEOvYDusAxLx3Hltn3/q93mYO5nDrrrUb1Yfq8SHl3CUpX6FaFZAjXXrGcTMpQLG+W0nPg==
X-Received: by 2002:a6b:e80f:0:b0:7fa:2902:aec5 with SMTP id ca18e2360f4ac-80004173005mr1753486539f.17.1720987390114;
        Sun, 14 Jul 2024 13:03:10 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:03:09 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 2/5] update minimum Rust version to 1.74.0
Date: Sun, 14 Jul 2024 14:02:23 -0600
Message-ID: <20240714200226.746471-3-tahbertschinger@gmail.com>
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

The new debug command needs RFC 2145 [1], "Replace old private-in-public
diagnostic with type privacy lints", in order to build succesfully. An
error was reported incorrectly for `parse_command()` in the
`debug::parser` module. This is fixed in Rust version 1.74.0.

[1] https://rust-lang.github.io/rfcs/2145-type-privacy.html

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock | 233 ++++++++++++++++++++++++++++-------------------------
 Cargo.toml |   2 +-
 2 files changed, 123 insertions(+), 112 deletions(-)

diff --git a/Cargo.lock b/Cargo.lock
index 1e109998..9b781755 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -4,56 +4,57 @@ version = 3
 
 [[package]]
 name = "aho-corasick"
-version = "1.1.2"
+version = "1.1.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b2969dcb958b36655471fc61f7e416fa76033bdd4bfed0678d8fee1e2d07a1f0"
+checksum = "8e60d3430d3a69478ad0993f19238d2df97c507009a52b3c10addcd7f6bcb916"
 dependencies = [
  "memchr",
 ]
 
 [[package]]
 name = "anstream"
-version = "0.6.11"
+version = "0.6.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6e2e1ebcb11de5c03c67de28a7df593d32191b44939c482e97702baaaa6ab6a5"
+checksum = "418c75fa768af9c03be99d17643f93f79bbba589895012a80e3452a19ddda15b"
 dependencies = [
  "anstyle",
  "anstyle-parse",
  "anstyle-query",
  "anstyle-wincon",
  "colorchoice",
+ "is_terminal_polyfill",
  "utf8parse",
 ]
 
 [[package]]
 name = "anstyle"
-version = "1.0.6"
+version = "1.0.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8901269c6307e8d93993578286ac0edf7f195079ffff5ebdeea6a59ffb7e36bc"
+checksum = "038dfcf04a5feb68e9c60b21c9625a54c2c0616e79b72b0fd87075a056ae1d1b"
 
 [[package]]
 name = "anstyle-parse"
-version = "0.2.3"
+version = "0.2.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c75ac65da39e5fe5ab759307499ddad880d724eed2f6ce5b5e8a26f4f387928c"
+checksum = "c03a11a9034d92058ceb6ee011ce58af4a9bf61491aa7e1e59ecd24bd40d22d4"
 dependencies = [
  "utf8parse",
 ]
 
 [[package]]
 name = "anstyle-query"
-version = "1.0.2"
+version = "1.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e28923312444cdd728e4738b3f9c9cac739500909bb3d3c94b43551b16517648"
+checksum = "ad186efb764318d35165f1758e7dcef3b10628e26d41a44bc5550652e6804391"
 dependencies = [
  "windows-sys 0.52.0",
 ]
 
 [[package]]
 name = "anstyle-wincon"
-version = "3.0.2"
+version = "3.0.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1cd54b81ec8d6180e24654d0b371ad22fc3dd083b6ff8ba325b72e00c87660a7"
+checksum = "61a38449feb7068f52bb06c12759005cf459ee52bb4adc1d5a7c4322d716fb19"
 dependencies = [
  "anstyle",
  "windows-sys 0.52.0",
@@ -61,15 +62,15 @@ dependencies = [
 
 [[package]]
 name = "anyhow"
-version = "1.0.79"
+version = "1.0.86"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "080e9890a082662b09c1ad45f567faeeb47f22b5fb23895fbe1e651e718e25ca"
+checksum = "b3d1d046238990b9cf5bcde22a3fb3584ee5cf65fb2765f454ed428c7a0063da"
 
 [[package]]
 name = "autocfg"
-version = "1.1.0"
+version = "1.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"
+checksum = "0c4b4d0bd25bd0b74681c0ad21497610ce1b7c91b1022cd21c80c6fbdd9476b0"
 
 [[package]]
 name = "bcachefs-tools"
@@ -114,7 +115,7 @@ version = "0.69.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a00dc851838a2120612785d195287475a3ac45514741da670b735818822129a0"
 dependencies = [
- "bitflags 2.4.2",
+ "bitflags 2.6.0",
  "cexpr",
  "clang-sys",
  "itertools",
@@ -145,9 +146,9 @@ checksum = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"
 
 [[package]]
 name = "bitflags"
-version = "2.4.2"
+version = "2.6.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ed570934406eb16438a4e976b1b4500774099c13b8cb96eec99f620f05090ddf"
+checksum = "b048fb63fd8b5923fc5aa7b340d8e156aec7ec02f0c78fa8a6ddc2613f6f71de"
 
 [[package]]
 name = "byteorder"
@@ -157,12 +158,9 @@ checksum = "1fd0f2584146f6f2ef48085050886acf353beff7305ebd1ae69500e27c67f64b"
 
 [[package]]
 name = "cc"
-version = "1.0.83"
+version = "1.0.104"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f1174fb0b6ec23863f8b971027804a42614e347eafb0a95bf0b12cdae21fc4d0"
-dependencies = [
- "libc",
-]
+checksum = "74b6a57f98764a267ff415d50a25e6e166f3831a5071af4995296ea97d210490"
 
 [[package]]
 name = "cexpr"
@@ -181,9 +179,9 @@ checksum = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"
 
 [[package]]
 name = "clang-sys"
-version = "1.7.0"
+version = "1.8.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "67523a3b4be3ce1989d607a828d036249522dd9c1c8de7f4dd2dae43a37369d1"
+checksum = "0b023947811758c97c59bf9d1c188fd619ad4718dcaa767947df1cadb14f39f4"
 dependencies = [
  "glob",
  "libc",
@@ -192,9 +190,9 @@ dependencies = [
 
 [[package]]
 name = "clap"
-version = "4.4.18"
+version = "4.5.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1e578d6ec4194633722ccf9544794b71b1385c3c027efe0c55db226fc880865c"
+checksum = "84b3edb18336f4df585bc9aa31dd99c036dfa5dc5e9a2939a722a188f3a8970d"
 dependencies = [
  "clap_builder",
  "clap_derive",
@@ -202,9 +200,9 @@ dependencies = [
 
 [[package]]
 name = "clap_builder"
-version = "4.4.18"
+version = "4.5.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4df4df40ec50c46000231c914968278b1eb05098cf8f1b3a518a95030e71d1c7"
+checksum = "c1c09dd5ada6c6c78075d6fd0da3f90d8080651e2d6cc8eb2f1aaa4034ced708"
 dependencies = [
  "anstream",
  "anstyle",
@@ -215,18 +213,18 @@ dependencies = [
 
 [[package]]
 name = "clap_complete"
-version = "4.4.10"
+version = "4.5.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "abb745187d7f4d76267b37485a65e0149edd0e91a4cfcdd3f27524ad86cee9f3"
+checksum = "1d598e88f6874d4b888ed40c71efbcbf4076f1dfbae128a08a8c9e45f710605d"
 dependencies = [
  "clap",
 ]
 
 [[package]]
 name = "clap_derive"
-version = "4.4.7"
+version = "4.5.8"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cf9804afaaf59a91e75b022a30fb7229a7901f60c755489cc61c9b423b836442"
+checksum = "2bac35c6dafb060fd4d275d9a4ffae97917c13a6327903a8be2153cd964f7085"
 dependencies = [
  "heck",
  "proc-macro2",
@@ -236,21 +234,21 @@ dependencies = [
 
 [[package]]
 name = "clap_lex"
-version = "0.6.0"
+version = "0.7.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "702fc72eb24e5a1e48ce58027a675bc24edd52096d5397d4aea7c6dd9eca0bd1"
+checksum = "4b82cf0babdbd58558212896d1a4272303a57bdb245c2bf1147185fb45640e70"
 
 [[package]]
 name = "colorchoice"
-version = "1.0.0"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "acbf1af155f9b9ef647e42cdc158db4b64a1b61f743629225fde6f3e0be2a7c7"
+checksum = "0b6a852b24ab71dffc585bcb46eaf7959d175cb865a7152e35b348d1b2960422"
 
 [[package]]
 name = "either"
-version = "1.9.0"
+version = "1.13.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a26ae43d7bcc3b814de94796a5e736d4029efb0ee900c12e2d54c993ad1a1e07"
+checksum = "60b1af1c220855b6ceac025d3f6ecdd2b7c4894bfe9cd9bda4fbb4bc7c0d4cf0"
 
 [[package]]
 name = "env_logger"
@@ -276,9 +274,9 @@ dependencies = [
 
 [[package]]
 name = "errno"
-version = "0.3.8"
+version = "0.3.9"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a258e46cdc063eb8519c00b9fc845fc47bcfca4130e2f08e88665ceda8474245"
+checksum = "534c5cf6194dfab3db3242765c03bbe257cf92f22b38f6bc0c58d59108a820ba"
 dependencies = [
  "libc",
  "windows-sys 0.52.0",
@@ -302,9 +300,9 @@ checksum = "d2fabcfbdc87f4758337ca535fb41a6d701b65693ce38287d856d1674551ec9b"
 
 [[package]]
 name = "heck"
-version = "0.4.1"
+version = "0.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "95505c38b4572b2d910cecb0281560f54b440a19336cbbcb27bf6ce6adc6f5a8"
+checksum = "2304e00983f87ffb38b55b444b5e3b60a884b5d30c0fca7d82fe33449bbe55ea"
 
 [[package]]
 name = "hermit-abi"
@@ -332,6 +330,12 @@ dependencies = [
  "windows-sys 0.52.0",
 ]
 
+[[package]]
+name = "is_terminal_polyfill"
+version = "1.70.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f8478577c03552c21db0e2724ffb8986a5ce7af88107e6be5d2ee6e158c12800"
+
 [[package]]
 name = "itertools"
 version = "0.12.1"
@@ -343,9 +347,9 @@ dependencies = [
 
 [[package]]
 name = "lazy_static"
-version = "1.4.0"
+version = "1.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"
+checksum = "bbd2bcb4c963f2ddae06a2efc7e9f3591312473c50c6685e1f298068316e66fe"
 
 [[package]]
 name = "lazycell"
@@ -355,18 +359,18 @@ checksum = "830d08ce1d1d941e6b30645f1a0eb5643013d835ce3779a5fc208261dbe10f55"
 
 [[package]]
 name = "libc"
-version = "0.2.153"
+version = "0.2.155"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9c198f91728a82281a64e1f4f9eeb25d82cb32a5de251c6bd1b5154d63a8e7bd"
+checksum = "97b3888a4aecf77e811145cadf6eef5901f4782c53886191b2f693f24761847c"
 
 [[package]]
 name = "libloading"
-version = "0.8.1"
+version = "0.8.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c571b676ddfc9a8c12f1f3d3085a7b163966a8fd8098a90640953ce5f6170161"
+checksum = "e310b3a6b5907f99202fcdb4960ff45b93735d7c7d96b760fcff8db2dc0e103d"
 dependencies = [
  "cfg-if",
- "windows-sys 0.48.0",
+ "windows-targets 0.52.6",
 ]
 
 [[package]]
@@ -381,9 +385,9 @@ dependencies = [
 
 [[package]]
 name = "linux-raw-sys"
-version = "0.4.13"
+version = "0.4.14"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "01cda141df6706de531b6c46c3a33ecca755538219bd484262fa09410c13539c"
+checksum = "78b3ae25bc7c8c38cec158d1f2757ee79e9b3740fbc7ccf0e59e4b08d793fa89"
 
 [[package]]
 name = "log"
@@ -393,9 +397,9 @@ checksum = "a7a70ba024b9dc04c27ea2f0c0548feb474ec5c54bba33a7f72f873a39d07b24"
 
 [[package]]
 name = "memchr"
-version = "2.7.1"
+version = "2.7.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "523dc4f511e55ab87b694dc30d0f820d60906ef06413f93d4d7a1385599cc149"
+checksum = "78ca9ab1a0babb1e7d5695e3530886289c18cf2f87ec19a575a0abdce112e3a3"
 
 [[package]]
 name = "memoffset"
@@ -430,21 +434,21 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
 [[package]]
 name = "paste"
-version = "1.0.14"
+version = "1.0.15"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "de3145af08024dea9fa9914f381a17b8fc6034dfb00f3a84013f7ff43f29ed4c"
+checksum = "57c0d7b74b563b49d38dae00a0c37d4d6de9b432382b2892f0574ddcae73fd0a"
 
 [[package]]
 name = "pkg-config"
-version = "0.3.29"
+version = "0.3.30"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2900ede94e305130c13ddd391e0ab7cbaeb783945ae07a279c268cb05109c6cb"
+checksum = "d231b230927b5e4ad203db57bbcbee2802f6bce620b1e4a9024a07d94e2907ec"
 
 [[package]]
 name = "prettyplease"
-version = "0.2.16"
+version = "0.2.20"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a41cf62165e97c7f814d2221421dbb9afcbcdb0a88068e5ea206e19951c2cbb5"
+checksum = "5f12335488a2f3b0a83b14edad48dca9879ce89b2edd10e80237e4e852dd645e"
 dependencies = [
  "proc-macro2",
  "syn",
@@ -452,27 +456,27 @@ dependencies = [
 
 [[package]]
 name = "proc-macro2"
-version = "1.0.78"
+version = "1.0.86"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2422ad645d89c99f8f3e6b88a9fdeca7fabeac836b1002371c4367c8f984aae"
+checksum = "5e719e8df665df0d1c8fbfd238015744736151d4445ec0836b8e628aae103b77"
 dependencies = [
  "unicode-ident",
 ]
 
 [[package]]
 name = "quote"
-version = "1.0.35"
+version = "1.0.36"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "291ec9ab5efd934aaf503a6466c5d5251535d108ee747472c3977cc5acc868ef"
+checksum = "0fa76aaf39101c457836aec0ce2316dbdc3ab723cdda1c6bd4e6ad4208acaca7"
 dependencies = [
  "proc-macro2",
 ]
 
 [[package]]
 name = "regex"
-version = "1.10.3"
+version = "1.10.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b62dbe01f0b06f9d8dc7d49e05a0785f153b00b2c227856282f671e0318c9b15"
+checksum = "b91213439dad192326a0d7c6ee3955910425f441d7038e0d6933b0aec5c4517f"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -482,9 +486,9 @@ dependencies = [
 
 [[package]]
 name = "regex-automata"
-version = "0.4.5"
+version = "0.4.7"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5bb987efffd3c6d0d8f5f89510bb458559eab11e4f869acb20bf845e016259cd"
+checksum = "38caf58cc5ef2fed281f89292ef23f6365465ed9a41b7a7754eb4e26496c92df"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -493,9 +497,9 @@ dependencies = [
 
 [[package]]
 name = "regex-syntax"
-version = "0.8.2"
+version = "0.8.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c08c74e62047bb2de4ff487b251e4a92e24f48745648451635cec7d591162d9f"
+checksum = "7a66a03ae7c801facd77a29370b4faec201768915ac14a721ba36f20bc9c209b"
 
 [[package]]
 name = "rpassword"
@@ -526,12 +530,12 @@ checksum = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2"
 
 [[package]]
 name = "rustix"
-version = "0.38.31"
+version = "0.38.34"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6ea3e1a662af26cd7a3ba09c0297a31af215563ecf42817c98df621387f4e949"
+checksum = "70dc5ec042f7a43c4a73241207cecc9873a06d45debb38b329f8541d85c2730f"
 dependencies = [
- "bitflags 2.4.2",
- "errno 0.3.8",
+ "bitflags 2.6.0",
+ "errno 0.3.9",
  "libc",
  "linux-raw-sys",
  "windows-sys 0.52.0",
@@ -551,24 +555,24 @@ checksum = "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"
 
 [[package]]
 name = "strsim"
-version = "0.10.0"
+version = "0.11.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "73473c0e59e6d5812c5dfe2a064a6444949f089e20eec9a2e5506596494e4623"
+checksum = "7da8b5736845d9f2fcb837ea5d9e2628564b3b043a70948a3f0b778838c5fb4f"
 
 [[package]]
 name = "strum"
-version = "0.26.2"
+version = "0.26.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5d8cec3501a5194c432b2b7976db6b7d10ec95c253208b45f83f7136aa985e29"
+checksum = "8fec0f0aef304996cf250b31b5a10dee7980c85da9d759361292b8bca5a18f06"
 dependencies = [
  "strum_macros",
 ]
 
 [[package]]
 name = "strum_macros"
-version = "0.26.2"
+version = "0.26.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c6cf59daf282c0a494ba14fd21610a0325f9f90ec9d1231dea26bcb1d696c946"
+checksum = "4c6bee85a5a24955dc440386795aa378cd9cf82acd5f764469152d2270e581be"
 dependencies = [
  "heck",
  "proc-macro2",
@@ -579,9 +583,9 @@ dependencies = [
 
 [[package]]
 name = "syn"
-version = "2.0.48"
+version = "2.0.68"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0f3531638e407dfc0814761abb7c00a5b54992b849452a0646b7f65c9f770f3f"
+checksum = "901fa70d88b9d6c98022e23b4136f9f3e54e4662c3bc1bd1d84a42a9a0f0c1e9"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -626,15 +630,15 @@ checksum = "3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b"
 
 [[package]]
 name = "utf8parse"
-version = "0.2.1"
+version = "0.2.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "711b9620af191e0cdc7468a8d14e709c3dcdb115b36f838e601583af800a370a"
+checksum = "06abde3611657adf66d383f00b093d7faecc7fa57071cce2578660c9f1010821"
 
 [[package]]
 name = "uuid"
-version = "1.7.0"
+version = "1.9.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f00cc9702ca12d3c81455259621e676d0f7251cec66a21e98fe2e9a37db93b2a"
+checksum = "5de17fd2f7da591098415cff336e12965a28061ddace43b59cb3c430179c9439"
 
 [[package]]
 name = "which"
@@ -694,7 +698,7 @@ version = "0.52.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "282be5f36a8ce781fad8c8ae18fa3f9beff57ec1b52cb3de0789201425d9a33d"
 dependencies = [
- "windows-targets 0.52.0",
+ "windows-targets 0.52.6",
 ]
 
 [[package]]
@@ -714,17 +718,18 @@ dependencies = [
 
 [[package]]
 name = "windows-targets"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8a18201040b24831fbb9e4eb208f8892e1f50a37feb53cc7ff887feb8f50e7cd"
+checksum = "9b724f72796e036ab90c1021d4780d4d3d648aca59e491e6b98e725b84e99973"
 dependencies = [
- "windows_aarch64_gnullvm 0.52.0",
- "windows_aarch64_msvc 0.52.0",
- "windows_i686_gnu 0.52.0",
- "windows_i686_msvc 0.52.0",
- "windows_x86_64_gnu 0.52.0",
- "windows_x86_64_gnullvm 0.52.0",
- "windows_x86_64_msvc 0.52.0",
+ "windows_aarch64_gnullvm 0.52.6",
+ "windows_aarch64_msvc 0.52.6",
+ "windows_i686_gnu 0.52.6",
+ "windows_i686_gnullvm",
+ "windows_i686_msvc 0.52.6",
+ "windows_x86_64_gnu 0.52.6",
+ "windows_x86_64_gnullvm 0.52.6",
+ "windows_x86_64_msvc 0.52.6",
 ]
 
 [[package]]
@@ -735,9 +740,9 @@ checksum = "2b38e32f0abccf9987a4e3079dfb67dcd799fb61361e53e2882c3cbaf0d905d8"
 
 [[package]]
 name = "windows_aarch64_gnullvm"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cb7764e35d4db8a7921e09562a0304bf2f93e0a51bfccee0bd0bb0b666b015ea"
+checksum = "32a4622180e7a0ec044bb555404c800bc9fd9ec262ec147edd5989ccd0c02cd3"
 
 [[package]]
 name = "windows_aarch64_msvc"
@@ -747,9 +752,9 @@ checksum = "dc35310971f3b2dbbf3f0690a219f40e2d9afcf64f9ab7cc1be722937c26b4bc"
 
 [[package]]
 name = "windows_aarch64_msvc"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bbaa0368d4f1d2aaefc55b6fcfee13f41544ddf36801e793edbbfd7d7df075ef"
+checksum = "09ec2a7bb152e2252b53fa7803150007879548bc709c039df7627cabbd05d469"
 
 [[package]]
 name = "windows_i686_gnu"
@@ -759,9 +764,15 @@ checksum = "a75915e7def60c94dcef72200b9a8e58e5091744960da64ec734a6c6e9b3743e"
 
 [[package]]
 name = "windows_i686_gnu"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a28637cb1fa3560a16915793afb20081aba2c92ee8af57b4d5f28e4b3e7df313"
+checksum = "8e9b5ad5ab802e97eb8e295ac6720e509ee4c243f69d781394014ebfe8bbfa0b"
+
+[[package]]
+name = "windows_i686_gnullvm"
+version = "0.52.6"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "0eee52d38c090b3caa76c563b86c3a4bd71ef1a819287c19d586d7334ae8ed66"
 
 [[package]]
 name = "windows_i686_msvc"
@@ -771,9 +782,9 @@ checksum = "8f55c233f70c4b27f66c523580f78f1004e8b5a8b659e05a4eb49d4166cca406"
 
 [[package]]
 name = "windows_i686_msvc"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ffe5e8e31046ce6230cc7215707b816e339ff4d4d67c65dffa206fd0f7aa7b9a"
+checksum = "240948bc05c5e7c6dabba28bf89d89ffce3e303022809e73deaefe4f6ec56c66"
 
 [[package]]
 name = "windows_x86_64_gnu"
@@ -783,9 +794,9 @@ checksum = "53d40abd2583d23e4718fddf1ebec84dbff8381c07cae67ff7768bbf19c6718e"
 
 [[package]]
 name = "windows_x86_64_gnu"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3d6fa32db2bc4a2f5abeacf2b69f7992cd09dca97498da74a151a3132c26befd"
+checksum = "147a5c80aabfbf0c7d901cb5895d1de30ef2907eb21fbbab29ca94c5b08b1a78"
 
 [[package]]
 name = "windows_x86_64_gnullvm"
@@ -795,9 +806,9 @@ checksum = "0b7b52767868a23d5bab768e390dc5f5c55825b6d30b86c844ff2dc7414044cc"
 
 [[package]]
 name = "windows_x86_64_gnullvm"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1a657e1e9d3f514745a572a6846d3c7aa7dbe1658c056ed9c3344c4109a6949e"
+checksum = "24d5b23dc417412679681396f2b49f3de8c1473deb516bd34410872eff51ed0d"
 
 [[package]]
 name = "windows_x86_64_msvc"
@@ -807,9 +818,9 @@ checksum = "ed94fce61571a4006852b7389a063ab983c02eb1bb37b47f8272ce92d06d9538"
 
 [[package]]
 name = "windows_x86_64_msvc"
-version = "0.52.0"
+version = "0.52.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dff9641d1cd4be8d1a070daf9e3773c5f67e78b4d9d42263020c057706765c04"
+checksum = "589f6da84c646204747d1270a2a5661ea66ed1cced2631d546fdfb155959f9ec"
 
 [[package]]
 name = "zeroize"
diff --git a/Cargo.toml b/Cargo.toml
index d56d6272..d3b0e753 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -3,7 +3,7 @@ name = "bcachefs-tools"
 version = "1.9.1"
 authors = ["Yuxuan Shui <yshuiv7@gmail.com>", "Kayla Firestack <dev@kaylafire.me>", "Kent Overstreet <kent.overstreet@linux.dev>" ]
 edition = "2021"
-rust-version = "1.70"
+rust-version = "1.74"
 
 [[bin]]
 name = "bcachefs"
-- 
2.45.2

