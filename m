Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770D14F8A2
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 23:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RyvDBMY/"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d51ba18e1bso38498775ad.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 15:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1704930884; x=1705535684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AkKAC8fXGxgR2FZQIwvmp6S1WjGpbzgmWqhUZnPfRwc=;
        b=RyvDBMY/jaR5Wp09nb2N5/Y6fHOLvqZxwv5yppI8EguJ+RGHLLy6+oq2IDjJNOFipW
         JWWsl0up5rlg3WbbVXvyoxS8xU+UmmPO2VFU0ji7y8hqXQZAqh9UBpE0wy1esTaCC28F
         p6FhKbc/MfLUb4ualYSObzJLoIQc1iWgchV+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704930884; x=1705535684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkKAC8fXGxgR2FZQIwvmp6S1WjGpbzgmWqhUZnPfRwc=;
        b=oh21og9dlIp5LnPa1KTUFo/ptB+5VQfLld5DwdUGMIc5f/1mITK8dO3ZuHQtget0rK
         2D0c43nvZseXdnYlbFPZbZz8CS/atB456E/b/CqkwCenTfg/nq0Ru8iHo7mc2nDtfhci
         cwcm2djqILWzzC1rz4q5ZpuGLsc0kP3YrcncjW3SnflBuS7Z/2DWyxPaBvMk45UmeH8+
         N6xNChX8Bk8Zx3G+94CNyHqZ9JvjHE6Tmg53K2wnfDbH06kiU7PtdUJmdWyZi5H8rhJM
         f7qZ7ZQIE1pVtq7m6ZCnsKO1MVaVMfTod8/QeX7mjnJ3QCYnO8ojNwZnaDCK+oirfOit
         ue7A==
X-Gm-Message-State: AOJu0YyIYiXOk0o7OsL9V9H7cf/xJtRkjexoq04VWFSAVbREuNnNoNPA
	SJbE3oBaS4odfHPibaBNmXO2QgHA/mJ9
X-Google-Smtp-Source: AGHT+IG3VHTfKDtN5NqvtfOQ7FN7xwVWf9o5KsbTsTToq7q2RrpkuMSsY1WcJDsfacmjZdMui85kFg==
X-Received: by 2002:a17:902:6e17:b0:1d3:65b0:838a with SMTP id u23-20020a1709026e1700b001d365b0838amr326124plk.131.1704930883861;
        Wed, 10 Jan 2024 15:54:43 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id p20-20020a170903249400b001d4593a2e8fsm4225463plw.83.2024.01.10.15.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:54:43 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] bcachefs: Replace strlcpy() with strscpy()
Date: Wed, 10 Jan 2024 15:54:41 -0800
Message-Id: <20240110235438.work.385-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1461; i=keescook@chromium.org;
 h=from:subject:message-id; bh=ZyUK3B0CXfdfFsJKgLgvn82ykQEB6lsn8P9ShT8/n08=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlny5BU7vXazzuAdCKg5WiEdS2gaGoj1/UONt+X
 dqqZTo1ZRuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZZ8uQQAKCRCJcvTf3G3A
 JniiEAC0CyhVOy1fGNjm5zbSRWC8pSo7oJNyw/8tYneECk8XGjD5M0mGrj7HXUv7Yda4hN1I+Ih
 HMnGsgRl90reZO2GcX+izxss4Y5hbW3PZ5bUUyCSgvcZI9+RfRFx0OW/mNwSrsMpWDcF4tHqgkl
 UnMkMmQ6UuXQ+AJp7osJgGGv5LqsPfBEEGabjC9yyeIswHhZSZ99KYWE2B19Tp6sPRlBbDyY0Kx
 sW4PXnTHtqp5Sf1rD+1TB0+KqHNnJkQ0er8bDFV/Jpp3IwWvrQOk1EUSSj1r/VsA68nsbY7t6BX
 iFSueGdhIiOSkIqunSEfqIKd28DRS/r1AxzSZBMutIM4sgXMICE2LnkRAgHxuR12YBtXAUGV9Tn
 pF6LUaFmPU/jOukGZ8qLzWQPvQwd/2EpcHacu4vYzOVBNtEenUCZcZY+iHVx9fkFEJaVgA72Vs9
 qNjvZbL2upPkg0uNX5GaUu5vxeGQcbrfciqNXQJ2si4bzmu7PFzLYE6dQqiBOC7kSVG2HMsArNR
 yH3OFyjV4ttsvWH5XQ55hL7KXwWrFz/QzNYBKAO3X6alGg5uQEXyrJ1j8BIFj1pnsap0ev+vi8X
 I1SW+nwykfPeYg7MjAwhc8ujJT/BwEt7T9RYx211jv0GaIG+HPcE29w8n2qxE87jFVdzoFdR0Wt
 88e6v2J 1OG78piA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

strlcpy() reads the entire source buffer first. This read may exceed
the destination size limit. This is both inefficient and can lead
to linear read overflows if a source string is not NUL-terminated[1].
Additionally, it returns the size of the source string, not the
resulting size of the destination string. In an effort to remove strlcpy()
completely[2], replace strlcpy() here with strscpy().

Nothing checks the return value here, so a direct replacement with
strspy() is possible.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy [1]
Link: https://github.com/KSPP/linux/issues/89 [2]
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/bcachefs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 9dbc35940197..cefe52898e8e 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1386,8 +1386,8 @@ static int bch2_dev_attach_bdev(struct bch_fs *c, struct bch_sb_handle *sb)
 	prt_bdevname(&name, ca->disk_sb.bdev);
 
 	if (c->sb.nr_devices == 1)
-		strlcpy(c->name, name.buf, sizeof(c->name));
-	strlcpy(ca->name, name.buf, sizeof(ca->name));
+		strscpy(c->name, name.buf, sizeof(c->name));
+	strscpy(ca->name, name.buf, sizeof(ca->name));
 
 	printbuf_exit(&name);
 
-- 
2.34.1

