Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E03C77B7F
	for <linux-bcachefs@archiver.kernel.org>; Wed,  3 May 2023 06:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjECGyI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 3 May 2023 02:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjECGyH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 3 May 2023 02:54:07 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89240422F
        for <linux-bcachefs@vger.kernel.org>; Tue,  2 May 2023 23:54:04 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aad55244b7so34623945ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 May 2023 23:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683096843; x=1685688843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/iojv9dkLYgAWs67X+QqYODrCc6G9q/NkDINGU2mg7o=;
        b=KI53BsC8OfXPxfCSmLdREqoROZRJ50drYxpeJ7yU2jRBkrCf7BDxW30Msf1sJr4gpw
         9LwSOnNemm4MHea3GrVKKg0SsPfk9hjncFB9u0WvBYOjrJLUwCWnoElEZnIk7JxIr4fq
         uCrv1VVzvjHk3ew2sBLHnF4LucXnSY9rMkR8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683096843; x=1685688843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/iojv9dkLYgAWs67X+QqYODrCc6G9q/NkDINGU2mg7o=;
        b=BVDkqpJ6LgPIGDlk3RFoDGfeuwlftE/ZhTHXxtTyP6flgmQsgDwA1hsflz56c5hFzs
         jfEx4BIu4CFgQf+Sq7//qzRDooOcvBDRrgFMN5c9TmoQH3pphcPww+Fh9/CdLDIqVWNt
         i63iTsBupqM/CURjrj07zLGnRjYw0aBN2DJfMFdyhfq8058wxcWjutQOsMZ5G13CGnG4
         63F4jhsAF9WU58IfLECeGeiJv6sMxe35agQn3SR5gyFcg5uU3GZNk0yoAcbL+RUQAtkP
         tGFWGwSwgrE4ngvQLkWkPDw9cEhtSv+sostxP+07UZGZ1ctoQwiNExKzRGaRwSVq0DVu
         EYTg==
X-Gm-Message-State: AC+VfDwablgZwPMCIqZVBuW9rmpOezhCHnWc3h/2JaPtpef5qrXoPGr3
        Z9pc4cN8ED1XN6n2UhFjPSaKh+C8+oCUhlB6yrexFA==
X-Google-Smtp-Source: ACHHUZ6WASfxAZRp4Zk2AIwCjtbkxwF2xbvMlVFY5zYk6WX+4xKSC1aD608ZGRlZ2EjQ562hwG67fw==
X-Received: by 2002:a17:902:8f8f:b0:1ab:7c4:eb24 with SMTP id z15-20020a1709028f8f00b001ab07c4eb24mr1275635plo.22.1683096843446;
        Tue, 02 May 2023 23:54:03 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:973:fcb8:93e1:6f99])
        by smtp.gmail.com with ESMTPSA id jn7-20020a170903050700b001ab0159ba3esm3885549plb.13.2023.05.02.23.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 23:54:02 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] chore(util): minimal Rust build example
Date:   Tue,  2 May 2023 23:53:54 -0700
Message-Id: <20230503065354.19071-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This is a minimal demonstration of how to use Rust in kernel side
of bcachefs. Kernel side rust does not have Rust `std`, thus
formating is a bit more challenging than doing from user space

This minimal demo implement `uuid_le_cmp`, but eventually,
in Rust, we probably do not even need to use it, just simply
`u1.b != u2.b` is good enough. Furthermore, we might consider
(even in C code) to use uuid_t instead of uuid_le

Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
---
 fs/bcachefs/Makefile              |  3 +++
 fs/bcachefs/util.h                |  8 ++++++++
 fs/bcachefs/util_rust.rs          | 17 +++++++++++++++++
 scripts/generate_rust_analyzer.py |  2 +-
 4 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 fs/bcachefs/util_rust.rs

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index a71956048a027..972976aac6921 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -72,3 +72,6 @@ bcachefs-y		:=	\
 	xattr.o
 
 bcachefs-$(CONFIG_BCACHEFS_POSIX_ACL) += acl.o
+
+bcachefs-$(CONFIG_RUST) +=	\
+	util_rust.o	\
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 9eb86c58e5509..6e87baee760a9 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -839,9 +839,17 @@ static inline int u8_cmp(u8 l, u8 r)
 
 #include <linux/uuid.h>
 
+#ifdef CONFIG_RUST
+int deprecated_uuid_le_cmp(const uuid_le *b1, const uuid_le *b2);
+#endif
+
 static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
 {
+	#ifdef CONFIG_RUST
+	return deprecated_uuid_le_cmp(&u1, &u2);
+	#else
 	return memcmp(&u1, &u2, sizeof(uuid_le));
+	#endif
 }
 
 #endif /* _BCACHEFS_UTIL_H */
diff --git a/fs/bcachefs/util_rust.rs b/fs/bcachefs/util_rust.rs
new file mode 100644
index 0000000000000..23338c29384c0
--- /dev/null
+++ b/fs/bcachefs/util_rust.rs
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: MIT */
+
+#[repr(C)]
+pub struct UuidLe {
+  b: [u8; 16],
+}
+
+// this function is prefixed `deprecated` because it uses
+// uuid_le from /usr/include/linux/uuid.h, which itself is
+// deprecated in favor of uuid_t from include/linux/uuid.h
+// it also does not exactly matches memcmp
+#[no_mangle]
+pub extern "C" fn deprecated_uuid_le_cmp( u1 : &UuidLe, u2 : &UuidLe) -> bool
+{
+  // pr_info!("using deprecated_uuid_le_cmp");
+  return u1.b != u2.b;
+}
diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index 946e250c1b2a6..d258d10bb6e31 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -98,7 +98,7 @@ def generate_crates(srctree, objtree, sysroot_src):
     # Then, the rest outside of `rust/`.
     #
     # We explicitly mention the top-level folders we want to cover.
-    for folder in ("samples", "drivers"):
+    for folder in ("samples", "drivers", 'fs'):
         for path in (srctree / folder).rglob("*.rs"):
             logging.info("Checking %s", path)
             name = path.name.replace(".rs", "")
-- 
2.30.2

