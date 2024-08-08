Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA7215B109
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145308; cv=none; b=KEt78nS2TB6MYWBLfePFGf9NSF8LJJ9KEyAWGyE2KYaEp5PINpIru1IQ3yKk2sSbFM0buJVii2vou/t8S5XFz8ZfUbcE8oIGc393l/8BJJcRqMGhBcFE+CE4WO6LiVK9gF2XJPLKxoP+xppzQtfnLVZxAyhzblwRREjXvFK2icQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145308; c=relaxed/simple;
	bh=lM4E+0QDfWeiHiQEc8/d7xk75Z3XLq+R4ATU188GEVg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWQVg48Jzm270ybBRVfYDUS3oem7N+acQ/WJMyVbfCbZDG7ZiAZqHCXv20mGWYK1ug7BaJSb/xFN1gy05aeU0QsTPfOxWbPD/AwHBDKzLIH+r6WqE/C7bfTM4TZPOikfunfoBvTjBKR9cjekzco6DqVxZ0X/Lze/TL5eCkJfjck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=o0I0Kw42; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="o0I0Kw42"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6b79b93a4c9so11326376d6.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145306; x=1723750106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EjfT3NMblUo7sZTNjknqk3yM6nPmAl4UxLqtdr8jd/U=;
        b=o0I0Kw42ZFGX0/H6DLAvadPYxR59ucVUzdlSx2wx16xVACVdVeDa5j5CdDImTDno2N
         Cg5yhKqb0LYHFDs0Ibrd27lsHEVfzN4B800gsFd/XTXfoMQDxtT45UmJnNwPVsMEBsYf
         Nvwki25hOYz/Gcd5LSJpCFZHLeAVA1/YdYXsmBe0zl8+XPvaafrlfw6Cfs+L9MZPV/2+
         c6mXbLViGCbHFpO+GpTZmO+DZfhQl/mP3XQ1++zYstvG+3jgiDrPcgMnlDZlnRlRCiyu
         EKVE8ucWmsVc8Zepq3E2sxhik/5rrM+6oeXTG3KL9XGPDkegjt9v2LSUy0oehFtsQjny
         GJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145306; x=1723750106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjfT3NMblUo7sZTNjknqk3yM6nPmAl4UxLqtdr8jd/U=;
        b=jDIDoGISW0BJn4lVJIUiDOTkhgBgZZO18K50Z7/p0pV8DbJ4l72rDgTJpUmcVyyf0e
         Plv/v7FX9o+1D/PC2R/HBONE/uXoHFHa6iXXWHoerfrFbG20fPswSdeOljcHIz5/JfVZ
         JCjHLBwa1LCWx6zMdFijsnMd6mzAqnhI4MMg5v/IpecwaF/ZKvQlHfY9k40BdcBqkhbK
         AC8LsSIXSrOuUQMe2Wro1um/o1m7FUDM2pI9vs8o0SMBCBOHTXuwaIHdh5FvLLE5XVJD
         hkk/7hp9Z77/IogmDyJzeZVxGyXTmaaSdmq9QxQfX9Fe052ihutvVr6GS6B+32ErMCzi
         vKtg==
X-Forwarded-Encrypted: i=1; AJvYcCW3jbjES65mFM0+Uk8+qvy5IuIKZQjESYd5WTEIqCP0oWxZs9MEkP4Cg+DlAoqa61Gy6No8KwLLbLMWPWmyBmYPxiwreQ90kWpl8Tf9MkA=
X-Gm-Message-State: AOJu0Yx8lYeH2qVj5KOxMl2vi8U5q3xvFUZUOSrfGANv0EOMgeaxvkwA
	0JCS/6da33QFH7XvF/cCWwcmGGLs2nDNH1djYlZn9ClAPRfpap8vRdwShVjVH9U=
X-Google-Smtp-Source: AGHT+IGSh+lZaiCIMZedN+ZNZCZXZjbXsLY7KjtrhuBLT/ySiKQHjkhCsGdxbJMDj7u/JeFTXRzKag==
X-Received: by 2002:ad4:5ca8:0:b0:6b5:e761:73ce with SMTP id 6a1803df08f44-6bd6cb0fcb5mr41503466d6.16.1723145306354;
        Thu, 08 Aug 2024 12:28:26 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c76aceasm69502006d6.6.2024.08.08.12.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:26 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 07/16] fanotify: rename a misnamed constant
Date: Thu,  8 Aug 2024 15:27:09 -0400
Message-ID: <5d8efd2bf048544e9dcc7bb00cb9013837e3db6c.1723144881.git.josef@toxicpanda.com>
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

From: Amir Goldstein <amir73il@gmail.com>

FANOTIFY_PIDFD_INFO_HDR_LEN is not the length of the header.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3a7101544f30..5ece186d5c50 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -119,7 +119,7 @@ struct kmem_cache *fanotify_perm_event_cachep __ro_after_init;
 #define FANOTIFY_EVENT_ALIGN 4
 #define FANOTIFY_FID_INFO_HDR_LEN \
 	(sizeof(struct fanotify_event_info_fid) + sizeof(struct file_handle))
-#define FANOTIFY_PIDFD_INFO_HDR_LEN \
+#define FANOTIFY_PIDFD_INFO_LEN \
 	sizeof(struct fanotify_event_info_pidfd)
 #define FANOTIFY_ERROR_INFO_LEN \
 	(sizeof(struct fanotify_event_info_error))
@@ -174,14 +174,14 @@ static size_t fanotify_event_len(unsigned int info_mode,
 		dot_len = 1;
 	}
 
-	if (info_mode & FAN_REPORT_PIDFD)
-		event_len += FANOTIFY_PIDFD_INFO_HDR_LEN;
-
 	if (fanotify_event_has_object_fh(event)) {
 		fh_len = fanotify_event_object_fh_len(event);
 		event_len += fanotify_fid_info_len(fh_len, dot_len);
 	}
 
+	if (info_mode & FAN_REPORT_PIDFD)
+		event_len += FANOTIFY_PIDFD_INFO_LEN;
+
 	return event_len;
 }
 
@@ -511,7 +511,7 @@ static int copy_pidfd_info_to_user(int pidfd,
 				   size_t count)
 {
 	struct fanotify_event_info_pidfd info = { };
-	size_t info_len = FANOTIFY_PIDFD_INFO_HDR_LEN;
+	size_t info_len = FANOTIFY_PIDFD_INFO_LEN;
 
 	if (WARN_ON_ONCE(info_len > count))
 		return -EFAULT;
-- 
2.43.0

