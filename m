Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E41877
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990318; cv=none; b=EaLigjTv61jID4b0RzVkOd5Hcn2TSc9En5yTsrb5CWgSnXqPAXE2bCiaPR2f1XB3YNjAqszdl3BL65569sjQ1dk2avCYqyA1GdOnqdt8Dwsjr6vmoj2jUAXlmv6qbdUDRgo5o7PwAt5puSpA7i/LidUuOX5d+vQ3Kvl3mlEKaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990318; c=relaxed/simple;
	bh=5DB5gnZlAoOviN9NoQpP4VheAeKxgSMzrP7Mp+IQzYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2zblg+FjBODmjrOv9pDpX+9NEh58Xf8dbQRDYquZt3qdEtYe7plqwR3u/UqTfM7AQaB3SViW1tEId9X1VAQBW2fjAV1IZqULqNqTOjzIWcbsGLdmFjWInKBKRiCk4qsTgLPz9cahacqJLtj9v5bnNLF49FN0hz8zavtRZPY4Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bk0bdPv2; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bk0bdPv2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzaKu2WuYK7SI1Jwv6NzAFNBczeBGHV2km/aakc1k+8=;
	b=Bk0bdPv2gvjF7HyVzACFGnifZokWoa0bQHzGjm5YLijjutQ7fGZInxYSWicc4bT2MYkZHC
	b8uqDiTcP0KT+RVyfbHt7tDt7qtFCBIYGRra3+sSlMPh5wdkK2pTHF9KHpBhEBU7PFKpXx
	ia+M6ocz8zSq+lZkWRIWJ18evy4dL8A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/9] bcachefs: Assert we're not in a restart in bch2_trans_put()
Date: Sat, 26 Oct 2024 20:51:30 -0400
Message-ID: <20241027005141.2337634-2-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This always indicates a transaction restart handling bug

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 318045b9b754..b36ee4e511fa 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3248,6 +3248,9 @@ void bch2_trans_put(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
 
+	if (trans->restarted)
+		bch2_trans_in_restart_error(trans);
+
 	bch2_trans_unlock(trans);
 
 	trans_for_each_update(trans, i)
-- 
2.45.2

