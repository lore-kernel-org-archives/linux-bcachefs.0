Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AAB1CCEF0
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741634488; cv=none; b=F+MiGDo7vNr2V49VV2LQMB82OC9YamqvQdG98QJZHxZ7WZkjuYWAOss+5fK2+yy1pTcL+HJfw1xmAtRGvHvMWZmjTqApE5YqbNmFc+Jm8MXVVDmR0lnSwm2iXs+VNUkOQNMue9MK36aCvg06ZdGyXwtf5NZwsVs3/q6T5s/MbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741634488; c=relaxed/simple;
	bh=wmtgrd4Yyflou9lds3N1NlcgvGq23JCJo0t84LhDX4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ERl4jI5eZaeqFx8ZI81QoP/JV3FJ17L5rGb6kVwLUFLVTUDDLmOKUOeUSohETwc1Ilx+qgsWg+MvMd41S3umoAS6VTrTJoc/ycsbIaoNTcXKOZERicZYU/zDrkOpXp3x+iOuUxHIeDewWrRL6ybtQPVnz59X4HygpBPLo6FbtN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V5K6HG65; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V5K6HG65"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741634483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vf/jHlASJNsHG4o/m4N2LSWfzEAnf5BZcxzVvU1NXkw=;
	b=V5K6HG65H6R6mA6/HyHIToH2HYS3tzhdGkvMkVSwVhMEwB68c0h5I1JvXZZw3bbORvWanK
	Gg2KBIGRWnaX1IfPES+OI9mJBiAZjwDMo7XNvTHF0DioyJFrqZ2GG3eoH6mud8gUguq2Kg
	EWqOztmS+J/3KFRhIgXQ5qdjw3gAFA4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Fix error type in bch2_alloc_v3_validate()
Date: Mon, 10 Mar 2025 20:20:29 +0100
Message-ID: <20250310192028.442751-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use error type alloc_v3_unpack_error in bch2_alloc_v3_validate().

Fixes: b65db750e2bb ("bcachefs: Enumerate fsck errors")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/alloc_background.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index ecad4a78c3f7..4dfcf3e6fffd 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -232,7 +232,7 @@ int bch2_alloc_v3_validate(struct bch_fs *c, struct bkey_s_c k,
 	int ret = 0;
 
 	bkey_fsck_err_on(bch2_alloc_unpack_v3(&u, k),
-			 c, alloc_v2_unpack_error,
+			 c, alloc_v3_unpack_error,
 			 "unpack error");
 fsck_err:
 	return ret;
-- 
2.48.1

