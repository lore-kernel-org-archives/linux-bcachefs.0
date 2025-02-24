Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246521B21BF;
	Mon, 24 Feb 2025 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740378907; cv=none; b=VQY356pE16lEUwFr9qXFTWZWrc7dCGBz34oSJKHgAzm3zycbhLeaXKo/3HYLmD1uwLHhnYEnmfVy078sNZmzb/k/1ExYgPtgW/KWL5lotoMqO0ElXSocRya8FhudDgNF+YkYZHcYvj6cg80C6FmhGwBEIp5BdnBeQX6Lc7CroAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740378907; c=relaxed/simple;
	bh=2Tey6aVfTe7o6nfJgADzLeBkJOJSsPqxYx+SzO+wDT4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=B1bIjqtRpzu8jdHfNgKfKtdx4wNLbGcxMYo2OIpWycWURU45BEVc0TcT80//KSMth5c3fcRQYvJ1KXGiVHnQ8LOAhExZURd3ocV5UVYvXUw5JTlWzZl0PBelIlfxW0T/9OKiXRumQkaeMXanhN4AqxsHy5R9a0PbXsXEyDnFyXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eSxEe7vl; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eSxEe7vl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740378895; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=eIBURKnXosIPXGshxYjASprz6Rzs5J0/YOJzkdNmzis=;
	b=eSxEe7vlV8EzYn3o9Rp4qEa3yG8f3M0JK0M1V+6dysey6fh8MBRLOG+jAovWE+RXIgawNofQqHOd1f7+Y8vP8JC6ao/dG2nUGLHhBShE/ifE5Kgoj2rQ2+vYpc7wCzUnnKj7sMBLzu1zQc/M4ToIlKXqKzoD+J7sJef/QhZZJmA=
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WQ3dpwL_1740378886 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 24 Feb 2025 14:34:54 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove the unused variable block_size
Date: Mon, 24 Feb 2025 14:34:45 +0800
Message-Id: <20250224063445.34991-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Variable block_size is not effectively used, so delete it.

fs/bcachefs/super-io.c:369:6: warning: variable ‘block_size’ set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=19045
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/bcachefs/super-io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 0edc8814eb7e..ab99a2fb9356 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -366,7 +366,6 @@ static int bch2_sb_validate(struct bch_sb_handle *disk_sb,
 	struct bch_sb *sb = disk_sb->sb;
 	struct bch_sb_field_members_v1 *mi;
 	enum bch_opt_id opt_id;
-	u16 block_size;
 	int ret;
 
 	ret = bch2_sb_compatible(sb, out);
@@ -385,8 +384,6 @@ static int bch2_sb_validate(struct bch_sb_handle *disk_sb,
 		return -BCH_ERR_invalid_sb_features;
 	}
 
-	block_size = le16_to_cpu(sb->block_size);
-
 	if (bch2_is_zero(sb->user_uuid.b, sizeof(sb->user_uuid))) {
 		prt_printf(out, "Bad user UUID (got zeroes)");
 		return -BCH_ERR_invalid_sb_uuid;
-- 
2.32.0.3.g01195cf9f

