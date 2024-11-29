Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187061A38E1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912096; cv=none; b=TlnBDQ7IktYotuvBCovJUv4hKD55xj2fOoq6Qe8ep2ETn/oxs5egNMfWMYQLjE6m/RWV9G6PPbpD2ex2GWji0WjyxzYmA4IWanyR65zmqHqfgoYj38g9o9625erN/bzv+1gu4TmC7RKgEQFotS7C1bmQMPb7nFaigX9tizLVqXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912096; c=relaxed/simple;
	bh=XRvzeBcWcMMrHklEVlbOyRez5hTKHYJ1g1ataFH8xpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEQ97IW1SvGBLlMKTchFykP60JNPd44CglUCItN3xdrDlviw9HeiZWxMiwNhSDZbkCbuyR0pvLiJIkY0COCGCMJDM7NcBLpguSYVa707XGIGF6t8oO4bTPd502r1HIVNS2Tx5JqA0pFAblzbJIAQUs5O4xLEfA+9HDGsa7l9O4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com
Subject: [PATCH 31/34] bcachefs: cryptographic MACs on superblock are not (yet?) supported
Date: Fri, 29 Nov 2024 15:27:30 -0500
Message-ID: <20241129202736.2713679-32-kent.overstreet@linux.dev>
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

We should add support for cryptographic macs on the superblock - and it
won't be hard, but it'll need an incompatible feature bit (and we have a
new incompatible feature versioning scheme coming).

For now, just add a guard to avoid a dull ptr deref in gen_poly_key().

Reported-by: syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 4c29f8215d54..6a086c1c4b14 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -677,7 +677,8 @@ static int read_one_super(struct bch_sb_handle *sb, u64 offset, struct printbuf
 	}
 
 	enum bch_csum_type csum_type = BCH_SB_CSUM_TYPE(sb->sb);
-	if (csum_type >= BCH_CSUM_NR) {
+	if (csum_type >= BCH_CSUM_NR ||
+	    bch2_csum_type_is_encryption(csum_type)) {
 		prt_printf(err, "unknown checksum type %llu", BCH_SB_CSUM_TYPE(sb->sb));
 		return -BCH_ERR_invalid_sb_csum_type;
 	}
-- 
2.45.2

