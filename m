Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5E71B95B
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 02:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728699012; cv=none; b=JI7r8V/jp29odbtDSQUPnC8j59oa3oJ8CCn/ZB6FbjFOdUhv9G8Hw1s6YM4fHIvgpr010PH3dbRwn2jp1jTQICHDF3euEE5TIjNLXF6WnUmzbVjr4sKK+RvPqtMlsGMIiglJMacYd08R25lH6EOlIG4/wH07qT8GP1j7ic4zcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728699012; c=relaxed/simple;
	bh=5EkInnmhQs9LkavqpJ4K08cC6g2TWdZ+hcm036ZBnl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LVJRtIpEEJYGh0ZNadY8dsfPlv7vk4j7NOF9LoTZkl1TM3/1a4gofRRBqY6n+AqivbNgxQFG+Zua5v0Nq6nhf+ul0N6a6J2QpaU6ii6CD+ovm0tSOcueazb1+rahYDk6z91TNQNUK/8C79jOtp7B36R2U9J8qh2DmP/C94DyMoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wByaPyrG; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wByaPyrG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728699006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NREuQuSOBmO8pku5yOlKbW1ZAlcefeqkvESxEOyWbtU=;
	b=wByaPyrGbSs0cnW0xFXWsIzjjqi/7OtP080m2j7C2GND/cPh/Wo56x4JcvBAncVXfYAbBO
	DhT/syuJ8pu865aKPudcx1A74U6pbwcxWMD6QogAIAy40OTdTkJ58yMkzWegjm1on697fo
	5e2+M7mrO/Xtc0HycS/CU3SL/AIOo8c=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix invalid shift in member_to_text()
Date: Fri, 11 Oct 2024 22:09:53 -0400
Message-ID: <20241012020953.3306834-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reported-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-members.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 02bcde3c1b02..b06ba1d0d037 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -247,7 +247,10 @@ static void member_to_text(struct printbuf *out,
 	prt_newline(out);
 
 	prt_printf(out, "Btree allocated bitmap blocksize:\t");
-	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
+	if (m.btree_bitmap_shift < 64)
+		prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
+	else
+		prt_printf(out, "(invalid shift %u)", m.btree_bitmap_shift);
 	prt_newline(out);
 
 	prt_printf(out, "Btree allocated bitmap:\t");
-- 
2.45.2

