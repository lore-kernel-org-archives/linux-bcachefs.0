Received: from mail2.ecloud.global (mail2.ecloud.global [135.181.6.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B21487D6
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 10:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.6.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729677653; cv=pass; b=Jk+XwF5NQlMxSSRGB7lfe18d60jxKdzSdzcLeI+LQW/UXdNaBSZdvD//MsflAon7Po85kHbqr2pZ2c7w10vA4WynJk6O3kX/JZ3I+6RVxXqEBXte73eEUtJdNw03rjb/mWv/gs16PZSz4WQEGHR52ZBqNITYm+qzzGRXJcZb7RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729677653; c=relaxed/simple;
	bh=Hzl1IpvuLnP1buw24z+kIcyvRQqZLOlzxcb9m/z0/C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umcGxM9JQsMh6zNUc8thkoLF3ZcS39qEqPMttrlgVi3MCf9cyaFIabifalL232QECy4d+iWeYC46lJGJe027he68lpH50+TKynB3v/UHjbFxPkyAxVZO2ON+OoxQ+uzbot3xcmHcTKke5pOthl0ACYj3WVB3QCJm/5ZdeMUqpa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=sWsYJY9+; arc=pass smtp.client-ip=135.181.6.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="sWsYJY9+"
Received: from authenticated-user (mail2.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail2.ecloud.global (Postfix) with ESMTPSA id 179C77205FA;
	Wed, 23 Oct 2024 10:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail2;
	t=1729677648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbV/81pJQUFeVNvITNOiBdJo9NzRtzSJOGcRWC2BCWU=;
	b=sWsYJY9+pGsMNAGBsMT3wqAhLILJuIph6Frocjy/l2+4kUpIorYyvm6VXUKbrMPmBmRZ8b
	dRhgWVfRha2Rg2u5uNYi7s4tHpVbXJYXNEDcAAy3eXHvvcWzbg3Q/dGUhfsneXZgUQtQ66
	/TlAimLFXlcc2naJiSwsIM90KwrLJ2I=
ARC-Seal: i=1; s=mail2; d=murena.io; t=1729677648; a=rsa-sha256; cv=none;
	b=nb2OrmdWHz4WKzvwmmIXXagmyfqj4tg3C+NMTg3YLTjOsnZ4zIdw5IVy7hXDB41tnktLZ+
	93twFzktF2+P3/ur9sMWApsTa/H7JDOkwe8QG+XA+acql84qRzG/JO5ozb9c2LXFmo40lK
	0HY6C+ERpH+ZbI7SRjvjDg+3GiPGXiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail2; t=1729677648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbV/81pJQUFeVNvITNOiBdJo9NzRtzSJOGcRWC2BCWU=;
	b=rDeXYyK1TQyE+ZFh/pB8xy5YBor3V9/UoYYSmdekG0Ok4JTHSP7pSRFUY25Co1JAUbjjxb
	8cBmFMeq4ms9VSF7qfzfnFAjuZfTLRluWMJ/pKl4lr21fLv52QaYnBDg86TRFECJxzdM3y
	BJlQLGyrKjv/dPSvzcg9gtG4yo8mzRw=
ARC-Authentication-Results: i=1;
	mail2.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
From: Integral <integral@murena.io>
To: mmpgouride@gmail.com
Cc: integral@murena.io,
	kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v5] bcachefs: add support for true/false & yes/no in bool-type options
Date: Wed, 23 Oct 2024 18:00:33 +0800
Message-ID: <20241023100033.166289-1-integral@murena.io>
In-Reply-To: <C427A74E-0AE3-48F6-A47C-633E54949379@gmail.com>
References: <C427A74E-0AE3-48F6-A47C-633E54949379@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the patch which uses existing constant table:

Currently, when using bcachefs-tools to set options, bool-type options
can only accept 1 or 0. Add support for accepting true/false and yes/no
for these options.

Signed-off-by: Integral <integral@murena.io>
---
 fs/bcachefs/opts.c | 18 +++++++++++-------
 fs/fs_parser.c     |  3 ++-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 68d240126522..b564c42d62f8 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/kernel.h>
+#include <linux/fs_parser.h>
 
 #include "bcachefs.h"
 #include "compress.h"
@@ -322,6 +323,8 @@ int bch2_opt_validate(const struct bch_option *opt, u64 v, struct printbuf *err)
 	return 0;
 }
 
+extern const struct constant_table bool_names[];
+
 int bch2_opt_parse(struct bch_fs *c,
 		   const struct bch_option *opt,
 		   const char *val, u64 *res,
@@ -332,17 +335,18 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
-			ret = kstrtou64(val, 10, res);
+			ret = lookup_constant(bool_names, val, -BCH_ERR_option_not_bool);
+			if (ret != -BCH_ERR_option_not_bool) {
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
diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index 24727ec34e5a..6521e9a9d6ef 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -13,7 +13,7 @@
 #include <linux/namei.h>
 #include "internal.h"
 
-static const struct constant_table bool_names[] = {
+const struct constant_table bool_names[] = {
 	{ "0",		false },
 	{ "1",		true },
 	{ "false",	false },
@@ -22,6 +22,7 @@ static const struct constant_table bool_names[] = {
 	{ "yes",	true },
 	{ },
 };
+EXPORT_SYMBOL(bool_names);
 
 static const struct constant_table *
 __lookup_constant(const struct constant_table *tbl, const char *name)
-- 
2.47.0

