Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E027E052
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Aug 2025 13:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660602; cv=none; b=myDJ2jOgK+CgRvUPgII/PgKApKj05J6K2lKaafkHHtAqHg5++puB1ZSMTbeBhiQxWaZohh07mTsGyAzNI0eu42wx0EQBTJGgoshFC9wWH06QRB5TxJZGngN2JW/mmC3CmLv8Ief8a+6rLKg7U4Y5+MHPpijDVlA8UJwih0DrwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660602; c=relaxed/simple;
	bh=tLiwHFJq6cmNppXWBXgv8Tt+GcKiAkXy2Guzuj4pC8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oxldtnJykDWIkEWykE3l3VPPv8CU2MWuHu11kMvptlS+aHGV/vY+vchamCL2KO21Gij+zE5MCdYN9qtPXNQF+iSLtn1Dy90kgPi/xc2usG61eLrayFyvoqKgmTLQYYGx4eHEsFN6YKprZN/b/j0hiTvMoXaDHk+qigh/e38/EtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UR9kU9Hd; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UR9kU9Hd"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31efefd2655so1767869a91.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 08 Aug 2025 06:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754660600; x=1755265400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tzIN/3fohi40TXG8ncAoIn1LNwbSG9gUtysq7JUiB+M=;
        b=UR9kU9HdYc2+rf+td0XiUjotZwnA0GIj84GziiWLgCk59haGF8Ft3suV15MWB/VGKb
         U/yoNLSiEu3YjaGsrAJN15anwHWMTIgZ7bJokTzYhza7vFV99qfAP0nQJ5liGPmqOXav
         dNyVeal8vDetSEBJLewJEzAMGCo4b89V5L5Kv3Z0sYN+ozRNqMBdkxuxr9SiBmcuTm/s
         /jURgMOPY8OPRjhj1EsmyM/j5x/eAYKcJl8M74TNvjuElzg4hV3kBqT8NNWq0TIlXPMZ
         jA3Ty2M3fo0XYrhuYyJeTQeO5aO9qVSzRiCkXIVQLmKTmx2mrREFy0lBNGS+yCc+Buy7
         5SFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754660600; x=1755265400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tzIN/3fohi40TXG8ncAoIn1LNwbSG9gUtysq7JUiB+M=;
        b=A1FW23OfJzGHtB6MjKimANt3JO5ZVFMyypXLgV7cC9OML/t4+kfhRp2kraku2WgFjm
         HrLAwNtujnexWDR1kdz9rUML2W6biT+Mbufx9ThEKRJyBZfrNcpoGXXr2qCmY18dup+C
         TJ9TPcFDS86iuHs6vAA+oXDCRfLEWltw2nds9uBIXRzCHZv87hMGiduLCwi6fUR3PZTg
         ItusCwF8nKyhXC9cm2j9us80T6g1u9IrTu6nQ5a7VldbI0l6QBGIw6TU0m7P+OGC2lwP
         qOZDqYne2mE89d7k+q5kVv2zfW54VqJkvFS/VpMsY9GwSV8QwxMuzq1AqaFQOoY+1/gE
         1x0w==
X-Gm-Message-State: AOJu0Yz8fFP8Ra2JfxMGU2x+7zPiVqMfrLWcE8z6bUV591B8YM9H9vZg
	iyCRYgabveDKMWWbQiZzky4IyewHnWYFaoY1kN4jQQJBk6EPMEI9XjI0Kj4jHQ==
X-Gm-Gg: ASbGncuSZa19aLaMpEv/aCBIKZkto3GGOWK6gD5x9lkEPdAUsdOfkUop/WA/QyiwuZT
	p7dh1i3jjWgvmppGKadMxLMJJqYL4yMoe+sNqdMvY8cAsHnvlwOyrtrUQgRrIhZ9s+mT+9Jnwc3
	EmIfDfszPE7GDIGq/nhuyw6qB0tNwgTPQlIb8ztOL65TIodV8ay2Ll/aal8zY7ZOnJJzVWq5mNQ
	d6m4EdT4Tgg9Ko3+BXlo+dqwnhJNTW8HA+pSSXCfPO2zk08yLiKoXHABp205z63WUAtiwobJcaL
	NhUe6tyxltC44fCwbwiJED5004CJorRryvvt75ZH2AdLukKet305lAnQLi8vMynOVPk4/cBx
X-Google-Smtp-Source: AGHT+IFttSxeQGmB5Bdz2wZs/F2iyMydaTKV0x4QklCCCOgKvJ4hHWcH7Q1ZGNBcsFHsXtqEahPzIw==
X-Received: by 2002:a17:90b:4b50:b0:321:50df:51c9 with SMTP id 98e67ed59e1d1-321754823a3mr11440902a91.6.1754660599800;
        Fri, 08 Aug 2025 06:43:19 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63dc4ef0sm25022721a91.14.2025.08.08.06.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 06:43:19 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/3] bcachefs: Introduce bch2_splice_read
Date: Fri,  8 Aug 2025 21:43:10 +0800
Message-ID: <20250808134312.878432-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This provides our own splice read, which locks ei_pagecache_lock around
filemap_splice_read.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 12 ++++++++++++
 fs/bcachefs/fs-io-buffered.h |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index fd8beb5167ee..c16c45a72c47 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -1100,6 +1100,18 @@ ssize_t bch2_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return bch2_err_class(ret);
 }
 
+ssize_t bch2_splice_read(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe,
+			 size_t len, unsigned int flags)
+{
+	ssize_t ret;
+	struct bch_inode_info *inode = to_bch_ei(in->f_mapping->host);
+	bch2_pagecache_add_get(inode);
+	ret = filemap_splice_read(in, ppos, pipe, len, flags);
+	bch2_pagecache_add_put(inode);
+	return ret;
+}
+
 void bch2_fs_fs_io_buffered_exit(struct bch_fs *c)
 {
 	bioset_exit(&c->writepage_bioset);
diff --git a/fs/bcachefs/fs-io-buffered.h b/fs/bcachefs/fs-io-buffered.h
index 3207ebbb4ab4..3bcbf62ad420 100644
--- a/fs/bcachefs/fs-io-buffered.h
+++ b/fs/bcachefs/fs-io-buffered.h
@@ -17,6 +17,10 @@ int bch2_write_end(struct file *, struct address_space *, loff_t,
 
 ssize_t bch2_write_iter(struct kiocb *, struct iov_iter *);
 
+ssize_t bch2_splice_read(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe,
+			 size_t len, unsigned int flags);
+
 void bch2_fs_fs_io_buffered_exit(struct bch_fs *);
 int bch2_fs_fs_io_buffered_init(struct bch_fs *);
 #else
-- 
2.49.0

