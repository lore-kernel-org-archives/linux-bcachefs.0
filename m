Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90613F433
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712587612; cv=none; b=B/NkYcXPy892g7HImBniKbXyU9v3pRnm1H4chzhZPURYICwoGjDTRhEX6Rg8NR8zwNfuR25jFcIOaztRx+ZggPLwVOUDLM0jhPv7NHxr6jQK2UD7i2L0TbdN+dkzSH4yYB6ZlN9El0Ye8P6/ejUbyVUYPWVZ3HE4SEqq9pMpwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712587612; c=relaxed/simple;
	bh=ZNyPdi9gwDs6okSYIB3uFmuZC+Ik8WCH8Q4IDz6eCnU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aaGIZ8QEML3rlZE7F8C+Ok51GSv9JO8Z+OUiuOH4ie2NjoU0RPhuFf9i48hxpvTkPWCafMc0S7sZpSv7HV+eHR9HWytXBBrH8rkD7z/KUJl2PMXG//MCH4HPJYuaGwohEbZSUzC3+vJRELWmgxgLIH7QVA/4AjHrsqoRxjEgUpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hoU948uZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hoU948uZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712587610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RSHphSHRet93tEDtalVSdP3Oq8DGO/EL44E9FO+SeS4=;
	b=hoU948uZugiv0GAAUmmwhasKWI9XSiPEoEJ9/Lkc8IgBP1G8yEd3x81ofNe0Zw/GCPFY1K
	52LQFHfvAhL07u+slKsSsnQsIlLMAaGibsjGY69rXhqdrahPMbhgjyoZmUpJeFgmXkpoAD
	ENTucP7Umx8clifmYGfKloBPsBExSbg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-wepGNB5KPi-mVqQpjULvrg-1; Mon,
 08 Apr 2024 10:46:47 -0400
X-MC-Unique: wepGNB5KPi-mVqQpjULvrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B3A53810B31
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6DD462026D06
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Apr 2024 14:46:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 0/4] bcachefs: fiemap delalloc support and cleanup
Date: Mon,  8 Apr 2024 10:48:42 -0400
Message-ID: <20240408144846.1001243-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Hi all,

Here's v3 of the fiemap delalloc support patches for bcachefs. The main
difference from v2 is that the pagecache seek calls are now using
nonblocking mode to avoid deadlocks between fiemap and the write path.
The write path locks in folio -> extent btree order while fiemap walks
the extent btree and scans for folios in transaction context. Therefore,
the latter must restart the iterating transaction in the event of folio
trylock failure and restart the scan from where it left off.

The series is pushed to CI via my test branch, as usual:

https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian

v3:
- Use nonblocking pagecache seek to address extent btree vs. folio
  deadlocks.
v2: https://lore.kernel.org/linux-bcachefs/20240117155611.248042-1-bfoster@redhat.com/
- Clean up bch2_fiemap() a bit to use processing helpers.
- Added patch for sync flag fixup.
v1: https://lore.kernel.org/linux-bcachefs/20231219140215.300753-1-bfoster@redhat.com/

Brian Foster (4):
  bcachefs: drop duplicate fiemap sync flag
  bcachefs: track current fiemap offset in start variable
  bcachefs: refactor fiemap processing into extent helper and struct
  bcachefs: add fiemap delalloc extent detection

 fs/bcachefs/fs.c | 175 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 133 insertions(+), 42 deletions(-)

-- 
2.44.0

