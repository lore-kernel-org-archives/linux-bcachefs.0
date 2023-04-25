Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB49C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 22:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjDYWpj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 18:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjDYWpi (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 18:45:38 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0E8CC25
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 15:45:36 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b87d23729so5125233b3a.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 15:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682462736; x=1685054736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aVG5yB145dsz6mbHUSFyT0bUEi6Y/ALqtArvcRJG97k=;
        b=eYs4regtUiEOCQxefE6nD60Fa4MgGOoakfPgRaQYMlUqW32TGXsjRDzN1StlLtgtYm
         iPYA63Po0xiKMLJQBtlTY9qZEa59UUcrX9CHrFpBLybovSvgFqpRK0wz7mdq870RaHsD
         4iN6GPvykmKXDfJgYPaRZv94n75N+cgIaUoeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682462736; x=1685054736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aVG5yB145dsz6mbHUSFyT0bUEi6Y/ALqtArvcRJG97k=;
        b=EVYuw2sCJNunbphvbeJqaLDT4+uCEkRUBGqI/S6oULn8DsKJLNnCMei5vnnUIuFBdb
         wfLBEIQTpzS3KL1v4l7oNB7FVcH+NTiLDsIkegzK7NqxwQwRtWkJbBy+aGZ27Gf/6PKj
         VfxnmzHogWtJTlCDHtsfyLXQAcpQaVoQZ+ThoL9GeNjC2ZBiOCjF65BTgj0UgnK02nkR
         AXGXP7KDxcfIe5B70jenUJG9YbKPIPctju9OS3VApybiOh4bh8mh5tNr404aWIWxihxE
         hdKdLJaOKRZlgnUJo4ane7vzSit1fhQwudTNYv/vYCmTXnKsPWZQ2LFabUSxuMQn4pwC
         WqHA==
X-Gm-Message-State: AAQBX9cuSNsbGKSKeXCi+aTl2WmOeCqd5PDFblh1OcXjHVGVGLyS4N31
        uH2UdtbeXcXu/6G0QVuUUxEa1tkGyz78+owksU4f/A==
X-Google-Smtp-Source: AKy350aqN/psX+jXqqzTFOUoVopz0iMDzrBMCpRAzwJ93w+cHmm2Bo2xylfUQynD5gNZw4fR+Hg4Uw==
X-Received: by 2002:a05:6a00:1681:b0:63f:3aac:78a6 with SMTP id k1-20020a056a00168100b0063f3aac78a6mr16044267pfc.9.1682462735748;
        Tue, 25 Apr 2023 15:45:35 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:6450:e55b:77e8:267b])
        by smtp.gmail.com with ESMTPSA id u25-20020a62d459000000b0063b70f0b657sm9671014pfl.24.2023.04.25.15.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 15:45:35 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] feat(cmd_mount): Add support for magic keyword `OLD_BLKID_UUID`
Date:   Tue, 25 Apr 2023 15:45:27 -0700
Message-Id: <20230425224527.21103-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This commit enhances mount by allowing it to accept `OLD_BLKID_UUID=xxx` as the device, enabling whole fs mounting without relying on colon-separated devices. Using colon-separated devices in fstab is discouraged due to potential device reference issues after reboot. Additionally, using `UUID=xxx` in fstab is currently infeasible as it depends on blkid, which prior to v2.39, does not recognize bcachefs. This update enables mounting via fstab using `OLD_BLKID_UUID=xxx` as obtained from `bcachefs show-super` "External UUID".
---
 rust-src/src/cmd_mount.rs | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index af370ef..14e6176 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -1,9 +1,8 @@
 use atty::Stream;
 use bch_bindgen::{bcachefs, bcachefs::bch_sb_handle};
-use log::{info, warn, debug, error, trace, LevelFilter};
+use log::{info, debug, error, LevelFilter};
 use clap::Parser;
 use uuid::Uuid;
-use std::convert::TryInto;
 use std::path::PathBuf;
 use crate::key;
 use crate::key::KeyLoc;
@@ -162,14 +161,17 @@ struct Cli {
 }
 
 fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
-    let (devs, sbs) = if opt.dev.starts_with("UUID=") {
-        let uuid = opt.dev.replacen("UUID=", "", 1);
-        let uuid = Uuid::parse_str(&uuid)?;
-        let devs_sbs = get_devices_by_uuid(uuid)?;
-
-        let devs_strs: Vec<_> = devs_sbs.iter().map(|(dev, _)| dev.clone().into_os_string().into_string().unwrap()).collect();
-        let devs_str = devs_strs.join(":");
-        let sbs = devs_sbs.iter().map(|(_, sb)| *sb).collect();
+    let (devs, sbs) = if opt.dev.starts_with("OLD_BLKID_UUID=") {
+        let uuid = opt.dev.replacen("OLD_BLKID_UUID=", "", 1);
+        debug!("enumerating devices with UUID {}", uuid);
+        let devs_sbs = Uuid::parse_str(&uuid).map(|uuid| get_devices_by_uuid(uuid))??;
+
+        let devs_str = devs_sbs
+            .iter()
+            .map(|(dev, _)| dev.to_str().unwrap())
+            .collect::<Vec<_>>()
+            .join(":");
+        let sbs: Vec<bch_sb_handle> = devs_sbs.iter().map(|(_, sb)| *sb).collect();
 
         (devs_str, sbs)
     } else {
@@ -183,7 +185,9 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
         (opt.dev, sbs)
     };
 
-    if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
+    if sbs.len() == 0 {
+        Err(anyhow::anyhow!("No device found from specified parameters"))?;
+    } else if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
         let key = opt
             .key_location
             .0
@@ -192,6 +196,13 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
         key::prepare_key(&sbs[0], key)?;
     }
 
+    info!(
+        "mounting with params: device: {}, target: {}, options: {}",
+        devs,
+        &opt.mountpoint.to_string_lossy(),
+        &opt.options
+    );
+
     mount(devs, &opt.mountpoint, &opt.options)?;
     Ok(())
 }
-- 
2.33.1

