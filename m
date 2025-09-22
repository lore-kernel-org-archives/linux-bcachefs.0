Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60B82FD1DA
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Sep 2025 08:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758528791; cv=none; b=BuUjCR1ZS7OCh53XH5kZ/Empq43zy1SNjdApCpa6AWqBPIdnlohDbZsuNeRrf3DpjTof/+qRrpPGJaoWxejT+kSdqH5uyrBUe9Cqy6YQDxK1dvzXeuhpIpJ1Fqt8U3YzCgzaUOUqhEWGIpTWHWgmwLfCywqGd6YPr+CTO6S/An0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758528791; c=relaxed/simple;
	bh=03intFBuR12n5Xre+XE44wZlrnRELjVcZ4XDVUx8RH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EQqIAx2pn0uhLaDT4gJUbodRjmCmUBMluHUUeXaSd5zAo6X6MRWJSbk5BOFEHsYLiW0H6Tx7lhkqgP+Ce9NFlli4V+1rjW5/k9Dnjnpyp9/5QfRnaNvOrW9hTWsVu4OMCLqEp34W7+Jv5OcT0Ufl06AvihU5U8n21/0BDGdMb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qGU2GMH7; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qGU2GMH7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758528775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zANDTeVI0tZPCMAhDyTdeSxz2VUrPHZhrCLKm1twdBY=;
	b=qGU2GMH7FB0mtYF0za+9l/X4OXqCrWNnwOBeXTriqDPIevQJOiKEiYIg/jPTMVckGid/VZ
	IjABKbvFELgsPxLFceBE0FJQGmsV59ZFOHrxxf2H3auZzg3ZUGIh9hjpr4zOxAWK/EVXxK
	I1xyAuFOsPwRInI2tqaS4ZymYII57u0=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: return -EMLINK instead of -EINVAL when hard link count exceeds limit
Date: Mon, 22 Sep 2025 16:11:36 +0800
Message-ID: <20250922081136.160829-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Currently bcachefs returns -EINVAL when the hard link count reaches
U32_MAX. However, -EINVAL is a generic invalid argument error that
doesn't accurately convey the specific "too many links" condition.

This patch changes the error return code from -EINVAL to -EMLINK
when the hard link count limit is exceeded, providing more precise
error information to userspace and making it consistent with other
filesystems' behavior.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/errcode.h | 1 +
 fs/bcachefs/inode.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index acc3b7b67704..b22a694ec750 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -215,6 +215,7 @@
 	x(EINVAL,			varint_decode_error)			\
 	x(EINVAL,			erasure_coding_found_btree_node)	\
 	x(EINVAL,			option_negative)			\
+	x(EMLINK,			too_many_links)				\
 	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
 	x(EROFS,			erofs_trans_commit)			\
 	x(EROFS,			erofs_no_writes)			\
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index ef4cc7395b86..5765144b4d65 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1193,7 +1193,7 @@ int bch2_inode_nlink_inc(struct bch_inode_unpacked *bi)
 		bi->bi_flags &= ~BCH_INODE_unlinked;
 	else {
 		if (bi->bi_nlink == U32_MAX)
-			return -EINVAL;
+			return -BCH_ERR_too_many_links;
 
 		bi->bi_nlink++;
 	}
-- 
2.43.0

