Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D638DD0
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JJaXj6Pv"
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA553EB0D
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:10 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7yTdJ/3CxYa+DNS3FLOSPX3YwhxrvIpdM585Dloys4=;
	b=JJaXj6Pvw675tLd+clptd5FBUuEQBf9luJdq0P+iBW8+z3jrMVm7KSpSBmdaxLpg2KkHfx
	Cdh2wDs757uEcDIygd+KihPbR8qmeXegVnbzL5Tt8WLvitX1UyHhWhAmP7PrzihYdB4IX+
	svTlWYVLRD8anvZAreJuOJTON3nqHyM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/17] bcachefs: Don't flush journal after replay
Date: Fri, 10 Nov 2023 11:31:45 -0500
Message-ID: <20231110163157.2736111-9-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The flush_all_pins() after journal replay was unecessary, and trying to
completely flush the journal while RW is not a great idea - it's not
guaranteed to terminate if other threads keep adding things to the
jorunal.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 3524d1e0003e..86713b2a6c87 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -218,10 +218,8 @@ static int bch2_journal_replay(struct bch_fs *c)
 	j->replay_journal_seq = 0;
 
 	bch2_journal_set_replay_done(j);
-	bch2_journal_flush_all_pins(j);
-	ret = bch2_journal_error(j);
 
-	if (keys->nr && !ret)
+	if (keys->nr)
 		bch2_journal_log_msg(c, "journal replay finished");
 err:
 	if (trans)
-- 
2.42.0

