Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D2915ECEA
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Aug 2024 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229101; cv=none; b=CE2wbK+ltS1NMRalel4qKc4Q5PzIeI9lD1VQ1OEjNC3/9yZSIneLMR0F7y8+nhRjdZZCjGHWX9wvbosVe2FXSJ9JeQ8wVVgJ2Lj9BtvKRrIyMFKC+PibF2eVpOE13L34eFM2ze/w27nFwyc62Vt2w0kClTFhDiafGyKzbbymPQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229101; c=relaxed/simple;
	bh=KQKrHptqPFx5UnDyLAwlPOx0/0+4MigGJ4Sd0QKK9Tg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4c4nEriq7rDyTBIKC/4nGp7vD244oZv1IjVsdgWkSmnSbiqUbxgl8ifPbNCnVkrZ2DworrQBFBVf8I2V9mJwwuBqjmvFWNb7D/lMcFA385nB7//5vwZfvi11akux6ZGFAPkHhCWIN+Dqg0xrzb6VKFjFYHkx8U9CzKUtZgNMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=0m2N/m2J; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="0m2N/m2J"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a1d6f47112so135926785a.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Aug 2024 11:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229097; x=1723833897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=0m2N/m2J9AO0vbrptlGK6P1iy5pgychmhD1pUEzksIgbu1QWUkLGNe6qZetJCIAJV0
         Oxls5GWjDldwMQmDnHysOfncwLj6f9JPjUYATlelsteI0cg5cgF6Pe4vxyOdTFguwVn9
         uNt/yHMc5SxthkryGiuRcB2B/GA2Y37jO24Ztmx6mWPGElYmtW8rO2kvISTUETOqQZYY
         DuUQ2Y3H13w9HFF7MlQzUihmC7UMc186Q9R5fefSUMogPBluAv4HlpgW92dMshshoGvG
         XsfdZ0VjR4xIG9DwdZwKQElyadlGvo5R5JRfudBxTezqYXwceSwYBPJ6dsKFs4eJW3DB
         EW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229097; x=1723833897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=UWQD4sRW4vMdDuDTNxTYxcctsBfUIccpyHp2wW4zhdPgpgglDhbOVMO7IwcN8xE8jX
         QXuJk8gp3xCAcYoLf/sJws/CAEdfJAiTuQUcus6Jja7hOTc+DMc84xHaZhzvubsOItMp
         bUXbySOkaBEfXxY7IdIEuxAf+pK0BYhbvtXd+xI3KNUWNmdvLFLJxkZ6J1GupSRgvheJ
         utsQmE0p9jtmU76zE9Wr8N9UP2Dmb2mJammtb8O8ZvRPACd9aOSvUarr8/8CdJ8cpCI1
         7EMqcf9zi/tkS590no2DTo0vuHsYP+NwSZsLpDs3YxVhwE6EcVdewyJ9q2Rdk0Ln9w3a
         7CuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTSw2jdfPs8By5ibJb++0DJBZdJcVdiLTAMd9AjwAXcRs1wKCLcFsHZMIsTDV+XqYPSUXgXtD0/vcdgxBuRMFmAz2Llxntrc0lVuXX07I=
X-Gm-Message-State: AOJu0YwfQGXaR8n8MlC60EIbNpcQJPckJvUlqEiIiX9ceQ1u/ko9LBfL
	8Mz45BrAqqWy9oculXqcaxy6CscgZSemniQ55d/wDDGglNUuYEK+fOnQ8mO/SOM=
X-Google-Smtp-Source: AGHT+IHHl/EOLnBynA8lLjSkcy7OyB9isu0I/BOdIulGxQRUK1Ol8/y8N8Du8hRfZkA5IbZGtjvFiw==
X-Received: by 2002:a05:620a:2906:b0:79f:186e:40c0 with SMTP id af79cd13be357-7a4c182f605mr329964385a.53.1723229097560;
        Fri, 09 Aug 2024 11:44:57 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d6e49bsm4437685a.32.2024.08.09.11.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:44:57 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 03/16] fsnotify: generate pre-content permission event on open
Date: Fri,  9 Aug 2024 14:44:11 -0400
Message-ID: <4b235bf62c99f1f1196edc9da4258167314dc3c3.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on open depending on
file open mode.  The pre-content event will be generated in addition to
FS_OPEN_PERM, but without sb_writers held and after file was truncated
in case file was opened with O_CREAT and/or O_TRUNC.

The event will have a range info of (0..0) to provide an opportunity
to fill entire file content on open.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
 fs/namei.c               |  9 +++++++++
 include/linux/fsnotify.h | 10 +++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3a4c40e12f78..c16487e3742d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3735,6 +3735,15 @@ static int do_open(struct nameidata *nd,
 	}
 	if (do_truncate)
 		mnt_drop_write(nd->path.mnt);
+
+	/*
+	 * This permission hook is different than fsnotify_open_perm() hook.
+	 * This is a pre-content hook that is called without sb_writers held
+	 * and after the file was truncated.
+	 */
+	if (!error)
+		error = fsnotify_file_perm(file, MAY_OPEN);
+
 	return error;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 7600a0c045ba..fb3837b8de4c 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -168,6 +168,10 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 		fsnotify_mask = FS_PRE_MODIFY;
 	else if (perm_mask & (MAY_READ | MAY_ACCESS))
 		fsnotify_mask = FS_PRE_ACCESS;
+	else if (perm_mask & MAY_OPEN && file->f_mode & FMODE_WRITER)
+		fsnotify_mask = FS_PRE_MODIFY;
+	else if (perm_mask & MAY_OPEN)
+		fsnotify_mask = FS_PRE_ACCESS;
 	else
 		return 0;
 
@@ -176,10 +180,14 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 
 /*
  * fsnotify_file_perm - permission hook before file access
+ *
+ * Called from read()/write() with perm_mask MAY_READ/MAY_WRITE.
+ * Called from open() with MAY_OPEN without sb_writers held and after the file
+ * was truncated. Note that this is a different event from fsnotify_open_perm().
  */
 static inline int fsnotify_file_perm(struct file *file, int perm_mask)
 {
-	return fsnotify_file_area_perm(file, perm_mask, NULL, 0);
+	return fsnotify_file_area_perm(file, perm_mask, &file->f_pos, 0);
 }
 
 /*
-- 
2.43.0

