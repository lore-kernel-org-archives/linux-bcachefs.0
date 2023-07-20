Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6AFEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Thu, 20 Jul 2023 12:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjGTM63 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 20 Jul 2023 08:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjGTM62 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 20 Jul 2023 08:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12110D2
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jul 2023 05:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689857862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BgjU3Z8BJ1HH/hIyFDOYjbgiIpABadDIfH/RKXLj3aA=;
        b=S53GRCsOpPJ1JGDPjJAZOnDoOrnCS15qBsoY7o8spvk7sDWbECUF1TII+9h6J6d/BTGgys
        TyOFBVe2nfvtsktCO26rzmblwZzJonqHE2A1OhEDYqJJ3K0rj5WMl5KCe8qk0frKNzhyxX
        7q9RVijwqbB/A2zVGy335mXbvr7JmOc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-o2aqzmI6PDqBlqgqkE_y7A-1; Thu, 20 Jul 2023 08:57:40 -0400
X-MC-Unique: o2aqzmI6PDqBlqgqkE_y7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D601A3852D83;
        Thu, 20 Jul 2023 12:57:36 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0C991121314;
        Thu, 20 Jul 2023 12:57:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] MAINTAINERS: add Brian Foster as a reviewer for bcachefs
Date:   Thu, 20 Jul 2023 09:00:33 -0400
Message-ID: <20230720130033.5730-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Brian has been playing with bcachefs for several months now and has
offerred to commit time to patch review.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Just not in the next week or so, since I'm heading off on vacation. :)

Brian

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 48763cc35386..22c57b3bc211 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3524,6 +3524,7 @@ F:	drivers/md/bcache/
 
 BCACHEFS
 M:	Kent Overstreet <kent.overstreet@linux.dev>
+R:	Brian Foster <bfoster@redhat.com>
 L:	linux-bcachefs@vger.kernel.org
 S:	Supported
 C:	irc://irc.oftc.net/bcache
-- 
2.41.0

