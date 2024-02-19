Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1032182
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708350915; cv=none; b=ltoMtqObmPguZ55tbMQAUZjafkpvdBktHuRwvEWYmIdjl/zMXA1yRHOAD7ydQtma+mfkc8mSyecr9WI4P7gvzA4JCkg5FcbleZ4oERvg6PSGvycWz0XmrEa70FFt6zj5xCJCCP/VxzoRekNExa6BXdWDuiPCInGRS7TnIZd9LCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708350915; c=relaxed/simple;
	bh=cDkvW9Q/kv80dCZTJtgXl4KORvMZZ++sZ6P0cqnMCQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FxfQLeCqI1PYU54Jab9BAO7KfmPY2c+ffE7A2QCx2c5HyNobKgLqmfHJcl3iS5kzHFEyeECPzILqx5YzE0j8p2y2BoONq+oVvniDNPO2TIuNsOFiIOHPjG6a+XK0CtwhoPxWw/hwBGsi30bu+O702zFfkojJgEiBQ734lcvEaGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=kmJeVvqJ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="kmJeVvqJ"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e22e63abf1so979664b3a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 05:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708350913; x=1708955713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pAmYBNZ3LUxsG2e7e+2NeNhPKtf3kaPqY+vt7L5/YBQ=;
        b=kmJeVvqJ7X/oMIFOJ/EUabPO8N/hw9HJnbSfPzGTdNQvwEOW1XDkBoene3m94P3pRJ
         tb0yWjpjg2o6UFq7NciB3R/gjlv29EkoadiDM8QzakLKfTtmLk7sUMpwH1OtaUGL7sot
         +lJiSYSPSH+LHdhJIBRjW/rq0vLM/uriP08muxW3vb86sCU7JILRX3XQMQC/VK/b3C3/
         x1J+8gjNAxfGW4unmMIx7JuR4MUgeEqW8/lSBHUu42X1m5bvV5cxVN1nODRB9+09Nsgv
         BQ6T7OtMSESXJ6j/i8VFLxhxjAnddlSmI/PiO/BDz/Cg8c1AlhrVwEOWQ8ZwnSr3Hvii
         f5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708350913; x=1708955713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pAmYBNZ3LUxsG2e7e+2NeNhPKtf3kaPqY+vt7L5/YBQ=;
        b=I8/+hlJOziXQhWlZh+FlcnTMbN71GQuy9LJIExSMAYbh0cgha88FoqoBd0XJj7pCeE
         6Z54MUpcvMC1Ovid4CF/iq5Hmvv7OhPk7youQ8o6ENn/DQd+1GtnZo+9yWpfcW9vewrP
         xuhppvZaoIwKg6opwfetR7INHr2yvYzxxvsaS1Eq0VLFXzf+zjCcIff5VKclhP5L6DiU
         /Ch8YntNOxu0ExWglGwN2InVntg7doyGmt5CWew6ZVmJVw9BeHzSabFUutBW4onhfZly
         2ydRiMBH/bFWfkfStsf3VibpprbyFCp291C3YeGX+/qfUYEx2oiyw0jKenX9LGR5PLAM
         sUNg==
X-Gm-Message-State: AOJu0YxVPGgA6JPeejMAfJ59+ULybfmm0tDXQJVtXZs1mXyDZ5+CwQdv
	Q/8NGVMZ4JBK0yr7C8JkNFmKUThGchSvBjFDGri6cNx2qTPBDlCsC27VFQ6w2+R2ROI2vU0FhqK
	1
X-Google-Smtp-Source: AGHT+IGIyKwcG4SJhrSBsfV+3PwhGHGuwXGGzAj+rnj067UUs+aGGZWsfXs1/Uksicqyz54jFUPIqQ==
X-Received: by 2002:a05:6a00:9395:b0:6e4:7146:f139 with SMTP id ka21-20020a056a00939500b006e47146f139mr962374pfb.19.1708350912264;
        Mon, 19 Feb 2024 05:55:12 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id k13-20020aa788cd000000b006e4641f578csm1853499pff.189.2024.02.19.05.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 05:55:11 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 0/3] *** improved shrinker stats ***
Date: Tue, 20 Feb 2024 02:28:37 +1300
Message-ID: <20240219135425.885068-1-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since you asked so nicely Kent...

Daniel Hill (3):
  bcachefs: add a printbuf formatter for percentages
  bcachefs: add btree_key_cache shrinker stats
  bcachefs: add hit/miss percent to btree_cache sysfs

 fs/bcachefs/btree_cache.c           | 35 +++++++++++++++++++++++++
 fs/bcachefs/btree_key_cache.c       | 40 +++++++++++++++++++++++++----
 fs/bcachefs/btree_key_cache_types.h |  4 +++
 fs/bcachefs/btree_types.h           |  3 +++
 fs/bcachefs/printbuf.c              | 14 ++++++++++
 fs/bcachefs/printbuf.h              |  1 +
 6 files changed, 92 insertions(+), 5 deletions(-)

-- 
2.43.0

