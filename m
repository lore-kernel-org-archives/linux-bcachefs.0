Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C729A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 04:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521744; cv=none; b=d3d+6xClMSVno2rKusPvoTor9xfeoyhjm5hXFskiEeqvUI70pGljw30zP7Tiozm30hu0K7KUdn+vMeXowaL9fNbI40tZtvLEIPpWVz2ekRm/SmqCFdNwyl6Rp19Scy6Wu7ufwrxdiFKIUNU/20L9bFwWnwjQhWUACXHGz5ODJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521744; c=relaxed/simple;
	bh=xOtqCV2sJgVZnMdHZDcHsrK20y4+hpDydPGgSuQVlPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBpt/FLqTL2GbMCZj/ehNKiWz8r8+ZDZ4WvbMvwCjpktvoqvjc6ZSSPQnKUVaCqjaJ0km1R4N+az0ztLVqUn9gasq4GMgJHIeJMuTRy2yiumpG2sBygYRPMZFbul7H+L7OeUqcxOoCJVgyba8SEB4oTwH1kz2MFkFzV5XjfSSoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SG72MEPC; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG72MEPC"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-26827ec5235so2548796fac.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 21:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723521741; x=1724126541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTRaKOJnjlY8dSWuXQXJGBff8VMpRwslBZGCg8rYFk8=;
        b=SG72MEPC7kfI/6kRfYiCsAv9XUVEBsoML5CVSWmXQUvs/3zgohOWsmQJ/TG8Tzxa95
         FvYvxsM5YoJ5GtzE6vIp957hcNhmonqPch6mdCWT8geAe66KjEU9njGsNtxwYVgSzNWU
         DY8LXiebkLKJ0mE/xvTLAne9NfqawS9YD0yvYkPcED3wBHbT7MAq7AQvusjIaYhmp0pz
         eBSEkY54nzg/2GlUjjG0pvHEzFYh+EO9lwtMR7Hhl/QDjDElTbsS7KRq3tHsG/Innt4+
         XIoaBFV5eTI7xvnOyj6QufvwSuBXjRe7pPyqvT555xagGSCbN+PdOabYwFQIKZlYS1iB
         0wPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521741; x=1724126541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTRaKOJnjlY8dSWuXQXJGBff8VMpRwslBZGCg8rYFk8=;
        b=oOUQq0lbKLJYkZmYUNlpG1AjlPIx5IK0UW78g50JqqisIyUeiDeMaFYIkiJKAtrDCi
         5J7vXAch/0gq4nP6f/Xe5+ma37B7AxfUyjzdDTr7p3ewFl6FOFaeCIxslao5i1dpZKBR
         Cn5E9zPcvRW5+13Wcrr4qelotps44UWUN1hvGBoWLw3h754hK/TTLgaMZgzcUAgDQ+6k
         qXEYqlKjiYw6UpF0Vhr56O+xRye6mShwJf5l4MsYdP5YIv6Qw3Qt+yXOYK929RskW53n
         +1yx64oiID759nlJZnT5Jea8vggizzIxUMy8E4PZlxgqRQWXWHP8mfJd2XKXNmAGh+ht
         alsw==
X-Gm-Message-State: AOJu0YwrtAQz+v5E+bQ8aBZgXASx9eYXuyuPLbD9aoPTl68h3oVFnzkk
	2C+LzWoiUnVwbVOXA/+sr7GRWOwZ23nw1tGzLHHSHlOUCGyrQF8w
X-Google-Smtp-Source: AGHT+IFsesdc8EtPdw2gceezFcFbJl54sfQ1O0t741tEJYd4c6x/9uxt/MP9Y9S48BcGnl7nIFZh9A==
X-Received: by 2002:a05:6871:2882:b0:261:7af:719c with SMTP id 586e51a60fabf-26fcb7ab34amr2480887fac.35.1723521741597;
        Mon, 12 Aug 2024 21:02:21 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58ae59esm4772752b3a.74.2024.08.12.21.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 21:02:21 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2 1/2] bcachefs: Minimize the search range used to calculate the mantissa
Date: Tue, 13 Aug 2024 12:01:58 +0800
Message-ID: <20240813040159.375953-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240813040159.375953-1-mmpgouride@gmail.com>
References: <20240813040159.375953-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the search key's mantissa is larger than the node i's, we know that
the search key is larger than the first key of the cacheline corresponding
to node i, so that when we are calculating the mantissa of right side
nodes of node i, the left side of the search range can be the first key
of node i. Once the search range is minimized, the mantissa we are
calculating can have more useful bits, thus reduce the slow path
comparison. Besides, we can now remove all the prev array stuff.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 00a821f617a5..43b40f6b8c0a 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -616,7 +616,7 @@ static __always_inline void make_bfloat(struct btree *b, struct bset_tree *t,
 	struct bkey_packed *m = tree_to_bkey(b, t, j);
 	struct bkey_packed *l = is_power_of_2(j)
 		? min_key
-		: tree_to_prev_bkey(b, t, j >> ffs(j));
+		: tree_to_bkey(b, t, j >> ffs(j));
 	struct bkey_packed *r = is_power_of_2(j + 1)
 		? max_key
 		: tree_to_bkey(b, t, j >> (ffz(j) + 1));
-- 
2.45.2

