Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096D5262818
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724134; cv=none; b=iYzsf8TvrANktEgxNlcz/hg/ICTizS4WeVDJwUkk38oRRCvntjmsFGiqPTpMBNvndiZfMCl9ixB1RAbL8iW0+pHT/9LO8aZ5KHnHoHUCqaQv5yXfRlCdi2IVmXxANLtmvPOKhV0w+GhjIYFvtKlQKVabKgRShTcOPMWgs8UtGMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724134; c=relaxed/simple;
	bh=K1ooNKL8AdC6RIsSs098TLnDhQWMYm39r5PuKuRHGNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILkTX+C5whyNVcEv3HXb800F399Ub/pg6Hf63eAEj8HS1BcpcmYNwgWX8xd3PvfB3nh5XTofGgXJKmwQM41Xw3JQ05Ay6+bLsQnQYSwiXh5+XNXSziCoM6c/viJMr1yha91roU50tedAoyGeVgAkh/h8l8E2iDHly+OzFsVCRMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L3LIwjik; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L3LIwjik"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5CFXdkfygxNsg+BuND2fin1tGgb4k1Y+GefZ0INd7o=;
	b=L3LIwjik+XxZV/S9pXbc4DU9SJccWABCU+6XAUVDFl041qFmwRonHr84rEtMR0HcvzyLnq
	CVLH86NnTTENdHpwCcsyp1R0GnMOhPBOGD96USzxQVpxJqH5JDaXH2+9RduldyABwZY5lB
	twZFj3CvJEjhf5St39wgKrDHo/3oezg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/14] bcachefs: Read error message now indicates if it was for an internal move
Date: Tue, 11 Mar 2025 16:15:05 -0400
Message-ID: <20250311201518.3573009-4-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index af963999e1a7..03baab542abb 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -329,10 +329,17 @@ static struct bch_read_bio *promote_alloc(struct btree_trans *trans,
 static int bch2_read_err_msg_trans(struct btree_trans *trans, struct printbuf *out,
 				   struct bch_read_bio *rbio, struct bpos read_pos)
 {
-	return lockrestart_do(trans,
+	int ret = lockrestart_do(trans,
 		bch2_inum_offset_err_msg_trans(trans, out,
 				(subvol_inum) { rbio->subvol, read_pos.inode },
 				read_pos.offset << 9));
+	if (ret)
+		return ret;
+
+	if (rbio->flags & BCH_READ_data_update)
+		prt_str(out, "(internal move) ");
+
+	return 0;
 }
 
 static void bch2_read_err_msg(struct bch_fs *c, struct printbuf *out,
-- 
2.47.2

