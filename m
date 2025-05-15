Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79211F0E24
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747319400; cv=none; b=QG58cme20PzHDusRdPNPPKo9QoL03GRcTAKCmLaeTPgwzj2+p24tPtXL870X7Mfg8A1ah9OyONwUKxHpun/wPZfqW+ILkXg+OwfuphcKqy4Iwwu3LGBToUiHbAgUVqTXyJMytGEdfn1tt4t24RN2aEXfVkq0RrmT2sMzc2NTzcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747319400; c=relaxed/simple;
	bh=ZgN/2gBQWcilmdTR/tBsYUIh7K9VJkjm4jx0oEW6sSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D1Ry/pODA8QInRlevBjDr1UYkEXOsS7NAIhkxC/TD93+WZ+Zh8uDckydOpzhMMaeJBVNLwLMRSm5Hy+Ar+HDlqEkta+8tJMDxyIPopwVLQegTUga4s1O0YKCHvuU/bw7NmLZRca+H351OCqnUOysZP6BZoRGgNc9iO2+8AkZKCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LABFzml6; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LABFzml6"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so1871550b3a.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747319397; x=1747924197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ELxKh2+t+WY9TGBeqM2Hg5oyEOkLRF0VOqpcCaoCVE4=;
        b=LABFzml6iKUfqsya6ipWxxrEgHldQ5cY/nr5HcrWnJdpxCEcqsTsh7VpPMZ+vQLcLo
         XoewDx49H7tnrj3i8tuxBlmt8vnWIWXRlcVv/umwXPqEak5acmegMWXqYJM3hRCQlimS
         V8Gz2UtmTxNiwwDt81cS7PBrgf5Lo0N4THE7xCJ4vBPelfXlJjhXRviquPGbDseiOAKP
         KhV5GBExLxmhqmoL50t4OKpiV3ILzgUPnP1xvX3TMY1EWqZFKBBhhLpUsNVaX5UyGKJJ
         ogc9OGRU6SW1pZwUILX8axsQGrghuUqTLKD30hVikKQ1EewmfxuiitHksFLf1Gkc3cpk
         UHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747319397; x=1747924197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELxKh2+t+WY9TGBeqM2Hg5oyEOkLRF0VOqpcCaoCVE4=;
        b=YaCU+JgubxHySQi+8XkD2nl/VNfU6gYeaTYkI0R+oljzILn10vVPxJ8kAlNpNeoWdC
         dg8EE17WfCTs2HoULM5UFVU6PmGnkQC3e3cnGrUSSVa3Udlx2QrvQWd1h3EcM2VlMxkY
         MpOJjl8ROnXh4h6xlTzc24UEWGme6LJdIiG3CKX+C6gT8CqJQK10NBWEv/n8nXp/Uiys
         0+Ff288P4l+lwhLbcuVuba5YXTCTyRbAmduhU2ZFBP8ouNX5F1E34Ap7RdA2ohwfj96j
         V3o+VqzjFXH6J/FDk+VpISE2Sw9PLfStqY8kpvCz9tfQ5E+gJO/GjohkRAgBWUGkeUUa
         wlbA==
X-Gm-Message-State: AOJu0Yxg5QkMRWZUrvfq+vt+TXprdCLVhGb83buB5agxDDSuvcm0MZDi
	sIynfcQdCjdKLC0ulhBqX1Z4lnNYU3iIfLr4+8LeT3KQdzMMnKH8
X-Gm-Gg: ASbGncuBH6r4ociaVjCJPQkVQQwAS9MaMOTAS+/6oU8bYBqXb5cbHfSuxGgWocsd70i
	WYpzzKP4QtqznhP7pWXrSjiHFcHiyTtPLYliQowdY9u+PfJD0ZdIISvQFptuKZiAGDLBZeq41c/
	L00/FxYG/APKtqn8ye+DuMKWyu7oHY6C7SdKCUj0TrYcvXdD7KdSjhKCiP++QOPhEiPWZZxrALu
	jBJk13Y//FeespyFKgzFLL/QNkb3UDkh/H3ScwhYcR5xAs+GBXJNh92lSMSlQIkrIzgQVtZV0/e
	ExiGbeTimsmihe5roKGZvRjScQ==
X-Google-Smtp-Source: AGHT+IHoE9Nw8WTG1tov0o8zD8AX3cGpy1xIF/b8aiB7OVZ1CrxBvkrRdXR0qWyaFqH9iGmhyP4z7w==
X-Received: by 2002:a05:6a00:3c84:b0:73c:3f2e:5df5 with SMTP id d2e1a72fcca58-74296200d4emr4475106b3a.9.1747319396839;
        Thu, 15 May 2025 07:29:56 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a4066fsm11320094b3a.151.2025.05.15.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 07:29:56 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Kill BTREE_TRIGGER_bucket_invalidate
Date: Thu, 15 May 2025 22:29:50 +0800
Message-ID: <20250515142950.375479-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/alloc_background.c | 9 ---------
 fs/bcachefs/btree_types.h      | 6 +-----
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 81e2ae4bb400..51dfd2f24c20 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -914,15 +914,6 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 				goto err;
 		}
 
-		if ((flags & BTREE_TRIGGER_bucket_invalidate) &&
-		    old_a->cached_sectors) {
-			ret = bch2_mod_dev_cached_sectors(trans, ca->dev_idx,
-					 -((s64) old_a->cached_sectors),
-					 flags & BTREE_TRIGGER_gc);
-			if (ret)
-				goto err;
-		}
-
 		ret = bch2_alloc_key_to_dev_counters(trans, ca, old_a, new_a, flags);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 3acccca3b3a3..e5a965db68b4 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -258,9 +258,6 @@ struct btree_node_iter {
  *
  * BTREE_TRIGGER_insert - @new is entering the btree
  * BTREE_TRIGGER_overwrite - @old is leaving the btree
- *
- * BTREE_TRIGGER_bucket_invalidate - signal from bucket invalidate path to alloc
- * trigger
  */
 #define BTREE_TRIGGER_FLAGS()			\
 	x(norun)				\
@@ -270,8 +267,7 @@ struct btree_node_iter {
 	x(gc)					\
 	x(insert)				\
 	x(overwrite)				\
-	x(is_root)				\
-	x(bucket_invalidate)
+	x(is_root)
 
 enum {
 #define x(n) BTREE_ITER_FLAG_BIT_##n,
-- 
2.48.1

