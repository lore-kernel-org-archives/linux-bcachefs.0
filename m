Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B24C4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed,  1 Nov 2023 13:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjKANBP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjKANBP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 09:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282FD101
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 06:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698843630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l59QNL8WpomZ1eV/XolkCj2jfIE+VYD5X7E5qEGdHIo=;
        b=Eo9crFpHV8zvdDG0y6CNd4pKHaAdoPDnBaWgNM7hvhDhzeAIlNSdOKum9tqgxgh/3+4MBU
        Kzyrbz6BHIwp9D3WKICPrqi3otHIs+EKAdejBGjXMsz71FuxweCVji7myUjmPUkAWIoEI6
        m8VrPSqik7+jqfKc/q6U8/EIqIiXf0g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-Jsl8vOw_NXuZuG4ueRHwig-1; Wed, 01 Nov 2023 09:00:26 -0400
X-MC-Unique: Jsl8vOw_NXuZuG4ueRHwig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B645980D721;
        Wed,  1 Nov 2023 13:00:25 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81DBB1C060BA;
        Wed,  1 Nov 2023 13:00:25 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] bcachefs: fix odebug warn and lockdep splat due to on-stack rhashtable
Date:   Wed,  1 Nov 2023 09:01:02 -0400
Message-ID: <20231101130102.365223-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Guenter Roeck reports a lockdep splat and DEBUG_OBJECTS_WORK related
warning when bch2_copygc_thread() initializes its rhashtable. The
lockdep splat relates to a warning print caused by the fact that the
rhashtable exists on the stack but is not annotated as so. This is
something that could be addressed by INIT_WORK_ONSTACK(), but
rhashtable doesn't expose that control and probably isnt worth the
churn for just one user. Instead, dynamically allocate the
buckets_in_flight structure and avoid the splat that way.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/movinggc.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 6f9882f6622b..0158c7aae6b0 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -305,14 +305,16 @@ static int bch2_copygc_thread(void *arg)
 	struct moving_context ctxt;
 	struct bch_move_stats move_stats;
 	struct io_clock *clock = &c->io_clock[WRITE];
-	struct buckets_in_flight buckets;
+	struct buckets_in_flight *buckets;
 	u64 last, wait;
 	int ret = 0;
 
-	memset(&buckets, 0, sizeof(buckets));
-
-	ret = rhashtable_init(&buckets.table, &bch_move_bucket_params);
+	buckets = kzalloc(sizeof(struct buckets_in_flight), GFP_KERNEL);
+	if (!buckets)
+		return -ENOMEM;
+	ret = rhashtable_init(&buckets->table, &bch_move_bucket_params);
 	if (ret) {
+		kfree(buckets);
 		bch_err_msg(c, ret, "allocating copygc buckets in flight");
 		return ret;
 	}
@@ -331,12 +333,12 @@ static int bch2_copygc_thread(void *arg)
 		cond_resched();
 
 		if (!c->copy_gc_enabled) {
-			move_buckets_wait(&ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, buckets, true);
 			kthread_wait_freezable(c->copy_gc_enabled);
 		}
 
 		if (unlikely(freezing(current))) {
-			move_buckets_wait(&ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, buckets, true);
 			__refrigerator(false);
 			continue;
 		}
@@ -347,7 +349,7 @@ static int bch2_copygc_thread(void *arg)
 		if (wait > clock->max_slop) {
 			c->copygc_wait_at = last;
 			c->copygc_wait = last + wait;
-			move_buckets_wait(&ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, buckets, true);
 			trace_and_count(c, copygc_wait, c, wait, last + wait);
 			bch2_kthread_io_clock_wait(clock, last + wait,
 					MAX_SCHEDULE_TIMEOUT);
@@ -357,7 +359,7 @@ static int bch2_copygc_thread(void *arg)
 		c->copygc_wait = 0;
 
 		c->copygc_running = true;
-		ret = bch2_copygc(&ctxt, &buckets, &did_work);
+		ret = bch2_copygc(&ctxt, buckets, &did_work);
 		c->copygc_running = false;
 
 		wake_up(&c->copygc_running_wq);
@@ -373,8 +375,10 @@ static int bch2_copygc_thread(void *arg)
 		}
 	}
 
-	move_buckets_wait(&ctxt, &buckets, true);
-	rhashtable_destroy(&buckets.table);
+	move_buckets_wait(&ctxt, buckets, true);
+
+	rhashtable_destroy(&buckets->table);
+	kfree(buckets);
 	bch2_moving_ctxt_exit(&ctxt);
 	bch2_move_stats_exit(&move_stats, c);
 
-- 
2.41.0

