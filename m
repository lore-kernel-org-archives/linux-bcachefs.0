Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469A9EB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGIRQK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjGIRQJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:09 -0400
Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038BCF1
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/5vFcFkJusN+d7t+c7V3F5oG8QmnyosKj/7uky0sqpA=;
        b=StWvj8j0gh7GXEUFIkreC89gqmvfYBlxtTM5Afu6H1VqjPnm+Jt10niupS/TW0fdQMj7t7
        QnhvgtTf5DJ8bgXdsQg8RuZx00nOnM5v4Bp3mDzCqx9nOmfA4/IcTn0iuUTq6N08WDAy6E
        xovhc9dckgOS3buJQ7XtOGUjma7j3vA=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 08/10] bcachefs: Stash journal replay params in bch_fs
Date:   Sun,  9 Jul 2023 13:15:49 -0400
Message-Id: <20230709171551.2349961-9-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

For the upcoming enumeration of recovery passes, we need all recovery
passes to be called the same way - including journal replay.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |  3 +++
 fs/bcachefs/recovery.c | 11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 1ab32b61f0..67ed55761a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -993,6 +993,9 @@ struct bch_fs {
 	/* QUOTAS */
 	struct bch_memquota_type quotas[QTYP_NR];
 
+	/* RECOVERY */
+	u64			journal_replay_seq_start;
+	u64			journal_replay_seq_end;
 	/* DEBUG JUNK */
 	struct dentry		*fs_debug_dir;
 	struct dentry		*btree_debug_dir;
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 4c61a28e49..1499efc9d2 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -624,11 +624,13 @@ static int journal_sort_seq_cmp(const void *_l, const void *_r)
 	return cmp_int(l->journal_seq, r->journal_seq);
 }
 
-static int bch2_journal_replay(struct bch_fs *c, u64 start_seq, u64 end_seq)
+static int bch2_journal_replay(struct bch_fs *c)
 {
 	struct journal_keys *keys = &c->journal_keys;
 	struct journal_key **keys_sorted, *k;
 	struct journal *j = &c->journal;
+	u64 start_seq	= c->journal_replay_seq_start;
+	u64 end_seq	= c->journal_replay_seq_start;
 	size_t i;
 	int ret;
 
@@ -1256,6 +1258,9 @@ int bch2_fs_recovery(struct bch_fs *c)
 		blacklist_seq = journal_seq = le64_to_cpu(clean->journal_seq) + 1;
 	}
 
+	c->journal_replay_seq_start	= last_seq;
+	c->journal_replay_seq_end	= blacklist_seq - 1;;
+
 	if (c->opts.reconstruct_alloc) {
 		c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
 		drop_alloc_keys(&c->journal_keys);
@@ -1346,7 +1351,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		set_bit(BCH_FS_MAY_GO_RW, &c->flags);
 
 		bch_info(c, "starting journal replay, %zu keys", c->journal_keys.nr);
-		ret = bch2_journal_replay(c, last_seq, blacklist_seq - 1);
+		ret = bch2_journal_replay(c);
 		if (ret)
 			goto err;
 		if (c->opts.verbose || !c->sb.clean)
@@ -1406,7 +1411,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		set_bit(BCH_FS_MAY_GO_RW, &c->flags);
 
 		bch_verbose(c, "starting journal replay, %zu keys", c->journal_keys.nr);
-		ret = bch2_journal_replay(c, last_seq, blacklist_seq - 1);
+		ret = bch2_journal_replay(c);
 		if (ret)
 			goto err;
 		if (c->opts.verbose || !c->sb.clean)
-- 
2.40.1

