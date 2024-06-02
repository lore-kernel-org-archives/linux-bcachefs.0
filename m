Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B667A5A79B;
	Sun,  2 Jun 2024 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717350516; cv=none; b=pQrgMXK8nlEey1knqDb2e52SljEx5m9ORikpVQ32D0krhOaEN3+tJVsdwRpY5b4TxnzcH3KgU6LULWa4jSBk31hc1XbL9t8oe9r97/Kr4WJ88xquL2a7dhgbcvNR5AkAxcEy9P2PGwHv3IRvis0uFycxdluS2Vr13hJRZqAUMVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717350516; c=relaxed/simple;
	bh=HZBhpsabW3XZ2JWJtKb+cvqE9wv56/ewsCF0Su26CXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=urRAgORlC43gWNM+8HLGmXCIxXCuNVddH0Wohuy1ankZlaWkQ9cZELcPlJn4RmMvP/cNjnvpwYJcublUFGeWkrxH8qnUDNNnqtRs5D+02B+eQyrkF5weDOMOAvKXRiwWtOZabLApRjGFM875MivfOzf2+1hRfvsQ13dD2IcZecY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMxeeCOX; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMxeeCOX"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2c1ebfc4e6bso286942a91.3;
        Sun, 02 Jun 2024 10:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717350514; x=1717955314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z17ZhyH6OHFIWFfmFYlugkpZiR9dmaOSQiVuQJAdc+Q=;
        b=mMxeeCOX3PQ9wuoQJ4uzSReCdoU77boUP7CqTygwEfnO5IDcBg6aDuv02FgZZzHAvf
         9TfQKjhwuMjYuhf8ITzDS0chmnLPO4SmGc1xm4optuwOwHVuEbaP3anI5fsH/ZDtAduD
         3twekq4bo6ke+o60IUkDW60VoyHGvEbvfoqsAhNBMlkwlpkUH5GXIbtzrHUSeMNr1/Rz
         IlAn00xCBHYi+QdC4ahB/KpQftX+fjgp/PtsPq5OzrewIV6Mq3OW0jytcrpNvFx+0hXS
         dLq/8m+Vtpvm4ECfS53cDZ5EHDVBIRQDOLG08E7Y4uU3BNbwzjgmg2Tv/FS3vANyLEhm
         7LFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717350514; x=1717955314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z17ZhyH6OHFIWFfmFYlugkpZiR9dmaOSQiVuQJAdc+Q=;
        b=dzN7Y4a0ccxEml9YAT34LUyiH6gDb18XNA+W64c8l9YZv5YqkuuGcJslsFRunfMVcH
         KlVVARNfA/w9741tPFlLWoVS+gk3SjQ3PiQqrjp2x+0ptnTgQk0cW/OliGz2obdWNWv5
         lNKhQB1k3ge9uvKgpNyia0L6n5WYlOAZwIp7eL8X7I/7SGL16rkyqA/a6DBjOaIXxoUN
         jiufvL5qJynn4D8RCZNclzngzXN+TPnmbEtpbrWSDzVM/0a9PDm5+bcsrSGkvscdfrm2
         QCT6dbJFky5xXCHqmiA6aq3a2sc636infLg5teihEZjUdMrO1zbwcPaxQdBo7XzLIH9K
         ciCg==
X-Forwarded-Encrypted: i=1; AJvYcCW2gsxVMVvPQ8vcXuoerHkQdfw0aSnWj6R3rI0VzhzUx812aL2K6qJCcwyAqNL+R143vNKtX/VjeMcvo6pZCOggic+aApyDzDlWinqppCU7q4dIWprsfVrT1D5w1YV1NO1KUITzYgP0eMvlL9U=
X-Gm-Message-State: AOJu0YzWTbNz7pvnG2/H+YlYLwP4s6D4pZnKwYpK3HYzBcYu2NvjcTgH
	zvczVZcgyDnlEaEaWSogZ5XMaSjMBSYVu/Jl/07dRfqa+Rr08Neh
X-Google-Smtp-Source: AGHT+IENhK8zQltv5hp7mgtlbP2tCvRYnj2FkWlYAQ0CSAUZnV9X/z/Poam/4TpvD/Wzx4pmWG1r2Q==
X-Received: by 2002:a05:6a21:6d9f:b0:1b0:1ce1:e7b2 with SMTP id adf61e73a8af0-1b26f2cc95bmr8041718637.4.1717350513914;
        Sun, 02 Jun 2024 10:48:33 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a775f741sm6481184a91.7.2024.06.02.10.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 10:48:33 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	irogers@google.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	lkp@intel.com,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] bcachefs: Fix missing assignment of minimum element before min_heap_pop()
Date: Mon,  3 Jun 2024 01:48:28 +0800
Message-Id: <20240602174828.1955320-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202406030001.jwsq6DZp-lkp@intel.com>
References: <202406030001.jwsq6DZp-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When replacing the heap_pop() macro with min_heap_pop(), the original
heap_pop() macro would store the minimum element into 'ret'. However,
after replacing it with min_heap_pop(), the code incorrectly failed to
store the minimum element into 'ret' before deleting it.

Fix the issue by using min_heap_peek() to assign the minimum element to
'ret' before calling min_heap_pop() to remove the minimum element.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406030001.jwsq6DZp-lkp@intel.com/
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/bcachefs/clock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 3ec64fe6a064..18fab9c44b1b 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -156,8 +156,10 @@ static struct io_timer *get_expired_timer(struct io_clock *clock,
 	spin_lock(&clock->timer_lock);
 
 	if (clock->timers.nr &&
-	    time_after_eq(now, clock->timers.data[0]->expire))
+	    time_after_eq(now, clock->timers.data[0]->expire)) {
+		ret = *min_heap_peek(&clock->timers);
 		min_heap_pop(&clock->timers, &callbacks, NULL);
+	}
 
 	spin_unlock(&clock->timer_lock);
 
-- 
2.34.1

