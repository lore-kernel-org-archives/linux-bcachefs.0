Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C1913D245
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727956084; cv=pass; b=h9C1hSIr4dRdeEjlvKwgQV6mkRTNYxsTxTl7nihhjDEuU0ufmar4ADW9K08UnNQp8DyNcv4vEH82CZX7g2afkn+dBq9NqC6O9gMjKrLQsV+AEFniVgbGzyMj+7JYARNVSJ0sStgcoC6XqTybKVLrrS013AZB7FP7mYFTDp9O6Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727956084; c=relaxed/simple;
	bh=QYGW1h0SeFTwtBqapyZNfmvnLiMEf4Re4hlqzmQbWpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8jD3sm3q/lySfy2e+wo8lWb3VEEMa8KVHJOb+ilpG6UBgcN45NRjxjfwJgqD6Hi1o2ZVb0p7EIT8bV26qCSy3+Xv+T5ThNx70yWD5ME5rxVFt7Vhbt3/i0eMWGwUDhHPfY8ZppQ1KHY/EP3U1kWckRBhOVdVYdyQiYREvXkjio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=nom6Y16M; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="nom6Y16M"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id AF7F48831B0;
	Thu,  3 Oct 2024 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1727955624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o+waN2lRr07uhpPtle/Qv7BsRwY+hOXEKCs6pM9hQoQ=;
	b=nom6Y16MTKkgIwlAZubaaGwGx8z1dlQGZrY90wFa9gQfGk4lNqEZmvIybwcDFW6FOCbhkl
	nqNPLhHaSdg9yD/7vrAWaU/02U20qdBHanOPp6iWOLQeBTODijop8I74IGRnSNDo4aB6KE
	fa5J5VSty7un/3kPKa0lAQfcMu8M+Yg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1727955624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o+waN2lRr07uhpPtle/Qv7BsRwY+hOXEKCs6pM9hQoQ=;
	b=pf1d1qK/qt7A5nunObl+Z+MrwpyZfyUyd+q1s0RRtF+hlKCQNY8mgeuq+oUpBrFnUKgHEV
	ZZ6QohZNaeB0pFbUm2DUa0LvGAC49Gu6eJ16bQbZamz5sRTNwk9i8aIBUcoLdxT2GbqDqF
	7vFBJwAFF95ABztYUxhHiWCAavOPYNs=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Seal: i=1; s=mail3; d=murena.io; t=1727955624; a=rsa-sha256; cv=none;
	b=ktzVpkrZnQETETcfLbRJ0kHWfW00zB9jGhlSIswfvCKkfiWs4B1MgSEdiomXiMe3j9rjqB
	gqtNwImJkNzzvH9gQRN0BWJawET4j6TzkpUGbT4P0RjMInCjTcDF/BRDfcEaJaSXiunQ8r
	vrZm3L+n/SRvD6c+c7DQ62pVa22OKIY=
From: Integral <integral@murena.io>
To: mmpgouride@gmail.com
Cc: integral@murena.io,
	kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] bcachefs: add support for true/false & yes/no in bool-type options
Date: Thu,  3 Oct 2024 19:40:13 +0800
Message-ID: <20241003114012.297236-2-integral@murena.io>
In-Reply-To: <21B6E9C0-9A84-4B54-9FC8-307E82AB6006@gmail.com>
References: <21B6E9C0-9A84-4B54-9FC8-307E82AB6006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is my new patch:

Currently, when using bcachefs-tools to set options, bool-type options can
only accept 1 or 0. Add support for accepting true/false and yes/no for
these options.

Signed-off-by: Integral <integral@murena.io>
---
 fs/bcachefs/opts.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 232be8a44051..659536d00cb9 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/kernel.h>
+#include <linux/fs_parser.h>
 
 #include "bcachefs.h"
 #include "compress.h"
@@ -322,6 +323,18 @@ int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf *err)
 	return 0;
 }
 
+static const struct constant_table bch2_opt_bool_names[] = {
+	{ "0",		false },
+	{ "false",	false },
+	{ "no",		false },
+	{ "off",	false },
+	{ "1",		true },
+	{ "true",	true },
+	{ "yes",	true },
+	{ "on",		true },
+	{ },
+};
+
 int bch2_opt_parse(struct bch_fs *c,
 		   const struct bch_option *opt,
 		   const char *val, u64 *res,
@@ -332,17 +345,18 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
-			ret = kstrtou64(val, 10, res);
+			ret = lookup_constant(bch2_opt_bool_names, val, BCH_ERR_option_not_bool);
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
2.46.2

