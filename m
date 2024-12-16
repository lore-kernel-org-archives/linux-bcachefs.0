Received: from mail.lony.xyz (unknown [172.105.251.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1B207DE0;
	Mon, 16 Dec 2024 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.251.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734378185; cv=none; b=sX/fgxOJKwoWhMpnnFw4T5iuXrijaoeYzJJOFvq1z+D6v9axjgmgqhoNyhBTd9g3RieFetuTuk6SgEgLL/PjQJ8CBXp4ojttqAW15hk8ii98xUPZ7DXBDlxMe+YLgG8iw/omWtrfeivd+KqDY9I5it5r9JFcifEI4D7avzlej4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734378185; c=relaxed/simple;
	bh=Jpw8fC0tv7WQKVMIxm+fYFx/JGkmz8LtbfJpAw4FyoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n4p3HP+YuPySHY8Qb5nL0NEAgTTSFN9WR3rqC2DraWaTsp140K3WIwu297Ux3xhKeONOC0CenqwpIu6+KlLf0iETiTTYnSz9MKT4qhs7vIvKARbtMQ/oCUM4CBaXedoi5gHwCmW9DobLYt0FW4KHrQ2NTcsRWnhKt3jFLpl+jbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lony.xyz; spf=pass smtp.mailfrom=lony.xyz; dkim=fail (2048-bit key) header.d=lony.xyz header.i=@lony.xyz header.b=Q0qCKCTR reason="signature verification failed"; arc=none smtp.client-ip=172.105.251.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lony.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lony.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=lony.xyz header.i=@lony.xyz header.b="Q0qCKCTR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lony.xyz; s=mail;
	t=1734377602; bh=Jpw8fC0tv7WQKVMIxm+fYFx/JGkmz8LtbfJpAw4FyoQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Q0qCKCTR2d77fXwaBUqo9CaGrE7Di8RCw5vMMDcbRunh9jiIQdUq8+1GUK7+6zvFm
	 yHXmFFwac2ShvSeUVOeeAltoVz4uZvrEhAWZw1fJXiwyitTTId9CrreQyIJJSIjNhy
	 GvUYk3gsZwgP/rM75x3wQ8rJxgd6wGpOe/Q6Hw9ZFlIkz3LCrUls1V8Ek7sG2LejNW
	 1wMBXdq1ZyMOLTY2JLma8Oss6E5jzh3ufqIHjuk4SdRgwQ4j5WN2ktFrQpi8SnyJzE
	 GmrhWMSXxNFBkmy71jhpiOIi+a2kBuOz1KgiAgcpfS3HD/GoYusPzGuK8AzmaSh3mj
	 0IBhxMHJcec9A==
From: =?UTF-8?q?Sergio=20Migu=C3=A9ns=20Iglesias?= <sergio@lony.xyz>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Sergio=20Migu=C3=A9ns=20Iglesias?= <sergio@lony.xyz>
Subject: [PATCH] bcachefs: Reverse first btree write conditional
Date: Mon, 16 Dec 2024 20:32:53 +0100
Message-ID: <20241216193259.114315-1-sergio@lony.xyz>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The conditional led nowhere so it was inverted to clean the code.

Signed-off-by: Sergio Miguéns Iglesias <sergio@lony.xyz>

---
 fs/bcachefs/btree_io.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 839d68802e42..7dbb1d908d94 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1862,11 +1862,7 @@ static void btree_node_write_work(struct work_struct *work)
 		goto err;
 	}
 
-	if (wbio->wbio.first_btree_write) {
-		if (wbio->wbio.failed.nr) {
-
-		}
-	} else {
+	if (!wbio->wbio.first_btree_write) {
 		ret = bch2_trans_do(c,
 			bch2_btree_node_update_key_get_iter(trans, b, &wbio->key,
 					BCH_WATERMARK_interior_updates|
-- 
2.47.0

