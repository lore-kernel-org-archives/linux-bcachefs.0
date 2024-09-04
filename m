Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A81148307
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481783; cv=none; b=pevXofvdyOzCw1lmom1457GO7tvfgvb4312TdO0dpFb1a1lsrCJCc/1Mvui+jAuvlZ9btkqgte6FSfbaM0yElmGQb9KFPaE8+DKMoiwIAsG06IynGAaz05SMFo2vhKoxV2a2KA7Ej5ePgilI71Rdvgh4M+LFQFR0ilBG8YHolHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481783; c=relaxed/simple;
	bh=wT7ZMo9Fh5VSq1s78YBc49T5i3a6aTxkHXKOOzIvwHc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AutPQ7cyg9qu6mAcsoqwQSa8nB9jmCN93cQojGtI9DBItPou1xnNaZ28rxmIOsHSKn+9FvNT2SyUieuvkeGAkUjzJN8IQ5MI3fqg9yIDmQw5AInRh0Ic87Ds/QXcZo5XbjL9D7XTsO+EormivOd4qx6pgUcEeSOLKumE77KayQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mrbXx0A6; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mrbXx0A6"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3df0c4a65baso4328794b6e.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481781; x=1726086581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Z8sRCIfMieTISA3wuOPUcg1dm1vDp7n73Jg7OelYjY=;
        b=mrbXx0A6WH/L9F/fPw/ggso+cBDHyN1A7GYeDwwPskP0oJm2agj6nqKbMLk43qqGT2
         dIVvyTxbpUH2jTTkV2zEziSapTSRkwe6efAUMfczFha383yN2+CuTw6uzf8xVdqMgzVc
         Oe4qViReBFdwQYDxuq8V9hypR4kflvZbj/wdfKx6ZCWDVupnppn1QlUaFZNAYUfIfVnu
         Haw2a9VGKovzO/IqjQknOvYinhGLt+MKRU/PCk/caewdkcnHKCiQgGd1iNnlDuARJsUN
         2iK7Z3yafW1WPsPa7auDME3hQ5ZKuEI285FanwPCqh879HZ1pc+31u5MRZCVfEOS896L
         e9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481781; x=1726086581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Z8sRCIfMieTISA3wuOPUcg1dm1vDp7n73Jg7OelYjY=;
        b=pgQIWB/A+VJjrzOHU2ctFLqO9jX/4nQVuFzEYx2o4/f1R76Yt565Lmr/etLTFYvLQV
         v8kfCZ17+/ZL2q8kEgDVEIrTiEuKaNP/WapKqjkEB7JsGDU2nGelNO17ly3bF1if4uTK
         D8K87qr28GV80u+dOxBPvdZLBJVLzKrEQF8Z49MOLaMuIwk5gL6Lr/Q5sl7AU7TgTrRW
         Q4BizN3Pp2njwUaQ/wDTz2uIGZmOQSVwmIRQrL2vv8mJ/ePM0wS/igFjZIG/Vm/t/fQa
         NG9NVcHoDzJpEk6h0JVEc19uGOGptKhkmZIkoPbqYvEu5Kii3PPOBbpMGWt/IbEt2y4a
         yiFg==
X-Forwarded-Encrypted: i=1; AJvYcCU029ZZQDjJP9ZW3rvasngDEwS0ZEjHSC+Qp+0WzeA9+Dn3rX8GVWfbWwRgRpplhWxk1cnv2dMHzzT8DZ3fWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy09m29FZo3esh9G3TUvfrbp/xyohzFK5Wi+3HH9H1Cq9CmoJWO
	QHmvafRo612pyJ3Dms8VxihAcdqv/Idfx8fn4Q1kBrlDfqTscBobELFozh2Y39VDtNdTkXDw+Cq
	l
X-Google-Smtp-Source: AGHT+IETtHQ5ywMiUmPhP/0afBVUyPAVLJijgZTnYTfqkdZL3bCN8lBGOnkAyW3ORokI+fooL1bn0A==
X-Received: by 2002:a05:6808:f13:b0:3e0:483:8bc1 with SMTP id 5614622812f47-3e004838dfdmr11138749b6e.43.1725481781057;
        Wed, 04 Sep 2024 13:29:41 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45801cbc493sm1441111cf.69.2024.09.04.13.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:40 -0700 (PDT)
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
Subject: [PATCH v5 16/18] xfs: add pre-content fsnotify hook for write faults
Date: Wed,  4 Sep 2024 16:28:06 -0400
Message-ID: <12aebe1a4f039d0234ea74393a39614c0244f7e0.1725481503.git.josef@toxicpanda.com>
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

xfs has it's own handling for write faults, so we need to add the
pre-content fsnotify hook for this case.  Reads go through filemap_fault
so they're handled properly there.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc9686..3e385756017f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1283,6 +1283,10 @@ xfs_write_fault(
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
+	ret = filemap_fsnotify_fault(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-- 
2.43.0

