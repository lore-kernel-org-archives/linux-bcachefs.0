Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89527262818
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724137; cv=none; b=IjWavNBqwaaysJVJLgQIYek+kZcRILbvESja+XIzwiyihpIkXKa2yFTxT1zI+oo9mEkN+evcbyOzCis2N12AAqQfE/DJIsPkxtfkTPr9hVcKEFT2iOQlkNDnVArxsD7INNwMDEZEDMdawVRg2hyVCkJAAYk1/uWxWOtsR1cXKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724137; c=relaxed/simple;
	bh=3OGNxqMM+tZbIqvtcXXkzLi+/DW8DtdBwt3dMb2lFbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pN0iq2HyCjBaJGCEpeabYUF+oP7UGO01E3RJlrod5lSmowZRvEGKPtn3JpFm+deKyE4uFUj9t40bEkWazG2kQ3CzKyse97JwmtcgIh1vsRdhtu/eVGrh3acIU4BuczMKM5MoI6EI9fa9PLS5LrkNgD5qnWW+CLIAaqGmMqiNkfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N51E74O0; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N51E74O0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t40Wrsq/OsdCcZyryHHOz2sqtUKv6VgWW8czUUHIAuU=;
	b=N51E74O0GGbC56fleog+mLB3iAqsx4AtR7B1c7UAhr0ibCzmnNEJ2SZyhWw4/MknZxy7UD
	maQf33QZ/GATh9KqCYu5sMrv9nsA1xLZoDQCJdqLkyghXgl92hYyTw+3xV7+G0fRmSokde
	T8IMjkvl9PtBASQJzJvTs3V5Umw8oJI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/14] bcachefs: Don't create bch_io_failures unless it's needed
Date: Tue, 11 Mar 2025 16:15:09 -0400
Message-ID: <20250311201518.3573009-8-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Only needed in retry path, no point in wasting stack space.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index 6e5ea5b45a54..42a22985d789 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -146,13 +146,11 @@ int __bch2_read(struct bch_fs *, struct bch_read_bio *, struct bvec_iter,
 static inline void bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 			     subvol_inum inum)
 {
-	struct bch_io_failures failed = { .nr = 0 };
-
 	BUG_ON(rbio->_state);
 
 	rbio->subvol = inum.subvol;
 
-	__bch2_read(c, rbio, rbio->bio.bi_iter, inum, &failed,
+	__bch2_read(c, rbio, rbio->bio.bi_iter, inum, NULL,
 		    BCH_READ_retry_if_stale|
 		    BCH_READ_may_promote|
 		    BCH_READ_user_mapped);
-- 
2.47.2

