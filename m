Received: from zulu.geekplace.eu (zulu.geekplace.eu [5.45.100.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F20234CEA;
	Tue, 14 Jan 2025 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.45.100.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860306; cv=none; b=ohfwiloCKGtwqs6xMhxv1dzSH211LXC1C6l7VIE8Zqmg3PbAo165ev8MnsoKhpcZzX6vdSwQkfpb/4YUOtU/FXSTyhW2rlqGSl01X2M+PFHKfDmNwi4HfOtoJfRFolnhTB1eaTZJRnT/2ZAxcOuFC7b8TH+pNSxqh4OJD6SoC88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860306; c=relaxed/simple;
	bh=Bj5FnEmUDANu3IKnq6qsbq0Z/psIRt+l809kE2S4YPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIxHtnTDk4emfz11mB1bWL4qohXm+BDF0kdZD2X5FPgjMFv3lW3LC/S08Hxup0WibVfTQjTyk3bp2hMrlzlm34X8mHVaYw2SZfyrhrv8o2efiYxQHPf9R5JbGlX4qalAqQ92yJWIZHVpgsPKgzUa0Jv1jXIP411jOoWH6cvFsHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=geekplace.eu; arc=none smtp.client-ip=5.45.100.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geekplace.eu
Received: from neo-pc.sch (unknown [IPv6:2001:4091:a244:80ab:34fb:50ff:feac:591b])
	by zulu.geekplace.eu (Postfix) with ESMTPA id B986A4A008D;
	Tue, 14 Jan 2025 14:05:46 +0100 (CET)
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
Subject: [PATCH 1/2] sched: provide sched_set_batch()
Date: Tue, 14 Jan 2025 13:47:27 +0100
Message-ID: <20250114130513.498482-3-flo@geekplace.eu>
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

This allows kernel threads created by modules to run under
SCHED_BATCH. Typically this may be a good option if the task of the
kernel thread is not sensitive to scheduling latency, for example
rebalancing or gc tasks.

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 include/linux/sched.h   |  1 +
 kernel/sched/syscalls.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64934e0830af..80d46ed1dfa8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1874,6 +1874,7 @@ extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sc
 extern void sched_set_fifo(struct task_struct *p);
 extern void sched_set_fifo_low(struct task_struct *p);
 extern void sched_set_normal(struct task_struct *p, int nice);
+extern void sched_set_batch(struct task_struct *p, int nice);
 extern int sched_setattr(struct task_struct *, const struct sched_attr *);
 extern int sched_setattr_nocheck(struct task_struct *, const struct sched_attr *);
 extern struct task_struct *idle_task(int cpu);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index ff0e5ab4e37c..e0e0be4223df 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -880,6 +880,16 @@ void sched_set_normal(struct task_struct *p, int nice)
 }
 EXPORT_SYMBOL_GPL(sched_set_normal);
 
+void sched_set_batch(struct task_struct *p, int nice)
+{
+	struct sched_attr attr = {
+		.sched_policy = SCHED_BATCH,
+		.sched_nice = nice,
+	};
+	WARN_ON_ONCE(sched_setattr_nocheck(p, &attr) != 0);
+}
+EXPORT_SYMBOL_GPL(sched_set_batch);
+
 static int
 do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 {
-- 
2.45.2

