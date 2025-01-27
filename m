Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7AF152E02
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951181; cv=none; b=n6/A471G//ghb6hjNhxmZp/RVmpJJP3S5trFftipQ+Lt6LYKbfv1f/0O2VlAPR9sr8/A58EStCW46G5ohmkFHmxRuhAGwXobZKcoXNOCRL5FSmagjh6TRKM1HKGjOE11NMi1Xos/gebvIAL8HhZvA/Albud/Jj990Mr1vBY9u30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951181; c=relaxed/simple;
	bh=oe0gAgJXos+D10p2Og1rLlT8fpQeRp6vJLhQovT4Irg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+Q0pl0cTG4boTNZP9gKoERz4A2lbevPBFFAFQOnqi6ry0/EetYXIEhOMBFPYj86dAx7ZYj7MyA1dAiFaiKjD8R92/V0EwTWbFJURNLI8ZkpxqRqJzrKQ1/M1UIy3/PmU0gGryxGc/RFrpfEP+osTmYIhzeGIv9617i/gHVca/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bEJyRDBH; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bEJyRDBH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=btzZtmDm0O5mlcyK0I//lNct9NMpLCAqZgoQ8O4RYQ4=;
	b=bEJyRDBHTb/2gvjfWqDrc6Pt++193GG98LHY4hSqkAn5xUFbL4XcZEUCPiiKQYcUJbwsjn
	sQs8aOKss6fonBcWlBnieTyzrZRec8B1FdKgi2Pw/YaZNfGvU00zqJrfVDupXflCwDWD+t
	bDnn5JqBAjAsrWetP6Rauuoc30pvo7g=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/11] bcachefs: Journal writes are now IOPRIO_CLASS_RT
Date: Sun, 26 Jan 2025 23:12:35 -0500
Message-ID: <20250127041239.2693707-10-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

System performance is particularly sensitive to journal write latency,
the number of outstanding journal writes is bounded and we can't issue
journal flushes until other journal writes have completed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 7f2efe85a805..11c39e0c34f4 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -17,6 +17,7 @@
 #include "sb-clean.h"
 #include "trace.h"
 
+#include <linux/ioprio.h>
 #include <linux/string_choices.h>
 
 void bch2_journal_pos_from_member_info_set(struct bch_fs *c)
@@ -1763,6 +1764,7 @@ static CLOSURE_CALLBACK(journal_write_submit)
 		bio->bi_iter.bi_sector	= ptr->offset;
 		bio->bi_end_io		= journal_write_endio;
 		bio->bi_private		= ca;
+		bio->bi_ioprio		= IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0);
 
 		BUG_ON(bio->bi_iter.bi_sector == ca->prev_journal_sector);
 		ca->prev_journal_sector = bio->bi_iter.bi_sector;
-- 
2.45.2

