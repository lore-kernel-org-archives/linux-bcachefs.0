Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B82A1C9ED3
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670779; cv=none; b=HhZPRvEnyBgLg8IO2WsCQvpWcBYaJAN3mybOGh84QkOnTlzYE/hYJuj3k/6S6jpk11rQnZn8Cr+Ukp7+AfD61gxy1nSTV/HkPoHd8gggJJqNARssivmc0cUoY910WTr+qxyI2fwvlI0joqFvXCVJ/kNZF02zmydTJT3oh7BieoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670779; c=relaxed/simple;
	bh=RuLIdPYLf2U7vdfwd0GY223a6ukGYtQumd4qAvMMF1s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAO/SpfMXoMJLW/Jzxkvt34XskvMZw0KIqI8ezK6qWmUmnt1381v9MQAfOQERSr8YwEGPbEZKI8Zs/AtHzpa9CBKTSzhgZ1mCrrIxtz9NmfjV7xK8UCs612jg5999T8nz2vHQeysYDVY1wBKdFeMtg6k4wOFFciETTsn518/DgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=IPZSBVx3; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="IPZSBVx3"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6bf6ea1d34aso1191896d6.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670776; x=1724275576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQ0y3/dQBSJxG2OyPRkhEh3Vj0wjByustgiYia+MZqs=;
        b=IPZSBVx3FvAg/wy6rDR0AVmgrMkTIpQdIqpFh6B2mN60MX5Cz5YOVcUsQyTw7eR4q1
         oKcHesIjSo9/dJycGPV2Vl+n3frm4OhclApkYB2ODCb9JMCPbg3fdbQ1f3RPUtgV2cMo
         807s7jHG1sAjH4vqauzhgyQtG0I0cWhJHOmSvKi98hed+Hk7KKto1yfS+uwc0eoySD09
         xjDioDWCPhb79AbqF0zIwgBu6mshgq12cmAPwiRb4x2euQrO2q8rHeMyae9GA5ZfuEpi
         K1wsjqm1lQNfCbCnKONLdy37L8tuc+cdmqv8/Ft5b3GUKq+yC7jdn1yStgHULCzrWCuw
         f1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670776; x=1724275576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NQ0y3/dQBSJxG2OyPRkhEh3Vj0wjByustgiYia+MZqs=;
        b=hHzI2CuUBkYBxGBIGm3w5KqZuYTY3uARxvwjerED4uNPhygYbALZbTxQAqD5QVy1Zi
         xbesWfXbu6DBpdK7Sn3ihVNKfNBsfRx5xuh1mstG/LCW6RxSTpEHxdvYecdFSI9f/1aY
         p9YiZFQhplgAb4BDq/W4QpEsaafEZoOVaSUhV6yeD8meDEPa6lyWFjz7B+zqC0KwoDA6
         WMO4PBlEOqe/M0A3PrKIer0FHeW2NubJaWCwF9otrzZCgXFVyaYO2+4Nwl3Rrqsq72tM
         GtTOUtLyy3EJEli0IUQQSKmHjr8FYnGKydOdQuhLo83zwTkqvfuGTam4AXISn3dB92qe
         BCxA==
X-Forwarded-Encrypted: i=1; AJvYcCW3VAdCgvit8345aou575WJIq0Z9Vw2+gJg/FDfmQMGRLz0BDUBKianFpoOxKdyFPs7BJ6oNhxEYWcGLnGAkGt1zvBEPLOFddvc63fyzQI=
X-Gm-Message-State: AOJu0YxCICEErm3KpICBWdEE9cLXlajFpnLLTVinZdoPReX7xORfY9dI
	LdkxcUsCceRUQpKcl9UsyiTFCHjt/Llb+UGO1WQFtHmiQMe/5U/rFdoDHUnVBMs=
X-Google-Smtp-Source: AGHT+IExGAEQEamrim6ho8QAd+QcOVhJTtOVmgmL6OYA606guNdAfaz4yD+2UP67QG+9AhpysKNQAg==
X-Received: by 2002:a05:6214:2e4a:b0:6b7:a9dd:ba58 with SMTP id 6a1803df08f44-6bf5d1fa365mr62306796d6.18.1723670776088;
        Wed, 14 Aug 2024 14:26:16 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6fe26c71sm618696d6.61.2024.08.14.14.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:15 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 11/16] fanotify: disable readahead if we have pre-content watches
Date: Wed, 14 Aug 2024 17:25:29 -0400
Message-ID: <9a458c9c553c6a8d5416c91650a9b152458459d0.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With page faults we can trigger readahead on the file, and then
subsequent faults can find these pages and insert them into the file
without emitting an fanotify event.  To avoid this case, disable
readahead if we have pre-content watches on the file.  This way we are
guaranteed to get an event for every range we attempt to access on a
pre-content watched file.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/filemap.c   | 12 ++++++++++++
 mm/readahead.c | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index ca8c8d889eef..8b1684b62177 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3122,6 +3122,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	unsigned long vm_flags = vmf->vma->vm_flags;
 	unsigned int mmap_miss;
 
+	/*
+	 * If we have pre-content watches we need to disable readahead to make
+	 * sure that we don't populate our mapping with 0 filled pages that we
+	 * never emitted an event for.
+	 */
+	if (fsnotify_file_has_pre_content_watches(file))
+		return fpin;
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
 	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
@@ -3190,6 +3198,10 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	struct file *fpin = NULL;
 	unsigned int mmap_miss;
 
+	/* See comment in do_sync_mmap_readahead. */
+	if (fsnotify_file_has_pre_content_watches(file))
+		return fpin;
+
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
diff --git a/mm/readahead.c b/mm/readahead.c
index 817b2a352d78..bc068d9218e3 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -128,6 +128,7 @@
 #include <linux/blk-cgroup.h>
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
+#include <linux/fsnotify.h>
 
 #include "internal.h"
 
@@ -674,6 +675,14 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 {
 	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
 
+	/*
+	 * If we have pre-content watches we need to disable readahead to make
+	 * sure that we don't find 0 filled pages in cache that we never emitted
+	 * events for.
+	 */
+	if (ractl->file && fsnotify_file_has_pre_content_watches(ractl->file))
+		return;
+
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -704,6 +713,10 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	if (!ractl->ra->ra_pages)
 		return;
 
+	/* See the comment in page_cache_sync_ra. */
+	if (ractl->file && fsnotify_file_has_pre_content_watches(ractl->file))
+		return;
+
 	/*
 	 * Same bit is used for PG_readahead and PG_reclaim.
 	 */
-- 
2.43.0

