Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A1C17C7C
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146477; cv=none; b=Z4Ddq80a/us+qDWzkbc9K7pwtySNJwlcThyyvty3L+XJ15CwlXLa+dnk/V7B2XkKQy9uZmvhTdO7ooXPOqnM3/1lJG1URJXnvQXW98qlmKSxZuTsacp8pumIJu13E30XDfkpd0V/Ov21x5Zz/vS6yHpmTQWIrwl1t2gP4kPsTy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146477; c=relaxed/simple;
	bh=QG8A+aj8+qiVIJXQDatc0psJO1nQixSoI1HYpErTnGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s0BR1aidxADISwbLXQ+Cl9wAiRtARraspDZI1CX99xcIADi3w70ZFvUfRSGiVSkbozqHRMnZ3R+s76NIdSgOtr/dgj5BjFAN6zkl+I3xariYwJR/47DatcZwdlARko1nGUO6+zs5yb9XJGya7vq3VSzz5x8vIN/xHb8xZzo+zzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DmDceVBf; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DmDceVBf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727146473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hX0ICgYkWPwpFSHu/i9gdiyiwv3g0dDgwMMYMEyidkA=;
	b=DmDceVBfX9SESHXUBGftAb6BfR7yv9cs8yq4nTTEo8pRejjAUPLHr0mxPDXJKjUvV+3+zH
	5LcVwOd7jL3bTo/xBnlMTAdoB4wooRfB9MAJQw19TiF0HVXVHdiZCGw7qKsfsM3gU8TG4V
	kU//CcZJa45piq2Q/CiFKrrQrsh1z5E=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Removes NULL pointer checks for __filemap_get_folio return values
Date: Tue, 24 Sep 2024 10:53:50 +0800
Message-Id: <20240924025350.3948674-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

__filemap_get_folio the return value cannot be NULL, so unnecessary checks
are removed.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io-buffered.c  | 2 +-
 fs/bcachefs/fs-io-pagecache.c | 2 +-
 fs/bcachefs/fs-io.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 48a1ab9a649b..9742aae87017 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -669,7 +669,7 @@ int bch2_write_begin(struct file *file, struct address_space *mapping,
 	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT,
 				    FGP_WRITEBEGIN | fgf_set_order(len),
 				    mapping_gfp_mask(mapping));
-	if (IS_ERR_OR_NULL(folio))
+	if (IS_ERR(folio))
 		goto err_unlock;
 
 	offset = pos - folio_pos(folio);
diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index af3a24546aa3..972092906100 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -29,7 +29,7 @@ int bch2_filemap_get_contig_folios_d(struct address_space *mapping,
 			break;
 
 		f = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, fgp_flags, gfp);
-		if (IS_ERR_OR_NULL(f))
+		if (IS_ERR(f))
 			break;
 
 		BUG_ON(fs->nr && folio_pos(f) != pos);
diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 71d0fa387509..5025e70ab6b2 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -256,7 +256,7 @@ static int __bch2_truncate_folio(struct bch_inode_info *inode,
 
 		folio = __filemap_get_folio(mapping, index,
 					    FGP_LOCK|FGP_CREAT, GFP_KERNEL);
-		if (IS_ERR_OR_NULL(folio)) {
+		if (IS_ERR(folio)) {
 			ret = -ENOMEM;
 			goto out;
 		}
-- 
2.34.1

