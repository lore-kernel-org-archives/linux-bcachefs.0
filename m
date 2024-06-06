Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533E196C65
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682295; cv=none; b=Ma3ABK8ZWCQp3W9XUbwqHEB1rfHtQoJgAZzABz+BvExAHYPw+JoIkER+SXgjIZn4lHS7mzuY/jqvqnSpW4sbKe+juDoCLVC36/Meluk0+oCKoj25g6i1NZddS1qZyH83F4IDOivX25j6Dd9DWhZpofTVPrU3ossIYV+rJX4ZLbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682295; c=relaxed/simple;
	bh=3GkRDit6IsitFsgIF/TxZ0OEvo6U1Y4Q+kJhulDvRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IgJtgHOsUs+09dN2gWV0dUOHROw+iCnM2ZfKtVat3lQNE0TL5SswGZhmFNjHRozRcHcjKyxArxXsIokjWBd9jkDdmR8OWTZlcqgn1txs5winRFm7+HcyRHs35aMGE7aaouxNcC+6lheHkJf1djaFGnbWmYzKX1Aza9jCBpFvRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ah06udUc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah06udUc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717682292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y572SaCTpxdimu0de/dSzCAj14DCjckzezYe8mkX/eE=;
	b=Ah06udUcyrUE7X0TNoB8Fs0nglb7a8ileIPPHd8Jux/i1bsaKBKcJZIIvpjRv6Hbrsnhip
	21yXWxkTM+kxxnMnAhlTZN41s/37L90xev8CHWYvjJGwzg35Q/HEcXGh48NL1Dfjns2RIB
	qy26lD1BgInz1DAawYNTH2rg0B57gjc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-CeB_710HNTue02bRYEKWWw-1; Thu,
 06 Jun 2024 09:58:09 -0400
X-MC-Unique: CeB_710HNTue02bRYEKWWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 550833C00085;
	Thu,  6 Jun 2024 13:58:07 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D9D710139;
	Thu,  6 Jun 2024 13:58:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] bcachefs: fix smatch data leak warning in fs usage ioctl
Date: Thu,  6 Jun 2024 09:58:26 -0400
Message-ID: <20240606135826.1684764-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

smatch warns that the copy of arg to userspace is a potential data
leak by virtue of arg.pad not being checked or zeroed. This was
introduced by the commit referenced below that switched arg from
being a zeroed runtime allocation to living on the stack. Fix by
simply zero initializing the structure.

Fixes: cde738a61e65 ("bcachefs: Convert bch2_ioctl_fs_usage() to new accounting")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/chardev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 70db3a737d71..4248c251fce5 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -515,7 +515,7 @@ static long bch2_ioctl_data(struct bch_fs *c,
 static long bch2_ioctl_fs_usage(struct bch_fs *c,
 				struct bch_ioctl_fs_usage __user *user_arg)
 {
-	struct bch_ioctl_fs_usage arg;
+	struct bch_ioctl_fs_usage arg = {};
 	darray_char replicas = {};
 	u32 replica_entries_bytes;
 	int ret = 0;
-- 
2.44.0

