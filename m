Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C22AF09
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 22:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638993; cv=none; b=VSVNVADjWg+0O3wXhIqe3ShwtMOnJV4XhXxwxCYdoK6IKh6z3Dc40iVJ0oZ0NKqbrhnXUwGVx4FGBY3pzzD56aRDnzIe19urz9bgyadqxNoVgBzgUu9Aud2KPyxxA5rL3j6K+gjDea3TCISwoA5LxYZTceVZhnbkoSFFh4cvCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638993; c=relaxed/simple;
	bh=b/ht21e45pqw1/ShnztXfNNj2KgCn8VxUaK1Hxs+agY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwHW2DZyUoI8LmZ6JU2EM8IfGqyfBWQ09rMiyHuGUIvPpjsc8j1AvU687kksBPVyBLeNgXAt8Z3IR7Js7v+b9PPG8zW0r5aoMcWcdsI/JMw0VjE93Tu1G740ewrFhhrO5iqjQ3U0Up0bbSLDkN5akfr6Q6WffQmosmrfb5ZQWGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYbi/RC3; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYbi/RC3"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5b2761611e8so2820491eaf.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 15:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715638991; x=1716243791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHIb9tRtGWU0VPfp1ixdq5HeuizotjKE4Cyncgc7mug=;
        b=mYbi/RC3khr7FoBftaJS8LvNGMrc250TM1YdLwc3vFKqKh8nC5RWCfQqWYTPQGWjzl
         nQdbVOFBInqthnrR3K23c88hzAH7wxUr/jQ1O9qRhubEiAOvoA5lakuk2qphtifhDBO7
         MCCKY7wqxxGeEwNZuoSHwWYxBzZgAHSOB7eOq/tPC3Hx/AjKAE+jxsHqrOldnJQcWecf
         fzX9CnoCWx7p4+L/S7oHRkRd2Q0FoIGIgEalRVdnbb8imF3Mt4IhhNlCy8maJcmzJFEV
         Lgy6tjvid0H4FUDO7h/1dePMo7Wvg3uqEO6kpAPsD6XPyUI0101UX8i77RCXQmF7CjtP
         Jn2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715638991; x=1716243791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHIb9tRtGWU0VPfp1ixdq5HeuizotjKE4Cyncgc7mug=;
        b=ON9yMtrOAlD80fQbk3TKyEHN2J8dhiA8oR0NFsJYHdGKiEmI1y7GbWmwqHEriROaF2
         vjGlP1GHRhMvDSwKg1QUMrWd/rMa70RKbr2x0xtMjlFNl7Yw2f3gl6k5roguUzRg3bfD
         hVnhneh9UN76JTSzxIvWqJ+0bcA/HoBhjGrKkmtQKddgnTDGt2epY3jgA1Os/y9+/RNN
         7CYNBLzuKb6SSmu29FKKEOY0Sg3L4ahqwe243bGaLBctXi7ZXxZhIgMDozlgOjNBzUnO
         xZVMpAcevggMdsRt4RqsXqD3nh3FZywVISxtbuZuoEtj97OAiziN+t9WFlkicK/DGqnS
         9RdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjWIWnJ8WZUQVmBc2ioz6MuVwFjvH8oJkL2sf17u/AvV+0RlvwiXQoXP895MWwVMTOUzZgSxXSI/2yGrzbsfOs7JEUZ17fJauTwL3DRGE=
X-Gm-Message-State: AOJu0YzLtUyIpmlo21RMM3jG3hwIUTjd4m4sLpjBfbuWlNjPj/ySaKXs
	LAgVRSlHPgUv2FElT9qNHH/qcHBWpWB32n+bIYvNqAhqkYC4lg00
X-Google-Smtp-Source: AGHT+IGCTumEfiTbJWDWCxVlQyH3+gVgAbhk0xjlnA7fZlWINYESyq5ySj/SE0f1hE9zv0nZW3prXg==
X-Received: by 2002:a05:6870:4725:b0:23c:3afd:88f6 with SMTP id 586e51a60fabf-24172a4d8e5mr13363704fac.16.1715638990395;
        Mon, 13 May 2024 15:23:10 -0700 (PDT)
Received: from moria.mynetworksettings.com (pool-100-6-165-19.pitbpa.fios.verizon.net. [100.6.165.19])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2a11e8sm494131685a.58.2024.05.13.15.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 15:23:10 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS 2/3] update minimum Rust version to 1.74.0
Date: Mon, 13 May 2024 18:22:26 -0400
Message-ID: <20240513222227.3755093-2-tahbertschinger@gmail.com>
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

