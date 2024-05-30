Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE5033FD
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 01:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717033104; cv=none; b=q3Bf+1RuWeXeQAiwtYqPJTeAJ8pvcXNLJdvTXmR12+/HVwDDs6/uvLYR+RJ9MvLAyVB5y4gIl5AvT+AIrHygsAFbTT76qz0XT+OOhLHJrjj2uuR5iBzYCCqusiulWIf1TPtRM8dj7tD39UStIiUr13qFPTQiDCjm1wnaOcW52AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717033104; c=relaxed/simple;
	bh=XMxjod/Pp7+WR5gX6Y8nvH3GHdgB/Jo4u10U8rCOcMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q3cujyTz78bo6vfAnDrgMxntqdyVCHh7zQEUdOPEPu7XSZr6p/WPPdD5EqI0HhSMLJXZq1U/RXgF2dIFdOZ9AdaYXsVTDOwOnDU7mK6SOBfYoAzzK/ngXA1o+2E19hgOVVJ1IVoFYi86XeWcjKbSZ3mHQpElg94o1f8ckxjgfAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvqYx+Ia; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvqYx+Ia"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3747e9f7cceso624205ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 18:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717033102; x=1717637902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NWXXWo822EBBoKXoPILgkv6rd3kXkruyS5PuMnu9h+Q=;
        b=SvqYx+IaUm6CizHaW1/Lp4yJjzIduzOolSttXVjikKVhdP9KN6yuQpWtc8u2rokjZE
         x8kxPH1LvU2LgYWIXL7xb85Pjr8IJesplS0r6jRQV83R9KLmrLUJdXOiZepXSPrDRNLb
         9Q+0c8XUt63WB8tfUFI2/Q10YgTsMbKwoKFkW1iVW4b/hJaYVao+M5r+ig6/nKa7WCJ1
         0GJwkU9JWMm2cJt1ZtyVsoSk+VzAjQwLpHjY6udkjeaojAkS2pE5FVjfU01TbCouGasf
         kXQ6T4Cev1Ks7UdjoisUjC+yzAQnh7RECvIOQD4VbM9BZY8wMyh5wEW8P35K5fAuIJ1R
         RbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717033102; x=1717637902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NWXXWo822EBBoKXoPILgkv6rd3kXkruyS5PuMnu9h+Q=;
        b=hcsDpoTS8jJ02WVtuAUahgLUjb3/W3W8lqeIVg5CObhGvtzNAn6Ny2Ibdplju1Dh6S
         MpEvMb5UNrRLZnsnc6OV8ji0H2q0wkpAt/A+g8Jn73ZTuBgnFty/Xt5+YLi4VD6dwg6Y
         IlPZd6XZ1buLlN6DyZZIbtf4w/UH0MldjDDescxl7URUxcFR7w/DuihmRXxZWb6IJFRy
         6aFEKlZrnpBev/FfruqizQGtTATwQJh+1eihAmLOzn4pp9ED4nO90WyHteqhTvR7NStI
         yC5Igeo+0Cvmq3GYP2qzQcXq0UmjLleZbbietA9jknBYbBDo2H9J5X/8rj8N08rV6+S1
         bbmg==
X-Forwarded-Encrypted: i=1; AJvYcCXSDrdlvCXdqMbfZz4g1WBudaettMWfB0f2J6lSqZVZkCw+2FWX0+Vi0MAs1DyT+KPSAG0KjfpsNRd21KlIB9W731CDJwI/GBO9X7y/x28=
X-Gm-Message-State: AOJu0YxnyRFrzeeOdWKarU0iaoHmOXzBdWc+1ff++FStH5SWoqpWd3ig
	4alHDBM/ITqiUKpkLkl21asgsTnu/k5GoYoyyhGcMSMWsbll7gxX
X-Google-Smtp-Source: AGHT+IGqdY3TsX2H7zB1wieQ/vnKy7KWF+K5e0cfaEBCgF3kkV8NB/1DF3cHeneXlDwJTO9IndRXmA==
X-Received: by 2002:a05:6e02:2161:b0:371:252c:d8f6 with SMTP id e9e14a558f8ab-3747df640ffmr7492695ab.11.1717033102344;
        Wed, 29 May 2024 18:38:22 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3747f53725esm369715ab.48.2024.05.29.18.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 18:38:21 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] bcachefs: fix uninitialized variable in bch2_remount()
Date: Wed, 29 May 2024 19:38:14 -0600
Message-ID: <20240530013814.849633-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405291826.785pVN5c-lkp@intel.com/
Fixes: d6a5e45c75bb ("bcachefs: use new mount API")
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index d4e7d6dc61cb..b2a3a042349f 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1713,7 +1713,7 @@ static int bch2_remount(struct super_block *sb, int *flags,
 			struct bch_opts opts)
 {
 	struct bch_fs *c = sb->s_fs_info;
-	int ret;
+	int ret = 0;
 
 	opt_set(opts, read_only, (*flags & SB_RDONLY) != 0);
 
-- 
2.45.0

