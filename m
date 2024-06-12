Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F5684DFE
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jun 2024 20:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718223691; cv=none; b=iDz33bxnIhe654HviCyCEdbFZxfRP33jGRK2MK8dxtX6ijHOyitweLuNLUrSOPSLdqsvCz/tPIhjo4kbW36/kBb2ukhlVg8tx12B1HuFALEkKaUJUIpGuVRxOmdig0Hc14y6sihcYyYgKkCDRVC4nmxYieKaJtJdC3ayPHyDaXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718223691; c=relaxed/simple;
	bh=Y9JmGBo0c7lW83Az7dSmFQ4xeG9SUat2NMd0Gd2IswQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g4ifbAXW1YWDhW46xbf/ucNcsm4ElBm1fZcRHw5F03fnau0Dke7hQvumMCnegYceqCT9ERXmdxVfZgTTypBMg5oEjY28A5nVy3U1CGEfahrL7zh1XoFjA1c8SjavSQQjpx3hBXExBK/xogehfwMI85OeudRpZL3QMkVe7H8sZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rhQtJxAF; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rhQtJxAF"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718223686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wXcD6/YF85x4CLdgIr2RqnTdVu0TMTvQKa4O5vPHG4s=;
	b=rhQtJxAFenwuQ6pEBVukxUvt/crmCY9eWVUQQ4XVUfSiXrTWEhHfTLFc8LOCTeal2Kh7Oz
	VRLzUwdd/c+W/PfeiTMe96GK8x+2RxxD3/QWdZ32T19Nv+JDQ+kT8FfSiGp+GHe9XYY8s4
	AFHTuMbe1k3X9NfwB5guXi3evHqAG+g=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2024 16:21:22 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.10-rc4
Message-ID: <6pkst4l27qb7asdlg47jy6zycvvse45ienwiybqgjtc47fs4so@f6ahc5rwgv46>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, another batch of fixes for you. Nothing terribly exciting, the
usual mix of syzbot + user bug fixes.

The following changes since commit 83a7eefedc9b56fe7bfeff13b6c7356688ffa670:

  Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-06-12

for you to fetch changes up to f2736b9c791a126ecb9cfc1aef1c7b4152b66e2d:

  bcachefs: Fix rcu_read_lock() leak in drop_extra_replicas (2024-06-11 18:59:08 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.10-rc4

- fix kworker explosion, due to calling submit_bio() (which can block)
  from a multithreaded workqueue
- fix error handling in btree node scan
- forward compat fix: kill an old debug assert
- key cache shrinker fixes
  this is a partial fix for stalls doing multithreaded creates - there
  were various O(n^2) issues the key cache shrinker was hitting

  https://lore.kernel.org/linux-bcachefs/fmfpgkt3dlzxhotrfmqg3j3wn5bpqiqvlc44xllncvdkimmx3i@n4okabtvhu7t/

  there's more work coming here; I'm working on a patch to delete the
  key cache lock, which initial testing shows to be a pretty drastic
  performance improvement
- assorted syzbot fixes

----------------------------------------------------------------
Hongbo Li (1):
      bcachefs: fix the display format for show-super

Kent Overstreet (16):
      bcachefs: Split out btree_write_submit_wq
      bcachefs: Fix incorrect error handling found_btree_node_is_readable()
      bcachefs: Delete incorrect BTREE_ID_NR assertion
      bcachefs: fix stack frame size in fsck.c
      bcachefs: Enable automatic shrinking for rhashtables
      bcachefs: increase key cache shrinker batch size
      bcachefs: set sb->s_shrinker->seeks = 0
      bcachefs: Fix reporting of freed objects from key cache shrinker
      bcachefs: Leave a buffer in the btree key cache to avoid lock thrashing
      bcachefs: Fix refcount leak in check_fix_ptrs()
      bcachefs: Fix snapshot_create_lock lock ordering
      bcachefs: Replace bucket_valid() asserts in bucket lookup with proper checks
      bcachefs: Check for invalid bucket from bucket_gen(), gc_bucket()
      bcachefs: Add missing synchronize_srcu_expedited() call when shutting down
      bcachefs: Add missing bch_inode_info.ei_flags init
      bcachefs: Fix rcu_read_lock() leak in drop_extra_replicas

 fs/bcachefs/alloc_background.c |  22 +++-
 fs/bcachefs/bcachefs.h         |   3 +-
 fs/bcachefs/btree_cache.c      |   9 +-
 fs/bcachefs/btree_gc.c         |  17 ++-
 fs/bcachefs/btree_io.c         |   8 +-
 fs/bcachefs/btree_iter.c       |  11 +-
 fs/bcachefs/btree_key_cache.c  |  33 +++--
 fs/bcachefs/btree_node_scan.c  |   9 +-
 fs/bcachefs/buckets.c          | 293 +++++++++++++++++++++++------------------
 fs/bcachefs/buckets.h          |  17 ++-
 fs/bcachefs/buckets_types.h    |   2 +
 fs/bcachefs/data_update.c      |   3 +-
 fs/bcachefs/ec.c               |  26 +++-
 fs/bcachefs/extents.c          |   9 +-
 fs/bcachefs/fs-ioctl.c         |  17 +--
 fs/bcachefs/fs.c               |   3 +
 fs/bcachefs/fsck.c             |   3 +
 fs/bcachefs/io_read.c          |  37 ++++--
 fs/bcachefs/io_write.c         |  19 ++-
 fs/bcachefs/movinggc.c         |   7 +-
 fs/bcachefs/super-io.c         |   6 +-
 fs/bcachefs/super.c            |  10 +-
 22 files changed, 344 insertions(+), 220 deletions(-)
