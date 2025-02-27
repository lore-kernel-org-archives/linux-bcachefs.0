Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A840271815;
	Thu, 27 Feb 2025 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740692880; cv=none; b=Yj4lV4PhOUby23Vd7LPFGTcxCD7duKM7rQXaA9jg6OcMqyfvFCjNk8FL7/EREtd7bbFQU6QcgTqZFyezhI5ifcRpxh2l0dq5p7kH9hl1/XNEu/jtR72ogJhEbkuSdL8vZnC4IhotXtCXnp5RiHaHEtcYo3XOx1DHu//5UB+qgiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740692880; c=relaxed/simple;
	bh=BjqVqzhktYwhpoR5gD02U6D0iieURF7D5wZ0FkzbMXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fgRJQULQSpoG76Y1bnT5LUzQSgJtR1zHzngELETTuTlmGGstt+DrCyTgWWWBDv7bhGAOPm684dZjUQnlgBjULifnrCXZwLXhJ11rfeGmXgz1Al4NRVN5kJH6QAFWO4KIhT6Q8Q4x+LZTpmnnmx5dLW9dc4M3yvypo0LkXRn4pfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WUiKd4+x; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUiKd4+x"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-439350f1a0bso9910005e9.0;
        Thu, 27 Feb 2025 13:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740692874; x=1741297674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPsgbgu3FIiYxP/zboORp1uv/rfrWPbLOG86PuABuH8=;
        b=WUiKd4+xuu9Onkt4i9xlK0ujQSwuMrSN5rXsnedEGpkCKowR6W8tjlts/SdulES/Ot
         f7JJC4zzIiow2xsiXTF05rX2CoMoEzh73sC3TpYJInmK99BCrxc7kn136HMlv7/CJbKV
         IJaBSii55NnU6rXbeHPLYZchIJNcGVsOsU57oi0v1EF6lMgmcIxPZxsVpQbJdRGjFUwC
         MiM8Lj+sF0rhrw9TeVgIBBlU8AvVo7+5bj3ddmKej2U6JBsylIXbEBE+KnCiB+oGGxxc
         TileKH4Uv9f8Sz4r444i7t6P1DOD4+vaP7sGNZXgvhW0WIHdEyKCfkPFnPfMOXwF0dRH
         UGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740692874; x=1741297674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPsgbgu3FIiYxP/zboORp1uv/rfrWPbLOG86PuABuH8=;
        b=pYbyL+/rsnONT1Wgh2uVJeaBMU0un/juLREceEa7nM2IU/zFYytEq+vkNX9W9A1BFc
         1LPP7389eDxqFjS8GZCwLy3yT+UAy2XkzmIq9AHW1tUylF9rWvsgtg8L/fAQvsB1JzYv
         v3ZGwBpkXST6ZgCU3wogOJMbLwbU88BoQkuJocBKEcP2l/y5UQy+vKig3tjbK7Pwmzls
         eFJNQAJouSYbvUQkY9DHKtUDPfPAON9A0u0V02LvEVslOnDEAyRVdidTHwnE2HafHpKf
         IYnMcAcbG42UHPejcr9uzt2tCdNjpQPjFw92yzl32xrO4ZD87RLcMsazrqKsr1MYDz8i
         OPOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTeAxk2X+1waZLvbKKVodWLjvd2R2+uckxT8xQts84otJIfHkgUuC2dumsIbadLi6rkWTOVPJkIdBeyO/jbA==@vger.kernel.org, AJvYcCXS/IZhpYhicFmGU3A1Cdryz3dyTHaDOrqHWx8Um3GGNlhcyGLZPPFgcg91SisPB1Il/YaBTe/8V5c/vlBz@vger.kernel.org
X-Gm-Message-State: AOJu0YwVH9tTVDChoXJJVY+U+AaLYB8vNVqqKp+mk3umiWfoEE5mjLOy
	Soj7+/Q7iOhqJsv3NWq95sZQMRzh6LFaf73M19pXwjfDvFOs8ruwAfyHEIbHO9I=
X-Gm-Gg: ASbGncshFj/q2rai7FVu7tGFjlVS3Pl7wH6+8TCFpcTtbetARSaRDmL9LdJX47AQzRp
	oLNS/qd1hBJOLAJzBg6trUP64VzrVI7ROAQOFaqiimg2nKkTQrEqZFjZislBDoPhu+fuMNIWEj+
	pkP44jobQqvyx/7IYqdD1kK33q4fWEV5dfJhW4DZGbUHEIwmHr8u6m7A1AaGmanrlDlTSfv/cY1
	32oeaPaPAeeu1ZJ3mbIkgUtTgUBn26xYeA5L4dVCk3siWLOUe9lqOi/k9Fklt3PAGoGVazkj0Il
	Vzt4wPv7WNbnidXsegRG9fXMtuU=
X-Google-Smtp-Source: AGHT+IFvRqWE6o8uWmYw6dawx6Taw5Dz2GijLOiouxcfaB8nbGuRuBCvHnRPMeIdpSEg8CrE/irs2w==
X-Received: by 2002:a05:600c:1392:b0:439:98fd:a4b6 with SMTP id 5b1f17b1804b1-43ba629a811mr8661265e9.15.1740692874281;
        Thu, 27 Feb 2025 13:47:54 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43aba5870e7sm70221605e9.35.2025.02.27.13.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 13:47:53 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] bcachefs: remove superfluous semicolons after statements
Date: Thu, 27 Feb 2025 21:47:19 +0000
Message-ID: <20250227214719.653887-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There are a several statements with two following semicolons, replace
these with just one semicolon.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/bcachefs/btree_cache.c | 2 +-
 fs/bcachefs/btree_io.c    | 2 +-
 fs/bcachefs/btree_iter.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index ca755e8d1a37..23ca9cc18b56 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -521,7 +521,7 @@ static unsigned long bch2_btree_cache_scan(struct shrinker *shrink,
 		if (btree_node_accessed(b)) {
 			clear_btree_node_accessed(b);
 			bc->not_freed[BCH_BTREE_CACHE_NOT_FREED_access_bit]++;
-			--touched;;
+			--touched;
 		} else if (!btree_node_reclaim(c, b, true)) {
 			__bch2_btree_node_hash_remove(bc, b);
 			__btree_node_data_free(bc, b);
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 80a0094be356..8c8724173f0b 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1919,7 +1919,7 @@ static void btree_node_scrub_work(struct work_struct *work)
 	}
 
 	printbuf_exit(&err);
-	bch2_bkey_buf_exit(&scrub->key, c);;
+	bch2_bkey_buf_exit(&scrub->key, c);
 	btree_bounce_free(c, c->opts.btree_node_size, scrub->used_mempool, scrub->buf);
 	percpu_ref_put(&scrub->ca->io_ref);
 	kfree(scrub);
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index e32fce4fd258..168a6b7201f1 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2717,7 +2717,7 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 	}
 
 	/* Extents can straddle iter->pos: */
-	iter->pos = bpos_min(iter->pos, k.k->p);;
+	iter->pos = bpos_min(iter->pos, k.k->p);
 
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		iter->pos.snapshot = iter->snapshot;
-- 
2.47.2

