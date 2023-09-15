Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC6EEE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbjIOMwf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjIOMwd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:52:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D0DC19A5
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694782302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gdVjbevYsRHO7cxHrHkHDBtCl/9dhk1q7LBn8VJzC0=;
        b=COholny+wCoT3Wz1W7X5aiHhOq2PH/YoWnPUNpCiQSlzMW1Mi6Zr9C9HYu6cUcHji9J5To
        NLghVr7djCCnlBVSZX3MOq5pcEdVtH3YZf+AxNwmnH22KiYTmLCTCe4Jyw9oajjIK7Q8uU
        LFS2/bYIj4R3QTntamhHfY6I3a3i5Cs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-V39Mhp_dOsauh3sFXdzyFQ-1; Fri, 15 Sep 2023 08:51:40 -0400
X-MC-Unique: V39Mhp_dOsauh3sFXdzyFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84C77101A550
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A8951004145
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Date:   Fri, 15 Sep 2023 08:51:54 -0400
Message-ID: <20230915125154.307450-5-bfoster@redhat.com>
In-Reply-To: <20230915125154.307450-1-bfoster@redhat.com>
References: <20230915125154.307450-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Initial support for the vfs superblock freeze and unfreeze
operations. Superblock freeze occurs in stages, where the vfs
attempts to quiesce high level write operations, page faults, fs
internal operations, and then finally calls into the filesystem for
any last stage steps (i.e. log flushing, etc.) before marking the
superblock frozen.

The majority of write paths are covered by freeze protection (i.e.
sb_start_write() and friends) in higher level common code, with the
exception of the fs-internal SB_FREEZE_FS stage (i.e.
sb_start_intwrite()). This typically maps to active filesystem
transactions in a manner that allows the vfs to implement a barrier
of internal fs operations during the freeze sequence. This is not a
viable model for bcachefs, however, because it utilizes transactions
both to populate the journal as well as to perform journal reclaim.
This means that mapping intwrite protection to transaction lifecycle
or transaction commit is likely to deadlock freeze, as quiescing the
journal requires transactional operations blocked by the final stage
of freeze.

The flipside of this is that bcachefs does already maintain its own
internal sets of write references for similar purposes, currently
utilized for transitions from read-write to read-only mode. Since
this largely mirrors the high level sequence involved with freeze,
we can simply invoke this mechanism in the freeze callback to fully
quiesce the filesystem in the final stage. This means that while the
SB_FREEZE_FS stage is essentially a no-op, the ->freeze_fs()
callback that immediately follows begins by performing effectively
the same step by quiescing all internal write references.

One caveat to this approach is that without integration of internal
freeze protection, write operations gated on internal write refs
will fail with an internal -EROFS error rather than block on
acquiring freeze protection. IOW, this is roughly equivalent to only
having support for sb_start_intwrite_trylock(), and not the blocking
variant. Many of these paths already use non-blocking internal write
refs and so would map into an sb_start_intwrite_trylock() anyways.
The only instance of this I've been able to uncover that doesn't
explicitly rely on a higher level non-blocking write ref is the
bch2_rbio_narrow_crcs() path, which updates crcs in certain read
cases, and Kent has pointed out isn't critical if it happens to fail
due to read-only status.

Given that, implement basic freeze support as described above and
leave tighter integration with internal freeze protection as a
possible future enhancement. There are multiple potential ideas
worth exploring here. For example, we could implement a multi-stage
freeze callback that might allow bcachefs to quiesce its internal
write references without deadlocks, we could integrate intwrite
protection with bcachefs' internal write references somehow or
another, or perhaps consider implementing blocking support for
internal write refs to be used specifically for freeze, etc. In the
meantime, this enables functional freeze support and the associated
test coverage that comes with it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index c1abed92703b..1354af2cb85c 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1716,6 +1716,35 @@ static void bch2_put_super(struct super_block *sb)
 	__bch2_fs_stop(c);
 }
 
+/*
+ * bcachefs doesn't currently integrate intwrite freeze protection but the
+ * internal write references serve the same purpose. Therefore reuse the
+ * read-only transition code to perform the quiesce. The caveat is that we don't
+ * currently have the ability to block tasks that want a write reference while
+ * the superblock is frozen. This is fine for now, but we should either add
+ * blocking support or find a way to integrate sb_start_intwrite() and friends.
+ */
+static int bch2_freeze(struct super_block *sb)
+{
+	struct bch_fs *c = sb->s_fs_info;
+
+	down_write(&c->state_lock);
+	bch2_fs_read_only(c);
+	up_write(&c->state_lock);
+	return 0;
+}
+
+static int bch2_unfreeze(struct super_block *sb)
+{
+	struct bch_fs *c = sb->s_fs_info;
+	int ret;
+
+	down_write(&c->state_lock);
+	ret = bch2_fs_read_write(c);
+	up_write(&c->state_lock);
+	return ret;
+}
+
 static const struct super_operations bch_super_operations = {
 	.alloc_inode	= bch2_alloc_inode,
 	.destroy_inode	= bch2_destroy_inode,
@@ -1727,10 +1756,8 @@ static const struct super_operations bch_super_operations = {
 	.show_options	= bch2_show_options,
 	.remount_fs	= bch2_remount,
 	.put_super	= bch2_put_super,
-#if 0
 	.freeze_fs	= bch2_freeze,
 	.unfreeze_fs	= bch2_unfreeze,
-#endif
 };
 
 static int bch2_set_super(struct super_block *s, void *data)
-- 
2.41.0

