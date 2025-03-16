Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C14A2E3362
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742094254; cv=none; b=gJ/9VZTKkO4mkiYl0TrahpqqsJ0Yx4O4rOYujRZO7ZqSV8rv5ngAGS1fl3aJq/2jOJIea95/8gNFHk7x8StlL8VNMvjnpdvGM7yFNvd6zpV5aklGmndWparwiruunz8szYVGMkXcXWDKYe6OIbUY3l926SzgqFBvynRPJC/uA5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742094254; c=relaxed/simple;
	bh=VDEzFq3lQWptFywuq8O7zDOkP6nzA5QK94P82Ok9u4Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ub/wm6N9JItitnZ3rVN3c5ZC1Nv+mr5i5jJl2KdvLS+6kgtTpvWCUftabVSgCjBhHKQJ3s//oaNBFVi5Sszl8ZhXavl9PkLMC+k3wJMbIs2CdNduzHVNKe72/nsHlafioM46PEd2bfb1ZzEt9oG3XyzTToe/cXwFwO5Jl83zHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5K4N751; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5K4N751"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF1C4CEEC
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 03:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742094253;
	bh=VDEzFq3lQWptFywuq8O7zDOkP6nzA5QK94P82Ok9u4Q=;
	h=From:To:Subject:Date:From;
	b=k5K4N7510hDFr4j2ae2IoSgVoc1XebDV8ntGCOxDIyQR35hUf1LoQifQQChXwAG7X
	 iKB+gq6rTY/pZttON6+9r8/CXnW64WF7dkVDxQlsKOuGwN+DtoI1gbjbtz0tpc6S3g
	 r4TTx+m1NyzHlWWurHfnZSs/ohBXswydPgEkHXQ2uYeyLQyElAlmP2hiFP1z7dlkt4
	 pZqAVlshUzPLt32ydfOR6NmqF1NxuPu0MsyGUBrUGKIXr820oDfyv1J01d0AFX4ZW5
	 aZjWVklQLCpAOjH1jviJ8ACKQY/2w7y1DLizUjthA8U6jloVtjSS9sUKGR9K6qUmtZ
	 3gMTKiflaHLng==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Remove unnecessary softdeps on crc32c and crc64
Date: Sat, 15 Mar 2025 20:03:19 -0700
Message-ID: <20250316030319.92651-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since bcachefs does not access crc32c and crc64 through the crypto API,
there is no need to use module softdeps to ensure they are loaded.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/bcachefs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 78a8daa80fcce..6de3a5751561e 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -73,12 +73,10 @@
 #include <crypto/hash.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
 MODULE_DESCRIPTION("bcachefs filesystem");
-MODULE_SOFTDEP("pre: crc32c");
-MODULE_SOFTDEP("pre: crc64");
 MODULE_SOFTDEP("pre: sha256");
 MODULE_SOFTDEP("pre: chacha20");
 MODULE_SOFTDEP("pre: poly1305");
 MODULE_SOFTDEP("pre: xxhash");
 

base-commit: da920b7df701770e006928053672147075587fb2
-- 
2.49.0

