Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15A9192B71
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Oct 2024 01:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730252692; cv=none; b=Cmrp6Jqygz1PLXOFEtUiitPLFPHb5i/1MJrSWzid0TKm9NgGxn2T/MIZE+tg6Giooa7mXQQDoIuRkxEdgherjWYIPty8+0lIvWPt3s9uTSuDxK8MlfiWFfK2FuK/Ra/VswIZ+ITw0+bOtTPPzWdPo9bVo44tGs83RfTEgbeXmmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730252692; c=relaxed/simple;
	bh=HlT1MnkFVEP0AxA08aYGDi7MMVaTawplWk1GWu00UfI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gBmkerrcwxR3eSc/kPnNorUa2QQL/+HaC2w56ka3Ki5LD03GI4mVY6MEI4V1+FhjRWxrXtVpdED4ji2xqj+KM1xN7MjsSaHODWa1UlVwBI6zZapvqcAh4AYDVE7G8X/k54ThklCRIfeWbs/3tSLZnAyB71ogKPlJWaBeND6XIaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XdVJK0krHz2DbYb;
	Wed, 30 Oct 2024 09:43:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BB8EC1A0188;
	Wed, 30 Oct 2024 09:44:44 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 09:44:44 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: move sysfs macro from util to sysfs
Date: Wed, 30 Oct 2024 09:44:15 +0800
Message-ID: <20241030014415.405869-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The macro of sysfs_pd_controller_xxx are only used for sysfs, move
them into sysfs.c.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/bcachefs/util.h  | 36 ------------------------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 50c9743306a2..cdf124c5c9ec 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -138,6 +138,42 @@ do {									\
 	_v;								\
 })
 
+#define sysfs_pd_controller_attribute(name)				\
+	rw_attribute(name##_rate);					\
+	rw_attribute(name##_rate_bytes);				\
+	rw_attribute(name##_rate_d_term);				\
+	rw_attribute(name##_rate_p_term_inverse);			\
+	read_attribute(name##_rate_debug)
+
+#define sysfs_pd_controller_files(name)					\
+	&sysfs_##name##_rate,						\
+	&sysfs_##name##_rate_bytes,					\
+	&sysfs_##name##_rate_d_term,					\
+	&sysfs_##name##_rate_p_term_inverse,				\
+	&sysfs_##name##_rate_debug
+
+#define sysfs_pd_controller_show(name, var)				\
+do {									\
+	sysfs_hprint(name##_rate,		(var)->rate.rate);	\
+	sysfs_print(name##_rate_bytes,		(var)->rate.rate);	\
+	sysfs_print(name##_rate_d_term,		(var)->d_term);		\
+	sysfs_print(name##_rate_p_term_inverse,	(var)->p_term_inverse);	\
+									\
+	if (attr == &sysfs_##name##_rate_debug)				\
+		bch2_pd_controller_debug_to_text(out, var);		\
+} while (0)
+
+#define sysfs_pd_controller_store(name, var)				\
+do {									\
+	sysfs_strtoul_clamp(name##_rate,				\
+			    (var)->rate.rate, 1, UINT_MAX);		\
+	sysfs_strtoul_clamp(name##_rate_bytes,				\
+			    (var)->rate.rate, 1, UINT_MAX);		\
+	sysfs_strtoul(name##_rate_d_term,	(var)->d_term);		\
+	sysfs_strtoul_clamp(name##_rate_p_term_inverse,			\
+			    (var)->p_term_inverse, 1, INT_MAX);		\
+} while (0)
+
 write_attribute(trigger_gc);
 write_attribute(trigger_discards);
 write_attribute(trigger_invalidates);
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index fb02c1c36004..7712a8a0937d 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -275,42 +275,6 @@ void bch2_pd_controller_update(struct bch_pd_controller *, s64, s64, int);
 void bch2_pd_controller_init(struct bch_pd_controller *);
 void bch2_pd_controller_debug_to_text(struct printbuf *, struct bch_pd_controller *);
 
-#define sysfs_pd_controller_attribute(name)				\
-	rw_attribute(name##_rate);					\
-	rw_attribute(name##_rate_bytes);				\
-	rw_attribute(name##_rate_d_term);				\
-	rw_attribute(name##_rate_p_term_inverse);			\
-	read_attribute(name##_rate_debug)
-
-#define sysfs_pd_controller_files(name)					\
-	&sysfs_##name##_rate,						\
-	&sysfs_##name##_rate_bytes,					\
-	&sysfs_##name##_rate_d_term,					\
-	&sysfs_##name##_rate_p_term_inverse,				\
-	&sysfs_##name##_rate_debug
-
-#define sysfs_pd_controller_show(name, var)				\
-do {									\
-	sysfs_hprint(name##_rate,		(var)->rate.rate);	\
-	sysfs_print(name##_rate_bytes,		(var)->rate.rate);	\
-	sysfs_print(name##_rate_d_term,		(var)->d_term);		\
-	sysfs_print(name##_rate_p_term_inverse,	(var)->p_term_inverse);	\
-									\
-	if (attr == &sysfs_##name##_rate_debug)				\
-		bch2_pd_controller_debug_to_text(out, var);		\
-} while (0)
-
-#define sysfs_pd_controller_store(name, var)				\
-do {									\
-	sysfs_strtoul_clamp(name##_rate,				\
-			    (var)->rate.rate, 1, UINT_MAX);		\
-	sysfs_strtoul_clamp(name##_rate_bytes,				\
-			    (var)->rate.rate, 1, UINT_MAX);		\
-	sysfs_strtoul(name##_rate_d_term,	(var)->d_term);		\
-	sysfs_strtoul_clamp(name##_rate_p_term_inverse,			\
-			    (var)->p_term_inverse, 1, INT_MAX);		\
-} while (0)
-
 #define container_of_or_null(ptr, type, member)				\
 ({									\
 	typeof(ptr) _ptr = ptr;						\
-- 
2.34.1

