Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755D274C1B
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 07:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721287218; cv=pass; b=PW5yyp0Q8MwuMbULgrE7R/fG79pcSObs+wtksqTc/z5ao7XTWlmpKxxyD7EqXXegkeQ3svfrp0yARWUJV/B52T4S4FXatzCAc1yYGYoKCwdcorj2+TqS2wZFWv53nr8BrcEF2c4t0mI+YFZGK8jZFIAfdVRnKj4TtDeC1sQwpy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721287218; c=relaxed/simple;
	bh=suGeRIyHaNiCXSbnAxuAyrsiFtNmKgy7hGa2GxORKVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lx/bKHgAao2jDuXkUQSHDvW8JTeOEoRBhieRFCXV/KTxWnEGUeZ5lsWYd3liMlwFpshWt1s0L6CEjl9OQxeQ9QKGq/o57dSO8Z/Q975a/DOYt1kjk1uyxgqWwjEFzkWLctZtDUFKZQT8a2TkJSJLE1TN2BSoEsV00RvwaPuW1KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=MdJXQnRE; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="MdJXQnRE"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id AA33888471B;
	Thu, 18 Jul 2024 07:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1721287214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OUDD5yJ5ezVXZtzcgJgyOa86VUFGFeUJX5/rtgCxgfw=;
	b=MdJXQnRE8hniIy65rYRMzH0XejKB4s4uMkFJUh0GhcPDec93dnnroeWlZSb1dwHQxxSl0/
	kcmyGEqqHIyRRIG3mAnXnjMcwS5T1f1k/E5IvLu+PEker30eVCy0f4J7wpkS3Yg7wyPLjj
	vnbKZy6sMhVHRAVdCSmtGyBEAHVAgGk=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1721287214; a=rsa-sha256; cv=none;
	b=9icqbqXhpYlkLuLil30l+l3kSyXcR+7+9GeY7JtZ5YTTTLjdB8sEKQ3l6a7wvaLQGjJnu3
	1H93Ygk/zifpJnX3gXkpQe1Lgv5ED8bv6FQMrWp6CstfqmWmt93xDSaaiMfcjyUuni7NRL
	DLfuJVg8yNwSq6Bqjn6lkkQgQ4HNyJM=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1721287214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OUDD5yJ5ezVXZtzcgJgyOa86VUFGFeUJX5/rtgCxgfw=;
	b=TNs171/3eJzlJ4+LXm/OLa9QcusPuJID+wBRB2cEFF0H9Ln84qYWAQvCBCRxOjaOu+zMKg
	odsBaIohh4vEou5SvpkMo8Tbs+y0vOQ5pdAAiJIoGHHZd0dmx+ngRfbj0bD/8UJzzure0t
	4TN4ZJ1MjRQQNW3X8kEWfs8rr9XueRc=
From: Integral <integral@murena.io>
To: kent.overstreet@gmail.com
Cc: linux-bcachefs@vger.kernel.org,
	Integral <integral@murena.io>
Subject: [PATCH] libbcachefs: add support for true/false & yes/no in bool-type options
Date: Thu, 18 Jul 2024 15:13:48 +0800
Message-ID: <20240718071346.68754-3-integral@murena.io>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a resend of my previous patch with code style optimized as I
forgot to add Kent Overstreet in "To". The previous patch is
(https://lore.kernel.org/linux-bcachefs/20240718062835.58037-2-integral@murena.io/T/#u).

Currently, when using bcachefs-tools to set options, bool-type options can
only accept 1 or 0. Add support for accepting true/false and yes/no for
these options.

---
 libbcachefs/opts.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/libbcachefs/opts.c b/libbcachefs/opts.c
index 0770aebe..e6ebc4c1 100644
--- a/libbcachefs/opts.c
+++ b/libbcachefs/opts.c
@@ -332,17 +332,19 @@ int bch2_opt_parse(struct bch_fs *c,
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 		if (val) {
-			ret = kstrtou64(val, 10, res);
+			if (!strcmp(val, "1") || !strcmp(val, "true") || !strcmp(val, "yes")) {
+				*res = 1;
+			} else if (!strcmp(val, "0") || !strcmp(val, "false") || !strcmp(val, "no")) {
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

