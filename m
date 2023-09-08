Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B353BEE57E0
	for <linux-bcachefs@archiver.kernel.org>; Fri,  8 Sep 2023 07:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjIHH3G (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 8 Sep 2023 03:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjIHH3G (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 8 Sep 2023 03:29:06 -0400
Received: from orion.157878.xyz (orion.157878.xyz [115.70.13.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545211BC8
        for <linux-bcachefs@vger.kernel.org>; Fri,  8 Sep 2023 00:29:02 -0700 (PDT)
From:   Colin Gillespie <colin@cgillespie.xyz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cgillespie.xyz;
        s=2023; t=1694158140;
        bh=MtfcOdqUC8KDP7S4OdTfGDoPhpLleWlnA01FmzRclsY=;
        h=From:To:Cc:Subject:Date:From;
        b=pEydBXrR56WqyY2aS3p/9mQrKGBI6fCiZ6xC+dq0kptxPO/OPoN1gasNwgCd8+Ftg
         wNSyEV2rk7RDRLDkh78YJ8TPrl0kAC6GPzXXV5krya3pjQu+W9Q2fk0BzHEh3KDIBE
         zxUAd8MQghDM1rKTz3qMSBTLFaHKCw5dNw6wUwFgyOndcpVTZmA3XO/qidkFEbyGhV
         aqK9+QsBOdZui9zy9e+mcMhIg7y/oq2T+jcJulEIIhjwZxHR5lQ64H/4qP4Guh+F8N
         b4HVbqLfG3LJ6FGZLIQiCsC7tLNkeaP4z4NLb7pvQqY9/qEMs4XJKATcV1iOIymTZ9
         uODbShQcDwoEA==
To:     linux-bcachefs@vger.kernel.org
Cc:     Colin Gillespie <colin@cgillespie.xyz>
Subject: [PATCH 0/2] revoke invalidated encryption keys
Date:   Fri,  8 Sep 2023 17:27:50 +1000
Message-ID: <20230908072751.25406-2-colin@cgillespie.xyz>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

I found that mounting a filesystem after changing its passphrase with
bcachefs set-passphrase would hang indefinitely. It appears the old key
is being used, but the mount process can't tell that it's invalid.

Instead of relying on the user to call bcachefs unlock, this patch
revokes the invalid key, causing further operations to fail.

Colin Gillespie (2):
  cmd_set_passphrase: revoke the invalidated key
  cmd_mount: request passphrase if the existing key is revoked

 cmd_key.c              |  1 +
 libbcachefs/checksum.c | 18 ++++++++++++++++++
 libbcachefs/checksum.h |  1 +
 rust-src/src/key.rs    |  7 ++++---
 4 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.42.0

