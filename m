Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C8916FF2A
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797120; cv=none; b=UIkh/lhKLAom26hcyqLeOJt/SOoaSrqWj2I78YEMDXDl5+ng35ccqXmGFa6ThPMOoiYg7ozUm88YKsFoVYoKHMKALdnyIKu+7tEkPQLvJLasiFaBy8ng7KHiW7i3YqldWjGWs4rKeyEkp8AAmSIIN5BVCvHwnja6mm8yOzHIvs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797120; c=relaxed/simple;
	bh=mo7/yO1Yndpem+PcqhS/LIJ1mmm3bFvn7FLulf7/mso=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ng86nKYLWzADqcgXVkanNCKNF3llZQaUq5/OAcRr/EEEFZGiv8cRdrfkop6vgJxtxh00Xu1FPyG29661UQAqXv+/L4J/YUvmWjShziLOP4uiYs2p5TlJWfpUdUZgq7q8puf5EMMwIph3JpdaKpFy6HhnQKrOxqXH18K7PYPCGcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i88HNH26; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i88HNH26"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720797116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aCl5Cagow0kZ0VwbMg3350PV0wzz5LFLN7z3dyjPT+I=;
	b=i88HNH26UaoPmU1uNWay5wlpfvGgOHy9UVzJFtbqDf7FPD1DxU/RmqbGn5MIbxPPIO+dya
	w6aXjD3T3rs7k8q/sY2Zs8adR++bSLhmUSDs11JpQJh0376lYyNi46P9u2drCMwFGEaqwj
	4imvvyMv2zzn0R8iEUAp/b9YsHIkm94=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2024 11:11:54 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.10-rc8, more
Message-ID: <ibddimatjnhtx5efnlbg7oyr6dkfjpes5nvwflfdtxilxiwy3f@o6z5qql3kjn5>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, just a few stragglers left.

The revert should've had a
Reported-By: Gabriel de Perthuis <g2p.code@gmail.com>

noting it here since I just tagged the pull, but he did the work of
bisecting it for us :)

Cheers,
Kent

The following changes since commit 7d7f71cd8763a296d02dff9514447aa3de199c47:

  bcachefs: Add missing bch2_trans_begin() (2024-07-10 09:53:39 -0400)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-07-12

for you to fetch changes up to 1841027c7de47527ed819a935b7aa340b9171eb5:

  bcachefs: bch2_gc_btree() should not use btree_root_lock (2024-07-11 20:10:55 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.10-rc8, more

- revert the SLAB_ACCOUNT patch, something crazy is going on in memcg
  and someone forgot to test
- minor fixes: missing rcu_read_lock(), scheduling while atomic (in an
  emergency shutdown path)
- two lockdep fixes; these could have gone earlier, but were left to
  bake awhile

----------------------------------------------------------------
Kent Overstreet (6):
      bcachefs: Fix RCU splat
      bcachefs: fix scheduling while atomic in break_cycle()
      Revert "bcachefs: Mark bch_inode_info as SLAB_ACCOUNT"
      bcachefs; Use trans_unlock_long() when waiting on allocator
      bcachefs: Set PF_MEMALLOC_NOFS when trans->locked
      bcachefs: bch2_gc_btree() should not use btree_root_lock

 fs/bcachefs/btree_gc.c      | 30 ++++++++++++++++++++++--------
 fs/bcachefs/btree_iter.c    |  7 ++++---
 fs/bcachefs/btree_locking.c | 10 ++++------
 fs/bcachefs/btree_locking.h | 22 ++++++++++++++++++++++
 fs/bcachefs/btree_types.h   |  1 +
 fs/bcachefs/buckets.c       |  2 +-
 fs/bcachefs/buckets.h       |  8 ++++++++
 fs/bcachefs/fs.c            |  3 +--
 fs/bcachefs/io_misc.c       |  2 +-
 fs/bcachefs/util.c          | 25 ++++++++++++++++++++++---
 fs/bcachefs/util.h          |  1 +
 11 files changed, 87 insertions(+), 24 deletions(-)
