Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611962C95
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482085; cv=none; b=arIxBUZK5dLPaBKPmkrnIkivcALIqUgIO/G2bGHYbddaLgPgD2EW7D60M+4YLpuBouBFsLp0oi83xSXpTt3u9bYfxqgMRG+1dRINwnxuKYYu1YwK/1ZIF0YTm+jEhYXl8BEBKoVIbjV+yrZBN1g8BRo/5ybZ1iHzMPWaIwFORJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482085; c=relaxed/simple;
	bh=pv6JGa/D9Gh8GFZ4R0VTy7YlDkH+cU8pyd+16IPRMeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDU+baS5uZfLZWQz8GoOk1PVKo/PdunkgNI8lvJpKY8tURNbw9D3KF48qekyjczJ2VTvtpn+GNHFrY8RF7nK6IDSBPyQLfp28Rh+cXGArgJliKJQNuTYSN36qh/w/KavDmCjH/28PuqeoeHM2fDGmfrds22SWEZJxzgpHa4skc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RO+Fki1j; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RO+Fki1j"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6wGUlj6XKny0ayxtXimCqo7UPCpf485mcpzupm1NwSo=;
	b=RO+Fki1jizEqL/UBFHrtMcNYqxCuIrz3Fju91h1EeNDdIFEV/O8XaOvdq7PRPxXBeV+5gv
	SjeY9qYukwuq4fNqcUmaWScAS9oT3bC9kv2pUnV5xsDRf/W9Nad6i4kXfXCIMnQ1Tg6n+P
	P6fQkQ3VpdjNVW8eRVyhV+JnuKqWS8s=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 00/12] rebalance + reflink improvements
Date: Sun, 20 Oct 2024 23:40:51 -0400
Message-ID: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reed Riley found an interesting bug where too many cached replicas were
being kept around in extents, and the data update path barfed when it
hit the limit.

Fixing this meant adding some sort of policy for when we keep a cached
copy around (answer: we now keep one, if a promote target is set and
it's on the promote target).

But for that to work properly, the data update path needs to know what
the promote target is...

This series plumbs the full set of io path options that apply to
rebalance through bch_extent_rebalance (i.e. they're kept with the
extent when needed, meaning they're available for indirect extents),
regularizes and cleans up a fair amount of stuff, and makes it possible
for new options to take effect over the options in bch_extent_rebalance,
in the extent (we now track whether the option came from the inode or
the filesystem, so inode options can correctly take precedence).

data_replicas and data_checksum are now plumbed through
bch_extent_rebalance, as well.

Things that did not make the cut:

- Setting new options on a file doesn't yet apply them to indirect
  extents. I wrote the code for this, but it's a security hole without
  knowing if this was "your" reflinked data, or copied from another
  user. Handling this will probably require bch_reflink_p_v2.

- Rebalance doesn't yet apply new data_replicas settings in the
  background, like it does for the compression and target options (this
  would remove the need to manually run 'bcachefs rereplicate'.

  This one will be easier to do, but I think I want to do some cleanup
  on data_opts next.

The first patch in the series will go to Linus shortly, the rest next
merge window.

Kent Overstreet (12):
  bcachefs: Don't keep tons of cached pointers around
  bcachefs: use bch2_data_update_opts_to_text() in
    trace_move_extent_fail()
  bcachefs: bch2_io_opts_fixups()
  bcachefs: small cleanup for extent ptr bitmasks
  bcachefs: kill bch2_bkey_needs_rebalance()
  bcachefs: kill __bch2_bkey_sectors_need_rebalance()
  bcachefs: rename bch_extent_rebalance fields to match other opts
    structs
  bcachefs: io_opts_to_rebalance_opts()
  bcachefs: Add bch_io_opts fields for indicating whether the opts came
    from the inode
  bcachefs: New bch_extent_rebalance fields
  bcachefs: bch2_indirect_extent_error()
  bcachefs: bch2_write_inode() now checks for changing rebalance options

 fs/bcachefs/data_update.c    |  88 +++++++-------
 fs/bcachefs/data_update.h    |   3 +-
 fs/bcachefs/extents.c        | 223 +++++++++++++++++++----------------
 fs/bcachefs/extents.h        |  13 +-
 fs/bcachefs/extents_format.h |  45 ++++++-
 fs/bcachefs/fs.c             |  26 +++-
 fs/bcachefs/inode.c          |  12 +-
 fs/bcachefs/inode.h          |   8 ++
 fs/bcachefs/io_misc.c        |   2 +-
 fs/bcachefs/io_read.c        |  31 ++---
 fs/bcachefs/io_write.c       |   2 +-
 fs/bcachefs/move.c           |  90 ++++++++++----
 fs/bcachefs/move.h           |   5 +-
 fs/bcachefs/opts.c           |   5 +-
 fs/bcachefs/opts.h           |  29 ++++-
 fs/bcachefs/rebalance.c      |  48 +++-----
 fs/bcachefs/rebalance.h      |   1 +
 fs/bcachefs/reflink.c        |  15 ++-
 fs/bcachefs/reflink.h        |   2 +
 fs/bcachefs/xattr.c          |   7 --
 20 files changed, 393 insertions(+), 262 deletions(-)

-- 
2.45.2

