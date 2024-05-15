Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4874F1FE;
	Wed, 15 May 2024 01:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715737779; cv=none; b=mKZpx7qzkfq36EW3JnvvdxEoQvZvUcX20Ce4YfjDiaXa3eNsVWK/vQjqsy46gTH4aKFxFv7t0j2H8ZCDguZMQ70S25h0HhQhWt9hK170PM8Xc7/GVWd/l7xI3lpdTVyvyXBzJSCfrnI1Toiq551VCwMEvZfmZCMkJ+4JoZc7Mjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715737779; c=relaxed/simple;
	bh=pvzjn5+bbR0c+haL5/MVAidccpj+9o808LC0Z+cMxlA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tex4lYlEszIWTCTVI+wzH5xocgkFIWTEGcbiJ9nlBz3+woT4MpjGBH6HjqIs5EFLfG5dtC9mXYcAEiXWJxPGs6rRtr7LKlUGDPTvXFOigop1oxXlguulHf3RnM4So45/a0sypBH/vxTvjydcdGHwaADISMH2A/nqNuYvEeLaYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kk9X4Fsz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kk9X4Fsz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ee0132a6f3so48007805ad.0;
        Tue, 14 May 2024 18:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715737743; x=1716342543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5kQ1NfQplOskT4B5ZqgIky4P0ExeAiR7M84edP4J3wY=;
        b=kk9X4Fszq0tV3IL+k7hTWhXPkHh4ka1Kljqs2c+Lds8YnVEw9tNRobHQ2NU0vpHIdq
         V+nBJ6R1h1NSt0KTMEIT1DflD8LDCmSNxT4ch+/wT3+lGT4KyWshKLTKRwtK3q5n7mtc
         mDeFUTc8lxxlhgTyBsh8iC+hQp4Xcdt44agxsCiihMt7Qp05TxHOuuB3fMQCt8YxE4Cq
         J2v1fxh8BuXokHpR7K0R51MsizMWiZ303+ulKbv8yleGftn1nnoP/u2GE+BoovvJMnmL
         zJknkt94W1TX1uT3nlhSyzVeQcHbc3X1vJa6SF/TjFJKJiEae1bjWRptI2YNyM6QeAAh
         lsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715737743; x=1716342543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5kQ1NfQplOskT4B5ZqgIky4P0ExeAiR7M84edP4J3wY=;
        b=czpqkvkef9etExJXPi44akYjMTI2WmpevDwBOTwSQySGLonH943GJVTrXJwP0gwtAn
         VW25c6JAbTO4M0lfAyfgAi43W0Idok0j/rgDA58FSH5KOHouM4Q8tq5EwKx5JBj1mzZF
         woIB6pkNVzWIW6wdFYw9eN/7ROn042x/CARlIb9lCdUmCfrk9AOSgvLIZX6rPfuOm88J
         EP2ZuheLjwSCy9JuSDP7xfByvCltNv02D3VPEtmx4DHAV43wIICpnGT+0n1d+wgMyIAt
         TQh5A8Fcxt94BK8bGhazfAfJa5cOf0ibmJ4yxPEJmK/fd99LGqAqEv0xO3Rb+G1Q+vnT
         Juzg==
X-Forwarded-Encrypted: i=1; AJvYcCVxJiood5vmHPTpnEhhHNYLYRAHVjTeJ/jr7JkYg7u5J40biI3mkEp4+aDgrpNaPVQRdPlOlS9jMsD8mDZK+RSvHlYBohkS8doELDm8Ptxcdl4osKudzF29g9p/yY+8K0/05DFhib366e4s09E=
X-Gm-Message-State: AOJu0Yzh5BLrGxHk5XrKqbpT/EsyeSwrX6JumgIMkwOS2ybm6ySNcrOv
	RGe8x1vtzIDXyMRxvoINV8QtMzP3aimDQieWKOU0hXemLALECqD6
X-Google-Smtp-Source: AGHT+IEYhfu4JIQARBLlRTK82jbbq24FhpCzudO3FGRm+9VC8IHIV63l+67Dn1fzRpfFXaPAb+xLfQ==
X-Received: by 2002:a17:902:82c8:b0:1ec:5f1f:364f with SMTP id d9443c01a7336-1ef43d18196mr132940295ad.26.1715737742825;
        Tue, 14 May 2024 18:49:02 -0700 (PDT)
Received: from localhost.localdomain ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160b1asm105738195ad.275.2024.05.14.18.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 18:49:02 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
Subject: [PATCH] guard against unknown r->data_type in bch2_sb_dev_has_data()
Date: Tue, 14 May 2024 21:47:22 -0400
Message-Id: <20240515014720.2482142-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shift is perfomed only when the data type makes sense.

Fix a missing guard on r->data_type being known.

Reported-by: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/replicas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index 678b9c20e251..0fa91d0bf951 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -1006,14 +1006,14 @@ unsigned bch2_sb_dev_has_data(struct bch_sb *sb, unsigned dev)
 
 		for_each_replicas_entry(replicas, r)
 			for (i = 0; i < r->nr_devs; i++)
-				if (r->devs[i] == dev)
+				if (r->devs[i] == dev && r->data_type < BCH_DATA_NR)
 					data_has |= 1 << r->data_type;
 	} else if (replicas_v0) {
 		struct bch_replicas_entry_v0 *r;
 
 		for_each_replicas_entry_v0(replicas_v0, r)
 			for (i = 0; i < r->nr_devs; i++)
-				if (r->devs[i] == dev)
+				if (r->devs[i] == dev && r->data_type < BCH_DATA_NR)
 					data_has |= 1 << r->data_type;
 	}
 
-- 
2.34.1

