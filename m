Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3CF21A15
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705506900; cv=none; b=qg9IBT5moHbiir0DmTPYBuvdedwaukCk3gXcnKHhVq5p1ZKbbTE85+H7xELbb1qZw1Ey/StLU61ni5+7DuYBgfqA4BiWwy/G3jSttp0q7fyWlDsTOB5QQSA0Tx1ee/oqRgomMySi2ME8vv14WqopncYhxq1UbRtEJ66WcuSRph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705506900; c=relaxed/simple;
	bh=O5/AV+b01fQcUSLfNoznSHX0OtnJjY69QR8dX2N0vxI=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By; b=XmOKe7Dq6sMM/vvLjAeaM0SipK66x70c/IYwoAMEsNBB6kI98RYi3hnZy/elmj2caSdcdeKA0gcJY2hIpm2QZbkAFRO4QuVBFKfkUQT5ZCt7/Et+tPWur/J/GhMLE6WsLw4iwnFwZRx06KH49fybJg5KBWPwt3wap/0RYo2k58U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EO7vZWEf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EO7vZWEf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705506898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqzdmLpiv0g8leIsHgZgq61cKor5D31l6COO5o4uPdE=;
	b=EO7vZWEf8r7jh2VyebnGdXMnJ0CB4IC7iOHeDvwCFZpv6onWZGCD7rVRLYraerDcx68dl+
	pVeub4qemzi1vS32Ian9gHHoKI1cghSnEls0V24aBLsev9J81fkEv+4DrTDkSJ3d2GuvM6
	n5BBSRSuszT82jLhsCjv0nagO38I+sw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-WFB7d4pzMmuL3t5jfTsAvA-1; Wed,
 17 Jan 2024 10:54:56 -0500
X-MC-Unique: WFB7d4pzMmuL3t5jfTsAvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57E262932497
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0C91BDB0
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 1/4] bcachefs: drop duplicate fiemap sync flag
Date: Wed, 17 Jan 2024 10:56:08 -0500
Message-ID: <20240117155611.248042-2-bfoster@redhat.com>
In-Reply-To: <20240117155611.248042-1-bfoster@redhat.com>
References: <20240117155611.248042-1-bfoster@redhat.com>
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
index da11757682c0..696f266febfe 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -897,7 +897,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	u32 snapshot;
 	int ret = 0;
 
-	ret = fiemap_prep(&ei->v, info, start, &len, FIEMAP_FLAG_SYNC);
+	ret = fiemap_prep(&ei->v, info, start, &len, 0);
 	if (ret)
 		return ret;
 
-- 
2.42.0

