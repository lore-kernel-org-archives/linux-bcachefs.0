Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D871C9EB1
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670777; cv=none; b=RCfPpxhZmZlj9WVSOvOrDEm56VqZbTA+AcNNtDO/MtZCa39VSchKHSZzw1reAS34G49h0exP74JToMs+DMRHZtEnnVQXQR0BBeihzS6+KFaSgUnSwjcyO+Gx56fyBB6SedjAgYXZd/EyBPb/+b3BeQkvXhLectnF9wgXMW/zPnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670777; c=relaxed/simple;
	bh=x/zxNttmCT+y0dOsXy0tvMYfEvnIhvz+MK7V5Zr+cWQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0PGEcD4Zpw2H9adYPCJrAgJCaOPgENwStxxO9t+Ngw9Qo2mJch2Gln3mZB6DONLkYfRY146r48dTVJqOQq6DeNIazWrZf5yfJ6vOmJm9t8pLqjhRlBtiEWf1hth+8NmOd4diKOpmUb0HBWgoJuz/8bjwRxxKW8xcFED/XJW1UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=en+qEQiO; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="en+qEQiO"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4f6b612fad4so122108e0c.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670773; x=1724275573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/Hz6ZhLh0CWwWHWSWJMj1KvT9KtOfMKuwzMM3GJFXM=;
        b=en+qEQiOETr3SYLmlzGaTW8td+fupQSJfA5ALa/ZpPCgoL/KymuDIrrW4ZL3ZM8RKs
         Y6BZf90ZpT9z4gUXfQEisEoMZOp8xeMLNYM7WDZAyo2HJ/2H5ZA25T20uH5yQhyCJoxL
         E22rBWBqqUpE7U565sQuVT6sL7GWEuIFmS4pdJinGK4zbHJci8OR9L+0/9SujHvHXjrU
         V7oJlPqe/pZspkoGYu1Bofrskkb1ZFoxJP34D7rqrB32Li32R1N/SuIa3/1PCwxeayil
         l186EMeikpBxDEcF3zrXa2J8pxBIOcK6nygtCvCEa9KJ0KyrJruQjesS/Gh1/Rgg5MjQ
         FE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670773; x=1724275573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/Hz6ZhLh0CWwWHWSWJMj1KvT9KtOfMKuwzMM3GJFXM=;
        b=l5YUU/B34EcwAlOdLsC8XEZL9oxZIYswNGx+48Gp68nedFYe6kXxDP6iL7x4fsy5d5
         ITbEVXXuhKQEdskPKMQoIbG2FBaD8OcFs7dz2VzvIvfaCuwanDPvbvkMfbTzKeMNWdKG
         PMAtYL5ZUYovsfB/pOnCvbnElgkcM/tp4Bzg0Vgt/PBDoOZq4QbEgXNK2jQROCNyUa8o
         6xh1AbiXCpdN+pYoYDPYEAwN7rcIU5tJJ29xD/na280YBupyXs2ViY2gVJzJKuFB95qh
         xFIE2K14B+WH8B8Y3Pw8JiWY7uQs6WBFEOKxSItXAdTWwhOjWhrb6MmkU5L99E+lem4H
         JPiA==
X-Forwarded-Encrypted: i=1; AJvYcCW3xwZmVgjt4jVi0rX47J/PTOQB0SPVIFpFvzwTApz091Xw/G9uUw5MhwMHUdGQCYD+VSbDOjhnVpBtMUmm88/MklEP8UXBHTUpOxQPKqg=
X-Gm-Message-State: AOJu0Yy/zAHxLMbpLasTFbwSW2XEUAs3qOw6vOLx0dinMIgEhjPyl5H+
	g8fU68+r1UdTCH2N17U2eJ+i3zMZpuwUPNc1Qnlm6CV9xMqSZaV2VALInQZjYds=
X-Google-Smtp-Source: AGHT+IEgvzETar+HRop8OxZM9BBYNdvV/dcg/BqJjJoXGsdJI9+RkgFTa2pKDMrLYqGGS3MRLjx9Ew==
X-Received: by 2002:a05:6122:4699:b0:4f2:f2e1:5f04 with SMTP id 71dfb90a1353d-4fad1ea4056mr4448238e0c.8.1723670772920;
        Wed, 14 Aug 2024 14:26:12 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45369ff11d9sm557421cf.21.2024.08.14.14.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 08/16] fanotify: report file range info with pre-content events
