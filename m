Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180C3273D72
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681712; cv=none; b=gjE9wyu55OWayeBXlPmPkR7DNgYhMT4+xEuAOshWKB9cVrnIHm4/zv2rT7PpNQyInPwOlTqcyMyNsjttidVii2MCrrd0NbTwVbY2G451bgaQ4vWGYEh2Rjtvf81tf6WjkW490M6A37Z1nMwbDvXaLYLUKKV4zhvep2a6TdNOdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681712; c=relaxed/simple;
	bh=+gIGEagdpCjldXJyhjnQmmwAbzwEfPzw8apJrUDTDfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHUD49BtFolhdp+U0pv21tqYcZJo4XndkRlBjGuXK0XxsSF6sueHtOI4XA1CeIHwe2QapQebkQf22OYZ8aP6kw0emV9GYO83lsffv1kATy5Ek86Rzi5TiXQFXfcVefRiSI/YAOelXtyZ5d4BbGqGPxUwVn3BRgmzx5TjKIKjW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JfgkYREi; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JfgkYREi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBE8zXk72EziXSnpUIVANV2ZEo3vqBwO8vej66MwCaM=;
	b=JfgkYREi5mU2JosiSz7W3knJP2BAJSnG2Wbzudf7JPYWt3IXIPmeRRN3QvlJK0RR7aZ532
	JruQe2Zy9foPTaOWCLeuM8v2fT8x8cV8dKGMG1I5Gk+DGn3xQL/bfzyantV+ykAwVxoeFf
	cQYIapZRt6aMGM+qZk6jucUE3TsoflQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/7] bcachefs: Fix triggering of discard by the journal path
Date: Wed, 16 Jul 2025 12:01:37 -0400
Message-ID: <20250716160141.1158722-3-kent.overstreet@linux.dev>
In-Reply-To: <20250716160141.1158722-1-kent.overstreet@linux.dev>
References: <20250716160141.1158722-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It becomes possible to do discards after a journal flush, which
naturally the journal code is reponsible for.

A prior refactoring seems to have broken this - which went unnoticed
because the foreground allocator path can also trigger discards.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index dd3f3434c1b0..9e028dbcc3d0 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1767,6 +1767,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 
 			closure_wake_up(&c->freelist_wait);
 			bch2_reset_alloc_cursors(c);
+			do_discards = true;
 		}
 
 		j->seq_ondisk = seq;
-- 
2.50.0

