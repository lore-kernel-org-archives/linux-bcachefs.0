Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044AC216E08
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729876592; cv=none; b=AmzeYDVB/djX8XH6xE1PN1WM4yFXh8gxnPD/vMRmFlup1n63L0gpaKC/vBxKwpDMG6z9RJuJyxS17RkfXiiv3xNz8wNlnmJL2fI/UdPezzDjrN9QgqWIyKzdqSN32rCL5gUaE24RS0H/bfRheHBbjqLX9CiIx07NP4BWzZ+aKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729876592; c=relaxed/simple;
	bh=ry1SW5aVA9SqGvPPT215Xlei4bjQTZ4IF+DJyn11UH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tIs7ap58sDgLV0uJNxv7JGm3k3PtnIMeAiCM4jwsKJBcLwHEOtmC8LF5mzL6WdJCdJ2UlMliFvO52/kFQS2nvUEGZfUptOpC1rSXDI4ntCqirES6BgIMR47ayRfbH+/jTMt0e+LEjvwASuwXS6pbYxfv3BZlTuQxO2bXswT1qI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=slSmXOHG; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="slSmXOHG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729876584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JFZ7N2pOTIozEOClW3aQOffvDsZI0VlLpfaXsSPEcOw=;
	b=slSmXOHGD304KD/0mzAfCKlL6imS6Z1lWw8Aw8QvnpeHDs+xHmF9YNXK+kUcuI2fwW7wA7
	13cN/hjCbu5NcYWCqqkf/MxU0Bl2V1A+zUmMLQtyJNrU+JGBO/U0Lt26XSliCtCcSRTHRb
	Yjg6zpHPD0XWw/pDKQdn8DPKf4a0ys8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix UAF in bch2_reconstruct_alloc()
Date: Fri, 25 Oct 2024 13:15:31 -0400
Message-ID: <20241025171531.1254607-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

write_super() -> sb_counters_from_cpu() may reallocate the superblock

Reported-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 454b5a32dd7f..0ebc76dd7eb5 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -94,11 +94,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
 	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
 
-	bch2_write_super(c);
-	mutex_unlock(&c->sb_lock);
-
 	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
 
+	bch2_write_super(c);
+	mutex_unlock(&c->sb_lock);
 
 	bch2_shoot_down_journal_keys(c, BTREE_ID_alloc,
 				     0, BTREE_MAX_DEPTH, POS_MIN, SPOS_MAX);
-- 
2.45.2

