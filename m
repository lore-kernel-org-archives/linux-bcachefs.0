Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C23416BE35
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Aug 2024 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724846700; cv=none; b=kJPa3mFehNryQovwl+UZYpS+00iIHRyJ13iKltnVr5/O515md4zpL87V/zDOdWb8F+QURkaMNNiCEtDYRBiTUm5DTKYyPQC/Rgb0d/UXFrOJFofC2Z3NaHWd37gy1Rcjx2DhBC908zH8RDsFgctqZ8P/Uq3nDvJONrMwtT9YLHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724846700; c=relaxed/simple;
	bh=kDtERYYG0MpcuVRV7IycEdWcCS9KfVRKzDoFjL1R11o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gRgnzW/zEFeOT5asqCV6GthpHtOzpR48QYuQDyp5gk6K8qcXVxiTaTS3l0D4FC22KfYbbCuaeoMRfB5lhdw6/TpnKbkajTMxdYLblPkdEQ4tiCaAbhZoth71lN7CEXNQcoOeozAQwzw/8lhmbepwnKTJSl3rNmeH83BdBYKXWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NThi+uCV; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NThi+uCV"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7142a30e3bdso412489b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Aug 2024 05:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724846697; x=1725451497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lhb10m9GJcPcXsiWtRJAxrDbcOxMaxelYsEm/7234+c=;
        b=NThi+uCVju1ROSw6PQmen9UUt80vfooKFcGDpOzKbXdA3ZTpp+MBJ6lf100RA8JIrE
         B1VrKerH5wba0wgJ9ZSensGvuyVE8fOsyS/rRPoryOVNII1J0owejB+iQtPhGfKooDJE
         J9kTR3mvd26MqFmsHC++i41ZHQF127LElh2sw48mJ7Khqq7h0c367dp19ASYiPc70F2s
         ZzxUJDetmBV/qdG4WfmMZkcavGiFS4cNPVHewwjX9ALG07uaCRAv696oI4t0Nb5Ni+gU
         dMoZFBx+dhNX7NfnOjAEtWmkECr0gadVRcnEyZypCxY+5RNMJkUMjwfUG/eRnIxsXQgv
         rqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724846697; x=1725451497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lhb10m9GJcPcXsiWtRJAxrDbcOxMaxelYsEm/7234+c=;
        b=NZzRYOZ4mWIz5pRmmlerji5QMGBLcBA3HSI+v8NtxRnwpleEWfe/fmqngtZuxWUtqL
         ntxP0vIpUHWwDhPnJHJyiY7GxBtzKJrGZgIfnaWSWQW4NtMqsgbnWeyuxMBenGQgsZKX
         ImgP00YiKx9YZKlZMicEe9ZQPiu627ZJkFEDgcJwzZ1zuckY2uw94y8Y2+YDwLBXKfFU
         T0R13um8WH6fsMfhJKsylKO74XOncHB9NpeTDhN4eBiQ72KqcAOONRbA29BJN5Bf7Cqe
         WOvthY57eEwPwpNUl+xDBd37QrQklg5aRqZ4jGbjeFSQhFLNB0CeM+z0G8XDIqbmippn
         IjCw==
X-Gm-Message-State: AOJu0YyTZd/fc+pnmQHfq9Dwt5m45RDFveeYxBVAc1gyQutiv1QlaMHC
	dNoqtlRbdt6MGl5QMF4Ckjb4aQrtB89D6bcWSIwPFvMnPzZ96+TQjv75dnh/
X-Google-Smtp-Source: AGHT+IGUQTABrXTyrfqaEPOjCyrOsmqbjZY7h0feJMJ05JqaEsngwpuAvtZ8Ns6wp2XpUmQbs+SxGQ==
X-Received: by 2002:a05:6a20:439f:b0:1c0:f114:100c with SMTP id adf61e73a8af0-1ccd1a9e22fmr3198416637.17.1724846697305;
        Wed, 28 Aug 2024 05:04:57 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714351aee10sm10178965b3a.93.2024.08.28.05.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 05:04:56 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Remove the second call to these function
Date: Wed, 28 Aug 2024 20:04:51 +0800
Message-ID: <20240828120451.700518-1-mmpgouride@gmail.com>
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

