Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86921F190E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 10:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740048976; cv=none; b=DnHlFP7yPim826jBCPxRnIp+H+iqme7SsJjL/5duDyL54ftuMGoNyHW4ji7n5R9ntZhH8ZGGWhEDc7i7vmQgz2KGkDQRTvnYCarHeV82WxQMcyhpvPWRkANPM1W3MhP/5nFAAxsgAondcv0gdRjspZLT9bscrnPq7mIOiF3CQVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740048976; c=relaxed/simple;
	bh=Ez1wlY5T5NYXHpGqmnQPocnVUcnbXmyZkP0g59Zt/Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aH82VeBKNgT+BFdftDqRfFRvZHCp7kFDJNU1l6aD0o1cfXppepkSq1DngLocKKDQFfR+Dt9jbRBOOQa58iyw8P18WytFfKjZBQ2Q+YexPYVpxhjhrCDdmctAU+w0n4F+2D/aMujlIrhdQ+e6TL6kMbsp7b6aoieA98zllPVUufc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inOoVf/j; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inOoVf/j"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c07b65efeeso67780285a.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 02:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740048973; x=1740653773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gd3mMLIYUgjuJbbnbMfJVs7U0S3pqaKkp98GWvyNbtc=;
        b=inOoVf/jCaPZ1vm7uA3rCwZaPRwnW1KLWXqFSe2wlyryEXOXXlY9699GTbIlRLgZkF
         6MbQcYXheEOnTjmnW9Jn3LddUQBECMXMNfIDTWZr4Im88ndXDc9KRvw6Q0OmdybW1q1i
         LZR5u9kfccuSzLhDwlF8WSSz3tdYYt3SVJksiS/dXOl+6vKO+Jo6BX952//i77XkgITz
         o7TCIJ3Yrks1NtqHglKCwcoT8oeB+tmbJrivDakosTeQ6JX6MZIFh/Gr/Rzj7hUCurNc
         LOszObjYwaKQzgavB+awNFDyHd+fF2ahSVfNYf61ZZzWQCU3LLQyBQbHX6T0OTLwcOkN
         eN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740048973; x=1740653773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gd3mMLIYUgjuJbbnbMfJVs7U0S3pqaKkp98GWvyNbtc=;
        b=DgAwQls4IMji3Sw5i0V15TfOWOC7QXumk2OGoQLWLU6tZaNIU0AkOvRqAtIZ1+pqC8
         1GNyjlD95jX8aDWD4b1eCp+H7hBrS3j9eQ2HdhS33iWEsYsDJnZT1SkanNY69nFkURyc
         a9LV3ATl5EQrkO8jPKX+6qNezIy6ZuXb5hCo+av5Wb2KhWvbhdW3zRBjvspmrT423jl0
         x4Pi9tCkW8NUnJIfNne798EO/x/IxA3V7ytBqbU8Urk9QcUogygpJOatl9w5RK35QWYp
         V3X0C9EcLc+VLiQztDQ3Aqo6sGzOQlNqSkbnxBzR4AKQPrieXmq7jAJqT5xaIUNct6Iv
         /HOQ==
X-Gm-Message-State: AOJu0YwCqCq5uMJvwbXEhgGomk2pA947WXHXkldKs06UgRNEDxRG76T8
	WPpdhwcTQhtLzoE46HF7bsBxAJhHvpIPjUSHe0GRVDsDt2XFGg3Q
X-Gm-Gg: ASbGncurg9OmAX5GAeudq4ceu8yfjWV9nH3KnL/jmXFL79UX2oDcauHChTPLZV5cYtp
	61GE20kDFLTU8AttMiSv3s4CATOMRAssobw9IdPWfFgfQ8aE28ILwQddZkpy1Fg/8WmtenVoO1G
	B+t52pg3I7xzoSfL07UFWMFwuS9MtKCtOrHp/T5RBGZQvnvyKcr7PvDt1xXsfF2tm/IxDY30zI2
	WribxNZ6Ntg48n1LFRKZ0ez0yoC4Nb0C7Uiq1w3xQJOfZGd8KeZ3Okr7fsPWnB5Vg==
X-Google-Smtp-Source: AGHT+IFbpNwnVUs4CwsQcfzMkUPKxTMzPsZCxsVP8leN+bpObIOqWr95vhutxCy6LeebhoFiNI0Kyg==
X-Received: by 2002:a05:620a:4088:b0:7c0:b9bf:9057 with SMTP id af79cd13be357-7c0c42a667bmr167102185a.14.1740048973422;
        Thu, 20 Feb 2025 02:56:13 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c09f33bc60sm459639185a.108.2025.02.20.02.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 02:56:12 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	ryncsn@gmail.com,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix memmove when move keys down
Date: Thu, 20 Feb 2025 18:56:08 +0800
Message-ID: <20250220105608.1174912-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fix alone doesn't fix [1], but should be applied before debugging
that.

[1] https://syzkaller.appspot.com/bug?extid=38a0cbd267eff2d286ff

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e71b278672b6..80a0094be356 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
 		}
 got_good_key:
 		le16_add_cpu(&i->u64s, -next_good_key);
-		memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *) k);
+		memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) vstruct_end(i) - (u64 *) k);
 		set_btree_node_need_rewrite(b);
 	}
 fsck_err:
-- 
2.48.1

