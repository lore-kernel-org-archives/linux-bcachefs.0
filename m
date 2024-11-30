Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81033B796
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930112; cv=none; b=PuBqRxfjCZW+antqYepFvHyiG4wH/i0rxaSIWZpaDfcZvClbt+BgqEnVTAtIvAdiFfvnwbxg+3Px97zWFv00+3JwDExwzX2LTYvGEoLzpq67zvordHSObEs0Mlch7spxknR5PJJJyfo4IbwwKVF+XSsEcoqo4SMElwMgeJMy5jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930112; c=relaxed/simple;
	bh=Tpbw1ce2O7nKs9/6fw8Iky68DriSImfi8g60OJQWGKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/XphPVisAagxZP/XalsD2/dL5/myDOfml8xJ0coffHOmpkQx6GmRTpyg6bxvvZrXTN9guHQc0dyg64mlwyRiB7oo1xhtazdc7XtUgIVlomOWonq2yEce5ip7X6EIf6nuaaLXEgM1f+LoKJQgvuwC1kkq9B+6gZxWGyFgyqgHNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sBlncAdV; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sBlncAdV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6sNYQRcjCGpUXGsLq0CfhXPG6bKdcCMa4K+lZBpZ6o=;
	b=sBlncAdVbMcne4duz51UVR1QIV6+Ngt7JBhFXlUjGV9o+qujBHjzILqFfh60D8xJuJEJMM
	npbdI18meyhIfSWkMLp/Ua4Ig/O16iz59CM2Q/jgPV6240+y2AuyG90CfpzgQ9X3kIEi51
	Ef47sWrgMuhWjlPnwaBUHkRb/HUgw8U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] bcachefs: bkey_fsck_err now respects errors_silent
Date: Fri, 29 Nov 2024 20:28:08 -0500
Message-ID: <20241130012812.3135521-3-kent.overstreet@linux.dev>
In-Reply-To: <20241130012812.3135521-1-kent.overstreet@linux.dev>
References: <20241130012812.3135521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/error.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index abaa9570cd62..9e34374960f3 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -476,11 +476,16 @@ int __bch2_bkey_fsck_err(struct bch_fs *c,
 		return -BCH_ERR_fsck_delete_bkey;
 
 	unsigned fsck_flags = 0;
-	if (!(from.flags & (BCH_VALIDATE_write|BCH_VALIDATE_commit)))
+	if (!(from.flags & (BCH_VALIDATE_write|BCH_VALIDATE_commit))) {
+		if (test_bit(err, c->sb.errors_silent))
+			return -BCH_ERR_fsck_delete_bkey;
+
 		fsck_flags |= FSCK_AUTOFIX|FSCK_CAN_FIX;
+	}
+	if (!WARN_ON(err >= ARRAY_SIZE(fsck_flags_extra)))
+		fsck_flags |= fsck_flags_extra[err];
 
 	struct printbuf buf = PRINTBUF;
-	va_list args;
 
 	prt_printf(&buf, "invalid bkey in %s btree=",
 		   bch2_bkey_validate_contexts[from.from]);
@@ -489,9 +494,12 @@ int __bch2_bkey_fsck_err(struct bch_fs *c,
 
 	bch2_bkey_val_to_text(&buf, c, k);
 	prt_str(&buf, "\n  ");
+
+	va_list args;
 	va_start(args, fmt);
 	prt_vprintf(&buf, fmt, args);
 	va_end(args);
+
 	prt_str(&buf, ": delete?");
 
 	int ret = __bch2_fsck_err(c, NULL, fsck_flags, err, "%s", buf.buf);
-- 
2.45.2

