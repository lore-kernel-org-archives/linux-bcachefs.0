Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57E1C54E94
	for <linux-bcachefs@archiver.kernel.org>; Wed, 25 Jan 2023 16:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjAYQnf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 25 Jan 2023 11:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbjAYQnd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 25 Jan 2023 11:43:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A191259E8
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jan 2023 08:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674664964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7XRtDgrGXT5KeEsV1Ejo6vJuOK5Z477PsSDQQHe1GYI=;
        b=fD+YX/buNwRGsLVehdFtoxx85CJiEu1Kq/YKgFJ+Qbgw3BTFUrfS4DX1cFOiihyp054fPD
        JJfYNWDDdBtFOn5ExR0GwVFiKRxFiH6iu4tlbFGQkS88EhhoGqjZAMz5OjZrz4Ex3+K1la
        JmJkQ/maYVFAr7k+H+aJ2mcX4BnpMkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-3HoCY_OdNsiabOkPMbDg2g-1; Wed, 25 Jan 2023 11:42:40 -0500
X-MC-Unique: 3HoCY_OdNsiabOkPMbDg2g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7DF1100F909
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jan 2023 16:42:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B117A492C14
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jan 2023 16:42:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: push cpuid variable down into bch2_inode_create()
Date:   Wed, 25 Jan 2023 11:43:55 -0500
Message-Id: <20230125164355.43269-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: root <root@fs-i40c-08.fs.lab.eng.bos.redhat.com>

The cpu id number only appears to be used by inode number sharding,
which is isolated to the inode create function. Push it down a function
to eliminate an unnecessary parameter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Just a small, random cleanup from roving around the code...

Brian

 fs/bcachefs/fs-common.c | 3 +--
 fs/bcachefs/inode.c     | 3 ++-
 fs/bcachefs/inode.h     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
index 1f2e1fc4f6b2..abde0b5ea30e 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/fs-common.c
@@ -32,7 +32,6 @@ int bch2_create_trans(struct btree_trans *trans,
 	struct btree_iter inode_iter = { NULL };
 	subvol_inum new_inum = dir;
 	u64 now = bch2_current_time(c);
-	u64 cpu = raw_smp_processor_id();
 	u64 dir_target;
 	u32 snapshot;
 	unsigned dir_type = mode_to_type(mode);
@@ -53,7 +52,7 @@ int bch2_create_trans(struct btree_trans *trans,
 		if (flags & BCH_CREATE_TMPFILE)
 			new_inode->bi_flags |= BCH_INODE_UNLINKED;
 
-		ret = bch2_inode_create(trans, &inode_iter, new_inode, snapshot, cpu);
+		ret = bch2_inode_create(trans, &inode_iter, new_inode, snapshot);
 		if (ret)
 			goto err;
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 560545a7ea03..9b3df4256219 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -628,13 +628,14 @@ static inline u32 bkey_generation(struct bkey_s_c k)
 int bch2_inode_create(struct btree_trans *trans,
 		      struct btree_iter *iter,
 		      struct bch_inode_unpacked *inode_u,
-		      u32 snapshot, u64 cpu)
+		      u32 snapshot)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_s_c k;
 	u64 min, max, start, pos, *hint;
 	int ret = 0;
 	unsigned bits = (c->opts.inodes_32bit ? 31 : 63);
+	u64 cpu = raw_smp_processor_id();
 
 	if (c->opts.shard_inode_numbers) {
 		bits -= c->inode_shard_bits;
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index f5066afb4886..86cb32503a23 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -101,7 +101,7 @@ void bch2_inode_init(struct bch_fs *, struct bch_inode_unpacked *,
 		     struct bch_inode_unpacked *);
 
 int bch2_inode_create(struct btree_trans *, struct btree_iter *,
-		      struct bch_inode_unpacked *, u32, u64);
+		      struct bch_inode_unpacked *, u32);
 
 int bch2_inode_rm(struct bch_fs *, subvol_inum);
 
-- 
2.39.1

