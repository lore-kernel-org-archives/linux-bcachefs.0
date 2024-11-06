Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B9C20D500
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730929423; cv=none; b=jw/IgY4OpnjbIu+Dbar/hPL1GJEuDdaQZ0+9MP1zutKdCewizj4HrfNPOinYK9FhkN883vmhAFO965i3F0SDmWjfHkUcBBlwWmFmxp1rrntak/eOMJuF8vrc858PpnXLPtLYnRsln1iMrveUq2gAEvbpYZWV24OgOATOawuZvWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730929423; c=relaxed/simple;
	bh=c0VWQe/4BJkaIjyZWh1fxa8jdhcSmrBQVBgvnefih0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B5c6kx0enfhJGTvEeKCdYYJ3UypmZ6n8XzZn6ia9LbXBcG5owMbPDGNTqsLmg6yvs2rX9uPovd++GaASbqBS1Tuj/igIGrUw29xNYsKhKp6aIINdiAGYXw0cyxBrDFnX2xCjPwVivBDoep6L/3/ksEJN+AoG8TBBOAkCNywuPs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LQ8p4oUo; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LQ8p4oUo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730929419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PkE8g7GvKLJ/zHX2V7/cnoXhO+j+A12njaiftXNy/+s=;
	b=LQ8p4oUoh0ZAcklwioZPhsrU83TNstb1AYRnc/nIYWWwVJMPr7LX1gFE8ScPwFSrQZzVw+
	iU/EW838DFBtdKZ1Z/j4GXm+UaEMemfigMh/CR5+YZAXX6xdvursNWPc+N73omagKxefgw
	uOKnbIlGs4CdC3HhY++WbgQZ9HKeMcA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Reed Riley <reed@riley.engineer>
Subject: [PATCH] bcachefs: Fix UAF in __promote_alloc() error path
Date: Wed,  6 Nov 2024 16:43:28 -0500
Message-ID: <20241106214328.33454-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we error in data_update_init() after adding to the rhashtable of
outstanding promotes, kfree_rcu() is required.

Reported-by: Reed Riley <reed@riley.engineer>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index ac6a6fcc2bb8..b3b934a87c6d 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -262,7 +262,8 @@ static struct promote_op *__promote_alloc(struct btree_trans *trans,
 		bio_free_pages(&(*rbio)->bio);
 	kfree(*rbio);
 	*rbio = NULL;
-	kfree(op);
+	/* We may have added to the rhashtable and thus need rcu freeing: */
+	kfree_rcu(op, rcu);
 	bch2_write_ref_put(c, BCH_WRITE_REF_promote);
 	return ERR_PTR(ret);
 }
-- 
2.45.2

