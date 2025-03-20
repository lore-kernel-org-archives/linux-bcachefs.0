Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0459833E7
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506386; cv=none; b=Kq462M9Ua3sYGMdTsKU8+LEPiUuK/wQlr5oGTgwSaoQ9PmDIVLloYgCtgMRmkQIsQS24G0jrpLkMYZEo7NvFzQ8aSrn1ukUCwrD2su2xT6fen8IkguxIoFcaGNB3R7HIfu3cQ/y0WeLxkrAZhNN7wfUfGNCYwLdLDWYyQwlAVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506386; c=relaxed/simple;
	bh=d+XerfcS5YIfQMtGYJRH4KNlm6p3FA03XL2dIargv6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kFMqNOd0hHUYMz7YqgS1mShaixa/OP57e5YdxYJFicgVaFqA/bF5hyu0mdr+Lk1iRy6f1Oam50zkGizMdhFKSf7QIMsFHyCxsxk31g0niMVjuMv3kyt5Mndd/kr8xq1PNPOK2zdIQlBTzHS9q4ycK7CJRmgr4UssLo8nfbl1VEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=emhusMaU; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="emhusMaU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=avDsow9gY+u4l1EF1co7/vLw7jp7Nv3zAfzZcDSw1FU=;
	b=emhusMaUqNKyxtgx2rZIuieVInkG1+p9Sh60WldiRuay16BWLXFEv+rFtnnbkX9K7IcGK9
	Tk3yCetvShhjTpSIqNa3mMx1FjLy/c1+tU8n8IwN2SBJ0pcMWlR0zTTklP0SJxDL7v5wKV
	fACwBgKdvnGVFh0ZZThOKKJotMQsWyA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] kmsan splat fixes
Date: Thu, 20 Mar 2025 17:32:48 -0400
Message-ID: <20250320213256.3359777-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

we should be just about kmsan clean now; not 100%, the kmsan tests are
extremely heavy so I'm not flipping them on in the CI yet.

none of these were actual bugs, but this will make a massive dent in the
syzbot dashboard.

Kent Overstreet (5):
  bcachefs: Disable asm memcpys when kmsan enabled
  bcachefs: Fix kmsan warnings in bch2_extent_crc_pack()
  bcachefs: kmsan asserts
  bcachefs: Fix a KMSAN splat in btree_update_nodes_written()
  bcachefs: move_bucket_key -> __packed

 fs/bcachefs/btree_trans_commit.c    |  1 +
 fs/bcachefs/btree_update.c          |  2 ++
 fs/bcachefs/btree_update.h          |  2 ++
 fs/bcachefs/btree_update_interior.c | 18 +++++++-------
 fs/bcachefs/extents.c               | 38 +++++++++++++++++------------
 fs/bcachefs/move_types.h            |  2 +-
 fs/bcachefs/util.h                  |  4 +--
 7 files changed, 39 insertions(+), 28 deletions(-)

-- 
2.49.0

