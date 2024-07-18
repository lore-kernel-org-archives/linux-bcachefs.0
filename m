Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C99273FD
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 06:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721284686; cv=pass; b=QIXSoSR3CUTKPNING29sZI06QLY6ZVoYj2pBr333l+BtRsQgCkf+1yjk0IMdYdwZ1jf/rUBgW8WizeyK2GUR0svMGW7Yx4E289/7M297rWnPqGMUE3MapwGcH1gqfAOYk6tEa2TLcfWl3tUZYP/gJ6gMChmMZu5xPpWHPfAYGeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721284686; c=relaxed/simple;
	bh=zmaULNPGFkOan/1DHVxJyeugYikVQxy2hdrVHKNpAkM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qKHWSb1/GdxmlbXxKQTc6kHwO1ZfA8myJPMaK5eS7NBhLD251gxPwwgk4YF90XlAFIDPKtbO8BElo865a+aTNlPmnWoVdtSet8FLQhlvnSCEyhQFDmtLt0omN/srdpHxn7NSvgBTx+U1AVfLaFQ5cpJj4cEO4zFfnb7GdgOoUXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=JRJiZXLW; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="JRJiZXLW"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id C325588467F;
	Thu, 18 Jul 2024 06:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1721284237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kBdaZQuIispBLD08RqrfpAGmB9Xu1RomUbMSVabkUyE=;
	b=JRJiZXLWWfgb+Ui7ab6724PZVOmtYqze9CildkGUDMbTjMMZjiT6b+peTqfT/Ivcp+gIDo
	VW67/NOvdvHdM4fw0IGuQhLnqU8MvVdJnhR08HhyhVVOJZ55Q2umiptT3er+fcl8QlHN2b
	UyDagg8uqwSpmBauy3s2XD3v0Ijsbl0=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1721284237; a=rsa-sha256; cv=none;
	b=knb1dZdRdDebrqovvsLJYI/PEEleFbSj0ZM47yETladlf+TnxFe4Obmyv+5mMD+Q62GFF2
	rgHidemHIS+9Uz/ij8dpkVR5kVStsvSP/gTQFXbN5ayUSPRE0HLOIcPGsiU5xl/46wqO8d
	C7URYXOOlBijmbMJF9VeSIBmw5CqR08=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1721284237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kBdaZQuIispBLD08RqrfpAGmB9Xu1RomUbMSVabkUyE=;
	b=Eo6VxBfFvGNTKxpNFw1kwxg4Umo+tOHoD6JPmG7kXr7MxKPOSjLjpKCwS8oAf+pp8bGCIm
	172+yRbHVhOcoh9NHk7FN0346CfhSDkRhIvq/Crn85qIAT80geAJ0ZRGn/vSXz9AoTi43f
	iig3TDz29DMh5okeyICqFW2rJRAC0Qw=
From: Integral <integral@murena.io>
To: linux-bcachefs@vger.kernel.org
Cc: Integral <integral@murena.io>
Subject: [PATCH] Add support for true/false & yes/no in bool-type options
Date: Thu, 18 Jul 2024 14:28:36 +0800
Message-ID: <20240718062835.58037-2-integral@murena.io>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when using bcachefs-tools to set options, bool-type options can
only accept 1 or 0. Add support for accepting true/false and yes/no for
these options.

---
 libbcachefs/opts.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libbcachefs/opts.c b/libbcachefs/opts.c
index 0770aebe..2c0113fb 100644
--- a/libbcachefs/opts.c
+++ b/libbcachefs/opts.c
@@ -332,6 +332,11 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
+			if (!strcmp(val, "true") || !strcmp(val, "yes"))
+				val = "1";
+			else if (!strcmp(val, "false") || !strcmp(val, "no"))
+				val = "0";
+
 			ret = kstrtou64(val, 10, res);
 		} else {
 			ret = 0;
-- 
2.45.2

