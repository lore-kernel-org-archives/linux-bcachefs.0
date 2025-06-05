Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E48F27C879
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Jun 2025 19:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151902; cv=none; b=DMG0Tt1rwZQqbKSft7ej1RraJpfEtwMKncFB8+uMgJfggJBJMxBDVAdCOcNoRbetGfZEog/2O4Blv3vnWYtkVT4mj/wyZOkxBOKQk7qH0lBRxwU7R/tkurMP7WDzw7crXhIYjOiTza1Q78oEwa8mXCnID8orkUOcFRSPnFsb8VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151902; c=relaxed/simple;
	bh=kZPC/bU4FUO8Snlgdk/X+AXh3Tple8zWEBX/6jS43Zk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kUMd0ze3qrCLmDJk6TaJkVqpCJc4Tf67rYmv3YtdqYqQqqBcff4xi45cn4ZLm9kg54rFIVTXx+26tcuxe0411Hy4dWtZZZ4AlhFJj91olWS5kf3MJBseggowDFb/hwpHKD8HUDWe2zdmj8oy2BEqC/VJrXBztl8bk5uxjcM09lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oNYTSUrU; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oNYTSUrU"
Date: Thu, 5 Jun 2025 15:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749151887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=47NC+eUtASoUvob4ZWSGgly7GR6tZd5QJ0FRo18wtKM=;
	b=oNYTSUrUppbjso7MGwtOZbIqBmfq9MsAxb6zwzVKUKwEJYeuEJO4Es2J0nGZ2WrvvLMgeg
	eCtZsBP6oatmGKo/FHVFUD4ajxi9JJCyOWpeD93VZ6OMX0asJTQYV/W3SLIrLN/IUpufpG
	poK25IrVX2wHGUYBkuOd6/QulijEb28=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.15 stable
Message-ID: <xlnudv42ksgzhydnz4uefmiuh4f6ebtixwwjh2mwj5fivw24ll@tczlx6fmsu5k>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

The following changes since commit 3ef49626da6dd67013fc2cf0a4e4c9e158bb59f7:

  Linux 6.15.1 (2025-06-04 14:46:27 +0200)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.15-2025-06-05

for you to fetch changes up to fc9459c9a888766c4c4adff59b072aad1bfbf6ad:

  bcachefs: Fix subvol to missing root repair (2025-06-05 14:04:58 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.15 stable

----------------------------------------------------------------
Kent Overstreet (5):
      bcachefs: Kill un-reverted directory i_size code
      bcachefs: Repair code for directory i_size
      bcachefs: delete dead code from may_delete_deleted_inode()
      bcachefs: Run may_delete_deleted_inode() checks in bch2_inode_rm()
      bcachefs: Fix subvol to missing root repair

 fs/bcachefs/dirent.c           | 12 ++-----
 fs/bcachefs/dirent.h           |  4 +--
 fs/bcachefs/errcode.h          |  2 ++
 fs/bcachefs/fs.c               |  8 ++++-
 fs/bcachefs/fsck.c             |  8 +++++
 fs/bcachefs/inode.c            | 77 ++++++++++++++++++++++++++++--------------
 fs/bcachefs/namei.c            |  4 +--
 fs/bcachefs/sb-errors_format.h |  4 ++-
 fs/bcachefs/subvolume.c        | 19 ++++++++---
 9 files changed, 92 insertions(+), 46 deletions(-)
