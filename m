Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A63C21347
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705506898; cv=none; b=MlhBqeT8mG1LTgyTjXmV3718AXuVFgyqn2eizO1+ILN7/SO4CMVVrhVTeifWJTGSJ9h40kTcxhn7dQVGxp62rTWaCO7n41dUSc9FxXHOFEFvZMxv4Xx8txlJ73edbHGUh+fU00pHouLGp9wN2p3CGVsGei5sM1JjwP187sX7x+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705506898; c=relaxed/simple;
	bh=KiPkJgcZApa3VhGro0U2VO+ELCvyX0whNRmdCOKBCgY=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By; b=NLKv6CEAen664rIvFXZ8Uvj6T8LFER5lcNh1SVZ9NklgayIpdy9oZWP4JQnGASmgW5HzIQTdJ/Aw4M/yb2q2GC5VeazKSPgpeXcTRtIPxg+V50V7SKXJGLg/vItjVK0n2DoZ+tDBcIxLzLfXpdoaZ65gjFX3w0Zn4QeXGpzdjgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enP3yFbX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enP3yFbX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705506895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+oOLJt0ifL6z++Zc0huhNwSMj9ockBgMkIk/zf3IQQo=;
	b=enP3yFbXuveDKDIA++UtCTtPh3Z6DP2V4cxKmvIOYUvT0IcQHHDR99kcezR54COd8YS9u6
	QEEKR9/sSSoMzppf9q2I1bKYw84c3Rxi+A4TeZwyUf82A14HPgBx/rf3MTgsT2VtAOf1je
	7PVcHIyKNNUTdguRkORYL/S0a4fvGeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-ESzvQYSWPOa8NRgOcK_3Iw-1; Wed, 17 Jan 2024 10:54:53 -0500
X-MC-Unique: ESzvQYSWPOa8NRgOcK_3Iw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E31687280A
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64ED9FEEE
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 2/4] bcachefs: track current fiemap offset in start variable
Date: Wed, 17 Jan 2024 10:56:09 -0500
Message-ID: <20240117155611.248042-3-bfoster@redhat.com>
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

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 696f266febfe..c9f426905ef9 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -945,6 +945,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
 
 		sectors = min(sectors, k.k->size - offset_into_extent);
+		start = iter.pos.offset + sectors;
 
 		bch2_cut_front(POS(k.k->p.inode,
 				   bkey_start_offset(k.k) +
@@ -965,8 +966,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bkey_copy(prev.k, cur.k);
 		have_extent = true;
 
-		bch2_btree_iter_set_pos(&iter,
-			POS(iter.pos.inode, iter.pos.offset + sectors));
+		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
 	}
 	start = iter.pos.offset;
 	bch2_trans_iter_exit(trans, &iter);
-- 
2.42.0

