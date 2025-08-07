Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4262D19E7F7;
	Thu,  7 Aug 2025 02:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754532797; cv=none; b=d0royLqxguC8g1pWjBrfQ5KifNDcYa58/IGYH/Xl2quENJNxgE4IrhKa/PhVNqoQAN0+QCc/nOXyymX8J4vDHi8P7d7rI+pK6I55COQ3W03fwWsj6N1D/zPDQ6lF1s4fhrVTfD93AMn7wVYDMBD+TjylgT21CG5qLGzx4Xma/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754532797; c=relaxed/simple;
	bh=bjZoRWfLpmeOdTTI4k9aMb9/Ih/LSgljnLO6aUeUF6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lwuCyO2iW9q9zyL2qmj0WZ3gefB7gkohM2JBKxVkwti9WQSLs96QblXANRSe2MUw/XUb+vSFmfLNtbdFdFv+Ceqkk3zZgGy1i6g/yIrku9HICLqpgPXY2x/QuV6UaesQnaQ3ZXQCgXur2Hq3kd5c3r797OP5MpLz6/a7t9anizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CaNON5Dy; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CaNON5Dy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754532785; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wjzpvRTlPXbCAqH7c9SEYA2qoDEppt1RnIPgRipvYoQ=;
	b=CaNON5Dy3TiU9eH7cxGqcQY1CY/lR6Vfv1/hBGrZsCCMEx9iBQAtERMq+D0LQVuzwF0suBwOrKbtK7kCQzHnCjgJ8Ku0z6PilGp9tEmwm23bhsj1VGS8o0agnNtxb0SZF+XdCba3EBtWeNAYmQwGR0K6MMJNuOLj9UH/sfaVHBw=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WlCHQX1_1754532457 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Aug 2025 10:07:46 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: remove unneeded semicolon
Date: Thu,  7 Aug 2025 10:07:36 +0800
Message-ID: <20250807020736.2418895-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional modification involved.

./fs/bcachefs/btree_trans_commit.c:343:32-33: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=23409
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/bcachefs/btree_trans_commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 4d58bdb233e9..2a69c05a27bf 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -340,7 +340,7 @@ static inline void btree_insert_entry_checks(struct btree_trans *trans,
 	BUG_ON(i->cached	!= path->cached);
 	BUG_ON(i->cached &&
 	       !i->key_cache_already_flushed  &&
-	       bkey_deleted(&i->k->k));;
+	       bkey_deleted(&i->k->k));
 	BUG_ON(i->level		!= path->level);
 	BUG_ON(i->btree_id	!= path->btree_id);
 	BUG_ON(i->bkey_type	!= __btree_node_type(path->level, path->btree_id));
-- 
2.43.5

