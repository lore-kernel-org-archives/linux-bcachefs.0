Received: from zulu.geekplace.eu (zulu.geekplace.eu [5.45.100.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4F236A91;
	Tue, 14 Jan 2025 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.45.100.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860308; cv=none; b=TMLAO94R99s/dbxRjowOt5OaaUUjFDZfwJpLGdgvJWe5ZaaCcUje3e95crGUdvErLBnw5CrIHWkQMej2CNh024HYFop7iNjevxcAoFOBhi0ujyiSnMxu5aQTnNzHukUJJEfkqpekcBF6oR1icYkdj/i68+prvhWt9iFCDH5zaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860308; c=relaxed/simple;
	bh=er4aJjgFNTkQb4sR+8CKCroPY2b+ZjQRSWYxSFTffQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi9goaMvqS/1NQhIbMEbQVonwV5C6CAWuXrxs65OeNAPUM1obFAOWLQVQEo/S8V/e2Hb/e7dYgKLet3d3CqPLF5y73ZaJhXBqpABqxCbepPN4qWpq8F3XaZuBghEfcpMKkkpf2PoNJI1bm06Z6Ry5ie1Rip87AsIpVcOSWOjiW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=geekplace.eu; arc=none smtp.client-ip=5.45.100.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geekplace.eu
Received: from neo-pc.sch (unknown [IPv6:2001:4091:a244:80ab:34fb:50ff:feac:591b])
	by zulu.geekplace.eu (Postfix) with ESMTPA id 3253E4A018D;
	Tue, 14 Jan 2025 14:05:47 +0100 (CET)
From: Florian Schmaus <flo@geekplace.eu>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Florian Schmaus <flo@geekplace.eu>
Subject: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and nice 19
Date: Tue, 14 Jan 2025 13:47:28 +0100
Message-ID: <20250114130513.498482-4-flo@geekplace.eu>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250114130513.498482-2-flo@geekplace.eu>
References: <20250114130513.498482-2-flo@geekplace.eu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the rebalance thread is isually not compute bound, it does cause
a considerable amount of I/O. Since "reducing" the nice level from 0
to 19, also implicitly reduces the threads best-effort I/O scheduling
class level from 4 to 7, the reblance thread's I/O will be depriotized
over normal I/O.

Furthermore, we set the rebalance thread's scheduling class to BATCH,
which means that it will potentially receive a higher scheduling
latency. Making room for threads that need a low
schedulinglatency (e.g., interactive onces).

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 fs/bcachefs/rebalance.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index cd6647374353..87e4f507af80 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -22,6 +22,7 @@
 
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 #include <linux/sched/cputime.h>
 
 #define REBALANCE_WORK_SCAN_OFFSET	(U64_MAX - 1)
@@ -478,6 +479,8 @@ int bch2_rebalance_start(struct bch_fs *c)
 	if (ret)
 		return ret;
 
+	sched_set_batch(p, 19);
+
 	get_task_struct(p);
 	rcu_assign_pointer(c->rebalance.thread, p);
 	wake_up_process(p);
-- 
2.45.2

