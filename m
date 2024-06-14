Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000B3D52A;
	Fri, 14 Jun 2024 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382676; cv=none; b=NH4jDM1Sh7xBBrihHMDX3jzo8nPSr/hjNfoHM2oh+p2aRCN2SHEZcAaH5AudEBbp2fVPjKo2wFnjlk2BC5s+FUNnk8lAc4tYb3SCyi5lX2dhMkHDTZWWG9CT8Dmf808r6Fh320zfN7fPlXKiE870kHXNzCAQ7dPsy8tI1ZVCixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382676; c=relaxed/simple;
	bh=X+5bG+qbdISxsGeb0a+1AFG3m4p01v3F9dA4DrjjAcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyBqnluMen2AMVtqJu+83N3mbZMZDoagfsOmePHbZnbn/1/tbGnncRil3U8B8xiyuDKEDjr6cTjtcnQB5V8df0JjMmfGouJj21XrXknV1kblQlDzEYm2hWM0MzgOCwCkNHzj9nWK2X9zmmPyJj+//Sr24yu6n7Ut6Xt7YfIUCiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=DvVqtLV8; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="DvVqtLV8"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4W14Xb2GVfz9sQS;
	Fri, 14 Jun 2024 18:31:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718382671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WCUWQ8iDfccCkabKJOtC1SZ6ZnJubABbkIhO2DOFn0=;
	b=DvVqtLV84iI2FctPE0woX69p8wXyAmCs8PL2oyiP58ZE7CGp6rvrAnwWn5oYEKS9S81SRt
	8gsriGemQKw0QBlo9XWKT02DNUvD8n00oVcT4VrrgJyUZFX8Kc2zid5ufTnlaqO8v4hU+j
	u5KzVlivv3QCDqPpDm4j2ZjYB7c00zGfPz1R2s4mEDdhehnjbcFcjobomKvYfWolI7/N7L
	cGXkQ/KoAEBEmL6uuN3soPgqbzKjCGyKMPyi+zw7mgBI8L2zOGPdn0rTFYuXCoFMvMAuyR
	IyOEbJNzEjFWXRjnloL9YyXB2CMVPCWgkIInBxAGp7JiTUkE4qRmz93sdxvVgw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: gost.dev@samsung.com,
	linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	mcgrof@kernel.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 2/2] bcachefs: set fgf order hint before starting a buffered write
Date: Fri, 14 Jun 2024 16:30:58 +0000
Message-ID: <20240614163058.74882-3-kernel@pankajraghav.com>
In-Reply-To: <20240614163058.74882-1-kernel@pankajraghav.com>
References: <20240614163058.74882-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4W14Xb2GVfz9sQS

From: Pankaj Raghav <p.raghav@samsung.com>

Set the preferred folio order in the fgp_flags by calling
fgf_set_order(). Page cache will try to allocate large folio of the
preferred order whenever possible instead of allocating multiple 0 order
folios.

This improves the buffered write performance up to 1.25x with default
mount options and up to 1.57x when mounted with no_data_io option with
the following fio workload:

fio --name=bcachefs --filename=/mnt/test  --size=100G \
     --ioengine=io_uring --iodepth=16 --rw=write --bs=128k

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/bcachefs/fs-io-buffered.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 3c9a5a8edd1e..d478703d219f 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -678,7 +678,7 @@ int bch2_write_begin(struct file *file, struct address_space *mapping,
 	bch2_pagecache_add_get(inode);
 
 	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
-				FGP_WRITEBEGIN,
+				FGP_WRITEBEGIN | fgf_set_order(len),
 				mapping_gfp_mask(mapping));
 	if (IS_ERR_OR_NULL(folio))
 		goto err_unlock;
@@ -820,7 +820,7 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	darray_init(&fs);
 
 	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
-				   FGP_WRITEBEGIN,
+				   FGP_WRITEBEGIN | fgf_set_order(len),
 				   mapping_gfp_mask(mapping),
 				   &fs);
 	if (ret)
-- 
2.44.1

