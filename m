Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C0WuD3GL"
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [IPv6:2001:41d0:203:375::ba])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CB18F
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:26 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AKYKyQS+swCYRPoEhHHstTPz9C3lBo78d482K5huzFo=;
	b=C0WuD3GLBKHdHBSqln1jv1ifU0ZFBSSqYzWLf0TecK0VrRZP+JQ54jcFcG9pUD1mt5mJfP
	3VsADmCAGfk0oRoTKqnom2QQ2hCZmOQ3cBKG0iJxKXjldGOi6nTLxpSXUgqwIhgwJZIukE
	2fw0lufmDFc/0wbWeQHE7YFGwVfJE0o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 6/6] bcachefs: BCH_IOCTL_FSCK_ONLINE
Date: Wed,  6 Dec 2023 15:33:10 -0500
Message-ID: <20231206203313.2197302-7-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h | 11 +++++++
 fs/bcachefs/chardev.c        | 61 +++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 07c490851742..2ac6272c8ef5 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -85,6 +85,8 @@ struct bch_ioctl_incremental {
 
 #define BCH_IOCTL_FSCK_OFFLINE		_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
 
+#define BCH_IOCTL_FSCK_ONLINE		_IOW(0xbc,	20,  struct bch_ioctl_fsck_online)
+
 /* ioctl below act on a particular file, not the filesystem as a whole: */
 
 #define BCHFS_IOC_REINHERIT_ATTRS	_IOR(0xbc, 64, const char __user *)
@@ -399,4 +401,13 @@ struct bch_ioctl_fsck_offline {
 	__u64			devs[0];
 };
 
+/*
+ * BCH_IOCTL_FSCK_ONLINE: run fsck from the 'bcachefs fsck' userspace command,
+ * but with the kernel's implementation of fsck:
+ */
+struct bch_ioctl_fsck_online {
+	__u64			flags;
+	__u64			opts;		/* string */
+};
+
 #endif /* _BCACHEFS_IOCTL_H */
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 03082a001036..c572f3b7aa1f 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -7,6 +7,7 @@
 #include "chardev.h"
 #include "journal.h"
 #include "move.h"
+#include "recovery.h"
 #include "replicas.h"
 #include "super.h"
 #include "super-io.h"
@@ -199,6 +200,7 @@ static long bch2_ioctl_incremental(struct bch_ioctl_incremental __user *user_arg
 struct fsck_thread {
 	struct thread_with_file	thr;
 	struct printbuf		buf;
+	struct bch_fs		*c;
 	char			**devs;
 	size_t			nr_devs;
 	struct bch_opts		opts;
@@ -915,6 +917,62 @@ static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
 	return ret;
 }
 
+static int bch2_fsck_online_thread_fn(void *arg)
+{
+	struct fsck_thread *thr = container_of(arg, struct fsck_thread, thr);
+	struct bch_fs *c = thr->c;
+
+	c->output_filter = current;
+	c->output = &thr->output;
+
+	c->opts.fsck = true;
+	c->curr_recovery_pass = BCH_RECOVERY_PASS_check_alloc_info;
+	bch2_run_online_recovery_passes(c);
+
+	c->output = NULL;
+	c->output_filter = NULL;
+
+	thr->thr.done = true;
+	wake_up(&thr->output.wait);
+	return 0;
+}
+
+static long bch2_ioctl_fsck_online(struct bch_fs *c,
+				   struct bch_ioctl_fsck_online arg)
+{
+	struct fsck_thread *thr = NULL;
+	long ret = 0;
+
+	/* XXX what refcount are we taking on the filesystem? */
+
+	if (arg.flags)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	thr = kzalloc(sizeof(*thr), GFP_KERNEL);
+	if (!thr)
+		return -ENOMEM;
+
+	thr->c = c;
+	thr->output.buf	= PRINTBUF;
+	thr->output.buf.atomic++;
+	spin_lock_init(&thr->output.lock);
+	init_waitqueue_head(&thr->output.wait);
+	darray_init(&thr->output2);
+
+	ret = run_thread_with_file(&thr->thr,
+				   &fsck_thread_ops,
+				   bch2_fsck_online_thread_fn,
+				   "bch-fsck");
+	if (ret < 0) {
+		bch_err_fn(c, ret);
+		bch2_fsck_thread_free(thr);
+	}
+	return ret;
+}
+
 #define BCH_IOCTL(_name, _argtype)					\
 do {									\
 	_argtype i;							\
@@ -970,7 +1028,8 @@ long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
 		BCH_IOCTL(disk_resize, struct bch_ioctl_disk_resize);
 	case BCH_IOCTL_DISK_RESIZE_JOURNAL:
 		BCH_IOCTL(disk_resize_journal, struct bch_ioctl_disk_resize_journal);
-
+	case BCH_IOCTL_FSCK_ONLINE:
+		BCH_IOCTL(fsck_online, struct bch_ioctl_fsck_online);
 	default:
 		return -ENOTTY;
 	}
-- 
2.42.0

