Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD7920E31F
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226176; cv=none; b=m328OzEN2a5m4WlKpXHnfv9LsX8ncCVZoCFdAGYlMlhybJSYvyVbSP9BWPjnwx9iO6QiV59rFdXyr2dgP7+vDpjOU0Tofc5jZBRRR/n57JAe/kYUIJL6b0w/5E4WAfYPXYLnkhEGJyQW33kziFipkVXaFJ2poA+fR/METB00iX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226176; c=relaxed/simple;
	bh=x95akVcAdzkuynTrKMbTXUykAFd8POhXPQ8QkXu99So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF/TYMC+xbQzQZ4yu3/Uz1lGnGiTCR3KyVlUIZ5SKO5GwvU2HSjS56D1rY2sQ8vofsdnTuqnDbhO9Rkxe2Keq2a1JKEoava25oCh16lBRwIEThwpfzfVoOVIlsA3VmnN3PXP2ZApyk5uRFhRscja52SwBjoHxMNTea6IOGq/AvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cflkYjfm; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cflkYjfm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OyXX4v7Uy2ejxsNFYxRRZQhNHcuAWevhuVwuxQTUIag=;
	b=cflkYjfmDYZIYQON6itobgNS0jxSbPUTP5K2rgeUGgrmHsInd21CUhXPR4cJAwS1AktVJe
	xKjeZaQMjNxXyCZtA3yxO6SamH6Y2kl+qDKi+/YHhSmtazoMZYEegR6anaH0fM41A2ISiU
	xJnyee17YFA6306yVkd9YhCOoMNDffg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/9] bcachefs: fix missing restart handling in bch2_read_retry_nodecode()
Date: Fri, 18 Oct 2024 00:35:54 -0400
Message-ID: <20241018043602.4067344-5-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index e4fc17c548fd..f00beff9ca0e 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -409,8 +409,8 @@ static void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_bio *rbio
 	bch2_trans_begin(trans);
 	rbio->bio.bi_status = 0;
 
-	k = bch2_btree_iter_peek_slot(&iter);
-	if (bkey_err(k))
+	ret = lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_slot(&iter)));
+	if (ret)
 		goto err;
 
 	bch2_bkey_buf_reassemble(&sk, c, k);
-- 
2.45.2

