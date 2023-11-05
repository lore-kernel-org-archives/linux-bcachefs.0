Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A11C4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 20:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjKEU5C (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 15:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjKEU5C (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 15:57:02 -0500
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Nov 2023 12:56:59 PST
Received: from gimli.kloenk.de (gimli.kloenk.de [IPv6:2a01:4f8:c012:b874::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955BEE
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 12:56:59 -0800 (PST)
From:   Finn Behrens <me@kloenk.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.de; s=mail;
        t=1699217358; bh=JuCE05FfTeFjcYr/SXPmBS1WAdyuDkLDiumSbRV8NFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DYUJ19k6YUIIpWtw8yM1l08Tzf1MKqpezChWrK3mQ4Qfoj7LiIp4Ad98pO+MpHhKX
         FNLlvcXJpUYdaOqUB0M0ZczRbUHlui0cKd2NyLOwFvM5Ut6Q/c+f776/R2LsNU4WFf
         lJzf8LVMof7hMrOWcvVaf/AUHV7roiQoBpI9Y568=
To:     linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev
Cc:     dev@leona.is, Finn Behrens <me@kloenk.de>
Subject: [PATCH 2/2] nix: add devShell
Date:   Sun,  5 Nov 2023 21:48:54 +0100
Message-ID: <20231105204854.244570-2-me@kloenk.de>
In-Reply-To: <20231105204854.244570-1-me@kloenk.de>
References: <20231105204854.244570-1-me@kloenk.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Finn Behrens <me@kloenk.de>
---
 flake.nix | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/flake.nix b/flake.nix
index bdaa4bf..e6ad966 100644
--- a/flake.nix
+++ b/flake.nix
@@ -27,5 +27,25 @@
         };
 
         formatter = pkgs.nixfmt;
+
+        devShells.default = pkgs.callPackage ({ mkShell, rustc, cargo, gnumake
+          , gcc, clang, pkg-config, libuuid, libsodium, keyutils, liburcu, zlib
+          , libaio, zstd, lz4, udev, }:
+          mkShell {
+            LIBCLANG_PATH = "${clang.cc.lib}/lib";
+            nativeBuildInputs = [ rustc cargo gnumake gcc pkg-config ];
+            buildInputs = [
+              clang.cc.lib
+              libuuid
+              libsodium
+              keyutils
+              liburcu
+              zlib
+              libaio
+              zstd
+              lz4
+              udev
+            ];
+          }) { };
       });
 }
-- 
2.42.0

