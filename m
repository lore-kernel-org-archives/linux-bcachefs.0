Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AC63085CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283709; cv=none; b=TvPLYsueU1N80TCvoUdO06dEDxcO6YLdwCHv5Yhm6W1FbvWtoNDXjSIbM332uwmnl8wkpa0/Jz2oknhH8qNBx7JY94TYOahg1ICmUR1FSQmtfeNEhDYHDmYuAp/32xEWwS1v3/lyHRdYeYwbqi2TapePrwGmVu8GvSZ64rQpE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283709; c=relaxed/simple;
	bh=0m6QmJmCY0tTzpzv8x44FAkEq2RGhlH53TBrioAxjL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSCcH6iWBDdguVMoBl1ltZq6n1A6VUD8gfm74ZkLT56xy81tfrfqWLQHRXrCvpXmMclVCssllWXgfmtTmL1/WHMK9abh855dAAusaHoRQlAS3ymaqehX4lw5albRNRJ6XznmGUPyvzLCNGGlFKQ4rvqMKGEIX4X87HDOVncU9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jBvrEjOV; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jBvrEjOV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2aSVj8G+UNjs78bi2h3tIMOtzA+cg2I4Xm5wSysHdfQ=;
	b=jBvrEjOVLJeV5axoirXloQUxADhgs2LT1I8OLdZJNsXnrT9Xj/d0mUK+LxU2B75KTvSrAg
	X9oz1v75yJOZ/TrC7uqbAhqrPBSVtg0HZdLfkMAfy0pkwB5KIMKkvqIkGsoPEtGruZ4Yo6
	5nI0a5zJsZjiQlSWR9T2COYRttM2XCE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 26/37] bcachefs: fsck: Fix reattach_inode() for subvol roots
Date: Wed, 18 Jun 2025 17:54:17 -0400
Message-ID: <20250618215431.738317-27-kent.overstreet@linux.dev>
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

bch_subvolume.fs_path_parent needs to be updated as well, it should
match inode.bi_parent_subvol.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index a3f73e7a2113..6e64af4ccc36 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -372,6 +372,18 @@ static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *
 	if (inode->bi_subvol) {
 		inode->bi_parent_subvol = BCACHEFS_ROOT_SUBVOL;
 
+		struct btree_iter subvol_iter;
+		struct bkey_i_subvolume *subvol =
+			bch2_bkey_get_mut_typed(trans, &subvol_iter,
+						BTREE_ID_subvolumes, POS(0, inode->bi_subvol),
+						0, subvolume);
+		ret = PTR_ERR_OR_ZERO(subvol);
+		if (ret)
+			return ret;
+
+		subvol->v.fs_path_parent = BCACHEFS_ROOT_SUBVOL;
+		bch2_trans_iter_exit(trans, &subvol_iter);
+
 		u64 root_inum;
 		ret = subvol_lookup(trans, inode->bi_parent_subvol,
 				    &dirent_snapshot, &root_inum);
-- 
2.50.0

