Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343D913EFE8
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712587614; cv=none; b=ED79xLlBSJoUeNo0pas02clBy5p+H3g3EnPpHnnWRsgS6IeqoGv0CbtoLhwNpc4nRpIvM19AAXuQMoAsj8KKHG595qYsYwvWVWtZ9a+buYsbmoWdZPM7Ha2dSruDsP2GKmameHcvbDF8wovAQO6/cwokCxCEmhOuplP6MQF+m2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712587614; c=relaxed/simple;
	bh=0HqcTozLN0/SbpaS70A1tec4/+eY2f7GJ/4bY032IFk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbIy//Zakr9kFAVs7naLZVhEkU1/sycTkC0juSzc5gf5bKtiElyyCWpVm5GAoA0+n8ytzO3MQT4dtnlWr+nihbRGOThtHOfkY1Ox9Wkd9HTFOce7tzB4ORuW1SxpOTwX3sW7tbS3F8z0bQt9Xx/zl8hOkQ9/WLCALWsG03Wa7k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XC/NyQOs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XC/NyQOs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712587611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdXf2W9jQnz15IHr3Rs3FuKQc3cKOVGl+szpSiXECtU=;
	b=XC/NyQOsja3iwclw8jZ8UF8kWl5NqAW1LR2bqJuizGSYWxDq1csXlsbyU/eh/AzYo+YsFY
	n7VolBkK2loTcepEtKT3gKN1X7Wk9bRWeCuA9DkKdo2qSRXVIDDK5OOJFkw+KcpWHWom0i
	TCVFqVV/aHl8Q+6yeDFS6dRHaOikLKU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-A5crNaLiOY663d7F9Nrk3Q-1; Mon,
 08 Apr 2024 10:46:48 -0400
X-MC-Unique: A5crNaLiOY663d7F9Nrk3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D6F29AA2CB
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD5F32026D06
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 2/4] bcachefs: track current fiemap offset in start variable
Date: Mon,  8 Apr 2024 10:48:44 -0400
Message-ID: <20240408144846.1001243-3-bfoster@redhat.com>
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

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 137ce028bc3c..9c86749b256e 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1015,6 +1015,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
 
 		sectors = min(sectors, k.k->size - offset_into_extent);
+		start = iter.pos.offset + sectors;
 
 		bch2_cut_front(POS(k.k->p.inode,
 				   bkey_start_offset(k.k) +
@@ -1035,8 +1036,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bkey_copy(prev.k, cur.k);
 		have_extent = true;
 
-		bch2_btree_iter_set_pos(&iter,
-			POS(iter.pos.inode, iter.pos.offset + sectors));
+		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
 	}
 	start = iter.pos.offset;
 	bch2_trans_iter_exit(trans, &iter);
-- 
2.44.0

