Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07621A3178
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Feb 2025 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740676962; cv=none; b=DZb/e2GkzGgX0Tb2cCOV2FBV1vG0/r2zzA9NKo+BfanQ3RD9J1zEC2XCAGnfwnRJ6F9E1QLIBMhIDY9O7s13Wpmx//c022a71sfZNCzfIAQCUwCcibS546RVtGj3a8mQAyU+bYP+Yoij3yerrGxtQOedjvIq4D34xq0vOLIsKzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740676962; c=relaxed/simple;
	bh=eErh/pyXl+8fq+iSD8/YfcDSs8fSgQFFow7b5b199hE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CAZPBzgxsuIWvuR7hUUeFhjZs6w7TjUXmtMhsggbcisXLmyJhg3otCo78GN5UFwvGByQu3se2xGo6B2JDEiNzozGYzSX1zy0/IfZx1cIUQoB1SGkaShhEEl8DiQw/Hk8IoOJQ2tSPpLS4UqlgHSNWIoGJLbRsd/VGcSPnPaExZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hH5GT0bU; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hH5GT0bU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740676957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kfcjng9ue/GFFUTz6SkApgIWXnYnxsO5SWJB9+YG+is=;
	b=hH5GT0bU8q1SUKh1CHIVq7AO0U5yazpDEixxp8YOjO8H3XNyfgWEKMbz+/QtXpK4WiW+l9
	ncf238qh0YSAB1ey8/AUxPhQcLJsk1mmY4QNpXWy5/HhioqreIxVtGj23JrCMJVd8Jj4E6
	ItaY62C1opm+Y+rvWdFnmQ4/ba30niY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Remove unnecessary byte allocation
Date: Thu, 27 Feb 2025 18:21:57 +0100
Message-ID: <20250227172155.4224-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The extra byte is not used - remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/fs-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 15725b4ce393..4adeddebaae8 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -218,7 +218,7 @@ static int bch2_ioc_reinherit_attrs(struct bch_fs *c,
 	int ret = 0;
 	subvol_inum inum;
 
-	kname = kmalloc(BCH_NAME_MAX + 1, GFP_KERNEL);
+	kname = kmalloc(BCH_NAME_MAX, GFP_KERNEL);
 	if (!kname)
 		return -ENOMEM;
 
-- 
2.48.1

