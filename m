Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB8317BED2
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Nov 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731162069; cv=none; b=okL40URIaIKGbZSc4XAQwQ5mfvcA771pVVCwZ8J1I1ceCET9K7jcUTZMfuma/+7a5qQ86NwMaZNBVmcQhaZ6cUE4MebZjP3RIK+ZFo/l2jBkMP4R9yA7arRSb/cU1WQlEbuFcRTGACIxwwAITpnIbHmRF3kY85T2sTh6H99KC0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731162069; c=relaxed/simple;
	bh=exuCil81JG8SjyeClCATIJw5jvdAPmIDHl0Su4n6GGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NdmaSEaJLl2ORg26drZMmH+MepVZ/nKASY+90jb4krPHFtpLx68/ounyFiiHXxgwl8j8W/2vMMYv99+NofCoZYaA3vQCAawoN0JD4TotBWKrtquNE//JrU9CXsdYUTJ5eGS9JmZf9coZG7xM4jXm4N7GG9Y0H/SgwTC29YqYLMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=hiTScbVS; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="hiTScbVS"
DKIM-Signature: a=rsa-sha256; bh=PLVWNuNojJ2Twu4w/CT+wX6EhEIw+rIAmSrdYh6qYqU=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731162034; v=1; x=1731594034;
 b=hiTScbVS3MkwtPYu0RVjrjiP9hiYwYcNiNuwd7dDM29Vz2XMqoqQZq37bci/XJOI6Va9cCA/
 cxyz2wY6wLW4YmB3TCh+elbs0VeMJajdnSKgGzbOTtYFR3n2D+6wV6ktHMDzxIs1LsOs/ONi+ZU
 n1BKiVZlTPgO950VyWCPzrVgVJ4qc/GYC87ovSdiScMpf7MQ7sWfEP39Yv2L1FND0WZ0XLZio6N
 GBOYuq0EhnNyOBMlsGpug2w4HI75a7uXc+jMqOelDnukcPbfV148aoJ/2UILxAMUR/0kA0Q2EIA
 gtxXJscZ8Al5wzS8UbClcFlKHDRlO8YSizTTusO5Ymw1g==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 103b7fd2; Sat, 09 Nov 2024
 22:20:34 +0800
From: "integral@archlinuxcn.org" <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs: avoid using strlen() to determine whether label is empty
Date: Sat,  9 Nov 2024 22:19:49 +0800
Message-ID: <20241109141949.138036-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "label" field in "struct bch_sb" is not guaranteed to be
null-terminated. Therefore, juding the first character is safer than using
strlen().

This patch fixes issue koverstreet/bcachefs-tools#341.

Signed-off-by: integral@archlinuxcn.org <integral@archlinuxcn.org>
---
 fs/bcachefs/super-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index c83bd3dedb1b..c612319ba901 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1322,7 +1322,7 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 	prt_printf(out, "Device index:\t%u\n", sb->dev_idx);
 
 	prt_printf(out, "Label:\t");
-	if (!strlen(sb->label))
+	if (!sb->label[0])
 		prt_printf(out, "(none)");
 	else
 		prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
-- 
2.47.0

