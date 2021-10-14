Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC268C433F5
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Oct 2021 12:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE065610CB
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Oct 2021 12:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhJNMmX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:42:23 -0400
Received: from cdw.me.uk ([91.203.57.136]:47823 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhJNMmX (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Oct 2021 08:42:23 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mb01w-0002Tp-Kc; Thu, 14 Oct 2021 13:40:16 +0100
Date:   Thu, 14 Oct 2021 13:40:16 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] bcachefs: Return -ENOKEY/EINVAL when mount decryption fails
Message-ID: <20211014124016.GE11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bch2_fs_encryption_init() correctly passes back -ENOKEY from request_key()
when no unlock key is found, or -EINVAL if superblock decryption fails
because of an invalid key. However, these get absorbed into a generic NULL
return from bch2_fs_alloc() and later returned to user space as -ENOMEM,
leading to a misleading error from mount(1):

  mount(2) system call failed: Out of memory.

Return explicit error pointers out of bch2_fs_alloc() and handle them in
both callers, so the user instead sees

  mount(2) system call failed: Required key not available.

when attempting to mount a filesystem which is still locked.

Signed-off-by: Chris Webb <chris@@arachsys.com>
---
 fs/bcachefs/super.c | 49 ++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index bb633e3df618..b75d814c97cd 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -645,12 +645,15 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	struct bch_fs *c;
 	unsigned i, iter_size;
 	const char *err;
+	int ret = 0;
 
 	pr_verbose_init(opts, "");
 
 	c = kvpmalloc(sizeof(struct bch_fs), GFP_KERNEL|__GFP_ZERO);
-	if (!c)
+	if (!c) {
+		c = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	__module_get(THIS_MODULE);
 
@@ -731,13 +734,16 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
 	mutex_init(&c->sectors_available_lock);
 
-	if (percpu_init_rwsem(&c->mark_lock))
+	if (percpu_init_rwsem(&c->mark_lock)) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	mutex_lock(&c->sb_lock);
 
 	if (bch2_sb_to_fs(c, sb)) {
 		mutex_unlock(&c->sb_lock);
+		ret = -ENOMEM;
 		goto err;
 	}
 
@@ -752,8 +758,10 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	c->block_bits		= ilog2(c->opts.block_size);
 	c->btree_foreground_merge_threshold = BTREE_FOREGROUND_MERGE_THRESHOLD(c);
 
-	if (bch2_fs_init_fault("fs_alloc"))
+	if (bch2_fs_init_fault("fs_alloc")) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	iter_size = sizeof(struct sort_iter) +
 		(btree_blocks(c) + 1) * 2 *
@@ -794,17 +802,24 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	    bch2_fs_btree_interior_update_init(c) ||
 	    bch2_fs_subvolumes_init(c) ||
 	    bch2_fs_io_init(c) ||
-	    bch2_fs_encryption_init(c) ||
 	    bch2_fs_compress_init(c) ||
 	    bch2_fs_ec_init(c) ||
-	    bch2_fs_fsio_init(c))
+	    bch2_fs_fsio_init(c)) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = bch2_fs_encryption_init(c);
+	if (ret)
 		goto err;
 
 	mi = bch2_sb_get_members(c->disk_sb.sb);
 	for (i = 0; i < c->sb.nr_devices; i++)
 		if (bch2_dev_exists(c->disk_sb.sb, mi, i) &&
-		    bch2_dev_alloc(c, i))
+		    bch2_dev_alloc(c, i)) {
+			ret = -ENOMEM;
 			goto err;
+		}
 
 	bch2_journal_entry_res_resize(&c->journal,
 			&c->btree_root_journal_res,
@@ -819,14 +834,15 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	mutex_unlock(&bch_fs_list_lock);
 	if (err) {
 		bch_err(c, "bch2_fs_online() error: %s", err);
+		ret = -ENOMEM;
 		goto err;
 	}
 out:
-	pr_verbose_init(opts, "ret %i", c ? 0 : -ENOMEM);
+	pr_verbose_init(opts, "ret %i", PTR_ERR_OR_ZERO(c));
 	return c;
 err:
 	bch2_fs_free(c);
-	c = NULL;
+	c = ERR_PTR(ret);
 	goto out;
 }
 
@@ -1931,10 +1947,11 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 		i++;
 	}
 
-	ret = -ENOMEM;
 	c = bch2_fs_alloc(sb[best_sb].sb, opts);
-	if (!c)
+	if (IS_ERR(c)) {
+		ret = PTR_ERR(c);
 		goto err;
+	}
 
 	err = "bch2_dev_online() error";
 	down_write(&c->state_lock);
@@ -1965,7 +1982,7 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 	       devices[0], err);
 	ret = -EINVAL;
 err:
-	if (c)
+	if (!IS_ERR_OR_NULL(c))
 		bch2_fs_stop(c);
 	for (i = 0; i < nr_devices; i++)
 		bch2_free_super(&sb[i]);
@@ -1994,12 +2011,12 @@ static const char *__bch2_fs_open_incremental(struct bch_sb_handle *sb,
 		if (err)
 			goto err;
 	} else {
+		allocated_fs = true;
 		c = bch2_fs_alloc(sb->sb, opts);
-		err = "cannot allocate memory";
-		if (!c)
-			goto err;
 
-		allocated_fs = true;
+		err = "bch2_fs_alloc() error";
+		if (IS_ERR(c))
+			goto err;
 	}
 
 	err = "bch2_dev_online() error";
@@ -2025,7 +2042,7 @@ static const char *__bch2_fs_open_incremental(struct bch_sb_handle *sb,
 err:
 	mutex_unlock(&bch_fs_list_lock);
 
-	if (allocated_fs)
+	if (allocated_fs && !IS_ERR(c))
 		bch2_fs_stop(c);
 	else if (c)
 		closure_put(&c->cl);
