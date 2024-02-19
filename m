Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F0532182
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708350939; cv=none; b=Mn5NaJLnwyiwyuFK1ETMdT2FOsnyCdW4S3iNFnl4yDa0kxkhAIUtSbfuh7x5abrabfYHtTnCEbZcVsWaS5ABrUpECF+1qlMxaFiJ05Rvd3i5exX/RyAS1j4GBKj8hhxCngW+eR2gPi6mTgEkqWACxl+fYQ5w5pzGrjRSmaJ6W+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708350939; c=relaxed/simple;
	bh=Vu8ByjvihTmX7YDHUn9bFcfZH4JWYrU+vIt0DVWXUpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu/Wn6f1nVOe6XKXpvlF9q1Yjn9tSH6GsponzSd15VTre5zFOlx10oZJHRKgOGLikdiFSU85fpw1QRvZMyOJ42D8gJHHL8+mH6eRKE/g7PLjwRuc2K8RA8VO9oppXGHbQf6shufSIaOQoEFQ0/+vYIgvMnqkA43DzRt9fmvqz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=SvfCzh8v; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="SvfCzh8v"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e09a890341so2112971b3a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 05:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708350936; x=1708955736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqU9SeGneC4pvhTLyKyD6NERgvC6LBUEb5UiMTcvUsQ=;
        b=SvfCzh8vh1tPYT8jL0BrgBiR+nk8NYU+3KsDITRZ7r+9PUlKSYxdS9J2lHyeSuu4Uw
         hdB3SGjB08Wne3egXyeW9xa2EQemKzN4c4aNowiyqOi2XduQBtSJzc7/AQwjo1HhtaOb
         qQGgphGotyBCFQm10ySWZ8tBXgZXdy3ZISTQwRo03W0Q6hkB7dmDivcp14xQkRPYy0kH
         ShjAI3XDmD9t+lR84qDDNecwvAE0EBRLuNTS32gP2pL1wbRUWq3q/zqFpKsZZS2tf/xp
         KnTjCpxwf1gLgjm+BQnaZAYOCM+2JMLr4kC8xvkzNUF7RkF5WlDGefmYsN0Z5BAT7f2N
         pzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708350936; x=1708955736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqU9SeGneC4pvhTLyKyD6NERgvC6LBUEb5UiMTcvUsQ=;
        b=KI2wtcKDTQuDI7v2Q0sELwKq0RvavziMeCPyULloQe8KL6ZD77fyqcbArvg/TleFJD
         TIgFc/rlHukmTpmoxh55QNh/Gz9ObcDxz6R4un1dCgwZzQ965mb5flCZ6XgSi+b5EyTP
         qC7b2fZngiejLsSjcabhDfnvTJ4+CazvvcVmXVlhQI05Ig+ulGB4F3oBf0gcFUzkmb7I
         LYeRe99rxy33zzSdRnMVwCPPGQE2U5uISdAxZFb0ITL2gCjQsSi5WzjPUr8oM5c0WFWQ
         bSZfzG6aU/h1+6k9Vy8fNTjcGZ/xRVzc6oK6UrHwBkqRhkyak2qQRcbC7878ix1B5VnI
         Jm0w==
X-Gm-Message-State: AOJu0Ywk8FZVPB6bbcEJquIL0z+jfmV2ieg8rgEOfaMg6dP46FGA0tU0
	rq1WcpUyAWp0sR6+6vG7Dqls88QckOahCqTKcQB0cv0awisBFCOMOb9P9ihQiPD2mhMKp0PilYq
	G
X-Google-Smtp-Source: AGHT+IFJWSTOHIgqTky7Wq+/+YVmKmdFlY2owG1mFPxWQ9VKmuCau/1VCWS79jdy4M2INJHcBL6WrQ==
X-Received: by 2002:a05:6a20:d703:b0:19c:6fb0:2b02 with SMTP id iz3-20020a056a20d70300b0019c6fb02b02mr11134531pzb.61.1708350936655;
        Mon, 19 Feb 2024 05:55:36 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id k13-20020aa788cd000000b006e4641f578csm1853499pff.189.2024.02.19.05.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 05:55:36 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 2/3] bcachefs: add btree_key_cache shrinker stats
Date: Tue, 20 Feb 2024 02:28:39 +1300
Message-ID: <20240219135425.885068-3-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219135425.885068-1-daniel@gluo.nz>
References: <20240219135425.885068-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some counters to keep track of what is causing us to skip over some
entries causing potential leaks.

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/btree_key_cache.c       | 40 +++++++++++++++++++++++++----
 fs/bcachefs/btree_key_cache_types.h |  4 +++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 74e52fd28abe..bed209a625cb 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -827,6 +827,7 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 	struct bucket_table *tbl;
 	struct bkey_cached *ck, *t;
 	size_t scanned = 0, freed = 0, nr = sc->nr_to_scan;
