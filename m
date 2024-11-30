Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406192F3B
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930109; cv=none; b=Y7YhGgG003WZS4wppSClKmHIuf4iJEzfWnQv2KxNOBE5KNcZb550hivNpu2dyKmhsLU6/H/03/cEfTaATSfDK6eapDq5voeS/9/9zF7obIaWCXlCcsJ08Fwtc+UIkeIXDrkJOJk9Lj4md6A5IeBO3PFOll/UA3mCqpCmrh+bLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930109; c=relaxed/simple;
	bh=EVm9X2Yzg/FVwglfdpIQWJ9YR0mTMQRGkaqu5L+sP1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSWG5dEuXQtnBADJCLRs4HybDbXtXDlc6D07ae/4u/8BPAjjao3blDY8LHDW739ebInvXOTBc8ZDru6pNGqdPXHEN6t92JnkqhDEDSHZmbuaqzJTlqrohdaES6CjLoaVAzOUDsjhvOeJCsQ5c+vuxclJjurELbBbS+HdtVrrOiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kTMV/9r5; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kTMV/9r5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rh9JAZfa7zQg3/XrL0tr2o9LQsOVg66xmySHu8on3zY=;
	b=kTMV/9r5RpOY7CssgXOmaCJr8XyBnc5wTj22sceB59DonrLY8ZiUQ8HxgZwvySalFgLvTG
	b2LtkW8VnZmDZd541PuLZ8I2+qzEYihWuQFPXQ61IXF0urz1rGFf3Bh4h31WHqyr7s33KV
	McPHxAujcWL374ANrXLTLTQhOi7A4ZI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/4] fix repair for bkey errors
Date: Fri, 29 Nov 2024 20:28:06 -0500
Message-ID: <20241130012812.3135521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bkey validation is done at btree node read time, where repair just means
"drop it from the in memory btree node" - persisting that repair means
kicking off an async btree node rewrite, which wasn't always happening.

this fixes, among other things, the "disk accounting key with version=0"
errors that kept popping up despite the log saying it'd been fixed

Kent Overstreet (4):
  bcachefs: list_pop_entry()
  bcachefs: bkey_fsck_err now respects errors_silent
  bcachefs: If we did repair on a btree node, make sure we rewrite it
  bcachefs: bch2_async_btree_node_rewrites_flush()

 fs/bcachefs/bcachefs.h              |   7 +-
 fs/bcachefs/btree_io.c              |  19 ++--
 fs/bcachefs/btree_update_interior.c | 153 ++++++++++++++++------------
 fs/bcachefs/btree_update_interior.h |   1 +
 fs/bcachefs/ec.c                    |   6 +-
 fs/bcachefs/error.c                 |  12 ++-
 fs/bcachefs/io_write.c              |   4 +-
 fs/bcachefs/recovery.c              |   2 +
 fs/bcachefs/util.h                  |  13 +++
 9 files changed, 135 insertions(+), 82 deletions(-)

-- 
2.45.2

