Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E442AC7618E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjDZRPY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 13:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDZRPW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 13:15:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DA03A8C
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 10:15:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so6914739a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 10:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682529320; x=1685121320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UeUEt6Kqev0tsVFysYj46UX09PgPhifjwnaZBtU2eM8=;
        b=I9GUI/FxhgvyPtKtYX819JJ5VzQWCUT7B4C/JhLRRoBJJ+Sh/XHSqfr56ZDxBWC1+M
         FJWnDpzf4dJsRkNrzWehov/+aY0/hVZ+U3ovoktJZYxWLwy9iojDPQ/JX5DRzbt+XAEe
         Fm3wsBZF0N8nBppiDeG+MEiFZLKxGyt1eIWVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529320; x=1685121320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UeUEt6Kqev0tsVFysYj46UX09PgPhifjwnaZBtU2eM8=;
        b=cD4f+9ceTW8AS9sMu5Bz1bDEM3XKVFN7D2Qw52q9wWnySYNMmubw7QIp0reUQnh7tG
         2mNjvYul8vZcFqTi0oAPtXBK7pODwcULVFrbjibnQm1NJIUIBng3hDroOJ3MO6GPwmhM
         KRDujNXLvelXRL/2S6NI5Spf2L0DYPC6nZ2Z+uPwqW+uiN4XSpUbIqapmHPfvhr6Tar8
         HdxyjtIgj2WNpFUwsYVwpwoum0Pe0KHqnUcfQQHiP9M11eCdLgorXdnLyEir9ypIhqSj
         YA3nyDsanxknbjer6XB0OfaHT5aB9h3TTKc+I8IoPWqsLLD54i0CfgpBPTuVACveXrup
         Fqzg==
X-Gm-Message-State: AAQBX9dDnRIij8HOVS8IMFd45dt8gJpSZitcpBKCcMrH5rswCu3rwfDE
        GDTsmmT7QH85TsjnU14TdsoB+eykQa+qTDYQZ0zTvQ==
X-Google-Smtp-Source: AKy350YOnqNmeRW27TQl5paAeuPfqdg0CCBJYOsPGWX/t433IIvqsIwaOxgWhWKtEThAY40ij6i4MA==
X-Received: by 2002:a17:90a:8043:b0:246:97d2:dc27 with SMTP id e3-20020a17090a804300b0024697d2dc27mr21460217pjw.42.1682529320156;
        Wed, 26 Apr 2023 10:15:20 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:6450:e55b:77e8:267b])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709028c8100b001a80d7c6954sm10159994plo.288.2023.04.26.10.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 10:15:19 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH] feat(cmd_mount): Add support for magic keyword `OLD_BLKID_UUID`
Date:   Wed, 26 Apr 2023 10:15:12 -0700
Message-Id: <20230426171512.89139-1-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This commit enhances mount sub command by allowing it to accept
`OLD_BLKID_UUID=xxx` as the device, enabling whole fs mounting without relying
on colon-separated devices.

Using colon-separated devices in fstab is discouraged due to potential device
reference issues after reboot. Additionally, using `UUID=xxx` in fstab or with
`mount -t bcachefs` is currently infeasible as it depends on blkid, which prior
to v2.39, does not recognize bcachefs. This update enables mounting via fstab
using `OLD_BLKID_UUID=xxx` as obtained from `bcachefs show-super` "External
UUID".

Signed-off-by: TruongSinh Tran-Nguyen <i@truongsinh.pro>
---
 rust-src/src/cmd_mount.rs | 44 +++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index af370ef..0150ffd 100644
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
@@ -161,17 +160,31 @@ struct Cli {
     verbose:        u8,
 }
 
+fn devs_str_sbs_from_uuid(uuid: String) -> anyhow::Result<(String, Vec<bch_sb_handle>)> {
+    debug!("enumerating devices with UUID {}", uuid);
+
+    let devs_sbs = Uuid::parse_str(&uuid)
+        .map(|uuid| get_devices_by_uuid(uuid))??;
+
+    let devs_str = devs_sbs
+        .iter()
+        .map(|(dev, _)| dev.to_str().unwrap())
+        .collect::<Vec<_>>()
+        .join(":");
+
+    let sbs: Vec<bch_sb_handle> = devs_sbs.iter().map(|(_, sb)| *sb).collect();
+
+    Ok((devs_str, sbs))
+
+}
+
 fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     let (devs, sbs) = if opt.dev.starts_with("UUID=") {
         let uuid = opt.dev.replacen("UUID=", "", 1);
-        let uuid = Uuid::parse_str(&uuid)?;
-        let devs_sbs = get_devices_by_uuid(uuid)?;
-
-        let devs_strs: Vec<_> = devs_sbs.iter().map(|(dev, _)| dev.clone().into_os_string().into_string().unwrap()).collect();
-        let devs_str = devs_strs.join(":");
-        let sbs = devs_sbs.iter().map(|(_, sb)| *sb).collect();
-
-        (devs_str, sbs)
+        devs_str_sbs_from_uuid(uuid)?
+    } else if opt.dev.starts_with("OLD_BLKID_UUID=") {
+        let uuid = opt.dev.replacen("OLD_BLKID_UUID=", "", 1);
+        devs_str_sbs_from_uuid(uuid)?
     } else {
         let mut sbs = Vec::new();
 
@@ -183,7 +196,9 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
         (opt.dev, sbs)
     };
 
-    if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
+    if sbs.len() == 0 {
+        Err(anyhow::anyhow!("No device found from specified parameters"))?;
+    } else if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
         let key = opt
             .key_location
             .0
@@ -192,6 +207,13 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
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

