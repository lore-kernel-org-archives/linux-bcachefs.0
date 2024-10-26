Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8D1632C1;
	Sat, 26 Oct 2024 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729939680; cv=none; b=S+7bPaTSF9gqJyuB3o/zXxekSAdul4SeTf0Kr98XDPWEG285lNXL9FVOxZ8kleHBkQlOg8ZHn4P0FKqjybdwfEThMWmF7S0EKsIwiR9uTUtW/nAVX17XHrkyoNwp0oKez/AYxFj8+zHGOrPcHrCWj4MiRO7baiwvgHCMNI3uZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729939680; c=relaxed/simple;
	bh=1Bu5O4wbBSnxBGu1Uvr2iiI4h7/bwwNKK3bUAUklt/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFnj6KR/Xo0PU7UJd6o/RlAaHSnC47UZj4UkslCxpJ6K+0R0NSZucvag1CO5JVHwUVzcEdXNt50pOpRJTK9/UUqLjU5Y7wWQ+i7VtuA5q9z89knpPN0L48qpCU2QonI5CzRTgclijR1AEnflfJRiABHnzCnxqKEBOJ9b2CeCSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fv2/630o; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fv2/630o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729939675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kfDq2ciDIudEXlpQN6LS8uZ5p5AHSvkIn8aMLnqbNOU=;
	b=Fv2/630oBtfrKk/gFNG1YxyWTiu1RF9F/R+iTKoYfrXHVAwpcaiJyA/wwWP78QMtuT8W3j
	r+bCv+yKJNpt0caSJW5cTHrVx59DnhloeE9vk19iLzGvKUxlIGXzQr9xbX9UbD3bGfCHy4
	oxl7yio141NNia0FUK0TeGWE50RsqwY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Use str_write_read() helper in write_super_endio()
Date: Sat, 26 Oct 2024 12:47:23 +0200
Message-ID: <20241026104723.22416-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_write_read() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/super-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index ce7410d72089..557673ee2535 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -23,6 +23,7 @@
 
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#include <linux/string_choices.h>
 
 static const struct blk_holder_ops bch2_sb_handle_bdev_ops = {
 };
@@ -873,7 +874,7 @@ static void write_super_endio(struct bio *bio)
 			       ? BCH_MEMBER_ERROR_write
 			       : BCH_MEMBER_ERROR_read,
 			       "superblock %s error: %s",
-			       bio_data_dir(bio) ? "write" : "read",
+			       str_write_read(bio_data_dir(bio)),
 			       bch2_blk_status_to_str(bio->bi_status)))
 		ca->sb_write_error = 1;
 
-- 
2.47.0

