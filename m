Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018A262FC7
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681711; cv=none; b=KUKulX4AE7q/fFNlV69ALMm0fXG2QQ+DaZinTD66u6djAXbrCm310r/EcKUdXwBtIzlWXmfof/C/5Q9v69T6djorbtRQOZmF5lye8cIV/wUE5VN/m0g8OZmCTNiX2Wd/fhVLe8NMUUkKCJ5FemFCdmI79sssV63yOVEU2fE9/f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681711; c=relaxed/simple;
	bh=9Y8+aNFfaMxwiMuyl615gwYgkvccrC2beQqP+yallcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeYChfA11Yo11T5lYb07RMD/x90HwXtKxY2yF524PcucJLZ8R6K+lZrea3mTQiIhipmOYIRovkhV6XXJtOfuNjVmwEwJK0Tx/CNmGZP6+oZhV3M82ERDvJ3lZNPLP6kwru9CvciM6xeqAP3ub+exnuNGwIy7o7Pn3Mk5oaytOO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QJNfukCb; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QJNfukCb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=epstTAiQzK8V4lTdmwxFg1WtkyYSpDxMOjk7TijBL+c=;
	b=QJNfukCbaCssV7BSBrZAmVNaE8pVswu68pVPXhP28Y1EdfvUiFMzqC0tsYRhbjSbVv9lCL
	BgZJRQN1/cqecXdYpzaFgDEtFOKfxRPrUv4dbQQaO1IbKsrTu5LcAxnDhY5w5oiPXrenut
	GFTzlpZNabkTh1vjROfCe3vwNFPEGhA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/7] bcachefs: async_objs: update iter pos after obj printed
Date: Wed, 16 Jul 2025 12:01:36 -0400
Message-ID: <20250716160141.1158722-2-kent.overstreet@linux.dev>
In-Reply-To: <20250716160141.1158722-1-kent.overstreet@linux.dev>
References: <20250716160141.1158722-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/async_objs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/bcachefs/async_objs.c b/fs/bcachefs/async_objs.c
index a7cd1f0f0964..e368c765eb46 100644
--- a/fs/bcachefs/async_objs.c
+++ b/fs/bcachefs/async_objs.c
@@ -80,12 +80,11 @@ static ssize_t bch2_async_obj_list_read(struct file *file, char __user *buf,
 			break;
 
 		list->obj_to_text(&i->buf, obj);
+		i->iter = iter.pos;
 	}
 
 	if (i->buf.allocation_failure)
 		ret = -ENOMEM;
-	else
-		i->iter = iter.pos;
 
 	if (!ret)
 		ret = bch2_debugfs_flush_buf(i);
-- 
2.50.0

