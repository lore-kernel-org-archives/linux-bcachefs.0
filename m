Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A92DFA32
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 05:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695198; cv=none; b=DnoojD49bBP+/rl3TISsQ4fPAybxcNOFbKuuoxM/06q344BZny5GeW4IjFoM+v/mNab9F7P+v+8ktHe3dYewbLQyLPmhIOKl1+uyaA7jr3IKjlFi2zrHN41lEVOlO6yxyN2SaevakpleS9wqAGLc2lSVZFIxOmhPHtDGbmnL/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695198; c=relaxed/simple;
	bh=oHSjlobGDVxGS3qD+swZC8Q+8efwr4BAXlJKpB2SxJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ3mA4lcAgJeKRM1o/tZ6wU+GQTHwD6gSyOzQDGXvTP2NtujEbp1OlyXZq2TgmTsoauh3+GSstfNSHjLdeo8Ma4D5IVBlVV68Xq8SZMq2gK7PxbGkDYOSusMU5ioabMZoi4V+LieemKvcqprwGrdqi+3+NsUXFs1MTbWq6X6wBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JO9iXT3Y; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JO9iXT3Y"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b061a06f127so2198544a12.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Apr 2025 22:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744695196; x=1745299996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOgaml1Pyu1pgHe0HBTYxOvDEzb+iQidjCLz06zEHxI=;
        b=JO9iXT3YWPOPgHrTH8Nxz/3hOWFyYMN+tAn4sGNATXda+1X8iRPCbeWiUhVVt5LX/d
         vm1akmImYrk1CK4bpxOJgEAryHBwa011BOrbwVJv1yPBabCo7Kijavwg394/yHMK6eck
         Wa41z1DxQ7UvukQVR5TfXhPv9+UPqDlQT6BDndrbOf/PsSxIXv2fk3BcUzcIGXTEhynG
         it6NtTjK/z3NW4j3R+dmcD2GVFgfZJEHytYT0i9zEg+sv4cKSM3v7tdKRfeZF21eiDcK
         BC4t1066rk6yRajTDSSI6tUtBf9NIL66PJ5+nkZDT8viNizRUrgE+YoF2HL9TuKQ1z5x
         L7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744695196; x=1745299996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOgaml1Pyu1pgHe0HBTYxOvDEzb+iQidjCLz06zEHxI=;
        b=F89nAYFy0gYEPJAWb1X4AVOci6JFCnyB3U7kkdsju/Q73Tu4+59lNrJihJSdQEYZj7
         aXQxlDPAzkIG0gtHHWYs1bjR1WrJ+rzq6ARO42q+Beqq77A4tYLl4TJ0/oznmDwu7f0d
         cn52qA5NR6tPASQSAlQjP6OiGweGOzKAIAvS9Xx5R+z6Q2M27jEpiSTssUhZ5JvtOAJK
         wa8qw5NGq6NWAMrM+6HADX0BOWj9oCiDNgA7N9SI4YvCDcrgTZaH2Qaj1EjGoZU+DV8N
         X2dYLddvZMLWCnOz9GS7KLy071u5SX7wTBsfb6bFNxRYx0LP2vG9hry3Oiqpaq6L260O
         7tvw==
X-Gm-Message-State: AOJu0Yyadh2TwOo0k3qMj9PnwADwUHaeXe/zy8M3/hu50gLseBX3SJ62
	Z8z5WCWARn4a2cyo7b2T29mc2Isyp8JK6Itc1BsSlWlxhmVCqEcl
X-Gm-Gg: ASbGncvpRBaxHQfi+xR/Afk3d20XHsOmdJNmAWWvHL2zzo6dsyFyM27QLzV8KGrvYTG
	kz6U7PuHwpxH27ZN8cPUD78xn7oBRQ5KtHysZmO3Y8ajL0XL/JRbveRkR3U2YVjeE1zgRxhoVbr
	7t7JklNs70IbrvWjc87xWxuWPG1zbjcPRq2ZhLL51x6s+eO84EjkXmHzcQbkJh6aLo4swb2d4yC
	EpRdZWvgxitiGolZyRkf/AgdoLCJxDAGhtnw8yqqP0V8pMgt3jUGt/J4wO0FKajx9jhIYMCGgco
	BI2FvRoPKb5EpS4=
X-Google-Smtp-Source: AGHT+IHtRscTZuRwm2Uh3tYNnvYY43m9B3MHdUIUY6RRqSxwYcl+ZqKfjt8tdHPnPY8fk/p8UvBVEA==
X-Received: by 2002:a17:90b:51cc:b0:2fa:228d:5b03 with SMTP id 98e67ed59e1d1-3082367e2e5mr20887092a91.19.1744695195961;
        Mon, 14 Apr 2025 22:33:15 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-306df09071fsm12239679a91.25.2025.04.14.22.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 22:33:15 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/4] bcachefs: Kill bch2_trans_unlock_noassert
Date: Tue, 15 Apr 2025 13:33:04 +0800
Message-ID: <20250415053307.81354-2-mmpgouride@gmail.com>
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
 fs/bcachefs/btree_cache.c   | 2 +-
 fs/bcachefs/btree_locking.c | 7 -------
 fs/bcachefs/btree_locking.h | 1 -
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 9b80201c7982..153980a9a1cc 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -978,7 +978,7 @@ static noinline struct btree *bch2_btree_node_fill(struct btree_trans *trans,
 
 		/* Unlock before doing IO: */
 		six_unlock_intent(&b->c.lock);
-		bch2_trans_unlock_noassert(trans);
+		bch2_trans_unlock(trans);
 
 		bch2_btree_node_read(trans, b, sync);
 
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 94eb2b73a843..f4f563944340 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -799,13 +799,6 @@ int bch2_trans_relock_notrace(struct btree_trans *trans)
 	return __bch2_trans_relock(trans, false);
 }
 
-void bch2_trans_unlock_noassert(struct btree_trans *trans)
-{
-	__bch2_trans_unlock(trans);
-
-	trans_set_unlocked(trans);
-}
-
 void bch2_trans_unlock(struct btree_trans *trans)
 {
 	__bch2_trans_unlock(trans);
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index b33ab7af8440..66b27c0853a5 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -15,7 +15,6 @@
 
 void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags, gfp_t gfp);
 
-void bch2_trans_unlock_noassert(struct btree_trans *);
 void bch2_trans_unlock_write(struct btree_trans *);
 
 static inline bool is_btree_node(struct btree_path *path, unsigned l)
-- 
2.48.1

