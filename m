Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1A21E503C
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481776; cv=none; b=kOsktJN9ZX7qAiVZN+T8UUHXwdfiqRuFCB8HqXap0852r1//V0jo/wnZQDT29d/SnNqXOp3ZubxGlJiCYfuj30/cKSMLB9wtOzkRo39WwOSAkXhorsyoCvxDTDSFWyin4G62d0ap0GVITn9aR8i9CURuI5t2F1UbLw1xE3c276E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481776; c=relaxed/simple;
	bh=RHm6Vcau9bymJmSH7LFX1AgubiQ8JArKmLFZ//38aUA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8jjtkeIwSR39l7ddUC7M5dKfLYrukNQiD5iYRmavCe8qLkVZ70zRsJtfOSLlmzE0gLEDsjy4ALhkYd9GX8ZVS40NJgXbRrYHglt8qypf/N/O/TbUffMHblIthSf3rg1S5pUOJ+UIgKCn3KgrjiBwpiRCqyeVT8hNlRuOkyOBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=DkyRDa6X; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="DkyRDa6X"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e1a74ee4c75so82570276.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481773; x=1726086573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0zVu5c8eaWCvvk5EBO+fDxyCoY1kZOiTk4/wXy3iZ/k=;
        b=DkyRDa6XmYumakFghCrNcOBmEOvXbsH5FISDD4gJ67hadBHnFL5XTza/W3cfpy3q+m
         ruxY0iNipBvRq3cDFiE6Okc73JXO5RRz8l+8VcL9N5gdHjVW0pov9w9J5x7OMJAbPuSX
         1o6CnpuJW6PrFzhZQ9Strozw1DEijSZOJRrAEC3ZWVbybq8cvjb46PAcReCVxWaHXAIW
         6Zhx+2nFaDPRQCDxnsvzIDlgPjrrkMvuJTLgO9qY7u+yeOxnrenL1rHYzu1rTHhi70oP
         HspqZMPCxXCoSISGRLO9ZzWgGw9OZyoXhQ6NZtMRjiBlma/PVzIqcfqQS1NfTkhM/YAy
         77ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481773; x=1726086573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zVu5c8eaWCvvk5EBO+fDxyCoY1kZOiTk4/wXy3iZ/k=;
        b=Ck/EadAUF5Bdp1OqcUMjm+YaVYWrPHttJkD2EYmKuLiefl3uYTntNff9xRF/0Cwuln
         7gxxKaxFFUMRdQ9NQqyb8wHb1nfBJ0XaIqgXc2XaoGYKS6BzNo11NyyeOy20x5T/H0AA
         RvuvtCkahqU6Ym6PXCz++1FflnkQy/XlqFLxWpGaPpCpM11QQHVilRfyVD1lSUgX4kvP
         NzTiJ0tbmAOyirxutvDH59KykVv/kOKOoaZO/SpxHi/h6izmRfl+ctVU2RA8efGI4nPb
         EFVsGm7mYf/mciIo71OtsE5+yPeV6fdRYSFh4fazoGD9WHmRyBmiDJG3NBkuTL42FzZA
         NTtg==
X-Forwarded-Encrypted: i=1; AJvYcCW6mpI8zwVNqp2JpcRo3mUA+2eWCFli4ZIh0jVOWQNftLROH5nYpZF0JW9nKrdlfS+6FI+yX+CqKxl58YdR2A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3z4K9LuhB9ghfG0QDSNW7RiaID+vPg0NWjoxH8szNwMtvvm9q
	y4fJp6oNASGe5ytY+SYbBOBQDA49X2se5Wo8c3r7TNIdqs0TnY4fAabEKXfFxgc=
X-Google-Smtp-Source: AGHT+IFDFkzBbYpd9NLUztwVk1+npkB1ydP+fmMEnnhVo46mYhG5bHnYSQtzbSERWVZmLM1FzjZsHw==
X-Received: by 2002:a05:6902:1b04:b0:e16:49d6:43e3 with SMTP id 3f1490d57ef6-e1a7a028d68mr20024706276.22.1725481773240;
        Wed, 04 Sep 2024 13:29:33 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c520418d34sm1550836d6.119.2024.09.04.13.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 11/18] fanotify: add a helper to check for pre content events
Date: Wed,  4 Sep 2024 16:28:01 -0400
Message-ID: <288ff84b68a6b79a0526b6d53df2df5d184b5232.1725481503.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725481503.git.josef@toxicpanda.com>
References: <cover.1725481503.git.josef@toxicpanda.com>
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

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fsnotify.c             | 15 +++++++++++++++
 include/linux/fsnotify_backend.h | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 1ca4a8da7f29..30badf8ba36c 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -201,6 +201,21 @@ static inline bool fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 	return mask & marks_mask & ALL_FSNOTIFY_EVENTS;
 }
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	__u32 mnt_mask = real_mount(file->f_path.mnt)->mnt_fsnotify_mask;
+
+	if (!(inode->i_sb->s_type->fs_flags & FS_ALLOW_HSM))
+		return false;
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

