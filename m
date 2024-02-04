Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24813881E
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Feb 2024 07:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707033117; cv=none; b=ACzzYN40/BLMj5KHHeo+9XzWpTt2a6z9cmk+mtEqmFuN/a6eA4hjkIMsZWCxha1+NN8G3Z2kq0wN4SRnxBvgdpVWe0rPWilyMMEbLPPCyOn2p/QAS9LInh/buiFYuZV1KjBZx6oRLoEzK7mh7aoLx1+nRifdKMzOTv7AQEC5qHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707033117; c=relaxed/simple;
	bh=swxDwCuqOvnW0ofmUHTOSsI69KrSJEGYUdUJMkgW6DE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z834Z4rYJrfIxCR4eW+5mkUF+U2DUR/csuxWxCA3mwiov63tzRlEvsbP/c2bLYkuQ7R+QmoUc1WzzBQQ6F7WopRHWuhVHRW2gV3S+jVA5JrfwUxW4t/gvQ4A5N8atPuIz2QKbMhdotYHW9MuJADXp7xyWEweFiwlBkhA6Uv7XBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=FwpgcRC9; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="FwpgcRC9"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a2f79e79f0cso467473366b.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 03 Feb 2024 23:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707033114; x=1707637914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r9lL0IzOj5zPv3u3eQbvaxza72dRt9HHWlCqgXcKhlY=;
        b=FwpgcRC9+9Y5MyW50N3eNNgCUtHixy/RnfHEhTPUxfnwMdvXNEDptvv0aSLCAKDU14
         /AxIn6pc62aS+rkSWaX8/LDVGFByIzWxLYiCcr0Ayv6IxLhpS086yMMp5Ze6L9bA9zd6
         jYWlzCx9/h1fqazN14cRSKRhWNTJbVJ/YfgOPUNq2fC7etBNpM3c0rH+heK19zqfwVOG
         ESl2FAcCMzCKiCD8Q/Ml8IHTg1STiONcU2EhUqD9LONvyiVU7ntZs5JA1bBT9BDWL1Yn
         1Q3WBV6NbmBO1BaEcczu6mse6A19EzY+WLDSBp6RsH5bYwQ4EBa0mUeavZ1uHqO8ZXGL
         1uiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707033114; x=1707637914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r9lL0IzOj5zPv3u3eQbvaxza72dRt9HHWlCqgXcKhlY=;
        b=tXBvK+jo4gWqH0UYJgGIsAQs1m28XFubawu41uq+ab9RqGOsK6Dnt/dTLo+GvtXBBj
         /PsehYCeR8A8Cpm3ECRo+87OxTu8uU0pkk08sgav2Bo7CO7YtGcjm108lMtHSaJpvp3C
         4fivd+huXCZGUqASNFzXIUVFOKR9PmThwlglJoibyleAZwIXRcI4VINOEaPCJpLJbXxd
         x4nc0eu0XP5vKmb/u6p0mUNicqGIWjp9XO8V47PNgVXnkIQrb/UhpZ7VQRjWHvQ3FJCK
         ZmyEJImXFN0dc4GSSaDS1dt9dwI8YUya2VZaYOm+2YBrMxZGO03Nx0VXLO9J2jkM/bYu
         IxYw==
X-Gm-Message-State: AOJu0YzvycKXcn+K+tXrzi46gJCius1OfYdYC3VEeOopLCqmf/eH9dT9
	7kII3wreWhjUwUsbfXX/9Ir6/eRSbZQcW2mbbMc3NVnFGtpBe+odrIcU1QnH04A=
X-Google-Smtp-Source: AGHT+IFaUId2YjI/7K0G74BgyKxetnOxYAKjZVZ/4EnhPSVz8M3hluftmtM9ljduBj6scQUzlvjrow==
X-Received: by 2002:a17:906:e9b:b0:a36:741e:a5 with SMTP id p27-20020a1709060e9b00b00a36741e00a5mr9556198ejf.70.1707033114107;
        Sat, 03 Feb 2024 23:51:54 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXdTdtaPKHz+ZjeZIntLpv33KdmF01cL/QmdmOUKZpIvQpEmz+OwrX9F3wNg2kOEiWJAayAX6RHgMs5kSWGbzUmv4v9qBd6ImKIdI9/AnHOhQME8w55iJk/yuXXDBaQiYmK94xX6LE=
Received: from x1.fosdem.net ([2001:67c:1810:f051:d51b:7b6:cc25:3002])
        by smtp.gmail.com with ESMTPSA id bz8-20020a1709070aa800b00a376758a0e9sm1098439ejc.81.2024.02.03.23.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 23:51:53 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH] bcachefs: install fd later to avoid race with close
Date: Sun,  4 Feb 2024 08:51:52 +0100
Message-Id: <20240204075152.695920-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling fd_install() makes a file reachable for userland, including the
possibility to close the file descriptor, which leads to calling its
'release' hook. If that happens before the code had a chance to bump the
reference of the newly created task struct, the release callback will
call put_task_struct() too early, leading to the premature destruction
of the kernel thread.

Avoid that race by calling fd_install() later, after all the setup is
done.

Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 fs/bcachefs/thread_with_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/thread_with_file.c b/fs/bcachefs/thread_with_file.c
index b1c867aa2b58..9220d7de10db 100644
--- a/fs/bcachefs/thread_with_file.c
+++ b/fs/bcachefs/thread_with_file.c
@@ -53,9 +53,9 @@ int bch2_run_thread_with_file(struct thread_with_file *thr,
 	if (ret)
 		goto err;
 
-	fd_install(fd, file);
 	get_task_struct(thr->task);
 	wake_up_process(thr->task);
+	fd_install(fd, file);
 	return fd;
 err:
 	if (fd >= 0)
-- 
2.39.2

