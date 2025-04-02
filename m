Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B2227B8E;
	Wed,  2 Apr 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743564421; cv=none; b=GlUHA0cH/mnJc81IKsVRNf16gX7nWkNWPlqQbLw8+RqxHgemFSTXrdkSumTb/1hZAchpCwO+TWXpdpMBoohDeQWVZSLaT5saHTxnUMAvZPurH6w4MRZ4pGqu0tApGdLitRkuxvo6FX8gXMjxCAMySUDC4Cy+I1/UHr74ZtHKXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743564421; c=relaxed/simple;
	bh=vt5hmw1z6p3BkhBofk+q1jJoMY+sk9Nnoin03Tn/75o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gz+EIvzaRjOKcW6ifQ1cvPeI9GwmacsM88seWA4cJwinWWf/AC3rLhYwSFzfiiBknxjVf8X8fsWPwWVVQsDD53ax840k3t51E1Z1vMks4E7DoHunlBU7jJ8UErvL/S8rMtd4sICryZABCc2lgCUCMeLlX5WLhREQTy23Hhw8DKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/ITZ3Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/ITZ3Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586C8C4CEDD;
	Wed,  2 Apr 2025 03:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743564420;
	bh=vt5hmw1z6p3BkhBofk+q1jJoMY+sk9Nnoin03Tn/75o=;
	h=From:To:Cc:Subject:Date:From;
	b=m/ITZ3Oc9vJRgfknje++6RgyFcwCekv/Oe+lIMIu4eLpbec3KT1vFbNGTsTg6Bnje
	 5estcdXvh3fD2abPrksCwODc0BfhGRG2xF90mrkOOXVGLg0igMxdWZHN43w9hWPUxv
	 mEXHptvoeBDQakoh0PCno1RBTNYNgkvI4HO+QD4YnZh9/l1eSsKg+pzcEJ0/nvufaZ
	 03wiPxuCgHCu3CyLTgnkp8FiThq1DqjWyUvwWQlDrc6kJChkk7BTGcrj4aY2HujB0+
	 F7vcpsFUmVT00NPnATSpzhV8ogKwlY5h4895UgBZ6+1l7tWROPJeqBPOrWv1mKDL+e
	 ywhsQtwDDDPxA==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] bcachefs: add missing selection of XARRAY_MULTI
Date: Tue,  1 Apr 2025 20:26:48 -0700
Message-ID: <20250402032648.266034-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

When CONFIG_XARRAY_MULTI is not set, reading from a bcachefs file hits
the 'BUG_ON(order > 0);' in xas_set_order(), because it tries to insert
a large folio in the page cache.  Fix this by making bcachefs select
XARRAY_MULTI.

Fixes: be212d86b19c ("bcachefs: bs > ps support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm not entirely sure this is the correct fix; if it's not, please treat
this as a bug report...

 fs/bcachefs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index c9798750202d3..bf1c94e51dd06 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -24,10 +24,11 @@ config BCACHEFS_FS
 	select XOR_BLOCKS
 	select XXHASH
 	select SRCU
 	select SYMBOLIC_ERRNAME
 	select MIN_HEAP
+	select XARRAY_MULTI
 	help
 	The bcachefs filesystem - a modern, copy on write filesystem, with
 	support for multiple devices, compression, checksumming, etc.
 
 config BCACHEFS_QUOTA

base-commit: 88eeda35f19bab3a247ca25d99bc82ac710bc09f
-- 
2.49.0