Date: Wed, 14 Aug 2024 17:25:26 -0400
Message-ID: <b72ac7d8171570eaa9adf05e5a55f6ea8ba41ac2.1723670362.git.josef@toxicpanda.com>
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

With group class FAN_CLASS_PRE_CONTENT, report offset and length info
along with FAN_PRE_ACCESS and FAN_PRE_MODIFY permission events.

This information is meant to be used by hierarchical storage managers
that want to fill partial content of files on first access to range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.h      |  8 +++++++
 fs/notify/fanotify/fanotify_user.c | 38 ++++++++++++++++++++++++++++++
 include/uapi/linux/fanotify.h      |  7 ++++++
 3 files changed, 53 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 93598b7d5952..7f06355afa1f 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -448,6 +448,14 @@ static inline bool fanotify_is_perm_event(u32 mask)
 		mask & FANOTIFY_PERM_EVENTS;
 }
 
+static inline bool fanotify_event_has_access_range(struct fanotify_event *event)
+{
+	if (!(event->mask & FANOTIFY_PRE_CONTENT_EVENTS))
+		return false;
+
+	return FANOTIFY_PERM(event)->ppos;
+}
+
 static inline struct fanotify_event *FANOTIFY_E(struct fsnotify_event *fse)
 {
 	return container_of(fse, struct fanotify_event, fse);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5ece186d5c50..ed56fe6f5ec7 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -123,6 +123,8 @@ struct kmem_cache *fanotify_perm_event_cachep __ro_after_init;
 	sizeof(struct fanotify_event_info_pidfd)
 #define FANOTIFY_ERROR_INFO_LEN \
 	(sizeof(struct fanotify_event_info_error))
+#define FANOTIFY_RANGE_INFO_LEN \
+	(sizeof(struct fanotify_event_info_range))
 
 static int fanotify_fid_info_len(int fh_len, int name_len)
 {
@@ -182,6 +184,9 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (info_mode & FAN_REPORT_PIDFD)
 		event_len += FANOTIFY_PIDFD_INFO_LEN;
 
+	if (fanotify_event_has_access_range(event))
+		event_len += FANOTIFY_RANGE_INFO_LEN;
+
 	return event_len;
 }
 
@@ -526,6 +531,30 @@ static int copy_pidfd_info_to_user(int pidfd,
 	return info_len;
 }
 
+static size_t copy_range_info_to_user(struct fanotify_event *event,
+				      char __user *buf, int count)
+{
+	struct fanotify_perm_event *pevent = FANOTIFY_PERM(event);
+	struct fanotify_event_info_range info = { };
+	size_t info_len = FANOTIFY_RANGE_INFO_LEN;
+
+	if (WARN_ON_ONCE(info_len > count))
+		return -EFAULT;
+
+	if (WARN_ON_ONCE(!pevent->ppos))
+		return -EINVAL;
+
+	info.hdr.info_type = FAN_EVENT_INFO_TYPE_RANGE;
+	info.hdr.len = info_len;
+	info.offset = *(pevent->ppos);
+	info.count = pevent->count;
+
+	if (copy_to_user(buf, &info, info_len))
+		return -EFAULT;
+
+	return info_len;
+}
+
 static int copy_info_records_to_user(struct fanotify_event *event,
 				     struct fanotify_info *info,
 				     unsigned int info_mode, int pidfd,
@@ -647,6 +676,15 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
+	if (fanotify_event_has_access_range(event)) {
+		ret = copy_range_info_to_user(event, buf, count);
+		if (ret < 0)
+			return ret;
+		buf += ret;
+		count -= ret;
+		total_bytes += ret;
+	}
+
 	return total_bytes;
 }
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index ac00fad66416..cc28dce5f744 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -145,6 +145,7 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_DFID	3
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
 #define FAN_EVENT_INFO_TYPE_ERROR	5
+#define FAN_EVENT_INFO_TYPE_RANGE	6
 
 /* Special info types for FAN_RENAME */
 #define FAN_EVENT_INFO_TYPE_OLD_DFID_NAME	10
@@ -191,6 +192,12 @@ struct fanotify_event_info_error {
 	__u32 error_count;
 };
 
+struct fanotify_event_info_range {
+	struct fanotify_event_info_header hdr;
+	__u64 offset;
+	__u64 count;
+};
+
 /*
  * User space may need to record additional information about its decision.
  * The extra information type records what kind of information is included.
-- 
2.43.0

