Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80586179A7
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810654; cv=none; b=iHKyCBJWoYNltsVUzZPkmUZuPPQv8g8XV8BsBAJjbxRgWMkusvgrkBNGsXmtvvKHn8ZcyKlbhoJqkd5WlSh2QRQR9u2kFFKC+BPb+6e110G0XTSaAYY+uAqXkKXcZ7Dr5jHs5Ss18UyvEe5F09x+oNTxJegXk+PS1Yxq2O4suRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810654; c=relaxed/simple;
	bh=wp3ItIjP/eM3nHRV/ueToWWpUBvQ0HURSPAs4dNTOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsGJfLyEs4wRx0riGxla5eHH3RlAVPRce7XFXEyokWEwUVU4N1sxZmcZnFD8KmENSnkbQIxWDb0LufOtT80qe059i3LqQEPobYPqDZyzy0Cm8GlMGy0Kf6hBxZtn/KrtQ7OqfOLdh7nNHjdm7RBFl/EiljaFBrO1Dmry/J+e8uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YVIs0Yfb; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YVIs0Yfb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qbFCupYD6cuufrah1tp95LcKbCVJkF/QAIca55VNNDo=;
	b=YVIs0YfbvmD5K+GzUpP9ySjW+Ovk/9RibUBBtAdETMseV0OPKEypGAljR11LTXP30jIysu
	g2kzWvZrEDbG+XwRUq0I6dskFD7/L1/Yrg4BpL8QRcX8Z3xtZzLF0wq3eiulYCMv6v+iNY
	hoMbx+kYu/jEaJHITRL6SHihF2m5iI0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/6] bcachefs: bch2_dev_missing_bkey()
Date: Wed, 16 Apr 2025 09:37:21 -0400
Message-ID: <20250416133724.3653606-3-kent.overstreet@linux.dev>
In-Reply-To: <20250416133724.3653606-1-kent.overstreet@linux.dev>
References: <20250416133724.3653606-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Part of the ongoing project to kill off bch2_(fs|trans)_inconsistent
calls - they generally need to be replaced with either

- a fsck_err() call that can repair the error, or

- logging an error of the appropriate type in the superblock, and
  flagging the appropriate recovery pass to repair the error

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c    | 10 +++++++++-
 fs/bcachefs/sb-members.c | 22 +++++++++++++++++++++-
 fs/bcachefs/sb-members.h |  8 +++++---
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 98de81bdef6b..7058a3432fd2 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -158,7 +158,15 @@ int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
 		if (dev >= 0 && p.ptr.dev != dev)
 			continue;
 
-		struct bch_dev *ca = bch2_dev_rcu(c, p.ptr.dev);
+		struct bch_dev *ca = bch2_dev_rcu_noerror(c, p.ptr.dev);
+
+		if (unlikely(!ca && p.ptr.dev != BCH_SB_MEMBER_INVALID)) {
+			rcu_read_unlock();
+			int ret = bch2_dev_missing_bkey(c, k, p.ptr.dev);
+			if (ret)
+				return ret;
+			rcu_read_lock();
+		}
 
 		if (p.ptr.cached && (!ca || dev_ptr_stale_rcu(ca, &p.ptr)))
 			continue;
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 116131f95815..5f7a7d1965e3 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -5,11 +5,31 @@
 #include "disk_groups.h"
 #include "error.h"
 #include "opts.h"
+#include "recovery_passes.h"
 #include "replicas.h"
 #include "sb-members.h"
 #include "super-io.h"
 
-void bch2_dev_missing(struct bch_fs *c, unsigned dev)
+int bch2_dev_missing_bkey(struct bch_fs *c, struct bkey_s_c k, unsigned dev)
+{
+	struct printbuf buf = PRINTBUF;
+	bch2_log_msg_start(c, &buf);
+
+	prt_printf(&buf, "pointer to nonexistent device %u in key\n", dev);
+	bch2_bkey_val_to_text(&buf, c, k);
+
+	bool print = bch2_count_fsck_err(c, ptr_to_invalid_device, &buf);
+
+	int ret = bch2_run_explicit_recovery_pass_printbuf(c, &buf,
+						 BCH_RECOVERY_PASS_check_allocations);
+
+	if (print)
+		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	printbuf_exit(&buf);
+	return ret;
+}
+
+void bch2_dev_missing_atomic(struct bch_fs *c, unsigned dev)
 {
 	if (dev != BCH_SB_MEMBER_INVALID)
 		bch2_fs_inconsistent(c, "pointer to nonexistent device %u", dev);
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index 06bb41a3f360..99d15e54726b 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -218,13 +218,15 @@ static inline struct bch_dev *bch2_dev_rcu_noerror(struct bch_fs *c, unsigned de
 		: NULL;
 }
 
-void bch2_dev_missing(struct bch_fs *, unsigned);
+int bch2_dev_missing_bkey(struct bch_fs *, struct bkey_s_c, unsigned);
+
+void bch2_dev_missing_atomic(struct bch_fs *, unsigned);
 
 static inline struct bch_dev *bch2_dev_rcu(struct bch_fs *c, unsigned dev)
 {
 	struct bch_dev *ca = bch2_dev_rcu_noerror(c, dev);
 	if (unlikely(!ca))
-		bch2_dev_missing(c, dev);
+		bch2_dev_missing_atomic(c, dev);
 	return ca;
 }
 
@@ -242,7 +244,7 @@ static inline struct bch_dev *bch2_dev_tryget(struct bch_fs *c, unsigned dev)
 {
 	struct bch_dev *ca = bch2_dev_tryget_noerror(c, dev);
 	if (unlikely(!ca))
-		bch2_dev_missing(c, dev);
+		bch2_dev_missing_atomic(c, dev);
 	return ca;
 }
 
-- 
2.49.0

