Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46333C46CA1
	for <linux-bcachefs@archiver.kernel.org>; Sat, 16 Sep 2023 08:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbjIPIpo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 16 Sep 2023 04:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbjIPIpe (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 16 Sep 2023 04:45:34 -0400
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63113E71
        for <linux-bcachefs@vger.kernel.org>; Sat, 16 Sep 2023 01:45:29 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id hQvcqqzCHBh1whQvdqxVHj; Sat, 16 Sep 2023 10:45:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1694853926;
        bh=cA7WgRDiydPCuNf/SfhbEh7C8ImUKHG5ugsQxiw8lwY=;
        h=From:To:Cc:Subject:Date;
        b=PXR0QG3lTF7N9XgySHtDSVHe2gdPAui/WnZoRa2jD4u6bFFju0FxGWZXXpgOZ1Zub
         KaQs4MkZCze4W+AMVDuwKYr8+oaTF6byXp83/WAYzoRA7GEmubQr/z9h8XQRMwjXWM
         fjsxpRFwwwIwS2+9X0J2TCLn7jaeTuWD6s/P92SYMiBYo3C5UIu6gZctUDQpTC5GC7
         U+E0x0M+VWXIphkCqGJq0xN92+f7T61PVW7QbcGpbAVX2jlrOajoTJ85Slb9rkos/6
         uhyGVLXfiA8veXc5cyAJI0m/+LI7VNsa4fkaaGCwPNFc2YT45zm+pcgSPs/R6DTD15
         4VJ86sWwTPdUQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 16 Sep 2023 10:45:26 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Avoid a potential memory over-allocation in bch2_printbuf_make_room()
Date:   Sat, 16 Sep 2023 10:45:23 +0200
Message-Id: <2e6a82a83d0ddd9ce7f36ea889dd7ffc30f5fbc9.1694853900.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

kmalloc() and co. don't always allocate a power of 2 number of bytes.
There are some special handling for 64<n<=96 and 128<n<=192 cases.

So trust kmalloc() algorithm instead of forcing a power of 2 allocation.
This can saves a few bytes of memory and still make use of all the
memory allocated.

On the other side, it may require an additional realloc() in some cases.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/bcachefs/printbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/printbuf.c b/fs/bcachefs/printbuf.c
index 77bee9060bfe..34527407e950 100644
--- a/fs/bcachefs/printbuf.c
+++ b/fs/bcachefs/printbuf.c
@@ -28,7 +28,7 @@ int bch2_printbuf_make_room(struct printbuf *out, unsigned extra)
 	if (out->pos + extra < out->size)
 		return 0;
 
-	new_size = roundup_pow_of_two(out->size + extra);
+	new_size = kmalloc_size_roundup(out->size + extra);
 
 	/*
 	 * Note: output buffer must be freeable with kfree(), it's not required
-- 
2.34.1

