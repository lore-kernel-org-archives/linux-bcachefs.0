Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9201C49EA5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 02:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8867F60FEA
	for <linux-bcachefs@archiver.kernel.org>; Fri, 25 Jun 2021 02:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhFYC26 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 24 Jun 2021 22:28:58 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17406 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhFYC26 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 24 Jun 2021 22:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1624587093; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=V/DuHw+Qr6x2did+dT93IyJgEJrZsRlbu0GRAPlp+jNoUIoJix5O+ZO9gnoPc2fwZeFAoNPSgKjPEl8vx6xDSzSRqMRNbSGVOKcmZcHfHtDcpip+pMH71ro3Q8RIyIDXWte2KDqwYlCEkqANg8e3TMPh2sXhrSINgkmdkhf/ZhQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1624587093; h=Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=bnUEDjgQd7YtUmZj6zLxFPhV1H1pwyXi142x9mwP9gg=; 
        b=M0FJxFEi8L8UZkpO0VxWaft/erYYArDLwkzs059dRPdkt2eCoL5sKL6wYdNKzTyhHs0FGHs7t+Lw2ca4z+TeDXwo6dL8Md2edRzTH3+phCKKVy7PqgFWhE/VNkthtPBmsbgYRwd99RRS2fFjLFeuncbmzXjdqSqy4rgIOfnWi0Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com>
Received: from gothmog.test (pool-108-51-207-71.washdc.fios.verizon.net [108.51.207.71]) by mx.zohomail.com
        with SMTPS id 1624587090577515.7105532171563; Thu, 24 Jun 2021 19:11:30 -0700 (PDT)
From:   Dan Robertson <dan@dlrobertson.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 1/1] generic/103: increase reserved bytes for bcachefs
Date:   Thu, 24 Jun 2021 22:11:18 -0400
Message-Id: <20210625021118.28813-2-dan@dlrobertson.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210625021118.28813-1-dan@dlrobertson.com>
References: <20210625021118.28813-1-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The bcachefs btree nodes are quite large. If we only reserve 512 bytes
we hit an intermittent failure where the fallocate that is intented to
fill the available space triggers a btree node split and the exente update
is interrupted. The retry of the extent update will fail because the
new amount of available space is less than that of the request.

Signed-off-by: Dan Robertson <dan@dlrobertson.com>
---
 tests/generic/103 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tests/generic/103 b/tests/generic/103
index b22b0159..610f31f6 100755
--- a/tests/generic/103
+++ b/tests/generic/103
@@ -43,7 +43,15 @@ _consume_freesp()
 
 	# consume nearly all available space (leave ~512kB)
 	avail=`_get_available_space $SCRATCH_MNT`
-	filesizekb=$((avail / 1024 - 512))
+	if [ $FSTYP = "bcachefs" ]; then
+		# The bcachefs btree nodes are quite large. If the fallocate
+		# triggers a split leaf of a btree node, we'll need more
+		# than 512 kept in reserve.
+		reserve=1024
+	else
+		reserve=512
+	fi
+	filesizekb=$((avail / 1024 - reserve))
 	$XFS_IO_PROG -fc "falloc 0 ${filesizekb}k" $file
 }
 
