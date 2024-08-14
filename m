Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3F51C824D
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670770; cv=none; b=UHQRX39c3vzXnqIe7MSzkf00IrUQzIJ5hG4l/8Y3ytTzaimg3hKJHZfPaSdm4vEyobIxAqOSEYo5HCZr5S+dyH5QUM+NxSh862L+gBE1Uh9D22JAk6nczRe6hnauAM8WvrLxs8rloaGO6x6wSQI3Cz3WExidRsgTiZqs1eEV1Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670770; c=relaxed/simple;
	bh=KQKrHptqPFx5UnDyLAwlPOx0/0+4MigGJ4Sd0QKK9Tg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y03wSV7LuI5sMOFJG9e5/mieffFwfNS7MRzCT1sRLlv6mKmdRdTL+obqWX+PHGPjvavp6nPnsiVfxoQYSLUiaGxyHS/G5HSihb/emCceeIflwo1+MbXI02KD5+ZH8s+bn2s7HYm6k2lEFfi40qywXEBPxL44UJvXPMlDRIn7Eyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Z0HWOMMg; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Z0HWOMMg"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7a1dd2004e1so16345585a.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670767; x=1724275567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=Z0HWOMMgOrSgPVSZOBi/9uBHz4Tfa36G4QNcdn+g7fc3uhcaQPXtqfAUMOFmQKI+hK
         SKdkrH4sln7u/TQnIHVz3/n8RNUk9wbfZvp6pU0O8jjTC0qvNPiYAR1Hm4ixpDLyPsPr
         v9RzOXNN31RxWtrAEWx0x1yZWXucvQV9bxQHhSjCdhBlkc3+ic+XC8xJBl1VMt67AHUX
         ZyP2ey0a0j/U6vhR971S9Y8/DgXoXiVbSN5DlOgxc+0v/Imu4o2xIxxhklU8Yh/pZ/bH
         d6+bvFko1cME3EFyr7CqLu7AIWttktPhY/UhWVjt5OwKQ8XE6HhDOgb41rUN+Hs3B7EW
         tLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670767; x=1724275567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=sTsQsmXpGnJgGHJxULsTvqcca1CLcW68BKumjUyi3yxWUIedSf3IMSKDamyV9v3TOu
         QVTiX0uDvLFr1Jb2MfF7v5GFOd1wWubgcln84biqRAElldH3vgetIBH98Wl8Dil+uOcY
         523P+ltADXMWTsIIIUQnIM+LYUopcJhJ6YBsSucMq2coYN4fyRFsqz4ujSkndnGvo0Fe
         4haKnB0mVWho4r/bFOKSxDHvfdz2pGzqwwmkD8Kjsp2eAo3uGUweu8qxDLxRWWKR2N6F
         luQt0Q4z+NAQMFqSgLv3AOMTLZKkuZnbtAgzasodarGgdbhdOfWrXeWIMhjwsiNN12E7
         HfpA==
X-Forwarded-Encrypted: i=1; AJvYcCU0tgzr9J0oPl5AZYCWddn8s1Yaj//bWiZ1JjQyzwdUb7LgZAZNpfcMRW3qDobVEDW3F43hnX2690W/XJsA34u5BgGdE/Eu4TlGpRqklaQ=
X-Gm-Message-State: AOJu0YyY60xav/7e3nNu+cHJmsBUEDZwQUrG99/XIAJtPjHuj+k4gLAg
	kQA+LJPUzDi0m9zt4jiMageMnVIEIGl+p9VLRXZRh01HzFCjldPbSfX8KKIsPpI=
X-Google-Smtp-Source: AGHT+IEOAxo/YLBU2zsyh9BoruPZGvcW7AnOYidoJyHePzbDbTVUapd9HA/DiVKweRuuQtAwKoLbLg==
X-Received: by 2002:a05:620a:4506:b0:7a3:4fb7:5c77 with SMTP id af79cd13be357-7a4ee3187dcmr432377385a.11.1723670767459;
        Wed, 14 Aug 2024 14:26:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff04830fsm8695885a.30.2024.08.14.14.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:07 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 03/16] fsnotify: generate pre-content permission event on open
Date: Wed, 14 Aug 2024 17:25:21 -0400
Message-ID: <4b235bf62c99f1f1196edc9da4258167314dc3c3.1723670362.git.josef@toxicpanda.com>
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

