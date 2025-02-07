Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B08A17C208
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Feb 2025 03:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738899720; cv=none; b=Zg4duuZRDSHDYW4uEncrIy3IFAj9KpjCcCQaN1eOu1ETg8fTtGmv2Hn3GVs6pBb+M67MSlb6axoxbO3QXysqld4kM2KCtUYK3PxiMUJgFqOzn2n5T6qVGkm97oJLULrYz1cHgaOlLZdBIdll5xa2thELu2dtpBsMn0IuHThHT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738899720; c=relaxed/simple;
	bh=7oN/H/a2w+7dGQMpc4UFYN5V0qv/VyRZqGxOjPwk8pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hyi/cM9aoYpOBBWNYFGOJZaLDjmy1dF4IHGs3yr78sPkHeyqLO/zy+iQarxqXyXWqYqqPS0ciana4ZdNxMudIFeuneCBQ51R8PhXoMop+7B3tq92dyaFSw8A5ecNVM2YDbICAc3rEkx7l0IKQ/7ANWZ8wWd3ohjx84Lm/MGvn2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WzQjTxyR; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WzQjTxyR"
Date: Thu, 6 Feb 2025 22:41:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738899715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=StZ+UKenkov6NFhhanj24b643rsTU6dS/c2q5q/L9UI=;
	b=WzQjTxyRigLrNFr1UYxcK1XqgwkZ+mSHezCZAfuy53gaBwpz6HlP2bBAWF2rzD2ShnjaKd
	5UJ1/7RS4/yPi/xT1t6QIjuy3fqzcgeC6Ajo21rL5ThfxCJVr3lF7ipIn6s/GonW3RLghI
	3A/HTaKlhxbvAh9eYdCmuie+rclAJgI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Akira Yokosawa <akiyks@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.14-rc2
Message-ID: <usxj7gse2c53ow2a3fxpoi3ygsvu6shpo3huvecih577iaq3a7@os7sfywxj2vw>
References: <z2eszznjel6knkkvckjxvkp5feo5jhnwvls3rtk7mbt47znvcr@kvo6dhimlghe>
 <6491ceb6-e48b-442b-ac61-7b2b65252d7a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6491ceb6-e48b-442b-ac61-7b2b65252d7a@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 07, 2025 at 12:05:05PM +0900, Akira Yokosawa wrote:
> This caused a new warning in "make htmldocs", which was reported at:

Yep, I missed that, here's an updated pull:

The following changes since commit 2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-02-06.2

for you to fetch changes up to 4be214c26936813b636eed2fac906f585ddbf0f9:

  bcachefs: bch2_bkey_sectors_need_rebalance() now only depends on bch_extent_rebalance (2025-02-06 22:35:11 -0500)

----------------------------------------------------------------
bcachefs fixes for 6.14-rc2

- add a SubmittingPatches to clarify that patches submitted for bcachefs
  do, in fact, need to be tested
- discard path now correctly issues journal flushes when needed, this
  fixes performance issues when the filesystem is nearly full and we're
  bottlenecked on copygc
- fix a bug that could cause the pending rebalance work accounting to be
  off when devices are being onlined/offlined; users should report if
  they are still seeing this
- and a few more trivial ones

----------------------------------------------------------------
Jeongjun Park (2):
      bcachefs: fix incorrect pointer check in __bch2_subvolume_delete()
      bcachefs: fix deadlock in journal_entry_open()

Kent Overstreet (4):
      bcachefs docs: SubmittingPatches.rst
      bcachefs: Fix discard path journal flushing
      bcachefs: Fix rcu imbalance in bch2_fs_btree_key_cache_exit()
      bcachefs: bch2_bkey_sectors_need_rebalance() now only depends on bch_extent_rebalance

 .../filesystems/bcachefs/SubmittingPatches.rst     | 98 ++++++++++++++++++++++
 Documentation/filesystems/bcachefs/index.rst       |  1 +
 MAINTAINERS                                        |  1 +
 fs/bcachefs/alloc_background.c                     | 47 ++++++-----
 fs/bcachefs/alloc_foreground.c                     | 10 ++-
 fs/bcachefs/alloc_types.h                          |  1 +
 fs/bcachefs/btree_key_cache.c                      |  1 -
 fs/bcachefs/buckets_waiting_for_journal.c          | 12 ++-
 fs/bcachefs/buckets_waiting_for_journal.h          |  4 +-
 fs/bcachefs/inode.h                                |  4 +-
 fs/bcachefs/journal.c                              | 18 +++-
 fs/bcachefs/journal.h                              |  1 +
 fs/bcachefs/journal_types.h                        |  1 +
 fs/bcachefs/opts.h                                 | 14 ----
 fs/bcachefs/rebalance.c                            |  8 +-
 fs/bcachefs/rebalance.h                            | 20 +++++
 fs/bcachefs/subvolume.c                            |  7 +-
 fs/bcachefs/super.c                                | 11 +++
 fs/bcachefs/super.h                                |  1 +
 fs/bcachefs/trace.h                                | 14 +++-
 20 files changed, 215 insertions(+), 59 deletions(-)
 create mode 100644 Documentation/filesystems/bcachefs/SubmittingPatches.rst
