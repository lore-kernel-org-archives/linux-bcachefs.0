Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CDA1BF317
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Sep 2024 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889954; cv=none; b=cvDcxY1H6iv4B9kPLdNQzlwYwBvL0Pn8aDf6snmkNxKAU9htnUllK9FRuDlziPtmOnfIRTBm8HBAvd32xUAjbyStA/gThzs9ka+EgP8ghG6ZGfQwunXFqo+N1VOMgSnteFYw5baAZ/caf/eRrcjnMMFtXZ7HaWC/wZu148Qu6C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889954; c=relaxed/simple;
	bh=jjQFYMgyUAKr7GPyMSddKKP70RLlpHOV9E1bqzIQKqk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sn/+zWn2uSgOR14s55D0qAj6nJdDQCnETEVNWCyINfe8H40/MEXoAaKLy68r/utcpClDkHo7uWtmlPVpn4iIzgD49ekt+TlhY3wXNIF0jbCrrpM5BM5p3ZaF3/a2kNVc0oRNATyJY0zEguwAtB8eALlwpJIwcL3gFHNPFIJPQK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UZXv1nfz; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UZXv1nfz"
Date: Mon, 9 Sep 2024 09:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725889949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aeqj0nbUuy/cfdqtEFeg/xP2DE4BRqCeRoWhaRbnTtc=;
	b=UZXv1nfzfvWUuvyoZJjtc/cYXdFGpfvHv5tGnkOBK1agYn2CshH2JKTclzG5qZA/zkZ1ta
	wCQHcR7Cume1M3wtd7iYXVTBTO8XXwGBwpVzvXockJZQNOrMnX3ywhqecPy6uqITJ8+H2P
	S7NhmOCUClNrqmnuci0tIkwXIl8jmHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.11-rc8/final
Message-ID: <uyzlav7jahhammvvx2eymn4thh5vvpo3ngu7tdmkmyygdwim6c@3b7dyx3tbqyo>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

this closes out the main critical bug users have been hitting

now to dig through the bug tracker some more...

The following changes since commit 53f6619554fb1edf8d7599b560d44dbea085c730:

  bcachefs: BCH_SB_MEMBER_INVALID (2024-09-03 20:43:14 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-09-09

for you to fetch changes up to 16005147cca41a0f67b5def2a4656286f8c0db4a:

  bcachefs: Don't delete open files in online fsck (2024-09-09 09:41:47 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.11-rc8

- fix ca->io_ref usage; analagous to previous patch doing that for main
  discard path
- cond_resched() in __journal_keys_sort(), cutting down on "hung task"
  warnings when journal is big
- rest of basic BCH_SB_MEMBER_INVALID support
- and the critical one: don't delete open files in online fsck, this was
  causing the "dirent points to inode that doesn't point back"
  inconsistencies some users were seeing

----------------------------------------------------------------
Kent Overstreet (6):
      bcachefs: Fix ca->io_ref usage
      bcachefs: Add a cond_resched() to __journal_keys_sort()
      bcachefs: Simplify bch2_bkey_drop_ptrs()
      bcachefs: More BCH_SB_MEMBER_INVALID support
      bcachefs: fix btree_key_cache sysfs knob
      bcachefs: Don't delete open files in online fsck

 fs/bcachefs/alloc_background.c   | 24 ++++++++++++------------
 fs/bcachefs/btree_journal_iter.c |  2 ++
 fs/bcachefs/buckets.c            | 15 ++++++++-------
 fs/bcachefs/ec.h                 |  4 +++-
 fs/bcachefs/extents.c            | 26 ++++++++++----------------
 fs/bcachefs/extents.h            | 23 +++++++++--------------
 fs/bcachefs/fs.c                 |  8 ++++++++
 fs/bcachefs/fs.h                 |  7 +++++++
 fs/bcachefs/fsck.c               | 18 ++++++++++++++++++
 fs/bcachefs/replicas.c           |  2 +-
 fs/bcachefs/sysfs.c              |  2 +-
 11 files changed, 79 insertions(+), 52 deletions(-)
