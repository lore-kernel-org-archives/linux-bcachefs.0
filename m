Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C894A3E
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 05:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729660534; cv=pass; b=lsZr6apArzpJAJu18WayheNG3mTzy5ResDd4s+u4gQsQ3T+Th6LkX5Q2i/NJijW3IJ3N9xEznY+fBaMB++cykDgX+6jT7NwmdOZ9gFJJGZf4f+b886tx0vaVp3ggJZCqb0KqTJdK5Msz1t7ybtAT+Nt1e4x6taOsfkgCoAgOoFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729660534; c=relaxed/simple;
	bh=CWyTOZYOuMa/EmnQTI9XH26t5T3YA+Bsp4QRMpooj8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNthI46WoXMmvNub02hbKFJ8p3V7nS9TEnhGZfHQXodw+1FB73cE9TlHQscciy07JIsFwbpi8HILSeM0CK1fiSjaz9exjVhJIidxiwVRZ/VkOziR6LLVFtgvfMBW/JhoXyXUQnmIIFPPW89oiZEJwodCuZWFQDUc+Whj2RJ3RDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=l9ooGUZU; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="l9ooGUZU"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id ED55E881527;
	Wed, 23 Oct 2024 05:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1729660529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8zM+0zzZMDKGtast45PbCUJXeNAfGmAc3LvY110Ts8=;
	b=l9ooGUZUbHBJ1PZpf1aHm7VRxGBut5Y3tTL4SJJiPEeIGBndkb7lvRKmWpDrowPXo+L1Ha
	31DEGj/UAVN2TVrHeb7+FXhUhoDjZg/p/xmOQuKI5LzgPtyWLXl0sGBeOXn9vKejKqegaI
	DoqLQfaov/YF4K/qWox3MZRqEFQhX3I=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1729660529; a=rsa-sha256; cv=none;
	b=dtCgPNwThMTg/aJC69qwpJLX82DVwjPXyssBXslGl28w2guP0QQgjtqCLcuMc3kKwsn2Zi
	Bn2SLGgBY29dBnvRyrU9Yjfk5C3sM/N+KLvBJwGAFinDRL4ZCDYXX4hKckacfDRWBsbfN9
	NVlZ1xeNwDb+96l0ha/6DFn+GOC1UUM=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1729660529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8zM+0zzZMDKGtast45PbCUJXeNAfGmAc3LvY110Ts8=;
	b=S3Mbc2aSYsuc3fgiq5ol0asrrHFtaf1Xk/up9G/LSTkc0O1sNntp8wSvhVtZTI4mU6HxH7
	XQMqd04CsOPFReUPgium7murPUruX0DP6cM2q6ts3PpgED98It4ny+6zRDUkGVmyRJqJ1K
	TzTmYLSffhDdVYpY3n/TZq+SaEI0tQ4=
From: Integral <integral@murena.io>
To: lihongbo22@huawei.com
Cc: integral@murena.io,
	kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	mmpgouride@gmail.com
Subject: [PATCH v4] libbcachefs: add support for true/false & yes/no in bool-type options
Date: Wed, 23 Oct 2024 13:15:05 +0800
Message-ID: <20241023051504.59321-2-integral@murena.io>
In-Reply-To: <916cace5-ecf5-426d-a215-17e1107fef88@huawei.com>
References: <916cace5-ecf5-426d-a215-17e1107fef88@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is my latest patch:

Currently, when using bcachefs-tools to set options, bool-type options
can only accept 1 or 0. Add support for accepting true/false and yes/no
for these options.

Signed-off-by: Integral <integral@murena.io>
---
 fs/bcachefs/opts.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 68d240126522..2d81e39ddd73 100644
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
-- 
2.47.0

