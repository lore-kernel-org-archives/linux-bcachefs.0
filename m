Received: from zulu.geekplace.eu (zulu.geekplace.eu [5.45.100.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB6229627;
	Tue, 14 Jan 2025 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.45.100.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860306; cv=none; b=ij3c2cs5ztXkzUAEZbm48cH1GwnXSOBOVzbnvj7DQCpsw9SbL8BBdK4OqBLCN2g3jWPbm/7ElOl83u9xob8hFDIcWK+8jaSU77OuNTPT9tPlRSQnEqeGNb08d50KtUXjuadAkLhsdNtSydzkVyLxaMdOQLT32g1Gad7cimlFmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860306; c=relaxed/simple;
	bh=wTUioNE9KmC0WnqhHbKLnvyOhk5Xn9fgU6QE/xVmLlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OCXbBhtWWCluGNymXcxFG8JrvLPIpp0DlJV4XpJi3fbdkar0qqIgUEgZQi+IH4sQ6nH/PpL4UDs9w1yQQfl/gWBmHDVcTGjxTmKQkIw4964nubvWJV4DMhfX6YjB2kMtBIvaZSrttVdCFiYQ9RUDe5wD7bhKMRtsUTQANn9Bf10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=geekplace.eu; arc=none smtp.client-ip=5.45.100.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geekplace.eu
Received: from neo-pc.sch (unknown [IPv6:2001:4091:a244:80ab:34fb:50ff:feac:591b])
	by zulu.geekplace.eu (Postfix) with ESMTPA id 2CFD04A0040;
	Tue, 14 Jan 2025 14:05:41 +0100 (CET)
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
	linux-kernel@vger.kernel.org
Subject: [RESEND] Add sched_set_batch() and run bcachefs-rebalance under SCHED_BATCH
Date: Tue, 14 Jan 2025 13:47:26 +0100
Message-ID: <20250114130513.498482-2-flo@geekplace.eu>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resending the patchset which first adds the sched_set_batch(),
akin to the existing sched_set_normal() and sched_set_fifo_low()
functions. In the second patch, we use sched_set_batch() to run
bcachefs' rebalance thread under SCHED_BATCH.

I am resending the patchset [1,2], since the two patches of the set
where not send to the same recipients. This probably caused some
confusion.

1: https://lore.kernel.org/lkml/20241114210649.71377-1-flo@geekplace.eu/
2: https://lore.kernel.org/lkml/20241114210649.71377-2-flo@geekplace.eu/

