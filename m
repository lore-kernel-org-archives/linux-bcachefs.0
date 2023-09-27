Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770DDE810D0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 11:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjI0LYO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjI0LYN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 07:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD70192
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 04:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695813804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX37w7YvefuP9vVNl6UL2Cb4/+L7BmDNBZwAp80JRmA=;
        b=jCblIDUCz8fZnuZJH/A/QgHuhZALaGfeUncMOIK03IBHUx+tVU8aRNtJXG+nj9Ymm0nqEV
        cyWSEXk+vtTMDsRy1Jp50eNGTAok4Oy0hhPTWj532VPt8uikTf54oytjGSEqd+7HmyLVP7
        HAEZZJFnIpRuOpXQi3Z59/sTMYvqPh8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-9mK04bbCOy6ZjeGMEMKNaA-1; Wed, 27 Sep 2023 07:23:21 -0400
X-MC-Unique: 9mK04bbCOy6ZjeGMEMKNaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2640280FEC5
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9347215670B
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order problem
Date:   Wed, 27 Sep 2023 07:23:37 -0400
Message-ID: <20230927112338.262207-2-bfoster@redhat.com>
In-Reply-To: <20230927112338.262207-1-bfoster@redhat.com>
References: <20230927112338.262207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

An fsstress task on a big endian system (s390x) quickly produces a
bunch of CRC errors in the system logs. Most of these are related to
the narrow CRCs path, but the fundamental problem can be reduced to
a single write and re-read (after dropping caches) of a previously
merged extent.

The key merge path that handles extent merges eventually calls into
bch2_checksum_merge() to combine the CRCs of the associated extents.
This code attempts to avoid a byte order swap by feeding the le64
values into the crc32c code, but the latter casts the resulting u64
value down to a u32, which truncates the high bytes where the actual
crc value ends up. This results in a CRC value that does not change
(since it is merged with a CRC of 0), and checksum failures ensue.

Fix the checksum merge code to swap to cpu byte order on the
boundaries to the external crc code such that any value casting is
handled properly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/checksum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 1948119edbf4..4cc0196ec9a5 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -362,7 +362,7 @@ struct bch_csum bch2_checksum_merge(unsigned type, struct bch_csum a,
 
 	state.type = type;
 	bch2_checksum_init(&state);
-	state.seed = (u64 __force) a.lo;
+	state.seed = le64_to_cpu(a.lo);
 
 	BUG_ON(!bch2_checksum_mergeable(type));
 
@@ -373,7 +373,7 @@ struct bch_csum bch2_checksum_merge(unsigned type, struct bch_csum a,
 				page_address(ZERO_PAGE(0)), page_len);
 		b_len -= page_len;
 	}
-	a.lo = (__le64 __force) bch2_checksum_final(&state);
+	a.lo = cpu_to_le64(bch2_checksum_final(&state));
 	a.lo ^= b.lo;
 	a.hi ^= b.hi;
 	return a;
-- 
2.41.0

