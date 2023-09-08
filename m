Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2438BEE57E1
	for <linux-bcachefs@archiver.kernel.org>; Fri,  8 Sep 2023 07:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjIHH3H (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 8 Sep 2023 03:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjIHH3G (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 8 Sep 2023 03:29:06 -0400
Received: from orion.157878.xyz (orion.157878.xyz [115.70.13.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB871BD3
        for <linux-bcachefs@vger.kernel.org>; Fri,  8 Sep 2023 00:29:03 -0700 (PDT)
From:   Colin Gillespie <colin@cgillespie.xyz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cgillespie.xyz;
        s=2023; t=1694158141;
        bh=quePa1zvS3vrgUciGABTeSSTyG7uhAqkpBhq0j+HTDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9DQSB2pqQHnKjL2NGEZSv6ZLcMaKJH+5QF0n0wyqr7fdzM/TKg2gcpcqk5bOlC6k
         OTwFBnloFDZU/4CD1CuKOXtg6yontp/09cQjNsupl/gKMKfFbLZdEmLohUmcKdFnS0
         Khv+hz/uRV0JM7TiwpJmKsq+9Y9qKaVp4hNw6sgI1mE62e7o+IsoqOr01MIlq492QK
         9lqRQr8Zk8ESK8utBB3lPFBuGVHZJVUJOvte2nE+mL8UnsuqB9dKu9wGZQV6NHQjlk
         ZFkvLN6n8djZSOQb7FEGw9gLbST2uf76ZHEmmNuWoMF/JTMau4GYBTzz5MM0+k2B3f
         fM6GuQDtuHPjw==
To:     linux-bcachefs@vger.kernel.org
Cc:     Colin Gillespie <colin@cgillespie.xyz>
Subject: [PATCH 2/2] cmd_mount: request passphrase if the existing key is revoked
Date:   Fri,  8 Sep 2023 17:27:52 +1000
Message-ID: <20230908072751.25406-4-colin@cgillespie.xyz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230908072751.25406-2-colin@cgillespie.xyz>
References: <20230908072751.25406-2-colin@cgillespie.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Colin Gillespie <colin@cgillespie.xyz>
---
 rust-src/src/key.rs | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/rust-src/src/key.rs b/rust-src/src/key.rs
index 07292e8..9319351 100644
--- a/rust-src/src/key.rs
+++ b/rust-src/src/key.rs
@@ -41,10 +41,11 @@ fn check_for_key(key_name: &std::ffi::CStr) -> anyhow::Result<bool> {
     if key_id > 0 {
         info!("Key has became available");
         Ok(true)
-    } else if errno::errno().0 != libc::ENOKEY {
-        Err(crate::ErrnoError(errno::errno()).into())
     } else {
-        Ok(false)
+        match errno::errno().0 {
+            libc::ENOKEY | libc::EKEYREVOKED => Ok(false),
+            _ => Err(crate::ErrnoError(errno::errno()).into()),
+        }
     }
 }
 
-- 
2.42.0

