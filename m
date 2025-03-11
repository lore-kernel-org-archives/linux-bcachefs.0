Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E231DF73B
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724142; cv=none; b=lJ5qBc6KWNPouvyJ0mL9WaADljxlCJLOeG95l87cC3aQkzjwK1o3Sswf5I5XyH83hecPrwNNBAEEmkqq08+eciNO7s8O40A5mDsYj1Gh8p+XjHIDanpyB2I6K3bJ0412SOJv9Th9bGAHvWq3ch99DtCzIFXg4/wjMAMMpRQq6Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724142; c=relaxed/simple;
	bh=58LwYD+/RiTwwk5pzvBg/Kv57SPE0C/J693GHoo80sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfWpicd6Dkm/XDutdygfDmaUQiKMplTSIoss+L1epDcwk3JRTCn5fM4Tpq4+L1ZzhqsTQc9YxjAHlv4WKdvGxuYXl6gykpBPV85xcGkRdfVSjWtzqSS+1a/wegyCWZGn3acCkmUgSKtMeduupbFmcvxIqGZR3txZmPTz9OXPuUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cNP4k/lh; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cNP4k/lh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtqC6OiwTYoq5kZhKdgHJsrIpFxQrdzbcESeg41ir84=;
	b=cNP4k/lh+eSOXf6ACMhTqUvDrLIpjMwrF6A99WSti4+wEEzmRX2C+1JflK5XCFZeN1MT0q
	aX5H14LEcLcEtJ/pu6P/AJZj9e4HN7HTiU+TQEJbxk4mRwd5MnVr/+eDItFYTTZXrOQsJS
	EF+xdvDveQfJYIVjQ2u4VhbxNZrglT4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 14/14] bcachefs: Read retries are after checksum errors now REQ_FUA
Date: Tue, 11 Mar 2025 16:15:16 -0400
Message-ID: <20250311201518.3573009-15-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

REQ_FUA means "skip the drive cache", and it can be used with reads to.
If there was a checksum error, we want to retry the whole read path, not
read it from cache again.

Suggested-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 69c1422685e0..d90e32fb6893 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -1217,6 +1217,10 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	rbio->bio.bi_iter.bi_sector = pick.ptr.offset;
 	rbio->bio.bi_end_io	= bch2_read_endio;
 
+	/* XXX: also nvme read recovery level */
+	if (unlikely(failed && bch2_dev_io_failures(failed, pick.ptr.dev)))
+		rbio->bio.bi_opf |= REQ_FUA;
+
 	if (rbio->bounce)
 		trace_and_count(c, io_read_bounce, &rbio->bio);
 
-- 
2.47.2

