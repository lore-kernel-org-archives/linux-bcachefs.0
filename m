Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F091E2602
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Jun 2025 02:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749089226; cv=none; b=RUsBemZBvdNKBZL2lnmujhU8LoB87DcnDeAZjhYWqR/OzOp+ZlgSIFUIoo5s2GSB+b4fG8NFQ39fU9YKSICsSZ8ImfzBoVHCI4TxrKJYjqzjvw2D6wjkLMAJyo7fPSa0wuDpzsG+3S7VryZBIq9oSL82Gv7mrRHTv+l6rktjSRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749089226; c=relaxed/simple;
	bh=g/89JrcinhaKCfauoUiwx+64YKczUou7i7jRjRO/y3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R2rEguzPZUscyjLe6gAGjCvryVyX71c47LMPrq12PrMTYmIfTipDDBXgEuKJErFCb/fsW6Msg5sM0/y75qAxZjjgvYKxC3wGsM89fmlddbDBf3HTyE7fPzSfCUZOY+n+90Jm07xbI109UjOwU5BbInK9IWouaIfeHgLQq4sGwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tB6LJOsZ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tB6LJOsZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749089221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YR6p82qQa62oSNecEJ7kVe/ooitmM6WoRtJwRc9tQ54=;
	b=tB6LJOsZRcusOXt9QznE6YOxRKeXJJWySg0+I5sy/FtKW2gb6I7ZO86HICYYp8uLoEQ69z
	QoK1D5tNPBMSGQ1iwFUxEUu19z2cC0IU7n8a80VeurswQfe8D9N12E/wJLxkDc7WKN/JTr
	baQEvnkJNCX1dDXAwEOkEnR0RUuls0c=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 2/2] bcachefs: Use bio_add_folio_nofail() for unfailable operations
Date: Thu,  5 Jun 2025 10:06:39 +0800
Message-Id: <20250605020639.6868-2-youling.tang@linux.dev>
In-Reply-To: <20250605020639.6868-1-youling.tang@linux.dev>
References: <20250605020639.6868-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Use bio_add_folio_nofail() to replace the unfailable bio_add_folio()
operation.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io-buffered.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 66bacdd49f78..dad48d44f47b 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -145,7 +145,7 @@ static int readpage_bio_extend(struct btree_trans *trans,
 
 		BUG_ON(folio_sector(folio) != bio_end_sector(bio));
 
-		BUG_ON(!bio_add_folio(bio, folio, folio_size(folio), 0));
+		bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 	}
 
 	return bch2_trans_relock(trans);
@@ -311,7 +311,7 @@ void bch2_readahead(struct readahead_control *ractl)
 		readpage_iter_advance(&readpages_iter);
 
 		rbio->bio.bi_iter.bi_sector = folio_sector(folio);
-		BUG_ON(!bio_add_folio(&rbio->bio, folio, folio_size(folio), 0));
+		bio_add_folio_nofail(&rbio->bio, folio, folio_size(folio), 0);
 
 		bchfs_read(trans, rbio, inode_inum(inode),
 			   &readpages_iter);
@@ -354,7 +354,7 @@ int bch2_read_single_folio(struct folio *folio, struct address_space *mapping)
 	rbio->bio.bi_private = &done;
 	rbio->bio.bi_opf = REQ_OP_READ|REQ_SYNC;
 	rbio->bio.bi_iter.bi_sector = folio_sector(folio);
-	BUG_ON(!bio_add_folio(&rbio->bio, folio, folio_size(folio), 0));
+	bio_add_folio_nofail(&rbio->bio, folio, folio_size(folio), 0);
 
 	blk_start_plug(&plug);
 	bch2_trans_run(c, (bchfs_read(trans, rbio, inode_inum(inode), NULL), 0));
@@ -639,8 +639,8 @@ static int __bch2_writepage(struct folio *folio,
 		atomic_inc(&s->write_count);
 
 		BUG_ON(inode != w->io->inode);
-		BUG_ON(!bio_add_folio(&w->io->op.wbio.bio, folio,
-				     sectors << 9, offset << 9));
+		bio_add_folio_nofail(&w->io->op.wbio.bio, folio,
+				     sectors << 9, offset << 9);
 
 		w->io->op.res.sectors += reserved_sectors;
 		w->io->op.i_sectors_delta -= dirty_sectors;
-- 
2.34.1

