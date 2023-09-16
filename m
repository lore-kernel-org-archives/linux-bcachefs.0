Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2DFCD37B2
	for <linux-bcachefs@archiver.kernel.org>; Sat, 16 Sep 2023 06:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbjIPGVI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 16 Sep 2023 02:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238294AbjIPGUh (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 16 Sep 2023 02:20:37 -0400
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515521985
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 23:20:31 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id hOfKq4neiXyjrhOfKqtMkJ; Sat, 16 Sep 2023 08:20:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1694845229;
        bh=NpZEkdpmUURyXQQ8IOswWsw2MID9l3LvCoklUVqRxWQ=;
        h=From:To:Cc:Subject:Date;
        b=DOWhnNS+NJtCPbiE9W4YqtuJXUQKSvgaUxKLcg8+zkJWr2r+Z/rUpoq5RDAYfTVV8
         ylMh7+iiPQ4YJzfK6kILGUA9tJckMqWCqgvHw6IQsKehfjZBEeTqKLEp7cz2uIb+LZ
         1YsU5EKs86qNi/jfn8UhsWOGhRkCwHz6cqtxiPyjgiXxMv8dzrhK4ANni96I+MqC5B
         yP1NSJfc78JtnzGfX2vzL9lg1DJZwW/8slSB3m/24uMERUg0BDSa0MSR/khvQ9IC27
         PXpRH76C0gJnZgsFcntRGy3qY8UqpRW2+6LXOvx3zSNFmLlKrOEztHD4gnJGCdtWAg
         +cZxGPc7s8zdQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 16 Sep 2023 08:20:29 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Avoid a potential useless over memory allocation in bch2_prt_vprintf()
Date:   Sat, 16 Sep 2023 08:20:24 +0200
Message-Id: <0f40108bed3e084057223bdbe32c4b37f8500ff3.1694845203.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

printbuf_remaining() returns the number of characters we can print to the
output buffer - i.e. excluding the terminating null.

vsnprintf() takes the size of the buffer, including the trailing null
space.
It is truncated if the returned value is greater than or equal to the size
of the buffer.

Knowing all that, buffer sizes and overflow checks can be fixed in order
to potentially avoid a useless memory over-allocation.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Un-tested
---
 fs/bcachefs/printbuf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/printbuf.c b/fs/bcachefs/printbuf.c
index de41f9a14492..77bee9060bfe 100644
--- a/fs/bcachefs/printbuf.c
+++ b/fs/bcachefs/printbuf.c
@@ -54,8 +54,9 @@ void bch2_prt_vprintf(struct printbuf *out, const char *fmt, va_list args)
 		va_list args2;
 
 		va_copy(args2, args);
-		len = vsnprintf(out->buf + out->pos, printbuf_remaining(out), fmt, args2);
-	} while (len + 1 >= printbuf_remaining(out) &&
+		len = vsnprintf(out->buf + out->pos, printbuf_remaining(out) + 1,
+				fmt, args2);
+	} while (len >= printbuf_remaining(out) + 1 &&
 		 !bch2_printbuf_make_room(out, len + 1));
 
 	len = min_t(size_t, len,
@@ -70,9 +71,10 @@ void bch2_prt_printf(struct printbuf *out, const char *fmt, ...)
 
 	do {
 		va_start(args, fmt);
-		len = vsnprintf(out->buf + out->pos, printbuf_remaining(out), fmt, args);
+		len = vsnprintf(out->buf + out->pos, printbuf_remaining(out) + 1,
+				fmt, args);
 		va_end(args);
-	} while (len + 1 >= printbuf_remaining(out) &&
+	} while (len >= printbuf_remaining(out) + 1 &&
 		 !bch2_printbuf_make_room(out, len + 1));
 
 	len = min_t(size_t, len,
-- 
2.34.1

