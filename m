Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A223A584
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012508; cv=none; b=bUjehEuU8wnJJgbLEGOLkIqEV5NFfFMuOpgtB4/REASY0Lb19L5Gi/KYpt8nfV/D+z/NxBdxMC+cx8u0sWx7wNOqB7Z2VvmPra2wlOnCopTqGvjNwAnmUGUGSpfLtAYjodSpx9hdztLGgneug7kVhRtW3CnkuDKbhbXDAgcRWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012508; c=relaxed/simple;
	bh=ciUbjG+VTjLuRSapBCwhDa/6/IDSCXnIoOVJeKKqDgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnve9XDER+EBMegRRzM8m8lohJdi2TUmmbBVxmmJo3aG1W75QDBxQVDvjz1OlVLQ6S2myJkay1QmLKs2aWANrBRQS5B9kvV9cxrgBYqu+/72s+gOiRK1kZWNcSOtZ/O/I6+ZllF+aHlUu4n0M1/QlzeDDoZwf+V8FndH9GL85sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MOrjbyI/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MOrjbyI/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vldR0Ci43MiJNcnVZY4mlWJWUd7NCElMtJyS0vObLVM=;
	b=MOrjbyI/IRspN6T1iHRXg/LIXAhDj5HFpPumD4WJ1KdEp2A7DFBr1XW+bsUBR292liroZw
	shvjrMrccmZdeDayCzmiYKrU8XnKcXYXov8JyqRrFMGNXuKnM7JpeGHJcZ7LLSV8dqV1oO
	BaNUPhgZ5KpQjlVltao6xLpSSqJL/bw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-oqkmNtPxNhW66GF1M8HrGg-1; Sat,
 08 Feb 2025 06:01:43 -0500
X-MC-Unique: oqkmNtPxNhW66GF1M8HrGg-1
X-Mimecast-MFC-AGG-ID: oqkmNtPxNhW66GF1M8HrGg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E4541800874;
	Sat,  8 Feb 2025 11:01:42 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E20330001AB;
	Sat,  8 Feb 2025 11:01:40 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 10/21] bcachefs: convert eytzinger0_find_le to be 1-based
Date: Sat,  8 Feb 2025 12:01:07 +0100
Message-ID: <20250208110119.546961-11-agruenba@redhat.com>
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

eytzinger0_find_le() is also easy to concert to 1-based eytzinger (but
see the next commit).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 99edae4bb995..08256fcaeeb7 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -253,27 +253,27 @@ static inline unsigned inorder_to_eytzinger0(unsigned i, unsigned size)
 static inline int eytzinger0_find_le(void *base, size_t nr, size_t size,
 				     cmp_func_t cmp, const void *search)
 {
-	unsigned i, n = 0;
+	void *base1 = base - size;
+	unsigned i, n = 1;
 
 	if (!nr)
 		return -1;
 
 	do {
 		i = n;
-		n = eytzinger0_child(i, cmp(base + i * size, search) <= 0);
-	} while (n < nr);
+		n = eytzinger1_child(i, cmp(base1 + i * size, search) <= 0);
+	} while (n <= nr);
 
-	if (n & 1) {
+	if (!(n & 1)) {
 		/*
 		 * @i was greater than @search, return previous node:
 		 *
 		 * if @i was leftmost/smallest element,
-		 * eytzinger0_prev(eytzinger0_first())) returns -1, as expected
+		 * eytzinger1_prev(eytzinger1_first())) returns 0, as expected
 		 */
-		return eytzinger0_prev(i, nr);
-	} else {
-		return i;
+		i = eytzinger1_prev(i, nr);
 	}
+	return i - 1;
 }
 
 static inline int eytzinger0_find_gt(void *base, size_t nr, size_t size,
-- 
2.48.1

