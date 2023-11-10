Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5938DC5
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2NSWLrq"
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA7B3EB08
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:11 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gymOPzA4EO+MlthIckrUAdFfMv+mkbLMegehE/EQmG4=;
	b=C2NSWLrqO5l7aCQkxMk7Oafg5MsC+AZ0XHXqcYWyVmHcQzeW1Koge0301RGU1iVMlije1D
	t6TT/v09fCT5Ih9OUZgk4VEH+bULrMnAfr3Em6obmpnAAbFfmvV6T7EqEfWxJ2Cpr5xOws
	vE+gnnWqOHz8/8PY0kBEob1sdmRyT3M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/17] bcachefs: journal->buf_lock
Date: Fri, 10 Nov 2023 11:31:47 -0500
Message-ID: <20231110163157.2736111-11-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new lock for synchronizing between journal IO path and btree write
buffer flush.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 1 +
 fs/bcachefs/journal_io.c    | 2 ++
 fs/bcachefs/journal_types.h | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 7d448136434b..3a6b73d4ec24 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1215,6 +1215,7 @@ int bch2_fs_journal_init(struct journal *j)
 	static struct lock_class_key res_key;
 	unsigned i;
 
+	mutex_init(&j->buf_lock);
 	spin_lock_init(&j->lock);
 	spin_lock_init(&j->err_lock);
 	init_waitqueue_head(&j->wait);
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 51796454bba4..2394d4b02fff 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1869,9 +1869,11 @@ void bch2_journal_write(struct closure *cl)
 	if (ret)
 		goto err;
 
+	mutex_lock(&j->buf_lock);
 	journal_buf_realloc(j, w);
 
 	ret = bch2_journal_write_prep(j, w);
+	mutex_unlock(&j->buf_lock);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 2427cce64fed..0fed32f94976 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -181,6 +181,12 @@ struct journal {
 	 */
 	darray_u64		early_journal_entries;
 
+	/*
+	 * Protects journal_buf->data, when accessing without a jorunal
+	 * reservation: for synchronization between the btree write buffer code
+	 * and the journal write path:
+	 */
+	struct mutex		buf_lock;
 	/*
 	 * Two journal entries -- one is currently open for new entries, the
 	 * other is possibly being written out.
-- 
2.42.0

