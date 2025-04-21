Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A041E51FF
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745256376; cv=none; b=Eo9IkIL5i9ONfVi+quVaHPMm9MzPQYqjR3kix2HsXxVLmg5zGIWr0kCS+/jraJG7GQGfjdatjxmopN35iXTYbIKntVg/mgK9m7U4J3br2g3eY4cRQmUUX0tEJ9l8zO1D2aZhb6xe3ysGjnX22ks2l2KiX5vkUXsNYEmKOihiI9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745256376; c=relaxed/simple;
	bh=SGUtdpUB5zya2blGv4NqprNYZmGeLCSRfOpXJtN9cr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqquDyy17hUCcYiKZtq/1Yy+mm+44G0RnlXqcxanQjhRAj/zNkGt1/xqSA/vllnkd5CdB4slaGMv6FZ/ydVK/Geb/lxbnE76GBcln6rlUO+HLqxsKFhEm5sV1dxMEGLdJnmyG8BZ3+LtLWfAEsm5FtW2U5qM9q0F5/PLa8Yuvuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SqS4XUyw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SqS4XUyw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745256372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2z6GqvQ7LBQ4lswrWGTx5kZubJK43WWtx1HzRGt0bE=;
	b=SqS4XUyw7TtX1hmnJDcX7NAYnj3eljc7BYajrUGmGs80793I/JDzEKwz58Zk9OooDH57l5
	TwgnDFBtfG/A/bMamlDUKDlOJxic5jJnMAH/9vA+TEq4hV6iqgVhe3z0yAiEJZeYsfww7f
	NnuPFVt1H4oXzpT+ukJ+SlT/91JZuao=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: bch2_bio_to_text()
Date: Mon, 21 Apr 2025 13:26:01 -0400
Message-ID: <20250421172607.1781982-2-kent.overstreet@linux.dev>
In-Reply-To: <20250421172607.1781982-1-kent.overstreet@linux.dev>
References: <20250421172607.1781982-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Pretty printer for struct bio, to be used for async object debugging.

This is pretty minimal, we'll add more to it as we discover what we
need.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/util.c | 10 ++++++++++
 fs/bcachefs/util.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 6e5d7fc265bd..7e6ebe8cd9ea 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -715,6 +715,16 @@ void bch2_corrupt_bio(struct bio *bio)
 }
 #endif
 
+void bch2_bio_to_text(struct printbuf *out, struct bio *bio)
+{
+	prt_printf(out, "bi_remaining:\t%u\n",
+		   atomic_read(&bio->__bi_remaining));
+	prt_printf(out, "bi_end_io:\t%ps\n",
+		   bio->bi_end_io);
+	prt_printf(out, "bi_status:\t%u\n",
+		   bio->bi_status);
+}
+
 #if 0
 void eytzinger1_test(void)
 {
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 50f7197c67fc..7a93e187a49a 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -419,6 +419,8 @@ static inline void bch2_maybe_corrupt_bio(struct bio *bio, unsigned ratio)
 #define bch2_maybe_corrupt_bio(...)	do {} while (0)
 #endif
 
+void bch2_bio_to_text(struct printbuf *, struct bio *);
+
 static inline void memcpy_u64s_small(void *dst, const void *src,
 				     unsigned u64s)
 {
-- 
2.49.0

