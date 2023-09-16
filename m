Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41124CD37B6
	for <linux-bcachefs@archiver.kernel.org>; Sat, 16 Sep 2023 07:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjIPHa7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 16 Sep 2023 03:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjIPHaa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 16 Sep 2023 03:30:30 -0400
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0A21724
        for <linux-bcachefs@vger.kernel.org>; Sat, 16 Sep 2023 00:30:23 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id hPkzqXWcGBLWLhPkzqni2a; Sat, 16 Sep 2023 09:30:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1694849422;
        bh=FCzGUfVfl3gyXvyMuMWEuajChRiIpmEDWmkcE4/V2oA=;
        h=From:To:Cc:Subject:Date;
        b=bj5eJ+EpYft4no84HOrXdiDq5nzVL9vVG65EmhQgoM+uUPmKRJwuX5QWFsk0LsTgm
         pqPKT8vemhX3ZmpzoDYR2+sVOn2MEeAN1cRnp6rRRcFwTyTTVPdrr8xj5oa8WHq9NL
         Qw9wmVBBCqnwycFUd9TVZzp1UkpYdcNyLV9fFXubg9jZ7Jp1X1WZyBZFdpqMaR3XrB
         cehOkz8dLPiWpFCfMXc4yDqhAOrWS49eT1eZUEqpM/N0zdhSigyBL2O3LZ8fR16E0a
         IOyerjRtCULOvgQAIN0/Rs0lLOQ7dKFGQoXKp2oJHpTBU/uAH1bjzOW0To80ZaPSmY
         W1nIE7qwIxp/w==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 16 Sep 2023 09:30:22 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Use snprintf() instead of scnprintf() when appropriate
Date:   Sat, 16 Sep 2023 09:30:19 +0200
Message-Id: <9a998be3e2dbedcd3a9eae5f81ae6dcc6c0f98c4.1694849375.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

snprintf() and scnprintf() are the same, except for the returned value.
When this value is not used, it is more logical to use snprintf() which is
slightly simpler.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/bcachefs/super.c | 2 +-
 fs/bcachefs/tests.c | 2 +-
 fs/bcachefs/trace.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 2990eed85adf..773ea93e44c1 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1180,7 +1180,7 @@ static void bch2_dev_attach(struct bch_fs *c, struct bch_dev *ca,
 {
 	ca->dev_idx = dev_idx;
 	__set_bit(ca->dev_idx, ca->self.d);
-	scnprintf(ca->name, sizeof(ca->name), "dev-%u", dev_idx);
+	snprintf(ca->name, sizeof(ca->name), "dev-%u", dev_idx);
 
 	ca->fs = c;
 	rcu_assign_pointer(c->devs[ca->dev_idx], ca);
diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index c907b3e00176..72f9bf186f9c 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -926,7 +926,7 @@ int bch2_btree_perf_test(struct bch_fs *c, const char *testname,
 
 	time = j.finish - j.start;
 
-	scnprintf(name_buf, sizeof(name_buf), "%s:", testname);
+	snprintf(name_buf, sizeof(name_buf), "%s:", testname);
 	prt_human_readable_u64(&nr_buf, nr);
 	prt_human_readable_u64(&per_sec_buf, div64_u64(nr * NSEC_PER_SEC, time));
 	printk(KERN_INFO "%-12s %s with %u threads in %5llu sec, %5llu nsec per iter, %5s per sec\n",
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 19264492151b..da303dd4b71c 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -450,7 +450,7 @@ TRACE_EVENT(btree_path_relock_fail,
 			c = six_lock_counts(&path->l[level].b->c.lock);
 			__entry->read_count	= c.n[SIX_LOCK_read];
 			__entry->intent_count	= c.n[SIX_LOCK_intent];
-			scnprintf(__entry->node, sizeof(__entry->node), "%px", b);
+			snprintf(__entry->node, sizeof(__entry->node), "%px", b);
 		}
 		__entry->iter_lock_seq		= path->l[level].lock_seq;
 		__entry->node_lock_seq		= is_btree_node(path, level)
-- 
2.34.1

