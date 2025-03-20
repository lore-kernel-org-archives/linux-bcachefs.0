Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9EE221732
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505699; cv=none; b=Y8wiNm+VVMJ976lfnXfrLVFhaz2e95dqm4Dxnv4ciLFsKgQ06y43lcSPVnQyH7Zr84op/kntD1v+S3isa03y41EZ0QVBs8/j8CJLg3bOcexH6If08Pymigmq0JT/54ge3J/Tmko39kpuz3SH7js5NAtvZo1i5XLEBrs93hwsEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505699; c=relaxed/simple;
	bh=3kdbKx4EMuu1hf7HUvoODWNXWw2CLtqIubGiFa5cW6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uko7772/4Q/XfA+u/iVn2MOytjVM/cfDHYyJTSPaWHb/dpM8ngdHzKsEhOTwC/rjq0Ly6el1hr27l7fZWmYTu7OaCUnbdsgAXT+oG13BQ2OSuJTft0BRANkI9g8FkV4dGRAaL5AcQ6YXv9XhnhCzUr2etVuucAdMR72LRustBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BdwBF1np; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BdwBF1np"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzouNhybcOUY/o4zpKQpRS1i5KMyFuzArF0XQ86F1Sw=;
	b=BdwBF1np8vTVeFUmUh7Zm9KRpsGRkXMO9BsMtXda0gArrskwUO1qHTVA9Eu0mtRXrEjMpa
	0vjCE2tuO6x+8qM1Z1/mS3iEFaegdUeTF/YAsmFKawUa3VWYzE5BWwSw57WhaiZr6ECAi9
	nUv1830oV9U87QlM8BC/JYYcduHqqmc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/5] bcachefs: Device state is now a runtime option
Date: Thu, 20 Mar 2025 17:21:22 -0400
Message-ID: <20250320212125.3359155-5-kent.overstreet@linux.dev>
In-Reply-To: <20250320212125.3359155-1-kent.overstreet@linux.dev>
References: <20250320212125.3359155-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Other options can normally be set at runtime via sysfs, no reason for
this one not to be as well - it just doesn't support the degraded flags
argument this way, that requires the ioctl.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/opts.c  | 7 +++++++
 fs/bcachefs/opts.h  | 2 +-
 fs/bcachefs/sysfs.c | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 6c6ba23e9fbc..a980b38b88da 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -482,9 +482,16 @@ void bch2_opts_to_text(struct printbuf *out,
 
 int bch2_opt_check_may_set(struct bch_fs *c, struct bch_dev *ca, int id, u64 v)
 {
+	lockdep_assert_held(&c->state_lock);
+
 	int ret = 0;
 
 	switch (id) {
+	case Opt_state:
+		if (ca)
+			return __bch2_dev_set_state(c, ca, v, BCH_FORCE_IF_DEGRADED);
+		break;
+
 	case Opt_compression:
 	case Opt_background_compression:
 		ret = bch2_check_set_has_compressed_data(c, v);
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 19fcc0e51c0b..0bf39e4b1c8e 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -495,7 +495,7 @@ enum fsck_err_opts {
 	  NULL,		"Skip submit_bio() for data reads and writes, "	\
 			"for performance testing purposes")		\
 	x(state,			u64,				\
-	  OPT_DEVICE,							\
+	  OPT_DEVICE|OPT_RUNTIME,					\
 	  OPT_STR(bch2_member_states),					\
 	  BCH_MEMBER_STATE,		BCH_MEMBER_STATE_rw,		\
 	  "state",	"rw,ro,failed,spare")				\
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index b01b2ae87051..e8a795578186 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -631,6 +631,8 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 	if (unlikely(!bch2_write_ref_tryget(c, BCH_WRITE_REF_sysfs)))
 		return -EROFS;
 
+	down_write(&c->state_lock);
+
 	char *tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp) {
 		ret = -ENOMEM;
@@ -664,6 +666,7 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 
 	ret = size;
 err:
+	up_write(&c->state_lock);
 	bch2_write_ref_put(c, BCH_WRITE_REF_sysfs);
 	return ret;
 }
-- 
2.49.0

