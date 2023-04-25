Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD543C77B61
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 16:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDYQyf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 12:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbjDYQye (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 12:54:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FFFD307
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:54:33 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a682eee3baso46679935ad.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 09:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1682441672; x=1685033672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDw/GXoYnWeWmmyHmW5386Z/U8iMyILF5LHRgGnEKNU=;
        b=fwgb2JtgI3ixnTa/jsap/fKwZr6yx3eiw5A152fvuPa0sQY6GKnwFjMCk+z6BuHSQ5
         H5UVygJM9YjjExUZP7Pn8zTn7a6ZGSx2qspwXdQTV3lDmgqY2hfyVoksDp0wXdqAC8iq
         fWZV7NNaPmzr3/hWWa1cwYJWsj+KQ65SRVfQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682441672; x=1685033672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kDw/GXoYnWeWmmyHmW5386Z/U8iMyILF5LHRgGnEKNU=;
        b=QnX3nrugcpodjP66xpgEcqtEGLt8be/NKtMc9Urxp5JgNlaqGzft5HvQNv9IvosAV/
         3MXCCAKPNP6G6pwfsZ8ki0szcveCdCvGCis/h60rQinu+QqpRc7GcyYXykArhUfUAZ2z
         j9BtOGWeu9wAwwJjSb/pW6x5SPyiMffE+Ovps+hutoqab/+JI1MTEEoC571n96LfVql7
         zZyR1kXuZgUsHSWNHcC0jVZf0gugpcl6/lDNY2/xMkdwdHpLzrGdVu6g7irGBIdmMb9j
         5aeLVGs9UazJ57ISKgr0vEULhmTrBAJh+gL7Iln5eyQhi4m420dDnreB/DwQ5xvYKbxK
         2KvQ==
X-Gm-Message-State: AC+VfDzhK7x2ZRPl6XLNdncRZqItq5ywNJ2joEpIo3U9d+k86SxR1Czt
        rHiwd1ZCLlvWkSPZ1Is970wvJelTqy2rT78d65LB0Q==
X-Google-Smtp-Source: ACHHUZ7xkZMvqQ+4lSqyc5h1kOCQb2uLzXzfR3hJxJKhSCEQHjteQ8n8ASx6JjRKfJS+BLMR/EE9pQ==
X-Received: by 2002:a17:903:1109:b0:1a9:7b5e:14ba with SMTP id n9-20020a170903110900b001a97b5e14bamr7647038plh.29.1682441672078;
        Tue, 25 Apr 2023 09:54:32 -0700 (PDT)
Received: from TranNguyensMBP9.lan ([2601:602:9800:7b:35b9:af9:fa1f:ad29])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902d34900b001a1c721f7f8sm8495497plk.267.2023.04.25.09.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:54:31 -0700 (PDT)
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
To:     linux-bcachefs@vger.kernel.org
Cc:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Subject: [PATCH 2/2] feature: allow cmd mount to accept only 1 block device, then mount by UUID
Date:   Tue, 25 Apr 2023 09:54:06 -0700
Message-Id: <20230425165406.34056-2-i@truongsinh.pro>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20230425165406.34056-1-i@truongsinh.pro>
References: <20230425165406.34056-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This allows bcachefs to be mounted by /etc/fstab
---
 rust-src/src/cmd_mount.rs | 45 ++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index af370ef..da95f80 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -161,26 +161,47 @@ struct Cli {
     verbose:        u8,
 }
 
+fn get_devices_and_sbs_by_uuid(uuid: Uuid) -> anyhow::Result<(String, Vec<bch_sb_handle>)> {
+
+    let devs_sbs = get_devices_by_uuid(uuid)?;
+
+    let devs_strs: Vec<_> = devs_sbs.iter().map(|(dev, _)| dev.clone().into_os_string().into_string().unwrap()).collect();
+    let devs_str = devs_strs.join(":");
+    let sbs: Vec<bch_sb_handle> = devs_sbs.iter().map(|(_, sb)| *sb).collect();
+
+    Ok((devs_str, sbs))
+}
+
 fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
     let (devs, sbs) = if opt.dev.starts_with("UUID=") {
         let uuid = opt.dev.replacen("UUID=", "", 1);
         let uuid = Uuid::parse_str(&uuid)?;
-        let devs_sbs = get_devices_by_uuid(uuid)?;
+        get_devices_and_sbs_by_uuid(uuid)?
+    } else {
+        let sbs: Vec<bch_sb_handle> = opt.dev.split(':').map(|dev| {
+            let dev = PathBuf::from(dev);
+            bch_bindgen::rs::read_super(&dev)
+        }).collect::<Result<Vec<_>, _>>()?;
 
-        let devs_strs: Vec<_> = devs_sbs.iter().map(|(dev, _)| dev.clone().into_os_string().into_string().unwrap()).collect();
-        let devs_str = devs_strs.join(":");
-        let sbs = devs_sbs.iter().map(|(_, sb)| *sb).collect();
+        let uuid = sbs[0].sb().uuid();
+        let sbs_len: u8 = sbs.len().try_into().unwrap();
+        let nr_devices = sbs[0].sb().nr_devices;
 
-        (devs_str, sbs)
-    } else {
-        let mut sbs = Vec::new();
+        info!("{} is the external UUID", uuid);
 
-        for dev in opt.dev.split(':') {
-            let dev = PathBuf::from(dev);
-            sbs.push(bch_bindgen::rs::read_super(&dev)?);
+        if sbs_len == nr_devices {
+            info!("{} device(s) specified from mount command, matching required as specified from first device headers", sbs_len);
+            // @TODO looping through and check all devices actually have the same external UUID
+            (opt.dev, sbs)
+        } else {
+            warn!("{} device(s) specified from mount command", sbs_len);
+            warn!("{} device(s) required as specified from first device headers", nr_devices);
+            warn!("trying to scan all devices with external UUID instead");
+            let (devs_str, sbs) = get_devices_and_sbs_by_uuid(uuid)?;
+            info!("{} device(s) found from scanning all devices matching UUID", sbs.len());
+            // @TODO what if get_devices_and_sbs_by_uuid still cannot get all required?
+            (devs_str, sbs)
         }
-
-        (opt.dev, sbs)
     };
 
     if unsafe { bcachefs::bch2_sb_is_encrypted(sbs[0].sb) } {
-- 
2.33.1

