Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jQ7o2aMf"
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [IPv6:2001:41d0:203:375::bb])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B373A5
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:23 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=er1FU0yFUQ2/c6jCAgtI4iAWVBq+lPLvCjIPJBbrjzk=;
	b=jQ7o2aMf0P+yyiERCV2Ey+4LQggTVPVj+UKLNIUXgzVQgIBjwybKUd1QEIlLXJUTwtB6n2
	l7alxx28R6lNB34EidVzxCD8dDcp9yCGWnS5Y3zOMdpaFrF84y1vM52MeTODx9me8G7and
	8vd5m2mzV2qFtY5lefDdPTWQaOP9Boo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 2/6] bcachefs: Add ability to redirect log output
Date: Wed,  6 Dec 2023 15:33:06 -0500
Message-ID: <20231206203313.2197302-3-kent.overstreet@linux.dev>
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

Upcoming patches are going to add two new ioctls for running fsck in the
kernel, but pretending that we're running our normal userspace fsck.

This patch adds some plumbing for redirecting our normal log messages
away from the dmesg log to a thread_with_file file descriptor - via a
struct log_output, which will be consumed by the fsck f_op's read method.

The new ioctls will allow for running fsck in the kernel against an
offline filesystem (without mounting it), and an online filesystem. For
an offline filesystem we need a way to pass in a pointer to the
log_output, which is done via a new hidden opts.h option.

For online fsck, we can set c->output directly, but only want to
redirect log messages from the thread running fsck - hence the new
c->output_filter method.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h | 54 +++++++++++++++++++++++++++++++-----------
 fs/bcachefs/opts.h     |  5 ++++
 fs/bcachefs/super.c    | 28 ++++++++++++++++++++++
 3 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index bb2a0cc43f83..4689a6d6233b 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -264,36 +264,54 @@ do {									\
 
 #define bch2_fmt(_c, fmt)		bch2_log_msg(_c, fmt "\n")
 
+void __bch2_print(struct bch_fs *c, const char *fmt, ...);
+
+#define maybe_dev_to_fs(_c)	_Generic((_c),				\
+	struct bch_dev *:	((struct bch_dev *) (_c))->fs,		\
+	struct bch_fs *:	(_c))
+
+#define bch2_print(_c, ...) __bch2_print(maybe_dev_to_fs(_c), __VA_ARGS__)
+
+#define bch2_print_ratelimited(_c, ...)					\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+									\
+	if (__ratelimit(&_rs))						\
+		bch2_print(_c, __VA_ARGS__);				\
+} while (0)
+
 #define bch_info(c, fmt, ...) \
-	printk(KERN_INFO bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_INFO bch2_fmt(c, fmt), ##__VA_ARGS__)
 #define bch_notice(c, fmt, ...) \
-	printk(KERN_NOTICE bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_NOTICE bch2_fmt(c, fmt), ##__VA_ARGS__)
 #define bch_warn(c, fmt, ...) \
-	printk(KERN_WARNING bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_WARNING bch2_fmt(c, fmt), ##__VA_ARGS__)
 #define bch_warn_ratelimited(c, fmt, ...) \
-	printk_ratelimited(KERN_WARNING bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(c, KERN_WARNING bch2_fmt(c, fmt), ##__VA_ARGS__)
 
 #define bch_err(c, fmt, ...) \
-	printk(KERN_ERR bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_ERR bch2_fmt(c, fmt), ##__VA_ARGS__)
 #define bch_err_dev(ca, fmt, ...) \
-	printk(KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
 #define bch_err_dev_offset(ca, _offset, fmt, ...) \
-	printk(KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
 #define bch_err_inum(c, _inum, fmt, ...) \
-	printk(KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
 #define bch_err_inum_offset(c, _inum, _offset, fmt, ...) \
-	printk(KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
+	bch2_print(c, KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
 
 #define bch_err_ratelimited(c, fmt, ...) \
-	printk_ratelimited(KERN_ERR bch2_fmt(c, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(c, KERN_ERR bch2_fmt(c, fmt), ##__VA_ARGS__)
 #define bch_err_dev_ratelimited(ca, fmt, ...) \
-	printk_ratelimited(KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(ca, KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
 #define bch_err_dev_offset_ratelimited(ca, _offset, fmt, ...) \
-	printk_ratelimited(KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(ca, KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
 #define bch_err_inum_ratelimited(c, _inum, fmt, ...) \
-	printk_ratelimited(KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(c, KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
 #define bch_err_inum_offset_ratelimited(c, _inum, _offset, fmt, ...) \
-	printk_ratelimited(KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
+	bch2_print_ratelimited(c, KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
 
 #define bch_err_fn(_c, _ret)						\
 do {									\
@@ -446,6 +464,12 @@ enum bch_time_stats {
 
 struct btree;
 
+struct log_output {
+	spinlock_t		lock;
+	wait_queue_head_t	wait;
+	struct printbuf		buf;
+};
+
 enum gc_phase {
 	GC_PHASE_NOT_RUNNING,
 	GC_PHASE_START,
@@ -700,6 +724,8 @@ struct bch_fs {
 	struct super_block	*vfs_sb;
 	dev_t			dev;
 	char			name[40];
+	struct log_output	*output;
+	struct task_struct	*output_filter;
 
 	/* ro/rw, add/remove/resize devices: */
 	struct rw_semaphore	state_lock;
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 8526f177450a..91026dfb8c83 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -419,6 +419,11 @@ enum fsck_err_opts {
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		"Allocate the buckets_nouse bitmap")		\
+	x(log_output,			u64,				\
+	  0,								\
+	  OPT_UINT(0, S64_MAX),						\
+	  BCH2_NO_SB_OPT,		false,				\
+	  NULL,		"Allocate the buckets_nouse bitmap")		\
 	x(project,			u8,				\
 	  OPT_INODE,							\
 	  OPT_BOOL(),							\
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index e7f186b45df1..6c320defd593 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -80,6 +80,32 @@ const char * const bch2_fs_flag_strs[] = {
 	NULL
 };
 
+void __bch2_print(struct bch_fs *c, const char *fmt, ...)
+{
+	struct log_output *output = c->output;
+	va_list args;
+
+	if (c->output_filter && c->output_filter != current)
+		output = NULL;
+
+	va_start(args, fmt);
+	if (likely(!output)) {
+		vprintk(fmt, args);
+	} else {
+		unsigned long flags;
+
+		if (fmt[0] == KERN_SOH[0])
+			fmt += 2;
+
+		spin_lock_irqsave(&output->lock, flags);
+		prt_vprintf(&output->buf, fmt, args);
+		spin_unlock_irqrestore(&output->lock, flags);
+
+		wake_up(&output->wait);
+	}
+	va_end(args);
+}
+
 #define KTYPE(type)							\
 static const struct attribute_group type ## _group = {			\
 	.attrs = type ## _files						\
@@ -703,6 +729,8 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 		goto out;
 	}
 
+	c->output = (void *)(unsigned long) opts.log_output;
+
 	__module_get(THIS_MODULE);
 
 	closure_init(&c->cl, NULL);
-- 
2.42.0

