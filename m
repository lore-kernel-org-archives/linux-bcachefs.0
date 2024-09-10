Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EE823A6
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965422; cv=none; b=Mj49QJc0IYncVP2clyG3cH0hIktJkC+cHVJW8SNooXk2b7YEMoA2UOSFP3E1emMPrL6jgikiI2yDc/dV+kGtnM7yODwUwvzlWkAN6aklNeUJLWsNci/yUlkE/yyFOActpR0KXyq3pE1kdvYHVblazeHqRBiM4uAYotLKnGL5naw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965422; c=relaxed/simple;
	bh=j660FIt2LkNBUOlAD8fG6i3s65RXTVA5vEPHfgPW6AY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pYC7V9lYw6+unl+Zzka0g1XhEL/QTPAD5KLrZxjlk4KD94lGIIzv1eGSDVIuBJiUyETuhVeEqhkXKhlWMPY7Eph3iVV5N8rlFkLjKX8sG5PL/oW+F6p9NlYGcjVkalvBHHCGrGSWMuR0R3b0ICyrTjWM1qRU+6SUl47snX2JP+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=gUnACpx1; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="gUnACpx1"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-374b37bfbf2so194033f8f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 03:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1725965419; x=1726570219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kTCp9nY7FQEM3AmaK7gIs2eZ38YLpBmTnUOj1/n38Xo=;
        b=gUnACpx1upy7ki8K8G0dcz8z5s3wfzO/u5YA+s+0rF0xjiVa3KmGC6tiNIsKsCjrpe
         V98AVVp1r9mmdCX7fP3RqhUGcJBKZ0wZ8tchVWJd+Q/2glcBqRGpxqBVRsc9t6gsdSdC
         2aHPNHnY4OBdJU/u67gbDrs5VijJcuAXP7fc2m6z/yoROhTFJwYNNTAmPpYOXQ5mkJ1s
         edwMpnayapQa3d9B7zrWxAgRmCWSKMeKmwLf6LcUI1CIfroCfDLZf7rCEBkeF1R/QbM4
         06qvpK4SX4Hh5k2cy81ObcgfYrUukMNpVBpNwXxUDZ3e7aIZNM9b3d5bWWlzU4PgHemq
         uvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965419; x=1726570219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kTCp9nY7FQEM3AmaK7gIs2eZ38YLpBmTnUOj1/n38Xo=;
        b=msOjrtjNhAihHxSulfA1Tf7ukoXezoLN+LxC7QeBUXPq0ybBfIplaA8ETg3Sr3OzHu
         nUTvgn7GbvFv9pfW/cWkhA/ml1ww2PESgsoDttqKUIgSIZte5cWvcxCZhmNEZprHjUWE
         KBCImKqOoFchBiE2lyaqA28M7BWXTlWijo9EFCGhxgZRDXCGlogzD0ErLgZqDnAkyvG0
         6mdDJbX2PMDBz6ByupKkRPAUALxMnBENFE2MzOpAg6aOndvZzp+Ul1ZRDSSI31M0VHgR
         6hZ+OOrFk/OO0tiPuTzbmW3Pxs/k0G9+5V/U1pUogs2KAnt3ZyQjSRia8X/vDGA4C8D1
         nMiw==
X-Gm-Message-State: AOJu0YwqbIJ/liP4r+93+wGBpzYB4h398Mm0yklf1aHbtz1U8PblqW88
	3LS5ihXP3vzCNK0ITYzl8qbVTViNWKAy+5vhR1zzZwIVRKoygjtmrjB55idYQ3c=
X-Google-Smtp-Source: AGHT+IEWUdW0zk8adQ4t2k43BCT3ytMYT82ahbXEVJ7Mir9v+q7r+D14fxbNeEjwHcI8FM7pRrG09Q==
X-Received: by 2002:a5d:5f87:0:b0:376:8378:2a60 with SMTP id ffacd0b85a97d-378895c5ab1mr4746018f8f.1.1725965418704;
        Tue, 10 Sep 2024 03:50:18 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-91.dynamic.mnet-online.de. [62.216.208.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37895676117sm8509673f8f.60.2024.09.10.03.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 03:50:18 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [RESEND PATCH] bcachefs: Remove duplicate included headers
Date: Tue, 10 Sep 2024 12:50:08 +0200
Message-ID: <20240910105007.4882-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header files dirent_format.h and disk_groups_format.h are included
twice. Remove the redundant includes and the following warnings reported
by make includecheck:

  disk_groups_format.h is included more than once
  dirent_format.h is included more than once

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/bcachefs_format.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 14ce726bf5a3..b97fd0f75831 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -499,8 +499,6 @@ struct bch_sb_field {
 #include "disk_groups_format.h"
 #include "extents_format.h"
 #include "ec_format.h"
-#include "dirent_format.h"
-#include "disk_groups_format.h"
 #include "inode_format.h"
 #include "journal_seq_blacklist_format.h"
 #include "logged_ops_format.h"
-- 
2.46.0

