Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8F623771B
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012490; cv=none; b=LEAV43mI+aTUJeSKy2mc0DIjrjZ9KTkpEDySpSPnIJqeILlAQrRRAq5ZbmqWYMx2J70nHib4rFSJRvgb3GmVg27ZL0dKt+VoA+xFiP85uGHZEdTVrmXVAZGjzlOIUzNs27CRER4OMCiCmzjnSKZPaALsKPwkk32y/RomWvUqcLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012490; c=relaxed/simple;
	bh=NU9TKF9F++MvvVlPja2WflktJV9mAXaYdg+cZgHse1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A998t6MpoQvfpDfoWN+HMOxLLmAtGuIkH9l/4qait7KCyzi0v78/+45MT9Qh0aSA7QZgdDJjxm/98+eVDMHSjvAkiUsm/nhApMWKzIFt/ZU1wf2e59OIyHfRBjZOkIg6nZeiE6PbMmfoWid9KSlAJ+/5XH4OoMrGxRTi06E0GTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F67uujqk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F67uujqk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bJCDxJBTdjJmZo49f2akLDlAgjB18t4jwaHh9z0yyJA=;
	b=F67uujqk3qTO4N2iVfM7Rc26D65Ju7t9hGJyH5/y1DAdCfn0keIRbt1UUWKhowj8q+x2/S
	ken9uCiN2pqlJiBXKJBtq4Tf9THwKwsFOtH+KvEzugUc3O2AJ0kFfNrRTUzMlNPRSeZOsv
	tJzmjZZlKjybE3vkHhFlbDYwarPBxPQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-piCqylj5OoOBEBl_Wlofhg-1; Sat,
 08 Feb 2025 06:01:25 -0500
X-MC-Unique: piCqylj5OoOBEBl_Wlofhg-1
X-Mimecast-MFC-AGG-ID: piCqylj5OoOBEBl_Wlofhg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABCA119560AF;
	Sat,  8 Feb 2025 11:01:24 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2DBFE30001AB;
	Sat,  8 Feb 2025 11:01:22 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 01/21] bcachefs: bch2_blacklist_entries_gc cleanup
Date: Sat,  8 Feb 2025 12:00:58 +0100
Message-ID: <20250208110119.546961-2-agruenba@redhat.com>
In-Reply-To: <20250208110119.546961-1-agruenba@redhat.com>
References: <20250208110119.546961-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Use an eytzinger0_for_each() loop here.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/journal_seq_blacklist.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/journal_seq_blacklist.c b/fs/bcachefs/journal_seq_blacklist.c
index 1f25c111c54c..e463d2d95359 100644
--- a/fs/bcachefs/journal_seq_blacklist.c
+++ b/fs/bcachefs/journal_seq_blacklist.c
@@ -231,15 +231,14 @@ bool bch2_blacklist_entries_gc(struct bch_fs *c)
 	struct journal_seq_blacklist_table *t = c->journal_seq_blacklist_table;
 	BUG_ON(nr != t->nr);
 
-	unsigned i;
-	for (src = bl->start, i = t->nr == 0 ? 0 : eytzinger0_first(t->nr);
-	     src < bl->start + nr;
-	     src++, i = eytzinger0_next(i, nr)) {
+	src = bl->start;
+	eytzinger0_for_each(i, nr) {
 		BUG_ON(t->entries[i].start	!= le64_to_cpu(src->start));
 		BUG_ON(t->entries[i].end	!= le64_to_cpu(src->end));
 
 		if (t->entries[i].dirty || t->entries[i].end >= c->journal.oldest_seq_found_ondisk)
 			*dst++ = *src;
+		src++;
 	}
 
 	unsigned new_nr = dst - bl->start;
-- 
2.48.1

