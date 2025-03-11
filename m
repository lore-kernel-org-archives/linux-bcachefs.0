Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18B1238D5F
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 11:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741691624; cv=none; b=Aic7YG4FGMabNc7mSPnBSVIffXCHLFuW8Z8DqWdfupF22frdE4Fxs5fVGONBmR6FHnk0tTooSywHHJDxT1g6WKlfEXCSffwGKre4nWIy3pFSGC+tPSo7tvE+u56vRXFc1+cSXlfVbmgMOh3Wi18il4+Df8b2WQ6yAOBzf2xUoaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741691624; c=relaxed/simple;
	bh=ZSfnlQTOZD8O0fLofbS5GkGXGqJx98kuofJ7wgZMeTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WtEW/AaCPxqSy9QF2Au7fKeS6ROfVvbdwo8kJMFkDBTfZUewVT5zjGdHp7oXD2XHc/l2cvIeVl+SEohMFEiiU0lmZb7TgyhdT2TIzzHY+TUHnabeIiKFikR002Y0iHARdIMDaPgqesfnxyxAMhdiQhkEuafzIJwxzC2YR5e+KYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t4HOG6zp; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t4HOG6zp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741691610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HfPMogj46GXj+PK6wnAMkLlFbwsd12CYKYgvhpu8sPY=;
	b=t4HOG6zpcaANRvzYUVZLQbuMvGQ0/yUxrJ2bqnY+oHDmVT0FYsg8KIRZVGeC9eekxEUWKf
	RvgymgbuzlqBFqooyjMILKTR94Z8ZezDVo/3EIzKescXENbbQwet1xHAxMJQWxqH/ZDonD
	eAptpFSq+FUwnJ7eXFyJAYWWxPTCoDE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Use max() to improve gen_after()
Date: Tue, 11 Mar 2025 12:13:11 +0100
Message-ID: <20250311111310.495922-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use max() to simplify gen_after() and improve its readability.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/buckets.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index a9acdd6c0c86..124ac380b22e 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -167,9 +167,7 @@ static inline int gen_cmp(u8 a, u8 b)
 
 static inline int gen_after(u8 a, u8 b)
 {
-	int r = gen_cmp(a, b);
-
-	return r > 0 ? r : 0;
+	return max(0, gen_cmp(a, b));
 }
 
 static inline int dev_ptr_stale_rcu(struct bch_dev *ca, const struct bch_extent_ptr *ptr)
-- 
2.48.1

