Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE501392
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Mar 2025 19:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741463669; cv=none; b=e+N9Yl2kAWpbtuTaSHHIzqVf3WCdeYVdjxL9UB01c8HnJwmJV2U3H2bLdTKoHoPibkmh1Y3gCdxd/CwrlB0j8LiCXhA/zZAWglUNESK7uVGaRDynrYlTsXipLjSY1XOa6i15l131xDGzbBP8Y9E5o3VFB6uyfw+tuCJTr6lbze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741463669; c=relaxed/simple;
	bh=t6WB5fx0rHjhMtjcjQnz0mPgR8QLo8e815vrOJrpZ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K5qMqIFKfeS/jY63huh5YZOJ/s4HUdZr/froqTHC6w79cPuILjIHAvE+UKyI7pPDkz2rzlkADkPePv+ZnBJ9Dg5Boirm5S1aenmXDTQoum7DSWIv5Xgqm74l/dWVg4cSQ4zjVoMq5Nvm9cXo1GD+I4J7+qZxsp1u3Q9N/nyds2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DVNHGFPO; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DVNHGFPO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741463655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dUcqRxrAumHIfnW9n8O0WkK51jybPI0vkc2ANXUC6po=;
	b=DVNHGFPOYZVQBv1pvU1Il14JWY8EF6ju0bto+EpetrP7VY6TwburmWDWIHlSAdS4I4BZiF
	wHOrQqzaxR9DwSsmwa/NYQnI5aqofP9AsR/+snCi64k3ojXDaKq2aaSoEoVh5VGDy4/W+J
	CSHszUr70vcLnXPo8HlD8kqaVlIFQy0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] bcachefs: Remove unnecessary byte allocation
Date: Sat,  8 Mar 2025 20:53:53 +0100
Message-ID: <20250308195353.194683-2-thorsten.blum@linux.dev>
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
index d9f1a7c09e85..9761a365552a 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -244,7 +244,7 @@ static int bch2_ioc_reinherit_attrs(struct bch_fs *c,
 	int ret = 0;
 	subvol_inum inum;
 
-	kname = kmalloc(BCH_NAME_MAX + 1, GFP_KERNEL);
+	kname = kmalloc(BCH_NAME_MAX, GFP_KERNEL);
 	if (!kname)
 		return -ENOMEM;
 
-- 
2.48.1

