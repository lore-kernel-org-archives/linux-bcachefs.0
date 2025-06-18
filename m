Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF8821CFEF
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283707; cv=none; b=V0y1y3dytNKNJsI5YnqIM+tAfjIa6gUiXFrcOQeaXXwYeLIJ3fBDUA2qDc0BJyKyd+1aOTnqX5qQ4jBPjDZXgp1vA/iJU9xG6aRgqUWNLrTi5Ob6ETAt8Bcv2BhzLiSmob9XgkUHcjw1SqbqG2YwLo70ZIpIcPpkPLTcw9HyxZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283707; c=relaxed/simple;
	bh=ZtGQ68sZ8/vO15YMOh95cHWu9A8fO30qtTNaC/quyPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt16m2IHIqRRU1q1I5tzk/zM6+oj+zL4fudOBzuZpJUjXVsnEId+Rfy0ZfnYuhezGOVZb5j6Hj4MTXqxPz/zEPCofoB/9CLOSYDfaOfV+9FH4O8hkoOCsX7I72yUG2TuAv0cfgp9HXZGbvua72BLoQxpRQ2vP35ashwU9Lf4pDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aIytNsZE; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aIytNsZE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k51shgWI6apcPtCWOgP8yMIftRbpigZSljrIarkrkPE=;
	b=aIytNsZEVJeun0YpF6zFYBz5oR9z+uye+Z/KSNR9QYAP1i8IZVoDJuQOGcFV774Z62/UZc
	3zFMSfsYIR++pPlj9lfPWU15nDj8Hjo8ERQ5c2DyVmpUarAb0dnHT/0cFFG1x+bYdwUnew
	/dtzmVewnwi64o3+6i7z3l8S02WtNyo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 23/37] bcachefs: Fix __bch2_inum_to_path() when crossing subvol boundaries
Date: Wed, 18 Jun 2025 17:54:14 -0400
Message-ID: <20250618215431.738317-24-kent.overstreet@linux.dev>
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

The bch2_subvolume_get_snapshot() call needs to happen before the dirent
lookup - the dirent is in the parent subvolume.

Also, check for loops.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/namei.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index 779c22eb3979..7d1068aa998f 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -625,14 +625,26 @@ static int __bch2_inum_to_path(struct btree_trans *trans,
 {
 	unsigned orig_pos = path->pos;
 	int ret = 0;
+	DARRAY(subvol_inum) inums = {};
+
+	if (!snapshot) {
+		ret = bch2_subvolume_get_snapshot(trans, subvol, &snapshot);
+		if (ret)
+			goto disconnected;
+	}
 
 	while (true) {
-		if (!snapshot) {
-			ret = bch2_subvolume_get_snapshot(trans, subvol, &snapshot);
-			if (ret)
-				goto disconnected;
+		subvol_inum n = (subvol_inum) { subvol ?: snapshot, inum };
+
+		if (darray_find_p(inums, i, i->subvol == n.subvol && i->inum == n.inum)) {
+			prt_str_reversed(path, "(loop)");
+			break;
 		}
 
+		ret = darray_push(&inums, n);
+		if (ret)
+			goto err;
+
 		struct bch_inode_unpacked inode;
 		ret = bch2_inode_find_by_inum_snapshot(trans, inum, snapshot, &inode, 0);
 		if (ret)
@@ -650,7 +662,9 @@ static int __bch2_inum_to_path(struct btree_trans *trans,
 		inum = inode.bi_dir;
 		if (inode.bi_parent_subvol) {
 			subvol = inode.bi_parent_subvol;
-			snapshot = 0;
+			ret = bch2_subvolume_get_snapshot(trans, inode.bi_parent_subvol, &snapshot);
+			if (ret)
+				goto disconnected;
 		}
 
 		struct btree_iter d_iter;
@@ -662,6 +676,7 @@ static int __bch2_inum_to_path(struct btree_trans *trans,
 			goto disconnected;
 
 		struct qstr dirent_name = bch2_dirent_get_name(d);
+
 		prt_bytes_reversed(path, dirent_name.name, dirent_name.len);
 
 		prt_char(path, '/');
@@ -677,8 +692,10 @@ static int __bch2_inum_to_path(struct btree_trans *trans,
 		goto err;
 
 	reverse_bytes(path->buf + orig_pos, path->pos - orig_pos);
+	darray_exit(&inums);
 	return 0;
 err:
+	darray_exit(&inums);
 	return ret;
 disconnected:
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-- 
2.50.0

