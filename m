Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BC013A877
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550424; cv=none; b=M5i0BCGipCHXct/5eXcjC9LdKTu1igQf+n2w5EpP1wrmqrmV9Rh+px2npjhDtLZKaa+LVclAmGpfDsFp+pO3+AGN7IeTKH2vSD22OJde5yaKNWWwFA1ovZWx0rbWB9kiEiMl8b/JfndyRMC8hhNexL8qd4Yj9cITXznOZmDK+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550424; c=relaxed/simple;
	bh=pxZrYV8cKInOnwrq0/NJGujEVLfcAmM+zLdU24bgI18=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fo18PiTn6TmAcC5VJFyn0X1Dz3hWwiSdzceH9dchyErfSbp5G4ZnnWg13nJw3+4qlcnJP3qeMUfccFgUBRyFCiudTf0OoqC4iwuy1SwgeghPhy9QkGmkCTWwl7Ef8e9fSm5tKh7+koKVfBTN7iWuyEtwxKmEfJQA9mO5uJOQ+hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJF1UzFc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJF1UzFc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713550421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PQzpxWoIzNriQ5UOBWjWcgMcoBg/XLaSuB+A3UpdBuM=;
	b=aJF1UzFcbGb0qTnUjCl30ulwyOVISeKNDqocY9aAoYaEhUPCntKiiwPn1MZRnwZ0E1hvzD
	aUbSYjNFfqWyBNxLMEJpxzNHZgTiSpDljpF+fxwxmsT7Fy6f1WMNlOpoNeFKwEOgzkQBOt
	A5qTIScFbs59/F5l682ingleJGV/oQs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-ojcjcm-wP4yLzDDinzI97w-1; Fri,
 19 Apr 2024 14:13:39 -0400
X-MC-Unique: ojcjcm-wP4yLzDDinzI97w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F7081C02D49
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FFC443FB1
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 0/4] bcachefs: fiemap delalloc support and cleanup
Date: Fri, 19 Apr 2024 14:15:34 -0400
Message-ID: <20240419181538.1411082-1-bfoster@redhat.com>
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

This is mostly equivalent to v3 except that bch2_fiemap_hole() now
implements a do_drop_locks() style pattern to manage locking order
between folios and the extent tree. The pagecache scan is factored out
into a new helper to facilitate the retry.

Patches also available in my test branch:

  https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian

v4:
- Implement a do_drop_locks() like pattern in bch2_fiemap_hole() to
  avoid deadlock and livelock or excessive spinning.
v3: https://lore.kernel.org/linux-bcachefs/20240408144846.1001243-1-bfoster@redhat.com/
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

 fs/bcachefs/fs.c | 207 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 166 insertions(+), 41 deletions(-)

-- 
2.44.0

