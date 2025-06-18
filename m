Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1727E048
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283689; cv=none; b=VEviir9pNgjIUPvqg4LBmy2tTUADjYsBQpowF263ZXB90BbP8JwuNToIEr7pnHvE8Own1N6T+o4t/orJvVbWzMGnTPS+sRt3m9ak3Dm9Tjk5uoZ4shISR9R7dnb4Y3nsh4Cy4seow369sxyNl5iDhBLxr3uKa6mZD9RfHcKxTVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283689; c=relaxed/simple;
	bh=dr4lR9Iw4e95S1KlcojXqJxCLB0VSYSLKMU7UIBA5mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aqu5PxneKfNsKMOJkYJzfpDFinZlqxxUe5CuC1OeD0zT7lKFw7KiobKhqHNLHJwTxd6Nlg9mun0s1NsWTGYDUtGxqyPMIy1C/dACK9YdbiAC9i/2+p1MKjT818/PKIy1KSgiayBhKqgWPhXJCrMNn+SsEc4HKU7hmqGbK/+c1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d11923ep; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d11923ep"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRqRHBq1sW4L+sjK/2NNPKG2rTIuvRWY5wcIgFpCi1w=;
	b=d11923epxYnc0Aa0b27rHPNW03cVcQQ/vV7NaCdnr/OGk7ZK2uORdrJcDQlxc08KoEZwl4
	y+I4VVASpnmHBVEhDFgBEJJn7PHEbwiznhedTc4aSvHkGzXLK2re7HOB0VUJFOY2ic3Eds
	STGmM/TC6MPgxEXGnCYvxWPwXJbLsGA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/37] bcachefs: Add missing EBUG_ON
Date: Wed, 18 Jun 2025 17:53:56 -0400
Message-ID: <20250618215431.738317-6-kent.overstreet@linux.dev>
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

From: Alan Huang <mmpgouride@gmail.com>

Just like the EBUG_ON in bch2_journal_add_entry().

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index d9710801e3ee..55952143f0d3 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -757,6 +757,8 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 				  btree_trans_journal_entries_start(trans),
 				  trans->journal_entries.u64s);
 
+		EBUG_ON(trans->journal_res.u64s < trans->journal_entries.u64s);
+
 		trans->journal_res.offset	+= trans->journal_entries.u64s;
 		trans->journal_res.u64s		-= trans->journal_entries.u64s;
 
-- 
2.50.0

