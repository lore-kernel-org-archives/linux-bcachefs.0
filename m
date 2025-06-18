Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D227EC6F
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283710; cv=none; b=sK3LnKrZDFHrQ37XgE7UyxOUVx1LOgzz7m+de8NgydC3Cm1OOKumTN2Cqe1hHcyHWLjQi75qEYhc+lFc8/a3t+y0LNvrPx0MFHOJSZRWr+z1WYo72Omax1d9h6e99KzlkkNUnReYpIixjmRCtb01GW+ZFUiGQ+N0TB/2jBTqAas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283710; c=relaxed/simple;
	bh=UDkFMer1ufhLQ8LwNchPvp7CEB2E4ErLwDcMwza6tq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUC+yw/fl0L1bRX85j58A2yWdIE0HkpI2KkYQyJnK/ui/sfS6W5hNW1qeYpLLJbMnjphk+gRbWe1dRZpcetr5wCJylRT3X2MurAAbj05ZLg9vfBTLFRuhSWkec0k8RY8rn6sa+zddLqDlz2wAdCkKC3KZvrk8euReLSEZ1Rnizg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E4363rN7; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E4363rN7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v508P+vti/FZRw19zFMNDMOHwpyj7CMRUdxGE/joKwk=;
	b=E4363rN7DZaGqbfjzzuKJklAu7FmU/GcR+ZPctHf5Jv638eLf8CS2z36+qvc76Uyb9mdgg
	qnNcJ6DReHGHvgEbeGt/tm0Q3fLRT8kX8UsilGHADnY5nZmGPeoiz5n07hs2zusuExoJRj
	5yjjIRG5Gs9FioVQYk05r5saxqICHbw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 29/37] bcachefs: fsck: check_subdir_count logs path
Date: Wed, 18 Jun 2025 17:54:20 -0400
Message-ID: <20250618215431.738317-30-kent.overstreet@linux.dev>
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

We can easily go from inode number -> path now, which makes for more
useful log messages.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index f2c8e904acab..96b9ea58705f 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2066,14 +2066,22 @@ static int check_subdir_count_notnested(struct btree_trans *trans, struct inode_
 				continue;
 		}
 
-		if (fsck_err_on(i->inode.bi_nlink != i->count,
-				trans, inode_dir_wrong_nlink,
-				"directory %llu:%u with wrong i_nlink: got %u, should be %llu",
-				w->last_pos.inode, i->inode.bi_snapshot, i->inode.bi_nlink, i->count)) {
-			i->inode.bi_nlink = i->count;
-			ret = bch2_fsck_write_inode(trans, &i->inode);
-			if (ret)
-				break;
+		if (i->inode.bi_nlink != i->count) {
+			CLASS(printbuf, buf)();
+
+			lockrestart_do(trans,
+				       bch2_inum_snapshot_to_path(trans, w->last_pos.inode,
+								  i->inode.bi_snapshot, NULL, &buf));
+
+			if (fsck_err_on(i->inode.bi_nlink != i->count,
+					trans, inode_dir_wrong_nlink,
+					"directory with wrong i_nlink: got %u, should be %llu\n%s",
+					i->inode.bi_nlink, i->count, buf.buf)) {
+				i->inode.bi_nlink = i->count;
+				ret = bch2_fsck_write_inode(trans, &i->inode);
+				if (ret)
+					break;
+			}
 		}
 	}
 fsck_err:
-- 
2.50.0

