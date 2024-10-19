Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755F41E04AE
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 12:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729340787; cv=none; b=ogdEWVJpArjEOengBlWj+vmRhX5YovbDpWwFUQVB1JkzcCz+LrCFqOcPFDPxWhbbn79I7/ZFQU4NjCJZjEk5heUM8b0Q59J/iGHYxSvid4WXD/8qnZ70RBW4gTTEN6G6Mogprr58bSdjKmbzdgvwNNTkbT1l53YImw/EiHv075g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729340787; c=relaxed/simple;
	bh=TPPqJ0NmPL4E/VoFBUo0djk7VWetDY3ISarvN6BlR/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6QfEkvooAQxz9SUYSL09wu5Vwtu/qEVLtdQfAFRjDC5Lgu98gvtPuyRkvZqGGQvVRxk1ANHQD5cg+zGV4kfRNcflFjMiXB2qXjpW8d8H9mH9TlQBAB+eO9QzRRXfKGkcAgXF8hlKpfInLR4wEyfyJlCZ3xWxUdXMQfT8XvKoA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U20d6OcS; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U20d6OcS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729340782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PLY+s3Nc2BlIMQaSEKQErw4KcQTV95CxN6tP27JoM10=;
	b=U20d6OcSxF0YqMeOWJy+13sewVbtnvy6F6RXAmgN3scdLVSDu5xPodxLCMPEsq/7kV+C4e
	441HEZRTqlAf3kV4y4B87BZy+phUsAmpvUKPlC7/cBS3Pnf7mDUqe7NFMeYVj7i8syp4NP
	7PgcGHLa7qV/ayh6xJ4+VhBQSL1ezmU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Use str_write_read() helper function
Date: Sat, 19 Oct 2024 14:25:27 +0200
Message-ID: <20241019122526.42563-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the helper function str_write_read().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/journal_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 954f6a96e0f4..325c39f90f65 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -17,6 +17,8 @@
 #include "sb-clean.h"
 #include "trace.h"
 
+#include <linux/string_choices.h>
+
 void bch2_journal_pos_from_member_info_set(struct bch_fs *c)
 {
 	lockdep_assert_held(&c->sb_lock);
@@ -665,7 +667,7 @@ static void journal_entry_clock_to_text(struct printbuf *out, struct bch_fs *c,
 	struct jset_entry_clock *clock =
 		container_of(entry, struct jset_entry_clock, entry);
 
-	prt_printf(out, "%s=%llu", clock->rw ? "write" : "read", le64_to_cpu(clock->time));
+	prt_printf(out, "%s=%llu", str_write_read(clock->rw), le64_to_cpu(clock->time));
 }
 
 static int journal_entry_dev_usage_validate(struct bch_fs *c,
-- 
2.47.0

