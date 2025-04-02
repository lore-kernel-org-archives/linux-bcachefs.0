Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917DE13C81B
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611037; cv=none; b=JC1cKf2TDdThCegQhI89gfT3mcBCW93dLW/c3wkYznKXPOdXXwLzJGpspAVvQnlGpu2yVzQYC+Cad9HGV7nLadZ+NhHOxaQ3EC6dSDQu/6N/deLwjcg4YneoZ5t/7lt5w2CLgzkPtRt74i8Dkb8DFQ4thyRfqqD6sswOo0o1uIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611037; c=relaxed/simple;
	bh=B++9aZS3unT/v1fEPr7f9OKF8uO94exKlDHthKWUUdo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RVBiWRmNl3zyqlF8VzxE2aYWGgcJD7a0bpQAU+3aRLzDXuwzOu55e8XjSqvnYmBPFM1LXNhGu6bj3HyR6O0A5KgLhX5pHbGtEk65fkQ+im5UbEKx1mXwrU/PEqnQ5iJeELyvrXePCyHQrQzBKV45gyE7m83C56zXyZqSwbTnQbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R87rVGac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R87rVGac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903F9C4CEDD;
	Wed,  2 Apr 2025 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743611036;
	bh=B++9aZS3unT/v1fEPr7f9OKF8uO94exKlDHthKWUUdo=;
	h=From:To:Subject:Date:From;
	b=R87rVGacqMD34WT7sxB3lsmWvLpATmcKcAoK63HaJz5c1XjjglPn347rXMil61K0z
	 gdc9DAdY+0dVSMbZyFBLAMIH+zuyXovcCVQTvncBRXpxOXrg2Ka4tKoonZdfFZMQbY
	 7bmdYSh9lNbd/orvMC16HmSa69vnNLXd/hCRfoyZwwnsWVkmiGxiLMKe+edybahY8U
	 c4wbFBt2oJAwYlGdqWpD7UBQDgSQWtZHEGa1b2NxtYXNq5rNuPw86/YNTTHBqtRoYf
	 xW8ysgvPl1467hGoWuOrCrjBzNXNxTauqWsFKUR+nKgSh51Hbyhb8nQlkEjj1TNyzP
	 k+yXBk96ywWWg==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Remove unnecessary softdep on xxhash
Date: Wed,  2 Apr 2025 09:23:38 -0700
Message-ID: <20250402162338.24424-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

As with the other algorithms, bcachefs does not access xxhash through
the crypto API.  So there is no need to use a module softdep to ensure
that it is loaded.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 7b3716a9e6cb7..1941b656f4103 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -72,11 +72,10 @@
 #include <linux/sysfs.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
 MODULE_DESCRIPTION("bcachefs filesystem");
-MODULE_SOFTDEP("pre: xxhash");
 
 const char * const bch2_fs_flag_strs[] = {
 #define x(n)		#n,
 	BCH_FS_FLAGS()
 #undef x

base-commit: 04c4768d24f70d457ff49681ef726d5d23c089a5
-- 
2.49.0

