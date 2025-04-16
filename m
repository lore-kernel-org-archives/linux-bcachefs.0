Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E251C5D44
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811040; cv=none; b=X6V+Mi7YYbAXORAK8OzgphqjN/hF+5JQnKiqhjBmq1qzwbXJYwP3egd2QNKAPeTedNyLnFlq9sV1KQrxkdr+b93pbKn0mWRmCbNzanr0cMLKJf9HoUFj0xL/m4Pfft/0wxhxyIe3oYLzuTdxELDDWk713V6lsVyLCXkLq6FlSNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811040; c=relaxed/simple;
	bh=sa0Rkwcwyc6UmL4z5bC8UrRGpzR1Ry513pZcHwl4x5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XV0XM9+V1YgWIUdN8+gdogYV7KPeN2S+XVzVL1zWtlXdLbtZsTHZkZdoD/IRvjCs/buua4hAaq1KMimmPxKC/68yR6hu0uOR2/GKo0HC7M79lfMLkZcgPgjoVVGxdqzkmrSS+TDr7pwlVH+XE5LNsl0jT9qd5BeulTTD18KpxGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qwnLHsiA; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qwnLHsiA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744811036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IGFVCcQn2BHI/qZJ7osR5Ma4mrT4wzuFLNhivrcvwxM=;
	b=qwnLHsiAzuO0FZRbuXkfLY17wGE4ul/rs1QCzovYCtupvrz0n0ZCuxuG6MQwAFdtrDSY4d
	txlfKBn/DroTHPRIFtcH4X4xCt/my8Czivo76lZTaF6xKQm7/hiYpJH9BMt6GyCXEB+oHU
	vpEbipnNW/qH696KEhAa9cNbTjiUlLw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/4] more fine-grained btree node moves
Date: Wed, 16 Apr 2025 09:43:45 -0400
Message-ID: <20250416134352.3654545-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this tweaks the data move path so we can move specific btree nodes to
specific devices

it's for the new image creation tool, which uses it for generating more
deterministic disk images.

- create a two device filesystem, with data on one device, journal and
  btree on a second temporary device
- write out all data
- move the btrees we want to keep to the primary device
- drop temporary device, shrink primary device

Kent Overstreet (4):
  bcachefs: Plumb target parameter through btree_node_rewrite_pos()
  bcachefs: plumb btree_id through move_pred_fd
  bcachefs: bch2_move_data_btree() can move btree nodes
  bcachefs: bch2_move_data_btree() can now walk roots

 fs/bcachefs/btree_io.c              |   2 +-
 fs/bcachefs/btree_update_interior.c |  37 ++++++----
 fs/bcachefs/btree_update_interior.h |   4 +-
 fs/bcachefs/move.c                  | 104 ++++++++++++++++++++++------
 fs/bcachefs/move.h                  |   4 +-
 fs/bcachefs/rebalance.c             |   2 +-
 6 files changed, 112 insertions(+), 41 deletions(-)

-- 
2.49.0

