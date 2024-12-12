Received: from cmccmta1.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A744F18EA2;
	Fri, 13 Dec 2024 02:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734058127; cv=none; b=FfC4F1f/PAaombJ0Rrm5oJEho/NI6rDsXRqHs7RSmlemCwWgzJ5CycreEBMAMuDvrNI3yOSksMjsc4V51EytAEV3NFULT8NZ0cRX2JvJn7fr9alRUsalH90285gf+WPoCmxZhP142CHy5GIlxMb3bp3BsJR/mX/asVCG0jbmA3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734058127; c=relaxed/simple;
	bh=aNJmAJkFMuYIJJPT3U/sAf5AjG1ppAsaDrA5OFw+4Aw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hgpawTs+1Dz8P4044HxeqcAju9NdFGUguJj53BIjQbJaiPl4TafcPoXOAeLFwiUZWc8G5mr1mIN6AUKj5eW/JgiJwRtbMsqsivgaB7JaQ9Ewg2fR4GlSTofaH1J5ihRVe8HBRUUfmQcCYJ7c3wKoyjmbjsbXtSU5WiNkcXzorLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee3675ba080b1d-e635b;
	Fri, 13 Dec 2024 10:48:33 +0800 (CST)
X-RM-TRANSID:2ee3675ba080b1d-e635b
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.96])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee3675ba07999a-8b5e7;
	Fri, 13 Dec 2024 10:48:32 +0800 (CST)
X-RM-TRANSID:2ee3675ba07999a-8b5e7
From: Zhou Ding <zhouding@cmss.chinamobile.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhou Ding <zhouding@cmss.chinamobile.com>
Subject: [PATCH] bcachefs: fix invalid declaration after label in str_hash.c
Date: Thu, 12 Dec 2024 18:49:12 +0800
Message-Id: <20241212104912.122899-1-zhouding@cmss.chinamobile.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We get 1 error when building kernel withW=1:
fs/bcachefs/str_hash.c:164:2: error: a label can only be part of a statement and a declaration is not a statement

To resolve this, the code after the found: label was enclosed in a block
to comply with C89 rules, without affecting the logic of the code.

Signed-off-by: Zhou Ding <zhouding@cmss.chinamobile.com>
---
 fs/bcachefs/str_hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index ed3c852fc0be..08625947ed99 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -160,7 +160,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
 	bch_err(c, "%s(): inum %llu not found", __func__, inum);
 	ret = -BCH_ERR_fsck_repair_unimplemented;
 	goto err;
-found:
+found:{
 	struct bch_inode_unpacked inode;
 	ret = bch2_inode_unpack(k, &inode);
 	if (ret)
@@ -174,6 +174,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
 			ret = -BCH_ERR_fsck_repair_unimplemented;
 		}
 	}
+}
 err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
-- 
2.33.0



