Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1567E1714C0
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226424; cv=none; b=CtlVT9ZiX9it3L7dh9demhAgXcshBHrcjW9Y/vNCp7cU1DFQJr2h0/c9RCovpcOkPQfdsq7Jt7AvVZQZ3C1gyKUsedrdMf7mNrLsKYsU90Msj8+sbJ8Vs6UfQumfVvLsiGEbd3FGXj5BLNXoQupM4xHANIlTicX4Bljw1ptUf5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226424; c=relaxed/simple;
	bh=SZH7GvcgBR23D5MTmjQGteXe6BFR+rfGZL5r2C7n3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvenXKatZMuuxJwjltHwX649GqiLK1kuNUDlZ7sHN85cggA38IdPQFypPI4GWOPkWMF/cMcut+ya2zJ0mC3xhonbMCLiWu9a9EYFwmGnHUnFHA8eCK3SdL7OcolTXUi53+dA4jkeoarvRE7/8p5kboNxzlP/ZXejzngNn1bXWug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r3JR5qXz; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r3JR5qXz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDjd7M2DnCYX3n9bsKsbIwkg8O+1JJQ5Z1Z5P1fR+Fg=;
	b=r3JR5qXzXNMDB8NlG8rcY0lvoJOj3hwng1DPiSfMiwaBR3y+HCU6XPCgv0Hueo4dao7JBr
	ePeZXYlgSEAFX91h7L3He+DPncGO/ffJjMQ/lciUBE18TbzX6oOjNIbLm2cWeTOBVN8c6r
	Q1gEcVAigWwFFAaiyhhne1zfM9kgqPA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Fix data corruption on -ENOSPC in buffered write path
Date: Fri, 18 Oct 2024 00:40:03 -0400
Message-ID: <20241018044006.4067521-4-kent.overstreet@linux.dev>
In-Reply-To: <20241018044006.4067521-1-kent.overstreet@linux.dev>
References: <20241018044006.4067521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Found by generic/299: When we have to truncate a write due to -ENOSPC,
we may have to read in the folio we're writing to if we're now no longer
doing a complete write to a !uptodate folio.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-buffered.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 48a1ab9a649b..95972809e76d 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -856,6 +856,12 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 				folios_trunc(&fs, fi);
 				end = min(end, folio_end_pos(darray_last(fs)));
 			} else {
+				if (!folio_test_uptodate(f)) {
+					ret = bch2_read_single_folio(f, mapping);
+					if (ret)
+						goto out;
+				}
+
 				folios_trunc(&fs, fi + 1);
 				end = f_pos + f_reserved;
 			}
-- 
2.45.2

