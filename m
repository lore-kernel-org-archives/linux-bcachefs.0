Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4D074BED
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506239; cv=none; b=nWPUfInh/9AllVfadYGCASndGcrjSz2xhbMCksAXXgNFqHzM3W6q0wOo+bwSkPgjSI83cN0D+DmJc/CQ9NZLjYX8r0uhYLByOGPf4fAYgWeL5E6BINueHHfH7Qt06N2h3QmeggvrGZLJJYfNfb5kjz7kDYYcZGvzbqsHY9veY+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506239; c=relaxed/simple;
	bh=xRScA5KZPTVW34C+1yiOYUXspVR6SKwdudcEFfwhW00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZcmWTmK4NreS6tOYz3EfATTgCoTywGbUuOMd9MnB7CN3MZ3D1AWOS0mceKliBtilROPy89tK4ylsoweo4M70dY0GPREkhPnJLVGPg0+MchvITCWgZQR8uKPl81aeNdtUoJ5hrn/4mAEjpLFuhfCwYI+F76dxdIp+pKiVa4BDLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hqM9hTVd; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hqM9hTVd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BBQQbrQZNXS8pBhRN9z1TjdmngyXH2vE3f1dXIIXfOw=;
	b=hqM9hTVdGXg7Bf9lf3lMbYkASfeMajby0bDNjCmPo9DbPJyGm3VVbsCfF+neOtrJHqWdPY
	bxQMplaoJzm7x0upLZp35jOr9uUQStnv360xif/sohwadiTHfSkbUG8z7zokNt/gkU8nyr
	NwkhTOUjQXW2I2fvKk5pr+FQ9xI56tU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/4] self healing: inode <-> dirent checks
Date: Thu, 20 Mar 2025 17:30:15 -0400
Message-ID: <20250320213022.3359645-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

there have been some sporadic reports of "dirent points to inode that
does not point back" errors.

the reports I've seen look harmless after repair; no deeper corruption
involved, the inode backpointer field is off and nothing else. we
haven't caught it in the act yet - i.e. found the transaction in the
journal that did it - but this is something self healing can cope with
fine until we get it root caused.

this series takes the fsck code and adds it to the lookup path - the
general strategy of self healing is "any time we've already lookup up
multiple keys, check the relationships between them whenever it doesn't
cost to do so".

note that self healing hasn't actually been flipped on yet; i.e. we
won't be repairing outside of fsck, just running the same checks fsck
does (and going ERO if they fire).

once this has been out there for a bit, we'll flip on self healing.

Kent Overstreet (4):
  bcachefs: fs-common.c -> namei.c
  bcachefs: Move bch2_check_dirent_target() to namei.c
  bcachefs: Refactor bch2_check_dirent_target()
  bcachefs: Run bch2_check_dirent_target() at lookup time

 fs/bcachefs/Makefile                 |   2 +-
 fs/bcachefs/dirent.c                 |  51 ++++++
 fs/bcachefs/dirent.h                 |   2 +
 fs/bcachefs/error.c                  |   2 +-
 fs/bcachefs/fs-ioctl.c               |   2 +-
 fs/bcachefs/fs.c                     |  34 ++--
 fs/bcachefs/fsck.c                   | 231 +--------------------------
 fs/bcachefs/inode.h                  |   1 +
 fs/bcachefs/{fs-common.c => namei.c} | 180 ++++++++++++++++++++-
 fs/bcachefs/{fs-common.h => namei.h} |  31 +++-
 fs/bcachefs/recovery.c               |   2 +-
 11 files changed, 289 insertions(+), 249 deletions(-)
 rename fs/bcachefs/{fs-common.c => namei.c} (75%)
 rename fs/bcachefs/{fs-common.h => namei.h} (61%)

-- 
2.49.0

