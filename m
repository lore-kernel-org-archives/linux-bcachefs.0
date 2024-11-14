Received: from zulu.geekplace.eu (zulu.geekplace.eu [5.45.100.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131104CB36;
	Thu, 14 Nov 2024 21:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.45.100.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731618893; cv=none; b=YQjv7nf3EArQCxY/fwuUloJq8xWEzVL2F2OHawLcTGQHHDqrawFQk+5Z+e0DgYR7/gH80ZIqSduMxptO9pahkW6fBNzKmwcLomtaIZ0kbAS31FGl7yAjSpAhnPDWqOclrXbq/fFDqN3q3UMi7cgExbyzDEjXNQpOCtI0RTHswhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731618893; c=relaxed/simple;
	bh=8dJ0hJbPKBXGDqhEM08F0Xq+j3C/DQIvPSIjANwK3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfAPkQtUuI8yUf4TyRkT8FRkYzU/W39xjtQlvp7Nu4qa/xYdx2dzVYMmd4xFo9juIomsVd1mSZBua/+Spi5zopWAJ+b+OnUdmWVET2b/qPf3FL90J/YqqMH4mHcd9qrmCAjqvbVBCz94IDThf07h8J9gaAYc+engUOEMdI5LYnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=geekplace.eu; arc=none smtp.client-ip=5.45.100.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geekplace.eu
Received: from neo-pc.sch (unknown [IPv6:2001:4090:a240:80f6:34fb:50ff:feac:591b])
	by zulu.geekplace.eu (Postfix) with ESMTPA id 5D7174A01FC;
	Thu, 14 Nov 2024 22:07:33 +0100 (CET)
From: Florian Schmaus <flo@geekplace.eu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Florian Schmaus <flo@geekplace.eu>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: Set rebalance thread to SCHED_BATCH and nice 19
Date: Thu, 14 Nov 2024 22:06:48 +0100
Message-ID: <20241114210649.71377-2-flo@geekplace.eu>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241114210649.71377-1-flo@geekplace.eu>
References: <20241114210649.71377-1-flo@geekplace.eu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the rebalance thread's scheduling class to BATCH, which means it
could experience a higher scheduling latency. However, it reduces
preemption events of running threads.

And while the rebalance thread is ually not compute bound, it does
cause a considerable amount of I/O. By increasing its nice level from
0 to 19 we also implicitly reduce the thread's best-effort I/O
scheduling class level from 4 to 7. Therefore, the rebalance thread's
I/O operations will be deprioritized over standard I/O operations.

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 fs/bcachefs/rebalance.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 4adc74cd3f70..b26c68007c5a 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -22,6 +22,7 @@
 
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 #include <linux/sched/cputime.h>
 
 /* bch_extent_rebalance: */
@@ -662,6 +663,8 @@ int bch2_rebalance_start(struct bch_fs *c)
 	if (ret)
 		return ret;
 
+	sched_set_batch(p, 19);
+
 	get_task_struct(p);
 	rcu_assign_pointer(c->rebalance.thread, p);
 	wake_up_process(p);
-- 
2.45.2

