Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF8224D1
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 Aug 2024 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131186; cv=none; b=Zx3QKBOSmP+VweYUyn7nnyE22DIJ5K/AmYZM4oNSp8CYBHQpI7UdC/fpUENHU2unTcAVfe5wEczy50ptxaVJYEmA0cpzkwZMzE+7gQnwRsTFyJ9XOVh3GdI5bTPtHnY8NtgdvAxWBlux4ObaMiIHhMB3KkTvZS6XVN7Q3aayW08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131186; c=relaxed/simple;
	bh=KHg2dgQ3z4l3jlTadypXtknojw0gY6/D9vnUC/+ymoU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BaWg4y0ehuJ09fj55+LZ88PdPH4Dks51u7VQ0Il7pCcY2sc5Eizkes8Eb7EYsRbsE+VGV6G3ms8W6cwJRiQfXVwJGDIKdKTUnDtAQHC9rYIIBU62MoNnhuU006udBc3g4zwPH0lbbOQ1h7gh/fT/cuEjJdWqfj/D+m5cvIO1k/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=reNSuzD2; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="reNSuzD2"
Date: Thu, 8 Aug 2024 11:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QoOV+LDhOiZeXkQuut+ECTaJ3C1I3khBkfy80ox2qUc=;
	b=reNSuzD2lX5QuE1FYBKqzVSb/aYzCRkIaYVcdXWvXnTccNPOCWaq0/gyJ/+KegW8axX5no
	GAEzb4CU975IdS6nU1Our6GU1Xg6NuX5fcLTOdK60gl77/cTiBDQb8Qx2WxcVbk1XOuheD
	CAj33OXeYctobZf+TrnMazHOMPTS8ps=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.11-rc3
Message-ID: <6dvutmoo566vc3vr5ezzz6rjhqjjsqhwnrfu2v5tkoieh23mwp@qo2cc2bpin3n>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, couple little ones for you...

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-08

for you to fetch changes up to 73dc1656f41a42849e43b945fe44d4e3d55eb6c3:

  bcachefs: Use bch2_wait_on_allocator() in btree node alloc path (2024-08-07 21:04:55 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.11-rc3

Assorted little stuff:
- lockdep fixup for lockdep_set_notrack_class()
- we can now remove a device when using erasure coding without
  deadlocking, though we still hit other issues
- the "allocator stuck" timeout is now configurable, and messages are
  ratelimited; default timeout has been increased from 10 seconds to 30

----------------------------------------------------------------
Kent Overstreet (10):
      bcachefs: Fix double free of ca->buckets_nouse
      lockdep: Fix lockdep_set_notrack_class() for CONFIG_LOCK_STAT
      bcachefs: Don't rely on implicit unsigned -> signed integer conversion
      bcachefs: Add a comment for bucket helper types
      bcachefs: Add missing bch2_trans_begin() call
      bcachefs: Improved allocator debugging for ec
      bcachefs: ec should not allocate from ro devs
      bcachefs: Add missing path_traverse() to btree_iter_next_node()
      bcachefs: Make allocator stuck timeout configurable, ratelimit messages
      bcachefs: Use bch2_wait_on_allocator() in btree node alloc path

 fs/bcachefs/alloc_background.h      | 12 ++++++++++--
 fs/bcachefs/alloc_foreground.c      | 32 ++++++++++++++++++++++++++++----
 fs/bcachefs/alloc_foreground.h      |  9 +++++++--
 fs/bcachefs/bcachefs.h              |  2 ++
 fs/bcachefs/bcachefs_format.h       |  2 ++
 fs/bcachefs/btree_iter.c            |  5 +++++
 fs/bcachefs/btree_update_interior.c |  2 +-
 fs/bcachefs/ec.c                    | 34 +++++++++++++++++++++++-----------
 fs/bcachefs/io_misc.c               |  6 +-----
 fs/bcachefs/io_read.c               |  1 +
 fs/bcachefs/io_write.c              |  5 +----
 fs/bcachefs/opts.h                  |  5 +++++
 fs/bcachefs/super-io.c              |  4 ++++
 fs/bcachefs/super.c                 |  1 -
 fs/bcachefs/sysfs.c                 |  6 +++++-
 kernel/locking/lockdep.c            |  6 ++++++
 16 files changed, 101 insertions(+), 31 deletions(-)
