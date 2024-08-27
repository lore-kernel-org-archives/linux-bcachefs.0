Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764CC1C6F74
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771696; cv=none; b=aL7Bjyu8RqVlQD7NHlh9AWmaL8Tshj+YTIKoWg8bgsX6TGRmTfRIDxWhznVQmf78anyEAJL4pfCCWSqkI81epl+PXcp7GblQb65smtxi/kPUhqJgO3fPSCixyflXqHpLOw4KVVQYAJht6XHOxZB1rmjdExqSUx/CoYJCIO/K01Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771696; c=relaxed/simple;
	bh=qJSqaEbgrEWziCrxhXiUyKh/dJKaN5Ut4QZIG7pV9rY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T0RwGgZ8Q+7SVebMs1RS6MxdnkYcZNi1oImpaVPlDJB0jv2I6nrR+syBa8wQpCRY+wRET2xxv9jvnTz1S7aK39KoBDaHsIQWQZvCwLUXPvNT44ooR71BzBYoKUOaAqP93G/Ws910yNXyf9sol07NC9MzhxMhXEHi2FlhBL49r+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSRXZowD; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSRXZowD"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d46f2816c0so4500485a91.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 08:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724771695; x=1725376495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EfxNWiB3DVGahsLVWi6f7GRFa3yo61qJ2u2zIOqUOyY=;
        b=jSRXZowDO+l6MsgBeSuXAkdehIOfZ7g0583B8oBWphzKEmhGHSUL6oSeH+gs4z3CmK
         FPfljVN+5CL3XH5grSwVdjJs5l/TKhDTa5J6E1D/CaoemFYKwYam2gOgHn7bN4k26QSY
         2w5vhQqMGKDkUyq4K/LyXIK4eKxX6yMarR5TRTJBP6MoOqrmK6udYw7zIXs4y8Mndi0j
         Lc0zZ52T31bXC4wCnoJqvB5YRQX9Eh71x48vpu8De2Drz+4SXlU2T59Thic/Xyoi7HGE
         KVusAUDz5+U7nKvvDbaKnDEbB2vXopLEjOdRq1C2m/GlIejVds7+GW+Vth4kMjwmfUIp
         HWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724771695; x=1725376495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EfxNWiB3DVGahsLVWi6f7GRFa3yo61qJ2u2zIOqUOyY=;
        b=WbX7Gh+zUtrseFL/UcPrdFWzJ317XxasQqrJdr0d/exrwwYrihNJxV1/k53jH6VIA2
         LfqpwAcOrjd/KaOscHZhlRemaNx095joxiEnQoiOTA5annjODl/r4TOuHLK+riPDPZSM
         zBimwvn2SkyfyJT1EN9TBhuAtepkgdcYiqBxpNhyx4GLcK1cwZ2Vjj7rTjDeLVsRRDcH
         OBTflHCrmecb5Qu3bSIPBmaStc6AotzCHNn/oZdPXyDZapSOMI55fnPWPM+yBPMUZPTc
         lDvt9AYg4o6SdeQP3G/9TV5oKAV3LcrnoSjlwAz17djXYEkxZ1IdlAPcYWMmo97gvOAA
         QJYw==
X-Gm-Message-State: AOJu0YxHNor0bUR2NWBp4aD76NgOuUfRqS3JqQAKjfsEj7i4y2ruGQCm
	D0kzXXazaMSwum6Jl+vf8BQhjhel7pCCSdb+kGU7lgTPdeGGYp2sbeAxEw==
X-Google-Smtp-Source: AGHT+IG5lJpEjmwmblAlUIzTmYiJ/5xd4nPZxtirkzAeo1QsxA1UZkoY04LyTnmHO5LNvsP67Gsmsg==
X-Received: by 2002:a17:90a:b38f:b0:2cd:619:6826 with SMTP id 98e67ed59e1d1-2d8259b8dacmr3973211a91.34.1724771694426;
        Tue, 27 Aug 2024 08:14:54 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d613703c94sm12289333a91.10.2024.08.27.08.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:14:53 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix lost wake up
Date: Tue, 27 Aug 2024 23:14:48 +0800
Message-ID: <20240827151448.680522-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the reader acquires the read lock and then the writer enters the slow
path, while the reader proceeds to the unlock path, the following scenario
can occur without the change:

writer: pcpu_read_count(lock) return 1 (so __do_six_trylock will return 0)
reader: this_cpu_dec(*lock->readers)
reader: smp_mb()
reader: state = atomic_read(&lock->state) (there is no waiting flag set)
writer: six_set_bitmask()

then the writer will sleep forever.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/six.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 3a494c5d1247..b3583c50ef04 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -169,11 +169,17 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
 				ret = -1 - SIX_LOCK_write;
 		}
 	} else if (type == SIX_LOCK_write && lock->readers) {
-		if (try) {
+		if (try)
 			atomic_add(SIX_LOCK_HELD_write, &lock->state);
-			smp_mb__after_atomic();
-		}
 
+		/*
+		 * Make sure atomic_add happens before pcpu_read_count and
+		 * six_set_bitmask in slow path happens before pcpu_read_count.
+		 *
+		 * Paired with the smp_mb() in read lock fast path (per-cpu mode)
+		 * and the one before atomic_read in read unlock path.
+		 */
+		smp_mb();
 		ret = !pcpu_read_count(lock);
 
 		if (try && !ret) {
-- 
2.45.2

