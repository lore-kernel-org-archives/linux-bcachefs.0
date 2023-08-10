Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D09C001DB
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Aug 2023 13:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjHJNaC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Aug 2023 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjHJNaB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Aug 2023 09:30:01 -0400
X-Greylist: delayed 419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Aug 2023 06:29:58 PDT
Received: from sosiego.soundray.org (sosiego.soundray.org [116.203.207.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA7C2108
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 06:29:58 -0700 (PDT)
From:   Linus Heckemann <git@sphalerite.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sphalerite.org;
        s=sosiego; t=1691673775;
        bh=7MVjdP5rv0OP3g6sPUW3cMErFDct3h2alAllGmk0AVU=;
        h=From:To:Cc:Subject:Date;
        b=HY4hQSo+wvXLmnkD/Fi0OLn85NZDHybPbWK0kkOQYH5zzZ3qrqK9ONr2XS40Upw6X
         LU62TPHn9tEz8lVoeMD4J27F4m1FZ6HIjfIJno8XfdoXq+gKbYg+cuQHrBRagcqwl6
         K5jTEQo3QhtAUHkppo3/sH9//qxREiaYih3R1fiA=
To:     linux-bcachefs@vger.kernel.org
Cc:     Linus Heckemann <git@sphalerite.org>
Subject: [PATCH] cmd_mount: don't return 0 on mount failure
Date:   Thu, 10 Aug 2023 15:22:25 +0200
Message-Id: <20230810132225.796096-1-git@sphalerite.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Linus Heckemann <git@sphalerite.org>
---
 bcachefs.c                | 3 +--
 cmds.h                    | 2 +-
 rust-src/src/cmd_mount.rs | 6 ++++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/bcachefs.c b/bcachefs.c
index a3fe6d8..d1efcd5 100644
--- a/bcachefs.c
+++ b/bcachefs.c
@@ -250,8 +250,7 @@ int main(int argc, char *argv[])
 		return cmd_setattr(argc, argv);
 #ifndef BCACHEFS_NO_RUST
 	if (!strcmp(cmd, "mount")) {
-		cmd_mount(argc, argv);
-		return 0;
+		return cmd_mount(argc, argv);
 	}
 #endif
 
diff --git a/cmds.h b/cmds.h
index 96216b2..8b56795 100644
--- a/cmds.h
+++ b/cmds.h
@@ -60,6 +60,6 @@ int cmd_subvolume_delete(int argc, char *argv[]);
 int cmd_subvolume_snapshot(int argc, char *argv[]);
 
 int cmd_fusemount(int argc, char *argv[]);
-void cmd_mount(int agc, char *argv[]);
+int cmd_mount(int agc, char *argv[]);
 
 #endif /* _CMDS_H */
diff --git a/rust-src/src/cmd_mount.rs b/rust-src/src/cmd_mount.rs
index 0150ffd..b79985d 100644
--- a/rust-src/src/cmd_mount.rs
+++ b/rust-src/src/cmd_mount.rs
@@ -219,14 +219,14 @@ fn cmd_mount_inner(opt: Cli) -> anyhow::Result<()> {
 }
 
 #[no_mangle]
-pub extern "C" fn cmd_mount(argc: c_int, argv: *const *const c_char) {
+pub extern "C" fn cmd_mount(argc: c_int, argv: *const *const c_char) -> c_int {
     let argv: Vec<_> = (0..argc)
         .map(|i| unsafe { CStr::from_ptr(*argv.add(i as usize)) })
         .map(|i| OsStr::from_bytes(i.to_bytes()))
         .collect();
 
     let opt = Cli::parse_from(argv);
-    
+
     log::set_boxed_logger(Box::new(SimpleLogger)).unwrap();
 
     // @TODO : more granular log levels via mount option
@@ -239,7 +239,9 @@ pub extern "C" fn cmd_mount(argc: c_int, argv: *const *const c_char) {
     colored::control::set_override(opt.colorize);
     if let Err(e) = cmd_mount_inner(opt) {
         error!("Fatal error: {}", e);
+        1
     } else {
         info!("Successfully mounted");
+        0
     }
 }
-- 
2.40.1

