Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C721CC48
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283694; cv=none; b=VV0OMHAFEeBb49GWj4p4IKNY0nh9/+CrFwMCDDJIYGbVBqnxU3c8cz7MQ9iPlpcBipgsQdrhrLyhUG1NMXGPB721+uOu5gp5KTADvTnads5EOPZdmccj881q2PyJJfuh9w9AVNpci5th5Qb+LO/Dr6N3slTH2zoukj1iK4Jvj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283694; c=relaxed/simple;
	bh=zjOc2gNdsWhQgJk6KdCAHOx6U1O25BjqcFweg/ParUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTx0td5/qJPBSOlU/gAhALYobFfMeJv60Uc6NQKtuFlduu+HufD+5YprdBCzjGJ2f1F60MyN/l9D3SzvM3w1QyHyHgR1l1L1WjPZtgLSZPS9yH+OAbwkk5R69ZL8OPRTqHgNN+kULKlubKM1gyGy7ulK2Uyl1CG8Gmd7R7hIc8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bw2CKA/J; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bw2CKA/J"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8YzJp11n2+Ppc79wopAm7TsaMykA9hUTaMli1pzCPnk=;
	b=Bw2CKA/J0QH9Rdv0TfcxsaHBZPdjI/8eTsCdHemrXVGq4lOTgDIxk2a2w+ISSPd/PXdzC7
	vAhrjTbxaXB9K0t8yksi6LcBK5rvr0HZeFuMsJ50Opu3VLKIoSyI5ac8br0NTXUbSjh4GG
	qMjIsOcHC6K+7BNpi6aZBvzz+gPjW5A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/37] bcachefs: Fix "now allowing incompatible features" message
Date: Wed, 18 Jun 2025 17:54:02 -0400
Message-ID: <20250618215431.738317-12-kent.overstreet@linux.dev>
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

Check against version_incompat_allowed, not version_incompat.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 6aef8b101820..820249e9c5ea 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -692,7 +692,7 @@ static bool check_version_upgrade(struct bch_fs *c)
 		ret = true;
 	}
 
-	if (new_version > c->sb.version_incompat &&
+	if (new_version > c->sb.version_incompat_allowed &&
 	    c->opts.version_upgrade == BCH_VERSION_UPGRADE_incompatible) {
 		struct printbuf buf = PRINTBUF;
 
-- 
2.50.0