The new debug command needs RFC 2145 [1], "Replace old private-in-public
diagnostic with type privacy lints", in order to build succesfully. An
error was reported incorrectly for `parse_command()` in the
`debug::parser` module. This is fixed in Rust version 1.74.0.

[1] https://rust-lang.github.io/rfcs/2145-type-privacy.html

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.lock | 213 ++++++++++++++++++++++++++++-------------------------
 Cargo.toml |   2 +-
 2 files changed, 113 insertions(+), 102 deletions(-)

diff --git a/Cargo.lock b/Cargo.lock
index 22ac0e3b..94e40354 100644
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
+version = "1.0.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e28923312444cdd728e4738b3f9c9cac739500909bb3d3c94b43551b16517648"
+checksum = "a64c907d4e79225ac72e2a354c9ce84d50ebb4586dee56c82b3ee73004f537f5"
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
+version = "1.0.83"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "080e9890a082662b09c1ad45f567faeeb47f22b5fb23895fbe1e651e718e25ca"
+checksum = "25bdb32cbbdce2b519a9cd7df3a678443100e265d5e25ca763b7572a5104f5f3"
 
 [[package]]
 name = "autocfg"
-version = "1.1.0"
+version = "1.3.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa"
+checksum = "0c4b4d0bd25bd0b74681c0ad21497610ce1b7c91b1022cd21c80c6fbdd9476b0"
 
 [[package]]
 name = "bcachefs-tools"
