Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C220314
	for <linux-bcachefs@vger.kernel.org>; Sat,  6 Apr 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712413237; cv=none; b=if0fqVYER2iFIsmRpQGcOt7bQXVL51sG0BgTx43gFg8ku3/uYFGwmWQ8mMCARBN0XjYFGrd/ZWn7w+XJYO6Qrr2OjOZYmLGkg4slySAUuajxX5l5rDOuFRb6Wydi8L1T9s9cS3dD7+ExsbhLP/yKToXOROVwqhlY6Uw7N8qIRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712413237; c=relaxed/simple;
	bh=Irb+ftuDm46YsVkSeq1DKJ3dG7nsQoxw9PGx16qlrdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2x3+X9Au6+2zPXOyV1QNjUzb7yofHYok0Hjm7tNdZbSkPljyM0TZJ1DSUNMW+hmjLPCEYhycbggqmNB7C1vaeKUc3bC8iXHjxsA/Qtu8/Ah/KEMiAh4kdK4+yXdLc0udxvaCEp2wQ2Kcm7c4LkK+iE76+fqj4eulEQYA64y+Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=LA6j//Pr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="LA6j//Pr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-41639ec6fa4so2860185e9.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 06 Apr 2024 07:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1712413234; x=1713018034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gMFJwk72mdGi+f2eeLuZmpaE2qONzPo/pdcIQkd4uoM=;
        b=LA6j//PrPeMJR74T9idg6OvijRjhxnqXJIyFGZhlA58HnoQNCYhZxvNlcDbznvfQoZ
         +ugEViGRRM0odmsQTq/R9WoL4OVPD2uEdwLHn2SaJrj3QymviPwZuRUyVxJfI0+Bq10d
         GXqT684mPyytFMKzjy9Mu0jTLBd0hYCiK6XodB3y3v93Hjqy9tWIE7kw4LFDk8KbJ9Br
         lzSVFCYig3VSHseupqNi6hQcoqvufBAjzCZiMyxWONT2vgCrXV8K6y8UIl12bElx4R+Y
         Ly/sntQgvdpklCpkZS7OKS9EBNmR9Up9oCBP2ggKyHkri6momeqE+B0HhzsXtXzT07qX
         i2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712413234; x=1713018034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMFJwk72mdGi+f2eeLuZmpaE2qONzPo/pdcIQkd4uoM=;
        b=u7n/UVhanxHa1msmU852HaRq2ATe4hSaurxnY3taD7KlhxB7LH6tFqlOUi2+inlsFm
         KVoGQTX8H2lI2oJNSg5OorBnYVC/IJiL7dpyz9zVkZ4lz5BdZN/VQZ4VcfdAX8NPCQG+
         qbqQVsV+wqEs4RtKdQt6SLRGsgDb/VQ2EzcwCk4J9tCv/cEm+VGht3bcoOVjmFGe+cVf
         Z1nSSWSyDBHlVjlYn6NILrx8VbUHDoJUP4n5zfQQiO9jwVwOH6rD07SZefi5RC3qRT7j
         tKGoNgJtr+jq0SMnwia3+8jB85T/zD03aPnsAmpmf+3Lo2U3JA9gRXfq5SSDUnyghNtr
         SQVw==
X-Gm-Message-State: AOJu0YyX+gHTyN42TSeoxcIzprIWQ3f0aZ2uPxiQhxmenuTkOC49DxvV
	RVc4wivXd/5jUJxlNSo+RWiPHV6v7myas+cXHgEVHeAKUiaoXDD8TwZ5Gq+CeZY=
X-Google-Smtp-Source: AGHT+IHEAWxgzx4/f0KRN9arGTH66pFTyLd9JW1kTcJCXU4RfecAkf0ALenJ2gwZXFPQ+3R/jKCzew==
X-Received: by 2002:a05:600c:19cc:b0:414:8aa7:f3b7 with SMTP id u12-20020a05600c19cc00b004148aa7f3b7mr3190245wmq.19.1712413233845;
        Sat, 06 Apr 2024 07:20:33 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d4706000000b00343dc1074b0sm4609665wrq.5.2024.04.06.07.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 07:20:33 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Rename struct field swap to prevent macro naming collision
Date: Sat,  6 Apr 2024 16:19:20 +0200
Message-ID: <20240406141919.248148-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The struct field swap can collide with the swap() macro defined in
linux/minmax.h. Rename the struct field to prevent such collisions.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/eytzinger.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
index 4ce5e957a6e9..0f955c3c76a7 100644
--- a/fs/bcachefs/eytzinger.c
+++ b/fs/bcachefs/eytzinger.c
@@ -115,7 +115,7 @@ static void swap_bytes(void *a, void *b, size_t n)
 
 struct wrapper {
 	cmp_func_t cmp;
-	swap_func_t swap;
+	swap_func_t swap_func;
 };
 
 /*
@@ -125,7 +125,7 @@ struct wrapper {
 static void do_swap(void *a, void *b, size_t size, swap_r_func_t swap_func, const void *priv)
 {
 	if (swap_func == SWAP_WRAPPER) {
-		((const struct wrapper *)priv)->swap(a, b, (int)size);
+		((const struct wrapper *)priv)->swap_func(a, b, (int)size);
 		return;
 	}
 
@@ -174,7 +174,7 @@ void eytzinger0_sort_r(void *base, size_t n, size_t size,
 	int i, c, r;
 
 	/* called from 'sort' without swap function, let's pick the default */
-	if (swap_func == SWAP_WRAPPER && !((struct wrapper *)priv)->swap)
+	if (swap_func == SWAP_WRAPPER && !((struct wrapper *)priv)->swap_func)
 		swap_func = NULL;
 
 	if (!swap_func) {
@@ -227,7 +227,7 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 {
 	struct wrapper w = {
 		.cmp  = cmp_func,
-		.swap = swap_func,
+		.swap_func = swap_func,
 	};
 
 	return eytzinger0_sort_r(base, n, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
-- 
2.44.0

