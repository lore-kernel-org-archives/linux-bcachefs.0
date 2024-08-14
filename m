Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BEE1C822D
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670768; cv=none; b=uk+BUow1EstbfKpMEmFdFcGDptF9/t/jyFfaulKSUUl1j/efXTLA1BMg6tJUWq0nQkPJZXYU2osDO1bVNSvv1jQyYz0k91bRKQ62Xr6koXI6M2B+g0025Z6sAKEoy1O0U2mE0U4gp2Ftzy7UBcnjrHy8KkR+eQ4gKjVMs9GJOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670768; c=relaxed/simple;
	bh=Xn48LHyloGlt4wSB8hOBR2UrfV1ArFm69qZkTTQGfyU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeDIMPrq1ZFFIJe2xn3jkntf9ceUO1cBgVUNSh2e4pGCV95zLKMvlYWfcYbshc8TbVCXOmslD1z/tkt/8Noa4iKtXQfBrNlm3uTza+WBKDYB5zyPpUOWNd0QQo9KzT3p1OVRWfnVy0KL8NI2xWBpV3z/bQeFmY+Oca9pXQsLzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=En3n5z8I; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="En3n5z8I"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6bb96ef0e8eso1532096d6.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670766; x=1724275566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5YjJnCjztcen/Z+X5lHX0n7xhNQ/QripYlvqYqvblA=;
        b=En3n5z8I/v4+3hgSGzRIxA92hiAMAdP1sNFxjipj71+sP/7he2nH+uSYmm77Rwwu2J
         JewkBvVTlCAsBMO2WipkCD9rtjYbiFqsy0R9fC3EVA17bB96kiJvw4jZNVvWSXaE7Vtd
         X2YwYyGP/VYTfJsuJoKwWhpIuSomrcXAXioFTZpkXJzH13UqjsQhoZRSNffv/ZpvAqja
         GsArWLu9B1eTG8b5MSOKedQplrDnnP12P43Ihtyc5pTaXS+Y9j7/mbMqSb0t2L2crA1e
         LALVbU5Jc9gQ+ylcKJBfCPL0Zy6JSDaklSN5VpF47f+cbiKgWt7FEpmWNW1E4+g9Qhyy
         N+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670766; x=1724275566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5YjJnCjztcen/Z+X5lHX0n7xhNQ/QripYlvqYqvblA=;
        b=n6LiPO3LdRfS4LKY6BGZJkSwWeHwwlOkqLA0OIvpChqGlchEXQ83UnsZ61VgZqBHMM
         7/qM7P5MO2OzPlUu6JAZBKkbkJ1NhSBm8Qei5WO2gQMKzLuW6mWuDVrxKc87CDUS3m+F
         l98vM2tHD444vGx6chfDcNoAeHvrwi7dMJ8pW/cn2Ci62toh4Mtpl1DH/xAtC2VgJKHb
         51yNRBxE21PxdaIaJPWSYulFhWpQZJ0bXmDiWBBE0/BIXcXUSB2rjJ9PbeZuom4uBJbD
         UzyoGxf1/iPkRK150NjC7cOr85mQvPPQYo6hFXTBxeMaChFypbQd6Rbilze8fswou5D0
         W0Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUZYSbRXQT5xgzf/v5eyMe7w1yDlCl9d9Jgye82HCZIGuYF1Un1YWNfBtFJjZBoQf9cAj6vK24eDCfd36dagFHzR5WJgCEpnwB0+9rosFA=
X-Gm-Message-State: AOJu0YyD9cXIQjZBYqOhZApu4nMZSu+eTPg3XmMOwZuV9zeKFQNf1BuZ
	OUr/RMh2bFcd1tSuuqGQVcPvRmdnYjj2wNWDkKeRpxcO/DTSHwF6tsT7H9OeT6U=
X-Google-Smtp-Source: AGHT+IEJ45kMxMd9GAYKpZ0U1aW3kAHT2F3+5BvHJo7NIEX4yhQ21Vvr3YILDZWxA0MQ1vkSqNpnkg==
X-Received: by 2002:ad4:53cb:0:b0:6bf:6604:c876 with SMTP id 6a1803df08f44-6bf6604cca1mr24849216d6.32.1723670766260;
        Wed, 14 Aug 2024 14:26:06 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6fe25cf5sm632276d6.58.2024.08.14.14.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 02/16] fsnotify: introduce pre-content permission event
Date: Wed, 14 Aug 2024 17:25:20 -0400
Message-ID: <a96217d84dfebb15582a04524dc9821ba3ea1406.1723670362.git.josef@toxicpanda.com>
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

From: Amir Goldstein <amir73il@gmail.com>

