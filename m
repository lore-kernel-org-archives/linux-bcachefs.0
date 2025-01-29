Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A49187325
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738183808; cv=none; b=cfGIsyV+yYSzIIdvzpN44Ww9I5RuxNTICGepq5YS9H15bMgyC4j5dA9zcrbkHsOZL6UkuOyRVGwSkvGcHiv9gTcLb3dRNTtr/gnet83+BGg8RzvzF7LhL026GI1ljhH0YbU4o/JLIdb20zAAoaJxwAf6UMiJLygEIFItW+IA36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738183808; c=relaxed/simple;
	bh=kqC4izlj26FpbCLnKimxz5eVH9oMnDnnVzlCdQUqFBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vEFC3xocLB/nUamnITqtpIaUy5hjvpGkXyd7LuJu8q+SN0qacILShTx99Q8hnlb5nlIgJtz4hMxWjoTmugnT6wN3c5zvDwokh3csR3QWSdcFZWIN1pf6GKc4lQM9dS0oRNGMjlKbJhkq/5u/tpwVIQYz+p42Q3t4vFtTi0N20Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RJulemrB; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RJulemrB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738183798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LgqFwji85YwnYCP4LsWDflMB704w9RDgxjoKumv8aOY=;
	b=RJulemrBXWFGzGO74h2jdJmTo1doeZcCgb+DNENjE4a/3wmC2Mf5LjvDUzTSfQOCyfZqx5
	KvWYFDwNJgNb5+KF2VXCQfb0yfgSLMZgzGJoR/+wJvceRU8pICero3yeQIcgMWmSq//iKS
	WnaNxqyDNyCXklz5vOceiCz2kwzodfQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: BCH_IOCTL_QUERY_COUNTERS
Date: Wed, 29 Jan 2025 15:49:50 -0500
Message-ID: <20250129204950.222472-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an ioctl for querying counters, the same ones provided in
/sys/fs/bcachefs/<uuid>/counters/, but more suitable for a 'bcachefs
top' command.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h | 10 ++++++++++
 fs/bcachefs/chardev.c        | 32 ++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-counters.c    |  2 +-
 fs/bcachefs/sb-counters.h    |  1 +
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 3c23bdf788ce..f1b746fac007 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -87,6 +87,7 @@ struct bch_ioctl_incremental {
 #define BCH_IOCTL_FSCK_OFFLINE	_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
 #define BCH_IOCTL_FSCK_ONLINE	_IOW(0xbc,	20,  struct bch_ioctl_fsck_online)
 #define BCH_IOCTL_QUERY_ACCOUNTING _IOW(0xbc,	21,  struct bch_ioctl_query_accounting)
+#define BCH_IOCTL_QUERY_COUNTERS _IOW(0xbc,	21,  struct bch_ioctl_query_counters)
 
 /* ioctl below act on a particular file, not the filesystem as a whole: */
 
@@ -443,4 +444,13 @@ struct bch_ioctl_query_accounting {
 	struct bkey_i_accounting accounting[];
 };
 
+#define BCH_IOCTL_QUERY_COUNTERS_MOUNT	(1 << 0)
+
+struct bch_ioctl_query_counters {
+	__u16			nr;
+	__u16			flags;
+	__u32			pad;
+	__u64			d[];
+};
+
 #endif /* _BCACHEFS_IOCTL_H */
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 46e9e32105a9..c2d9efe8db53 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -448,6 +448,36 @@ static long bch2_ioctl_query_accounting(struct bch_fs *c,
 	return ret;
 }
 
+static long bch2_ioctl_query_counters(struct bch_fs *c,
+			struct bch_ioctl_query_counters __user *user_arg)
+{
+	struct bch_ioctl_query_counters arg;
+	int ret = copy_from_user_errcode(&arg, user_arg, sizeof(arg));
+	if (ret)
+		return ret;
+
+	if ((arg.flags & !BCH_IOCTL_QUERY_COUNTERS_MOUNT) ||
+	    arg.pad)
+		return -EINVAL;
+
+	arg.nr = min(arg.nr, BCH_COUNTER_NR);
+	ret = put_user(arg.nr, &user_arg->nr);
+	if (ret)
+		return ret;
+
+	for (unsigned i = 0; i < arg.nr; i++) {
+		u64 v = !(arg.flags & BCH_IOCTL_QUERY_COUNTERS_MOUNT)
+			? percpu_u64_get(&c->counters[i])
+			: c->counters_on_mount[i];
+
+		ret = put_user(v, &user_arg->d[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* obsolete, didn't allow for new data types: */
 static long bch2_ioctl_dev_usage(struct bch_fs *c,
 				 struct bch_ioctl_dev_usage __user *user_arg)
@@ -710,6 +740,8 @@ long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
 		BCH_IOCTL(fsck_online, struct bch_ioctl_fsck_online);
 	case BCH_IOCTL_QUERY_ACCOUNTING:
 		return bch2_ioctl_query_accounting(c, arg);
+	case BCH_IOCTL_QUERY_COUNTERS:
+		return bch2_ioctl_query_counters(c, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
index 6992e7469112..67f4e7a5aa5a 100644
--- a/fs/bcachefs/sb-counters.c
+++ b/fs/bcachefs/sb-counters.c
@@ -5,7 +5,7 @@
 
 /* BCH_SB_FIELD_counters */
 
-static const char * const bch2_counter_names[] = {
+const char * const bch2_counter_names[] = {
 #define x(t, n, ...) (#t),
 	BCH_PERSISTENT_COUNTERS()
 #undef x
diff --git a/fs/bcachefs/sb-counters.h b/fs/bcachefs/sb-counters.h
index 81f8aec9fcb1..eef7211edf42 100644
--- a/fs/bcachefs/sb-counters.h
+++ b/fs/bcachefs/sb-counters.h
@@ -11,6 +11,7 @@ int bch2_sb_counters_from_cpu(struct bch_fs *);
 void bch2_fs_counters_exit(struct bch_fs *);
 int bch2_fs_counters_init(struct bch_fs *);
 
+extern const char * const bch2_counter_names[];
 extern const struct bch_sb_field_ops bch_sb_field_ops_counters;
 
 #endif // _BCACHEFS_SB_COUNTERS_H
-- 
2.45.2

