Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE4920ADD7
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 07:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397691; cv=none; b=VC7sYzPB1MqomcsYDIvajQnKO37whb1+8+oxkbDio7sYwRWaQvJkfyZQ8zcEe6w5vzQiTbVKOeSLZbbUMWFUxSznF5YrP1GuraGySKFWAAqvSksBpItKQf7tQoPPBjUtCieVjJyRJSsAswir2bt2VDI7TlyzSihxGnoXmh1VtZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397691; c=relaxed/simple;
	bh=N2J3t3PqeiMO2PFQNUAOUQPWvev6v9J9NdG+yO+ShcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TImkoifAJCcT0qKGixiNYT4PbcgQvdQl36G7Bxp2QPuzrHKt8H9WcL3zd98MxPXNUSyZy+4jM0smg9hnca61JUxt5DISc18ANvvLgkzvzXOwSYBGJrE0zUXrIEe3MpYGFdheh0xmneZ0wg0/7jXxhVbcckSRdscd3YC3aA4vGV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Xndl91wkRzpZKW;
	Tue, 12 Nov 2024 15:46:13 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A571180115;
	Tue, 12 Nov 2024 15:48:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 12 Nov
 2024 15:48:06 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 3/3] bcachefs: use printbuf_err helper
Date: Tue, 12 Nov 2024 15:47:45 +0800
Message-ID: <20241112074745.407848-4-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112074745.407848-1-lihongbo22@huawei.com>
References: <20241112074745.407848-1-lihongbo22@huawei.com>
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

Obtain printbuf failure status with printbuf_err helper.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c  | 7 +------
 fs/bcachefs/sysfs.c | 4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 83f55cf99d46..cdef7a886695 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -543,12 +543,7 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 	ret = bch2_opt_parse(c, &bch2_opt_table[id], val, &v, &err);
 	if (ret == -BCH_ERR_option_needs_open_fs && parse_later) {
 		prt_printf(parse_later, "%s=%s,", name, val);
-		if (parse_later->allocation_failure) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		ret = 0;
+		ret = printbuf_err(parse_later);
 		goto out;
 	}
 
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 97733c766948..70084b646511 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -63,9 +63,7 @@ static ssize_t fn ## _show(struct kobject *kobj, struct attribute *attr,\
 	if (out.pos && out.buf[out.pos - 1] != '\n')			\
 		prt_newline(&out);					\
 									\
-	if (!ret && out.allocation_failure)				\
-		ret = -ENOMEM;						\
-									\
+	ret = ret ?: printbuf_err(&out);				\
 	if (!ret) {							\
 		ret = min_t(size_t, out.pos, PAGE_SIZE - 1);		\
 		memcpy(buf, out.buf, ret);				\
-- 
2.34.1

