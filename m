Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03301135A7E
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 20:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100142; cv=none; b=P5Y9qjWXRi67bOXktsuGnp4jfoBeXdyAKB7t+eI+y/FSIRruDhYWb0w8LjziXGrGmxLzqGQ9r9IRqWlzgYGOptVYf5ifmvZzUsRfTTuOp59mIAWa29qxyDDCMubTEZZcZgeLUVeSTmcKo8uq94Lc9C8C1Yevk8RYJEPonFfGrVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100142; c=relaxed/simple;
	bh=qSJL0zVUMqNK7hKY38GyIDZjRnZFpGHD3ItE0jZAaaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koMWw/T2BRvxOqxEM2AhG/HtKoqsNqOLTwk0DtCjChsBjqhhMYCSZc6RX6JyAiLzT5k4KiREhAWNOzLjrTeyBC5qVY4LiT/w/DFJC0cVwVDkMMtHLs3NJT6UoRytK2WtYPQb0PK8YdKVQJPTHEU8tamw3pL28OTyhKvVXH5XRtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n4OzSZuH; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n4OzSZuH"
X-Envelope-To: linux-bcachefs@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717100138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXmt6LcF6ZwACOIupXpRVgxRDfThLdJ5HGu8KlIKQog=;
	b=n4OzSZuHytn5uxaw2a7JF67INAXheKoVYvh4hui5oA22uwLGDbev91xE5yxbC466HjkeLr
	romC111YYgKaeOVWNO4c5h1439eBmvVekFF7rtlL4CMJ30knJkzXpuY+ba4sYAfyKGtQd6
	gVBhVHdsO6tbkOvAd/i0qeCIt+kVVWE=
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: kent.overstreet@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: axboe@kernel.dk,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: twf: Switch to create_io_thread()
Date: Thu, 30 May 2024 16:15:28 -0400
Message-ID: <20240530201528.426768-2-kent.overstreet@linux.dev>
In-Reply-To: <20240530201528.426768-1-kent.overstreet@linux.dev>
References: <20240530201528.426768-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

create_io_thread() is more appropriate than kthread_create() when
spinning up a thread to do work asynchronously on behalf of some
specific userspace task.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/chardev.c          |  3 +--
 fs/bcachefs/thread_with_file.c | 29 +++++++++++++++++++----------
 fs/bcachefs/thread_with_file.h |  3 ++-
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index fbb2b95e0f5c..9be0744cb19a 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -441,13 +441,12 @@ struct bch_data_ctx {
 	struct bch_move_stats		stats;
 };
 
-static int bch2_data_thread(void *arg)
+static void bch2_data_thread(void *arg)
 {
 	struct bch_data_ctx *ctx = container_of(arg, struct bch_data_ctx, thr);
 
 	ctx->thr.ret = bch2_data_job(ctx->c, &ctx->stats, ctx->arg);
 	ctx->stats.data_type = U8_MAX;
-	return 0;
 }
 
 static int bch2_data_job_release(struct inode *inode, struct file *file)
diff --git a/fs/bcachefs/thread_with_file.c b/fs/bcachefs/thread_with_file.c
index 075567016db5..a37d45a69328 100644
--- a/fs/bcachefs/thread_with_file.c
+++ b/fs/bcachefs/thread_with_file.c
@@ -13,15 +13,21 @@
 
 void bch2_thread_with_file_exit(struct thread_with_file *thr)
 {
-	if (thr->task) {
-		kthread_stop(thr->task);
+	if (thr->task)
 		put_task_struct(thr->task);
-	}
+}
+
+static int thr_with_file_fn(void *p)
+{
+	struct thread_with_file *thr = p;
+
+	thr->fn(thr);
+	do_exit(0);
 }
 
 int bch2_run_thread_with_file(struct thread_with_file *thr,
 			      const struct file_operations *fops,
-			      int (*fn)(void *))
+			      void (*fn)(void *))
 {
 	struct file *file = NULL;
 	int ret, fd = -1;
@@ -38,11 +44,15 @@ int bch2_run_thread_with_file(struct thread_with_file *thr,
 	get_task_comm(name, current);
 
 	thr->ret = 0;
-	thr->task = kthread_create(fn, thr, "%s", name);
+	thr->fn = fn;
+	thr->task = create_io_thread(thr_with_file_fn, thr, NUMA_NO_NODE);
 	ret = PTR_ERR_OR_ZERO(thr->task);
 	if (ret)
 		return ret;
 
+	set_task_comm(thr->task, name);
+	set_cpus_allowed_ptr(thr->task, cpu_possible_mask);
+
 	ret = get_unused_fd_flags(fd_flags);
 	if (ret < 0)
 		goto err;
@@ -54,14 +64,15 @@ int bch2_run_thread_with_file(struct thread_with_file *thr,
 		goto err;
 
 	get_task_struct(thr->task);
-	wake_up_process(thr->task);
+	wake_up_new_task(thr->task);
 	fd_install(fd, file);
+
 	return fd;
 err:
 	if (fd >= 0)
 		put_unused_fd(fd);
 	if (thr->task)
-		kthread_stop(thr->task);
+		put_task_struct(thr->task);
 	return ret;
 }
 
@@ -293,14 +304,12 @@ static const struct file_operations thread_with_stdout_fops = {
 	.unlocked_ioctl	= thread_with_stdio_ioctl,
 };
 
-static int thread_with_stdio_fn(void *arg)
+static void thread_with_stdio_fn(void *arg)
 {
 	struct thread_with_stdio *thr = arg;
 
 	thr->thr.ret = thr->ops->fn(thr);
-
 	thread_with_stdio_done(thr);
-	return 0;
 }
 
 void bch2_thread_with_stdio_init(struct thread_with_stdio *thr,
diff --git a/fs/bcachefs/thread_with_file.h b/fs/bcachefs/thread_with_file.h
index 72497b921911..d1aacc894ef9 100644
--- a/fs/bcachefs/thread_with_file.h
+++ b/fs/bcachefs/thread_with_file.h
@@ -40,6 +40,7 @@ struct task_struct;
 
 struct thread_with_file {
 	struct task_struct	*task;
+	void			(*fn)(void *);
 	int			ret;
 	bool			done;
 };
@@ -47,7 +48,7 @@ struct thread_with_file {
 void bch2_thread_with_file_exit(struct thread_with_file *);
 int bch2_run_thread_with_file(struct thread_with_file *,
 			      const struct file_operations *,
-			      int (*fn)(void *));
+			      void (*fn)(void *));
 
 struct thread_with_stdio;
 
-- 
2.45.1

