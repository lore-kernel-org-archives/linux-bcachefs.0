Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B15C2356CF
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754325671; cv=none; b=eyhztgm6Ue/Sy1eA3e2Db7YD2VMnGgC0Zv4O0o4nw2mH8mA4mPFnUfsF9zx3WXN4Lq+FkuQ0lLyeSUGeKPr9xeHKSjnZPaylXEJ8k4Wr07KvcOr9Qmwrc55r77RlC9srBWkNBCCnVuP/AQUIJky+Q8kWrwUgYajITx1D3HVvUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754325671; c=relaxed/simple;
	bh=Uv2vtn/Fh4DHeXqrhzH9tlSUnUxg1+kgBkL4nwHFbNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R1ffSu8tMnyVYiUcwcHBWQ+nkbuCG6wjv1XWyfwmRer8HfTcFMfNA9Sdt404rAfrmTXm+vklpRtPZcNrhEINv3QvwrHrtXJGkk2DK0+sFtvu1Avsksx6/AwangAuf2m6Wkztk1ozxKkuzZJhvHi5sPPl2nzdySk5Nshj9GeOrHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOx/Jo7Q; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOx/Jo7Q"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76a3818eb9bso2954086b3a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 09:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754325669; x=1754930469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9uAijymtSURYCWYlsfKGVzLh6lacDMtp0cs4EjX8VFs=;
        b=UOx/Jo7QUvYtrk2Tzk6QSre9jvKulEOzpmAT6N6rRssXw54jIRFW3TmLdOGKheAwQL
         HVjBBTdBS4cG08/jGXBvj6efoxH8iYIO/qORQghQvvNZzjEHhgN+4xnxUILUiW4C8lqb
         D4SO1ArUveBippY25CJ7SWlbnDvaKPAR9/L9++ahXYwY4k/Hm2YOBtqWJDfGsNEfo3tH
         cIjBhSQNWqH2YVzUMW3R4ECvxHGAWnnRIcbofi7/lOHKWcVjnaKujiFeo5S6VTIJU5OU
         bSXyBlus+GJ28tqjOdASWhtCPJY1nuFXc+NOTQ6/9gLDlTjAvi2+azU76LkqZ93Sfd98
         Kjug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754325669; x=1754930469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uAijymtSURYCWYlsfKGVzLh6lacDMtp0cs4EjX8VFs=;
        b=arBGSDIhpKUN2tW1+rYjf/Aa418MZb7bBcp5knKVD5lCwM27Yo5dxWaKHLoYjgddGW
         Gky2S5OOipNWHsSr1IoEZestbEgyvw0xoh6ZcqP99P20cxEwPF+7EvHI0FKBYH6cL5HC
         tX/dp2PTh4xqDhKlMCD8VlIfJfqdhT7hTRweOklR4+ZIJbxkZzd1U6JyF4sh6/hpdID6
         aeh9IdoNBWhz8ESwao1PQ4X5LCkzJeCwPX+QTAYDDPpqyAJp1FvSFmuiLVZx931So2df
         UtGL/JybBqqjII/VowswCeH31u/6lvCeNUOeLDq3JtjwNuuVPJ5Mhv703WQTZoqIvNNY
         xtHQ==
X-Gm-Message-State: AOJu0YzkDoGFo5lEx1k92Ponx+i7leWLKhndSVNGwJD2M0M+4x7wYIRr
	0GJRqq5wkH0epFiGwIcrj+ABdmF8HQs2c/AlQfyZ470agODjVkZw02e6
X-Gm-Gg: ASbGncuyZLaULLsJbibH6Yt5lFAR7LsMwSBplpSwNgGhsO0EvaGwLJWk6vlB1mH3bfG
	bz7z+Z0MzuQFvNiPLmiNrPMzxwsO6P6sZy318i1P5vDOnFMjLDuBkcOYUvdU4E+TF6Kp3zatuVn
	bkKMnSOUGb8u3BrS/vAOjMfafoxq3grYL9+NrnX0VVzbBEMty8cZdHIuAPjh10wE9FLAYOgeG57
	hYLRsD5nPUySa4QWKtQp37h7HHRSVH8xMYZDHl5FCrLBOalM/Z4YnSxLgzlbqc6FgfOboAmrSHH
	stGMuPxm7DE/xUIUwg6km+xu6ih7bmfsJhcUCph7tFJCPOEmTSp7sMrrTVeSFBOHAqhY3BI8
X-Google-Smtp-Source: AGHT+IHq7urcCak5bNP1A0wzEaqO652D9R3ANK/7ZzZ1WHWlcLZJ02+9AvolLktDBPA1u1jRM6ahAw==
X-Received: by 2002:a05:6a20:a11d:b0:220:82c7:309c with SMTP id adf61e73a8af0-23df8f77f7dmr17608773637.7.1754325669547;
        Mon, 04 Aug 2025 09:41:09 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfed320sm10744038b3a.132.2025.08.04.09.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 09:41:08 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: Ignore accounting key type larger than BCH_DISK_ACCOUNTING_TYPE_NR
Date: Tue,  5 Aug 2025 00:41:05 +0800
Message-ID: <20250804164105.253084-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/disk_accounting.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index f96530c70262..5944ad6d0f8d 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -184,6 +184,9 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 	void *end = &acc_k + 1;
 	int ret = 0;
 
+	if (acc_k.type >= BCH_DISK_ACCOUNTING_TYPE_NR)
+		return 0;
+
 	bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
 			 bversion_zero(k.k->bversion),
 			 c, accounting_key_version_0,
-- 
2.49.0

