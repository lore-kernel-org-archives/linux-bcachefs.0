Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FA3181CF8;
	Fri, 14 Jun 2024 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382674; cv=none; b=I9f8KXlCHInwX5IEH7radIDiPIAT+B40Ug2qp19+EFaYj+krYwWElZov0a+rJtaRwj87YQmp317Nacra2uH62UbTAiKJ+rkgREsmrfkYNgelJJhEN3nfafUKxpjHq4LZog5jovdFAdldmfiiQryzncYwdty/q+Ya9HHhFE7Hxjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382674; c=relaxed/simple;
	bh=xt5XfnvKr1HdXd1fR96PI5PySl8RFgUmzUiZ+WWEJk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1y1KveWybU6+V8JM9ElHQxEz1I/GUnnwcjDj3y3QhHpe6gG/mRSt6B95AxqtJnjjjeL86Me2VhHNn0M7plH05CWydO/kce5MAcb/LFMUDjcAV5QaFQ3ymf1KvCfuKLCAzZsBALzqgrPB3ckJwy9P43U0fbW2TU8GXd/JGhq9Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=gG3RS66l; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="gG3RS66l"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4W14XY0P0vz9sQ6;
	Fri, 14 Jun 2024 18:31:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718382669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuupP3B7G3wbWOUdFc1+5aNfDHyR1Nq4XTj2f2Nf2ww=;
	b=gG3RS66l47ZyApL9tubs4mWVuizBHCRMI07wGvVzXM1v0oBKdHCj4+cG6FJelnYfGj052n
	JywkObYhVv/vfMQeX51vohBQK0uP3TBBK8GquqjE4a8xMX1mqltgq4uUFUr40LqmqG+pNd
	DZx/cUuxp0de9uoa26b3G+ZMzohCxd6z7Rf0eED1EoVzCpf7WwMyI7n7o1hko+EMQHAF4e
	41L7MutrAcqOxIzeUwfDd1d0iP1682kdrUqSWm2VJnueB3AzwzsfUdhOvGdZmwVdG8+OZq
	5mSFl/Xm76rphlWaAfxQLhky6i3a3CRtZPYAYF/OzgZ7t5NwTpP0ji8MX6S2EQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: gost.dev@samsung.com,
	linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	mcgrof@kernel.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 1/2] bcachefs: use FGP_WRITEBEGIN instead of combining individual flags
Date: Fri, 14 Jun 2024 16:30:57 +0000
Message-ID: <20240614163058.74882-2-kernel@pankajraghav.com>
In-Reply-To: <20240614163058.74882-1-kernel@pankajraghav.com>
References: <20240614163058.74882-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4W14XY0P0vz9sQ6

From: Pankaj Raghav <p.raghav@samsung.com>

Use FGP_WRITEBEGIN to avoid repeating the individual FGP flags before
starting a buffered write.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/bcachefs/fs-io-buffered.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 54873ecc635c..3c9a5a8edd1e 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -678,7 +678,7 @@ int bch2_write_begin(struct file *file, struct address_space *mapping,
 	bch2_pagecache_add_get(inode);
 
 	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
-				FGP_LOCK|FGP_WRITE|FGP_CREAT|FGP_STABLE,
+				FGP_WRITEBEGIN,
 				mapping_gfp_mask(mapping));
 	if (IS_ERR_OR_NULL(folio))
 		goto err_unlock;
@@ -820,7 +820,7 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	darray_init(&fs);
 
 	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
-				   FGP_LOCK|FGP_WRITE|FGP_STABLE|FGP_CREAT,
+				   FGP_WRITEBEGIN,
 				   mapping_gfp_mask(mapping),
 				   &fs);
 	if (ret)
-- 
2.44.1

