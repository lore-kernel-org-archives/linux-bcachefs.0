Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3011311AC;
	Sun, 15 Jun 2025 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750006001; cv=none; b=cQV4XKcYt4ursEFaoPLOegKNZEMvrgT8mq//6prNSnTq92XoviD++4qN1W6JLRQCPoV/2MPFOUixwtTD47Tglv7Qi8ibUfCk9HTJnuMz5mCKwxRAseMJ2t5vGzTqrykJkOe8fJiJ460HVLP58qufYpx1ULnCgU/Jkd+YtkD6LEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750006001; c=relaxed/simple;
	bh=q2nxxF8EAq7o49j+77+PCK6HtmLE+7HtQ93eW9eAVmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I1hgqY/keOL26WqK7+3u7uxIOWukwsiclz7KCz83xjenYZcP6z2QUaGMsqU5lnFqO7gm6SuEtwoSeUB5PsLcj29tiFPcdnFEhXhkGSaTKqTZ6jTUkzvY3caBe+Bv+TZOCctmerO37Lj0/GN7l8Vki2MThwHMiV1hg1qSHrryj3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tz3qZ950; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tz3qZ950"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-73972a54919so3180599b3a.3;
        Sun, 15 Jun 2025 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750005999; x=1750610799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ibEFxJXBoB+iT4DQuUV/VzD7OboriX5WpdV9GnZMpc0=;
        b=Tz3qZ9506t70KI9kZ2BqDkRTqZSxWQfTMrjwbR1dcM5ohM0RlSk4b7whWe77f6a8sF
         ZqMOIwuSeWA8Z4Gr8sPoCXo+TJ4ytEU5xMe3b+AQE4ABdX6up9AscOPjyUzhLdg32Ul+
         jgi3slatdcoQwtyWofr51GJsKKUQxruDFDOuOm8tmGZBCMScjIdnsHPoHqf689Uq5N/p
         d3CpKrIYCbhLB7VJd+J24e3Didj0JEocOLUsIc1EIW4pG1681kgMxanuNQrWL4zDh7lu
         wgz9wbf3Zlz+f2pKYcY6x2iz8yS2V4T5rUE82EfvcgU1k5o0nvOImhXmXHuu9r0b3g5Y
         vbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750005999; x=1750610799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ibEFxJXBoB+iT4DQuUV/VzD7OboriX5WpdV9GnZMpc0=;
        b=VyK4zZvC+30jAfRZulNjwOzZpxo7PlY24yROGLHxqcVG5OnM0drURjzL9Y4hzqcMmT
         njetVSOE6KkF9VUvdS22FwlgdxhbTPrGMes5+aO0tvepxeTVjXTDS/vNMGar4uUiNSEG
         0VLPUBMljKbmpgWcDxHzQ6QfuRQXT360n+VudvJj3qqKODrKocwpwIJ4zEct0aZr0JT6
         SMslDAu0q/d1KczWLqrLPK+hF0IZhPwlEqn7mk/may0odIH3PhTQq6p8T68k5xpFQmcF
         N8TwyTdaIvxF5HrnSQdQNs4KxwGdA50clvdM2dUtV/dTirE9h7wM6yD/+/BNCqu9FOnu
         vlmw==
X-Forwarded-Encrypted: i=1; AJvYcCU+UIVdczmuboivWlMIA5RJOYiwjIcNWMFi62bbQibWmfw/+JOFvRH/EUgkZYmporXOOLQ0udlNGntnhEwM@vger.kernel.org, AJvYcCXCD1iKeZCd8p/BLTDN47aT5bLilH0SJSHc7tPEn+TJyrybSCIQhJDy3h5fM7wWKF15PY5xcmXdCZcIX22Dvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBhOg6lj2qtsIoXT3MfRqmEnRc3TnOLd7HZAiiyEYQgXD3A9JB
	lfmQQrukAu8Exk3tLZs5dSwSwACoAeO1u7lWAtM3VkUs3Mkc63neomxMUXiSTmd8N3Q=
X-Gm-Gg: ASbGncteCC3YcpR17d8H56URAEYw5lO2hvoJUt6IYyZ+HcJkSxs+6oNh1Ti8UUGPY07
	apKsGciblb4SGoRyIUkJ7S4DO9WYVlzMtHmBL74byYeu9iYsdr5p8/NySE4Bmu7QzxzfSFEnXXc
	beO+uSNCyArx5+WyW3Pg3KcCdIWBHC4P7tK2uIs1nf5yhprq0GhW2+oNMyaf4tk7eXjyK/LV2xz
	tFZtmKuTTCZ6ZS35uhOkU2OOXh2w+544+joupHDpTjCdLs6oGLavo8xmYWbCDwkDj7myNqthaFr
	Uwv8hAdmmfzmZdsWzXBUR0Oz+XI+JZh5PgFZEpoQdoYfPZ0VkErYKf8C65Q+NJrHBqS9fIdUc+r
	84AG2WeBuJbw=
X-Google-Smtp-Source: AGHT+IGw3WEeq1IegtvXBbQUHIc1MttDbgq2J09zuF57yiEiqxFXoWyS2xx1d8cXCyVf7frzjI88cQ==
X-Received: by 2002:a05:6a00:1781:b0:742:a77b:8c4 with SMTP id d2e1a72fcca58-7489cf6a9ebmr8371431b3a.3.1750005998875;
        Sun, 15 Jun 2025 09:46:38 -0700 (PDT)
Received: from localhost.localdomain ([122.174.173.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b2c1asm5233378b3a.143.2025.06.15.09.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 09:46:38 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: don't return fsck_fix for unfixable node errors in __btree_err
Date: Sun, 15 Jun 2025 22:15:38 +0530
Message-ID: <20250615164547.11900-1-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After cd3cdb1ef706 ("Single err message for btree node reads"),
all errors caused __btree_err to return -BCH_ERR_fsck_fix no matter what
the actual error type was if the recovery pass was scanning for btree
nodes. This lead to the code continuing despite things like bad node
formats when they earlier would have caused a jump to fsck_err, because
btree_err only jumps when the return from __btree_err does not match
fsck_fix. Ultimately this lead to undefined behavior by attempting to
unpack a key based on an invalid format.

Make only errors of type -BCH_ERR_btree_node_read_err_fixable cause
__btree_err to return -BCH_ERR_fsck_fix when scanning for btree nodes.

Reported-by: syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Fixes: cd3cdb1ef706 ("bcachefs: Single err message for btree node reads")
Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
v2: Return the given ret for all errors which are not btree_node_read_err_fixable when in scan_for_btree_nodes

 fs/bcachefs/btree_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index d8f3c4c65e90..940f7ce2e33e 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -557,7 +557,9 @@ static int __btree_err(int ret,
 		       const char *fmt, ...)
 {
 	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
-		return bch_err_throw(c, fsck_fix);
+		return ret == -BCH_ERR_btree_node_read_err_fixable
+			? bch_err_throw(c, fsck_fix)
+			: ret;
 
 	bool have_retry = false;
 	int ret2;
-- 
2.49.0

