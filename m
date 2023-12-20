Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA74A983
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Dec 2023 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqNUdJu5"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7ba7c845e1aso4990739f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Dec 2023 14:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703109802; x=1703714602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P2r3U/th1pvJrclbgjAKd3yWSH2XfpNi4OpfHp/0vng=;
        b=PqNUdJu5YAiLzV+WP/D0XJwkoG6t7nF0YjAM3MtrWSWai1hZfAGoMaAFTLryBcXtKJ
         2BXIbobD8Hpy2zvy3OKmBk6fw8ex/V2abO1ePslJ0oNlCTIgN+AjqthAmxZ83ex3sVi4
         btwDrtodxOKMm1rI7UQGdoX4LtkDECBM1ljGDqXTGwLH6rpiSTLEmhr72aCSaKb0xt66
         9fVJObFEDtD+8ur6X9GB/PnzxWBo+eEWUKXi6xnBdR3g8YGgRVwD6KiqN4tfw1fvbmvL
         ujYnwWrzM+52QaLLpGCovKZjkoqKbBphFzRNlKeIwmCAcerlk7ne7gNmaSnpi+5csvgA
         Q3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703109802; x=1703714602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P2r3U/th1pvJrclbgjAKd3yWSH2XfpNi4OpfHp/0vng=;
        b=klAq7ijDAeZSRJDPo0D7g/kjFTVuQz27gxXJNfKmsgWWgneU0NUWyEx9ZCK5kw0Iiu
         cAHfJOvvhmvc1mgdXXVbSSkTST2aG5lKkfN08VNs5ZRHXP9D8MtTuCp70oBDtgTNPl+V
         gtFMHlKY2HCHV8KdVuNA5dE9ZUmllEHB9ynUnVljOlQGdiqI7PKSBoyohBMaMYy/RDKG
         IUS41rzQSea5hBghXvE48I5SMZdMf778OGgxvyjo2CJu58xgP8ueG0NwttQruvKlgFiy
         cFoq3CcKjfPFB7xFL/Wsi4N8xA+MUbdywWOr6dVfLbMUleuvVIoeGVx7VSvIZg+66bn2
         Tu/A==
X-Gm-Message-State: AOJu0YwB8SRVK/xc1gETOXCghQmIqx5Sba3xMxam91sbmn1WMsHbiNwy
	r9Yb1boTELvVqd5ilc9bS+8=
X-Google-Smtp-Source: AGHT+IHSlZXIl5iss7Xmrh9pOPvPZYBhlC++f6CDqQdkD7S1BnsJc0NYkbvfEwxngzS7qUSBFq0tYA==
X-Received: by 2002:a6b:d813:0:b0:7ba:86a8:fb78 with SMTP id y19-20020a6bd813000000b007ba86a8fb78mr24126iob.13.1703109802626;
        Wed, 20 Dec 2023 14:03:22 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id g12-20020a02b70c000000b0046658ae37adsm123439jam.9.2023.12.20.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 14:03:22 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] remove Rust artifacts during `make clean`
Date: Wed, 20 Dec 2023 15:02:28 -0700
Message-ID: <20231220220228.92605-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This should use `cargo clean` instead of `rm -rf ...`. Also,
due to a typo, the `rm` did not actually remove the Rust artifacts.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 8b9bcde..418ffff 100644
--- a/Makefile
+++ b/Makefile
@@ -15,8 +15,10 @@ endif
 
 ifeq ($(BUILD_VERBOSE),1)
   Q =
+  CARGO_CLEAN_ARGS = --verbose
 else
   Q = @
+  CARGO_CLEAN_ARGS = --quiet
 endif
 
 CFLAGS+=-std=gnu11 -O2 -g -MMD -Wall -fPIC			\
@@ -46,9 +48,12 @@ CARGO_ARGS=${CARGO_TOOLCHAIN}
 CARGO=cargo $(CARGO_ARGS)
 CARGO_PROFILE=release
 # CARGO_PROFILE=debug
+CARGO_MANIFEST=--manifest-path rust-src/Cargo.toml
 
 CARGO_BUILD_ARGS=--$(CARGO_PROFILE)
-CARGO_BUILD=$(CARGO) build $(CARGO_BUILD_ARGS)
+CARGO_BUILD=$(CARGO) build $(CARGO_BUILD_ARGS) $(CARGO_MANIFEST)
+
+CARGO_CLEAN=$(CARGO) clean $(CARGO_CLEAN_ARGS) $(CARGO_MANIFEST)
 
 include Makefile.compiler
 
@@ -177,7 +182,7 @@ libbcachefs.a: $(filter-out ./tests/%.o, $(OBJS))
 
 RUST_SRCS=$(shell find rust-src/src rust-src/bch_bindgen/src -type f -iname '*.rs')
 rust-src/target/release/libbcachefs_rust.a: $(RUST_SRCS)
-	$(CARGO_BUILD) --manifest-path rust-src/Cargo.toml
+	$(CARGO_BUILD)
 
 tests/test_helper: $(filter ./tests/%.o, $(OBJS))
 	@echo "    [LD]     $@"
@@ -222,7 +227,7 @@ install_systemd: $(systemd_services) $(systemd_libfiles)
 clean:
 	@echo "Cleaning all"
 	$(Q)$(RM) bcachefs libbcachefs.a tests/test_helper .version *.tar.xz $(OBJS) $(DEPS) $(DOCGENERATED)
-	$(Q)$(RM) -rf rust-src/*/target
+	$(Q)$(CARGO_CLEAN)
 	$(Q)$(RM) -f $(built_scripts)
 
 .PHONY: deb
-- 
2.43.0

