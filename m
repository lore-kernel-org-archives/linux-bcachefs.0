Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C421347
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705506900; cv=none; b=PzYqmlTvj6/Rc4+zAt2tOZFEpGwKDM7T1h5V1CVk1scp40M/IzLA16D739Wub6MZ4VC19RSJQhx/rvzeAeuAcQoXwUy9NTWGVLmgjAlIHN4LkxZ4KoyW8YsAxrKr7lbOTb3n8nAlQS2sg8WiZTq+1oJg+jjcskHNPezh2vWNEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705506900; c=relaxed/simple;
	bh=oOq5hZWOer/1EMhGkkvrRabf3J+/Zk832sjAZjU4Ztk=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Scanned-By; b=btt+S2UCZMgWL3fUCx07AO9QafsYYKPkS9ef5zM2ftu3OQP7I4hxY0eb+sxJU7gOQUrad7gWXGBO/NxY28iXTF2aLklf79AKTWXKILLG8D2VLiVcq3LRsSuCNsgiBk4wgTaiCYK7dx0AMFGZSDEaCexmAw4E1kaon1UDF0pd8+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DpzxWs4t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DpzxWs4t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705506897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sDhecb0BNkMHpWgUi6WaBR3W4F8eS0R74KUVTBPTHT8=;
	b=DpzxWs4tbi+wwUrFpLUbq7KgCoEpqovAEh/Y6s0Bh+pWrbjb4m/d3LEsRrDD/7EdeGIMK8
	aCVbu3WNQ4YnB7bBZoG5p1C6f7dm+hDRAB21pYMoO13kJaEAwQkLX/xQA4cvncipNb5uLo
	hH9PlVsEqLs7hSsR6sISJH+tnTJZEkY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-uxSLb8T-PXig3i0K_MCTJw-1; Wed,
 17 Jan 2024 10:54:56 -0500
X-MC-Unique: uxSLb8T-PXig3i0K_MCTJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F2251C2B681
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1423DFF76
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 15:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 0/4] bcachefs: fiemap delalloc support and cleanup
Date: Wed, 17 Jan 2024 10:56:07 -0500
Message-ID: <20240117155611.248042-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Hi all,

Here's v2 of the fiemap delalloc processing patch. The main feedback to
v1 was around the organization of the code, so this tries to clean that
up a bit. Otherwise the functionality/behavior is intended to be pretty
much the same as v1. The main difference is that bch2_fiemap() is broken
down into helpers to clarify between when it's processing extents vs.
holes, and to generally separate extent key processing from the high
level scan.

The series is currently posted to my CI branch. I don't _think_ there
are any immediate regressions after having a look through the failures
on the head commit (as well as via my own local testing), but ISTM that
the variance/failure count on the baseline branches has increased a bit
from where we were at a few weeks or so ago...

Brian

v2:
- Clean up bch2_fiemap() a bit to use processing helpers.
- Added patch for sync flag fixup.
v1: https://lore.kernel.org/linux-bcachefs/20231219140215.300753-1-bfoster@redhat.com/

Brian Foster (4):
  bcachefs: drop duplicate fiemap sync flag
  bcachefs: track current fiemap offset in start variable
  bcachefs: refactor fiemap processing into extent helper and struct
  bcachefs: add fiemap delalloc extent detection

 fs/bcachefs/fs.c | 156 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 113 insertions(+), 43 deletions(-)

-- 
2.42.0

