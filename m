Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082123BF9C
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012514; cv=none; b=IHH21RxIEjeI2HftEEShR7qzThawnxbyP2p/ufAjXFsxjkBqd5Mz2LSriDVe+JeVuaecHaJhFbzmyo03qdpk+ZIpfyvw5TNnNFgGnYwPFo4OnBtGoUZGVJMzvKEP1zxmUYac8Rn9SF3S21t1ciKKavRFoTRxGeuDD8fpzDaBcjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012514; c=relaxed/simple;
	bh=IaIUcf/JkZ68vwx6QYFzDfwYJicqpdYIpvXI5JmSYgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laEa/wmepqGCxUXEaJGHjJa4Mx06hQCVyQT5eDD+urjSnQTqmlp9RbgxwxyZ9focg0RRKybTklQjXW4nlQh19zA2yIolGEk4AZ4gHtxKFoJKX4LxoNaf4c2zELYIqkuHr7UceUl0gGit9F2uayeHVclAfwcQk1adx+NO8cm87N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DD2C/HCF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DD2C/HCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVdzxbU/+sJnRzEpo3u5iXlwZcNsLNVMOZ2qGmRj+bI=;
	b=DD2C/HCFK90PtJZZSGT6fwQX15h11fJW4WZl4cDy+jggwnlEZQ/wAZJQcB4WpGhK+hchtu
	N+7zYMzCDFn+BmOL0/NO4FzSA2wr/nj9g1nFSmJUuOrYfVrqcDjUzB5YGxD5Ot5H+jX5Sr
	vj2IRasVXOW54TnczxV8a6mUFr5hvds=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-7-27H4TpPSSvn0zeUY0eng-1; Sat,
 08 Feb 2025 06:01:47 -0500
X-MC-Unique: 7-27H4TpPSSvn0zeUY0eng-1
X-Mimecast-MFC-AGG-ID: 7-27H4TpPSSvn0zeUY0eng
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E4011956086;
	Sat,  8 Feb 2025 11:01:46 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B57BF30001AB;
	Sat,  8 Feb 2025 11:01:44 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 12/21] bcachefs: add eytzinger0_find_gt self test
Date: Sat,  8 Feb 2025 12:01:09 +0100
Message-ID: <20250208110119.546961-13-agruenba@redhat.com>
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

Add an eytzinger0_find_gt() self test similar to eytzinger0_find_le().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index d25b2e800307..fed712dd5f82 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -819,9 +819,47 @@ static void eytzinger0_find_test_le(u16 *test_array, unsigned nr, u16 search)
 	}
 }
 
+static void eytzinger0_find_test_gt(u16 *test_array, unsigned nr, u16 search)
+{
+	int r, s;
+	bool bad;
+
+	r = eytzinger0_find_gt(test_array, nr,
+			       sizeof(test_array[0]),
+			       cmp_u16, &search);
+	if (r >= 0) {
+		if (test_array[r] <= search) {
+			bad = true;
+		} else {
+			s = eytzinger0_prev(r, nr);
+			bad = s >= 0 && test_array[s] > search;
+		}
+	} else {
+		s = eytzinger0_first(nr);
+		bad = s >= 0 && test_array[s] > search;
+	}
+
+	if (bad) {
+		s = -1;
+		eytzinger0_for_each(j, nr) {
+			if (test_array[j] > search) {
+				s = j;
+				break;
+			}
+		}
+
+		eytzinger0_for_each(j, nr)
+			pr_info("[%3u] = %12u\n", j, test_array[j]);
+		pr_info("find_gt(%12u) = %3i should be %3i\n",
+			search, r, s);
+		BUG();
+	}
+}
+
 static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16 search)
 {
 	eytzinger0_find_test_le(test_array, nr, search);
+	eytzinger0_find_test_gt(test_array, nr, search);
 }
 
 void eytzinger0_find_test(void)
-- 
2.48.1

