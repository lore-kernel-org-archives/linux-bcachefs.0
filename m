Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C8B839F7
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 04:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724127021; cv=none; b=pvBsvTPoxaFTUWU4loa/z8gPjCSyaSY2muRTOuiiLl6gZ2lB5GPBDDmXZFtJVO/qdgVjOQongjlZ9u1qW6tFuNa0UpTbCysJEqJrLEjcldRs/vAB1EdePJ2xaSMk/jTyEUi7kpe/DV2zcmjqLRwfvIOIsYCEYzKrFHzmbkyovK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724127021; c=relaxed/simple;
	bh=C3E7du26M3uksTtLFiOa8I8/G3PeoUDv2QSOA99Tbcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/BXuq47Rav36eXLcX31H+ZwtUYH32WDilyxxzFMReqNpOlLZZAPzcp6DkRJTKLXr0tk5QkjQCvEy3AncKn2wx5WBqEE/awHv3lgE9nXGr3icfNh7JRIxxAf886UmS3N98MwnFfPs4w/2pnO3KgT31wCHFwMS7eW/3PF4/a8uTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=awKXZ26Y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="awKXZ26Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=KS9xTXtsmKbmP5SlobdKk8fNlYcexZVfKC4cPA6vWvk=; b=awKXZ26YFggqqFNiMpDMDdv8C2
	51TkHJWGGOrtvF20QqibUxwAcbAQ4AVIK8XMg+bx/QYxm33lFSodXkRdjrFsoyLam7NhfGmG2TS44
	w3HJs/woiKZycr9ZAHYuVl22jVFfamoGSYkFiDccGhS9fkzwon2EG1dSLFHxAoGzefF5TYCYsTl28
	Clp6eoR4uZkWrGcmSkV2xKdvXECKm4FIiNPhiEzQQCJM67jarsijXbEErqr8HHUZXZYlQR+qm4I5D
	FaeIc2J8elLIn8xujfPvnsHkl98f4G0CgU0jvHncEMgqqKg3dT53lUKAzFGYtk7EAtIj9jF2X4Q5k
	fyYhNSyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgGCE-00000007Vi6-3Oo0;
	Tue, 20 Aug 2024 04:10:14 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Do not check folio_has_private()
Date: Tue, 20 Aug 2024 05:10:11 +0100
Message-ID: <20240820041013.1790178-1-willy@infradead.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_has_private() is an attractive nuisance; filesystem authors
generally don't realise that it actually checks two flags (one of which
is never set by bcachefs).  There's no need to check the private flag at
all; for folios owned by bcachefs, we know that folio->private is NULL
when the private flag is clear and non-NULL when the private flag is set.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/bcachefs/fs-io-pagecache.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs-io-pagecache.h b/fs/bcachefs/fs-io-pagecache.h
index fd7d692c087e..fad911cf5068 100644
--- a/fs/bcachefs/fs-io-pagecache.h
+++ b/fs/bcachefs/fs-io-pagecache.h
@@ -99,9 +99,7 @@ static inline void bch2_folio_release(struct folio *folio)
 
 static inline struct bch_folio *__bch2_folio(struct folio *folio)
 {
-	return folio_has_private(folio)
-		? (struct bch_folio *) folio_get_private(folio)
-		: NULL;
+	return folio_get_private(folio);
 }
 
 static inline struct bch_folio *bch2_folio(struct folio *folio)
-- 
2.43.0

