Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7AA523D
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Apr 2024 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713401476; cv=none; b=H6MAGPktzwq0eOSoc92ZFhcZH/52qfy05DmObHYgjQMZ767YPfCv7F66NLXt378E1H6UlTFmda20CKkXUnl/EMTMKLxJUdi7MHB6gI7q+MquuQxrfsvuZfD45J5N/qk79Hh8dyO18KlfulEk9FseVFQAJQhBetOuS0DHV3/vN+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713401476; c=relaxed/simple;
	bh=07ffA8kkXrVvn46Tku4SoiLPrhU77jqOGLiZCbjdHrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sSJKIhzQZE8UfivYsFojIMnLnehHWm4Wwj6s5L2LmpBgfo/7CH1lGf4U2cFTbfpvTGA1Zy6dp1uhB4iL2ZmicMbQFlHJ5AA4xZT25p4NuM4zd40kZATb394tYAjLNR0u4IbVtcxX4gH7UovllEMU8E9S7a2yhvCBJMuaEiyvx00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d2XVpF4e; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d2XVpF4e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713401471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LhIN91+VDRSgFAPqx1f6TgLIdjqG8AF5Ss9VnxYQdN0=;
	b=d2XVpF4eZJNBfbcmhditqQUyAqA4RtZGFCXPszP1rbJnng+99LaY+UXD7dz/qxuZm/UwAd
	ZYnpQyIZ1a1VgHHWBSnstVXlC/x+U/O1PZxhPQdBIqTYLN1OpkDWrgsyMWa0uQxe0aFzWc
	iI8i08361Flbft+Ed2qiaeTwGszZl+0=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hongbo Li <lihongbo22@huawei.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH v2] bcachefs: Align the display format of `btrees/inodes/keys`
Date: Thu, 18 Apr 2024 08:50:55 +0800
Message-Id: <20240418005055.45482-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Before patch:
```
 #cat btrees/inodes/keys
 u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
   flags= (16300000)
   bi_size=0
```

After patch:
```
 #cat btrees/inodes/keys
 u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:
   mode=40755
   flags=(16300000)
   bi_size=0
```

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
v2:
- Adjust where to add new lines of code.
- Remove flags ` ` by Hongbo suggestion.

 fs/bcachefs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index f0da2b0048cc..5c9ee41baa72 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -534,12 +534,13 @@ int bch2_inode_v3_invalid(struct bch_fs *c, struct bkey_s_c k,
 static void __bch2_inode_unpacked_to_text(struct printbuf *out,
 					  struct bch_inode_unpacked *inode)
 {
+	prt_printf(out, "\n");
 	printbuf_indent_add(out, 2);
 	prt_printf(out, "mode=%o\n", inode->bi_mode);
 
 	prt_str(out, "flags=");
 	prt_bitflags(out, bch2_inode_flag_strs, inode->bi_flags & ((1U << 20) - 1));
-	prt_printf(out, " (%x)\n", inode->bi_flags);
+	prt_printf(out, "(%x)\n", inode->bi_flags);
 
 	prt_printf(out, "journal_seq=%llu\n",	inode->bi_journal_seq);
 	prt_printf(out, "bi_size=%llu\n",	inode->bi_size);
-- 
2.34.1

