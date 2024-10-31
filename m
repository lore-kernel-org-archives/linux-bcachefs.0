Received: from mail.commonsconservancy.org (mail.commonsconservancy.org [145.0.6.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474AB1991CB
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.0.6.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730383583; cv=none; b=F+L+VPIosWpIq7EEWNm5g817WmtPTBovKUBkB17bv6hZFPUbT13rLVCA5tjGf1hGC3XkPFuztJ/PnugUQzrFzgJgZ0T5c1xwgLoWfYDI7aGxmgbTNkP6t0wPhdp6ZFQMh6qiUUeHU6UbfmolZ+04WSLdfHj7FoG7oFc3UP/qkdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730383583; c=relaxed/simple;
	bh=x+6ljZaexm5S2ven+wlqwlAU1///NJ+Tg8pfrjLVSqc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lu8tJU1S57P1FI1FORoSMVZavpRjUsT8r5JCAalQYw4s2aW8EzrxPOoiCjw85R7hamxCpQDXJ5n9mN+2kMdN6ndbk3lCt9yucnUfXZZy1HsDMcNlAO09+xC/9F/4a72e3AWi+A4ttLcRc860oGV2K48hkz/5fIqZcOq49cORW68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commonscaretakers.com; spf=pass smtp.mailfrom=commonsconservancy.org; dkim=pass (1024-bit key) header.d=commonscaretakers.com header.i=@commonscaretakers.com header.b=M2e2vSVI; arc=none smtp.client-ip=145.0.6.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commonscaretakers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=commonsconservancy.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=commonscaretakers.com header.i=@commonscaretakers.com header.b="M2e2vSVI"
From: Eric Herman <eric@commonscaretakers.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=commonscaretakers.com; s=mail; t=1730383577;
	bh=kl15RcSZnK64ocXktSEf825rg0E+yvk2UhjJHveAnUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2e2vSVI8pj49JtVifnxGfHSCw9sDwwJBOH00S6dFRQLlxQAi8GExpyppB5jn//Tg
	 npZFiVg1M/XNFrTgET2qjwtBRT7cNcKc7hZI/Z3otalxBub/yI29DVUlwOHUZpXpgV
	 OahCqAVxiZ5rhwcpUbkLCKQrvcYYHH4sOySmOnh4=
To: kent.overstreet@gmail.com
Cc: linux-bcachefs@vger.kernel.org,
	Eric Herman <eric@freesa.org>
Subject: [PATCH 2/2] ktest README.md: fix typo "standard"
Date: Thu, 31 Oct 2024 15:06:02 +0100
Message-Id: <20241031140602.2146768-2-eric@commonscaretakers.com>
In-Reply-To: <20241031140602.2146768-1-eric@commonscaretakers.com>
References: <20241031140602.2146768-1-eric@commonscaretakers.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Herman <eric@freesa.org>

Signed-off-by: Eric Herman <eric@freesa.org>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index e6a415e..9606ba5 100644
--- a/README.md
+++ b/README.md
@@ -15,7 +15,7 @@ options, scratch devices, timeouts, etc).
 DEPENDENCIES:
 =============
 
- * standand build tools (gcc, make)
+ * standard build tools (gcc, make)
  * qemu
  * minicom
  * socat
-- 
2.39.5

