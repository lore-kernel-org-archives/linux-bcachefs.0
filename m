Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF810F2;
	Wed, 11 Sep 2024 00:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726015344; cv=none; b=mopMJj3QIwXgNyiTdxs2DRt//gWcRMXHtHRbPlCKn1IW4VhfBSKjlId5oObWpH3I/anUlP3xrmIWBvovBZ2ic2MB8jQK2nnmNgyi6mfQW4zdC83efh3woxDOfrinoyYpW09LslasTx87PAPToXmUy6VOEGuzs/OX7xvtcoMdQ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726015344; c=relaxed/simple;
	bh=n3TpWyUkRt5idYCrOs9Rg7DvAkTda0Oa7o5tCI4XueI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MukiGYyCHJqDHeZtAb2uFo0HKhZ3+t/kR1M0Fc9dGGXA+g2Oh5VpTNLw0F2qklwg+zV9xxmE/QnaR2HB/Cc9yU5lUIElrSS419i2NIJMR0ewqkXkdu1bDsPKUBzpzIBY1woUJWQHoveVh26H02siudpD6fg01j/soHs4l6IVw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xnAgp18A; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xnAgp18A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1726015338; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=j++dOjqFm3InyBgden5iwAQp/AVIJ7CGYcnlVhhFNpk=;
	b=xnAgp18AWJR778CJaTJTekSxb/UFwOC+WsZFWo5z2iLsiNuY2LdDJ2QDSsvVXOcPXMORMsIbkO8s6jWD54+vzRySFsRPq9W25+X8Yz2wHb2Psn5rHCl5qpcaHj4KVO3Ds/Wn0enrp63TYmBnslUSxop4y28VQckkXVOSsI+o5qg=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WElmEnp_1726015336)
          by smtp.aliyun-inc.com;
          Wed, 11 Sep 2024 08:42:17 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove unneeded semicolon
Date: Wed, 11 Sep 2024 08:42:16 +0800
Message-Id: <20240911004216.42648-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/bcachefs/ec.c:903:24-25: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=10836
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index c26319475876..c63d9c6fa734 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -900,7 +900,7 @@ int bch2_ec_read_extent(struct btree_trans *trans, struct bch_read_bio *rbio,
 	bch2_bkey_val_to_text(&msgbuf, c, orig_k);
 	bch_err_ratelimited(c,
 			    "error doing reconstruct read: %s\n  %s", msg, msgbuf.buf);
-	printbuf_exit(&msgbuf);;
+	printbuf_exit(&msgbuf);
 	ret = -BCH_ERR_stripe_reconstruct;
 	goto out;
 }
-- 
2.32.0.3.g01195cf9f

