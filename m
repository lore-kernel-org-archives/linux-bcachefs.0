Received: from zulu.geekplace.eu (zulu.geekplace.eu [5.45.100.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BD1FC7DB;
	Thu, 19 Dec 2024 08:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.45.100.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734598357; cv=none; b=AvejZZ0kwTiX2Qby0r1Lid7lQsVkKS9cxbNNdePU32ckBI6lnz4xLoKQfR1zOC7zS4hBiwhzae6oIFmdRvj21/ugCZmniGdu7gDrvaodkpAGFpuuI1k5MkgZdJLx3u3fDBk6PW8YwRC8PgdaDw8ous4OZOG0312Z8bnc8OORvT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734598357; c=relaxed/simple;
	bh=FLnD2KLRv3Ds/S9fQ1+OF5caFRXvrvo6cmjz1gOIDKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TDr/fiTKNOmk5yxkububbLyHWAWdR7aZOmmc8I0ENnfXTpKHHnv5Z70WvoafUv7aEqEodX6dpzhGcr7984Ur52ORnGwR2eDXvkC+K+HrdeQ/WHpmE79EfKl8d/gv0riiK47C162hyJzyY1krEZzj9Hc2h5yxp7U6bnI6A1Aj2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=geekplace.eu; arc=none smtp.client-ip=5.45.100.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geekplace.eu
Received: from neo-pc.sch (unknown [IPv6:2001:4090:a246:82ee:34fb:50ff:feac:591b])
	by zulu.geekplace.eu (Postfix) with ESMTPA id B52974A00C5;
	Thu, 19 Dec 2024 09:42:51 +0100 (CET)
From: Florian Schmaus <flo@geekplace.eu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Florian Schmaus <flo@geekplace.eu>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Fix rate description, it is per second, not nanosecond
Date: Thu, 19 Dec 2024 09:42:45 +0100
Message-ID: <20241219084246.220185-1-flo@geekplace.eu>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This was fixed in bcache (not bcachefs) with commit e41166c5c44e
("bcache: writeback rate shouldn't artifically clamp"), but the
change did not make it into bcachefs.

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 fs/bcachefs/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index fb02c1c36004..dc6ed422a027 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -232,7 +232,7 @@ struct bch_ratelimit {
 	u64			next;
 
 	/*
-	 * Rate at which we want to do work, in units per nanosecond
+	 * Rate at which we want to do work, in units per second
 	 * The units here correspond to the units passed to
 	 * bch2_ratelimit_increment()
 	 */
-- 
2.45.2

