Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5453BE
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721566526; cv=none; b=If4Lm+jwpivs5auidY5+Dqp8rt8WT/CYUQRVv4cNtX/xhHizunAqeRsS5D/5m15ofw4xqcmJcx4QQzrtz9CdcVYQCQgw05z/xioAOgeozFJgyp7vGpe5sOZvAoen45JfCWnH/CzBhUNwe8NSgjHLw9PA/4aPN7T8eJY2xY7QwEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721566526; c=relaxed/simple;
	bh=vYi6WA2FD48gJBamWHmlpXPR9cWZTWlflkho+BYC+q4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DMIQjU6tMroMwT3rSAMaN6OrHoTOGvINggnqcsd9mWmfjnHYx5DsMuZH5r29NHch2RAQyW7Xq5xjInWaFikppqk6asMI1T9DczN1Pd9arT7XCW1XlAwx9d8K2jzM8hrOgzXezTnFysxYF7r1BZBdRG2f9MAeM0kODAJwswFwBQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOC/y/9h; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOC/y/9h"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d265e5278so42468b3a.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721566524; x=1722171324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=necQUxLKxT/wZge1WICsZUW6fEUJzSjZTM5RutKfFeE=;
        b=XOC/y/9hFYFOmShOUx1+2mmxfMXoMs6Hh1JSNijNLdp6OGHsANZd0LeZPGG1ytVtf1
         iecWSMeNM6uRV8Kedv0MaeqdVv0+lIR3CkbwG2UDG6CD+7iujrys80TqFEn87F0B3g91
         FNJQZLlaHQLI4QOzth2ry5O+U6RfGQ8Liys7UB+mezOdvAtZwSp3V1iB3pEeWTNlwetd
         EiqIfS6cJoZakQMYO+H3p3oZKvL9ZJPJv6OeiyVrd21gZaBdVK7jOMfbHvnrd9dWmVdd
         BXzGEG9joLvG+4atBHfvQmBs6DovrAJLZaGOS2wiHpCDuMca7NuAVWeG88gWKUUhzRNg
         nO7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721566524; x=1722171324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=necQUxLKxT/wZge1WICsZUW6fEUJzSjZTM5RutKfFeE=;
        b=NT7AA6amMsXp7pYaDCXiM4aaoQXY95OLUP4jDD9sH9xOuRW50Q4GWVKx4Wb0qQbylY
         kLfwUl+vmfh95TlNmo7aCSkr3CWebTYs7OGpuvMDu84oRNawVWE+cDecoCcjGNaK5F+o
         1LIsUmqPAaccgaVO4ZUVR0iEfQUPfVW9X4mmT8gVctKfDNaj/9JPrjJQNBkDO1d6y8Vk
         DgVOhFOf5bns+4sSeo44ubo6TaD/30iSGEhYEldAl5zvmhM8QFWerdQuYI82+Se10UB/
         6uMaJKqG0IDmfOoT6VlmcdAXCCkkBzgqG62e4BrmE6TGTtu5krSrH8L1NpD4GToI8frL
         c6Cg==
X-Gm-Message-State: AOJu0YzR4ElIJRdjNOyzGHu6wImhxF/vdlRDz5H0MamRDGsV/1S6crEJ
	0GrUQ1T0kjZx2Q+FabV8P3lDzIvzlOYUVJqG/4MBxP5zhs6truSO1qXjdzkTvB0=
X-Google-Smtp-Source: AGHT+IEFxGY/yMXJhoaalHTys423+vy5R5mQocpFx2FcpSEswt2vIVIufTY57TgEoopaFV5xqbIL3w==
X-Received: by 2002:a05:6a00:17a9:b0:70d:1d48:a7d9 with SMTP id d2e1a72fcca58-70d1d48a928mr709806b3a.15.1721566523552;
        Sun, 21 Jul 2024 05:55:23 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d22f50f46sm716838b3a.77.2024.07.21.05.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 05:55:23 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 4/4] bcachefs: remove the unused parameter in macro bkey_crc_next
Date: Sun, 21 Jul 2024 08:55:20 -0400
Message-Id: <20240721125520.252005-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the macro definition of bkey_crc_next, five parameters
were accepted, but only four of them were used. Let's remove
the unused one.

The patch has only passed compilation tests, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/bcachefs/extents.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index facdb8a86eec..68f8c30b348e 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -357,7 +357,7 @@ out:									\
 	__bkey_for_each_ptr_decode(_k, (_p).start, (_p).end,		\
 				   _ptr, _entry)
 
-#define bkey_crc_next(_k, _start, _end, _crc, _iter)			\
+#define bkey_crc_next(_k, _end, _crc, _iter)			\
 ({									\
 	__bkey_extent_entry_for_each_from(_iter, _end, _iter)		\
 		if (extent_entry_is_crc(_iter)) {			\
@@ -372,7 +372,7 @@ out:									\
 #define __bkey_for_each_crc(_k, _start, _end, _crc, _iter)		\
 	for ((_crc) = bch2_extent_crc_unpack(_k, NULL),			\
 	     (_iter) = (_start);					\
-	     bkey_crc_next(_k, _start, _end, _crc, _iter);		\
+	     bkey_crc_next(_k, _end, _crc, _iter);		\
 	     (_iter) = extent_entry_next(_iter))
 
 #define bkey_for_each_crc(_k, _p, _crc, _iter)				\
-- 
2.39.2

