Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC41A3BAD
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912079; cv=none; b=qsiXRxt4KUad2B2FYnwA8WduPnkqihEeqbrIBkwm96GC2XAZdXD9CNuXEhTzTbHXc5Ih/4Xrhu4JndviFJeQ6nw8D1D4ctr071+0axPCNAZW/w3pZSllmlRRdUbwBo3HwURC5L8HSyb4RKUuIQDsvpd94kSMpkeQfrMspVVPAyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912079; c=relaxed/simple;
	bh=lkGfRZkdPrNnjRBSs32sK1fHQQr3kc7X/vWaS7v6jRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFXx25OYjlDO4+fdp3f+wPvzwTRAIz00BgtNiqEu2ichjyS761GqNQC77Bu0tx17Dpmz3Uuu44utWdCzXJDEBWoajiJQJA3M0QDYQ9z6jYYK4tKykCB+mVn6ZqRSIm3PuqcIKUg/WsU1yeLJuPLVZGrTz422EXqCekTrejjDpPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 14/34] bcachefs: Go RW earlier, for normal rw mount
Date: Fri, 29 Nov 2024 15:27:13 -0500
Message-ID: <20241129202736.2713679-15-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, when mounting read-write after a clean shutdown, we wouldn't
go read-write until after all the recovery passes completed.

Now, go RW early in recovery, the same as any other situation we'll need
to go read-write. This fixes a bug where we discover unlinked inodes
after a clean shutdown: repair fails because we're read only.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery_passes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 1240c5c19fea..f6d3a99cb63e 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -46,7 +46,7 @@ static int bch2_set_may_go_rw(struct bch_fs *c)
 
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 
-	if (keys->nr || c->opts.fsck || !c->sb.clean || c->opts.recovery_passes)
+	if (keys->nr || !c->opts.read_only || c->opts.fsck || !c->sb.clean || c->opts.recovery_passes)
 		return bch2_fs_read_write_early(c);
 	return 0;
 }
-- 
2.45.2

