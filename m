Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AC835962
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744815936; cv=none; b=dIG9htrIg4W05MccgxWnoYxCr1PtClKa4BtBgnKmeq0bVLd+GFa1MZUUmlC1dUAythxRQj7R0EgZ1XXUvRPUgz0MfN+JuAxBzNwf6HhYjvsXcwmTfRIPfa4cu+h716fxOuTBwym3UAjJOWCUbFwNPk2r3uNRGGOgKoD8EC4E404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744815936; c=relaxed/simple;
	bh=ed8TXplqdq+HoC2g/2JYotgLa1SXRzPSJgJ1T4ty7BA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ITM0hibfvJVkexKdOSVb9TmKgThL3lta93PvBqw/GXVE/cbzllttvmH/hLDr0UJegfuQdFp8GgnfqRQO7uHnYS88+HEukpbii+3tQalcwbAH52y8XI1vBzxUm8ena26M4Hv1p2MhEJ4nHiuSLDIH6benvKCtFVTNzBWXrcgH9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZHHbf0NB; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZHHbf0NB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744815931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fjI1I7gqSNNhLQuCXUSAcz7z1Ihg9yF4Fz9RZAdaLRg=;
	b=ZHHbf0NB75CfmyZ4bud4tS2L878yoZ+DJ07gWbCmLMvOM57ov2ZjfJZjklHt00CjSKlZft
	JZc/i42U3QOR+fgRGUUPh205tG3uq7rjCv1Y2H+eqKoYw/VYbti64baRTcZyn4ieoH9fQi
	0PVa5Bf1yj25mEsmAbfYFyLsr2GKRrM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] docs: bcachefs: idle work scheduling design doc
Date: Wed, 16 Apr 2025 11:05:26 -0400
Message-ID: <20250416150526.3683518-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

People have been asking to see the plan for this, so -

bcachefs has various background tasks that need to be scheduled to
balance efficiency, predictability of performance, etc.

The design and philosophy hasn't changed too much since bcache, which
was primarily designed for server usage, with sustained load in mind.

These days we're seeing more desktop usage - where we really want to let
the system idle effictively, to reduce total power usage - while also
still balancing previous concerns, we still want to let work accumulate
to a degree.

