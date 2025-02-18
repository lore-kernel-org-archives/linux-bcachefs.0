Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A5919C552
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 06:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860686; cv=none; b=Wuvc9jYKLhJ61Mdi2Df4JepqJHmCLcCKYSoNjrgNpkT886F83oaCGNBiyJANXyPWCvm7nIFHQVvygO8JOXtHXKNllmhfGA6ffK3GoAEUErAfAiS14yndrUWeHAh11D/7w5CjAZCh+IOOJFWgc6nuCI2/nkPaYVgZA+94IojRWTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860686; c=relaxed/simple;
	bh=Et6r53etuNdyzXzBgrlaQZBNMpzJvHI39RWaJelMh2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SsRvo0/D2XIKdRHc403eADr8Gr9iKH3jfkBpfEkHgArIbhRZfhYsQg1j0gnAeScXhEC0r06zBGmFLhAk029bT5qlY6aT/2MkOnFPa20TkiEMcrXP6svA2vkHyyaGqLHvy1scqQGz2HMr+aXnd5O8OYVX1fBduYjW+4vCLPXMTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+As7pio; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+As7pio"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-471ebfbad4dso17746021cf.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 22:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739860684; x=1740465484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hjBBNrnoH5Izqb5Yp9xA8n9FFQ59Xbwh24KeyzHOse0=;
        b=F+As7pioX3ESHVEafRbmBsxxgaq4zysP1NpfhydUUg68Y2PMakHSPq6F3MywJAk2gi
         SkYvRbDYB6maHmT8PFig9XBfmoD+O1EVUCJuqZeOkbp4EeCbki3OyIHy6ktjQEB0QkT6
         OuP7o9eIHxnuO0eizPcxxJ6xQkZtl8hutRpzZWLoHDFsLum6fbutDQLc96CRGi5xUufo
         UkthRZOuSRcFahZXD/y2Xb434nrPNyAvyU+WrOGzy1uxjF2HUVwMk/K+si4wUAKJfqYo
         GzdjmIjiw8GZg/oT/42odaUP9rmi811qkUIxY+olRHLYiDcx83Q14nnfFtu2sQmKQy6y
         QZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739860684; x=1740465484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hjBBNrnoH5Izqb5Yp9xA8n9FFQ59Xbwh24KeyzHOse0=;
        b=bDxaHLweOd72M9xwn1KrDgIi9CPjnDG2/WhapfcA+9wyy95GIgAvDA8Z6jT4w5cjdY
         pmaGdp2E6CN1x0eEBddB3pDdlauM4NhOPxIpTiyEkwVUrZfV4JzHH2PLD2CgZbh6RzBA
         mUvbQL9MKexP8RFLOJ6gBNysicC/u+M290SNDPjMWAUkwvJnOfrgTw+mCHpB7I6LaBqP
         dDXSiAihExJElCTZK8XQuURQ8lUKym27nMhDDZhJPCzoBuF+USEdnWC6dz3ZWkr5qu+1
         /svyq0Qqcm8+Fg8lWnDNZsoUulFEY97/zNKdPm3794WDai0D3yMucflH/jCRtNDfy+2t
         aDfA==
X-Gm-Message-State: AOJu0Yzk22YTwKNNn+Q0pDqE0ce9YNYlrWPD0PqckaH1bqjDDlWUhQyf
	mzDMJnmGyoiU0LDAK8E2auFxy6+PCFxWOJ1z1lEn+qSJ+p3v1lYh
X-Gm-Gg: ASbGncstDqk3HDZjJ6Ujb01nRW1jhUW/Q2jgv6c7eobzEM7WAKNHLmeyxTmiW1ZgTxH
	UqJBV2qxyU/pf9jS1dlq5/rxGLdWn6DCwXgymM33VO6z+zgE42MTehl73Bn48Ctso16ro0Ldg2g
	JvoBE/lxdIS5d6iJ2BU7iOLv3T2Iy9OyewW+Oj3Co3cLvK5Xj4kM4o0bRuec6TfUbG0MrVHnmpz
	D9PRFvNaMpt22aQWei4ZPCp5K8P+KFATt1ANwslG5gInEfBhFKsRIh+ddor1IuBfg==
X-Google-Smtp-Source: AGHT+IEu2CStnTEN4UzIO+wF21GXsPizUUwWhQSVpqB2CiFMLPN56H8y0aw4unZvm5JPoKDv/kVhyg==
X-Received: by 2002:a05:622a:2c1:b0:471:c658:8764 with SMTP id d75a77b69052e-471dbe7dec2mr153612041cf.37.1739860683731;
        Mon, 17 Feb 2025 22:38:03 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f5d00e54sm14121621cf.21.2025.02.17.22.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 22:38:02 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	ryncsn@gmail.com,
	akpm@linux-foundation.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix memmove when move keys down
Date: Tue, 18 Feb 2025 14:37:57 +0800
Message-ID: <20250218063757.265776-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e71b278672b6..0022529522f1 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 		}
 got_good_key:
 		le16_add_cpu(&i->u64s, -next_good_key);
-		memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *) k);
+		memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) vstruct_end(i) - (u64 *) k - next_good_key);
 		set_btree_node_need_rewrite(b);
 	}
 fsck_err:
@@ -1259,7 +1259,7 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 
 			i->u64s = cpu_to_le16(le16_to_cpu(i->u64s) - k->u64s);
 			memmove_u64s_down(k, bkey_p_next(k),
-					  (u64 *) vstruct_end(i) - (u64 *) k);
+					  (u64 *) vstruct_end(i) - (u64 *) bkey_p_next(k));
 			set_btree_bset_end(b, b->set);
 			set_btree_node_need_rewrite(b);
 			continue;
-- 
2.47.0

