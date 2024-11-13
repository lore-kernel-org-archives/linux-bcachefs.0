Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE118756A;
	Wed, 13 Nov 2024 07:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731483822; cv=none; b=tYwI4TW/bpzmNay+6RXTv15mEZyBfKCnx5Wyyiw5UDg6CJxjZioEh0SGhItjmKAcGdRDOk0F0PhFhYIsPqCjuqTkmIfCNdINZC3cbDA5OvnDdsmtHjOiz6hcBzjznPnzFfR9HQk1qX7QeUbtHJAu/xfH5vQdjkj8s5ucFdkMTBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731483822; c=relaxed/simple;
	bh=+/fW1zWJHurV/kLnsLooVPcZLtMIU03UKT5faq/VO9I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L/6FKEQXIjrEMHntrHWv5WwRaQZKd+fOFNgoUq05Qi9iX/gkwcDb2sS2bfpjOxyCLd+NmLiuUkpmJVJt29D2V3T8tMVGVZaUYV2aq2SWpzDFmOKU8HiApInfDjc/CrEMvGSsaSTBCniW2E1rfVoEYM9uxaTn7fj2D+rwZBOdVoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZh0AMdB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZh0AMdB"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cd76c513cso55995725ad.3;
        Tue, 12 Nov 2024 23:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731483820; x=1732088620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=upf6P3i4nhBziNY2BpZ8k3Gvo865eWa67nQuWf0E1h8=;
        b=eZh0AMdB6ZCv+vxqJanTVqRLDMFjwbN+cIfGYlSKzmg+fg5yyzqUggDjFGoUYFBKsU
         fvtTwmB/RmIb1ZMuy/P3SpS9RpPRfcYiSueP1s0ri8Vrk1zLvx/gEDwucvBl9xwgJp8J
         fdcZyof07M6cFcOscwqvtr5Gm01MbbTlGMB7728MyAwCd0bNKUXZXTa231ABlyIANpT1
         x1olM0ltOKSZgDGtRZJeHiu6JifRqv5Q+d87B6FlQ6/ioVkxgnDpaadzSuXioGdnKJru
         qG9rfNUZ+TP4NDXSReKD07OdEpGe+Hb/0hetGn/CaaxMoVmE8zpE6RF883kR9LI6mYnS
         yG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731483820; x=1732088620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upf6P3i4nhBziNY2BpZ8k3Gvo865eWa67nQuWf0E1h8=;
        b=Th89MwaTWF2Bc0F3mJyX6AanBmp0n7fsKF0xZ0KcZXofnu+7+O0abfB9xfTCxfG8g1
         TQqI6WgCFDcEFnwatNsckALXOGMBXlzAiVXYDlSmYh3ifrdfvB96KwodaRCMGW/OkJrb
         3TR5LYeW5EFw3pALz/6ihE/HEhsS+wvgMRqix+V0JPGeV+7mewNLbwZ6K1B+3EnHJSpl
         qcypChD1hk4vcyRvPalm4cQ/Ka6aKmiGjki0c98OrGX/lypHiYVnB3Ilc+00XKne5g+c
         VRDZBNM8Dz2r15MZkYgeN1/D1GEB/6xF1Oa0U/FIRjgUh2Un8vds1DJg+DDZbl9V/XTL
         cDww==
X-Forwarded-Encrypted: i=1; AJvYcCVYsXFqBQOEFAGdIBj4qIRhqRB2ud04+kC8Qd/cQ9/mFycPRfPAZcyqmm3FDRcuEy5baoe7lFsEV0Z5CHLULA==@vger.kernel.org, AJvYcCWZL8WxrqzCtK0cp87OXHSiJ1Arj/L3hf4FNf1wBVO6Nod1Msw4Ceb2pzc70j47P1uT/85YuYySE41t759i@vger.kernel.org
X-Gm-Message-State: AOJu0YyVT/QCoFuV2AGNkVV5FAZlOVrzHeKIAE9eGsElMZ7p4Ojozedp
	OTbcBVwFlqyvur3zb9oo6O+7FxME9E2asXl/Ocsu81rPuutce0HEpMQtydpU
X-Google-Smtp-Source: AGHT+IELq6864v/j1VzgO9DxnzrOoA9RVRUguRRW1lhq0OEd3cr4ZKk3S6LZYELaM/NoV140IEMEXA==
X-Received: by 2002:a17:902:db06:b0:211:6b21:5a87 with SMTP id d9443c01a7336-211aba52314mr71155945ad.56.1731483820134;
        Tue, 12 Nov 2024 23:43:40 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-21177dc9068sm104398875ad.2.2024.11.12.23.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 23:43:39 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-kernel@vger.kernel.org (open list)
Cc: Daniel Yang <danielyangkang@gmail.com>
Subject: [PATCH] bcachefs: replace deprecated strncpy with strscpy
Date: Tue, 12 Nov 2024 23:42:48 -0800
Message-Id: <20241113074248.175133-1-danielyangkang@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function strncpy is deprecated due to not guaranteeing the
destination buffer will be NULL-terminated. The recommended replacement
is to use strscpy().

Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 9bf471fa4..37e98695b 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -364,7 +364,7 @@ static noinline void journal_transaction_name(struct btree_trans *trans)
 	struct jset_entry_log *l =
 		container_of(entry, struct jset_entry_log, entry);
 
-	strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
+	strscpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
 }
 
 static inline int btree_key_can_insert(struct btree_trans *trans,
-- 
2.39.5

