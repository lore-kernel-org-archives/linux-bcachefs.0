Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804D520E6
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 05:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdKM/v0P"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bc332d3a8cso538243039f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jan 2024 21:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705296382; x=1705901182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8w/MEEieB5XqqkKfZJp7uZa44ETXb37dN71M/sYvDmo=;
        b=cdKM/v0PfAAJOON4Tba2hGfcBFRIqvLFNnWoLgLbISySn7y6O8HC0Qu2Z1lSogR0Mk
         gsnQARx85YMNVrM7JSuaIwRjBa4OmrsqXxCc2TSVmnKEs9YKeScu2YEv+K0VtQzGWn7T
         tL3SOu5UYwoKLg3Gbsjigdlyr3dyCx34lUwFIvApKqc2YzfjGG9+g4iKhvzTPz5SrYNE
         tlQ/LbCu3bttPbOePZChhvILuL0IRZBWHsrCw52pkJTOIAtJsu0/hztqclqvNmH753iH
         RE/H9/3TY8IGYruGDaY35MzZuufuMDMtGmCJy6I5fqBLsNyKwhOSxlgK1/7JvG4q9tj8
         5R7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705296382; x=1705901182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8w/MEEieB5XqqkKfZJp7uZa44ETXb37dN71M/sYvDmo=;
        b=BDpExbFdSUJ0n1syy0xMd+1pbEnCnMCZGlw4v42v6qd7UOVsNt3wHwuAsZWRYwrH9U
         CXKb8dv5xEJZ4rKAJAFc4835LoaWW1b+bSglLztk61vkdTnY3joiwfxsRYvBkGRd6Giv
         Mn4EocY6Z/cLffyM+AA8YQHLLVbj5i4PqPaJ6l/5wivGwb/oMQ9gxdc1wUy+sTAzerj/
         5x83SHuO6F4mq9/hJCFQvlGLseW62KuNn7h1KyAxtHmiBRE0Ua2CS56LLFdy/61nUVQu
         ZGt0ddFBHZRnZqSMNvp+jMgMGlknX8TW0oPCp/PE8dETpqVg/qdyKjsNkQ6CRmvgTumv
         Uz2g==
X-Gm-Message-State: AOJu0YweLRlqNT2LcvcgoiD7r9kHxJ1iirlNnX5pq3ScFA+U8MXBSMzv
	nj7ldRDysE+HohUQS1DR+GA=
X-Google-Smtp-Source: AGHT+IGa9dBrJycxaSwDj0VCdmpFdy2DK59uvIPS/yNqYaXhEWccZ77OkIGgcHYk+ngJr2I3dzZg7A==
X-Received: by 2002:a92:c14c:0:b0:35d:763a:926c with SMTP id b12-20020a92c14c000000b0035d763a926cmr6143993ilh.114.1705296382437;
        Sun, 14 Jan 2024 21:26:22 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id i2-20020a056e020ec200b0035faf00c555sm2704129ilk.31.2024.01.14.21.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jan 2024 21:26:21 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS 0/2] convert main() from C to Rust
Date: Sun, 14 Jan 2024 22:24:49 -0700
Message-ID: <20240115052451.145611-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This converts the top-level main() of the bcachefs command line tool
from C to Rust.

The first patch does all the work of implementing a new main(), updating
the build process, and making things look for the executable in its new
location which is now rust-src/target/release/bcachefs.

The second patch removes the Library crate from the Rust package. This
was needed previously to allow the C program to link in the Rust
functions, but that doesn't happen anymore.

It seems likely that a bcachefs-tools library will be needed in the
future; for example see this request [1] on GitHub. This library will
have a different external-focused API as opposed to the previous library
that provided an internal API for the bcachefs tool itself. Considering
Rust's structure of one library crate per package, removing the current
library makes room for that requested library.

I tried to update everything to account for the new location of the
bcachefs executable, but let me know if anyone sees something I missed.
I could not figure out how this is set for the Debian package so it's
possible I missed something there...

[1] https://github.com/koverstreet/bcachefs-tools/issues/188


Thomas Bertschinger (2):
  convert main() from C to Rust
  remove library from bcachefs-tools Rust package

 Makefile                                      |  21 +--
 bcachefs.c                                    | 127 +-----------------
 cmds.h                                        |   6 +-
 rust-src/Cargo.lock                           |   2 +-
 rust-src/Cargo.toml                           |   7 +-
 rust-src/bch_bindgen/build.rs                 |   6 +
 .../bch_bindgen/src/libbcachefs_wrapper.h     |   2 +
 rust-src/build.rs                             |  21 +++
 rust-src/src/bcachefs.rs                      | 120 +++++++++++++++++
 rust-src/src/cmd_main.rs                      |  34 -----
 .../src/{ => commands}/cmd_completions.rs     |   3 +-
 rust-src/src/{ => commands}/cmd_list.rs       |   3 +-
 rust-src/src/{ => commands}/cmd_mount.rs      |  11 +-
 rust-src/src/{ => commands}/logger.rs         |   0
 rust-src/src/commands/mod.rs                  |  31 +++++
 rust-src/src/lib.rs                           |  54 --------
 tests/util.py                                 |   2 +-
 17 files changed, 214 insertions(+), 236 deletions(-)
 create mode 100644 rust-src/build.rs
 create mode 100644 rust-src/src/bcachefs.rs
 delete mode 100644 rust-src/src/cmd_main.rs
 rename rust-src/src/{ => commands}/cmd_completions.rs (84%)
 rename rust-src/src/{ => commands}/cmd_list.rs (98%)
 rename rust-src/src/{ => commands}/cmd_mount.rs (94%)
 rename rust-src/src/{ => commands}/logger.rs (100%)
 create mode 100644 rust-src/src/commands/mod.rs
 delete mode 100644 rust-src/src/lib.rs

-- 
2.43.0

