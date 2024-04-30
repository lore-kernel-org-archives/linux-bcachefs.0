Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609F14012
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Apr 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447694; cv=none; b=fGHso0JoFYybW7i/eKOK88M5CT3wfhNEXS24Wc6ET7YTs9A5xb2Arc23rE7mXuE9KpXih2mDhOz4RqGbuk6xsDClqxTSiSJyk1QTi9BYyrqgfZQEwQ10G+ItHl6AqNX4TzxhiOyGUR+dJ7pBM4HdFqBsGYOXdBEBhcXOU4SIW3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447694; c=relaxed/simple;
	bh=vnByxI1yvhz7cQm2zv+fS4UfkLZ+4Eziu8+SfaJw+2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UJaH7nA3iNRczvM+lk5xL+CLnA7MpvDrX/rYDtoJ8Djv1NBbPbLIlQxMvE7ZRS/kkQXmY1f0VEJg9gFb6PBdNIzSnuVTIIZYaeu6K8G7vURpvQslcbhqpDtTGpvQg8KZ+HaWdFERTYkKF64Vl6pFhTniuAEAms4TQkHjnD09wpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZHIXm3oW; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZHIXm3oW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714447690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u4umKi23uEoIzCMao6IETndhg1LA1WkSNjlJJg1tq54=;
	b=ZHIXm3oWpT8m+6fZAyjcYFDFIaarFCd7TZuXD/ZkQuaNepvQVhaph0QEPhsijnPfdtlKKe
	qaeM7Iady1yJWshq7sKGlU56qVfBkH4zZQC53BNkasAs9+7DBIXTsFwE3PUVQFa/2aGk/K
	ZxVJT99dDoIKA2T482zmvOMex/fPAW8=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Correct the FS_IOC_GETFLAGS to FS_IOC32_GETFLAGS in bch2_compat_fs_ioctl()
Date: Tue, 30 Apr 2024 11:27:44 +0800
Message-Id: <20240430032744.943468-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

It should be FS_IOC32_GETFLAGS instead of FS_IOC_GETFLAGS in
compat ioctl.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/fs-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 3dc8630ff9fe..205a323ffc6d 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -548,7 +548,7 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
-	case FS_IOC_GETFLAGS:
+	case FS_IOC32_GETFLAGS:
 		cmd = FS_IOC_GETFLAGS;
 		break;
 	case FS_IOC32_SETFLAGS:
-- 
2.34.1

