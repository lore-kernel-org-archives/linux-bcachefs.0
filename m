Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F63C15EFA0
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145313; cv=none; b=URfYIUlaRUa8lCUq0/S9CTQmfweZBcNNVI10eRp83Z/i6j0XD9I74Ts7aes/1Udl5mLZLM7cHGiUxgrFA9/7stOsy7DpqYOGvzcwVhHthorUWQP5UAhgDlNThi+Iai0Z9gSLHafycH5syVq1EO8pssPY5NKoJQG3DhgjWSoMDtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145313; c=relaxed/simple;
	bh=GuL24mTj9mXM70tRp2J+zNN/WSRlPMuaehdquMxMOMM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUVbkdtQLLX3nuP22axLv4vr6VhdZjOEXEyr8M/lXCKeNaxw/dQ1u2JFqrjZ9CuDjzWIyLtPFxpffPnd5CBLjXV6ud8Awhby334yJke756p//bW2xqTMzvntMU1ZDmH1YTZ3HhDZe3foqmXWTQJXavHSjQwPjw/GHuM8DcL7P4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=YuIjDizw; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="YuIjDizw"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-44ff9281e93so6937981cf.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145309; x=1723750109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2MplehQscA1+uvrWS0C9V1o5GwHxjl+BfkNu3cTe0I=;
        b=YuIjDizwBSBPP6YTB4We5JJP1CXSwKk6cmjWPtWgUS+SqPJl5OEigR8GifxH3HYjhu
         qCFp+vzbu7LlIRp+y6BZPhUJVyM/IEJnvke1iXb3nPXL/EuPVyIbsn4eBepUiIAMMl/g
         mEnNVdGANOSxCTRL6Deiq3DoHDieAaH9igHfZ12bUp/N8HMF5SUOjHxsqExHsNjs3DIz
         Boux0Ad41RNNSknEfzuVwlEy/We9lQg7VfTRWrgXmbHXyPoPtIqo4/HhyOq/5f5eDTR+
         ZzpyEVQLxPM49a6wWMm/mGaHP2i8HCiUoEYmlvO0cuiULtxHFq9ixHJLV6qzsQY2Z+NJ
         FdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145309; x=1723750109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2MplehQscA1+uvrWS0C9V1o5GwHxjl+BfkNu3cTe0I=;
        b=nZrVGGVtgUD1DgPkDAyIDB2+JHET+WA8Ej76BoJX/+K0j9wtZHR0tn1YF0XGxMcLR2
         B7yLBMXZbgJeIRSzhM6+T6GRUzLeYpY+oJnq5Zt1rP1G4xRDvDCkhBuSLp9Nj6Ic/RbM
         ZvgECAy7mWIuKFoOFy/J1K9LSOvMNd2Qc0HDW6JYvlMQ3NGLDYD8mc1sAhj5vRWEKeoF
         1PR0NxAWhrnGsexzt7sYXXcmkOKcV9NTeB2rljuXaCaiOS6AW2D6VBJjfOe2l6JhxjQN
         AtOETopoy1TdA6XA1mGJ/G5GvOwKR30P5qwFGWsZvIDgncL1GQKY/juhCcVtjL4H7blH
         kpNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJXw/w/NJ0Ti1jk7+YTyvyEJq95ICWYDiirVh3I/7PXIeVoP2QKYQYEfQVxelwdjQIPwL+pzEzeZUnUHpHN0Vu36KwqN0AJ923dyfHWnc=
X-Gm-Message-State: AOJu0YxK2dx8eCN0FQNE4SMyd48m6ztvaiE+PmU/bXgn4QdDVW2q1Qm1
	/16uogkYD+vwt0nstYJP783Vfbrpys3L/8Z0nZ22giPyIeBKrgiKdltAtoLKlJY=
X-Google-Smtp-Source: AGHT+IFDsbaV/n8kDCGttZbX/69iKd/pkdvlPw0dlBa5DAGrReE31B6U9TrZPgrw5N0QpefXodV8nA==
X-Received: by 2002:ac8:6f0a:0:b0:440:6345:257f with SMTP id d75a77b69052e-451d42ff7c2mr40818221cf.60.1723145309461;
        Thu, 08 Aug 2024 12:28:29 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c87db202sm15626721cf.72.2024.08.08.12.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:29 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 10/16] fanotify: add a helper to check for pre content events
Date: Thu,  8 Aug 2024 15:27:12 -0400
Message-ID: <531d057087b9430839ddd6082022e29a9066ef1f.1723144881.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723144881.git.josef@toxicpanda.com>
References: <cover.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want to emit events during page fault, and calling into fanotify
could be expensive, so add a helper to allow us to skip calling into
fanotify from page fault.  This will also be used to disable readahead
for content watched files which will be handled in a subsequent patch.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fsnotify.c             | 12 ++++++++++++
 include/linux/fsnotify_backend.h | 14 ++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 1ca4a8da7f29..cbfaa000f815 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -201,6 +201,18 @@ static inline bool fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 	return mask & marks_mask & ALL_FSNOTIFY_EVENTS;
 }
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	__u32 mnt_mask = real_mount(file->f_path.mnt)->mnt_fsnotify_mask;
+
+	return fsnotify_object_watched(inode, mnt_mask,
+				       FSNOTIFY_PRE_CONTENT_EVENTS);
+}
+#endif
+
+
 /*
  * Notify this dentry's parent about a child's events with child name info
  * if parent is watching or if inode/sb/mount are interested in events with
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 276320846bfd..b495a0676dd3 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -900,6 +900,15 @@ static inline void fsnotify_init_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->list);
 }
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+bool fsnotify_file_has_pre_content_watches(struct file *file);
+#else
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
+
 #else
 
 static inline int fsnotify(__u32 mask, const void *data, int data_type,
@@ -938,6 +947,11 @@ static inline u32 fsnotify_get_cookie(void)
 static inline void fsnotify_unmount_inodes(struct super_block *sb)
 {}
 
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return false;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */
-- 
2.43.0

