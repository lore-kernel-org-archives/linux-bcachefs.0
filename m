Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787A38DC2
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q8KR0hrY"
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876B33EB0F
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:10 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rmFWbWn39gKmN6xhNqA2M+UB0GunQtFXyNoKWJP6RUI=;
	b=q8KR0hrYsk17oA3LiSbnql/gVUzeHieKthoIAj/8K5867SNl1rj7Gdvwmvs5/ZRm2JMU/5
	EOKp6hjLj+xz04rjRHB6MKvQ/Wkr0WwrmA98UxIXMOfs7xoSBxWUhixgE6OQMC0u9I6IXi
	MyQlenfcBudDOVzoOYbdsvTiAzPX0gY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/17] bcachefs: Unwritten journal buffers are always dirty
Date: Fri, 10 Nov 2023 11:31:46 -0500
Message-ID: <20231110163157.2736111-10-kent.overstreet@linux.dev>
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

Ensure that journal bufs that haven't been written can't be reclaimed
from the journal pin fifo, and can thus have new pins taken.

Prep work for changing the btree write buffer to pull keys from the
journal directly.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal_io.c      | 1 +
 fs/bcachefs/journal_reclaim.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 52a59770d8d0..51796454bba4 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1583,6 +1583,7 @@ static void journal_write_done(struct closure *cl)
 	} while ((v = atomic64_cmpxchg(&j->reservations.counter,
 				       old.v, new.v)) != old.v);
 
+	bch2_journal_reclaim_fast(j);
 	bch2_journal_space_available(j);
 
 	track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight],
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 8fa05bedb7df..67684cc5c1e5 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -303,6 +303,7 @@ void bch2_journal_reclaim_fast(struct journal *j)
 	 * all btree nodes got written out
 	 */
 	while (!fifo_empty(&j->pin) &&
+	       j->pin.front <= j->seq_ondisk &&
 	       !atomic_read(&fifo_peek_front(&j->pin).count)) {
 		j->pin.front++;
 		popped = true;
-- 
2.42.0

