Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF8F262817
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724135; cv=none; b=LKIyu3MPUBdYY9KX026xw0r7DyYLPUsRgBHZuxOO0iXdeB53aAUJ8ABfi7KhRu7AjSbLgAf2CjFBS7YsykUdZ+Qq0ExXy1y+WTaFH692Gj3k0kA/k//RXiU1lFLaFRDjOo8HwPr4gOMqz6yvmj149fmHuGxeHHUR1fKYNrogg4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724135; c=relaxed/simple;
	bh=3r+I/qwtK7p9U84JWVVR3UA8vN1qfABvbs8OgrlXP7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJmBZE0Y9XRJl8damAXP3dvpnZrjwu/pLjBvzauxTP6AeOjSwmf+kWXCbHvfXb5tQ1O8BhP/Gu9YkjrI5lQiWPMO4slG7+yY82DTJzJlnF+vJaTO8ZQ4wSpepP7mpU6HhH3vRMKd2OgXrSf0zYzORnAUyJd5gqp6PY6Mmx234PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jITEk98H; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jITEk98H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwyrmHa6DhXsyGaL7OyLHw1/0g/wAw9gHtNXy/swfF8=;
	b=jITEk98HKJHpoKrWzR/1JhO9PXGRa4tIUKEuco5ABn4Q09yn5Q8+kI8FeSh41gOs2s2ESs
	XEYs8Hy2OVr9ojwgYh5r35sI5pAUEr02ciANune8S1pOvbZP00Z4geldBn9H91ewuExp74
	iZ/8CSrQtMYZwTa4etH1ja041bjwy78=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/14] bcachefs: Fix BCH_ERR_data_read_csum_err_maybe_userspace in retry path
Date: Tue, 11 Mar 2025 16:15:04 -0400
Message-ID: <20250311201518.3573009-3-kent.overstreet@linux.dev>
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

When we do a read to a buffer that's mapped into userspace, it's
possible to get a spurious checksum error if userspace was modified the
buffer at the same time.

When we retry those, they have to be bounced before we know definitively
whether we're reading corrupt data.

But the retry path propagates read flags differently, so needs special
handling.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 72a0a6f643d8..af963999e1a7 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -1283,6 +1283,9 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		swap(bvec_iter.bi_size, bytes);
 		bio_advance_iter(&rbio->bio, &bvec_iter, bytes);
 err:
+		if (ret == -BCH_ERR_data_read_retry_csum_err_maybe_userspace)
+			flags |= BCH_READ_must_bounce;
+
 		if (ret &&
 		    !bch2_err_matches(ret, BCH_ERR_transaction_restart) &&
 		    !bch2_err_matches(ret, BCH_ERR_data_read_retry))
-- 
2.47.2

