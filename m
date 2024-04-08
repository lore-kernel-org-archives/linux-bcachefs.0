Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F21CD21
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712587614; cv=none; b=qR1T36RHbfQyucnUjGNwGlht6IUKAiWdCUCTv58iwou9y8guoRhy1eH917Qsmd4KJldRz2bb2wZjtEayrWSgBRMfxsGD/WRoIqgvIBTjek14iEjd43f9HgEAiSj19lDeRtjdhH0iWdfpU9e/W0wkqqqOiKnZM5RQ9g9lSl0gGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712587614; c=relaxed/simple;
	bh=otgssSGqBz4LTkrVdkLhrV3R+E+1b9czUEWWwmDnnn8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=flAwCZkYQYctrY6rVNCgAM3NKvqWne/kfm44lbgV05prbtELliCETZP30Vzix9ImWvqx9ME+gnceRAI76BhLD8DyiFLEIvgaihivKQXh2VIbVpWvLVPJUMrKAuyC+7T5BnoBrhVieiqMLg9rhc4bqs1KFjQ6hOJvSHZT7Av9NhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJLkeEW4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJLkeEW4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712587610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfoVUEo5aT4NJfeEf17QyGYfkTbj4rTgwvWGiBAf/8A=;
	b=QJLkeEW4U911E1bt6YdNDJFjzVlSnsYURKnDIZWMIzV6i2nW7M2Lue+hejU/X6tR2fJcM2
	8AsHMlEMT2X6jSjxL3r609AkLtce2g7XklikMTxXWzvOILF6KLo/TW2ypAFpa1lPUtT291
	36e1iM7zXZWpNRY6IVYxJocG74e26q8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-ONaoARHiMBe-3oX67W-2ig-1; Mon,
 08 Apr 2024 10:46:49 -0400
X-MC-Unique: ONaoARHiMBe-3oX67W-2ig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E701C3F0EB
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 995882026D06
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 1/4] bcachefs: drop duplicate fiemap sync flag
Date: Mon,  8 Apr 2024 10:48:43 -0400
Message-ID: <20240408144846.1001243-2-bfoster@redhat.com>
In-Reply-To: <20240408144846.1001243-1-bfoster@redhat.com>
References: <20240408144846.1001243-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

FIEMAP_FLAG_SYNC handling was deliberately moved into core code in
commit 45dd052e67ad ("fs: handle FIEMAP_FLAG_SYNC in fiemap_prep"),
released in kernel v5.8. Update bcachefs accordingly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index b5ea9fa1259d..137ce028bc3c 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -967,7 +967,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	u32 snapshot;
 	int ret = 0;
 
-	ret = fiemap_prep(&ei->v, info, start, &len, FIEMAP_FLAG_SYNC);
+	ret = fiemap_prep(&ei->v, info, start, &len, 0);
 	if (ret)
 		return ret;
 
-- 
2.44.0

