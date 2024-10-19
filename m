Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68029155398
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 21:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729375018; cv=none; b=emxVubuCHGKeTLw+rBtd2wSS7NplTLZ/xXMmREdxXZQ+KZjQ7vfocg2SMxHK1xwKKdCtpLvrMgxhaiVzOEneYMyD8QvI3tPzLU2YoExaUQLboEkNkpF4oPBOFpGm/Ej1zWKW6XuozqGUoyZrf3IZKgPYArTOiGvz3Bwed+dIEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729375018; c=relaxed/simple;
	bh=pWEj/v2EWYdsZC/kXbTfx+l0n5ej9eFClusr0snZtyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SUNGLMMzdiTynasuvHNuq9mfYM2lsin36xFvaZ3IhoDmyzSWVQEfmlPSiQWf8MGao6jfqtCpu325U7yg/wLzGntcGKOJx9XUvovFqr2d6rxA/2KPaM9AnFSJDlp4hteMQrZLEuA8hJ9UcKNvLWqGVxlegjHnyd5JJvTgt3+tNRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r9bwDv5o; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r9bwDv5o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729375014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rFnFFuQXsISZ240V8SiOaFpEXcUDXsmTc80HGSbI134=;
	b=r9bwDv5oP2+KxLA1bUeBphQqODQuBwjEThtKtM19kLcPYJtgZgGMoH2DnmSWGQV3pbtO+t
	xamwlP+fsE4VaRHGGuEDt5ks/SFkmeJ66279bMiwYNN22qDV2cnDwQkp6m9HTJGmyY22yR
	25P8Y7PeA9laZOq3Q3kjsoSKFeOaNKk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix __bch2_fsck_err() warning
Date: Sat, 19 Oct 2024 17:56:46 -0400
Message-ID: <20241019215646.160150-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We only warn about having a btree_trans that wasn't passed in if we'll
be prompting.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/error.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 7a79f695ba2e..b679def8fb98 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -251,7 +251,10 @@ int __bch2_fsck_err(struct bch_fs *c,
 	 *   delete the key)
 	 * - and we don't need to warn if we're not prompting
 	 */
-	WARN_ON(!(flags & FSCK_AUTOFIX) && !trans && bch2_current_has_btree_trans(c));
+	WARN_ON((flags & FSCK_CAN_FIX) &&
+		!(flags & FSCK_AUTOFIX) &&
+		!trans &&
+		bch2_current_has_btree_trans(c));
 
 	if ((flags & FSCK_CAN_FIX) &&
 	    test_bit(err, c->sb.errors_silent))
-- 
2.45.2

