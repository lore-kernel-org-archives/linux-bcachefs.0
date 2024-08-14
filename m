Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D21C68B7
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670770; cv=none; b=Tidg+jNu9tX49Nlpv0pXiq4inL5daOAYMmOwzO6qhg4V7pNyK/xt8vjeWtLlPekWEkeuc/GPm/9ANW7KwvMxeqXzCbeXD3aEU7KqTz2AW3udmckgJpUN89Z/6mCJQitkwprr/ALqcy5iV/TcQG4GfpUEM1AAUYO4P6+ipIkzMl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670770; c=relaxed/simple;
	bh=2T/bTyebmmWzgd79hiDdf0J2vl5OhNotJm/x2K/voWI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io3Iv+KOd8+S5nlbA66FxTQx1WBygXrABALUpjy1DvNugMFhUno9KEZh1XpWrI+VsvtLA88lQ4aBbU7AcQGmK7LnLSBtd5W/mMKTavqip+0HUi4IjVHvyDXWuX5ClF2pxeSDTKI61KFsmo1VFXj8i7cQYqmI9RoZ0JglYR0kXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=GFA9QIbu; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="GFA9QIbu"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-44fee8813c3so1824311cf.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670765; x=1724275565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=GFA9QIbuFZu9qCRWztyBNw9BUbbzamMlRQWn2BHBujatWP2EdMryo9iv7xDIo9nOkX
         IMZ3acXfJtDRwBFtx0LpSlHGWW0RYylHhawiZLHG6QbtdLzFcSIxRhQ1nLmRglzFNlR9
         IRu/g6pJMx+2MHJBEf4DmobXu03h0MpmMdRza1m0ewKjdH9i8NV//h411MKMIGnvhLzU
         JUsSi5koXlP7xHEteq84R5vVdLoQnwYhZw+v7nSzZlvO8S9tnpSIDjY/uqzS0MLcLZhn
         S3EXoTbrC3aFyg+4FSNlvnVF9BAw2dSlML/Wew1otabc8WylfHJUcLHLLid7AsZUphV+
         ISfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670765; x=1724275565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=fReL1djC4spnGbEyKXCSQO/LifGMkSCnlf+jbfJ8Ka8NYkKfIkMNJbXN5ZjIypjWQm
         jlTO4VBC3b8Q/99t7nzxGrMpmooxdbdeNsMbvm1Ia9Udwylr18lgSbDByoY0P42o8hjX
         sD6dc4NVYLopGS0v6bPX3owHwiSIVzQ7fKkoO+hSAfACFF/GbudEtxOyqOCICJxzN8Uz
         EAsxoL531TuBqmzVDKcPMTegasTmslPESm4ct1bCL/+pWNmeUiIYPgaT16WwRfNEvT2o
         wC6TnnPeLzL9juZBdpiBswR9aDFFf3IYDU+eJ6Ge1jbp5IckIHanv1ew5DHGoVqFMNGM
         Rsxg==
X-Forwarded-Encrypted: i=1; AJvYcCVBBy3gPJD0h+CD/qJteao3xOYqZr7uwOUKR804cCQDqpm6OAPR3rJ6GQjMcJeb8Vgx80KbqMSLYhE4HJCGDlqwvi+UxYTQz/Kgz6/cxXw=
X-Gm-Message-State: AOJu0YxAiNEGngfxQ8YvpcKX0FRjFEhiFMjKfF+hRV2+6hzYDFgvHjj7
	CmPzK96YofGaNa4hjArZrNn2xbW2zw7QvVz5sqWycYJbHwHfMdcnYEzfBE4Oh44=
X-Google-Smtp-Source: AGHT+IFOosLEfbUYy+rk3DgRd8S4qUKsWD9x8eVobALgVUhAo3EcRpZRN6epvvOoKaA1rXEtmh1uXA==
X-Received: by 2002:ac8:6f0b:0:b0:447:ea03:454b with SMTP id d75a77b69052e-4535bbc9e18mr41862931cf.51.1723670765231;
        Wed, 14 Aug 2024 14:26:05 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45369ff3465sm558691cf.31.2024.08.14.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:04 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 01/16] fanotify: don't skip extra event info if no info_mode is set
Date: Wed, 14 Aug 2024 17:25:19 -0400
Message-ID: <6a659625a0d08fae894cc47352453a6be2579788.1723670362.git.josef@toxicpanda.com>
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

New pre-content events will be path events but they will also carry
additional range information. Remove the optimization to skip checking
whether info structures need to be generated for path events. This
results in no change in generated info structures for existing events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ec313e9f6e1..2e2fba8a9d20 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -160,9 +160,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	int fh_len;
 	int dot_len = 0;
 
-	if (!info_mode)
-		return event_len;
-
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
@@ -740,12 +737,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (info_mode) {
-		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
-						buf, count);
-		if (ret < 0)
-			goto out_close_fd;
-	}
+	ret = copy_info_records_to_user(event, info, info_mode, pidfd,
+					buf, count);
+	if (ret < 0)
+		goto out_close_fd;
 
 	if (f)
 		fd_install(fd, f);
-- 
2.43.0

