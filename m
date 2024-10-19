Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A54C155398
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729374977; cv=none; b=j5rmmsi5/HQ0HO3lfuyobHL5MUHsICpwJ/pkmgyDaQupemMWE+EfGyZN9lWNIdSXa81Fr6GEopnhil+FhfOxPZeyy5bMyuM0f/TPSbF3CO2p5+OANoiJYijwDRjxnMF++OS3Pt90jiJz07BRLbMNeL1HmVUBUiyytxu6hJiN4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729374977; c=relaxed/simple;
	bh=xCxZztCU4eXI62lhtWUIP/IR6QC26J++n6R7w/i05Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TEOTBLxDhjKkx7wAcMgckM49G5A6PXq7Rl3Z4ynU041iqc9huO8VkGhexTj79r9dwQBB2wgn7fDALr8gTJOEX3ZIuz6qlNNHrGFW+4wNxjTuFZkaRCdQRdOkuBZsVif0CZ3DSUux0KjBRnWrQ7PrraOfCnGR9FWEIvFFO6LVzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sIVEXHVI; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sIVEXHVI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729374972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vw/dWYdj63oxurJRaessr2E6Ryl8bzt9lx93zHeP/5o=;
	b=sIVEXHVIvsDxwcHNm6RpETiTcBDzorZ0F7IK0jL+QqTt2lIioN0V/O0PPwkz4ThZyxnbfh
	SbDyNshOHmvtQgWk9cz/uqCj2I/q7vije04G46ExAPOJnfZGkq0p3AUYdiTRoi9mG336WP
	uriV2vXbbmHQ2ihFxdBJ6U6cz2ENqdI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Allocator now directly wakes up copygc when necessary
Date: Sat, 19 Oct 2024 17:56:05 -0400
Message-ID: <20241019215605.160125-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

copygc tries to wait in a way that balances waiting for work to
accumulate with running before we run out of free space - but for a
variety of reasons (multiple devices, io clock slop, the vagaries of
fragmentation) this isn't completely reliable.

So to avoid getting stuck, add direct wakeups from the allocator to the
copygc thread when we start to notice we're low on free buckets.

Reported-by: syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c |  8 ++++++++
 fs/bcachefs/bcachefs.h         |  2 +-
 fs/bcachefs/movinggc.c         | 22 +++++++++++-----------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 5836870ab882..c7848672796d 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -822,6 +822,14 @@ int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
 		}
 	}
 
+	if (bch2_err_matches(ret, BCH_ERR_freelist_empty)) {
+		rcu_read_lock();
+		struct task_struct *t = rcu_dereference(c->copygc_thread);
+		if (t)
+			wake_up_process(t);
+		rcu_read_unlock();
+	}
+
 	return ret;
 }
 
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index f4151ee51b03..7cc81fbc4c3a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -986,7 +986,7 @@ struct bch_fs {
 	struct bch_fs_rebalance	rebalance;
 
 	/* COPYGC */
-	struct task_struct	*copygc_thread;
+	struct task_struct __rcu *copygc_thread;
 	struct write_point	copygc_write_point;
 	s64			copygc_wait_at;
 	s64			copygc_wait;
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index d658be90f737..80b18b4b04b7 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -363,19 +363,18 @@ static int bch2_copygc_thread(void *arg)
 		}
 
 		last = atomic64_read(&clock->now);
-		wait = bch2_copygc_wait_amount(c);
+		wait = max_t(long, 0, bch2_copygc_wait_amount(c) - clock->max_slop);
 
-		if (wait > clock->max_slop) {
+		if (wait > 0) {
 			c->copygc_wait_at = last;
 			c->copygc_wait = last + wait;
 			move_buckets_wait(&ctxt, buckets, true);
-			trace_and_count(c, copygc_wait, c, wait, last + wait);
-			bch2_kthread_io_clock_wait(clock, last + wait,
-					MAX_SCHEDULE_TIMEOUT);
+			trace_and_count(c, copygc_wait, c, wait, c->copygc_wait);
+			bch2_io_clock_schedule_timeout(clock, c->copygc_wait);
 			continue;
 		}
 
-		c->copygc_wait = 0;
+		c->copygc_wait = c->copygc_wait_at = 0;
 
 		c->copygc_running = true;
 		ret = bch2_copygc(&ctxt, buckets, &did_work);
@@ -407,9 +406,10 @@ static int bch2_copygc_thread(void *arg)
 
 void bch2_copygc_stop(struct bch_fs *c)
 {
-	if (c->copygc_thread) {
-		kthread_stop(c->copygc_thread);
-		put_task_struct(c->copygc_thread);
+	struct task_struct *t = rcu_dereference_protected(c->copygc_thread, true);
+	if (t) {
+		kthread_stop(t);
+		put_task_struct(t);
 	}
 	c->copygc_thread = NULL;
 }
@@ -436,8 +436,8 @@ int bch2_copygc_start(struct bch_fs *c)
 
 	get_task_struct(t);
 
-	c->copygc_thread = t;
-	wake_up_process(c->copygc_thread);
+	rcu_assign_pointer(c->copygc_thread, t);
+	wake_up_process(t);
 
 	return 0;
 }
-- 
2.45.2

