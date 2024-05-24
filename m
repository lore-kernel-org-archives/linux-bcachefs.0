Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C431272A2
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716557030; cv=none; b=Jyx2wjuE/hf6PapdQgCb864ERg6qqcJP7vw4THEVwlbeuGGLEHEpEYL2WXFBln4afSNrw2zjPzYRzdi68JdGQ1B9SDJVEf5VPUP7KqAt3e20iDXwfJrRizS+TmBIfv9Ye+F5bbRSKcOXMJk2IxU54nR8aV35AGG/vgmMtQl+QBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716557030; c=relaxed/simple;
	bh=9M+Jfutkj+3xFQXRZrdiDpsrzCMNEVrBpKHHCVV94K0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UKEAEH5rq9GdItlpWxwt8YrcpzyP3VAU72njKShGU8nkU1hh/vBbe4OkgwmKene5m2Fr5rqLvlFHmFabCIsTa7OwA/liMuxWdi94leSFKMw6874L0bUJW9RmC3vLTqucXH9j/fum8xvTVIkwK6JA0p4QHc1RQP2gTqKLkpOPMh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aL5TcvMd; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aL5TcvMd"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716557024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=yawCa/zMhfVB+WtgnLQ25RsWeDGEuNkEkDSE1kcE66E=;
	b=aL5TcvMd3lk5CCclv+OGux6AYuDyhaKI02HIqsrrBlyd/bdEwwPLhrCAA4Aab0bq8KUcPD
	FZSjyQqBDEKX3WvJ2HDTOdEulj9D3eBd/IDUoaf6nfM6rOSeiLmNRVxPNUzwRsggVIwFV5
	MoWfoglS2UxtpTrEdfyjAgXzQvQhK5Q=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Fri, 24 May 2024 09:23:41 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.10-rc1
Message-ID: <34o5tkmaecep7kccwzgwe4yzbkayhb5wkqukthj5may75yvqgn@43rljzrmlmmn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Nothing exciting, just syzbot fixes (except for the one
FMODE_CAN_ODIRECT patch).

Looks like syzbot reports have slowed down; this is all catch up from
two weeks of conferences.

Next hardening project is using Thomas's error injection tooling to
torture test repair.

The following changes since commit eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c:

  Merge tag 'mm-nonmm-stable-2024-05-19-11-56' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2024-05-19 14:02:03 -0700)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-05-24

for you to fetch changes up to d93ff5fa40b9db5f505d508336bc171f54db862e:

  bcachefs: Fix race path in bch2_inode_insert() (2024-05-22 20:37:47 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.10-rc1

Just a few syzbot fixes

----------------------------------------------------------------
Kent Overstreet (17):
      bcachefs: Fix rcu splat in check_fix_ptrs()
      bcachefs: Fix ref in trans_mark_dev_sbs() error path
      bcachefs: Fix shift overflow in btree_lost_data()
      bcachefs: Fix shift overflows in replicas.c
      bcachefs: Improve bch2_assert_pos_locked()
      bcachefs: Fix missing parens in drop_locks_do()
      bcachefs: Add missing guard in bch2_snapshot_has_children()
      bcachefs: Fix bch2_alloc_ciphers()
      bcachefs: bch2_checksum() returns 0 for unknown checksum type
      bcachefs: Check for subvolues with bogus snapshot/inode fields
      bcachefs: Fix bogus verify_replicas_entry() assert
      bcachefs: Fix btree_trans leak in bch2_readahead()
      bcachefs: Fix stack oob in __bch2_encrypt_bio()
      bcachefs: Fix unsafety in bch2_dirent_name_bytes()
      bcachefs: Fix shutdown ordering
      bcachefs: Ensure we're RW before journalling
      bcachefs: Fix race path in bch2_inode_insert()

Youling Tang (1):
      bcachefs: set FMODE_CAN_ODIRECT instead of a dummy direct_IO method

 fs/bcachefs/bcachefs_format.h |  6 ++++++
 fs/bcachefs/btree_iter.c      |  2 ++
 fs/bcachefs/btree_iter.h      |  2 +-
 fs/bcachefs/buckets.c         | 13 +++++++------
 fs/bcachefs/checksum.c        | 37 ++++++++++++++++++++----------------
 fs/bcachefs/dirent.c          |  3 +++
 fs/bcachefs/fs-io-buffered.c  |  4 ++--
 fs/bcachefs/fs.c              |  6 +++---
 fs/bcachefs/printbuf.c        |  7 +++++++
 fs/bcachefs/recovery.c        |  7 ++++++-
 fs/bcachefs/replicas.c        | 44 ++++++++++++++++++++++---------------------
 fs/bcachefs/sb-errors_types.h |  4 +++-
 fs/bcachefs/snapshot.h        |  7 ++-----
 fs/bcachefs/subvolume.c       |  9 +++++++++
 fs/bcachefs/super.c           |  2 +-
 15 files changed, 96 insertions(+), 57 deletions(-)
