Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26CA1714B3
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226175; cv=none; b=g//P9ZtPppJCtDziYIeToC5eCopk5I429rwnWHdrWiUunXqavoXO+Qh6OtLz7Wq7BOnGCPzEgSmOpWP8QfvxsDKQTVTKwpZ5LqOgksUJSAgI7BwJGhgdqs5+Scry2W+1BcGfbVrzNIfksv4oeDegXAH1lvL4+uHczvNowGVpkZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226175; c=relaxed/simple;
	bh=9R38CiVbBCb3ks/sX0vf9Qi84BMEJlWkpT2TX1Wvnw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTtR/Gh0EylLE2xiRqEaszpkPm1t8/vT5T5tyYbqe9+hmRKbyNLj0+oPqgj9zlszo70tHJaUmvSMSdEAgVJDiwtP4FAcXNkEeEScreIvdUJIkumPKyYmZQAZcro1BD3ZpkQUrxGDWU21CiZ7jVOVH+9L7BXQbtpLH0jo7R9Grfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EoxNWKUv; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EoxNWKUv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MCWWol/YKxZGwE3RgUme3rqyy1ZKIqgBeLvDhEBUsXk=;
	b=EoxNWKUvgNeEXYWybSyw1doAI79Cj1PWktmijOeLJsL4ws7pYsRH3maVhAMKlHPFlzVIA4
	15Mcv5OGuozYbHQXEyIuWFrx3PFn8AQGe5bhVw3PhfpqCqRcU641ZKdmkKz8JPzIWVbo95
	9owr1aYer48SVXkxuT6TcInBs0f3HEo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/9] bcachefs: fix restart handling in bch2_rename2()
Date: Fri, 18 Oct 2024 00:35:51 -0400
Message-ID: <20241018043602.4067344-2-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This should be impossible to hit in practice; the first lookup within a
transaction won't return a restart due to lock ordering, but we're
adding fault injection for transaction restarts and shaking out bugs.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 857175f4bbbe..d5d16d12e03a 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -871,7 +871,7 @@ static int bch2_rename2(struct mnt_idmap *idmap,
 	ret   = bch2_subvol_is_ro_trans(trans, src_dir->ei_inum.subvol) ?:
 		bch2_subvol_is_ro_trans(trans, dst_dir->ei_inum.subvol);
 	if (ret)
-		goto err;
+		goto err_tx_restart;
 
 	if (inode_attr_changing(dst_dir, src_inode, Inode_opt_project)) {
 		ret = bch2_fs_quota_transfer(c, src_inode,
-- 
2.45.2

