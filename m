Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UHAAOeI3"
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [IPv6:2001:41d0:203:375::ad])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0D5181
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:25 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+U0UW+vwLyjFPPI7GY90kQ7Z51EkASQaCBPvm8yknM=;
	b=UHAAOeI3re8h1PVUGYAk/SPbHnaq48EdOsoobN+o/l2k6Teyd804/3mtWcNDXdiNefVH30
	GAoJ2PpmxDfVblZiOEfWrrSuTf5wNcyHsAjc1mIN3Z7pZdyNYk2/ez0WNRuJEa+kMbSvPy
	N1kWvt5KN2UU2nrwnk/mr5EIjQQ6B/M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 5/6] bcachefs: BCH_IOCTL_FSCK_OFFLINE
Date: Wed,  6 Dec 2023 15:33:09 -0500
Message-ID: <20231206203313.2197302-6-kent.overstreet@linux.dev>
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

This adds a new ioctl for running fsck on a list of devices.

Normally, if we wish to use the kernel's implementation of fsck we'd run
it at mount time with -o fsck. This ioctl lets us run fsck without
mounting, so that userspace bcachefs-tools can transparently switch to
the kernel's implementation of fsck when appropriate - primarily if the
kernel version of bcachefs better matches the filesystem on disk.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h |  13 +++
 fs/bcachefs/chardev.c        | 206 ++++++++++++++++++++++++++++++++++-
 fs/bcachefs/recovery.c       |   6 +-
 3 files changed, 219 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 43822c17297c..07c490851742 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -83,6 +83,8 @@ struct bch_ioctl_incremental {
 
 #define BCH_IOCTL_DEV_USAGE_V2	_IOWR(0xbc,	18, struct bch_ioctl_dev_usage_v2)
 
+#define BCH_IOCTL_FSCK_OFFLINE		_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
+
 /* ioctl below act on a particular file, not the filesystem as a whole: */
 
 #define BCHFS_IOC_REINHERIT_ATTRS	_IOR(0xbc, 64, const char __user *)
@@ -386,4 +388,15 @@ struct bch_ioctl_subvolume {
 #define BCH_SUBVOL_SNAPSHOT_CREATE	(1U << 0)
 #define BCH_SUBVOL_SNAPSHOT_RO		(1U << 1)
 
+/*
+ * BCH_IOCTL_FSCK_OFFLINE: run fsck from the 'bcachefs fsck' userspace command,
+ * but with the kernel's implementation of fsck:
+ */
+struct bch_ioctl_fsck_offline {
+	__u64			flags;
+	__u64			opts;		/* string */
+	__u64			nr_devs;
+	__u64			devs[0];
+};
+
 #endif /* _BCACHEFS_IOCTL_H */
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 8e3ac2d32298..03082a001036 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -32,12 +32,15 @@ static int copy_to_user_errcode(void __user *to, const void *from, unsigned long
 struct thread_with_file {
 	struct task_struct	*task;
 	int			ret;
+	bool			done;
 };
 
 static void thread_with_file_exit(struct thread_with_file *thr)
 {
-	kthread_stop(thr->task);
-	put_task_struct(thr->task);
+	if (thr->task) {
+		kthread_stop(thr->task);
+		put_task_struct(thr->task);
+	}
 }
 
 static int run_thread_with_file(struct thread_with_file *thr,
@@ -193,8 +196,196 @@ static long bch2_ioctl_incremental(struct bch_ioctl_incremental __user *user_arg
 }
 #endif
 
+struct fsck_thread {
+	struct thread_with_file	thr;
+	struct printbuf		buf;
+	char			**devs;
+	size_t			nr_devs;
+	struct bch_opts		opts;
+
+	struct log_output	output;
+	DARRAY(char)		output2;
+};
+
+static void bch2_fsck_thread_free(struct fsck_thread *thr)
+{
+	thread_with_file_exit(&thr->thr);
+	if (thr->devs)
+		for (size_t i = 0; i < thr->nr_devs; i++)
+			kfree(thr->devs[i]);
+	darray_exit(&thr->output2);
+	printbuf_exit(&thr->output.buf);
+	kfree(thr->devs);
+	kfree(thr);
+}
+
+static int bch2_fsck_thread_release(struct inode *inode, struct file *file)
+{
+	struct fsck_thread *thr = container_of(file->private_data, struct fsck_thread, thr);
+
+	bch2_fsck_thread_free(thr);
+	return 0;
+}
+
+static bool fsck_thread_ready(struct fsck_thread *thr)
+{
+	return thr->output.buf.pos ||
+		thr->output2.nr ||
+		thr->thr.done;
+}
+
+static ssize_t bch2_fsck_thread_read(struct file *file, char __user *buf,
+				     size_t len, loff_t *ppos)
+{
+	struct fsck_thread *thr = container_of(file->private_data, struct fsck_thread, thr);
+	size_t copied = 0, b;
+	int ret = 0;
+
+	if ((file->f_flags & O_NONBLOCK) &&
+	    !fsck_thread_ready(thr))
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(thr->output.wait,
+			fsck_thread_ready(thr));
+	if (ret)
+		return ret;
+
+	if (thr->thr.done)
+		return 0;
+
+	while (len) {
+		ret = darray_make_room(&thr->output2, thr->output.buf.pos);
+		if (ret)
+			break;
+
+		spin_lock_irq(&thr->output.lock);
+		b = min_t(size_t, darray_room(thr->output2), thr->output.buf.pos);
+
+		memcpy(&darray_top(thr->output2), thr->output.buf.buf, b);
+		memmove(thr->output.buf.buf,
+			thr->output.buf.buf + b,
+			thr->output.buf.pos - b);
+
+		thr->output2.nr += b;
+		thr->output.buf.pos -= b;
+		spin_unlock_irq(&thr->output.lock);
+
+		b = min(len, thr->output2.nr);
+		if (!b)
+			break;
+
+		b -= copy_to_user(buf, thr->output2.data, b);
+		if (!b) {
+			ret = -EFAULT;
+			break;
+		}
+
+		copied	+= b;
+		buf	+= b;
+		len	-= b;
+
+		memmove(thr->output2.data,
+			thr->output2.data + b,
+			thr->output2.nr - b);
+		thr->output2.nr -= b;
+	}
+
+	return copied ?: ret;
+}
+
+static const struct file_operations fsck_thread_ops = {
+	.release	= bch2_fsck_thread_release,
+	.read		= bch2_fsck_thread_read,
+	.llseek		= no_llseek,
+};
+
+static int bch2_fsck_offline_thread_fn(void *arg)
+{
+	struct fsck_thread *thr = container_of(arg, struct fsck_thread, thr);
+	struct bch_fs *c = bch2_fs_open(thr->devs, thr->nr_devs, thr->opts);
+
+	thr->thr.ret = PTR_ERR_OR_ZERO(c);
+	if (!thr->thr.ret)
+		bch2_fs_stop(c);
+
+	thr->thr.done = true;
+	wake_up(&thr->output.wait);
+	return 0;
+}
+
+static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_arg)
+{
+	struct bch_ioctl_fsck_offline arg;
+	struct fsck_thread *thr = NULL;
+	u64 *devs = NULL;
+	long ret = 0;
+
+	if (copy_from_user(&arg, user_arg, sizeof(arg)))
+		return -EFAULT;
+
+	if (arg.flags)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!(devs = kcalloc(arg.nr_devs, sizeof(*devs), GFP_KERNEL)) ||
+	    !(thr = kzalloc(sizeof(*thr), GFP_KERNEL)) ||
+	    !(thr->devs = kcalloc(arg.nr_devs, sizeof(*thr->devs), GFP_KERNEL))) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	thr->nr_devs = arg.nr_devs;
+	thr->output.buf	= PRINTBUF;
+	thr->output.buf.atomic++;
+	spin_lock_init(&thr->output.lock);
+	init_waitqueue_head(&thr->output.wait);
+	darray_init(&thr->output2);
+
+	if (copy_from_user(devs, &user_arg->devs[0], sizeof(user_arg->devs[0]) * arg.nr_devs)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	for (size_t i = 0; i < arg.nr_devs; i++) {
+		thr->devs[i] = strndup_user((char __user *)(unsigned long) devs[i], PATH_MAX);
+		ret = PTR_ERR_OR_ZERO(thr->devs[i]);
+		if (ret)
+			goto err;
+	}
+
+	if (arg.opts) {
+		char *optstr = strndup_user((char __user *)(unsigned long) arg.opts, 1 << 16);
+
+		ret =   PTR_ERR_OR_ZERO(optstr) ?:
+			bch2_parse_mount_opts(NULL, &thr->opts, optstr);
+		kfree(optstr);
+
+		if (ret)
+			goto err;
+	}
+
+	opt_set(thr->opts, log_output, (u64)(unsigned long)&thr->output);
+
+	ret = run_thread_with_file(&thr->thr,
+				   &fsck_thread_ops,
+				   bch2_fsck_offline_thread_fn,
+				   "bch-fsck");
+err:
+	if (ret < 0) {
+		if (thr)
+			bch2_fsck_thread_free(thr);
+		pr_err("ret %s", bch2_err_str(ret));
+	}
+	kfree(devs);
+	return ret;
+}
+
 static long bch2_global_ioctl(unsigned cmd, void __user *arg)
 {
+	long ret;
+
 	switch (cmd) {
 #if 0
 	case BCH_IOCTL_ASSEMBLE:
@@ -202,9 +393,18 @@ static long bch2_global_ioctl(unsigned cmd, void __user *arg)
 	case BCH_IOCTL_INCREMENTAL:
 		return bch2_ioctl_incremental(arg);
 #endif
+	case BCH_IOCTL_FSCK_OFFLINE: {
+		ret = bch2_ioctl_fsck_offline(arg);
+		break;
+	}
 	default:
-		return -ENOTTY;
+		ret = -ENOTTY;
+		break;
 	}
+
+	if (ret < 0)
+		ret = bch2_err_class(ret);
+	return ret;
 }
 
 static long bch2_ioctl_query_uuid(struct bch_fs *c,
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 262c923b2f1a..2f5daecfbcf7 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -655,13 +655,13 @@ static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 	int ret;
 
 	if (!(p->when & PASS_SILENT))
-		printk(KERN_INFO bch2_log_msg(c, "%s..."),
-		       bch2_recovery_passes[pass]);
+		bch2_print(c, KERN_INFO bch2_log_msg(c, "%s..."),
+			   bch2_recovery_passes[pass]);
 	ret = p->fn(c);
 	if (ret)
 		return ret;
 	if (!(p->when & PASS_SILENT))
-		printk(KERN_CONT " done\n");
+		bch2_print(c, KERN_CONT " done\n");
 
 	return 0;
 }
-- 
2.42.0

