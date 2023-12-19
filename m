Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6F11D540
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsMVx83K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702994475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3K6oje9cUodL4SuAks/OGKm7RhPwxHuIUII23M8d2ck=;
	b=KsMVx83KoW92Vz1rIB72CO8aBReTeA5+fzc5JbEjitWJTN4cPTQBqllPiaB5GGuyIYbQiK
	c/Acidyvu4hq0HsEZ2DWbTDPDVlgGiPm8WUGCmHeu4JiK/nBCrkAJ5GI4DND93zO7rPP0M
	WQJJvaVrGsza/t2706S4SRpuBJa/2dc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-mnnMii8hM3aaOpL6DNnDeQ-1; Tue,
 19 Dec 2023 09:01:13 -0500
X-MC-Unique: mnnMii8hM3aaOpL6DNnDeQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED983C100B9
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7390A492BF0
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 14:01:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/2] bcachefs: fiemap delalloc support and cleanup
Date: Tue, 19 Dec 2023 09:02:13 -0500
Message-ID: <20231219140215.300753-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Hi,

Here's a couple patches to add basic fiemap support for delalloc extents
and make a somewhat unrelated cleanup. Patch 1 formats delalloc data
into fiemap info by faking up an extent key for pagecache resident
extents. When reading through some related code to grok how to do that
(I initially used a reservation type key), I happened across
bch2_extent_fallocate(), found the associated logic a bit wonky, and
thus tried to clean it up. Both patches are available in my CI test
branch.

Thoughts, reviews, flames appreciated.

Brian

P.S., I'm off soonish for PTO. If there are any issues to be addressed
with these patches, I'll pick it back up after the New Year.

Brian Foster (2):
  bcachefs: add fiemap delalloc extent detection
  bcachefs: clean up some dead fallocate code

 fs/bcachefs/fs.c      | 60 ++++++++++++++++++++++++++++++++++++++++---
 fs/bcachefs/io_misc.c | 35 +++++++++----------------
 2 files changed, 68 insertions(+), 27 deletions(-)

-- 
2.42.0

