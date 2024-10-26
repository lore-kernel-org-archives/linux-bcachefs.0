Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4001670839
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 04:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729916955; cv=none; b=ZohCcRQv7mrBT5ceTnaTIMcUQ7wCWUwnEuMk5jWfQB2WqemfO6G6/C6Kb4WFBpW70I0Fxj7p8NNKPy7wbry0CeGFHgzaI+7xyqSfLtRFY4WITERlQMD83iqLB+ocHBJb2sq7CNndhEGPqMdT6SZVoi/TzXjIS7GZe/DFQuXQhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729916955; c=relaxed/simple;
	bh=Gbz1S1gL4TFwdAhJkhrlbvgnhBGD4ZfgCW77PfqpjK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pUXeXDnyq6L5zVg+y0gkulFUHCMRLbeVamF82GwvWVeEqihsM3C28jAoyEmS+sX2flolGdhHcMvDYJBlp/BwIDUl2Mv1wAJlvKzzGFrbHbVJe1c57BTceVveBEkJ0P3SzS4fJBf3Etm3gB2Fenjcm5g11Ae99gZNVXG4Z2G8l3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=W9Ch3qxq; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="W9Ch3qxq"
DKIM-Signature: a=rsa-sha256; bh=OMIgrC7YNVCP8CFPFK3RoWlk+jesGqyN4klaqnsfAYM=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1729916929; v=1; x=1730348929;
 b=W9Ch3qxqV4Pcnu4Fubrk4RCvdrmPAMiK1Pn6Gh0JTzk4mNAi391zENYtch/THFCYV3LvJ0sx
 xW7ot1scvxGWJuCuqUcR1DiRtipBk1x0kZr5CZO/6uEDmTOHACzeDAuafQ3pscHKU18rzMI7JhT
 SzwjQsvQp48joFl5zNxoy6mqBMhwzMCSP+IQmEwXEcJPzH9igknk5N3C2g0hv4MNjG+CqdJZoL6
 2a5WiWrHv8AGCLl3uNs3kHihPIRmp55paV6iyF3bApc7eBsB1ktcspEWSAqkCrBZwxBDRvdbaxy
 BudheoWkDubRvVe7PJGARB/csXvJrHADzqjbww9lFASrg==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id e17cfa9e; Sat, 26 Oct 2024
 12:28:49 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH resend] bcachefs-tools: fix build failure when BCACHEFS_FUSE=1
Date: Sat, 26 Oct 2024 12:28:09 +0800
Message-ID: <20241026042807.483324-3-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when BCACHEFS_FUSE=1 is set, bcachefs-tools failed to build.
Replace "bch2_trans_do()" macro with "bch2_trans_commit_do()" in
cmd_fusemount.c to fix build failure.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 c_src/cmd_fusemount.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
index 50d35832..babdb6fb 100644
--- a/c_src/cmd_fusemount.c
+++ b/c_src/cmd_fusemount.c
@@ -242,7 +242,7 @@ static int do_create(struct bch_fs *c, subvol_inum dir,
 
 	bch2_inode_init_early(c, new_inode);
 
-	return bch2_trans_do(c, NULL, NULL, 0,
+	return bch2_trans_commit_do(c, NULL, NULL, 0,
 			bch2_create_trans(trans,
 				dir, &dir_u,
 				new_inode, &qstr,
@@ -295,7 +295,7 @@ static void bcachefs_fuse_unlink(fuse_req_t req, fuse_ino_t dir_ino,
 
 	fuse_log(FUSE_LOG_DEBUG, "bcachefs_fuse_unlink(%llu, %s)\n", dir.inum, name);
 
-	int ret = bch2_trans_do(c, NULL, NULL,
+	int ret = bch2_trans_commit_do(c, NULL, NULL,
 				BCH_TRANS_COMMIT_no_enospc,
 			    bch2_unlink_trans(trans, dir, &dir_u,
 					      &inode_u, &qstr, false));
@@ -330,7 +330,7 @@ static void bcachefs_fuse_rename(fuse_req_t req,
 		 src_dir.inum, srcname, dst_dir.inum, dstname, flags);
 
 	/* XXX handle overwrites */
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 		bch2_rename_trans(trans,
 				  src_dir, &src_dir_u,
 				  dst_dir, &dst_dir_u,
@@ -354,7 +354,7 @@ static void bcachefs_fuse_link(fuse_req_t req, fuse_ino_t ino,
 	fuse_log(FUSE_LOG_DEBUG, "bcachefs_fuse_link(%llu, %llu, %s)\n",
 		 inum.inum, newparent.inum, newname);
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 			    bch2_link_trans(trans, newparent, &dir_u,
 					    inum, &inode_u, &qstr));
 
-- 
2.47.0

