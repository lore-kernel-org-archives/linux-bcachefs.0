Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC5533E7
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506269; cv=none; b=r5Ir6ZVAw+OyH7On76sZh8nheolZcooQ5dy8j785G4mKw5iIP8ls3W3mCt1aRJwq/oAvzDYaXU+aFW/PwO6aTI6hr5AfPVJc8jeXZOWLjZVeqIwucoyODDNJHUIplt5PGHgef3xwxWStbKeobUIPCN3Hp8yonEMPG8DzOLTUj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506269; c=relaxed/simple;
	bh=/mlBClSJMxl08JyuwwJuNSq26hl6SLgzMC++qKlZEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jS1hX302rGwfM4Xrcbi1lLbZwSvwiwQAJKxksyhzBy2IlDiOZ/R6kKeI9Q+XmIwPZh0xzgl1f96+G0VOAcNsa/dxuZbUEb5FaWlIJvAJ+kJxqHhNier/DaNn1OtlF923pPup/sQfIh0zVnxrLbnobYCTXvGidUJ5pogsXrdL2W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jb7446Cf; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jb7446Cf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jm+8N1TukMdxO4ukZzlIBN/JaywhPmbPO4Dit52BfX4=;
	b=jb7446CfhalbaRITrACdrDBnDnHk+kqZ84TkjB8UKZjiJ/cs2F55QgRHNg5YIoxHx2DTIK
	VPoQcjTgpF3yjJS66Rc7pyL9nCtKTUocrOgcFYH/JpLTzJNUYh+rIx0f2dT0qTKMJ6mAQS
	qhFXzlA0X+0XpoG+qBQ+3ofk9U2D/2M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Count BCH_DATA_parity backpointers correctly
Date: Thu, 20 Mar 2025 17:30:55 -0400
Message-ID: <20250320213056.3359690-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

These are counted as stripe data in the corresponding alloc keys.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index c9dfc3657696..8da1b68821a0 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -50,6 +50,8 @@ void bch2_backpointer_to_text(struct printbuf *out, struct bch_fs *c, struct bke
 	}
 
 	bch2_btree_id_level_to_text(out, bp.v->btree_id, bp.v->level);
+	prt_str(out, " data_type=");
+	bch2_prt_data_type(out, bp.v->data_type);
 	prt_printf(out, " suboffset=%u len=%u gen=%u pos=",
 		   (u32) bp.k->p.offset & ~(~0U << MAX_EXTENT_COMPRESS_RATIO_SHIFT),
 		   bp.v->bucket_len,
@@ -791,6 +793,7 @@ static enum alloc_sector_counter data_type_to_alloc_counter(enum bch_data_type t
 	case BCH_DATA_cached:
 		return ALLOC_cached;
 	case BCH_DATA_stripe:
+	case BCH_DATA_parity:
 		return ALLOC_stripe;
 	default:
 		BUG();
-- 
2.49.0

