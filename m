Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EC9C25B6B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbjJXTO3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344223AbjJXTO2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:28 -0400
Received: from out-193.mta1.migadu.com (out-193.mta1.migadu.com [IPv6:2001:41d0:203:375::c1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F03E10C9
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5QtDPT9ZLedBVfTukHPyHh7a471xh3qUsNemx6VERM=;
        b=HEhIztzqrW2L+6CNGGrGpUx5a5QVWF66Lf9T1ctdmSQMIQjNlbkg6OhP9DA66Mkxl/4WIb
        KCSyc2hgAFuDLSgx3GfZt169y30u6Cz7dRYVTnaYKksiPU18Y+fTKHRWeaColcV5i5tDB8
        +/XcJFkseQXnmLP0UiFnZjajXLpycgc=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/6] bcachefs: bch2_inum_opts_get()
Date:   Tue, 24 Oct 2023 15:14:10 -0400
Message-ID: <20231024191414.2157874-6-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

New helper for new rebalance code

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/inode.c | 12 ++++++++++++
 fs/bcachefs/inode.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index a3921c397ea2..23fcd442c514 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -981,6 +981,18 @@ void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
 		opts->compression = opts->background_compression = opts->data_checksum = opts->erasure_code = 0;
 }
 
+int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_io_opts *opts)
+{
+	struct bch_inode_unpacked inode;
+	int ret = lockrestart_do(trans, bch2_inode_find_by_inum_trans(trans, inum, &inode));
+
+	if (ret)
+		return ret;
+
+	bch2_inode_opts_get(opts, trans->c, &inode);
+	return 0;
+}
+
 int bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
 {
 	struct bch_fs *c = trans->c;
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index a7464e1b6960..2781e3281583 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -200,6 +200,7 @@ void bch2_inode_nlink_dec(struct btree_trans *, struct bch_inode_unpacked *);
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
 void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
+int bch2_inum_opts_get(struct btree_trans*, subvol_inum, struct bch_io_opts *);
 
 int bch2_inode_rm_snapshot(struct btree_trans *, u64, u32);
 int bch2_delete_dead_inodes(struct bch_fs *);
-- 
2.42.0

