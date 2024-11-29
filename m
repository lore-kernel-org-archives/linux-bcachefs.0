Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822F314D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912088; cv=none; b=m/VCX+fflDFSp5hnzSM4RvKzuMK33tI6m3Trj6utaNR56EEz14Gpfd8H6ab7+fLxs6r7SSHipZ4e7OpajLi/ZxuSU8KHlDX7GX/2k6rahTmHAwhre6wyYdlGlAb3eJ/HDtD5v9fA6fbfeLWypXsrXRBakTwOkwuTtykeKTM6gWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912088; c=relaxed/simple;
	bh=8uSYjasaU0T0qTN8vMhMk4PKTvKfctOi1FY6RXZ5L8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+L1ncImqCrURBYxDkOQXsE77PjyUTEq2CwW4/fTUGqizKmSUMOKeMv2b9zHVkdm8kXThQVtwV6KGR483bzLEVWRny54jIOXSN11QUS5t6Qqw4LUAJuYnoKltH9NJQRfxKQDL585NR0F8wUJYpYmluFPk7u0fZSiRrBEiOJy3lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com
Subject: [PATCH 21/34] bcachefs: Guard against journal seq overflow
Date: Fri, 29 Nov 2024 15:27:20 -0500
Message-ID: <20241129202736.2713679-22-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Wraparound is impractical to handle since in various places we use 0 as
a sentinal value - but 64 bits (or 56, because the btree write buffer
steals a few bits) is enough for all practical purposes.

Reported-by: syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 9 +++++++++
 fs/bcachefs/journal_types.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 95cccda3b22c..dc66521964b7 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -382,6 +382,10 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
+	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
+				 c, "cannot start: journal seq overflow"))
+		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+
 	BUG_ON(!j->cur_entry_sectors);
 
 	buf->expires		=
@@ -1270,6 +1274,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	bool had_entries = false;
 	u64 last_seq = cur_seq, nr, seq;
 
+	if (cur_seq >= JOURNAL_SEQ_MAX) {
+		bch_err(c, "cannot start: journal seq overflow");
+		return -EINVAL;
+	}
+
 	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
 		i = *_i;
 
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 425d1abb257e..e9bd716fbb71 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -9,6 +9,9 @@
 #include "super_types.h"
 #include "fifo.h"
 
+/* btree write buffer steals 8 bits for its own purposes: */
+#define JOURNAL_SEQ_MAX		((1ULL << 56) - 1)
+
 #define JOURNAL_BUF_BITS	2
 #define JOURNAL_BUF_NR		(1U << JOURNAL_BUF_BITS)
 #define JOURNAL_BUF_MASK	(JOURNAL_BUF_NR - 1)
-- 
2.45.2

