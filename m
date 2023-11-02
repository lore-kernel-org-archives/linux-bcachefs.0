Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B14C4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 02:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346522AbjKBCuJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 22:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346504AbjKBCuE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 22:50:04 -0400
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E75C184
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:49:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698893372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgS50a7UGhoWZX3jzc6fu31kYnFQwHCuySCcxYtwyrc=;
        b=r4BDEInxPtXVgdKRuXSfreBOnAuyx+EkrnIsNFXH+NhUK8Y7kiSoeIlYq1Ay3UPC0urUX6
        uZRZ7VVQFPo0h6cuFaDzI2XxIFvfarUduFu4Xdn5yKMposjz6CdZSmfAa3BZ49Z5yMw3rG
        7qMuk/rJIUHbGz07lIW03fcD7qdX3iw=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Split brain detection
Date:   Wed,  1 Nov 2023 22:49:20 -0400
Message-ID: <20231102024924.4107287-3-kent.overstreet@linux.dev>
In-Reply-To: <20231102024924.4107287-1-kent.overstreet@linux.dev>
References: <20231102024924.4107287-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Use the new bch_member->seq, sb->write_time fields to detect split brain
and kick out devices when necessary.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/errcode.h |  1 +
 fs/bcachefs/super.c   | 56 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 2a11f32cf30a..e1f733eeb7f0 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -169,6 +169,7 @@
 	x(EINVAL,			device_size_too_small)			\
 	x(EINVAL,			device_not_a_member_of_filesystem)	\
 	x(EINVAL,			device_has_been_removed)		\
+	x(EINVAL,			device_splitbrain)			\
 	x(EINVAL,			device_already_online)			\
 	x(EINVAL,			insufficient_devices_to_start)		\
 	x(EINVAL,			invalid)				\
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 24672bb31cbe..e6b72ff06f56 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1012,20 +1012,46 @@ static int bch2_dev_may_add(struct bch_sb *sb, struct bch_fs *c)
 	return 0;
 }
 
-static int bch2_dev_in_fs(struct bch_sb *fs, struct bch_sb *sb)
+static int bch2_dev_in_fs(struct bch_sb_handle *fs,
+			  struct bch_sb_handle *sb)
 {
-	struct bch_sb *newest =
-		le64_to_cpu(fs->seq) > le64_to_cpu(sb->seq) ? fs : sb;
+	if (fs == sb)
+		return 0;
 
-	if (!uuid_equal(&fs->uuid, &sb->uuid))
+	if (!uuid_equal(&fs->sb->uuid, &sb->sb->uuid))
 		return -BCH_ERR_device_not_a_member_of_filesystem;
 
-	if (!bch2_dev_exists(newest, sb->dev_idx))
+	if (!bch2_dev_exists(fs->sb, sb->sb->dev_idx))
 		return -BCH_ERR_device_has_been_removed;
 
-	if (fs->block_size != sb->block_size)
+	if (fs->sb->block_size != sb->sb->block_size)
 		return -BCH_ERR_mismatched_block_size;
 
+	if (fs->sb->seq == sb->sb->seq &&
+	    fs->sb->write_time != sb->sb->write_time) {
+		pr_err("Split brain detected between %pg and %pg:\n"
+		       "seq (%llu) equal but write_time does not match\n"
+		       "Not using older sb %pg",
+		       sb->bdev, fs->bdev,
+		       le64_to_cpu(sb->sb->seq), sb->bdev);
+		return -BCH_ERR_device_splitbrain;
+	}
+
+	struct bch_member m = bch2_sb_member_get(fs->sb, sb->sb->dev_idx);
+	u64 seq_from_fs		= le64_to_cpu(m.seq);
+	u64 seq_from_member	= le64_to_cpu(sb->sb->seq);
+
+	if (seq_from_fs && seq_from_fs < seq_from_member) {
+		pr_err("Split brain detected between %pg and %pg:\n"
+		       "%pg believes seq of %pg to be %llu, but %pg has %llu\n"
+		       "Not using %pg",
+		       sb->bdev, fs->bdev,
+		       fs->bdev, sb->bdev, seq_from_fs,
+		       sb->bdev, seq_from_member,
+		       sb->bdev);
+		return -BCH_ERR_device_splitbrain;
+	}
+
 	return 0;
 }
 
@@ -1734,7 +1760,7 @@ int bch2_dev_online(struct bch_fs *c, const char *path)
 
 	dev_idx = sb.sb->dev_idx;
 
-	ret = bch2_dev_in_fs(c->disk_sb.sb, sb.sb);
+	ret = bch2_dev_in_fs(&c->disk_sb, &sb);
 	if (ret) {
 		bch_err_msg(c, ret, "bringing %s online", path);
 		goto err;
@@ -1882,6 +1908,12 @@ struct bch_dev *bch2_dev_lookup(struct bch_fs *c, const char *name)
 
 /* Filesystem open: */
 
+static inline int sb_cmp(struct bch_sb *l, struct bch_sb *r)
+{
+	return  cmp_int(le64_to_cpu(l->seq), le64_to_cpu(r->seq)) ?:
+		cmp_int(le64_to_cpu(l->write_time), le64_to_cpu(r->write_time));
+}
+
 struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 			    struct bch_opts opts)
 {
@@ -1914,19 +1946,21 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 	}
 
 	darray_for_each(sbs, sb)
-		if (!best || le64_to_cpu(sb->sb->seq) > le64_to_cpu(best->sb->seq))
+		if (!best || sb_cmp(sb->sb, best->sb) > 0)
 			best = sb;
 
 	darray_for_each_reverse(sbs, sb) {
-		if (sb != best && !bch2_dev_exists(best->sb, sb->sb->dev_idx)) {
-			pr_info("%pg has been removed, skipping", sb->bdev);
+		ret = bch2_dev_in_fs(best, sb);
+
+		if (ret == -BCH_ERR_device_has_been_removed ||
+		    ret == -BCH_ERR_device_splitbrain) {
 			bch2_free_super(sb);
 			darray_remove_item(&sbs, sb);
 			best -= best > sb;
+			ret = 0;
 			continue;
 		}
 
-		ret = bch2_dev_in_fs(best->sb, sb->sb);
 		if (ret)
 			goto err_print;
 	}
-- 
2.42.0

