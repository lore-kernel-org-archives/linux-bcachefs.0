Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFC227E1B1
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283691; cv=none; b=nZgVbayvXY6UD8cIHe+P9KnRdc/k/fxUMIqfQbL7G7O4+9ATBCxo9b/YOW5FETnpJkEMi1MkoymNIfgVjxbMx3vstJdF9DZrasUQcsTJQJXN3qq5mOGOuMj27qvige2k01Yx1WY4GasyCeMNcqIjv6pIhovwsyl81lIYHRWTX6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283691; c=relaxed/simple;
	bh=WDAgGPFVPKD18U4cA6X/0Cy8tizNz3xJTusqUgapX/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9xgtPXhZxxZrUTEBGZSSkZtQSMbe8fGJ2rotx/7sCV+cTOgAffQ9+v0wp8tr84NlymxSLGLr/zJVJX4EyV3z2BGJUaXrTmmX3Dv/i/oAffvmz8wTsY+MJu1EK/NhDnAHrXccNhRkGtwf9HP/jCq1z6HquQP/DF1nieNUQ2dRnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nUbFmluO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nUbFmluO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVl0uhjpaviYnMtGuWv+2vxRRfFIaCSkKBT1UOLHbc0=;
	b=nUbFmluOelayBhi8lh7682nX7wDiMt8Ez7Qc9QHJ81wUBlZPxbbuT2gQiEhhEGX61C/QU/
	SDoW8+6za2WHeKy+I7MXw4JPgJA0ZEEI7Q5i2Led7eQDwaJm5QoFrj+Feox4zsam92aQKf
	WeW4qQgVeUXSVsPQTIFLjxcV8tHbdzo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/37] bcachefs: Fix bch2_journal_keys_peek_prev_min()
Date: Wed, 18 Jun 2025 17:53:58 -0400
Message-ID: <20250618215431.738317-8-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this code is rarely invoked, so - we had a few bugs left from basing it
off of bch2_journal_keys_peek_max()...

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_journal_iter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index cf7398751644..de996c848e43 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -141,8 +141,8 @@ struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *c, enum btree_id b
 	if (!*idx)
 		*idx = __bch2_journal_key_search(keys, btree_id, level, pos);
 
-	while (*idx &&
-	       __journal_key_cmp(btree_id, level, end_pos, idx_to_key(keys, *idx - 1)) <= 0) {
+	while (*idx < keys->nr &&
+	       __journal_key_cmp(btree_id, level, end_pos, idx_to_key(keys, *idx - 1)) >= 0) {
 		(*idx)++;
 		iters++;
 		if (iters == 10) {
-- 
2.50.0

