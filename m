Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991D81D1F66
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670785; cv=none; b=A1wz93Z0b8sqh4IqhdstWT+RHK6T+YrZfOQeF+n5wNx4t9MHxIualGnlfO6mEjXmdhos5FhLMvZ6ETvg3k1r9QareVT28D24DV8UovfMVseBRDq+07GL1bU4vepI49lwL2ListNGvsjKI8RbmUYMKfHSs0oztZBmdRV/9gBDab4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670785; c=relaxed/simple;
	bh=S0mezk7lokrHR+8fcU6LAupASbj5zKj9YDRU//oGrc4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6OKoB842fqrMiFwYPAVWoY6S0P/k+HwYE8GmeD4ObrwhIPjUmNH4ugEgesPFaesyzM61Vkqao8ldWApddxHNDUJT4zElwqKZZRAntuHoEnnLT6MP1C+LeLpZHk+j4jttdh8piMboDH9P80nDCrpxZkvcFFA9hMfwiyfu1GllTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=yKYxjzMI; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="yKYxjzMI"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-79ef72bb8c8so13893185a.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670781; x=1724275581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/g0betjFPlSWGNNLN2rg+et8Qa/vCpguwAUALfab+wk=;
        b=yKYxjzMIHOKVD7hCfqqDbQ3M9MRTo7yLBD72u9lQJ+mFdhbDV088MXtG8urZrAPysj
         ybweUtaUr1xYRQjBHW3DQNwKBR6ilAPSyNAAgy4azinX3OB/tADp5lcp+O2Ao76NSl5W
         s3+SUN7NHq4J3Q3nBYeySTQ3XDRRkzuYWgokHzhhzEyFsSMOrU6fHRmzrADK2UmaS+sw
         sD5zjeXI7O0VSwDIQ8mbQfa/R0kBM46kV9F1c3m3bkfJgpk3+6b8oinyn11+cihhjfSq
         p80SBcXJJR6YPvjyS2+u5jPAGMxJqc5jGBkFwGpGNotkYebUJM1fS8IVHF/EZt02H1GS
         ngOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670781; x=1724275581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/g0betjFPlSWGNNLN2rg+et8Qa/vCpguwAUALfab+wk=;
        b=RM4maV2qtHJgUrvQQ+vsSO8EZ5bICh2HmFcOGinkVThMdiO3hSdhEjVZCGIFmrP6lU
         VSwN4TQ3utdeyMHOQ577KqUpL5msHfNrK9r9BoERJGHWYVZa1SxGlXCi73f8csdjtylW
         RTe1/Li5W4qhCaevi56FT6QpYdabFZCUboxNh/GuePZhkJQASlI8MTRVItS1NaIq+ZLA
         Er0eAW6eFmW71QFWLLgRSi1zBgAEoSYJuF/9If4py92/R96fFRQQhVpVhkOGtG91bj3K
         NbSFgoZYCcYPOl6FIFyiK1PtY08ObCNcngChcj9f1JvS5R3Uf3+eBSOs+xW8vK+NjsNH
         4rCA==
X-Forwarded-Encrypted: i=1; AJvYcCU32v5KkfZF53VgdubyWcLBfVDMZV/jLDOTTosRuQoFOrkW1A691agcGarqBWFgjtjTHjE5MPIVhRU2ONG+fpdhVPzENZ5xBM7h/RBBDII=
X-Gm-Message-State: AOJu0YxgJDez38S9b57jp2W6wpqTzyNWSTS7qvikH8E2U3uKrx55LKwZ
	dL7UDhLfFKmFJAZ+vr8DZ7+7fRHVA0UmnVJs4CwAGe8noEhTvZ934QsgMH105fE=
X-Google-Smtp-Source: AGHT+IEwLYSHYYTuAZJvUuE3hfd+/zuyGZIMkGIICNZLTcaMoU6Cqa81XGFABSQNoiEu298KSeXnZA==
X-Received: by 2002:a05:620a:288a:b0:79f:17d9:d86b with SMTP id af79cd13be357-7a4ee318773mr448400785a.12.1723670781667;
        Wed, 14 Aug 2024 14:26:21 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4536a072683sm480751cf.85.2024.08.14.14.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:21 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 16/16] xfs: add pre-content fsnotify hook for write faults
Date: Wed, 14 Aug 2024 17:25:34 -0400
Message-ID: <631039816bbac737db351e3067520e85a8774ba1.1723670362.git.josef@toxicpanda.com>
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

xfs has it's own handling for write faults, so we need to add the
pre-content fsnotify hook for this case.  Reads go through filemap_fault
so they're handled properly there.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc9686..e61c4c389d7d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1283,6 +1283,10 @@ xfs_write_fault(
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
+	ret = filemap_maybe_emit_fsnotify_event(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-- 
2.43.0

