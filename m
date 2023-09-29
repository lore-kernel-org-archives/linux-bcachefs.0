Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F45E71D3D
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 14:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjI2Ol5 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 10:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2Ol4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 10:41:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A541A7
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695998474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fmda5R0YWZY2R/DCKn4eCBIRiIdFe7lZRfJYK0Y/eIk=;
        b=cJ6pE4kFkpoljjnSHkWnfMeuXTARCCGjO+pmeUlZnDI30vFDIuDYR5g1ReK4RETk7zDtwg
        2vuHrMFb0eTXBg3W481+quDFz3AQbiwK+Ol6gXsEpv7kfzj5JpXWuP3LND6XgTs7RXng0F
        iA/4r0wEuv8J1Y7ghGnerIrkO7QjCl4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-zewz-tWnMq2qWhyuYXHkMg-1; Fri, 29 Sep 2023 10:41:12 -0400
X-MC-Unique: zewz-tWnMq2qWhyuYXHkMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5895785A5BD
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 14:41:12 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0B940C2064
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 14:41:12 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] bcachefs: allow writeback to fill bio completely
Date:   Fri, 29 Sep 2023 10:41:30 -0400
Message-ID: <20230929144130.355116-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The bcachefs folio writeback code includes a bio full check as well
as a fixed size check to determine when to split off and submit
writeback I/O. The inclusive check of the latter against the limit
means that writeback can submit slightly prematurely. This is not a
functional problem, but results in unnecessarily split I/Os and
extent merging.

This can be observed with a buffered write sized exactly to the
current maximum value (1MB) and with key_merging_disabled=1. The
latter prevents the merge from the second write such that a
subsequent check of the extent list shows a 1020k extent followed by
a contiguous 4k extent.

The purpose for the fixed size check is also undocumented and
somewhat obscure. Lift this check into a new helper that wraps the
bio check, fix the comparison logic, and add a comment to document
the purpose and how we might improve on this in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

CI: https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

v2:
- Preserve the current size limit and fix up the logic.
v1: https://lore.kernel.org/linux-bcachefs/20230927112338.262207-3-bfoster@redhat.com/

 fs/bcachefs/fs-io-buffered.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 58ccc7b91ac7..52f0e7acda3d 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -389,6 +389,21 @@ static inline struct bch_writepage_state bch_writepage_state_init(struct bch_fs
 	return ret;
 }
 
+/*
+ * Determine when a writepage io is full. We have to limit writepage bios to a
+ * single page per bvec (i.e. 1MB with 4k pages) because that is the limit to
+ * what the bounce path in bch2_write_extent() can handle. In theory we could
+ * loosen this restriction for non-bounce I/O, but we don't have that context
+ * here. Ideally, we can up this limit and make it configurable in the future
+ * when the bounce path can be enhanced to accommodate larger source bios.
+ */
+static inline bool bch_io_full(struct bch_writepage_io *io, unsigned len)
+{
+	struct bio *bio = &io->op.wbio.bio;
+	return bio_full(bio, len) ||
+		(bio->bi_iter.bi_size + len > BIO_MAX_VECS * PAGE_SIZE);
+}
+
 static void bch2_writepage_io_done(struct bch_write_op *op)
 {
 	struct bch_writepage_io *io =
@@ -606,9 +621,7 @@ static int __bch2_writepage(struct folio *folio,
 
 		if (w->io &&
 		    (w->io->op.res.nr_replicas != nr_replicas_this_write ||
-		     bio_full(&w->io->op.wbio.bio, sectors << 9) ||
-		     w->io->op.wbio.bio.bi_iter.bi_size + (sectors << 9) >=
-		     (BIO_MAX_VECS * PAGE_SIZE) ||
+		     bch_io_full(w->io, sectors << 9) ||
 		     bio_end_sector(&w->io->op.wbio.bio) != sector))
 			bch2_writepage_do_io(w);
 
-- 
2.41.0

