Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E01E289357
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727343; cv=none; b=ORZLJwFsQ2exYVczVN5KZpJvLZWt60zKrkkJ/yU30mF7NpvzJzsqpF+aNMCNUGQOlUw08Pk9ypoVGzRjObByJRxpA5Th/yq1+nrsa4Ax15gdgVKnJ8OkZd802EsG4/bktg6mk1g3QNpVCjsvWm9ByyLQV1didtsjx+aUHj9AjnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727343; c=relaxed/simple;
	bh=RBoOTmUhFHmCyHsvZqtuDaUZxAaSkitseB4mYQsYynw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aB/SzLB4mtnkSUKYQv3mPPnOGEMKGDbSKQx8mXwlXkhdHr42z8u/f/RKfW8I4Opq2GTgP+LjBiZz3PtDqbCwNCVdNwqjQUDdn+xQHFKqxyJnLtEZgFyzNzB0xqqTXFcatH32LSM5ohgdoNSdHKZuiUsQWK19Wrzm7Ny90mdFkAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/OibTGz; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/OibTGz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7c3mppo2B7ODueXmfU7KO8q0uctXYAtw2mVjfMfk4ys=;
	b=a/OibTGzC5h2HJFnig9ubNuBd2CncJKuhOSww+dfs4Weqyk18Hlbl1H0eCktOZ+if+1qjt
	isva0GAuTAU4FweY0lcOMTCZjl5sjHMzQqFqprG98AoglrQ/G3TnWsMmSCwI2ea3N6lUWO
	VxzC2ZKGZJFpQUX7TSRJuiqEgLB3V0I=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Print version_incompat_allowed on startup
Date: Tue, 15 Apr 2025 10:28:52 -0400
Message-ID: <20250415142853.2624553-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Let users know if incompatible features aren't enabled

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 788e870bfef6..f1eef5e7698b 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1013,6 +1013,11 @@ static void print_mount_opts(struct bch_fs *c)
 		bch2_opt_to_text(&p, c, c->disk_sb.sb, opt, v, OPT_SHOW_MOUNT_STYLE);
 	}
 
+	if (c->sb.version_incompat_allowed != c->sb.version) {
+		prt_printf(&p, "\n  allowing incompatible features above ");
+		bch2_version_to_text(&p, c->sb.version_incompat_allowed);
+	}
+
 	bch_info(c, "%s", p.buf);
 	printbuf_exit(&p);
 }
-- 
2.49.0

