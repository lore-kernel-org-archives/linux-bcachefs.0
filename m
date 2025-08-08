Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F33273D76
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Aug 2025 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660610; cv=none; b=aRExSG9JPvvC9+tKKR+L6bx3RGLJJ6obmWrHPdciV5E5Q2JDIs8o4xsW1cdX/o9rUj11TZtAGlcTjVYdDzg8+hfeM20hDrjTM1zNJYANL1d1RKlUffIlXvNaorRs3Z6h5azSOEONGrpBxYC3JxZ9vdIPbpO42qwrCiH5SAJAI/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660610; c=relaxed/simple;
	bh=RMMJcyE02djD26ACsJ8vHP0CAN5Pc2OUgA92VnMuqec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djPoMUoEgKLkGN3PZR3GDZOU8EWMVvXdfPmOBTb8cW6k0Fo1DON+8uDE3B8uwhVItWo30Q7ncFiri0qpAvwejfVN2qclmN6YwsS4kl9ODaa/wGjiR1YrmnN69w8MFw2iTh0SVkW4hJ1XSnNQm34yJb9Rp7bsavGSHXHKvqIuGGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=na4qfziw; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="na4qfziw"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b170c99aa49so1381785a12.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 08 Aug 2025 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754660609; x=1755265409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOIn1fU2b0kASHCE5XqbnUxSmJ66h7Pi+DT4SumcRqg=;
        b=na4qfziwU0bC9svyrdoZZyJCLm8a6a7ua/DtOPr+9tTNyAWu9VZcURuHXIxlcgEFBT
         Gu8oX9WR714Xe0AXlOQ3mIIAbOwRFouQiEK9qO1Qs3wytpj6I5F9IK6iWGdVd5HhKS+J
         Nt14p3zIbZf62x8xbqZCco+kNPXLBE2Uo+RMZyR7qgp3kF7rkHI9g1Rt4MfJY8z9Pn1U
         Rrdfg0y8fbNdj3MW1utGRiKbN+og7r7AF+5+yc7XhxqrHrXB4CNOiShLofFD15uL5sm9
         zDLpVY0Ou0SjgmyyWDk9DYUY7qhuMzteQP48JGwBcIcXtninupqeev4oSAJvPXWTnUZV
         vRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754660609; x=1755265409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOIn1fU2b0kASHCE5XqbnUxSmJ66h7Pi+DT4SumcRqg=;
        b=W2xSHTbtQ5dNzsOCsJQnsn5N29qlnC+cFhy/XWFX0tolLWEYCWoGddQ99eKuVzhS90
         k8/G+NVZO8y3Y2hLvbha7hnCJ4rO5mWlpOl0sAr+yGE8d3G8hEsctb8Qbrz6OpWRa/fv
         DkyNV/qS2v9ZiOD0Cm5yI3Pg2Hie+L/4lHA/RvArRPP6sw34UMxhyRsFcFn6ZKsx1Cvv
         522/qUbLg1PwpQrkaFXAYmYFo1wc7b3pYoBqaCChDTrRJAMEWP/aAwYdCDRw7TMk02u6
         jS/UlBlf8yopWMuQHNR5T0bQ6FUA0pEAhVhLRCTAEHhTfFPwVFC/Z0bghgjbSpioig4C
         7HFw==
X-Gm-Message-State: AOJu0Yya76UgHrcpeVOlR2mgM5efeRUQqgdPAMjjT3cS9wWO6AgZjzMm
	yi2zjF1Wx6M7gesGn+yaycz2lTrOuQEDxRRituhM22g0kgpTbv9vku2Q0QU5Tg==
X-Gm-Gg: ASbGncvolkfvPZBhofE+14RSX53B01ZmIx2Z0tgXv+9Iwu1y+7I8xGGgQ5WERmvo/qh
	OG1LaPfJff0xe+JL5kPfI1kh6XvRaB03psc/JrlXu3nEsG2euascRn8MJ0jR9hWMoT3TKNWI6H+
	FwdLP+99lpIg03CPHTEd712cAsmra1gwtibd62miBJglOhAxGdGW+NhC70uj+FS1QLTHt0ZE2t8
	gTGtFVW33L6RexRJKmIqdUlG8+wjQlJ5qBWON89QQPHUGqF7OeMOSD80lRZBJRD+mgOCeSEkb6n
	NyLC8TfoqCR+kj+RdiU7ueIlCXf9P1G5J7XQLh88HDr2EisHfCn04ZtNuagdID7mgwXDsOrQHbu
	n7ULOVsM=
X-Google-Smtp-Source: AGHT+IFEAEg1oi33RYJwIk81rlPvCQIxxF7DBKn+vKE1NlBQllt7MDdDZsRgHVwaJkEozxO3AHUo4Q==
X-Received: by 2002:a17:903:2352:b0:23f:c945:6081 with SMTP id d9443c01a7336-242c221b41fmr50370155ad.31.1754660608566;
        Fri, 08 Aug 2025 06:43:28 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2429b7dfc23sm77893155ad.105.2025.08.08.06.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 06:43:28 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 3/3] bcachefs: Don't lock ei_pagecache_lock in bch2_readahead
Date: Fri,  8 Aug 2025 21:43:12 +0800
Message-ID: <20250808134312.878432-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250808134312.878432-1-mmpgouride@gmail.com>
References: <20250808134312.878432-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lock should already be acquired from all code path.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index c16c45a72c47..01bc3e048542 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -70,15 +70,6 @@ static int readpages_iter_init(struct readpages_iter *iter,
 	return 0;
 }
 
-static void readpages_iter_exit(struct readpages_iter *iter,
-			        struct readahead_control *ractl)
-{
-	darray_for_each_reverse(iter->folios, folio) {
-		readpages_iter_folio_revert(ractl, *folio);
-		folio_get(*folio);
-	}
-}
-
 static inline struct folio *readpage_iter_peek(struct readpages_iter *iter)
 {
 	if (iter->idx >= iter->folios.nr)
@@ -305,10 +296,6 @@ void bch2_readahead(struct readahead_control *ractl)
 	 * scheduling.
 	 */
 	blk_start_plug(&plug);
-	if (!bch2_pagecache_add_tryget(inode)) {
-		readpages_iter_exit(&readpages_iter, ractl);
-		goto out;
-	}
 
 	struct btree_trans *trans = bch2_trans_get(c);
 	while ((folio = readpage_iter_peek(&readpages_iter))) {
@@ -334,8 +321,6 @@ void bch2_readahead(struct readahead_control *ractl)
 	}
 	bch2_trans_put(trans);
 
-	bch2_pagecache_add_put(inode);
-out:
 	blk_finish_plug(&plug);
 	darray_exit(&readpages_iter.folios);
 }
-- 
2.49.0

