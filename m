Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F5A4C91
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 03:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731382554; cv=none; b=TzATtgR1M3J4n6+iCO2nkyCJhUpTpn8vdtogh6HAaUJzIsvLwU+N9R+D4yvVnkrsUjhKlambuAido41QsG6DDTlWqWLMeNDtmHa7WlKES3D5AGlhsj8YCcUsqXkeXPeYLz6X7Zx78p7lXd24HpvZJZA+e2/48csyzcj4SsC3PGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731382554; c=relaxed/simple;
	bh=rMKVb2jYqK4+2nWP2Qbm3ywRPZNJXPBb6FTHkg8yT/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M+ISdx4IiLQtVXSdDUXfIMWgOg1+xsOYyzHhiqxQ5Yd6sNB30X9wGw2iiDKT2+QdBTQ6xuGU+VikNhA3gnIy0A9y3SxWbJxno07jWIY7IkTRY6+5KxPUZye9e7JQhTZHbjW8/Uiwzntm6ZWMXI/rEMAGbitnY1FTU33LqMCHX60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fax1j6SJ; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fax1j6SJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731382549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8bQ4oXcfUZgRe4pWvThGLlk+ybo3RbZlCSpCy3qXQsU=;
	b=fax1j6SJTNACLXkQBpb3O6g42X0wRkDzI0TOecd89p6RGzitDPK1BnLbevoeBAnVZshQno
	lYq/aiWcoW0Uvtvn1/CDc9ngdVsnQPgYljCKAy2unXxCS3hdM2CNCojoWAMMb2pRVukRW7
	Cf4WXt66xZEP1Z3aoqH8LyvS+8CCSJ0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	brauner@kernel.org,
	sforshee@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz
Subject: [PATCH 0/3] io path options + reflink (mild security implications)
Date: Mon, 11 Nov 2024 22:35:32 -0500
Message-ID: <20241112033539.105989-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

so, I've been fleshing out various things at the intersection of io path
options + rebalance + reflink, and this is the last little bit

background: bcachefs has io path options that can be set filesystem
wide, or per inode, and when changed rebalance automatically picks them
up and does the right thing

reflink adds a wrinkle, which is that we'd like e.g. recursively setting
the foreground/background targets on some files to move them to the
appropriate device (or nr_replicas etc.), like other data - but if a
user did a reflink copy of some other user's data and then set
nr_replicas=1, that would be bad.

so this series adds a flag to reflink pointers for "may propagate option
changes", which can then be set at remap_file_range() time based on
vfs level permission checks.

so, question for everyone: is write access to the source file what we
want? or should it be stricter, i.e. ownership matches?

then, we're currently missing mnt_idmap plumbing to remap_file_range()
to do said permissions checks - do we want to do that? or is there an
easier way?

Kent Overstreet (3):
  bcachefs: BCH_SB_VERSION_INCOMPAT
  bcachefs: bcachefs_metadata_version_reflink_p_may_update_opts
  bcachefs: Option changes now get propagated to reflinked data

 fs/bcachefs/bcachefs.h        |  2 ++
 fs/bcachefs/bcachefs_format.h | 28 +++++++++++--------
 fs/bcachefs/fs-io.c           |  9 ++++++-
 fs/bcachefs/move.c            | 51 ++++++++++++++++++++++++++++++-----
 fs/bcachefs/recovery.c        | 27 ++++++++++++++++---
 fs/bcachefs/reflink.c         | 18 ++++++++++---
 fs/bcachefs/reflink.h         |  3 ++-
 fs/bcachefs/reflink_format.h  |  2 ++
 fs/bcachefs/super-io.c        | 48 ++++++++++++++++++++++++++++++---
 fs/bcachefs/super-io.h        | 18 ++++++++++---
 10 files changed, 172 insertions(+), 34 deletions(-)

-- 
2.45.2

