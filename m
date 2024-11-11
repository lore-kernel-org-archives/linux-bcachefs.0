Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB84C14EC55;
	Mon, 11 Nov 2024 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731336274; cv=none; b=M51vEe427oXTgDBUnMjQmDVzm8i3x8yhl5Xb9+w+FMGDGmnYHW/Oj+685fL6QZu/6gVOdmRZ1sVP2Dayp5OrgI3icSHftw3N1PnjAQiZSaFKYT0fM5pIFKmHDKdJrXh/HybzALddO26c1lvKfWTNBaIgAqtmFwwAOsCF6lAT+Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731336274; c=relaxed/simple;
	bh=6sAXDPQRSWwacQoNdT90XODSqmSn/qQbRANJn47Mbw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=irWSANDe/PXsFptIYUdMSWnftc0Tyho3T3p3/07kIWNUBkq+O2jTCsLE13dDfSP4g7XrkVPDC7AO7xy6wcJxuVWpkjFV8jH6wqdfgaQN2jEFwYA4YpayHWYX5cvbubDCZv04+uOIAruyRmR/0WJMBcBUQDlFPEuZjbFOygUSzBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxT8ixkB; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxT8ixkB"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9aa8895facso869954166b.2;
        Mon, 11 Nov 2024 06:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731336271; x=1731941071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0N/0KQp3+3ibidp+do6cjFRrLqVCbMyVj/s0qA5h/fQ=;
        b=hxT8ixkB1IGzV3VdlHsdg8Fv94sT2Nt7pANPjmmZ6IO+z/U5FOqUgQaJjfjccfeNsP
         ustUU1tXSOpp6kIvFYI/a5CDxBUTgxIdEbO3NB4Ht4zHa92nOAxXnOofm1SyNknjJr7f
         8HdNCEUYktOHwlDsMEuWaIL4khJvXbuhGRM9L3VvvAnLnHVFAEXN+iQDW6u7N3p1FzIh
         wsQFy0H+ONep2xy7SEwkdvY8f35nLmeFRiM8S8zceNm3CixbCsZaCK0eXuIvgsO6pqvP
         lnYiRwmBjGcjEmLYPqsT1pSFu0/Mote+QKM/KyY0Aq4Lz/04vbf8nwXJBgVoEQK+jc/j
         lmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731336271; x=1731941071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N/0KQp3+3ibidp+do6cjFRrLqVCbMyVj/s0qA5h/fQ=;
        b=Vs3igj0PaB4t0eFAnloCikg1siwh2iiYm8wYS2/+nmFN3+WKd8xiGDMCeVO2taSDkg
         3iPnkLV5XPW9K6gXTGkqaG6fED+Qlp1DrJb1sOUtTe2FoFtFxYmZckLBGgCNoJl9u8x3
         BU+x0nnOprkEeKidDuPx1SXJHWdGuKaYwO+JEjQbI2yvvzMhk8EpdzVE677nKp8MItIv
         BiPUyR7h2K+9WlD5eYRkvr+qasV1w2sQf6MY178qJoHMd9CW7GqqgUncvXingaa+tBLg
         5D5DUN3O0EZL/kz2c6706BnedsM14kSXc/QL3IxyJhcxE1j6Cu5PeG+taU9qOJ2NUcZY
         cl3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMmG8/qW9te78GgYtSZymaXavxGAqtyphP3O3Zdp9VGy34ArAg7BjP0SW8RxzbI5kMuQWXdgs9+fQhsqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrjwdRF+gCIcRsf9UkP8Skt2rxU9kD+bvlx8LSbeZ0GQnjF/yf
	HRf4uQLItZqdkgzEti1EXcUupyh6lZ8Nw80LWY3kIpHm8q3R40XO
X-Google-Smtp-Source: AGHT+IGlyRaYr0Nn1HPopNxyI1tt/fBE6zIRdApGKslpDc/b1WF+UP8l+PRffW6XhueuDpAEyzt8tQ==
X-Received: by 2002:a17:907:97c7:b0:a99:ec3c:15cd with SMTP id a640c23a62f3a-a9ef0009412mr1266831766b.54.1731336270814;
        Mon, 11 Nov 2024 06:44:30 -0800 (PST)
Received: from gi4n-KLVL-WXX9.. ([2a01:e11:5400:7400:e7bf:a27b:6748:3bd1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee1aa544asm594584366b.167.2024.11.11.06.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 06:44:30 -0800 (PST)
From: Gianfranco Trad <gianf.trad@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	Gianfranco Trad <gianf.trad@gmail.com>,
	syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: zero-init move_bucket struct in bch2_copygc_get_buckets()
Date: Mon, 11 Nov 2024 15:42:44 +0100
Message-ID: <20241111144242.757798-3-gianf.trad@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zero-init move_bucket struct b fields in bch2_copygc_get_buckets() 
to mitigate later uninit-value-use KMSAN reported bug.

Reported-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8689d10f1894eedf774d
Tested-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
---
 fs/bcachefs/movinggc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index d658be90f737..cdc456b03bec 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -171,7 +171,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
 				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
 				  0, k, ({
-		struct move_bucket b = { .k.bucket = u64_to_bucket(k.k->p.offset) };
+		struct move_bucket b = { 0 };
+		b.k.bucket = u64_to_bucket(k.k->p.offset);
 		int ret2 = 0;
 
 		saw++;
-- 
2.43.0

