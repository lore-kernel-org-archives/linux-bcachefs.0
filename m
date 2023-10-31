Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC18C4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 14:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjJaOLo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Oct 2023 10:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjJaOLo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Oct 2023 10:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F43C1
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Oct 2023 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698761452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7cAiFZDbqXAXs7sCflnjq5qd1T3C/J6RDfmcdO14Lq8=;
        b=GUhQv6UCkDBn1qLaU0esZKRnISsx8NRVfBVN+jj89h5M8+LSpR5gmb6H+RIGinwBgOXx14
        MEZdB3NsMpraRcvvRNQ5vwPWYMW28fP5GjjPywEu+OQIhXhVmqvkT4DMCvRizd9twXi5bJ
        Smv97pELRZHZsWIOoZf4VzSziBSUfT0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-5Mlv8V1gM06D3ODVGwFo7Q-1; Tue,
 31 Oct 2023 10:10:50 -0400
X-MC-Unique: 5Mlv8V1gM06D3ODVGwFo7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9CB029ABA29;
        Tue, 31 Oct 2023 14:10:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.88])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 879B22166B26;
        Tue, 31 Oct 2023 14:10:49 +0000 (UTC)
Date:   Tue, 31 Oct 2023 10:11:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: odebuf and lockdep splat with bcachefs
Message-ID: <ZUELDel5DKZGfAwu@bfoster>
References: <09a4c8ed-c984-4582-b5c4-0804ee4d55ec@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09a4c8ed-c984-4582-b5c4-0804ee4d55ec@roeck-us.net>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 30, 2023 at 08:07:17PM -0700, Guenter Roeck wrote:
> Hi,
> 
> when trying the new bcachefs in the mainline kernel, I see the
> attached ODEBUG and lockdep splats.
> 
> This is simply mounting an empty bcachefs file system and
> copying some files into it.
> 

Hi Guenter,

I reproduce fairly quickly with DEBUG_OBJECTS_WORK enabled. It looks to
me that the lockdep splat is essentially fallout from the subsequent
warning, which doesn't like the INIT_WORK() of the onstack rhashtable.
Ideally this could INIT_WORK_ONSTACK(), but I don't see support for that
plumbed through the rhashtable interface. Given this is the main copygc
task fn, it seems fairly reasonable to me to just slab alloc the whole
bucket tracking structure (as below). This addresses the splat for me on
a quick test.

Kent,

Let me know if you're good with this and I'll post a proper patch..

Brian

--- 8< ---

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 4017120baeee..b835b85ef8b9 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -304,14 +304,16 @@ static int bch2_copygc_thread(void *arg)
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
@@ -329,12 +331,12 @@ static int bch2_copygc_thread(void *arg)
 		cond_resched();
 
 		if (!c->copy_gc_enabled) {
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(trans, &ctxt, buckets, true);
 			kthread_wait_freezable(c->copy_gc_enabled);
 		}
 
 		if (unlikely(freezing(current))) {
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(trans, &ctxt, buckets, true);
 			__refrigerator(false);
 			continue;
 		}
@@ -345,7 +347,7 @@ static int bch2_copygc_thread(void *arg)
 		if (wait > clock->max_slop) {
 			c->copygc_wait_at = last;
 			c->copygc_wait = last + wait;
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(trans, &ctxt, buckets, true);
 			trace_and_count(c, copygc_wait, c, wait, last + wait);
 			bch2_kthread_io_clock_wait(clock, last + wait,
 					MAX_SCHEDULE_TIMEOUT);
@@ -355,14 +357,16 @@ static int bch2_copygc_thread(void *arg)
 		c->copygc_wait = 0;
 
 		c->copygc_running = true;
-		ret = bch2_copygc(trans, &ctxt, &buckets);
+		ret = bch2_copygc(trans, &ctxt, buckets);
 		c->copygc_running = false;
 
 		wake_up(&c->copygc_running_wq);
 	}
 
-	move_buckets_wait(trans, &ctxt, &buckets, true);
-	rhashtable_destroy(&buckets.table);
+	move_buckets_wait(trans, &ctxt, buckets, true);
+
+	rhashtable_destroy(&buckets->table);
+	kfree(buckets);
 	bch2_trans_put(trans);
 	bch2_moving_ctxt_exit(&ctxt);

