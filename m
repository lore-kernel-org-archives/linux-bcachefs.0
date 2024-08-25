Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049A53C38
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 01:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724550127; cv=none; b=N2RG490yTzVgT5tZWI4Tc2j3eR4NlnA3rXe5KlFIxd4E89qqURWKQAcQY/879KKoSiFdzS3f7deudEDxfW2Rjackz7lCqwfpjz0ABUCZf3y73jdB3FfEYq8McYqiNyh81gBGJMn0fn4ZNsXPTvQ9gEAi0r4rKCyYKRVBXgFydqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724550127; c=relaxed/simple;
	bh=77j4BwprRx4KBiHy+ApU6E2TlZszxVlK+DAnOD/xtw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxtZ2jaZ8csAtQSx2dUYIvZlrKu3W1MByk0zwUhzvIe3F7wiiLajVvW7hPuXqCkl760l0lOtp1h3TAhh5ciqzhTnA5i7UYqoFsjPRLpubuDfEOQasltnNMGSrC0JIQ8RCL4FAdqpCDQXgnurLlSMFD1dz2P3K5yBs+o5uM/nD1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S1gYnyd6; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S1gYnyd6"
Date: Sat, 24 Aug 2024 21:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724550121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CD9xdaQ6ZOkmkPJJMe9lTkqYaU9rumiYIHfXD25S/0k=;
	b=S1gYnyd6QLDlgG8fE59FEgleTk0GBRGwUKMmcMOskrHNDJ+5IGxtTPeW6CmkFPrFGXhvRo
	YCN/2cHia6cUxTMNwIr7kLjHSDQltlgeTO48qjgAMIWThDri7jdSPFTG6eejOGTAtY26v5
	WFZ3+4dqNtPCC+0blOXyRNVhyau4ZN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
Message-ID: <hmtzlfu6t5shnt557pykpjha3nnkx4sqa3qaqfzx5rh5kcdusp@jr6mtee5pwq7>
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
X-Migadu-Flow: FLOW_OUT

ok, I take it you don't like this one either

On Sat, Aug 24, 2024 at 12:19:59PM GMT, Kent Overstreet wrote:
> The following changes since commit 0e49d3ff12501adaafaf6fdb19699f021d1eda1c:
> 
>   bcachefs: Fix locking in __bch2_trans_mark_dev_sb() (2024-08-16 20:45:15 -0400)
> 
> are available in the Git repository at:
> 
>   git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-24
> 
> for you to fetch changes up to 49aa7830396bce33b00fa7ee734c35de36521138:
> 
>   bcachefs: Fix rebalance_work accounting (2024-08-24 10:16:21 -0400)
> 
> ----------------------------------------------------------------
> bcachefs fixes for 6.11-rc5, v2
> 
> - rhashtable conversion for vfs inodes
> - rcu_pending, btree key cache conversion
> + nocow deadlock fix
> + fix for new rebalance_work accounting
> 
> ----------------------------------------------------------------
> Kent Overstreet (27):
>       bcachefs: Reallocate table when we're increasing size
>       bcachefs: fix field-spanning write warning
>       bcachefs: Fix incorrect gfp flags
>       bcachefs: Extra debug for data move path
>       bcachefs: bch2_data_update_init() cleanup
>       bcachefs: Fix "trying to move an extent, but nr_replicas=0"
>       bcachefs: setting bcachefs_effective.* xattrs is a noop
>       bcachefs: Fix failure to relock in btree_node_get()
>       bcachefs: Fix bch2_trigger_alloc assert
>       bcachefs: Fix bch2_bucket_gens_init()
>       bcachefs: fix time_stats_to_text()
>       bcachefs: fix missing bch2_err_str()
>       bcachefs: unlock_long() before resort in journal replay
>       bcachefs: fix failure to relock in bch2_btree_node_mem_alloc()
>       bcachefs: fix failure to relock in btree_node_fill()
>       bcachefs: Fix locking in bch2_ioc_setlabel()
>       bcachefs: Fix replay_now_at() assert
>       bcachefs: Fix missing validation in bch2_sb_journal_v2_validate()
>       fs/super.c: improve get_tree() error message
>       bcachefs: Fix warning in bch2_fs_journal_stop()
>       bcachefs: Fix compat issue with old alloc_v4 keys
>       bcachefs: Fix refcounting in discard path
>       bcachefs: clear path->should_be_locked in bch2_btree_key_cache_drop()
>       bcachefs: add missing inode_walker_exit()
>       bcachefs: don't use rht_bucket() in btree_key_cache_scan()
>       bcachefs: Fix failure to flush moves before sleeping in copygc
>       bcachefs: Fix rebalance_work accounting
> 
> Yuesong Li (1):
>       bcachefs: Fix double assignment in check_dirent_to_subvol()
> 
>  fs/bcachefs/alloc_background.c            |  66 +++++-----
>  fs/bcachefs/alloc_background_format.h     |   1 +
>  fs/bcachefs/bcachefs_format.h             |   3 +-
>  fs/bcachefs/btree_cache.c                 |  25 ++++
>  fs/bcachefs/btree_cache.h                 |   2 +
>  fs/bcachefs/btree_iter.h                  |   9 ++
>  fs/bcachefs/btree_key_cache.c             |  31 ++++-
>  fs/bcachefs/btree_update_interior.c       |  46 ++++---
>  fs/bcachefs/buckets.c                     |  74 +++++++----
>  fs/bcachefs/buckets_waiting_for_journal.c |   4 +-
>  fs/bcachefs/data_update.c                 | 209 ++++++++++++++++--------------
>  fs/bcachefs/extents.c                     |  41 ++++++
>  fs/bcachefs/extents.h                     |   1 +
>  fs/bcachefs/fs-io-buffered.c              |   2 +-
>  fs/bcachefs/fs-ioctl.c                    |   3 +-
>  fs/bcachefs/fsck.c                        |   6 +-
>  fs/bcachefs/journal.c                     |   2 +-
>  fs/bcachefs/journal_sb.c                  |  15 +++
>  fs/bcachefs/movinggc.c                    |   2 +-
>  fs/bcachefs/recovery.c                    |   9 +-
>  fs/bcachefs/replicas.c                    |   3 +-
>  fs/bcachefs/sb-downgrade.c                |   8 +-
>  fs/bcachefs/util.c                        |   1 -
>  fs/bcachefs/xattr.c                       |  12 +-
>  fs/super.c                                |   4 +-
>  25 files changed, 387 insertions(+), 192 deletions(-)
