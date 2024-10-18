Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E344E1714BF
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226176; cv=none; b=dNrwPRhRxtA2qHcr5RD3ULYMjKTDVWLD/bMTeOnJ36zkGxenUgTSKmOq4XYGig/CfFujjTR35rhRYAGip+xg6WNAe988Xp7moNSj1cisFjDswYY1igsYisudjpYdYNsQnnoyYaDL2vQi+0NFrk8qZbdx5oTRkbqwLnr6YT8k4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226176; c=relaxed/simple;
	bh=4G4HBebiPtX0UwErCDHzEOE4JytNUwu5BfJNNOLrM+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkPpUI8LXrMFLMod8K5ulrkNvdTwGmTsJaNiNy1/X9Q3dBXIAJ83aFBvDNXNxQl2tOgqiALthlY5M2IdDc6uX7CnAP0fuwR7GuchLly/JqRZ56KwiZEy2OGDadOO3webhnH/FqRbCi+bWpzEIXHT8uN3WP+D/dcAS45WjIiNypY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vu9IeTGx; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vu9IeTGx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DmDEZX5v1VferJ0kXE96N7a24e/Rm+0nEjWhuV5zZ28=;
	b=Vu9IeTGxyPMm3P6CRJd0ngq/8yo/sdqO84FUUZ48p4x+rUFN5ztNASxoI2jlCBT5okHoC4
	MYIXJVzZtuApMbvdV7cfbvN5h5mxQmUjB8bPQyjLtMNieUlJCbtg7xXawQAveCu9LOTcRG
	9EjukDvLFtACeE5q/PpHJVowcltxiPk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/9] bcachefs: fix restart handling in bch2_do_invalidates_work()
Date: Fri, 18 Oct 2024 00:35:55 -0400
Message-ID: <20241018043602.4067344-6-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this one is fairly harmless since the invalidate worker will just run
again later if it needs to, but still worth fixing

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 6e161f8ffe8d..50f1919f4cbf 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -2137,14 +2137,15 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 
 		struct bkey_s_c k = next_lru_key(trans, &iter, ca, &wrapped);
 		ret = bkey_err(k);
-		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-			continue;
 		if (ret)
-			break;
+			goto restart_err;
 		if (!k.k)
 			break;
 
 		ret = invalidate_one_bucket(trans, &iter, k, &nr_to_invalidate);
+restart_err:
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			continue;
 		if (ret)
 			break;
 
-- 
2.45.2

