Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBFB2C184;
	Thu,  9 May 2024 01:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218992; cv=none; b=AQSmbDXwCSX9cPaGLkXTTUqXhhEdMgRyem6aYxXTiymqRdt0AdNxQkYTbADVAFuthTRzPQIGI8/fT9cVwraHA9ucddsKKG5zIKeQHr06ke/BzBdywFPY7j07nLpBHEsQqIbdnKuX3YOaFsZJ5yU2HzhNQg54+zhAovqqr/Xnn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218992; c=relaxed/simple;
	bh=h4j9talqhyuZO0E63OwVJsILnahc4H2nREvymN3UlsM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZQ2/vlqsbeV2TGgHFUuKQNSrsFzSw5jmAkiu3X+H49IfhTQNk6+PpI/iJ0GTd5ZWoenDaEhYKRUNEBmdIy07jq1VfT/EPRQEBJFV0jf/LLdbHkTTbBtMUJ4j1bF8tAMxSB4tgiccvmhiMIuFQ+x9qYmw/O35siCo4xFUBqlk2xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jm/3O7F3; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jm/3O7F3"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6f4521ad6c0so376134b3a.0;
        Wed, 08 May 2024 18:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715218990; x=1715823790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jjW7YSKOnyy4HDgHwFaP+V9/m7qnEx/jJqBTszrsdI4=;
        b=jm/3O7F3zAAiZopNEw7ksc2nKKPFDRFQj3QIccLHVwARNh0+4DEczQgPpYk5gtgnPK
         I9oZvFDXWXRKEWOCv1adxXYmSPdzOv+wSar/UeAO6B6TB2eHF+rKOPNoAdkbqDTo7Ebm
         TqlibBPk8b8cURsO1EjF7lJ8qNQGy9JPXTuBpYB/pi6mX6wrR7TG/0hQH9XSZqR7Fh72
         2zwvwXA6QjtAw6vA1fAH2aF12oz2+zQW2Ik05A0NQN3D/i4vmu+dc1e1YJLe20sYPMz0
         +66WXLuD8CJUnOGcC6Os4v/Mifuf2mu+k+qNFEPo+1uAKKw/CrNww2hfgq55j1NCA61R
         fI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715218990; x=1715823790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjW7YSKOnyy4HDgHwFaP+V9/m7qnEx/jJqBTszrsdI4=;
        b=JmEo3DMQl6Xp4iO5BWeYCPgXr0xE0Ca30CU00L+uignb31/36S342+9/28/dobS6Hg
         xEtPNztOugbOEZ8chbE4wiAWVisfMn6IciWBGiF8m3BcRMWPANyC95g8pFTIgvxtGU0G
         pXE04zur7Zq+D6EJ8MDEklH+e/yVKpQFKojEj5DGl+UCqK3fd5SiVGZtk4Z3InKwMfWL
         Fdj8qkqhdIW3Coc6PWogyilgvjDI4kQzA8uTgrWtOk/ZurUUDrfz4qjrysVuO9H4ufgZ
         orHecx3mq7OkymfXGg9mjJMbeYR2yv8c7WgVg8wX+c7KMmEFiPvVKD0cbVseE76hq2DX
         RHVA==
X-Forwarded-Encrypted: i=1; AJvYcCVQZHQSxfIXu/BmzJiTmqroDivP2M8TawpsLzcSEQbn/pUYLB5TU2ElKxWmP5k8HFckhM07bbCjExUy8KtKvlchPSZQc83MxNNiTr3/Q5QnOADaGcH8FnnmGKxIAXAHnbpHc7Gfg2wpwSrtFbk=
X-Gm-Message-State: AOJu0YxJbDd9z0n7aYYu611pkEiBFlurwweKnL7dAxHFLb3aWkh8BKk1
	T/qj+YS7Koe4QR02bBAqj531VUDPVTt/N9Om9fd1IU+jKOREkSgG
X-Google-Smtp-Source: AGHT+IFmkk+RN4SAPT2N/WsCUf0ibrNJZW00a4c6JrPl2HoG/0dP87BFWLlNe+U5nR+D2xhFLeTu3A==
X-Received: by 2002:a05:6a20:3257:b0:1af:6a37:3b8a with SMTP id adf61e73a8af0-1afc8d26c83mr4209898637.16.1715218990533;
        Wed, 08 May 2024 18:43:10 -0700 (PDT)
Received: from localhost.localdomain ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2d995sm204497b3a.192.2024.05.08.18.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 18:43:09 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: guard against invalid bits_per_field in bch2_bkey_format_invalid
Date: Wed,  8 May 2024 21:40:32 -0400
Message-Id: <20240509014030.671222-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A check for a valid value for bits_per_field is performed for each field before computing packed_max.
If bits_per_field is invalid for any field the whole format is deemed
invalid.

Reported-by: syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/bcachefs_format.h |  8 ++++++++
 fs/bcachefs/bkey.c            | 18 ++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index d5b90439e581..9e688a8d780f 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -318,6 +318,14 @@ enum bch_bkey_fields {
 #define bkey_format_field(name, field)					\
 	[BKEY_FIELD_##name] = (sizeof(((struct bkey *) NULL)->field) * 8)
 
+#define BCH_BKEY_FIELDS()						\
+	x(INODE,        p.inode)					\
+	x(OFFSET,       p.offset)					\
+	x(SNAPSHOT,     p.snapshot)					\
+	x(SIZE,         size)						\
+	x(VERSION_HI,   version.hi)					\
+	x(VERSION_LO,   version.lo)	
+
 #define BKEY_FORMAT_CURRENT						\
 ((struct bkey_format) {							\
 	.key_u64s	= BKEY_U64s,					\
diff --git a/fs/bcachefs/bkey.c b/fs/bcachefs/bkey.c
index 76e79a15ba08..f7847c96a105 100644
--- a/fs/bcachefs/bkey.c
+++ b/fs/bcachefs/bkey.c
@@ -638,6 +638,13 @@ struct bkey_format bch2_bkey_format_done(struct bkey_format_state *s)
 	return ret;
 }
 
+static unsigned bch2_max_bits_per_field[] = {
+#define x(name, field) \
+	bkey_format_field(name, field),
+	BCH_BKEY_FIELDS()
+#undef x
+};
+
 int bch2_bkey_format_invalid(struct bch_fs *c,
 			     struct bkey_format *f,
 			     enum bkey_invalid_flags flags,
@@ -659,8 +666,15 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 		if (!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) {
 			unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
 			u64 unpacked_max = ~((~0ULL << 1) << (unpacked_bits - 1));
-			u64 packed_max = f->bits_per_field[i]
-				? ~((~0ULL << 1) << (f->bits_per_field[i] - 1))
+			unsigned bits_per_field = f->bits_per_field[i];
+
+			if (bits_per_field > bch2_max_bits_per_field[i]) {
+				prt_printf(err, "field %u uses more bits than allowed: %u > %u",
+						i, bits_per_field, bch2_max_bits_per_field[i]);
+				return -BCH_ERR_invalid;
+			}
+			u64 packed_max = bits_per_field
+				? ~((~0ULL << 1) << (bits_per_field - 1))
 				: 0;
 			u64 field_offset = le64_to_cpu(f->field_offset[i]);
 
-- 
2.34.1

