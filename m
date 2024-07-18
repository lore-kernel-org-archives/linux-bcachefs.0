Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4059F78C93
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721305835; cv=pass; b=KMA0WUXG4g5RJT+2TWO44QJihc5fr/wCfGRPdhQ9UHW0MyatboVOo661gxRJlnfdFZd1EnSSXlDLpgEC41rBWDkLRuGbcgA1PzjzjnNzzTeUiu5Qzn1sVZfN0ldGEsbtn3JgG+ZUCfd3LXwKRGHY252r1GBNQZ70O+thrPPaX60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721305835; c=relaxed/simple;
	bh=Jof/CdmVo6YwxIzK2/ZoSLP5bJTsJ/ipr9R4oggugG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHnCpgs+PWaL50BvcWU+Mvj8ixA2B+03PKAuBiuLgelq5UoXcWNEwEmcocSXsWouL7h/bFTb25vpi6QIgJvYzXwX591lQClJb/DeBpHYBrsbZV+KS4qF8eU/3j7VeFuiNnCgl8IcTsPSsfmJ0YfFimL29FvkmuhgyTzUptlrfwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=nkunQcOl; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="nkunQcOl"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id C6CF588467C;
	Thu, 18 Jul 2024 12:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1721305828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qIhQsHLtS2lA6v82xV+NvFClxNTB5XeRfqKgLIXKPrs=;
	b=nkunQcOlLaGM9cLEIXiRNL60+h9UhaWFbO1TKJpFZVyTTWyD7Iyb62xnBtpi89GLpwd+ji
	RHrzT3Tw1/l/SjAX/Em9Y/hL5cwkBk9odkkGjRN5SkRmEzR2qlOouv+zjQ2OC7lAC6P6uC
	7TI0ZC/SOybauJkWPlSNq+U2iR2XZJU=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1721305828; a=rsa-sha256; cv=none;
	b=MG3BPXC8ED83LuctxL9Gyzg/XnRzEDvJaHWF9fndiGGiMT9oQRhj6AShSApBjXmVlQbPNT
	Bzq2uBXtGU5mVyldoEEzgnrYkGzZ9ZEPp90nfuG33Kgu6omDgtGEtYOvyMxRwusN7cSH0H
	z4WOIN48Wk9vAsihDZg24u+BkvdFjh8=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1721305828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qIhQsHLtS2lA6v82xV+NvFClxNTB5XeRfqKgLIXKPrs=;
	b=EeCdhFnMEzoq0RVFLdXSpiva00CZ/3LXSVe/vm6BJQ+PNiVGauFGsDNCFREUAgwYvuHi3N
	8UP/NaLKHOTSBYrpHA3g75j5ltXzsicjaedWC2KfLsAmO92aQaut67hE+Ul6P2pYpWyPxI
	02PQlbfnHNJ75oDEQz/CMhYJwQHiXHQ=
From: Integral <integral@murena.io>
To: lihongbo22@huawei.com
Cc: integral@murena.io,
	kent.overstreet@gmail.com,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] Add support for true/false, yes/no & on/off in bool-type options
Date: Thu, 18 Jul 2024 20:29:28 +0800
Message-ID: <20240718122926.99326-3-integral@murena.io>
In-Reply-To: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
References: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the new patch:

Currently, when using bcachefs-tools to set options, bool-type options can
only accept 1 or 0. Add support for accepting true/false, yes/no &
on/off for these options.

Signed-off-by: Integral <integral@murena.io>
---
 fs/bcachefs/opts.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 0770aebef6d8..0e4cd6984eda 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -332,17 +332,21 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
-			ret = kstrtou64(val, 10, res);
+			if (!strcasecmp(val, "1") || !strcasecmp(val, "true") ||
+				!strcasecmp(val, "yes") || !strcasecmp(val, "on")) {
+				*res = 1;
+			} else if (!strcasecmp(val, "0") || !strcasecmp(val, "false") ||
+				!strcasecmp(val, "no") || !strcasecmp(val, "off")) {
+				*res = 0;
+			} else {
+				if (err)
+					prt_printf(err, "%s: must be bool", opt->attr.name);
+				return -BCH_ERR_option_not_bool;
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
2.45.2