+	long shrinker_skipped = 0;
 	unsigned start, flags;
 	int srcu_idx;
 
@@ -854,7 +855,7 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 	}
 
 	if (scanned >= nr)
-		goto out;
+		goto freed_out;
 
 	scanned += bc->nr_freed_pcpu;
 
@@ -871,6 +872,9 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 		bc->nr_freed_pcpu--;
 	}
 
+freed_out:
+	atomic_long_add(freed > scanned ? 0 : scanned - freed, &bc->shrinker_srcu_skipped);
+
 	if (scanned >= nr)
 		goto out;
 
@@ -889,15 +893,21 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 			next = rht_dereference_bucket_rcu(pos->next, tbl, bc->shrink_iter);
 			ck = container_of(pos, struct bkey_cached, hash);
 
-			if (test_bit(BKEY_CACHED_DIRTY, &ck->flags))
+			if (test_bit(BKEY_CACHED_DIRTY, &ck->flags)) {
+				shrinker_skipped++;
 				goto next;
+			}
 
-			if (test_bit(BKEY_CACHED_ACCESSED, &ck->flags))
+			if (test_bit(BKEY_CACHED_ACCESSED, &ck->flags)) {
 				clear_bit(BKEY_CACHED_ACCESSED, &ck->flags);
+				shrinker_skipped++;
+			}
 			else if (bkey_cached_lock_for_evict(ck)) {
 				bkey_cached_evict(bc, ck);
 				bkey_cached_free(bc, ck);
-			}
+
+			} else
+				shrinker_skipped++;
 
 			scanned++;
 			if (scanned >= nr)
@@ -913,6 +923,9 @@ static unsigned long bch2_btree_key_cache_scan(struct shrinker *shrink,
 
 	rcu_read_unlock();
 out:
+	atomic_long_inc(&bc->shrinker_count);
+	atomic_long_add(nr, &bc->shrinker_to_scan);
+	atomic_long_add(shrinker_skipped, &bc->shrinker_skipped);
 	memalloc_nofs_restore(flags);
 	srcu_read_unlock(&c->btree_trans_barrier, srcu_idx);
 	mutex_unlock(&bc->lock);
@@ -1044,12 +1057,29 @@ int bch2_fs_btree_key_cache_init(struct btree_key_cache *bc)
 
 void bch2_btree_key_cache_to_text(struct printbuf *out, struct btree_key_cache *c)
 {
-	prt_printf(out, "nr_freed:\t%lu",	atomic_long_read(&c->nr_freed));
+	long scanned = atomic_long_read(&c->shrinker_to_scan);
+	long freed = atomic_long_read(&c->nr_freed);
+
+	prt_printf(out, "nr_freed:\t%lu",	freed);
 	prt_newline(out);
 	prt_printf(out, "nr_keys:\t%lu",	atomic_long_read(&c->nr_keys));
 	prt_newline(out);
 	prt_printf(out, "nr_dirty:\t%lu",	atomic_long_read(&c->nr_dirty));
 	prt_newline(out);
+	prt_printf(out, "shrinker_count:\t%lu",	atomic_long_read(&c->shrinker_count));
+	prt_newline(out);
+	prt_printf(out, "shrinker_to_scan:\t\t%lu", scanned);
+	prt_newline(out);
+	prt_printf(out, "shrinker_skipped:\t\t%lu",
+		   atomic_long_read(&c->shrinker_skipped));
+	prt_newline(out);
+	prt_printf(out, "shrinker_srcu_skipped:\t\t%lu",
+		   atomic_long_read(&c->shrinker_srcu_skipped));
+	prt_newline(out);
+	prt_printf(out, "freed/scanned: ");
+	bch2_prt_percent_rational_u64(out, freed, scanned, 100);
+	prt_newline(out);
+
 }
 
 void bch2_btree_key_cache_exit(void)
diff --git a/fs/bcachefs/btree_key_cache_types.h b/fs/bcachefs/btree_key_cache_types.h
index 290e4e57df5b..ba5dd263b2e4 100644
--- a/fs/bcachefs/btree_key_cache_types.h
+++ b/fs/bcachefs/btree_key_cache_types.h
@@ -24,6 +24,10 @@ struct btree_key_cache {
 	atomic_long_t		nr_freed;
 	atomic_long_t		nr_keys;
 	atomic_long_t		nr_dirty;
+	atomic_long_t		shrinker_count;
+	atomic_long_t		shrinker_to_scan;
+	atomic_long_t		shrinker_skipped;
+	atomic_long_t		shrinker_srcu_skipped;
 };
 
 struct bkey_cached_key {
-- 
2.43.0

