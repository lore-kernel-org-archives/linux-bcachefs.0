Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C3E2566FC
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 07:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759132612; cv=none; b=B2yBuRPxbtPQQ61ORvXRMN52PTlgB7LmrnqL4uXeYs8UaieU2nifvaBo6oDhHLtr8so83AHpf/KIQOtuJzcnSwJFbI87bBwxU8jmfUvxK6m2nShnMAWJNJyh9a2l/P8FZ1QLjm3BpLaVjlnfJZ/sZfPYiMkpCNA6qsSyJTnMKNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759132612; c=relaxed/simple;
	bh=h+btU/06FxrCE0fKR+iLH1QhbcgKx3UJO4wJhGrFibE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HxFIWMA8YA4l/ADEkvDb/TJ/4L4GxAnObRvBqBtJHZ23gFaX5o4W0nfkkelZborNLSWOCjBHMEHDhylwRagBL09LBtrHDs+vE3h2Ut7M18h5t8o/c329T71ZDmzAzVXoCPxBk0nBcAv2MKvtmolBlcml9dwhbg7+hqFvW2QUF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=abWVC+oi; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abWVC+oi"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3322e6360bbso4180922a91.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 00:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759132610; x=1759737410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TDEdpB8zoJ5Ds6qklOPF4t9lxpIQ0+5rCmFrPNlgPiY=;
        b=abWVC+oif83mtvZcHsTnnhgwM0s+mvcKIoKxoqrWBL8XwFHTXiME8AaamOmY3tPzJb
         EDQWY5ltLwUHSDGhCUtF0OwFERBOMTYm7BkXltsROUkrLr2Xory65lIOYFEphp/nqpp0
         EzjN6Um9xaGnBGY8dOriEgjnNNYW8vfQMAMMCU8iQLe+X+BcR2bdg7T8CqI22/yE+VlZ
         QZqFjqK67R+qG39LX6EySfEtdm+XJ4/02Jrc+bmO86M6+YGZEPrXzVZzZEhRdrIXurIg
         ODNFfvHv4LvQf15ztZ5NGDle3dz9OI6hUq6lvjhhj15jdHjzGLLLCRJF3kx8qrUcjoJg
         Yhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759132610; x=1759737410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TDEdpB8zoJ5Ds6qklOPF4t9lxpIQ0+5rCmFrPNlgPiY=;
        b=uxKApYqqhSeaELOelvwHzkMbnXLF+1rHkZvl87dIm1Hu1NajkXncsGR5ssn2KQfHwb
         t4BWCgOedr6k60KRXs2p5wTBBYX6PZNeeSLsRCy7oZ9W4bpUdwdD6Bbsoko92Y+LP9gT
         avmHG8y7A8PWoR01Nvq3Yzx6fBvLiNXdXqcySeNiBozmzwprnW/2iH3VBimDsCdQu2S6
         zYSXTuD3YaYAQY8BLRPJV181XIrphVlC6/IuMdbpoj+mu6OFryMthev2UcYAXdd8kW72
         LRvVMHTBleEuhFi6wNv67YG/rNrBSWElLGlXEbhtgNlkonNg5BmRPAjllAMhzQ7sQSLC
         ej5g==
X-Gm-Message-State: AOJu0YyXRpD+8nQ98tKF1ttrvcokKgENl2B4nza0qaY0AiHayrVwrXLR
	Uc7FF2PZanpO0a6ZyA8qisty9gBBpf3JEMcuR33xGYIAJArpjMQjj2+BlOs83gkgeX4=
X-Gm-Gg: ASbGnctIe/4BTZzA8V0YFEHoAED9KM83s32v5bQtWm87ClaZBOoRowhVSeyvvAJGrTH
	S+1JSP6gGefn6Ek4ZrLzDmIF/WJ1+bPFgX1VV3tqlJsrDW6Ks3Gei05k/a5o14RmEaO8rpFCKBu
	Xd2nNR5U69uKNxKRLUcBql2hVwZiD+YNdYrmjvHGS/pmdc5XT0FwGLjthwzFAL5csC1eH+XyTCC
	KiRFN7jX/s8nhwGnIAMm/NDsJb4Y2ZxeHYVL6sVN5Zhc3Bc0RlJzlSxhvWJdooZMwx7z9DLhnHP
	0FC392twsJU2gxpbw+rQ4YEeFS998Hqx0PC4rtmzReQqovpXgyfxNt30dKDC3XH6Tdi3go6aiZQ
	18Zv+LbAGZXXTTGTxzjUi7E3C+566FkHIVypNAjNtVzWnf/0JvxvaKKthSJ5M4ilv4RyZCfnaz7
	iIwQHFCt4/N4Dtug==
X-Google-Smtp-Source: AGHT+IGRomaNwogJ4YJeLyfoYJL9WLvFP1cUCEllVYkQzMrcgYurGjV4rDtcFdnkKfabY0A66dSoWw==
X-Received: by 2002:a17:90b:1fce:b0:32d:17ce:49de with SMTP id 98e67ed59e1d1-3342a2497d5mr15967819a91.4.1759132609962;
        Mon, 29 Sep 2025 00:56:49 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:10a6:37a8:772f:4db1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-336bfcfc8c3sm2071443a91.11.2025.09.29.00.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 00:56:49 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re:  [PATCH] bcachefs: Fix deadlocks between fallocate and readahead
Date: Mon, 29 Sep 2025 13:26:43 +0530
Message-ID: <20250929075644.338686-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


I found that bchfs_fallocate() only evicts pagecache when FALLOC_FL_ZERO_RANGE is set:

if (mode & FALLOC_FL_ZERO_RANGE) {
    ret = bch2_truncate_folios(inode, offset, end);
    truncate_pagecache_range(&inode->v, offset, end - 1);
}

So basic fallocate (mode=0 or just KEEP_SIZE) doesn't evict pages and shouldn't need pagecache_block_get().

Should the fix be to only acquire pagecache_block_get() for modes that actually evict (ZERO_RANGE, PUNCH_HOLE, INSERT/COLLAPSE)?

