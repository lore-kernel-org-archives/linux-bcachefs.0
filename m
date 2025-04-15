Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB582DFA32
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 05:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695204; cv=none; b=BX33h6ZMbi8XC0KD4yzXDumrva2ocYIXnuy50uQRjY+z5iI9Wc6+U36WAVmJhu3Qrf3yEQ0ENuZjRNoKPEOvRmD1+eeXwErF3m/wNIbFqGJYGWgJ9codNhYM2ObDtW5Dvbt8F4SV3vaDyLhApl6XK4YTSFqQEGfbu+CggaDi/+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695204; c=relaxed/simple;
	bh=O89HpnLSAp2LirSdB1JJblUULJH3o0UILbxnZj6Sbj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0UYBBU/Yfv7Ttl2oP3bGUpIfboIADzi5udYnYCW+IXeIKFGBE2dFF991z8D+3yvXLQZzof5HYdY3LZs8ednkUcN41yKz3qUUDjmElJziFT1JVuHpJRczvRpQZZ41HApkmH1FTPGtyRQ6ZGea1yM3l5PrUBvm7dfW3JJaQ+F3Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EN3ofgya; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EN3ofgya"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227aaa82fafso40424905ad.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Apr 2025 22:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744695202; x=1745300002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+OwtvwEyDUNaqcCKMNFRcvwwYx8d1v1TeWQGzTbb+o=;
        b=EN3ofgyaIxTuKUchb9MMsLjuBLFtKN8xIJBOSmFXQ/qfNYn2We65YfOaYWDs6dAskw
         LCKZOYIWicM+fCEtRE4KthhNJ1atB5MmQqKpcQh0cTObeg65kEGBIJWiFPeFFQEWyhbA
         dnGvQ0EDjL6POQq9+bupSfU1aFvTkoUv5vXAofOpqxmb8GizAJOlhgOTG3dbcDM6PWF7
         xOphUv4H6OlSbzblAXWss7M/DwoiEtGAthULUL/+oDoz59knjmNpKUTg26reZvLfSpzk
         xDIMR8G44kSgJDyyQDqFqOWCdRJHryKzKJVnB8o7uNo2rzmf9RPEVpWsr9RHZP2aqWqN
         resA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744695202; x=1745300002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+OwtvwEyDUNaqcCKMNFRcvwwYx8d1v1TeWQGzTbb+o=;
        b=rpKgNWoHxlyrT7zN2FeWyZJJ3jG6s2J7l2slCxuZI7+mQa51FUOANsWzGo6jDeZbOO
         QUbmpD6dVRFOA2cVUn988xcgx3CjWVN2dSV9412T2gND5uJxacnhjA6sqSkVWL8dOw+o
         /wP+8jEuAojWPDNCgCBTZApQCqJ7RchOpPoBRV+QB5NVO5bxNEdMccR1lSbCISe5q8Vb
         JFJG0DVv5tzMyZ99sy218uW7vo2i25vSAdLA/8096vSUDLEPhA3BlaQjV25mAYIvZ1xB
         8/XkKDvBFEVjeSmfjcRPVPoXgLVXPYZ8IRYegRi9KR0TSWpR9CoZIjXsDjDH/tNMY3zz
         gjyQ==
X-Gm-Message-State: AOJu0YxumM4x3kHsdWgrBcHbnNk/OmuCGq/wxGiXuBD8XITi3BRPbM1v
	z/SCIwMRVb6ccoUzTm3uOYrN+XmF9A4k2mS7FVWPfa5Nu/r7JLk4
X-Gm-Gg: ASbGncvqJB4r/lhO/4xtlxaNR0nG5Da2yUI+C27IXfuGgUmgawxGC+7bcxhhnxXAc4d
	ylljVFaHu2kLSTrZqqI/P/7tAetFGWp6pgavqG3paTfk6jZp09OBDsfwMiDm6nSqlRtZwMDpWZ5
	Za4iyaTvzOvFCshZYCFAZFEhDUWCM+vWsvTNdAgx3x0iKDDCLAAwct/I2bJvrOojpxoLRgZgmia
	d8bHI7fgT7rVyR7GEQK0DdnQGTihutiE5wW4NWRgaj8YMpi5Vx+v6w3/InxpyKTp22dxEh5Wo3P
	TKP7J5n507ImpA0=
X-Google-Smtp-Source: AGHT+IEhdOIcXRT/oEI98BYmYxkynARXD1vQRSaumlOcmjQZSHgjJDqgFeAQTmChtRkqkscSqiPBHQ==
X-Received: by 2002:a17:902:d481:b0:223:fdac:2e4 with SMTP id d9443c01a7336-22bea4958f1mr182583185ad.1.1744695202548;
        Mon, 14 Apr 2025 22:33:22 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b628cfsm108693465ad.26.2025.04.14.22.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 22:33:22 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 3/4] bcachefs: Remove spurious +1/-1 operation
Date: Tue, 15 Apr 2025 13:33:06 +0800
Message-ID: <20250415053307.81354-4-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415053307.81354-1-mmpgouride@gmail.com>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index dd109dea0f1c..c2e05824e99b 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -656,13 +656,13 @@ static inline struct bset_tree *bset_tree_last(struct btree *b)
 static inline void *
 __btree_node_offset_to_ptr(const struct btree *b, u16 offset)
 {
-	return (void *) ((u64 *) b->data + 1 + offset);
+	return (void *) ((u64 *) b->data + offset);
 }
 
 static inline u16
 __btree_node_ptr_to_offset(const struct btree *b, const void *p)
 {
-	u16 ret = (u64 *) p - 1 - (u64 *) b->data;
+	u16 ret = (u64 *) p - (u64 *) b->data;
 
 	EBUG_ON(__btree_node_offset_to_ptr(b, ret) != p);
 	return ret;
-- 
2.48.1

