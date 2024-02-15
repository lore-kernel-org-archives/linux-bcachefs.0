Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694012882C
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708017273; cv=none; b=Ly+CYjq4kHqO7zMzXyfPk/OUL2y4IlJnUjWx22RXd+MwSRdrNJq7SRry55v94I00YGp5BTKez6QSX0L0aBzVCAzgtj+zKR8ZAUdl0/MEE4t7N3c3YZXTRgcV9qnk8aXfWkZYA8MU1aRbMxHlrw5Ie6O2BkNt7S62Uz2k3U9mHRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708017273; c=relaxed/simple;
	bh=yfaciUlMFQvo4t+YLdW6k21L4jGFLuZPOaKQmgyscY0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MZQRZ0jr4/2LUQNH6xJiJ3y7oTwq30CmG8cGM/Pv0bzScvhEdZnHGX9HILlicS1yv7pUwLGBuQos8XKMYfwEflayq+QFggNVRsJD62J3ItydPZgHVpjDCLLBaj4BGniTtQoIEyjEsvsnheoCKwmEwKtZ0p4tER/FLzE1j5H+IIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zgn8WUJh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zgn8WUJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708017269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZwZ7hQ7n7uqf/6vaNyxhEyhs3xJAJSz35cuc/sAo87w=;
	b=Zgn8WUJhDvJ7m/m8UNJgNAMDYlMaLZYjbHQoxsoEeU7QVUw+eNKI27u1IgwB/WiwhaXmHJ
	DVgwhNi2nw/ab5kU77BvFWbTMy444Roh3JAd15wcpTpsz1LFHdE45y2MJBIKO4hhfwfwrW
	e6KaCkJBTBU2eOXg+E50NsguXUSFTrg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-1_zgcDZKOKejdSTsPsZ3uQ-1; Thu, 15 Feb 2024 12:14:27 -0500
X-MC-Unique: 1_zgcDZKOKejdSTsPsZ3uQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93B07862FE3
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 17:14:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78C18AD6F
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 17:14:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] bcachefs: fix iov_iter count underflow on sub-block dio read
Date: Thu, 15 Feb 2024 12:16:05 -0500
Message-ID: <20240215171605.162107-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

bch2_direct_IO_read() checks the request offset and size for sector
alignment and then falls through to a couple calculations to shrink
the size of the request based on the inode size. The problem is that
these checks round up to the fs block size, which runs the risk of
underflowing iter->count if the block size happens to be large
enough. This is triggered by fstest generic/361 with a 4k block
size, which subsequently leads to a crash. To avoid this crash,
check that the shorten length doesn't exceed the overall length of
the iter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Ok, I think Su expressed preference for this variant over v1. I'm off
for a bit after today so I'm throwing this up onto CI in the event that
we'd like to at least get the crash problem fixed. If there's more to
look into here, let me know and I'll add it to the todo list after I'm
back..

Brian

v2:
- Check for underflow instead of removing shorten entirely.
v1: https://lore.kernel.org/linux-bcachefs/20240205154814.910664-1-bfoster@redhat.com/

 fs/bcachefs/fs-io-direct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index e3b219e19e10..33cb6da3a5ad 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -88,6 +88,8 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 		return ret;
 
 	shorten = iov_iter_count(iter) - round_up(ret, block_bytes(c));
+	if (shorten >= iter->count)
+		shorten = 0;
 	iter->count -= shorten;
 
 	bio = bio_alloc_bioset(NULL,
-- 
2.42.0

