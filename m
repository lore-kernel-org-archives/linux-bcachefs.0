Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AEC139D1B
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729043459; cv=none; b=LIsxzWhyba2wFP+8Ute7jvWqY8gu7VxA1FtA3A3NlucgpVqt2S2i5Yo5KW+OEKFNf3EiwHVgFCaSBtJeZlmPTrgVGuV3bmfohQPzFM2BN2c9ZhlTAQC7GoS0ZCrH1M0I9pObtOmVGYvCguSl0YzunzSJ1mDGNgCTlIslyHonpi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729043459; c=relaxed/simple;
	bh=kNL8RZpAhOK3XSLOXGLgVKw10zRrZt3dI5opcDhHpkg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XOSgOusEd8xEIn0x43iQLXPz7mDflpwNBmK5GI9VeLK8kVhFkhHxe1rIwk2BiQaW3xgiyv+kZlX4C/b8dhE/OJUh63AFogIFogYMwpXSesX1kMknkw4fg9jhUgj+11y7w0r0anvkRKwGdXjFGcpX1VCH+ZXOLRhEe0NJoMjORek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JAqJqFBC; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JAqJqFBC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729043455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KXQgibpwvhx7YUTtIm7mnFEXZ5fErMpg8ciGJfoRR2o=;
	b=JAqJqFBCeP8sNDH4ITMUYLe9+IYCM1Xg2EpIrNGHFfL8yDi/qgVlAm5ZPHwJHMz9fGxOlJ
	MaDfKMgIRNTnXoZ3ZEVTNSPVEES3lk8et6pNrjvwqtV9m5EqaBp95i5qJTvquRSKr/fD+S
	EHKnfKkmF2srS/KlqNHMYA6aIMlw3Io=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Correct the description of the '--bucket=size' options
Date: Wed, 16 Oct 2024 09:50:26 +0800
Message-Id: <20241016015026.1555670-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/opts.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index cb2e244a2429..92eae5636f2b 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -487,7 +487,7 @@ enum fsck_err_opts {
 	  OPT_DEVICE,							\
 	  OPT_UINT(0, S64_MAX),						\
 	  BCH2_NO_SB_OPT,		0,				\
-	  "size",	"Size of filesystem on device")			\
+	  "size",	"Specifies the bucket size; must be greater than the btree node size")\
 	x(durability,			u8,				\
 	  OPT_DEVICE|OPT_SB_FIELD_ONE_BIAS,				\
 	  OPT_UINT(0, BCH_REPLICAS_MAX),				\
-- 
2.34.1

