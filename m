Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E9212DD88
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729708579; cv=none; b=nGS78aPsaxkiNi+1/+k8ymu39w532EeHM3gqOlSdT96yID37Geq0I0LRYEY+cB5n/0LZUGRzjWz1ZXjm7888QpzqX+jP4glxKTbUWdE02wcugN5D64JEiJS97n8Al8W9YeAQaiERlQUop70JYH/J0+hAXUkjln5UbHso4xYZcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729708579; c=relaxed/simple;
	bh=uwuf4ezi2W2PdaQXgW2PskvY5lVlpMDiLbN2Bqvv9NY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+xkDFnO5PzvNERYsb9OLwxI4KC66v7ltf4kZ3EgY/geBeB+IGBDwKwk5izmiDM6ptRxXaEIIURHs0VCrga3LpqbcAkTorBhLqh898zZTUkMCK4fngGAIWB83RXTtju3cRn2RvcRYX0mdF8f9pMDz9LZNAaSMWIztbVCjadmhFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJdC/3QQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJdC/3QQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2041AC4CEC6;
	Wed, 23 Oct 2024 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729708579;
	bh=uwuf4ezi2W2PdaQXgW2PskvY5lVlpMDiLbN2Bqvv9NY=;
	h=From:To:Cc:Subject:Date:From;
	b=rJdC/3QQZhlQVI5y5roBY7fo3BR4K+y8/TyGcTQ9JgrVCvF/PsB90v4VfbbVQ4NHN
	 SV8ryRTKWheK74zV6m3AEhttQEX+hpYB04b8EavHgcfAUZ+aOgbQUMz+OOhQoizPts
	 Zud3z1NKMZTuWiqE71GNoFJV1lnPmJrvU+gGtsBat9ZfoVXCEB+zIDlhytSc5jRw9A
	 c8nouHBRPLCqHmMQg23ZLrJ+aBpdVS/ytND52DIDifpbiXsFFMtoppqAg0wOWdLz7U
	 JMYBvOJ6e3ChelZcU/jr4JiKDcLl3hb/DTMh+vTJ/ZYZcx96qtdr0fkE5Gt39pG3yn
	 oxpHXFTMAaTnA==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>
Subject: [PATCH] bcachefs: Explicitly select CRYPTO from BCACHEFS_FS
Date: Wed, 23 Oct 2024 18:35:21 +0000
Message-ID: <20241023183521.3752681-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Explicitly select CRYPTO from BCACHEFS_FS, so that this dependency of
CRYPTO_SHA256, CRYPTO_CHACHA20, and CRYPTO_POLY1305 (which are also
selected) is satisfied.  Currently this dependency is satisfied
indirectly via LIBCRC32C, but this is fragile and is planned to change
(https://lore.kernel.org/r/20241021002935.325878-13-ebiggers@kernel.org).

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410232254.ogS6Em2d-lkp@intel.com/
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index 5bac803ea367c..a61b22c142a19 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -13,10 +13,11 @@ config BCACHEFS_FS
 	select LZ4HC_DECOMPRESS
 	select ZLIB_DEFLATE
 	select ZLIB_INFLATE
 	select ZSTD_COMPRESS
 	select ZSTD_DECOMPRESS
+	select CRYPTO
 	select CRYPTO_SHA256
 	select CRYPTO_CHACHA20
 	select CRYPTO_POLY1305
 	select KEYS
 	select RAID6_PQ

base-commit: 42f7652d3eb527d03665b09edac47f85fb600924
-- 
2.47.0.163.g1226f6d8fa-goog

