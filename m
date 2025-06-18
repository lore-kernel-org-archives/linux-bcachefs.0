Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E081127E067
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283702; cv=none; b=DVO3JBjuwotoaIA7MRBB0OjY70jgqU2jDXorBhCbaqDH/ZApY9T7+YaqwEko5fF3yfjMGvar6pmk1zGVUHEDVmMvnzBlur1TNTZlpYv61s8QP/helN2R1EZLX975DUF8aBnr4S5KJ1Fi4qiGZCYDyj0A8AJmXxzSU5KULx/bv0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283702; c=relaxed/simple;
	bh=q6kZPo/HM22THmqCBfcyp2aY8lS53KLVuC3psgrFuPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7JYk7LUQE8PNL9jUURNQ+117iXERyNtTZ8WZA2bX6JaOLqayAAxOEAjrN6Jc/9TDXa/beAz9UamiWUTmv+kkdQp0a26bygzIbMIQrthL34YCZhPVD1Kv/I2cXistObJgbplr2F6p/i7OqmVwRfXr/biaeIJuceZIerSyzeXVp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G0986SN3; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G0986SN3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jejm4eCXiz30oH1CFRJGAVsMvEK8GIUeUm/wTqDNis=;
	b=G0986SN3unR5fyfQUGZgrvyw7yNBz/HzjFe5bgbOvG6Iox4LTy19sJKOyFCqXheAukVkfH
	MaC1U63SQgBv8PkaU+WcK02bXCUszXtdmhIaTkeYxh9/7DNdrPmsSGpsAugDOXhDGM2MRr
	iLQrbNxbbscNpuaiG5YbmtQyCFYXOKs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 20/37] bcachefs: don't return fsck_fix for unfixable node errors in __btree_err
Date: Wed, 18 Jun 2025 17:54:11 -0400
Message-ID: <20250618215431.738317-21-kent.overstreet@linux.dev>
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

From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>

After cd3cdb1ef706 ("Single err message for btree node reads"),
all errors caused __btree_err to return -BCH_ERR_fsck_fix no matter what
the actual error type was if the recovery pass was scanning for btree
nodes. This lead to the code continuing despite things like bad node
formats when they earlier would have caused a jump to fsck_err, because
btree_err only jumps when the return from __btree_err does not match
fsck_fix. Ultimately this lead to undefined behavior by attempting to
unpack a key based on an invalid format.

Make only errors of type -BCH_ERR_btree_node_read_err_fixable cause
__btree_err to return -BCH_ERR_fsck_fix when scanning for btree nodes.

Reported-by: syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Fixes: cd3cdb1ef706 ("bcachefs: Single err message for btree node reads")
Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 005d5c94edd0..dca5530a2f49 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -557,7 +557,9 @@ static int __btree_err(int ret,
 		       const char *fmt, ...)
 {
 	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
-		return bch_err_throw(c, fsck_fix);
+		return ret == -BCH_ERR_btree_node_read_err_fixable
+			? bch_err_throw(c, fsck_fix)
+			: ret;
 
 	bool have_retry = false;
 	int ret2;
-- 
2.50.0

