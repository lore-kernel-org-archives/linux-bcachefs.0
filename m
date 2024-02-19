Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171AA2DF84
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708345529; cv=none; b=kkoRyB3l8GdPdPXcKdB4HWybRl9yAzSaAPrJZ/7QnORzS6Rin2Qnj7wy9ssf2FIQHihXkA0RQjmPM/a6lPjYqgU42lIrx/guYZM3yVG0P5tNId3bjw4y79mPDQvk8zrBaYvnSBZM4iHE73Mdd+CXn74IZVGB+ZMMtT58eh9uXf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708345529; c=relaxed/simple;
	bh=jQmHISUloylPArDeVQiRujMmzubR2y02ILuqvBg9z+g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dUXYwM68PRJL5y6MbIE5myYB8/yYZ01Lc0/lb9UnWoYfFhYdnsgo6bSci68zGoXgwO7oSJpcR+JdL248NRy9xzBH0tFI1el8WVYvfnVmacmx/FbTDvWZXbchLmPdP24yq39jxqcau9RsQkKTgYzFCF9yKzSJ9V7dPzUTObTs6zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4TdhYl692Tzqjgv;
	Mon, 19 Feb 2024 20:24:43 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 330531400CB;
	Mon, 19 Feb 2024 20:25:17 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 19 Feb
 2024 20:25:16 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>,
	<ruanjinjie@huawei.com>, <lihongbo22@huawei.com>
Subject: [PATCH v2] bcachefs: fix the error code when mounting with incorrect options.
Date: Mon, 19 Feb 2024 20:24:32 +0800
Message-ID: <20240219122432.2570083-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

When mount with incorrect options such as:
"mount -t bcachefs -o errors=back /dev/loop1 /mnt/bcachefs/".
It rebacks the error "mount: /mnt/bcachefs: permission denied."
 cause bch2_parse_mount_opts returns -1 and bch2_mount throws
it up. This is unreasonable.

The real error message should be like this:
"mount: /mnt/bcachefs: wrong fs type, bad option, bad
superblock on /dev/loop1, missing codepage or helper program,
or other error."

Adding three private error codes for mounting error. Here are:
  - BCH_ERR_mount_option as the parent class for option error.
  - BCH_ERR_option_name represents the invalid option name.
  - BCH_ERR_option_value represents the invalid option value.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
Thanks for reviewing my patch. Here is my new changelog:

v2:
 - return private error codes for internal functions.
v1: https://lore.kernel.org/linux-bcachefs/b3edruyblko7tbpbbpftov75tmnmwir4mx7m2mwpdzzaylt3av@ttwlfwzzoc6s/T/#t
---
 fs/bcachefs/errcode.h | 3 +++
 fs/bcachefs/fs.c      | 4 +++-
 fs/bcachefs/opts.c    | 6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index fe3fc14d3c9a..3653ff2c0c12 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -5,6 +5,9 @@
 #define BCH_ERRCODES()								\
 	x(ERANGE,			ERANGE_option_too_small)		\
 	x(ERANGE,			ERANGE_option_too_big)			\
+	x(EINVAL,			mount_option)				\
+	x(BCH_ERR_mount_option,		option_name)				\
+	x(BCH_ERR_mount_option,		option_value)				\
 	x(ENOMEM,			ENOMEM_stripe_buf)			\
 	x(ENOMEM,			ENOMEM_replicas_table)			\
 	x(ENOMEM,			ENOMEM_cpu_replicas)			\
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 093f5404a655..3f073845bbd7 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1870,8 +1870,10 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 	opt_set(opts, read_only, (flags & SB_RDONLY) != 0);
 
 	ret = bch2_parse_mount_opts(NULL, &opts, data);
-	if (ret)
+	if (ret) {
+		ret = bch2_err_class(ret);
 		return ERR_PTR(ret);
+	}
 
 	if (!dev_name || strlen(dev_name) == 0)
 		return ERR_PTR(-EINVAL);
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b1ed0b9a20d3..1db11c15b2b9 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -456,7 +456,7 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 
 	copied_opts = kstrdup(options, GFP_KERNEL);
 	if (!copied_opts)
-		return -1;
+		return -ENOMEM;
 	copied_opts_start = copied_opts;
 
 	while ((opt = strsep(&copied_opts, ",")) != NULL) {
@@ -501,11 +501,11 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 
 bad_opt:
 	pr_err("Bad mount option %s", name);
-	ret = -1;
+	ret = -BCH_ERR_option_name;
 	goto out;
 bad_val:
 	pr_err("Invalid mount option %s", err.buf);
-	ret = -1;
+	ret = -BCH_ERR_option_value;
 	goto out;
 out:
 	kfree(copied_opts_start);
-- 
2.34.1

