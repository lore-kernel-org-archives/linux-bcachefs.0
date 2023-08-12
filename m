Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2641C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbjHLD5O (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 11 Aug 2023 23:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHLD5N (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 11 Aug 2023 23:57:13 -0400
X-Greylist: delayed 375 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Aug 2023 20:57:13 PDT
Received: from orion.157878.xyz (orion.157878.xyz [115.70.13.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C465AD
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Aug 2023 20:57:13 -0700 (PDT)
From:   Colin Gillespie <colin@cgillespie.xyz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cgillespie.xyz;
        s=2023; t=1691812255;
        bh=7yDuu0wThiMiSFUj6QlgxwfBbAD1VejS9JG7nv/sytQ=;
        h=From:To:Cc:Subject:Date:From;
        b=RNS2XL5Df5hlvSMbmVFa8TcT8AlxprIIs2gDC22kPoXxs/uR0A1GOaR3gubIVavjG
         mVap3fx7vkn2gCM9kl6KSnoBRHBOlN9feCJZpZkWGF/SMApYV89BivXkHXafAuE6mk
         xlTjnJ/zlvtCKycBPEP0tbOhwq1ZUwUgo3WS9aCRa6C0fez6gvOFB5vmvDtCL309Oi
         WNmeNo5AcNAarS8/8CSGJEc850hgCrjpkCftCTolf70W7gwqMvAag/2c7UqkUVdNZ+
         fHRJGfeol/qlIY92VqRD5Ue4xE1nV4vvjXjaAD5eJ29eMeQpLAnejwpz5cYdhpi0ha
         SG5D79S+TLyng==
To:     linux-bcachefs@vger.kernel.org
Cc:     Colin Gillespie <colin@cgillespie.xyz>
Subject: [PATCH] cmd_mount: use the correct keyring key type
Date:   Sat, 12 Aug 2023 13:50:37 +1000
Message-ID: <20230812035037.20681-1-colin@cgillespie.xyz>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Mount is checking for and adding encryption keys using the logon key
type instead of the user key type. This was causing it to not be able to
unlock volumes on its own, and ask for a passphrase on already unlocked
volumes.

Signed-off-by: Colin Gillespie <colin@cgillespie.xyz>
---
 rust-src/src/key.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust-src/src/key.rs b/rust-src/src/key.rs
index 2b4fc45..07292e8 100644
--- a/rust-src/src/key.rs
+++ b/rust-src/src/key.rs
@@ -35,7 +35,7 @@ impl std::str::FromStr for KeyLoc {
 fn check_for_key(key_name: &std::ffi::CStr) -> anyhow::Result<bool> {
     use bch_bindgen::keyutils::{self, keyctl_search};
     let key_name = key_name.to_bytes_with_nul().as_ptr() as *const _;
-    let key_type = c_str!("logon");
+    let key_type = c_str!("user");
 
     let key_id = unsafe { keyctl_search(keyutils::KEY_SPEC_USER_KEYRING, key_type, key_name, 0) };
     if key_id > 0 {
@@ -101,7 +101,7 @@ fn ask_for_key(sb: &bch_sb_handle) -> anyhow::Result<()> {
     } else if key.magic != bch_key_magic {
         Err(anyhow!("failed to verify the password"))
     } else {
-        let key_type = c_str!("logon");
+        let key_type = c_str!("user");
         let ret = unsafe {
             bch_bindgen::keyutils::add_key(
                 key_type,
-- 
2.41.0

