Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAF521CA0D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283709; cv=none; b=ZLZYB76BxnYblQztxxCuAPcpZ0eA21VmKuY3/yYBsZKMuYBW1WjK2TSj0SVNl+tjJrGLhnGOz6atkjKqKjhv05m23c++2EEivMrMqKi0H9yEpPCQV40hbXGq8IbI9GoqpSFDD+TADpDCmAc9mkJPXvRDMZEwISTskbP/WFM0oO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283709; c=relaxed/simple;
	bh=o9ZQuJNEuLYNuX7+hH9L5cmzWvB2+orvHno1dYz2Dvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf82PoBU5DWkW/zOC8+VTYlL/jeQsAZI58FVSfkirDsGRsOR1dPLexTKQCef66f6NktYDNqWFxZhrB6gnLm44Z7VHUenf2zz0lOvFwU0AkSjKj1M+keaigEUoQL/9IuIgx5ubDTi1CEmbAoe20iETI+SZGf6LZkOXsURyULn0hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m0Usav9N; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m0Usav9N"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baphCO/Q+e+224K+g14KP93VgB8nPWABEt33txBmuHk=;
	b=m0Usav9Npj+CMkGmQ5W9rC62BmfBGJ92TnI5tY+JudL2neBxduFb33RVQcPYQ9iyswSxnU
	DevJ/jilFkGYywSbxmZhWtP3Dtivh0cwacubJwGxQ9rL86lrJJ1A4yI6lIIMo1vqCT/LzV
	Jn4MNrxsXhtZkbBjX5ImqZCLFCWpyp4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 27/37] bcachefs: fsck: check_directory_structure runs in reverse order
Date: Wed, 18 Jun 2025 17:54:18 -0400
Message-ID: <20250618215431.738317-28-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When we find a directory connectivity problem, we should do the repair
in the oldest snapshot that has the issue - so that we don't end up
duplicating work or making a real mess of things.

Oldest snapshot IDs have the highest integer value, so - just walk
inodes in reverse order.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 6e64af4ccc36..7414a16af990 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2841,7 +2841,7 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 int bch2_check_directory_structure(struct bch_fs *c)
 {
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_commit(trans, iter, BTREE_ID_inodes, POS_MIN,
+		for_each_btree_key_reverse_commit(trans, iter, BTREE_ID_inodes, POS_MIN,
 					  BTREE_ITER_intent|
 					  BTREE_ITER_prefetch|
 					  BTREE_ITER_all_snapshots, k,
-- 
2.50.0

