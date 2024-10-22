Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5701537D9
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603684; cv=pass; b=s8t4xbm6nyVv9mA5PHh3Laa1syugHatPiH24KW9VeqMNdtWhSY1OPHMmiwoU1RLt/stq23rnA9MKuuGy3FUndMbv9HMDthiNd0sciZoEVbUiU0I6wamvxTgFyIQJAxSMSSUrRF8poOat0uJ38YcvEVU4IttJA9LDDCiVnsF2HUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603684; c=relaxed/simple;
	bh=LSpbKndwoaQvnvOaC4KJS9rIHsAhdEqkEWrHUL/LJ+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8vWHBCD9uMhjMXMLTAqO2iu9IBIG3bTp4L3z0JB8I4TNlCbkTJs3D0XuBMiFGJwhIBE3f16rptCR/kdVP47MjsfbS+HrBsAefEpSN4/I6oEzKKBq1AhfwG64zGBYflul0Kw6TEAye67OsmE6RFP0oDM4+mgeTT9QSFNAUidqfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=cgn7sXH3; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="cgn7sXH3"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id 7F3CC720631;
	Tue, 22 Oct 2024 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1729602786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/KlKo2tACFewdAEYPpSqhoURApLYSsgw1IP0xiKl10=;
	b=cgn7sXH3P/qiwM5isZutyf37oxK6J3GabhD1W8G0Pidv+9ouaJHZ8ohHgSoAq6JRRsJUyR
	oM0z9UK4smvumTugTqbcoP3UlF4Fe8LF1ip0DM7o+WpxPLnR/9RQzlUBjjCiYR5RSCOZap
	U2rSPGqC8lw2M9hepOQIYVBmEqQAmJo=
ARC-Seal: i=1; s=mail2; d=murena.io; t=1729602786; a=rsa-sha256; cv=none;
	b=T1BoOKgmBwWa0OpSp5iLSgpEohTf1Ws/Ni7AUsGk/7KnQV5HBhKhRHWEAldmNwWJ0BuUJL
	KG6UvoexzYZR/YNpiAWXwtopaX2PbG29ETKsj1f07BbiKogaMlv2MjKOdL2DU1WP3FDpz2
	FS9uvjBkF2JDXUq+aioc+sZmLNn7Ti8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1729602786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/KlKo2tACFewdAEYPpSqhoURApLYSsgw1IP0xiKl10=;
	b=mCebaOdKWgFrdwvpM7cMNOBWanZSEF7jNKpwzREDnSeeLgrUFrL9VO1/6sWUx0MaayLAs2
	tJsmDLin6BQn+YBgLiT++E96S3Wy34Qqa28sGNrZ0ZXL9ktkVTUC/1EUuUM1XxgYZ0poFR
	J4h/hYRLdj1kPV/aowSnjGw2kjD2cdE=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
From: Integral <integral@murena.io>
To: lihongbo22@huawei.com
Cc: integral@murena.io,
	kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	mmpgouride@gmail.com
Subject: [PATCH v3] bcachefs: add support for true/false & yes/no in bool-type options
Date: Tue, 22 Oct 2024 21:12:20 +0800
Message-ID: <20241022131218.300195-3-integral@murena.io>
In-Reply-To: <70f82243-359c-4b1e-a9c9-1ecbe1ea9020@huawei.com>
References: <70f82243-359c-4b1e-a9c9-1ecbe1ea9020@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is my modified patch:

Currently, when using bcachefs-tools to set options, bool-type options
can only accept 1 or 0. Add support for accepting true/false and yes/no
for these options.

Signed-off-by: Integral <integral@murena.io>
---
 fs/bcachefs/opts.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 68d240126522..26319e7a1c4b 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/kernel.h>
+#include <linux/fs_parser.h>
 
 #include "bcachefs.h"
 #include "compress.h"
@@ -322,6 +323,16 @@ int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf *err)
 	return 0;
 }
 
+static const struct constant_table bch2_opt_bool_names[] = {
+	{ "0",		false },
+	{ "false",	false },
+	{ "no",		false },
+	{ "1",		true },
+	{ "true",	true },
+	{ "yes",	true },
+	{ },
+};
+
 int bch2_opt_parse(struct bch_fs *c,
 		   const struct bch_option *opt,
 		   const char *val, u64 *res,
@@ -332,17 +343,18 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
-			ret = kstrtou64(val, 10, res);
+			ret = lookup_constant(bch2_opt_bool_names, val, -BCH_ERR_option_not_bool);
+			if (ret != BCH_ERR_option_not_bool) {
+				*res = ret;
+			} else {
+				if (err)
+					prt_printf(err, "%s: must be bool", opt->attr.name);
+				return ret;
+			}
 		} else {
-			ret = 0;
 			*res = 1;
 		}
 
-		if (ret < 0 || (*res != 0 && *res != 1)) {
-			if (err)
-				prt_printf(err, "%s: must be bool", opt->attr.name);
-			return ret < 0 ? ret : -BCH_ERR_option_not_bool;
-		}
 		break;
 	case BCH_OPT_UINT:
 		if (!val) {
-- 
2.47.0

