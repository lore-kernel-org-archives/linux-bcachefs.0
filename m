Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105CAC433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu,  4 Nov 2021 21:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C9761106
	for <linux-bcachefs@archiver.kernel.org>; Thu,  4 Nov 2021 21:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhKDVF6 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:05:58 -0400
Received: from cdw.me.uk ([91.203.57.136]:44733 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232305AbhKDVF6 (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 4 Nov 2021 17:05:58 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mijtE-0005q4-BQ; Thu, 04 Nov 2021 21:03:16 +0000
Date:   Thu, 4 Nov 2021 21:03:16 +0000
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Return -ENOKEY/EINVAL when mount decryption fails
Message-ID: <20211104210316.GA22353@arachsys.com>
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

Signed-off-by: Chris Webb <chris@arachsys.com>
---

Notes:
    v1: Generated to apply against v5.13 bcachefs kernel (2021-10-14)
    v2: Updated to apply against v5.15 bcachefs kernel (2021-11-04)

 fs/bcachefs/super.c | 51 ++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index dc8f641504be..9cd296feb312 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -638,12 +638,15 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
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
 
@@ -724,13 +727,16 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
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
 
@@ -745,8 +751,10 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	c->block_bits		= ilog2(c->opts.block_size);
 	c->btree_foreground_merge_threshold = BTREE_FOREGROUND_MERGE_THRESHOLD(c);
 
-	if (bch2_fs_init_fault("fs_alloc"))
+	if (bch2_fs_init_fault("fs_alloc")) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	iter_size = sizeof(struct sort_iter) +
 		(btree_blocks(c) + 1) * 2 *
@@ -787,10 +795,15 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
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
 
 	if (c->opts.nochanges)
@@ -799,8 +812,10 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
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
@@ -815,14 +830,15 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
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
 
@@ -1939,10 +1955,11 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
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
@@ -1973,7 +1990,7 @@ struct bch_fs *bch2_fs_open(char * const *devices, unsigned nr_devices,
 	       devices[0], err);
 	ret = -EINVAL;
 err:
-	if (c)
+	if (!IS_ERR_OR_NULL(c))
 		bch2_fs_stop(c);
 	for (i = 0; i < nr_devices; i++)
 		bch2_free_super(&sb[i]);
@@ -2002,12 +2019,12 @@ static const char *__bch2_fs_open_incremental(struct bch_sb_handle *sb,
 		if (err)
 			goto err;
 	} else {
-		c = bch2_fs_alloc(sb->sb, opts);
-		err = "cannot allocate memory";
-		if (!c)
-			goto err;
-
 		allocated_fs = true;
+		c = bch2_fs_alloc(sb->sb, opts);
+
+		err = "bch2_fs_alloc() error";
+		if (IS_ERR(c))
+			goto err;
 	}
 
 	err = "bch2_dev_online() error";
@@ -2033,7 +2050,7 @@ static const char *__bch2_fs_open_incremental(struct bch_sb_handle *sb,
 err:
 	mutex_unlock(&bch_fs_list_lock);
 
-	if (allocated_fs)
+	if (allocated_fs && !IS_ERR(c))
 		bch2_fs_stop(c);
 	else if (c)
 		closure_put(&c->cl);
