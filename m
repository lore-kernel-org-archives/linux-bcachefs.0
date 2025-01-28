Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CC1DE3A9
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082364; cv=none; b=cFz5tQqhHkfW0ajKu8q29WIefc2rSRvWqZSIOGi30tEMhbEE1JjvCiE2dEUO2KLzQHn8gpCUYiZQ78IO8rkOaUSim+6o2ktppd8/hHyyfp2UTMyk3c8WretjJhvHlT47GK2ZUzEp3wLRMkcrf88MOLU1F98ankVte7iLcASIWwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082364; c=relaxed/simple;
	bh=RLhmpcLSLz2d4R2iTc94unl567IghN9yXrv2qbuFyCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN+em+AaCvU6vH1cBAMgoGoZeqx7vwrZAuYXgoIKAaxNHAuzlsnGK3f56s96+PoXUqMlqCLbpVh8fx86QqKbW1xeKRzhHSL2l31MZjo4xyCxN/VdW5V9FhZbcvHaEpk1KR/iOLrCN1TG56ZmUHqLjsA67j1hNa626aLzzBMj33E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RHEsgZWR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RHEsgZWR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcbXjcntav8HQWgL6QsKfaxRCHFx880QRWv2hDtxguE=;
	b=RHEsgZWRfiGEq09AXp9WyxnlHyS/Smo6/s4iuso9Mvg3fCPn5aCX7tTsNZtE+DDIXMPPZT
	nFvMSs3bEqgeX7UAg8Xtmw8cVWG8juiO3diwEjLzhJy/Weq8ExMBPl0rPSheNYd/HejqIV
	UbMoe3eC+QRA2CKoPFa7yf06MTLO9QA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-cCPWAJv_Mw2lxzWfMVwm3Q-1; Tue,
 28 Jan 2025 11:39:19 -0500
X-MC-Unique: cCPWAJv_Mw2lxzWfMVwm3Q-1
X-Mimecast-MFC-AGG-ID: cCPWAJv_Mw2lxzWfMVwm3Q
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B07BA1800366;
	Tue, 28 Jan 2025 16:39:17 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDC0618008C8;
	Tue, 28 Jan 2025 16:39:15 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 06/21] bcachefs: eytzinger self tests: missing newline termination
Date: Tue, 28 Jan 2025 17:38:43 +0100
Message-ID: <20250128163859.1883260-7-agruenba@redhat.com>
In-Reply-To: <20250128163859.1883260-1-agruenba@redhat.com>
References: <20250128163859.1883260-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

pr_info() format strings need to be newline terminated.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 58a7b962847d..7cf319290a88 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -703,7 +703,7 @@ void eytzinger1_test(void)
 {
 	unsigned inorder, size;
 
-	pr_info("1 based eytzinger test:");
+	pr_info("1 based eytzinger test:\n");
 
 	for (size = 2;
 	     size < 65536;
@@ -711,7 +711,7 @@ void eytzinger1_test(void)
 		unsigned extra = eytzinger1_extra(size);
 
 		if (!(size % 4096))
-			pr_info("tree size %u", size);
+			pr_info("tree size %u\n", size);
 
 		BUG_ON(eytzinger1_prev(0, size) != eytzinger1_last(size));
 		BUG_ON(eytzinger1_next(0, size) != eytzinger1_first(size));
@@ -736,7 +736,7 @@ void eytzinger0_test(void)
 
 	unsigned inorder, size;
 
-	pr_info("0 based eytzinger test:");
+	pr_info("0 based eytzinger test:\n");
 
 	for (size = 1;
 	     size < 65536;
@@ -744,7 +744,7 @@ void eytzinger0_test(void)
 		unsigned extra = eytzinger0_extra(size);
 
 		if (!(size % 4096))
-			pr_info("tree size %u", size);
+			pr_info("tree size %u\n", size);
 
 		BUG_ON(eytzinger0_prev(-1, size) != eytzinger0_last(size));
 		BUG_ON(eytzinger0_next(-1, size) != eytzinger0_first(size));
@@ -788,8 +788,8 @@ static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 
 	if (c1 != c2) {
 		eytzinger0_for_each(j, nr)
-			pr_info("[%3u] = %12u", j, test_array[j]);
-		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i",
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find_le(%2u) -> [%2zi] = %2i should be %2i\n",
 			i, r, c1, c2);
 	}
 }
@@ -800,7 +800,7 @@ void eytzinger0_find_test(void)
 	u16 *test_array = kmalloc_array(allocated, sizeof(test_array[0]), GFP_KERNEL);
 
 	for (nr = 1; nr < allocated; nr++) {
-		pr_info("testing %u elems", nr);
+		pr_info("testing %u elems\n", nr);
 
 		get_random_bytes(test_array, nr * sizeof(test_array[0]));
 		eytzinger0_sort(test_array, nr, sizeof(test_array[0]), cmp_u16, NULL);
-- 
2.48.1

