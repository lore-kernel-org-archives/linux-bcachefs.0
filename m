Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C771B974
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Apr 2024 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713738998; cv=none; b=mJwtliJNzcsilEa5RaYFhIWvZOBDujqAnLGTP8a71qN1DM9m3kESvHEH7Ez48QmFqZ2sHQU6enuKVlxUsMhCKsin5UpvBHLhUqdzMrkN6vGFyD5CGPn8y9w7aFtf9r1+Buch1a6WBztI2FVKAatcbZ2mhtk9FzUsyzmeb+FQC2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713738998; c=relaxed/simple;
	bh=frxj7VoKufQjlZ6utnq8MUHWksTvQ4BGtt3iQhc+LJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=njM/qc53+KHQnYeLYA78EaSx7hY6NihSkyH0QFcfQHDznThpsYLiXXSf2K4gUi223wGalKhAu+WzKfyW30CAJB2/foqZsJHI9METun/GrIKZX7bKH+C6S1fHAIynohQWcrHqLYdcrd0spSPD+NQC+PAkzIvGgxrn0nLJBhOfwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=nCGLFlRm; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="nCGLFlRm"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-346b96f1483so1932166f8f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Apr 2024 15:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1713738995; x=1714343795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EnYedXI07hAt3dhd+HbGbXf1Rjt+QGaitKZA/KSOMMg=;
        b=nCGLFlRmj5xcxWgRcUByCxVCip37uBts3zRcVenKDD6aZDoi7YTx4GCkWoMIMvzk8Q
         O/9d04smlPW/1HwVN7rsIs2PITB28036EFh6IlpWgaS8NeYTXrgisT6EnhJh1IVSqW2y
         JL+t0UA/ZNqeTcfzaLOntVdi8JfUHDuKz7rqWeqVFH7wPXTX5g7Mg4MjYXlsyB9BCXBr
         dffBmEq2bLOf/o1ryz9h54vgOklAhapnOQLIBYYTaKsxcJwRUjwca5fnrJH6CTS7wwW/
         u/E6RoCNQD0zfNboAVRProin5u/ei0ttfJMT2HRW104d+Ass5VYX7qbsAvtlHACPu/d1
         U6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713738995; x=1714343795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnYedXI07hAt3dhd+HbGbXf1Rjt+QGaitKZA/KSOMMg=;
        b=IAt5/LiPvBo2h4CX+6c3nPA338i0AOfcJsUvAUai0RqUx6fsUTYf2Xa6/8J/mkhkzP
         VH1uyRjiljnixG0ZnqRq4evXUkNFPxkrwc/W+TzHLgFbKQYfoirJTN/F+q4KRUWXs2sD
         AR4j6BF6B6Pt7Ujku+/bROebNfMy56AKeJaDCP7V5foRgQEVA/jJP5MBaezQCKibMzjg
         AxgrL/80sskpJa8Lo58rKTxcJha+1WmRW9NXMbF4GfXA1CoHCTr8DZEvou3XQtyBg6XJ
         JVyyM1AeefNsu5Q0C4VbjxX5jkYtF1HUuaeZ5UP1/ORCFIpQPbg9PjL9Qsm3IIoJ6afN
         YLhA==
X-Gm-Message-State: AOJu0YyyH0vbd76tKlcw8MbGTG/Yy3jltXfg+TqzrlFMBMC4e81OkFnI
	qdm4ZmO0089iv2U7m9f5liNECLJjMSfe5ib5OfFQwO0Cg485uhZQrpO1Ys+wYUE=
X-Google-Smtp-Source: AGHT+IH3nS05/Y573CAnV+aIotx/7hBYrQJZjbQWPOFwWawFDdMCAUrtYZrRMhnxPkxNiNA4ue17jw==
X-Received: by 2002:a5d:53c4:0:b0:34a:70d:1117 with SMTP id a4-20020a5d53c4000000b0034a070d1117mr8754940wrw.18.1713738995089;
        Sun, 21 Apr 2024 15:36:35 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id i4-20020a05600c354400b0041902ebc87esm11158683wmq.35.2024.04.21.15.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 15:36:34 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Use format specifier %u instead of %lu
Date: Mon, 22 Apr 2024 00:35:50 +0200
Message-ID: <20240421223549.952824-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use %u instead of %lu and cast the value to unsigned int to resolve the
following warning on m68k:

	format ‘%lu’ expects argument of type ‘long unsigned int’, but
	argument 12 has type ‘unsigned int’

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/btree_io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 9678b2375bed..45dff1a77366 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -888,9 +888,10 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 				 -BCH_ERR_btree_node_read_err_fixable,
 				 c, NULL, b, i,
 				 btree_node_bkey_bad_u64s,
-				 "bad k->u64s %u (min %u max %lu)", k->u64s,
+				 "bad k->u64s %u (min %u max %u)", k->u64s,
 				 bkeyp_key_u64s(&b->format, k),
-				 U8_MAX - BKEY_U64s + bkeyp_key_u64s(&b->format, k)))
+				 (unsigned int)(U8_MAX - BKEY_U64s +
+					bkeyp_key_u64s(&b->format, k))))
 			goto drop_this_key;
 
 		if (!write)
-- 
2.44.0

