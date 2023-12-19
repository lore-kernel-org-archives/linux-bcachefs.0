Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFD40BE1
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 23:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bBukyUIe"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7b7fd9e17d8so20008639f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 15:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703029173; x=1703633973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XKn42vK7xVV1OyQ2OYvhbhZ6DPSota/GkNaF5LUHp7c=;
        b=bBukyUIewInoZKDw4Q4clPrgcW1EYKuG5Q1QuxAf6Zuj6AGmrm7j48o9PsGpbmxjg6
         8nwZPVfGNVDMpmln3XCjZcxNnjiKB1N9tLfYD8srgDzaBD3O+/W1iv8+pYuhL35qqhH7
         fx0VKsB1a7tyl42/lJa3jWYHhYhWNpJP070fFKEgxHthu5ulDQ4y+rDAIdDqRu7k6/LJ
         fN5THXlFOsyuxAY9s8v3omjeVPnA8PQ4RDs1OwGlwKlYD6Lb+dZM2ABVPGPdOazR0GR+
         DioXkTtClAl9aUQalCnKu6728YjOrWL3yWy1ZzegmhNIWzL+q5YgLPbTNRWRAcVeTiOI
         0pMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703029173; x=1703633973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XKn42vK7xVV1OyQ2OYvhbhZ6DPSota/GkNaF5LUHp7c=;
        b=eUr4S8M6zYzMHy/s8MpJyl5nfWmuKA7pgxV2JW5RllB3shZJHv/I63+k2Dw+ibnfh4
         9xk+rq88b24tCdMvZ7vg7t2PkRhvv8+KZzRb3lhLcHH92XZTSnYG9opTjjSq3p5sKG3f
         9LkXDPSMS1gCeFKD0E6FV9hXGNuTICOAN1TOan59UFMDTDQZ7BjlLFoMXdHUSZpZHM1L
         zySCOylQ/ViThS9y/bcLDTcbCJ9LYVCPxbxGrpYRfJSm1y+AdV3sK+85Pd9665WRee8R
         gHoI9B+6k24+V+bfckccQ87mlT4tKFc0hkNVrUp21gR8ZaSZW8FlHm0UFL3DbIegaLSA
         Zk6g==
X-Gm-Message-State: AOJu0YxQ0vfLEyLWCNjDLz08J9vOatjw7T2GodcLTShT3HX8cMHY62mq
	eDlhGaC+zAwkMFaOvrWvTK3mGjpfeyKodw==
X-Google-Smtp-Source: AGHT+IEuYp+53nehh9JVwf4lbH0gynbX9vfwrzdbj9dCK1P9tTKfAjVwkdicvyojeeArUyjxcGn9iw==
X-Received: by 2002:a5d:9a86:0:b0:7b7:2bb3:2b24 with SMTP id c6-20020a5d9a86000000b007b72bb32b24mr15630255iom.43.1703029173389;
        Tue, 19 Dec 2023 15:39:33 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id ca26-20020a0566381c1a00b0046b3f7528e9sm1727324jab.82.2023.12.19.15.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 15:39:33 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] docs: add llvm-config dependency for arch, fedora
Date: Tue, 19 Dec 2023 16:38:47 -0700
Message-ID: <20231219233847.5621-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds on to 446ec6b092cc ("docs: mention that libclang is
required"). That commit updated the dependency list for Debian. This
adds the packages needed to get llvm-config for arch and fedora.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 INSTALL.md | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/INSTALL.md b/INSTALL.md
index 2928ed9..7197d2f 100644
--- a/INSTALL.md
+++ b/INSTALL.md
@@ -34,13 +34,13 @@ Fedora: install the "Development tools" group along with:
 dnf install -y libaio-devel libsodium-devel \
     libblkid-devel libzstd-devel zlib-devel userspace-rcu-devel \
     lz4-devel libuuid-devel valgrind-devel keyutils-libs-devel \
-    findutils udev systemd-devel
+    findutils udev systemd-devel llvm-devel
 ```
 
 Arch: install bcachefs-tools-git from the AUR.
 Or to build from source, install build dependencies with
 ```shell
-pacman -S base-devel libaio keyutils libsodium liburcu zstd valgrind
+pacman -S base-devel libaio keyutils libsodium liburcu zstd valgrind llvm
 ```
 
 Then, just `make && make install`
-- 
2.43.0

