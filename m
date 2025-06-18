Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0A3085CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283712; cv=none; b=Nu29P1B+vEgRbm7UBQRnj1MpJRpBQEub+8ZPIlY6TURoR89fpH8MFhDrQ9FWVnNXE4tmZs9GWQ5zTCIIFuv8GwdzmkCAKzIsg1UZwRVUSdDCEBu5inhhrPx8r1qDq7d0Ec2EErWw0PeJ+fDdLnO+NQIv4ffKTDcwT9WSnLL1xJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283712; c=relaxed/simple;
	bh=ap9gVMGrE4P2snnX3SUA/5lezumJtmxLiq8nt9A7znM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cygw4IvBeYQoYt6Omc71/vfPNnujDWpM/EAx06/gzxdScKPP+5XGiQkUgJrrJ32KMcxTKy2KCeuu617xbDKCWr07bdqYR2SiBHF3WKP3PV8HFbC8KLiTGw6C23hTscBRXVd4JIgvB31r94SLjsyjBZvZ0WNDm38q/1iMrVYehSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GXi8223Q; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GXi8223Q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ssABj2/52k2e/iYCjf6EWc1CEy6DwuKeIYqHTO5Lz98=;
	b=GXi8223QPaY9r38G0iMIxfbZ08H6aI8C/5rlHKHI6/3ksUr0Uxh3IeiVH+MismGhG69yfH
	19JZgN9hucjtQjKLiwMyubf/TdeWDqGdmAepArpmboVU+wxoXLquMOJ5v7t6Ug/YhHwEJO
	ON1ddl7/aQFxqSkE+ZBnSJXH/Mx7EME=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 31/37] bcachefs: Fix bch2_read_bio_to_text()
Date: Wed, 18 Jun 2025 17:54:22 -0400
Message-ID: <20250618215431.738317-32-kent.overstreet@linux.dev>
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

We can only pass negative error codes to bch2_err_str(); if it's a
positive integer it's not an error and we trip an assert.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 04bbdcf58e40..cd184b219a65 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -1491,7 +1491,12 @@ void bch2_read_bio_to_text(struct printbuf *out, struct bch_read_bio *rbio)
 	prt_printf(out, "have_ioref:\t%u\n",	rbio->have_ioref);
 	prt_printf(out, "narrow_crcs:\t%u\n",	rbio->narrow_crcs);
 	prt_printf(out, "context:\t%u\n",	rbio->context);
-	prt_printf(out, "ret:\t%s\n",		bch2_err_str(rbio->ret));
+
+	int ret = READ_ONCE(rbio->ret);
+	if (ret < 0)
+		prt_printf(out, "ret:\t%s\n",		bch2_err_str(ret));
+	else
+		prt_printf(out, "ret:\t%i\n",		ret);
 
 	prt_printf(out, "flags:\t");
 	bch2_prt_bitflags(out, bch2_read_bio_flags, rbio->flags);
-- 
2.50.0

