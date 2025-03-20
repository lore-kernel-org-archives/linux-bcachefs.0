Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E60226D14
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505699; cv=none; b=uJbhHPF6aUeE0E0YY85245oKUcm3VBB0TKobuXodQJpDuNzKCHOCEK5XC/TazhdY+t5gRRUhDDb+kY9EdG42DJNgyDhqDjrit23xA97RNtIwbX/7KSzPhcf68gZagpQYP2AwjUvy/eBOFc68EHEhnGezcP9B530YvSagbu7+caM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505699; c=relaxed/simple;
	bh=Q49/UH7tpvoTaIfM6xFRJnbTISWgKXbyDu93ZDL5+Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKjWKnbABZBautHXpy1DiVMcBJbICa9d8GfidxET5gZyGuk9B0IOPau6kKUjuNjKNL7wvxqkGlRArgUWpj8uG50Q+YHgkXdO90WCS2pSkpBf/7rmzu2IkBLgwRthEO7XLoKw94VvPTlseSSb7PGXLcUVQhXJbVpx6FikMSs35P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rnVXKnLS; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rnVXKnLS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4c8s/3SnrS8rAgX8Av+PKwE5L+RQCIYWHjzyMGQiTo=;
	b=rnVXKnLSVu9hSemNAFJepDsPlIPcLmvNPO/mW8ioQFujToPQ+ajbWMj8Uumo7TzpyH1w7Q
	vQeBM9TMb3D7CIOedrWdjLGih1Gyr+5Qnud3rVhM3OKJhwMhzLUciVCLdtX7Hqvnt/SafU
	vkGAUfynwPYIThQyP4OmfxpsjUEUB3k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/5] bcachefs: Setting foreground_target at runtime now triggers rebalance
Date: Thu, 20 Mar 2025 17:21:21 -0400
Message-ID: <20250320212125.3359155-4-kent.overstreet@linux.dev>
In-Reply-To: <20250320212125.3359155-1-kent.overstreet@linux.dev>
References: <20250320212125.3359155-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 4c5b585041be..b01b2ae87051 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -650,6 +650,7 @@ static ssize_t sysfs_opt_store(struct bch_fs *c,
 
 	if (v &&
 	    (id == Opt_background_target ||
+	     (id == Opt_foreground_target && !c->opts.background_target) ||
 	     id == Opt_background_compression ||
 	     (id == Opt_compression && !c->opts.background_compression)))
 		bch2_set_rebalance_needs_scan(c, 0);
-- 
2.49.0

