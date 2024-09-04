Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07186172760
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481770; cv=none; b=fGxGkEYKderRkSoAE4AX4tQsJ/PtDzrQG6H2oq/H036XIIvyf4VUM59pg8l1sCrBMl84hKdv+Ixmch68hyQAG4el6jfHdWw3LNzYW3+0HNsLiifqfQ7vtzdlegLtdHouMXVQs58wFuqpRIIOIUJ6o6xarFfOQKKa3TuUyJ3Nykw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481770; c=relaxed/simple;
	bh=UkBoQACwZWNS66VUS7nQ/E+uy/3pz3xN2YqDEBSBDyw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3vlJokbaIttDeFnQqlLZ9phAnPXSAqt1N24knSLIpf/jaTWwKkoNRVV5bhnYc4K85EWC0+w8m3WX0cqsW2SHk/soAoagc78ifrT+3YPXRnzzdKBbcErZXXi2TyQsTDk6o0c/XiJsHdf5TM6mrSINvq7vo6lTM8qpVLdpxy+kVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mdhpT0tG; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mdhpT0tG"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7a7ff6c4fd0so1616085a.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481768; x=1726086568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kdFADlNMi9J5+Jo97YgtLX17z0QeGZLAaqk7oAQuL90=;
        b=mdhpT0tGPDmH7J6XLzDodwE6DGwnaSrY0JW+v7D6TVPxyccLmEFXz/cxq37IdLQLEA
         AyvZO0deX815OA++zxzdqC3KDTmSV4gsUjiWE/K86wYLFRMbr01w5UeH0t5SNp4Vg2/4
         meaw6/HNo724mJzJJU8iEPvnRNHHCzcaCkRq5/Embp/YyByUk9iAWru1YDscrfby7MvS
         2+ycnd7/xJX5nlQfWsFq+yaErpj15Z6lqpQVU5kS/kJ6/xleoqmr9hHnI5UAh/wK7Ykp
         04xmVLXCqSmr+phqe+tAsVECuQi/eiWgZLcIqEPdmgPRXqy7gA1wiA6sFQHggyU+SxII
         3iRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481768; x=1726086568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdFADlNMi9J5+Jo97YgtLX17z0QeGZLAaqk7oAQuL90=;
        b=iENbcSCpwIJHOdl0X8nQxyJNqlzZ/aAG2nyZo/RiDu3p8/kjK1DBfSgo3RkzAaeKVY
         TeUxIrCzbI+Jvi99ANVQOrukMh0IltOxLZ4YX+a216T9ZkSV4oNCQR2f18rlraWuKfj1
         hpwGPar1blJT+2dSJ7dIWG2hf8osmWgbYr1ujV+pNVFbGUp4qDydrYuZnFa53zyd+VrD
         VAPzGv2/EjOaAiNqjzYvGfjy/1GsjnGaNYvVq6Ai0dlwLjWn3TXylZa/KHhIMnybf/rS
         bKpu8seyoDiTcBqs3o4IHX7JvbxYfAmRon6lh5G/k8pL9z2tEzOiO2ZHcLXg0ZDTN9pX
         SBKg==
X-Forwarded-Encrypted: i=1; AJvYcCU+Xsf3KK7JnpGdHP12xFhg7AssDAAs4qjb9pLi7memGxa2gEjA7jz51NZO1l468rAUms3INPudxBXbgFA3Aw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+CNrkCAnLZawdTUvaf9CwnlezprMZcfXNc+pjz4aoZPdU8o9c
	8XI1TbwS91tgQvYE++yQwQsjDGyHf8gnIK7LLSh843iiUcfqDnYk50h+cBlXBHw=
X-Google-Smtp-Source: AGHT+IGx6um9uXhEhda5h73KKWCoNW2FF/dwyP15+JSEZ33BwCH3HCg2dZ3AYVIuYxLr9QIEDkXCMg==
X-Received: by 2002:a05:620a:1724:b0:79e:fc9c:4bcb with SMTP id af79cd13be357-7a8931ddae4mr1887788985a.11.1725481767911;
        Wed, 04 Sep 2024 13:29:27 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98ef4a2ebsm15638785a.67.2024.09.04.13.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:27 -0700 (PDT)
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
Subject: [PATCH v5 08/18] fanotify: report file range info with pre-content events
Date: Wed,  4 Sep 2024 16:27:58 -0400
Message-ID: <0833eaada39f0a33e655b47f2d15a5a37cf39a78.1725481503.git.josef@toxicpanda.com>
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

From: Amir Goldstein <amir73il@gmail.com>

With group class FAN_CLASS_PRE_CONTENT, report offset and length info
along with FAN_PRE_ACCESS and FAN_PRE_MODIFY permission events.

This information is meant to be used by hierarchical storage managers
that want to fill partial content of files on first access to range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.h      |  8 +++++++
 fs/notify/fanotify/fanotify_user.c | 38 ++++++++++++++++++++++++++++++
 include/uapi/linux/fanotify.h      |  8 +++++++
 3 files changed, 54 insertions(+)

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
index ac00fad66416..6136e8a9f9f3 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -145,6 +145,7 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_DFID	3
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
 #define FAN_EVENT_INFO_TYPE_ERROR	5
+#define FAN_EVENT_INFO_TYPE_RANGE	6
 
 /* Special info types for FAN_RENAME */
 #define FAN_EVENT_INFO_TYPE_OLD_DFID_NAME	10
@@ -191,6 +192,13 @@ struct fanotify_event_info_error {
 	__u32 error_count;
 };
 
+struct fanotify_event_info_range {
+	struct fanotify_event_info_header hdr;
+	__u32 pad;
+	__u64 offset;
+	__u64 count;
+};
+
 /*
  * User space may need to record additional information about its decision.
  * The extra information type records what kind of information is included.
-- 
2.43.0