The new FS_PRE_ACCESS permission event is similar to FS_ACCESS_PERM,
but it meant for a different use case of filling file content before
access to a file range, so it has slightly different semantics.

Generate FS_PRE_ACCESS/FS_ACCESS_PERM as two seperate events, same as
we did for FS_OPEN_PERM/FS_OPEN_EXEC_PERM.

FS_PRE_MODIFY is a new permission event, with similar semantics as
FS_PRE_ACCESS, which is called before a file is modified.

FS_ACCESS_PERM is reported also on blockdev and pipes, but the new
pre-content events are only reported for regular files and dirs.

The pre-content events are meant to be used by hierarchical storage
managers that want to fill the content of files on first access.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fsnotify.c             |  2 +-
 include/linux/fsnotify.h         | 27 ++++++++++++++++++++++++---
 include/linux/fsnotify_backend.h | 13 +++++++++++--
 security/selinux/hooks.c         |  3 ++-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 272c8a1dab3c..1ca4a8da7f29 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -621,7 +621,7 @@ static __init int fsnotify_init(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 23);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 25);
 
 	ret = init_srcu_struct(&fsnotify_mark_srcu);
 	if (ret)
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 278620e063ab..7600a0c045ba 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -133,12 +133,13 @@ static inline int fsnotify_file(struct file *file, __u32 mask)
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 /*
- * fsnotify_file_area_perm - permission hook before access to file range
+ * fsnotify_file_area_perm - permission hook before access/modify of file range
  */
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 					  const loff_t *ppos, size_t count)
 {
-	__u32 fsnotify_mask = FS_ACCESS_PERM;
+	struct inode *inode = file_inode(file);
+	__u32 fsnotify_mask;
 
 	/*
 	 * filesystem may be modified in the context of permission events
@@ -147,7 +148,27 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 	 */
 	lockdep_assert_once(file_write_not_started(file));
 
-	if (!(perm_mask & MAY_READ))
+	/*
+	 * Generate FS_PRE_ACCESS/FS_ACCESS_PERM as two seperate events.
+	 */
+	if (perm_mask & MAY_READ) {
+		int ret = fsnotify_file(file, FS_ACCESS_PERM);
+
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Pre-content events are only reported for regular files and dirs.
+	 */
+	if (!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode))
+		return 0;
+
+	if (perm_mask & MAY_WRITE)
+		fsnotify_mask = FS_PRE_MODIFY;
+	else if (perm_mask & (MAY_READ | MAY_ACCESS))
+		fsnotify_mask = FS_PRE_ACCESS;
+	else
 		return 0;
 
 	return fsnotify_file(file, fsnotify_mask);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 8be029bc50b1..200a5e3b1cd4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -56,6 +56,9 @@
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 #define FS_OPEN_EXEC_PERM	0x00040000	/* open/exec event in a permission hook */
 
+#define FS_PRE_ACCESS		0x00080000	/* Pre-content access hook */
+#define FS_PRE_MODIFY		0x00100000	/* Pre-content modify hook */
+
 /*
  * Set on inode mark that cares about things that happen to its children.
  * Always set for dnotify and inotify.
@@ -77,8 +80,14 @@
  */
 #define ALL_FSNOTIFY_DIRENT_EVENTS (FS_CREATE | FS_DELETE | FS_MOVE | FS_RENAME)
 
-#define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM | \
-				  FS_OPEN_EXEC_PERM)
+/* Content events can be used to inspect file content */
+#define FSNOTIFY_CONTENT_PERM_EVENTS (FS_OPEN_PERM | FS_OPEN_EXEC_PERM | \
+				      FS_ACCESS_PERM)
+/* Pre-content events can be used to fill file content */
+#define FSNOTIFY_PRE_CONTENT_EVENTS  (FS_PRE_ACCESS | FS_PRE_MODIFY)
+
+#define ALL_FSNOTIFY_PERM_EVENTS (FSNOTIFY_CONTENT_PERM_EVENTS | \
+				  FSNOTIFY_PRE_CONTENT_EVENTS)
 
 /*
  * This is a list of all events that may get sent to a parent that is watching
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 55c78c318ccd..2997edf3e7cd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3406,7 +3406,8 @@ static int selinux_path_notify(const struct path *path, u64 mask,
 		perm |= FILE__WATCH_WITH_PERM;
 
 	/* watches on read-like events need the file:watch_reads permission */
-	if (mask & (FS_ACCESS | FS_ACCESS_PERM | FS_CLOSE_NOWRITE))
+	if (mask & (FS_ACCESS | FS_ACCESS_PERM | FS_PRE_ACCESS |
+		    FS_CLOSE_NOWRITE))
 		perm |= FILE__WATCH_READS;
 
 	return path_has_perm(current_cred(), path, perm);
-- 
2.43.0