@@ -111,7 +112,7 @@ version = "0.69.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "a00dc851838a2120612785d195287475a3ac45514741da670b735818822129a0"
 dependencies = [
- "bitflags 2.4.2",
+ "bitflags 2.5.0",
  "cexpr",
  "clang-sys",
  "itertools",
@@ -142,9 +143,9 @@ checksum = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"
 
 [[package]]
 name = "bitflags"
-version = "2.4.2"
+version = "2.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ed570934406eb16438a4e976b1b4500774099c13b8cb96eec99f620f05090ddf"
+checksum = "cf4b9d6a944f767f8e5e0db018570623c85f3d925ac718db4e06d0187adb21c1"
 
 [[package]]
 name = "byteorder"
@@ -154,12 +155,9 @@ checksum = "1fd0f2584146f6f2ef48085050886acf353beff7305ebd1ae69500e27c67f64b"
 
 [[package]]
 name = "cc"
-version = "1.0.83"
+version = "1.0.97"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f1174fb0b6ec23863f8b971027804a42614e347eafb0a95bf0b12cdae21fc4d0"
-dependencies = [
- "libc",
-]
+checksum = "099a5357d84c4c61eb35fc8eafa9a79a902c2f76911e5747ced4e032edd8d9b4"
 
 [[package]]
 name = "cexpr"
@@ -189,9 +187,9 @@ dependencies = [
 
 [[package]]
 name = "clap"
-version = "4.4.18"
+version = "4.5.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1e578d6ec4194633722ccf9544794b71b1385c3c027efe0c55db226fc880865c"
+checksum = "90bc066a67923782aa8515dbaea16946c5bcc5addbd668bb80af688e53e548a0"
 dependencies = [
  "clap_builder",
  "clap_derive",
@@ -199,9 +197,9 @@ dependencies = [
 
 [[package]]
 name = "clap_builder"
-version = "4.4.18"
+version = "4.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "4df4df40ec50c46000231c914968278b1eb05098cf8f1b3a518a95030e71d1c7"
+checksum = "ae129e2e766ae0ec03484e609954119f123cc1fe650337e155d03b022f24f7b4"
 dependencies = [
  "anstream",
  "anstyle",
@@ -212,18 +210,18 @@ dependencies = [
 
 [[package]]
 name = "clap_complete"
-version = "4.4.10"
+version = "4.5.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "abb745187d7f4d76267b37485a65e0149edd0e91a4cfcdd3f27524ad86cee9f3"
+checksum = "dd79504325bf38b10165b02e89b4347300f855f273c4cb30c4a3209e6583275e"
 dependencies = [
  "clap",
 ]
 
 [[package]]
 name = "clap_derive"
-version = "4.4.7"
+version = "4.5.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cf9804afaaf59a91e75b022a30fb7229a7901f60c755489cc61c9b423b836442"
+checksum = "528131438037fd55894f62d6e9f068b8f45ac57ffa77517819645d10aed04f64"
 dependencies = [
  "heck",
  "proc-macro2",
@@ -233,15 +231,15 @@ dependencies = [
 
 [[package]]
 name = "clap_lex"
-version = "0.6.0"
+version = "0.7.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "702fc72eb24e5a1e48ce58027a675bc24edd52096d5397d4aea7c6dd9eca0bd1"
+checksum = "98cc8fbded0c607b7ba9dd60cd98df59af97e84d24e49c8557331cfc26d301ce"
 
 [[package]]
 name = "colorchoice"
-version = "1.0.0"
+version = "1.0.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "acbf1af155f9b9ef647e42cdc158db4b64a1b61f743629225fde6f3e0be2a7c7"
+checksum = "0b6a852b24ab71dffc585bcb46eaf7959d175cb865a7152e35b348d1b2960422"
 
 [[package]]
 name = "colored"
@@ -255,9 +253,9 @@ dependencies = [
 
 [[package]]
 name = "either"
-version = "1.9.0"
+version = "1.11.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a26ae43d7bcc3b814de94796a5e736d4029efb0ee900c12e2d54c993ad1a1e07"
+checksum = "a47c1c47d2f5964e29c61246e81db715514cd532db6b5116a25ea3c03d6780a2"
 
 [[package]]
 name = "errno"
@@ -272,9 +270,9 @@ dependencies = [
 
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
@@ -298,9 +296,9 @@ checksum = "d2fabcfbdc87f4758337ca535fb41a6d701b65693ce38287d856d1674551ec9b"
 
 [[package]]
 name = "heck"
-version = "0.4.1"
+version = "0.5.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "95505c38b4572b2d910cecb0281560f54b440a19336cbbcb27bf6ce6adc6f5a8"
+checksum = "2304e00983f87ffb38b55b444b5e3b60a884b5d30c0fca7d82fe33449bbe55ea"
 
 [[package]]
 name = "home"
@@ -311,6 +309,12 @@ dependencies = [
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
@@ -334,18 +338,18 @@ checksum = "830d08ce1d1d941e6b30645f1a0eb5643013d835ce3779a5fc208261dbe10f55"
 
 [[package]]
 name = "libc"
-version = "0.2.153"
+version = "0.2.154"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9c198f91728a82281a64e1f4f9eeb25d82cb32a5de251c6bd1b5154d63a8e7bd"
+checksum = "ae743338b92ff9146ce83992f766a31066a91a8c84a45e0e9f21e7cf6de6d346"
 
 [[package]]
 name = "libloading"
-version = "0.8.1"
+version = "0.8.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c571b676ddfc9a8c12f1f3d3085a7b163966a8fd8098a90640953ce5f6170161"
+checksum = "0c2a198fb6b0eada2a8df47933734e6d35d350665a33a3593d7164fa52c75c19"
 dependencies = [
  "cfg-if",
- "windows-sys 0.48.0",
+ "windows-targets 0.52.5",
 ]
 
 [[package]]
@@ -366,15 +370,15 @@ checksum = "01cda141df6706de531b6c46c3a33ecca755538219bd484262fa09410c13539c"
 
 [[package]]
 name = "log"
-version = "0.4.20"
+version = "0.4.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b5e6163cb8c49088c2c36f57875e58ccd8c87c7427f7fbd50ea6710b2f3f2e8f"
+checksum = "90ed8c1e510134f979dbc4f070f87d4313098b704861a105fe34231c70a3901c"
 
 [[package]]
 name = "memchr"
-version = "2.7.1"
+version = "2.7.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "523dc4f511e55ab87b694dc30d0f820d60906ef06413f93d4d7a1385599cc149"
+checksum = "6c8640c5d730cb13ebd907d8d04b52f55ac9a2eec55b440c8892f40d56c76c1d"
 
 [[package]]
 name = "memoffset"
@@ -409,21 +413,21 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
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
@@ -431,27 +435,27 @@ dependencies = [
 
 [[package]]
 name = "proc-macro2"
-version = "1.0.78"
+version = "1.0.82"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e2422ad645d89c99f8f3e6b88a9fdeca7fabeac836b1002371c4367c8f984aae"
+checksum = "8ad3d49ab951a01fbaafe34f2ec74122942fe18a3f9814c3268f1bb72042131b"
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
+version = "1.10.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b62dbe01f0b06f9d8dc7d49e05a0785f153b00b2c227856282f671e0318c9b15"
+checksum = "c117dbdfde9c8308975b6a18d71f3f385c89461f7b3fb054288ecf2a2058ba4c"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -461,9 +465,9 @@ dependencies = [
 
 [[package]]
 name = "regex-automata"
-version = "0.4.5"
+version = "0.4.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5bb987efffd3c6d0d8f5f89510bb458559eab11e4f869acb20bf845e016259cd"
+checksum = "86b83b8b9847f9bf95ef68afb0b8e6cdb80f498442f5179a29fad448fcc1eaea"
 dependencies = [
  "aho-corasick",
  "memchr",
@@ -472,9 +476,9 @@ dependencies = [
 
 [[package]]
 name = "regex-syntax"
-version = "0.8.2"
+version = "0.8.3"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "c08c74e62047bb2de4ff487b251e4a92e24f48745648451635cec7d591162d9f"
+checksum = "adad44e29e4c806119491a7f06f03de4d1af22c3a680dd47f1e6e179439d1f56"
 
 [[package]]
 name = "rpassword"
@@ -505,12 +509,12 @@ checksum = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2"
 
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
+ "bitflags 2.5.0",
+ "errno 0.3.9",
  "libc",
  "linux-raw-sys",
  "windows-sys 0.52.0",
@@ -524,15 +528,15 @@ checksum = "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"
 
 [[package]]
 name = "strsim"
-version = "0.10.0"
+version = "0.11.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "73473c0e59e6d5812c5dfe2a064a6444949f089e20eec9a2e5506596494e4623"
+checksum = "7da8b5736845d9f2fcb837ea5d9e2628564b3b043a70948a3f0b778838c5fb4f"
 
 [[package]]
 name = "syn"
-version = "2.0.48"
+version = "2.0.63"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0f3531638e407dfc0814761abb7c00a5b54992b849452a0646b7f65c9f770f3f"
+checksum = "bf5be731623ca1a1fb7d8be6f261a3be6d3e2337b8a1f97be944d020c8fcb704"
 dependencies = [
  "proc-macro2",
  "quote",
@@ -574,9 +578,9 @@ checksum = "711b9620af191e0cdc7468a8d14e709c3dcdb115b36f838e601583af800a370a"
 
 [[package]]
 name = "uuid"
-version = "1.7.0"
+version = "1.8.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f00cc9702ca12d3c81455259621e676d0f7251cec66a21e98fe2e9a37db93b2a"
+checksum = "a183cf7feeba97b4dd1c0d46788634f6221d87fa961b305bed08c851829efcc0"
 
 [[package]]
 name = "which"
@@ -627,7 +631,7 @@ version = "0.52.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "282be5f36a8ce781fad8c8ae18fa3f9beff57ec1b52cb3de0789201425d9a33d"
 dependencies = [
- "windows-targets 0.52.0",
+ "windows-targets 0.52.5",
 ]
 
 [[package]]
@@ -647,17 +651,18 @@ dependencies = [
 
 [[package]]
 name = "windows-targets"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8a18201040b24831fbb9e4eb208f8892e1f50a37feb53cc7ff887feb8f50e7cd"
+checksum = "6f0713a46559409d202e70e28227288446bf7841d3211583a4b53e3f6d96e7eb"
 dependencies = [
- "windows_aarch64_gnullvm 0.52.0",
- "windows_aarch64_msvc 0.52.0",
- "windows_i686_gnu 0.52.0",
- "windows_i686_msvc 0.52.0",
- "windows_x86_64_gnu 0.52.0",
- "windows_x86_64_gnullvm 0.52.0",
- "windows_x86_64_msvc 0.52.0",
+ "windows_aarch64_gnullvm 0.52.5",
+ "windows_aarch64_msvc 0.52.5",
+ "windows_i686_gnu 0.52.5",
+ "windows_i686_gnullvm",
+ "windows_i686_msvc 0.52.5",
+ "windows_x86_64_gnu 0.52.5",
+ "windows_x86_64_gnullvm 0.52.5",
+ "windows_x86_64_msvc 0.52.5",
 ]
 
 [[package]]
@@ -668,9 +673,9 @@ checksum = "2b38e32f0abccf9987a4e3079dfb67dcd799fb61361e53e2882c3cbaf0d905d8"
 
 [[package]]
 name = "windows_aarch64_gnullvm"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cb7764e35d4db8a7921e09562a0304bf2f93e0a51bfccee0bd0bb0b666b015ea"
+checksum = "7088eed71e8b8dda258ecc8bac5fb1153c5cffaf2578fc8ff5d61e23578d3263"
 
 [[package]]
 name = "windows_aarch64_msvc"
@@ -680,9 +685,9 @@ checksum = "dc35310971f3b2dbbf3f0690a219f40e2d9afcf64f9ab7cc1be722937c26b4bc"
 
 [[package]]
 name = "windows_aarch64_msvc"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bbaa0368d4f1d2aaefc55b6fcfee13f41544ddf36801e793edbbfd7d7df075ef"
+checksum = "9985fd1504e250c615ca5f281c3f7a6da76213ebd5ccc9561496568a2752afb6"
 
 [[package]]
 name = "windows_i686_gnu"
@@ -692,9 +697,15 @@ checksum = "a75915e7def60c94dcef72200b9a8e58e5091744960da64ec734a6c6e9b3743e"
 
 [[package]]
 name = "windows_i686_gnu"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a28637cb1fa3560a16915793afb20081aba2c92ee8af57b4d5f28e4b3e7df313"
+checksum = "88ba073cf16d5372720ec942a8ccbf61626074c6d4dd2e745299726ce8b89670"
+
+[[package]]
+name = "windows_i686_gnullvm"
+version = "0.52.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "87f4261229030a858f36b459e748ae97545d6f1ec60e5e0d6a3d32e0dc232ee9"
 
 [[package]]
 name = "windows_i686_msvc"
@@ -704,9 +715,9 @@ checksum = "8f55c233f70c4b27f66c523580f78f1004e8b5a8b659e05a4eb49d4166cca406"
 
 [[package]]
 name = "windows_i686_msvc"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ffe5e8e31046ce6230cc7215707b816e339ff4d4d67c65dffa206fd0f7aa7b9a"
+checksum = "db3c2bf3d13d5b658be73463284eaf12830ac9a26a90c717b7f771dfe97487bf"
 
 [[package]]
 name = "windows_x86_64_gnu"
@@ -716,9 +727,9 @@ checksum = "53d40abd2583d23e4718fddf1ebec84dbff8381c07cae67ff7768bbf19c6718e"
 
 [[package]]
 name = "windows_x86_64_gnu"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3d6fa32db2bc4a2f5abeacf2b69f7992cd09dca97498da74a151a3132c26befd"
+checksum = "4e4246f76bdeff09eb48875a0fd3e2af6aada79d409d33011886d3e1581517d9"
 
 [[package]]
 name = "windows_x86_64_gnullvm"
@@ -728,9 +739,9 @@ checksum = "0b7b52767868a23d5bab768e390dc5f5c55825b6d30b86c844ff2dc7414044cc"
 
 [[package]]
 name = "windows_x86_64_gnullvm"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "1a657e1e9d3f514745a572a6846d3c7aa7dbe1658c056ed9c3344c4109a6949e"
+checksum = "852298e482cd67c356ddd9570386e2862b5673c85bd5f88df9ab6802b334c596"
 
 [[package]]
 name = "windows_x86_64_msvc"
@@ -740,6 +751,6 @@ checksum = "ed94fce61571a4006852b7389a063ab983c02eb1bb37b47f8272ce92d06d9538"
 
 [[package]]
 name = "windows_x86_64_msvc"
-version = "0.52.0"
+version = "0.52.5"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "dff9641d1cd4be8d1a070daf9e3773c5f67e78b4d9d42263020c057706765c04"
+checksum = "bec47e5bfd1bff0eeaf6d8b485cc1074891a197ab4225d504cb7a1ab88b02bf0"
diff --git a/Cargo.toml b/Cargo.toml
index 17650563..9c2513db 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -3,7 +3,7 @@ name = "bcachefs-tools"
 version = "0.3.1"
 authors = ["Yuxuan Shui <yshuiv7@gmail.com>", "Kayla Firestack <dev@kaylafire.me>", "Kent Overstreet <kent.overstreet@linux.dev>" ]
 edition = "2021"
-rust-version = "1.70"
+rust-version = "1.74"
 
 [[bin]]
 name = "bcachefs"
-- 
2.43.0

