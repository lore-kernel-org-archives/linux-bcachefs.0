Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CEB3085CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283713; cv=none; b=GVKxPojn+kGTMVbgN3aeHcfkMDtDuDNgggkLeOMLd4kOvP90MZUg2fzaI6dZFF6VG+WgqgVS4eeJ3Su3NsrqYYoaIZRzAra1FBITux9/YXdvyzXhSGDsKVMO1PCaNELadS3SmzORBRuIo6VdiKI+kUCmvqFrf9RS0rbWIdnPUNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283713; c=relaxed/simple;
	bh=DbptK5lg+EeYd3kvL86+u1Sckk66FMizrum/OLztfjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8covAY+IhTH3aecUVeR/1/3bYTbn8GUcGXGdX3Az6AjlHezH5UtA16X0BoIBUuZxBMK1pjSsmK5wo2nBRMzkySW6Uceq4ou7zodzXMI8Qp0IdoAyxZbr7fgoR6FHTlCWYzINhdzDDvuunJsAhT9KBb/M53WLSXwGvWTa0mst40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=idmb4Qy2; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="idmb4Qy2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDFszfzhz0xsQKtCy+jM8ll1mGinTyiMdSRmdEicZms=;
	b=idmb4Qy2KKtKgj2scJqWjbVObQBpVONTW4YZk+RcDGTx2hSM8/m1RL/gnXyebpc6h1ZazE
	oVXx2x03aJ2sZOGmTDiJSSoHTAsqafq7pkZsWCHLyH4uzCHF6BE8th/BJdT/4wkl89hLrr
	L+LqfRyK2EG8O3wCPc2x5cKvS/SNCRk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 34/37] bcachefs: fsck: fix unhandled restart in topology repair
Date: Wed, 18 Jun 2025 17:54:25 -0400
Message-ID: <20250618215431.738317-35-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_gc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index e92cf3928c63..697c6ecc3a65 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -503,8 +503,14 @@ static int bch2_btree_repair_topology_recurse(struct btree_trans *trans, struct
 	prt_newline(&buf);
 	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
 
+	/*
+	 * XXX: we're not passing the trans object here because we're not set up
+	 * to handle a transaction restart - this code needs to be rewritten
+	 * when we start doing online topology repair
+	 */
+	bch2_trans_unlock_long(trans);
 	if (mustfix_fsck_err_on(!have_child,
-			trans, btree_node_topology_interior_node_empty,
+			c, btree_node_topology_interior_node_empty,
 			"empty interior btree node at %s", buf.buf))
 		ret = DROP_THIS_NODE;
 err:
-- 
2.50.0

