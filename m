Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7021D7E26
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681711; cv=none; b=ail+9ZXmK3owxSGyp9Rs8Gnj3nakp57DkUQT4QFORnIMIvpbnOvB9BuMFOx12p9BkBjVx4yn5mgCOqbttAaRxayYMnm4lNt4AlIAFL6mm2XFZ3C3ooZ6dBuUhxfWvniFDGBzAsMyNF22udGIklC4dGSCMBwL6i2nL5DMpmx1Fm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681711; c=relaxed/simple;
	bh=RodTPrlmrQ9OPu2IQbo21Ri3NOamY4DYF9jzuUI9jZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kf77hMW0P9mMB2d5j4UJeDvwOlWrZGbRHcga8Pc1MFXvZaQC3qBaOvJbownPZ4piZQt9H4SYbojXl/q2Vrqp6Cq+6McmQYE05UxKj7yp5e1PXfGNrliyk+ksS+Q6modezFYf9WPFnArDaxHzo7qf9shpAWSiNADK3FnuKApOGlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iyrT742V; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iyrT742V"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CNm4BnRu62RBejUyvx86+pyorkDlb4bQhhJt8xmJnJM=;
	b=iyrT742V3jatYW5ZI2iHMm9+BSbkewDieCyfzUtvx4ysgZTXdGenH/8FSpEb7CySJ/jCbH
	Nqt3j1irDMkuEEV5tHSsnnaAk6G4IxJQuP9xNp6cLDIXx900PVmVKidAJxansx6QO5F+OG
	dLfEHVzeDkQLHMB1K0MHqBDayZPnlFM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/7] bcachefs: io_read: remove from async obj list in rbio_done()
Date: Wed, 16 Jul 2025 12:01:35 -0400
Message-ID: <20250716160141.1158722-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, only split rbios allocated in io_read.c would be removed
from the async obj list.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index cd184b219a65..e0874ad9a6cf 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -166,6 +166,7 @@ static noinline void promote_free(struct bch_read_bio *rbio)
 	BUG_ON(ret);
 
 	async_object_list_del(c, promote, op->list_idx);
+	async_object_list_del(c, rbio, rbio->list_idx);
 
 	bch2_data_update_exit(&op->write);
 
@@ -456,6 +457,10 @@ static void bch2_rbio_done(struct bch_read_bio *rbio)
 	if (rbio->start_time)
 		bch2_time_stats_update(&rbio->c->times[BCH_TIME_data_read],
 				       rbio->start_time);
+#ifdef CONFIG_BCACHEFS_ASYNC_OBJECT_LISTS
+	if (rbio->list_idx)
+		async_object_list_del(rbio->c, rbio, rbio->list_idx);
+#endif
 	bio_endio(&rbio->bio);
 }
 
-- 
2.50.0