This lays out all the requirements and starts to sketch out the
algorithm I have in mind.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 .../filesystems/bcachefs/future/idle_work.rst | 77 ++++++++++++++++++
 Documentation/filesystems/bcachefs/index.rst  | 31 -------
 fs/bcachefs/idle.h                            | 80 +++++++++++++++++++
 3 files changed, 157 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/future/idle_work.rst
 delete mode 100644 Documentation/filesystems/bcachefs/index.rst
 create mode 100644 fs/bcachefs/idle.h

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
new file mode 100644
index 000000000000..e2afe45e9dc7
--- /dev/null
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -0,0 +1,77 @@
+Idle/background work classes design doc:
+
+Right now, our behaviour at idle isn't ideal, it was designed for servers that
+would be under sustained load, to keep pending work at a "medium" level, to
+let work build up so we can process it in more efficient batches, while also
+giving headroom for bursts in load.
+
+But for desktops or mobile - scenarios where work is less sustained and power
+usage is more important - we want to operate differently, with a "rush to
+idle" so the system can go to sleep. We don't want to be dribbling out
+background work while the system should be idle.
+
+The complicating factor is that there are a number of background tasks, which
+form a heirarchy (or a digraph, depending on how you divide it up) - one
+background task may generate work for another.
+
+Thus proper idle detection needs to model this heirarchy.
+
+- Foreground writes
+- Page cache writeback
+- Copygc, rebalance
+- Journal reclaim
+
+When we implement idle detection and rush to idle, we need to be careful not
+to disturb too much the existing behaviour that works reasonably well when the
+system is under sustained load (or perhaps improve it in the case of
+rebalance, which currently does not actively attempt to let work batch up).
+
+SUSTAINED LOAD REGIME
+---------------------
+
+When the system is under continuous load, we want these jobs to run
+continuously - this is perhaps best modelled with a P/D controller, where
+they'll be trying to keep a target value (i.e. fragmented disk space,
+available journal space) roughly in the middle of some range.
+
+The goal under sustained load is to balance our ability to handle load spikes
+without running out of x resource (free disk space, free space in the
+journal), while also letting some work accumululate to be batched (or become
+unnecessary).
+
+For example, we don't want to run copygc too aggressively, because then it
+will be evacuating buckets that would have become empty (been overwritten or
+deleted) anyways, and we don't want to wait until we're almost out of free
+space because then the system will behave unpredicably - suddenly we're doing
+a lot more work to service each write and the system becomes much slower.
+
+IDLE REGIME
+-----------
+
+When the system becomes idle, we should start flushing our pending work
+quicker so the system can go to sleep.
+
+Note that the definition of "idle" depends on where in the heirarchy a task
+is - a task should start flushing work more quickly when the task above it has
+stopped generating new work.
+
+e.g. rebalance should start flushing more quickly when page cache writeback is
+idle, and journal reclaim should only start flushing more quickly when both
+copygc and rebalance are idle.
+
+It's important to let work accumulate when more work is still incoming and we
+still have room, because flushing is always more efficient if we let it batch
+up. New writes may overwrite data before rebalance moves it, and tasks may be
+generating more updates for the btree nodes that journal reclaim needs to flush.
+
+On idle, how much work we do at each interval should be proportional to the
+length of time we have been idle for. If we're idle only for a short duration,
+we shouldn't flush everything right away; the system might wake up and start
+generating new work soon, and flushing immediately might end up doing a lot of
+work that would have been unnecessary if we'd allowed things to batch more.
+ 
+To summarize, we will need:
+- A list of classes for background tasks that generate work, which will
+  include one "foreground" class.
+- Tracking for each class - "Am I doing work, or have I gone to sleep?"
+- And each class should check the class above it when deciding how much work to issue.
diff --git a/Documentation/filesystems/bcachefs/index.rst b/Documentation/filesystems/bcachefs/index.rst
deleted file mode 100644
index 3864d0ae89c1..000000000000
--- a/Documentation/filesystems/bcachefs/index.rst
+++ /dev/null
@@ -1,31 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-======================
-bcachefs Documentation
-======================
-
-Subsystem-specific development process notes
---------------------------------------------
-
-Development notes specific to bcachefs. These are intended to supplement
-:doc:`general kernel development handbook </process/index>`.
-
-.. toctree::
-   :maxdepth: 1
-   :numbered:
-
-   CodingStyle
-   SubmittingPatches
-
-Filesystem implementation
--------------------------
-
-Documentation for filesystem features and their implementation details.
-At this moment, only a few of these are described here.
-
-.. toctree::
-   :maxdepth: 1
-   :numbered:
-
-   casefolding
-   errorcodes
diff --git a/fs/bcachefs/idle.h b/fs/bcachefs/idle.h
new file mode 100644
index 000000000000..eea49d879e3a
--- /dev/null
+++ b/fs/bcachefs/idle.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_IDLE_H
+#define _BCACHEFS_IDLE_H
+
+/*
+ * Idle/background work classes:
+ *
+ * We have a number of background tasks (copygc, rebalance, journal reclaim).
+ *
+ * SUSTAINED LOAD REGIME
+ * ---------------------
+ *
+ * When the system is under continuous load, we want these jobs to run
+ * continuously - this is perhaps best modelled with a P/D controller, where
+ * they'll be trying to keep a target value (i.e. fragmented disk space,
+ * available journal space) roughly in the middle of some range.
+ *
+ * The goal under sustained load is to balance our ability to handle load spikes
+ * without running out of x resource (free disk space, free space in the
+ * journal), while also letting some work accumululate to be batched (or become
+ * unnecessary).
+ *
+ * For example, we don't want to run copygc too aggressively, because then it
+ * will be evacuating buckets that would have become empty (been overwritten or
+ * deleted) anyways, and we don't want to wait until we're almost out of free
+ * space because then the system will behave unpredicably - suddenly we're doing
+ * a lot more work to service each write and the system becomes much slower.
+ *
+ * IDLE REGIME
+ * -----------
+ *
+ * Many systems are however not under sustained load - they're idle most of the
+ * time, and the goal is to let them idle as much as possible because power
+ * useage is a prime consideration. Thus, we need to detect when we've been
+ * idle - and the longer we've been idle, the more pending work we should do;
+ * the goal being to complete all of our pending work as quickly as possible so
+ * that the system can go back to sleep.
+ *
+ * But this does not mean that we should do _all_ our pending work immediately
+ * when the system is idle; remember that if we allow work to build up, much
+ * work will not need to be done.
+ *
+ * Therefore when we're idle we want to wake up and do some amount of pending
+ * work in batches; increasing both the amount of work we do and the duration of
+ * our sleeps proportional to how long we've been idle for.
+ *
+ * CLASSES OF IDLE WORK
+ * --------------------
+ *
+ * There are levels of foreground and background tasks; a foreground operation
+ * (generated from outsisde the system, i.e. userspace) will generate work for
+ * the data move class and the journal reclaim class, and the data move class
+ * will generate more work for the journal reclaim class.
+ *
+ * This complicates idle detection, because a given class wants to know if
+ * everything above it has finished or is no longer running, and will want to
+ * behave differently for work above it coming from outside the system (which we
+ * cannot schedule and can only guess at based on past behaviour), versus work
+ * above it but from inside the system (which we can schedule).
+ *
+ * That is
+ * - data moves want to wake up when foreground operations have been quiet for
+ *   a little while
+ * - journal reclaim wants to wake up when foreground operations have been quiet
+ *   for a little while, and immediately after background data moves have
+ *   finished and gone back to sleep
+ */
+
+#define BCACHEFS_IDLE_CLASSES()		\
+	x(foreground)			\
+	x(data_move)			\
+	x(journal_reclaim)
+
+enum bch_idle_class {
+#define x(n)	BCH_IDLE_##n,
+	BCACHEFS_IDLE_CLASSES()
+#undef x
+};
+
+#endif /* _BCACHEFS_IDLE_H */
-- 
2.49.0

