Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB031F707C;
	Mon, 21 Oct 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729519805; cv=none; b=BOc9PgQYySm00vnRH/9BUWUyz/rvr3iBNwVrZHS3CpyGDGvrjxPaVo1PkcUHQYWnUSK4DCJATbozSbcQSXnDEOkFlvozy3ZS1hnfd9zSVuIMxIhLR57YgNgSSW4NtChec/SyPU5dgpPUfP8/C+H3z0+fScULydbhQ7/uXMlcu7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729519805; c=relaxed/simple;
	bh=aWqJfDtr1WLxSrXwC2iHBRW21sac1TM1r/xJvcNUXpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cMGS0r8FirZABfzm4GtfPcw9mglGhBK0f1vv27Ve5CyBYFThyEN0B8Mix3xfGP/HL4k1JLuPcx2ro1UqF2rCkpZo9v6viMZljRkgxoNyYof+fJzM0O0N/UV66wQlnSBoaubqakLMeKz557l5n5r5B+2ZZIyt7MAFUXBkdmvpbsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YiL6J7qg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YiL6J7qg"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-208cf673b8dso44097925ad.3;
        Mon, 21 Oct 2024 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729519803; x=1730124603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qxv2dgjvYQbymudz8eTZ0SbmPBDb4Sl1dWbM5rEKIjs=;
        b=YiL6J7qgxHFFxxVUtSPMv67c5jQR946X9+6YCv/luFKUYgFAZ6vzkxAF9DWL6X8jXy
         Tx3EopVFnJlc2PcGjyGKNXOhAcH9Rfxt0VWERVOxkWZeRaxlJITGT8cqxGhNrT6WJqLo
         W1Ayl5dHGcTSszwP4nzNf+8KAqzAKlDm86MCBF/b207vkdhYKLBpRP7Q1m1P+yZFs5s3
         yg1IQUViLUpLYGg9UBQ8HTcao+FqwA8UIHgcOjdhA3Umqt5jNUGh36ExG6tNS04uHWp5
         hALdFBg6CP+etkoEM3OlsCQ+gC1T01Y6R1Svu3/14WNUS6M2KT6CSSnWpCCX1/fFZi8U
         PqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729519803; x=1730124603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qxv2dgjvYQbymudz8eTZ0SbmPBDb4Sl1dWbM5rEKIjs=;
        b=T4MmUUQUhSPETG9k4w44kUm2kY7l1zUBeGkS4OYy+hClnx4+Mgt/TwcNzxfJqytqYN
         ni8v5kXK9W9OhKcwbRYI/5korvOCYjG0N/A6i8FhWFMhlAWOLuj+WIvbWuzgX5Fip/oj
         C63HRvaKZFg636+jyvOdzbGtM+B1DJvGxJ7ZMHOyEQsiFdq6Ml3JRakEfrmVOW0Ky6KA
         K+obn7htsVqGp8kc84mTMddkwJ/QHRtrp1bgbpjK1KasUGx/RdWa42hzCYDaN6jGMjG1
         D3HmsTTTiXo8aYS8o0O7XKFthaeHNvePYB40JY8c6hXM5aP48wnDY0j2eyJm48JzD/CA
         ZIeA==
X-Forwarded-Encrypted: i=1; AJvYcCXEraE7cPxBp6Xlo83E0PVIBe9WUrhgHG3Jjy3yLSf/Xn/W/qE7Nr2nBBHsZcX4J999gjigcqxmGLYOwps=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4WIvdfxPlgNKhqfV/Bpsyk/ca2UFZsE8BXqYKtAekyFa52Sh1
	OrT8C7vrmbf+JMRJz1iFQp5pj07HdxvTiZEvvIWdj63qm0Kgucd18zU7LSZe
X-Google-Smtp-Source: AGHT+IHNfd9djThyafBnFt3aEztsWsquUQUDXs9ETwa22grNRcqHt3oVsVHelkArFPqWoZ9a6klNtg==
X-Received: by 2002:a17:902:d491:b0:20b:9f8c:e9d3 with SMTP id d9443c01a7336-20e5a932687mr189208305ad.55.1729519802695;
        Mon, 21 Oct 2024 07:10:02 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0d69esm26340815ad.102.2024.10.21.07.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 07:10:02 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Date: Mon, 21 Oct 2024 23:09:49 +0900
Message-Id: <20241021140949.29204-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
To fix this, we need to add validation on a.data_type in 
alloc_lru_idx_fragmentation().

Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/alloc_background.h       | 3 +++
 fs/bcachefs/disk_accounting_format.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index f8e87c6721b1..66a334e2edcd 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
 static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
 					   struct bch_dev *ca)
 {
+	if (a.data_type > BCH_DATA_TYPE_MAX)
+		return 0;
+	
 	if (!data_type_movable(a.data_type) ||
 	    !bch2_bucket_sectors_fragmented(ca, a))
 		return 0;
diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
index 7b6e6c97e6aa..0232bc9f590d 100644
--- a/fs/bcachefs/disk_accounting_format.h
+++ b/fs/bcachefs/disk_accounting_format.h
@@ -72,6 +72,8 @@ enum bch_data_type {
 	BCH_DATA_NR
 };
 
+#define BCH_DATA_TYPE_MAX 10
+
 static inline bool data_type_is_empty(enum bch_data_type type)
 {
 	switch (type) {
--
