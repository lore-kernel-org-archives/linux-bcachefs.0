Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861662943F
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jul 2024 01:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720487540; cv=none; b=dKWXKOj9kDf+AbGvPku3Wvf4yBIqaiTxvjl3LCXvu+O/9wKFofcThO/ojry064n8lNxhwHYR//geAe1ZzJgS9Xe7R5PonTboatPSOMySTpvIkNioufv9UcHrubab0pj8LrJtstoabVmI755IeWj+g75+K7k/SUOAqfbouKqMXtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720487540; c=relaxed/simple;
	bh=oL/TbqX4j3gvs9TcjKMhI3mDedwFHZZN+/pwg98vDks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NbZpgUyHFbY/4lioc3Cf4x00Jd+AEw9zfs33ypcFPSgrvRxFkFvJJuHxzk8vyVTAi7B6UDACGr8o57Vstvi7sv+XAEaC27936+KOk8l8lT05JxXDTirA1yzT0cdJaaZY+GH+CoGarAQHygIR/GBDkofRtIoOzCRxvtaJSrAl80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/9KM8XW; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/9KM8XW"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720487536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TbuIxKQQ4S+A2myySSe8uwpo48kGeIhRa8Lb5m30vK8=;
	b=M/9KM8XWQT7HyulvOT5gxDYrs4MbVDJSP86WW/WnEGF1EKPNl18fKXoOkxmKsX7ecrKNSJ
	rKkvCdVsSX7r25EXmM6pbNOJ1JeuiecIRO88j0Komerf5F2P+eFlIlxI70vyXKH16svtnd
	OkoukdsZVKOshjNSsh760V00MQTgCTw=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: youling.tang@linux.dev
X-Envelope-To: tangyouling@kylinos.cn
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <youling.tang@linux.dev>,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 1/2] bcachefs: Add support for FS_IOC_GETFSUUID
Date: Tue,  9 Jul 2024 09:11:33 +0800
Message-Id: <20240709011134.79954-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Kent Overstreet <kent.overstreet@linux.dev>

Use super_set_uuid() to set `sb->s_uuid_len` to avoid returning `-ENOTTY`
with sb->s_uuid_len being 0.

Original patch link:
[1]: https://lore.kernel.org/all/20240207025624.1019754-2-kent.overstreet@linux.dev/

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 3ea8dbc4d8e4..011ee5075a52 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1977,7 +1977,7 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	sb->s_time_gran		= c->sb.nsec_per_time_unit;
 	sb->s_time_min		= div_s64(S64_MIN, c->sb.time_units_per_sec) + 1;
 	sb->s_time_max		= div_s64(S64_MAX, c->sb.time_units_per_sec);
-	sb->s_uuid		= c->sb.user_uuid;
+	super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
 	sb->s_shrink->seeks	= 0;
 	c->vfs_sb		= sb;
 	strscpy(sb->s_id, c->name, sizeof(sb->s_id));
-- 
2.34.1

