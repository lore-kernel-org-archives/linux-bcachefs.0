Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A431957E4;
	Fri, 14 Jun 2024 10:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718362241; cv=none; b=jbapkq8+tMNiU4qPCodHwBhpIZjWLKefvYdT6i3/pyiM5EhxHg4KuHwrT8hMH6srmBH3D+YLmNTQbsGaF4PbCx/TifP/sACXRdm/ad9ipAXGlZhtKi6AYaVmWIvit99rkX+S9txQvzZNzJ965kwvpyC1NLQltB7tD+xS/pT2NJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718362241; c=relaxed/simple;
	bh=6pfJoYioiO6yA1+m6X4mMuZKZchxbko/MzEz7P3kvic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHpS3rgDAHIuUues/ABXDt31FiSJoXRV1Hb4g4hEXLIWMAyN6KEVGam76zuwhIGjJCWHU1QlgkTSA+6yyAm7YLi3GXB+KR4/+wfBN8/u8215ajbqxM6y1bliatJ1Zyy3gDD+M/AyVopmpbCnKHr0hUX+1/S/YeQHFHaNMLw85AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=fcuZWeS0; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="fcuZWeS0"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4W0wzb2c3Hz9tWv;
	Fri, 14 Jun 2024 12:50:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718362235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h9XKge9NpIpH1b33RjGZCWwlvvg3NKJI45iOzjHUY7w=;
	b=fcuZWeS03H+xn4nyFh2EdSFXGZj3IwNSTmI/lrAcWiXWtYElNMSFGl5YiyVNDgpWoC8aVL
	UfPUK46C5Pdp6EsuE4NbWTnFaNggiHtVS3lkCPZaI/6aHFXziTi/0bffdjBdYayyccAS0s
	haMMgf5jO1eO3W/MkwyUb9i3rorWhktujASBpoehLFZvWAAIlDBgyJ8lLhMDo/IZCiIEZx
	19EniWiQtk4i/f2RBh+1HR5s2kb94qrOrdWWQKGHuu7Klcl0rUgEuHmj6BkXrNfhw0TgrX
	Nk9lhKQXKHxrUldkR6ZxhhCAfDrp7fDCu4l49F7fGXYTxy/IaX31qqOh5/YxYA==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 1/2] bcachefs: use FGP_WRITEBEGIN instead of combining individual flags
Date: Fri, 14 Jun 2024 10:50:30 +0000
Message-ID: <20240614105031.57032-2-kernel@pankajraghav.com>
In-Reply-To: <20240614105031.57032-1-kernel@pankajraghav.com>
References: <20240614105031.57032-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pankaj Raghav <p.raghav@samsung.com>

Use FGP_WRITEBEGIN to avoid repeating the individual FGP flags before
starting a buffered write.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/bcachefs/fs-io-buffered.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 54873ecc635c..865691dd0173 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -677,9 +677,8 @@ int bch2_write_begin(struct file *file, struct address_space *mapping,
 
 	bch2_pagecache_add_get(inode);
 
-	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
-				FGP_LOCK|FGP_WRITE|FGP_CREAT|FGP_STABLE,
-				mapping_gfp_mask(mapping));
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_WRITEBEGIN,
+				    mapping_gfp_mask(mapping));
 	if (IS_ERR_OR_NULL(folio))
 		goto err_unlock;
 
@@ -820,9 +819,8 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	darray_init(&fs);
 
 	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
-				   FGP_LOCK|FGP_WRITE|FGP_STABLE|FGP_CREAT,
-				   mapping_gfp_mask(mapping),
-				   &fs);
+					       FGP_WRITEBEGIN,
+					       mapping_gfp_mask(mapping), &fs);
 	if (ret)
 		goto out;
 
-- 
2.44.1

