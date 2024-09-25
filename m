Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D053554757
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282707; cv=none; b=jwMlVQqv0jKHbBwfminl3gIvyjd3qhYVOE47iNs5vlHstoG7ibBxyssS1AppBqW87TDpKvKS2Q2PVEmRIx/8xRlEcK9qthjLBM+BMG7GDIyRtO2sUasidvH96AjKVTW/zpsu6HbcOvg67QjGhxQ3RiAqFQX3j6+ex5O7ChntpZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282707; c=relaxed/simple;
	bh=+DUdQBvqtVvAtwFJrrAxbaenWEE93KU9c2ixTaCt6p4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O7LtCTatF/nZJNbdKZDSLFQ6UuSQFtxOoQf+poLrxahu+k6wAakLOjdMpZBFBYqSEC4eM+f8fD6EQf9wu+YP7jTqjF4c0BAXjm4TPW5LzW35NmYf7HAcds5RgfHHhiDcYVe8/NPLy6D6aAvbXTLBcZzqbMzuw79RKiAYh08J7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyA8qgf3; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyA8qgf3"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7198de684a7so83445b3a.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727282705; x=1727887505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xsteog8D/C+nWj2OgHkM1HZ++Q3B4bbZAnt5yHXsab0=;
        b=TyA8qgf3KSt+tAmutloDMFCBdHkcZjJkdSOVrxMXFz6GnqhEEnyK8+iGuVPfTUrpcA
         41IrfxqaaVSBs3esfh1GVDiu8MDwvWMq8cLRX2wBFsY3+SolUclGcnVSKFfjxVredSSL
         lJQhRpVX33tQ9jpamOCqF0ygEEn6E4hQxdopi3TKCJc9R5Q7qxlRaJuIx5qoc+Ll9HSR
         381dcPZFehCvYkbanxmWdEuw2FvCI8jAf2LSOTA8oYAZ1VLpI4LP1Mgv7yTZBeSZRx7V
         hMXZoFqsAvep5zf+uMh6jnfuagT8W2fmB0EJK2eeqZdPEp6moMGYmz3/qLhKw4Wgj7WZ
         iC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727282705; x=1727887505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xsteog8D/C+nWj2OgHkM1HZ++Q3B4bbZAnt5yHXsab0=;
        b=bq+Igzv6IQBiXnUO2ckSaxcWZf15BtwimKXlERWEbT/+fa3lsmQl0AS9TXmnwyV0gY
         sqAQWaZYrrkJ/TlIEmRGdg/ey9QEur+jJNcZwNQzdATxm+WiD68Xfjsc7r+JRHU1SI8k
         aCR7CEyMOrEPBLR+nG+RxwhmxQrcUv+ok5cJq3eALWcEbRmkug6nwhRgVXNKK2JZCkIZ
         XNhhNjtgBiKjrkl6g73UUd46HlSeV7t/zU+p9EZo6ax2bynDyKqygs15oeT4TGptSpQi
         uY3elQeMehTLP6qVKLzZTkVmN9MIYzsQS+1SgOt+4cseMq3NHRY92Sy3oRojPbFjVSer
         7cdw==
X-Gm-Message-State: AOJu0YwzBclOIGznS3RMMdGEPkmFzqIbdUfzLHlB6bFyjJDAP9fGSUOD
	8P73pMbnDApA5nnU8K56ZziET2qh6Lf5ReT2tOWhUP+U9aAjAe4n
X-Google-Smtp-Source: AGHT+IHHYdRVUAJhC+qSwx761qwi6qDPBxFCkiNKPc8LheNwXzd9wKIGkZl/KzE0puEVsK/vtbBrmA==
X-Received: by 2002:a05:6a21:3941:b0:1c6:a65f:299 with SMTP id adf61e73a8af0-1d4d4ac640emr4467863637.21.1727282704890;
        Wed, 25 Sep 2024 09:45:04 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc846dbfsm2938147b3a.80.2024.09.25.09.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 09:45:04 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Merge the condition to avoid additional invocation
Date: Thu, 26 Sep 2024 00:45:00 +0800
Message-ID: <20240925164500.1178107-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the lock has been acquired and unlocked, we don't have to do clear
and wakeup again, though harmless since we hold the intent lock. Merge
the condition might be clearer.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
Only the title is changed in this version.

The original one is "bcachefs: Remove the second call to these function"


 fs/bcachefs/six.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index b3583c50ef04..8fb44a5d1406 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -491,8 +491,12 @@ static int six_lock_slowpath(struct six_lock *lock, enum six_lock_type type,
 				list_del(&wait->list);
 			raw_spin_unlock(&lock->wait_lock);
 
-			if (unlikely(acquired))
+			if (unlikely(acquired)) {
 				do_six_unlock_type(lock, type);
+			} else if (type == SIX_LOCK_write) {
+				six_clear_bitmask(lock, SIX_LOCK_HELD_write);
+				six_lock_wakeup(lock, atomic_read(&lock->state), SIX_LOCK_read);
+			}
 			break;
 		}
 
@@ -501,10 +505,6 @@ static int six_lock_slowpath(struct six_lock *lock, enum six_lock_type type,
 
 	__set_current_state(TASK_RUNNING);
 out:
-	if (ret && type == SIX_LOCK_write) {
-		six_clear_bitmask(lock, SIX_LOCK_HELD_write);
-		six_lock_wakeup(lock, atomic_read(&lock->state), SIX_LOCK_read);
-	}
 	trace_contention_end(lock, 0);
 
 	return ret;
-- 
2.45.2

