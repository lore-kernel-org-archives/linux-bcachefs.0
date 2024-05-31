Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11EE78C88
	for <linux-bcachefs@vger.kernel.org>; Fri, 31 May 2024 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717122699; cv=none; b=Ef0MtNDepJEp7Ce4dP9awoLXaj2yDp1PHdf18qs6sgJK9fk2LMIZjgv7bV4ITkNPPVFG+DpkizXNMXdX9xdKYIZMv3WrVTUU2Whfs2qhsT7ULNpx204TOezNw8H1RrL0zt9e2p8/sLnSxnuOB8n+1xhe/XwtYMCVnFlc8I1OCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717122699; c=relaxed/simple;
	bh=00ju4f/3GHc0EOMMkg7vmxo/6msUeyLgsUBjUiefSlU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZJNAfuAgx/FvvvkSGoZSpQks5lZGChkHI1dEBScri+Tb70T8up/aYTL8ocog5jjYr4Sw8Qk+k/fT8UKFRTcfvEwauTzrmkveflK2o9WY5+GomPMKlBWvmEdxLs/E6ZHoarwUaw69P3IHTSMRyvNbYH7qc9SeflL66HDul01QJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BuCbUCZy; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BuCbUCZy"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717122694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9DtHHW/1JNGGMpmrvNWctFteiGBA2L9suuHhbLIp850=;
	b=BuCbUCZyu9TzxKDUftypGJ8NhpNeLrZOuCiT9fscxqrfJexOohJvvm9Z1q/j8F2wed4uzx
	CKfIHVpoyCAcaKz1v4Kdv6AnwlMroeEuZcv9iYI5pxXN8dMfEhsK2/LbWgagFdo5VV2OhG
	Xft1e0+8HmmWqrCM96Bw11msIKz2SEE=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: track writeback errors using the generic tracking infrastructure
Date: Fri, 31 May 2024 10:31:15 +0800
Message-Id: <20240531023115.11940-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

We already using mapping_set_error() in bch2_writepage_io_done(), so all
we need to do is to use file_check_and_advance_wb_err() when handling
fsync() requests in bch2_fsync().

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index ef20b64033e0..f5b266e51261 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -192,7 +192,7 @@ int bch2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	int ret;
+	int ret, err;
 
 	ret = file_write_and_wait_range(file, start, end);
 	if (ret)
@@ -205,6 +205,11 @@ int bch2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	ret = bch2_err_class(ret);
 	if (ret == -EROFS)
 		ret = -EIO;
+
+	err = file_check_and_advance_wb_err(file);
+	if (!ret)
+		ret = err;
+
 	return ret;
 }
 
-- 
2.34.1

