Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8924DA932
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 Oct 2025 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759680329; cv=none; b=jzvmCWD2ZaMZZsnmovig9+X7FBHMgyIL3a3MrYEIy/inI9aGlny8Jb9EW1yrrumTutL8W9rf/nOQzE+xQCqXxVQ4JUg/I4unZtv9qmXG//eD0QZ6A0rHptrw9BFH9iTPvMdfJs5NUjk/QsOr9pokgX7kIda2EXznU62G/CvFT20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759680329; c=relaxed/simple;
	bh=XH2xXUswwjYui6iwKQscZaPoZe7ppMJZ6Sgoi/ykVGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X3/hdju7kEzvXhT7pkQEzsRCyUFeYbcUWDxM5zuYnKQFlHgev6MULaDqLKiepkGw2gH19/AyoGM8815EpmCmOiDvoamjbifiETdWbCfbxpVchAXv8xQqu3axRCfTgqmf+A2gNPxei3TKK+1L2YRh9V1XEeyqJlNHuMS9Wa4xEwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in; spf=none smtp.mailfrom=ee.vjti.ac.in; dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b=Uh2GnAdM; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b="Uh2GnAdM"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33255011eafso3864728a91.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Oct 2025 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1759680326; x=1760285126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Apb38vvwB4yx6ZuSTdH5FloXnDPkndq4ehFPRMxQ1PA=;
        b=Uh2GnAdMcaTbe+soMKte6d95AXFQ7QWCCKO9kIa0vbJ4NeasA9SmfgaH+xPkwefy31
         m9+CX9w7ms3rlYktz6SvAEbZH4nvME1fd3P++YF+rUssIetHQ1DBk9SjzybLUuZGyQ2Z
         VlTRNZVBi6/cn6obbIIvG4sN+HAkQ0BA/wr4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759680326; x=1760285126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Apb38vvwB4yx6ZuSTdH5FloXnDPkndq4ehFPRMxQ1PA=;
        b=eZULhHmzqfGJRrgBislzKHHJ0wrHUjmCxizcmuQeIKGmemqQP0ABkYNkHzhbYCZ70n
         knsxCL1BMe1nTp2yikoA4AeKz+roP/SW7A1XcE4tY6XBNVdLRW/n+p0qXUYJzZwSU6sp
         /I4aMCRtqx2eWIcP+mvkTXZrVyUHsw6tbjSpMP9tFWVfBOHvLoMALbo20g8UrkfPmoKG
         EjYElcBtjMhvuU7zNufD56dLTsdy6GnIeVOV1+4edj19WDwnWl6kOpFebVJt37jtm/nZ
         ztu1uox+SUP9LHY5saB/D8WZQao2A0zhr1DPP/lKv9zzPci6MP37bgS0KND6awSZOTMY
         oi4g==
X-Gm-Message-State: AOJu0Yyxc1ruC0KxThAhvvuFrGmab4VpIoNtZSHWqrUGm6zosdzDHlCv
	Fv8yHpnHuIbtLDFK7wibrxZHehrPkv7KMZBj9wzd4UNhOVnwcYWF4dF1Ce5XkETB6a0=
X-Gm-Gg: ASbGnctv4GOmPgOiyuXAuPd8aGE5+LTFVWh1wMYbe56jV5Fg6wdqCDJ78IoUiZGAjlX
	ml55Br5k1XzOV2dPOvuhXFjnnf/oFXcyCXjVf+MCkK3DfhXwNXiyuxNpwnbr8+SyMU6X+NJRfnH
	4H3hqo/i/q22H+lGbVCyrjrGWQQherQ+tAty+wgeu0hvxjQ6IG9bP/aMfOkzWJwVIz9A6/IxQzh
	z1FGbFzMgf4VHIdCvpfzhgpAvXhui/E9wZmlDpnvuFTcBLPbxHtEZNBLb5EDQO3zyuVDIPD+g8h
	Djhb4LsYV56d2kgwrVZVodAAXvA5f3/eWFBDgnJzb6Zl1dXz03jUvYVmc5AQn1y7lLE1TZ2fj3L
	GrThIPKNsaw+B4b/Gmvr/m6/wfrHfVafwfDOpwV/cflXsYkDnOly/Cg63i9zSbDxSsqA1zZgQDB
	1pLCW3gLWZRzNuzr9H6+eV/LYIVs4=
X-Google-Smtp-Source: AGHT+IFtAPsMcbWTsTzzk6FNbUS5ZUy5nzJQgGNyx0ZUq06fFmSWxW/ID+JTwnNDcwgVq0RlGrbwyA==
X-Received: by 2002:a17:90b:1d8d:b0:32e:37af:b012 with SMTP id 98e67ed59e1d1-339c264d739mr12476273a91.0.1759680325632;
        Sun, 05 Oct 2025 09:05:25 -0700 (PDT)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2405:201:31:d016:767d:6919:46bb:bc81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6ebe5f2sm13903271a91.11.2025.10.05.09.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 09:05:25 -0700 (PDT)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs:fix use-after-free in __bch2_bkey_fsck_err
Date: Sun,  5 Oct 2025 21:35:18 +0530
Message-Id: <20251005160518.10000-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

When mounting a corrupted bcachefs filesystem, KASAN detects a
use-after-free in the error reporting path. This occurs due to a race
between error reporting and key deletion during fsck.

The sequence of events:

1. extent_ptr_validate() detects an invalid extent pointer with a
   corrupt disk offset
2. It calls __bch2_bkey_fsck_err() to report the error
3. The fsck logic decides to delete the corrupt key
4. Meanwhile, __bch2_bkey_fsck_err() calls bch2_bkey_val_to_text()
5. This traverses the extent entries via bch2_extent_ptr_to_text()
6. sector_to_bucket_and_offset() is called with the corrupt offset
7. Memory access occurs on data being concurrently freed

The crash happens in bch2_extent_ptr_to_text() when it attempts to
validate bucket boundaries using already-freed extent pointer data.

Replace bch2_bkey_val_to_text() with bch2_bpos_to_text() to print
only the key position (inode, offset, snapshot) instead of traversing
potentially corrupt or freed extent metadata. The position is part of
the key header and remains safe to read even as the extent data is
being freed. The specific validation error is still printed in the
subsequent lines, providing sufficient context for debugging.

Tested successfully locally using syzbot provided reproducer

Reported-by: syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=564efbe31172fe908429
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
 fs/bcachefs/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 267e73d9d7e6..b0bf08915aa2 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -688,7 +688,7 @@ int __bch2_bkey_fsck_err(struct bch_fs *c,
 	bch2_btree_id_to_text(&buf, from.btree);
 	prt_printf(&buf, " level=%u: ", from.level);
 
-	bch2_bkey_val_to_text(&buf, c, k);
+	bch2_bpos_to_text(&buf, k.k->p);
 	prt_newline(&buf);
 
 	va_list args;
-- 
2.34.1

