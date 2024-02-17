Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEF42EB05
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Feb 2024 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708191834; cv=none; b=rup+43a5xMI5IeWm//XN8m/PgvjaLLwjLt92c+Y6u0MyPQW2lts6qKNCBLzhzxgRefNbc1E+tu7XiGFAVkrxWDf/rotgJ8tJfa8qMJQfkSafVF8/q/+/TyOr2czZgUX0ROaRHZWWBn/VsuPIjn6pjzjfP05tLl/Z+zgehI53leE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708191834; c=relaxed/simple;
	bh=TTC2XLTY+KJBE41UvgEdqzp3L4GwI7Y/gSXu0ygo8TY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pPwbv8pBgo9Mj4KZXZncd433ycKZpx7gKat34iNBSfuNjjgFtBthTjxUjnOY7pYjdTLpdAx9XF5/NU04ozv0PeLjX4f4h134xYogYZgwLLonNu733a123dVsDbLfZ+J+lczCKTH4Lucpi9zBjRjigbNHQiFDBktmugf0gr2aoSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t3eF45T+; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t3eF45T+"
Date: Sat, 17 Feb 2024 12:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708191829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=f8KgCulAAS8xo5J2WnyX6Xnxgkm2HzRe2M6ZFfBWbvc=;
	b=t3eF45T+R+SQ615OoDXF/MKkegnng7wciiEyRFqMKPL9SMGHIc6oANc2kfyFypsD9/frRd
	Ks6dBMKws4f87hVfNLRJRKEZL70bh+xNyR7gALCVA+OLdktBFSZhyZLXafaB4mtQdSMsx2
	4iTd6yND6qsMdlh/PCi5zqTh7YPs7Bc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.8-rc5
Message-ID: <p732lizcbavjuvut7qfz6k7i5iozoha4dkn4t6vublkdnmhdff@5mdx7mwqwy7t>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, few more fixes for you...

Cheers,
Kent

The following changes since commit 7b508b323b2ec45be59769bd4e4aeba729c52cf6:

  bcachefs: time_stats: Check for last_event == 0 when updating freq stats (2024-02-05 01:16:31 -0500)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-02-17

for you to fetch changes up to 816054f40a5fdaaed05d9e7f603d2824eeee7e62:

  bcachefs: Fix missing va_end() (2024-02-13 21:59:27 -0500)

----------------------------------------------------------------
bcachefs fixes for v6.8-rc5

Mostly pretty trivial, the user visible ones are:
 - don't barf when replicas_required > replicas
 - fix check_version_upgrade() so it doesn't do something nonsensical
   when we're downgrading

----------------------------------------------------------------
Kent Overstreet (5):
      bcachefs: Fix missing bch2_err_class() calls
      bcachefs: fix missing endiannes conversion in sb_members
      bcachefs: Clamp replicas_required to replicas
      bcachefs: Fix check_version_upgrade()
      bcachefs: Fix missing va_end()

Su Yue (1):
      bcachefs: fix kmemleak in __bch2_read_super error handling path

 fs/bcachefs/bcachefs.h              | 12 ++++++++++++
 fs/bcachefs/btree_update_interior.c |  3 ++-
 fs/bcachefs/fs.c                    |  9 +++++----
 fs/bcachefs/io_write.c              |  1 +
 fs/bcachefs/journal_io.c            |  4 +++-
 fs/bcachefs/journal_reclaim.c       |  2 +-
 fs/bcachefs/printbuf.c              |  1 +
 fs/bcachefs/recovery.c              | 11 ++++++-----
 fs/bcachefs/sb-members.c            |  2 +-
 fs/bcachefs/super-io.c              |  2 +-
 fs/bcachefs/super.c                 |  4 ++--
 11 files changed, 35 insertions(+), 16 deletions(-)
