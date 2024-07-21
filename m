Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C682EB1D
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721565815; cv=none; b=k/LD12gpPHJyHXuIqWkKh4oVETxa1Q9TrSA+6PkPCzJjAsqcClFB0rHZh4r8qM+3nMmzoq2VvdYgKU8XGAtCkCsFjbK0Av+M6YiekfD0u0Uv8Zqp5aK7l0q9y676l0ua7GKLGoMr8rUMxZMTOG9gKLhBEGWehPiLVCnnPWKUI+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721565815; c=relaxed/simple;
	bh=XZEX1Zib4814mHMi33U/eVnI2RUaweyE1zpQrDwlu4U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ir/autvDqxYBoziRErRMhxJ0zeHlizXRGnIy1xIhDuZXPtfDGaCP4KZpT6vUsw1Wwf+BxIpVcSeFuSo1ZmQmC51QMZX/Ju3BU3FR6nkKifAOL4U9oJP7uqiia6vbfW8TZ1LRi/MrcFjmaBDhN80BWpioAYtTRKfXZcXoAJktcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7r9OWOR; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7r9OWOR"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7a0e8b76813so544014a12.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721565813; x=1722170613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jQdBPKRdkqMsjcrWmIKRlq9gHJPvNmiK7G7OMnIV7Rg=;
        b=P7r9OWORjA4chFr917WcobmQAz/+/2s7qKRIRWjogYOOuQcrdQDLD64dfsKIh6su5A
         M4UGohEXUkyVQp2Xhq+NPEZoY+T9Sckp8Ad6bAhcGrsU3QdRBJq+PBvnElYXxWl1bSPS
         QNk6wBi3gWvPWuhFGbeLCk+kWMmRp4qcrWOefI1tNXcT19hC0qzUvb+/Soep9DUR54CP
         RFWeHFrrpTJ4zhnjKEoBgiWrM/kxaX5cOeRyUOhI3+IpYZvx55g+9BdKZz88azAaawaD
         qzh1cvDxIeoRjfcYeADrnun+0vNKyhab0aG4Nwgmla/I1FSHosHXuuGkF3BbTnwSzBHF
         rAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721565813; x=1722170613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQdBPKRdkqMsjcrWmIKRlq9gHJPvNmiK7G7OMnIV7Rg=;
        b=sIEdRrey3K/i3BIKtsk5GDBfNLu0STh3dqg7pRg39TXtEKCxDCVaSI6uTC73BfHE39
         bGWVXkgn4IO8Pk27kiV8c9xx1C/tyoBF0WF8qmrZb0hZZ9LGTuPSxDQFzNl5KxiB5G0O
         lWCSeB07eMYI5ZCMf268tYjPH2GLT8+TcjwJ6dzpOazwbUB0PMEeXS0yJxl18EPc+9A0
         x91m2zaTje+sbPjoZnMMOM1SE/3oaWaehFLl93PO1Z5Zgrq4pahkZA0IO1LtP2F93Uzr
         /6olSqurDQmLHLpkkc3l/ACmjURMKnGND4JSdVWbIEEj1MFDF23Ak7X1fvirTkNPiC4G
         DSFg==
X-Gm-Message-State: AOJu0YwU9aGVIQTF044PF8rBRjc3RJqbRxM3bc+RyHXtDYWIG5IfwvjC
	APMcyXJ2WWbYA+U+QXn7GbN1jQr+llFo/TNmm8bKK85ANgZQdjQU1ea4FRV0m88=
X-Google-Smtp-Source: AGHT+IHztqMI02TrpBpcsRTt7+GooRD97gmLigKNJaoh5rfTg6rU4Q3vlpbOdy2hW/92VF5Em8aV4g==
X-Received: by 2002:a17:90a:d3c6:b0:2c9:754d:2cba with SMTP id 98e67ed59e1d1-2cd273d7d09mr3239984a91.3.1721565812882;
        Sun, 21 Jul 2024 05:43:32 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf808f08esm5010614a91.36.2024.07.21.05.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 05:43:32 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 1/4] bcachefs: remove the unused macro definition
Date: Sun, 21 Jul 2024 08:43:24 -0400
Message-Id: <20240721124327.247969-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

macro bch2_kthread_wait_event_ioclock_timeout is no longer used,
let's remove it.

The patch has passed compilation test.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/bcachefs/clock.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/bcachefs/clock.h b/fs/bcachefs/clock.h
index 85c975dfbcfe..82c79c8baf92 100644
--- a/fs/bcachefs/clock.h
+++ b/fs/bcachefs/clock.h
@@ -20,15 +20,6 @@ static inline void bch2_increment_clock(struct bch_fs *c, u64 sectors,
 
 void bch2_io_clock_schedule_timeout(struct io_clock *, u64);
 
-#define bch2_kthread_wait_event_ioclock_timeout(condition, clock, timeout)\
-({									\
-	long __ret = timeout;						\
-	might_sleep();							\
-	if (!___wait_cond_timeout(condition))				\
-		__ret = __wait_event_timeout(wq, condition, timeout);	\
-	__ret;								\
-})
-
 void bch2_io_timers_to_text(struct printbuf *, struct io_clock *);
 
 void bch2_io_clock_exit(struct io_clock *);
-- 
2.39.2

