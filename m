Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1925E1F5FA
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Apr 2024 10:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830120; cv=none; b=DUTRsBVGIPc5/KOS6DAQWPCrAw1sJKXjtCAi5sGP5Aj3keXwVpNJyBwilQNr0rW4k5IuyAY3rzcF/9TyaKC+aE/C6Pol7nQM1GibLb9rDKn1IF/OtX0vL5q2m4gnXL0pVvosjYrfEOPs7kaYrq2Ggi6I0VfVYQ4Sl3qafgjJFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830120; c=relaxed/simple;
	bh=wbpx9glS3fE6bDQi+XOp0Gcwc7b4T5B2mgOBzsiuCl4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pkoX/JMJ4TbWtx/EeWC2YdIZ343T4WzabWnpA01t/YzoSZU/vICHB6PvPGsP9vbbFvyNh8oFLta0JVusRdWYFGNsyyi+gZRWT6uoumibBoVZyB0Tql4+tAHXtTOdlPz2bZPNxdrFaKuImSSjFH3ZOuydYhILHocqRgI2ZAuodjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1KA/vfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1KA/vfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F061C433C7;
	Thu, 11 Apr 2024 10:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712830119;
	bh=wbpx9glS3fE6bDQi+XOp0Gcwc7b4T5B2mgOBzsiuCl4=;
	h=From:To:Cc:Subject:Date:From;
	b=T1KA/vfVy+JMYTXNqvJxoTfahOcTbh4TZMOgy+bTaf9sH5x7757x6IVGLDGVjgEHE
	 Q92a7F1uhEJGrDA836Mo3npYaLMij1dEwWs2nOKlkwOWe33iikbuo4JphQwbZ+9RFG
	 hBF3Uuin/yeG0a2t7+UvvaYueQLPTgSmg6H5bcWFD9g4XJwVf6zRC1n4zJ1OVJtMrD
	 ikx8YZRte8Sd5gJK/lcIcgWMBfmwmJ4wdaDw+poyZPDQmbJ48TY8PCDMdmPES2TtWy
	 cgNxs1VoVvL+Hegh1SQMZlF3PgCLiXlNhKpyw/Ecmu79qsu/+sQauhAgvL1kVd2Yq1
	 flxQ3Z4+UTafA==
From: Chao Yu <chao@kernel.org>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org,
	Chao Yu <chao@kernel.org>
Subject: [PATCH] bcachefs: fix error path of __bch2_read_super()
Date: Thu, 11 Apr 2024 18:08:29 +0800
Message-Id: <20240411100829.1729332-1-chao@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In __bch2_read_super(), if kstrdup() fails, it needs to release memory
in sb->holder, fix to call bch2_free_super() in the error path.

Signed-off-by: Chao Yu <chao@kernel.org>
---
 fs/bcachefs/super-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index ad28e370b640..cec1470c2dd9 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -698,8 +698,10 @@ static int __bch2_read_super(const char *path, struct bch_opts *opts,
 		return -ENOMEM;
 
 	sb->sb_name = kstrdup(path, GFP_KERNEL);
-	if (!sb->sb_name)
-		return -ENOMEM;
+	if (!sb->sb_name) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 #ifndef __KERNEL__
 	if (opt_get(*opts, direct_io) == false)
-- 
2.40.1

