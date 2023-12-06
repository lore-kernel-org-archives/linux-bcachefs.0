Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vKmWcaYw"
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [IPv6:2001:41d0:203:375::aa])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3ED3
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:23 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucfP8VhXo0FnRII3YD2SjyyldYA9vdOfWhC7e2pYxaA=;
	b=vKmWcaYwogfrR9AXPtXpX61CG+mMdjszD+mpil4CtJ3+gxhOvzycHI1KRRRppusDm3rrmH
	aC9HtE6RUtZ5s5GM0QFTN7WWjRkjKTUEuorQsreCBG9It3QF4JmPwLRyi6wrNAakvKVdhz
	51fGeSzDMEM+QZYQlqsqGIDV84wXPyE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 1/6] bcachefs: thread_with_file
Date: Wed,  6 Dec 2023 15:33:05 -0500
Message-ID: <20231206203313.2197302-2-kent.overstreet@linux.dev>
In-Reply-To: <20231206203313.2197302-1-kent.overstreet@linux.dev>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Abstract out a new helper from the data job code, for connecting a
kthread to a file descriptor.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/chardev.c | 113 ++++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 44 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index ba0436ae6b05..8e3ac2d32298 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -29,6 +29,61 @@ static int copy_to_user_errcode(void __user *to, const void *from, unsigned long
 	return copy_to_user(to, from, n) ? -EFAULT : 0;
 }
 
+struct thread_with_file {
+	struct task_struct	*task;
+	int			ret;
+};
+
+static void thread_with_file_exit(struct thread_with_file *thr)
+{
+	kthread_stop(thr->task);
+	put_task_struct(thr->task);
+}
+
+static int run_thread_with_file(struct thread_with_file *thr,
+				const struct file_operations *fops,
+				int (*fn)(void *), const char *fmt, ...)
+{
+	va_list args;
+	struct file *file = NULL;
+	int ret, fd = -1;
+	struct printbuf name = PRINTBUF;
+	unsigned fd_flags = O_RDONLY|O_CLOEXEC|O_NONBLOCK;
+
+	va_start(args, fmt);
+	prt_vprintf(&name, fmt, args);
+	va_end(args);
+
+	thr->ret = 0;
+	thr->task = kthread_create(fn, thr, name.buf);
+	ret = PTR_ERR_OR_ZERO(thr->task);
+	if (ret)
+		goto err;
+
+	ret = get_unused_fd_flags(fd_flags);
+	if (ret < 0)
+		goto err_stop_task;
+	fd = ret;
+
+	file = anon_inode_getfile(name.buf, fops, thr, fd_flags);
+	ret = PTR_ERR_OR_ZERO(file);
+	if (ret)
+		goto err_put_fd;
+
+	fd_install(fd, file);
+	get_task_struct(thr->task);
+	wake_up_process(thr->task);
+	printbuf_exit(&name);
+	return fd;
+err_put_fd:
+	put_unused_fd(fd);
+err_stop_task:
+	kthread_stop(thr->task);
+err:
+	printbuf_exit(&name);
+	return ret;
+}
+
 /* returns with ref on ca->ref */
 static struct bch_dev *bch2_device_lookup(struct bch_fs *c, u64 dev,
 					  unsigned flags)
@@ -299,31 +354,27 @@ static long bch2_ioctl_disk_set_state(struct bch_fs *c,
 }
 
 struct bch_data_ctx {
+	struct thread_with_file		thr;
+
 	struct bch_fs			*c;
 	struct bch_ioctl_data		arg;
 	struct bch_move_stats		stats;
-
-	int				ret;
-
-	struct task_struct		*thread;
 };
 
 static int bch2_data_thread(void *arg)
 {
-	struct bch_data_ctx *ctx = arg;
-
-	ctx->ret = bch2_data_job(ctx->c, &ctx->stats, ctx->arg);
+	struct bch_data_ctx *ctx = container_of(arg, struct bch_data_ctx, thr);
 
+	ctx->thr.ret = bch2_data_job(ctx->c, &ctx->stats, ctx->arg);
 	ctx->stats.data_type = U8_MAX;
 	return 0;
 }
 
 static int bch2_data_job_release(struct inode *inode, struct file *file)
 {
-	struct bch_data_ctx *ctx = file->private_data;
+	struct bch_data_ctx *ctx = container_of(file->private_data, struct bch_data_ctx, thr);
 
-	kthread_stop(ctx->thread);
-	put_task_struct(ctx->thread);
+	thread_with_file_exit(&ctx->thr);
 	kfree(ctx);
 	return 0;
 }
@@ -331,7 +382,7 @@ static int bch2_data_job_release(struct inode *inode, struct file *file)
 static ssize_t bch2_data_job_read(struct file *file, char __user *buf,
 				  size_t len, loff_t *ppos)
 {
-	struct bch_data_ctx *ctx = file->private_data;
+	struct bch_data_ctx *ctx = container_of(file->private_data, struct bch_data_ctx, thr);
 	struct bch_fs *c = ctx->c;
 	struct bch_ioctl_data_event e = {
 		.type			= BCH_DATA_EVENT_PROGRESS,
@@ -357,10 +408,8 @@ static const struct file_operations bcachefs_data_ops = {
 static long bch2_ioctl_data(struct bch_fs *c,
 			    struct bch_ioctl_data arg)
 {
-	struct bch_data_ctx *ctx = NULL;
-	struct file *file = NULL;
-	unsigned flags = O_RDONLY|O_CLOEXEC|O_NONBLOCK;
-	int ret, fd = -1;
+	struct bch_data_ctx *ctx;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -375,36 +424,12 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	ctx->c = c;
 	ctx->arg = arg;
 
-	ctx->thread = kthread_create(bch2_data_thread, ctx,
-				     "bch-data/%s", c->name);
-	if (IS_ERR(ctx->thread)) {
-		ret = PTR_ERR(ctx->thread);
-		goto err;
-	}
-
-	ret = get_unused_fd_flags(flags);
+	ret = run_thread_with_file(&ctx->thr,
+				   &bcachefs_data_ops,
+				   bch2_data_thread,
+				   "bch-data/%s", c->name);
 	if (ret < 0)
-		goto err;
-	fd = ret;
-
-	file = anon_inode_getfile("[bcachefs]", &bcachefs_data_ops, ctx, flags);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
-		goto err;
-	}
-
-	fd_install(fd, file);
-
-	get_task_struct(ctx->thread);
-	wake_up_process(ctx->thread);
-
-	return fd;
-err:
-	if (fd >= 0)
-		put_unused_fd(fd);
-	if (!IS_ERR_OR_NULL(ctx->thread))
-		kthread_stop(ctx->thread);
-	kfree(ctx);
+		kfree(ctx);
 	return ret;
 }
 
-- 
2.42.0

