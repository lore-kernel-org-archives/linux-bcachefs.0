Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A92191
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821250; cv=none; b=PDEu5bYjX0hfDBdbxIwvYOChD3ffCng9EV11aE7B7PKbjXYTzThrgwQIJ2zd75CUS7xUQg/mwbhOdgB2ZRq5GygRBkB4AlB0k+R1Pd462zWxc17t07oD2c98q2dhF5FGEAt1caONgS4nRZK4Axg/x30luF/9+GtWlKcJw09d3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821250; c=relaxed/simple;
	bh=LRuOdUyCdCsnGYMFuHC+PbIAbxt88Aa4AoAocGCe80A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mpkrhm+KHppVL5y+STa2Ds7S2l7926d95TmNfDxvb2YbiyR2tOejPLySckmI4ZOPZbkxE2tk3AstrXoIT3tKLMCHRecPqdKu4dxLJKkC6nr/rUzugL2vryGgh3547N02vQ48sg3CRWLZwl6fmyo+3lmp72C09xVPzfycEkUntVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qt6Mm68T; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qt6Mm68T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752821245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6SLzZSku9zMjLu1PzZks3lXNhAAYzmW4s7rVjlcBwiY=;
	b=qt6Mm68TG/UmJ+/oH2bTidS2LUY5vbNOtjt3XFComU9FOza8FLAHX+R/SgbmoH4wke11xa
	Xlq0tWbCAyzrGz+2jHYM9B75RJ9etI5fXwHukbXcV4c/G30ibn8qZP3rUfwruvM1Wboihr
	bzaprKD+LCFRotPNIiAyxyLZgQ6wsnU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com
Subject: [PATCH 1/4] bcachefs: Ensure we don't return with closure on waitlist
Date: Fri, 18 Jul 2025 02:47:12 -0400
Message-ID: <20250718064715.333124-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

things will break wildly if we leave a stack allocated closure on a
waitlist

Reported-by: syzbot+0ea2c41a649240197795@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 62dda821247e..bea14f02114f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2060,6 +2060,9 @@ struct ec_stripe_head *bch2_ec_stripe_head_get(struct btree_trans *trans,
 	BUG_ON(trans->restarted);
 	return h;
 err:
+	if (waiting &&
+	    !bch2_err_matches(ret, BCH_ERR_operation_blocked))
+		closure_wake_up(&c->freelist_wait);
 	bch2_ec_stripe_head_put(c, h);
 	return ERR_PTR(ret);
 }
-- 
2.50.0

