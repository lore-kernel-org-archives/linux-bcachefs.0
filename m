Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8A17623F;
	Thu, 15 Aug 2024 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723712292; cv=none; b=osEth0rs/EL1r8UT/usLMtLB+4fSV9GxG78Hcex5HxLBDRv2S+KrIaxCvZi5otmiPArj529ltxIcoy3ul8UbxvdLCzmDpUZo4RZQgRO+b5enRWcIxr1FIWtCdfe9KjdpEqIJSkEkrXIMW4WHMtTdc9q9iT/nMi8KJXmdAZ997HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723712292; c=relaxed/simple;
	bh=FeoHnh9gYc8gP46gXGfNS0eNxpOx2tgvWTWqNozBoLs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dgWDZsXjaYmoNieq6QJL/7V6Ns0LN77mXz0sY2s+GrE0/NzfiK1G28Wwz/bRUJy6c+VpAFKxYu18MNkpYrSe1PvCI7TMvMP1iTouNMZgXRGDbbwH9pK3NnJ4CzBesCChwkdYGed9ERpGJCP69/x0DvAlvPCj/GxhmnhJcJh7qHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mo74cRiD; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mo74cRiD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723712288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSW/RP+4fH73cAbB3bODhcZsRza4EeE57k+NBfbM3xM=;
	b=mo74cRiDsOxUE+Ir5lfNX+cga+AD5mitepsHcIld4C+DlXLaaSO5cEJ1pcsky1EBk5vK6C
	bnn6FI3q3Ck99Bvz2+3Ic9kwCCchKMVVBLQZ4Yfog0xsbsh1Ocp/Pqe7GKkfAlt34NJPBA
	OW4gjZaDoovalLLnJsiRhJhVSk7jPoA=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 2/2] bcachefs: Simplify bch2_xattr_emit() implementation
Date: Thu, 15 Aug 2024 16:57:44 +0800
Message-Id: <20240815085744.224879-2-youling.tang@linux.dev>
In-Reply-To: <20240815085744.224879-1-youling.tang@linux.dev>
References: <20240815085744.224879-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Use helper functions to make code more readable.

Similar to commit a5488f29835c ("fs: simplify ->listxattr() implementation")

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/xattr.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 9e77e949a29b..e64e2c47b6ca 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -251,17 +251,27 @@ static int __bch2_xattr_emit(const char *prefix,
 	return 0;
 }
 
+static inline const char *bch2_xattr_prefix(unsigned type, struct dentry *dentry)
+{
+	const struct xattr_handler *handler = bch2_xattr_type_to_handler(type);
+
+	if (!xattr_handler_can_list(handler, dentry))
+		return NULL;
+
+	return xattr_prefix(handler);
+}
+
 static int bch2_xattr_emit(struct dentry *dentry,
 			    const struct bch_xattr *xattr,
 			    struct xattr_buf *buf)
 {
-	const struct xattr_handler *handler =
-		bch2_xattr_type_to_handler(xattr->x_type);
+	const char *prefix;
+
+	prefix = bch2_xattr_prefix(xattr->x_type, dentry);
+	if (!prefix)
+		return 0;
 
-	return handler && (!handler->list || handler->list(dentry))
-		? __bch2_xattr_emit(handler->prefix ?: handler->name,
-				    xattr->x_name, xattr->x_name_len, buf)
-		: 0;
+	return __bch2_xattr_emit(prefix, xattr->x_name, xattr->x_name_len, buf);
 }
 
 static int bch2_xattr_list_bcachefs(struct bch_fs *c,
-- 
2.34.1

