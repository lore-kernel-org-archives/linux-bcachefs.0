Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BA12E337B
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 04:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742703628; cv=none; b=M+nEUKMHX+kS15000kQ/+UVcxnhdwM3Jcv7Bzt9I3rzr8/n3krZIEltPBYuRm4zjHE8dQQmTidfnGs6+f9hxDMOdVxIzhw09RDb1W9ynp+V0xrZGeDDc1Oag6jix+zyAspfZy57JCIcI5/C+ooxnImaMtYeCOTCrxlXGaqHWMY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742703628; c=relaxed/simple;
	bh=q2jBIUertY3EQrND3M4tOGnLwFde1ojosR4yGEbxNQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JqHLDtfSF1ZpfYLGrdC+Pq9WddSADnBlZy9lDzy7PCUB5MIrcQGmGbn+NDYaw+caEAn8XLcx4iCHmZX4b6zsNEesuFlA4NR92rsV14BLwcLQR00YgJmYDihffXJLEUnC1RSlMI/wU636MJ0SGE4KNK6V9ADB/RARdITPC74Pv9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XmOO116K; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmOO116K"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22401f4d35aso68428885ad.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 22 Mar 2025 21:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742703626; x=1743308426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wM8YOeW/6ubH7cu0W9v7KROAgQCuweaDlOg1B7v97i4=;
        b=XmOO116Ke7w604c8jt98KJHetm8KHOUH010fKavHijr3g7naFdoVlXko6RUq61fvqI
         iZlDcatVU4ohETm4kVWRdak0LaZWQbGXUBzptbq2oOOZa8Gzca8g9VdYxTNkWyDF8rwJ
         wZagCbUe8MYs8umdDbQ0aUcJQ+C/zt4B3pRq0l5YCNjLczfwsofRZSrNgPImHAfLoGqc
         Vbd+1HAvz3BflH6XY3ypNn3Jkqx5hQ6CBs2oGFP3FwPhU01Gy23KRfhsAtSvdmRvzMKZ
         5JSQIUULyEJ+dm5aLJgImsq4COj+TNU7elDF1IQVVGjtouUF0pQirGHdJ7ZV7E0YK67X
         aUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742703626; x=1743308426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wM8YOeW/6ubH7cu0W9v7KROAgQCuweaDlOg1B7v97i4=;
        b=flu80uubUIssiOhhqFL7xSrdNsq4vfIDHz+D/avQZwhEr/U/QDtllkceZ/PEK0CULu
         FK1kKvT2IC5wOuLfYVCHJz7mTisZEAiMMmG6WCgSnCLWTmd4kAbqSt4E9MYy+3CYlGNX
         RRtbyXZMKnaaOTKD2vb9/PX5OBQ4r56Uvw3DQicMXdHoqIN0e+CplcAM2YVwKTOfmori
         A7mOC17pWS9Tc19HGzIwsJdI1LhuBYeUczovxg9Rt+KBFKtDOYf/E0jIrsdkBL++I5qK
         COgMzO2Vihqkh97ahrDR9oR5A2/onn9i8YqD8HbgRMC43yh7iOn86GzyDs/EtDFK1uoT
         rd+g==
X-Gm-Message-State: AOJu0Ywft4p1tsrdBEH0OfCLKmHFibuMpdmBLVEvJkTdIfc8cbWT7fuC
	VoxfQgaDoEFRJRTQxfJPfnVr0jDUSSAXhe01gn5M1ksoglyZGstz
X-Gm-Gg: ASbGnctgAy/e3whIb1+aE+YCV2N0eNK++L+7XHt0sbi5mzy9lMBJ7bJx+eCaKJtR9CR
	Jjr1sK34TJZIDap2nt5sH0BE2JC17Gzj3eK8mrQY4+dwXmuBn4SasF1Y69jpQ4on+LfK3m1VWHC
	vlfgWYntiX/eZKXXTIKOjuXir975fxKuxTB/V7R4WIB4O8f1rgeTwdrJ2PIE+L9sA4O0N9IVkRf
	TU/k7CaEmXsdxcvwrB7a+8HzwAoPbn423R6l6On79vmN2mB1IKNLPKnvcLRqSkS5aw3SNDxU+mv
	+clmvo4wmrf6Qy/xzdD1orT92muCZA==
X-Google-Smtp-Source: AGHT+IHbHOGgOxeVxi9hxTQ4YBK2riB1m7AqHfuaC0TgP7BtjJV/Kszl4t4ljfsI3JN0X1P8Lpj4GQ==
X-Received: by 2002:aa7:88c9:0:b0:730:7600:aeab with SMTP id d2e1a72fcca58-739059c5da7mr14076426b3a.13.1742703626397;
        Sat, 22 Mar 2025 21:20:26 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73906008299sm4928663b3a.74.2025.03.22.21.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 21:20:25 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Add missing smp_rmb()
Date: Sun, 23 Mar 2025 12:20:21 +0800
Message-ID: <20250323042021.57711-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The smp_rmb() guarantees that reads from reservations.counter
occur before accessing cur_entry_u64s. It's paired with the
atomic64_try_cmpxchg in journal_entry_open.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---

Since I'm touching this part, add the READ_ONCE anyway.


 fs/bcachefs/journal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index ab68c5c4d8d8..fe362ddd2895 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -350,9 +350,11 @@ static inline int journal_res_get_fast(struct journal *j,
 
 		/*
 		 * Check if there is still room in the current journal
-		 * entry:
+		 * entry, smp_rmb() guarantees that reads from reservations.counter
+		 * occur before accessing cur_entry_u64s:
 		 */
-		if (new.cur_entry_offset + res->u64s > j->cur_entry_u64s)
+		smp_rmb();
+		if (new.cur_entry_offset + res->u64s > READ_ONCE(j->cur_entry_u64s))
 			return 0;
 
 		EBUG_ON(!journal_state_count(new, new.idx));
-- 
2.48.1

