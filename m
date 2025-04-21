Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49126171A1
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 17:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745256215; cv=none; b=aHjvoPJiAIge17G+JY76Y26t5ewHyIfuCX+kpSN/Oo1ix/VWazrOyz1vV6tOYBc2YykliS+gifnHHpv0uNTUs9lN8KGvaPtW/r2l7Tm65U33PaM86HT1BGfk9CYy3CubLtyHNpjII6ftVDWfoDlJxuE3p4V2zGe30BrYMayMzX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745256215; c=relaxed/simple;
	bh=SGUtdpUB5zya2blGv4NqprNYZmGeLCSRfOpXJtN9cr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/pWrdhZTvfRV6j8hyrel1WI7kIxiSIoDMtoiBgzfBemgPpB9w76b8SO8MExhwmy3XBl26lOv1efhQOTGcz42J6IV6bkVOb3/ST9r2sEByY/CkBpxiXHT0InLu0P0lLBVfHCqSh3AkRtDnQcTbM7C6fxvzjxt+QEt84E6hfGBp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=idshp4Og; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="idshp4Og"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745256210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2z6GqvQ7LBQ4lswrWGTx5kZubJK43WWtx1HzRGt0bE=;
	b=idshp4OgU7yBxz0Ky3OVob7Tqw+lPgc+nuXU1XPa3p/wcNWRvrDKWQTv9l1/k4MpjQaMKm
	po/6mjLnyWSaGN9boen2jj6N+ovdc1dWRcQE1byt+VXbF2tsA6/aO5cVl3g+wCHlazLnde
	hZ2bQ7N9IZEil21EX6aY4s6wiP2/dJ8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@gver.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: bch2_bio_to_text()
Date: Mon, 21 Apr 2025 13:23:17 -0400
Message-ID: <20250421172323.1781730-2-kent.overstreet@linux.dev>
In-Reply-To: <20250421172323.1781730-1-kent.overstreet@linux.dev>
References: <20250421172323.1781730-1-kent.overstreet@linux.dev>
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

