Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFE71BF58
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Jul 2025 02:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751681260; cv=none; b=E35gd9OO8ng5sHR/uEVhrE/Sx4q3GIppMN0hzuPcwVENz9LmV3Z4Wx/ZNGxrjI3+ZjigYkFRVITUtcBtV31ipyuVC3sNE65iEXVQcH+Us3yXkrS2PMpghencBCaYjh+MW+hvNqhMr1b3kJKKirsKCCnW843kqEwsNIYkog1HFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751681260; c=relaxed/simple;
	bh=WG0l2vXf4C7gYU/NPv2He4rrfyB5Oh+SIprx16W+qyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tLXHDGAAeyX3T1I469cDizODH5Z8z+Z/cQE5lUyNUs0HvbZjf9mWFrKwRnYdvFU43GaqkouOPWCWuCl6DiVRz9ArAfSrJDnjb4I0t350YYw64uZg+4/3YBvE5PNEAQFhLZxeojwGlifQ/Za9i4C3+aUZj5aO76ObAQD7WxmcLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AydaTY7/; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AydaTY7/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751681255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OjmpWIcj21P7LuBODrrCigEVya17IaLI/8xF+alupLU=;
	b=AydaTY7/7Tv9oQFj1u8s+qMz2zl3F81gZ91pSPxxBpVVmrYDRS4/UirkjB31vWH+aH8oIc
	slJp+Z7kEeo+Ae6YIcGy9YR/r5SbPPbSDR9HWQe6lFi8TV7kJvCO6ThnVEhmSvXcC0DtrF
	G/jAQj+4pAOML6Cb2GpvA2oPDKMz/yU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Poulin?= <jeromepoulin@gmail.com>
Subject: [PATCH] bcachefs: Fix infinite loop in backpointers fsck on upgrade
Date: Fri,  4 Jul 2025 22:07:30 -0400
Message-ID: <20250705020730.751334-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On upgrade from before bcachefs_metadata_version_backpointer_bucket_gen
we'll typically skip the write buffer flush, because we expect many
invalid/missing backpointers and it's faster to just repair them.

When we find backpointers that sum up to more than the bucket sector
counters, that's a special situation - we need to walk those
backpointers to kill the bad ones, and so that case needs a write buffer
flush to avoid an infinite loop.

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 77d93beb3c8f..9d0c3cb634e8 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -943,20 +943,24 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 	if (sectors[ALLOC_dirty]  != a->dirty_sectors ||
 	    sectors[ALLOC_cached] != a->cached_sectors ||
 	    sectors[ALLOC_stripe] != a->stripe_sectors) {
-		if (c->sb.version_upgrade_complete >= bcachefs_metadata_version_backpointer_bucket_gen) {
+		if (sectors[ALLOC_dirty]  > a->dirty_sectors ||
+		    sectors[ALLOC_cached] > a->cached_sectors ||
+		    sectors[ALLOC_stripe] > a->stripe_sectors) {
 			ret = bch2_backpointers_maybe_flush(trans, alloc_k, last_flushed);
 			if (ret)
 				goto err;
-		}
 
-		if (sectors[ALLOC_dirty]  > a->dirty_sectors ||
-		    sectors[ALLOC_cached] > a->cached_sectors ||
-		    sectors[ALLOC_stripe] > a->stripe_sectors) {
 			ret = check_bucket_backpointers_to_extents(trans, ca, alloc_k.k->p) ?:
 				bch_err_throw(c, transaction_restart_nested);
 			goto err;
 		}
 
+		if (c->sb.version_upgrade_complete >= bcachefs_metadata_version_backpointer_bucket_gen) {
+			ret = bch2_backpointers_maybe_flush(trans, alloc_k, last_flushed);
+			if (ret)
+				goto err;
+		}
+
 		bool empty = (sectors[ALLOC_dirty] +
 			      sectors[ALLOC_stripe] +
 			      sectors[ALLOC_cached]) == 0;
-- 
2.50.0

