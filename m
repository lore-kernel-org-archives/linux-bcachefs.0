Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6F5C77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbjEIRBK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjEIRAI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 13:00:08 -0400
Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3515FD2
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:58:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcHhLx9X66ZiP+hkbacjwT2I7KoTF7hsRShtmv0sqzA=;
        b=biwaHuM/eMP7HCr+Axj3/+gSQknHQmfD/m+5P9FSCxSV1Qo7DgDdKxnIfUnw7Z52iep6WD
        5RtlZ21/HtbKg2eI2eaHqsksKozLugNUlmXy/eh7CPd/+wwd2fDjXTK5MrowYJjuWCoxcf
        A3j0RF4EpAMOrAqGuKGPzDWm6rjV1QI=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 32/32] MAINTAINERS: Add entry for bcachefs
Date:   Tue,  9 May 2023 12:56:57 -0400
Message-Id: <20230509165657.1735798-33-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs is a new copy-on-write filesystem; add a MAINTAINERS entry for
it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dbf3c33c31..0ac2b432f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3509,6 +3509,13 @@ W:	http://bcache.evilpiepirate.org
 C:	irc://irc.oftc.net/bcache
 F:	drivers/md/bcache/
 
+BCACHEFS:
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+L:	linux-bcachefs@vger.kernel.org
+S:	Supported
+C:	irc://irc.oftc.net/bcache
+F:	fs/bcachefs/
+
 BDISP ST MEDIA DRIVER
 M:	Fabien Dessenne <fabien.dessenne@foss.st.com>
 L:	linux-media@vger.kernel.org
-- 
2.40.1

