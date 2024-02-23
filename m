Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB7414DFC7
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 22:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708726860; cv=none; b=NYmGDRwzIC20m827dbaD7dzhTTfhZxsgvJ7Oh/NUc0cV6XMmiQzeFQKs7j9GxaHODeAUMk7MKkyGIcrC4AbWCW6Ab1TCswRDbwzAYYZIlj+aTvkCiet+6gKK/eUSYqhYKQvg4/PqQD1n4fJfV9AdI5C4iCE+5h7zKDfH7sCtrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708726860; c=relaxed/simple;
	bh=C6DYqCGoecvmlNV4aTYhOXoE5G2p+ThBTQp1YY/q1i0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k5MoGwVtHOvUaPEXpEOZhrMR12zOAr1DUci35FbXLPKh7AhLd+iQSw9YP+drkaKXKTFqLGo9uB2UfFSPWDNqAy/KyMMKp6TryF3YRd7MudGg+iMfa2tdZ6tvb8xZ2Amf9BSjU4Rkx8717I0GEydHJay4dYwPHmyaG1rLXbGIMUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hn2XOFEQ; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hn2XOFEQ"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-365145ef32fso2283095ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 14:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708726849; x=1709331649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=totYPU1oe0M42Q0/drGFwaOh09XGh4Kl0wwEiXNLuo4=;
        b=Hn2XOFEQtjasEcF485n2JgHXnJsp+3QYWth8iteICaNqVM9oaO+FP//GmOPJCMKBa5
         fmsELZcmhGuPS/nimpPmXENLWncs/UqURuUGS9J8D4cmswNVttokQPGuKW+vkIF1zn5V
         aLGS0WI7iLnvb12RbF39U2iX9U3kkDx7SqrKJSCBMQFTyJSe55gDrbOLkvmJU8jHFGuf
         Gn8VyTGIzdiPlWEjfoETzfbE6X0BwPMdz+U5AGYXDQwDPnIPbIk6wAdAYBNkolfDjtDh
         jJJ0psmcN8dEvpeGaf9TUJlrQvlupg+8M1c21dBW6gLmPvYMX34FrfIGAq0R8C/1645e
         pk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708726849; x=1709331649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=totYPU1oe0M42Q0/drGFwaOh09XGh4Kl0wwEiXNLuo4=;
        b=ubBkYiME+QMR0U9A9Bmu5gaLuDkKgI5ICFI5MzprrEBfnZ6LO3t8qY0/0dN6fyURFo
         yQGICl+vXc19jD9f204KB1/XftpKoRLN9LieqyiNQUKsmAdoM8w+UIE6zx7szZQB2TDZ
         Qfe4/0hDJpUXnSzEyBSsMZMp1Eb4mCql/qlcehjNIq9AUUraOKmqgiIj53b2GAoHj25k
         TvQDD5RCB8RwXnubtCyyOHELpeMrxR02ynjZcmLkYfAaNTp8lp6nETosXGbngbEd0HA5
         8mM4POMByOqgj2OBIYOpx4gKbIZDjWNKs0SdlwoaCmjp7u1w2zUhP5xjC3UsfLXyl7ZD
         vlUg==
X-Forwarded-Encrypted: i=1; AJvYcCUUwBgCEPs+pmxYsr5D+jCJEN7heZ0gqQ7x5IGoQ1WHx/O4fR9BnG2vkWqcRzihKgPNVBB1IBsfoPDVCIQ6cRRDS1pFvBDlNiu8DP+KwHk=
X-Gm-Message-State: AOJu0YxQ8g5Qxs4CQWg46ftGxJcxYVbWkQ59/fJ/Ls6vcExY/xxBCsw2
	NEwnwNVVp9f+uFHRerUGrTc7UR+0UQCbKGN55xvWua4nOoLAcpQJTE8+cxJI
X-Google-Smtp-Source: AGHT+IEq1lHlKCmTxBeJnDw0QSzipMYnlRYxSNGXNIB7tsQ/w4sYCcyqTtgqfRqVQ3VBmHM0bVhX0Q==
X-Received: by 2002:a05:6e02:60e:b0:363:b805:fcb6 with SMTP id t14-20020a056e02060e00b00363b805fcb6mr1248230ils.28.1708726849399;
        Fri, 23 Feb 2024 14:20:49 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id f5-20020a92cb45000000b0036581060910sm300136ilq.6.2024.02.23.14.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 14:20:48 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] powerpc: use "long long" for 64-bit types in userspace
Date: Fri, 23 Feb 2024 15:20:42 -0700
Message-ID: <20240223222042.140688-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This resolves build warnings and failures for architectures where the
Linux userspace `asm/types.h` header defines 64-bit types (u64, s64) as
`long` instead of `long long`.

By defining `__SANE_USERSPACE_TYPES__`, these types are defined as
`long long` instead.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Makefile              | 1 +
 include/linux/types.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 6e5d0e5..7363d5d 100644
--- a/Makefile
+++ b/Makefile
@@ -42,6 +42,7 @@ CFLAGS+=-std=gnu11 -O2 -g -MMD -Wall -fPIC			\
 	-DNO_BCACHEFS_FS					\
 	-DNO_BCACHEFS_SYSFS					\
 	-DVERSION_STRING='"$(VERSION)"'				\
+	-D__SANE_USERSPACE_TYPES__				\
 	$(EXTRA_CFLAGS)
 
 # Intenionally not doing the above to $(LDFLAGS) because we rely on
diff --git a/include/linux/types.h b/include/linux/types.h
index 6ae97c4..004d5eb 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -10,7 +10,9 @@
 #include <sys/types.h>
 #include <linux/posix_types.h>
 
+#ifndef __SANE_USERSPACE_TYPES__
 #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
+#endif
 #include <asm/types.h>
 
 #include <linux/cache.h>
-- 
2.43.0

