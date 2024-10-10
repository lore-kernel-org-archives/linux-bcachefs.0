Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C501C3316
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728566517; cv=none; b=m3lOjet9P2cAEjAYtoo8Ra7cayGh2nn4xGwnIClEnkSQvcpgTJSi20En3FRd+sl163DISu0twv2NnfNf/l5ANzkGw2z4v+gAd5FiUgcUktqjRLxaG6Obkl/2gazn0rgdWfJD07tt5JgGdywu3n5wb6eMj+mSY6J0LNfG1QnOH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728566517; c=relaxed/simple;
	bh=HvycsQLOELlTrtsvonbemGU8lh7eK1/FDYVyHxjlRbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rSIsNXfjnQ+vdEREy43R2btqZX/2E1Pv9y03Au6dfZVxvAv4Tg/lMZexF7Xr6lnt6mJxVXK5bJTXooZNDQT59uKqTQn1RoN5Z7WAgZUPEEL2v0JiOvtsw995nFxD8hdeA7o3ratn+i14JU4mXWeGlMROY3tLkollwlk6Jj+/jds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7X2pC5U; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7X2pC5U"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20c544d345cso6403805ad.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728566515; x=1729171315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4bFaXFUiqmyQDLS25LetGM3WmPC1TTq5PD/TQMNOxQA=;
        b=d7X2pC5UZi6ncd3Ze0AB2bjfwMKagCZ1aonGWSfhY5kPsbhl8HkKDw7txca5Wyk0eN
         H5bE8shTvb/yjWKOXY7qQCn44yCQ74jP0kd/kCSNkNm7UojGqFncUryz63rNxEQbSP79
         TIUYHmChbhTaJE3kXlrJw/uR/maIXHNFR0Og0paI9i7AUyWaLz0nurETB06KVC9PhVbc
         vUb8SgeMQPNDDHAKyLuOIP0uLVsxB04fstlMV3Kx4lSplalWU+/WlUSYEaaXDZncZww1
         LvxSY/YXPqU/RjJf0wNB/wOM+A+e8yNfkQ8ioL948LrW5X1HN4XvMXsxcxiK12GfxhGX
         5alA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728566515; x=1729171315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4bFaXFUiqmyQDLS25LetGM3WmPC1TTq5PD/TQMNOxQA=;
        b=Bfm0Dp7NN2wgP0nE77ZQbXJX+9J4I8PFRCg8piIwsfyBp8ws7S+DWozm5b+QwAtCz/
         7jktQqmEhjm5H0FUqxcYBPkdI4IRYcVfBHWnqQTJ9QiT7EDLcW9oPfjn6xY1D7/doaPq
         YNshAMPTZhDINXKKDaPUq6lRXwdjrtfqHQH4viBdR/Tn9dISJj4vnQVlt5bWgOc5T3zc
         yuRa1TW0qkHFsUH+yjn++IPM9f7tXUIzKGseAIAbFLDIbJL29MtmUkhv9CP40vMo1dDk
         di0fnFxG2KG1eLdzvfp6gZw60qElvtrx2h5Ic1EMuanJeP4FuPmNLTOL7bmrYRfZQlm8
         YsLw==
X-Gm-Message-State: AOJu0YzWzJSNdK8++yMZ0U9fz7MBib1p5YfU9mFXpyFjZKqlW9Y2yCAn
	qLI14kNIPX1TUMYQFx94MKZUUpZWFN3qh4V4beCscy08+cEgf41OlmmmCPYc
X-Google-Smtp-Source: AGHT+IGAyxIVOs62Us09D6cR2LVLPe5QMOopYx/GYaFmNqeetlCcJYf+phwDepdAUG5GpH2WDlV8jQ==
X-Received: by 2002:a17:902:c406:b0:20b:6c1e:1e13 with SMTP id d9443c01a7336-20c804ee35dmr47075865ad.23.1728566514768;
        Thu, 10 Oct 2024 06:21:54 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0eb7a2sm9365965ad.157.2024.10.10.06.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 06:21:54 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Do not allow no fail lock request to fail
Date: Thu, 10 Oct 2024 21:21:50 +0800
Message-ID: <20241010132150.1814411-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the transaction chose itself as a victim before and restarted, it
might request a no fail lock request this time. But it might be added to
others' lock graph and be chose as the victim again, it's no longer safe
without additional check. We can also convert the cycle detector to be
fully RCU-based to solve that unsoundness, but the latency added to trans_put
and additional memory required may not worth it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index bf25fd0a1cca..fff176382e30 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -293,7 +293,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 
 	g.nr = 0;
 
-	if (trans->lock_must_abort) {
+	if (trans->lock_must_abort && !trans->lock_may_not_fail) {
 		if (cycle)
 			return -1;
 
-- 
2.45.2

