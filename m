Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111E1957F3;
	Fri, 14 Jun 2024 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718362243; cv=none; b=SE8L2w473O0bHwc38sb/V8AtwBd7gnr6HrOlCvrfgQuU+874cJz6D68VYCQVZ7FocQKCEOUmcg2j9PdzZk/F1I+sdTK18/6T2WgdbWimtlfdmP1QmEHsIBr6IY903fZanYJAHN/VgWyhmZqaijJZ06vL8m5fSArPHlL/zXORnbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718362243; c=relaxed/simple;
	bh=RvT456eSgnYsXlxc1lkKdAdRmMkX5mVmeOV8t6IuOwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx5EhteC7GkVtb6Wpyfwm+s4JLygd4J2QISg/Jdj2lu3WDWDmmFLU3ap8RGnm6Dx1xB86KEBQKzDzRcqFPioqEx/J+AcNyQZkrgjZY3zptOJygCUlIxhnjtxJUP56tih4O1LGGfKv8LFZ37RBKLbFgh002kghEv3jM5H2u2pMTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=Q5m1RtaN; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="Q5m1RtaN"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4W0wzd0hGQz9smv;
	Fri, 14 Jun 2024 12:50:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718362237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CrPG7rd88hoRsGFAKAqpUnCfo3BYaLv2EBMdGcByx7Q=;
	b=Q5m1RtaNRYG6C6VXOYfenCnmOjYk5x1yb12ZuGbpAeAZ8Rhui+dg9+0Yr1Vgm+SgpdoAU1
	bc+WRZkN4/iEGSA7QPwIoxLd4VZuqwJiiowXy9l6/ue7d+jTdNa7Pu9ESNln4UVw6wASp+
	QieShjvS2zhUL11VEDk+FDIJy43SM4HONoQAhG/UXyToM4NhC1lXhL7RTkA3YOxkdxBDmH
	nIBZPcF0X17uqCaDPbVZb1wSl86Y2iuzK1pLPlNg7i7xo9dF7La2kNC0IUStSBbKYuUxRf
	5huoS3H8vkVSdAPASp+LNvVs/CE7oUGtLV8/+0sn0LCo6icl3g2UtAdBnmG83Q==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 2/2] bcachefs: set fgf order hint before starting a buffered write
Date: Fri, 14 Jun 2024 10:50:31 +0000
Message-ID: <20240614105031.57032-3-kernel@pankajraghav.com>
In-Reply-To: <20240614105031.57032-1-kernel@pankajraghav.com>
References: <20240614105031.57032-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4W0wzd0hGQz9smv

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
 fs/bcachefs/fs-io-buffered.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 865691dd0173..1355d618f988 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -677,7 +677,8 @@ int bch2_write_begin(struct file *file, struct address_space *mapping,
 
 	bch2_pagecache_add_get(inode);
 
-	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_WRITEBEGIN,
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
+				    FGP_WRITEBEGIN | fgf_set_order(len),
 				    mapping_gfp_mask(mapping));
 	if (IS_ERR_OR_NULL(folio))
 		goto err_unlock;
@@ -819,7 +820,7 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	darray_init(&fs);
 
 	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
-					       FGP_WRITEBEGIN,
+					       FGP_WRITEBEGIN | fgf_set_order(len),
 					       mapping_gfp_mask(mapping), &fs);
 	if (ret)
 		goto out;
-- 
2.44.1

