Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FECD13AD37
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550424; cv=none; b=gaeGT40SE7IXsgoyS9HCSOko2mOcuMlEcJ3EzNCNOcb9KV48UyBvtkx1fGR/u64HTxBIVtyCkMtI4YOdE2nP+04rf7ItofQnfwnvfUeyn39ALEPq+ZGmUarkbP+iC4GLYEmhM6IS8bBAch2YHg8AoMZcYHckKfBYd5xqSu8GebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550424; c=relaxed/simple;
	bh=rY+xpQIzLBljj8+kKSdgVRAUpggXWlaA69KSq218Oz0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4D+yEMtcDWrZL3piNEc5oeprM80fJYwMvM9W8zTK78javY2zLIuuRUCNljzVm93VaV5QyGpueGq2oN7PuFeamI4nlNwLoSfFUqzX8foLL5Ua1cKV5PkDMXm2//rzohtx/QMxTE+bau/fSFHWJF2h6E7RL33OCkZfRDh+TggsLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLWZAkZ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLWZAkZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713550421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6XMr5WF2BubF4fGQ+BjLqF8SCyk5+VTevnuAfck9i4=;
	b=RLWZAkZ7oyPYL2K48IAN3q6XOHsffyKr2zMCFhaxY2ykxTbV2HjtriaW6yTnpawX9MsPPK
	qOAx4N0/hBKUHrN9+Djt2Vru0b607Nwi/xvY4SXKyXBb0q/5RW/S+YKL9SmErP1Uwypcw+
	CzmfdicNHAXCBb66UWdwUJqwkBSbxg4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-QDUrNabnOUmPYmwsBePX5w-1; Fri,
 19 Apr 2024 14:13:40 -0400
X-MC-Unique: QDUrNabnOUmPYmwsBePX5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6FE23C23FC7
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACBEB43FB1
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 1/4] bcachefs: drop duplicate fiemap sync flag
Date: Fri, 19 Apr 2024 14:15:35 -0400
Message-ID: <20240419181538.1411082-2-bfoster@redhat.com>
In-Reply-To: <20240419181538.1411082-1-bfoster@redhat.com>
References: <20240419181538.1411082-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

FIEMAP_FLAG_SYNC handling was deliberately moved into core code in
commit 45dd052e67ad ("fs: handle FIEMAP_FLAG_SYNC in fiemap_prep"),
released in kernel v5.8. Update bcachefs accordingly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index de307e2323bb..f6cd14c9b38c 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -963,7 +963,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	u32 snapshot;
 	int ret = 0;
 
-	ret = fiemap_prep(&ei->v, info, start, &len, FIEMAP_FLAG_SYNC);
+	ret = fiemap_prep(&ei->v, info, start, &len, 0);
 	if (ret)
 		return ret;
 
-- 
2.44.0

