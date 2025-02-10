Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B760146B8
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 03:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156670; cv=none; b=ps8VQmcMXB5OarGPa2MYDi9M1fBuCVH82oJGgN8HzRp2sokj92pyD4dubIDRwHCKVfB6EThkDV844YnM1K6B9ChWkPMcdAccE7k7gTxrAkJnrVXLrC9kOXLV4Tg2oHfl58vz9F5SccZvP4aC25ElsPJEou7uuw1HH3I1IA74m8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156670; c=relaxed/simple;
	bh=e5Meyq07pkzgZcnHEvFEeneW7paFhLs5JjE9dDl/BmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tyGxuMTu5V0AnlfklJmcVqIdq6LO2GmsqoFtTgezUapF3nDBAdbkXpW2sYo8yaioyK3J9bQUA8NmDWK7hlmx7w2LZ9Qd9yToPbIp4NQsPVreJo+N8chwr6M6kIbEifMXozWyl1SN9bjp1rGmPik89yuStUAha9XZ5PT93fjoNno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d0OnULpt; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0OnULpt"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c05a0a4872so132458585a.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Feb 2025 19:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739156667; x=1739761467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QkxIqF/W6ETQmqSwJ7EPm0X0wVvyhtQ5D6vTHKTKqYo=;
        b=d0OnULpteophmg08FTdpR5emtIGsXfTrwaF3ERH00c/4XMC1EFJpJwhfSmOrVqW4wv
         PpFF8WoOe7QiaKap/jem6LtfKC/r2dH7QgEfGCnqdIbKjf9rAbCFvZcnp3dwYwsYsfuN
         jxTGsW5lMxSnh15g/Ss4PcpSPrlLT8gxsqkqS3528vb9SkaUPvFrznRJ8w3jZiewibg9
         GaCDdhDrINdenq33HdA982biOAWX3jPsN0I5LnqGkjck+9HIKffUSEEkK8mZt0ONESpE
         mI+0ZCmc1DHDyBt4RJ+G02rLNCwvfx2us6lcfpv8+DjdjsSUa3BZkrKHlgZ7CMuMVeLn
         zKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739156667; x=1739761467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QkxIqF/W6ETQmqSwJ7EPm0X0wVvyhtQ5D6vTHKTKqYo=;
        b=uGMn4ImRnbdtuwbDj4CDNSzLHkWf6ejh/T3uxWz1HxQxnX6SRN5H9L2ErqtFpwAn/P
         mzuvlsIn4tJcyN8pOkTMfKUfzgYKH1RTWmN3WKG0hp429Diy74qNGq4PnwhecogOgeGm
         OV263hmH9puSn/EXoa09VA9DYb4B01Ai5533fZKFWljGnoe1QWvzqQycrA70FvNxrcUa
         mpgm1B/d8LWACUKps0fylxhfVyQibf7OBy19Wer4fjMNUvPXmv7pMfasFijNtFf6g85V
         bA8CYugixJDvKi1SQ8aaif0h68ziDppMUy0yRxxpl0x+mJoPBBhL2vZn+CcfiAv809sv
         MTow==
X-Gm-Message-State: AOJu0Yzf5Qfy+2kWnMJA8jG3RQ73Y9CIvzDoCyc8dREUWlaZEhxFG37w
	HIwNxkU2fm6sTdDLpsoMkZMMvcl7kmc8Oi9TsjDd+Mg81v45KVT3
X-Gm-Gg: ASbGncshaldNwFUsoU0Ppyna/MVIo3k2FOKaOyi4/LM+0Bfn55eJM3zl/ecZEJQmPgR
	KxzXTg1fuxJMjKqE08qekfbtjwOyMtSfM16h05UVRSleag71o0oCsXqXg/5L6HLko9qOqAh2eJo
	qFW5Vw0Kqd7vBGrbFwHJ4dSxEpkJVgU9vrDn17fXXJKxbkfDrLTCv9PkOCbnumohJQqwPh4P1lw
	lhmmN4tExUgTGN9u5Tc+2HfJtpINHGdYmzUDEMc2/dNJ9oBoCUufNvcEpuJF0xekQ==
X-Google-Smtp-Source: AGHT+IF5J0eCfDxu/KNryalAa2d0CG8PKx35oGhpCf810KJOFQijZX2NpMJiH5AmgW0hKC1aoA+7Vg==
X-Received: by 2002:a05:620a:404e:b0:7b6:cfab:9882 with SMTP id af79cd13be357-7c047c4e8b2mr2029554585a.58.1739156667556;
        Sun, 09 Feb 2025 19:04:27 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c041dec31dsm480562685a.1.2025.02.09.19.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 19:04:26 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Use uncompressed_size as the operand
Date: Mon, 10 Feb 2025 11:04:21 +0800
Message-ID: <20250210030422.711912-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since we don't merge compressed extents, uncompressed_size should be
equal to compressed_size, use uncompressed_size to clarify the intention.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 05d5f71a7ca9..eeea23d09b9a 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -326,7 +326,7 @@ bool bch2_extent_merge(struct bch_fs *c, struct bkey_s l, struct bkey_s_c r)
 			    !bch2_checksum_mergeable(lp.crc.csum_type))
 				return false;
 
-			if (lp.crc.offset + lp.crc.live_size != lp.crc.compressed_size ||
+			if (lp.crc.offset + lp.crc.live_size != lp.crc.uncompressed_size ||
 			    rp.crc.offset)
 				return false;
 
-- 
2.47.0

