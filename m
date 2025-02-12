Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B14209663
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739383869; cv=none; b=eCsvTP01plyjyDnKNLC7m/EHYPoahQbihwLUylGZopb2LLVDbEOIv36ygDdTva4o8HPoBD8kSRcVK8q88Ra9F4ePY5RvNtJIomJLJrLSzQldrIgHgie8DzzgFo4h/ZNdYIWj/RC5yAJOfWX663E4SFEM85wZ8NesBIcysR1ztCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739383869; c=relaxed/simple;
	bh=dpQGZ/m6BI6kTxeBKA8Jo+tXH/ZDpD5O1KXd+9Jwbcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQmHZulhCUbQPK25Q/hXNurtlaXXX9Sr7f2K+H3zFC2fHFIiWzeWS+xRK07sKlK0ny3jepzWg84jwh1NzCN5JElPHK3gq5+GekceAHF39aHU4/4XHbPYkE9xVuK+9xr6W1SuYObb/5X5zKLyUefBeJGgCxqwpzLfP/LVf7tnKqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EUQ+oIr6; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUQ+oIr6"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47191bcb2afso27393801cf.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 10:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739383866; x=1739988666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pVUX40s0Vv3EPme6Y/lkWOeBsuWZ0rz7wMp5Qzxp6N8=;
        b=EUQ+oIr6y7HetdB2CVtr3T1D0NmdeAFwIx5keOfCi+2Vp/2BoL09A155fJY2ItWn9l
         5qZANq52FvRX/PXFzhV7OLcW4VWFFIpoDmeWfaJxCfyaOx6Z+wXPFOlYG09pUSDGe5MP
         83Vhuk0bAyIwhil+/171GjmduAWfayTinF0pGgrNyoPZGi8o4zANJmB7lIEr4OI3olhW
         irI9UWP9PEZUPiSiy/eE6jFPvXDleIC0ldrDKhgXzlfzl4AS0eI38esEdt3QpJZuS6gC
         lK4Umnpwi003BzPGmpVsMjxWZHTqyQAJKfA6oVxvqmNR2xmu00aHsHhtlWks6s2kvv59
         XTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739383866; x=1739988666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVUX40s0Vv3EPme6Y/lkWOeBsuWZ0rz7wMp5Qzxp6N8=;
        b=j4tSe9Bl8qu4BdzRIpS6En9NzYr+6ATNg64NF4ZjfsnVQcX6UYDhyaYbb0JNiAVfRL
         ULgZF9BEH7MKD1sIxDhSwDuDkcckx0wRxa418pNILfoB9CFNFwO7qgiVF+jh64tDJ5vQ
         YSpEzqr3Ze+8urPNgpBpUYu6wNn1SBPk5azWrNldBbSDp6uu55Hc8sBox+tCSZfcncmj
         7/ln4Zpov6fwCKiolz/rT9eJWlaMY1ikqwb+h4cv7Iuvj8FoaFegLgJLWat+7jHKBR/K
         Lb309g90+wbRk4OKTX587zEIP3hzUWfvfGwL7UXNZQVbx6teZ6trzvph6s2Yq1jUyO1j
         Kt8g==
X-Gm-Message-State: AOJu0YyVC/pKOeX3jR+2+h/0jWpfiqfLKJ/kilZMNNXkA+fP8CYacQoD
	b1oF/QbWDzlk6GSrXpnBWQNTpYhNs+5+PS1u/T0PiG5gJtrbxOzf/50hzisJK+c=
X-Gm-Gg: ASbGncsI3ms88PUbanRJjk4cFdLQJDrI/dn48zxtgfPxZ4yxQpuyg08U9KZXUGC/6+h
	g072xiNGwhMea2Oitc0aOerYji8VurgmazEpE3zMTmO+HanHkjGD0x9m4GnE1k6ciFaKdkvOOom
	Rr+nkoC2al4eoQnkbty7ebiItABTv+9Xww6CdK/r5UF0ZJl/9GLLhR0o6gZ/8FY0a3nfa0uk9r6
	OfNqhv1JqF/0gFd7xEV8UW2teWqDE6/nJ460eWvaaZ9IJ1ifmp8vxOxFzWyuWL2Xg==
X-Google-Smtp-Source: AGHT+IGyniwBEOYXEPmYH6y/5smwJ72MtejCVhSCUR2hcd2HafBKExg7XgoZFCaiErt9VKipXyy02Q==
X-Received: by 2002:ac8:5915:0:b0:471:bf71:cbc6 with SMTP id d75a77b69052e-471bf71d4cdmr1489171cf.51.1739383866391;
        Wed, 12 Feb 2025 10:11:06 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4718cb6d2b0sm48080121cf.16.2025.02.12.10.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:11:06 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Pass _orig_restart_count to trans_was_restarted
Date: Thu, 13 Feb 2025 02:11:01 +0800
Message-ID: <20250212181101.142433-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

_orig_restart_count is unused now, according to the logic, trans_was_restarted
should be using _orig_restart_count.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index b9538e6e6d65..0045cb7f4c0d 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -739,7 +739,7 @@ transaction_restart:							\
 	if (!_ret2)							\
 		bch2_trans_verify_not_restarted(_trans, _restart_count);\
 									\
-	_ret2 ?: trans_was_restarted(_trans, _restart_count);		\
+	_ret2 ?: trans_was_restarted(_trans, _orig_restart_count);		\
 })
 
 #define for_each_btree_key_max_continue(_trans, _iter,			\
-- 
2.47.0

