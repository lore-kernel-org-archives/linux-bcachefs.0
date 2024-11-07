Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192EA216447
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731009409; cv=none; b=bncr7amHJw+SSQszZUNTC/GCKJl9mFm31ycLJmwTS4jTIa6VEAH4rkay5fS4TeYFy6kWKqTn++Ac4lm4jM4bj0HXqUIHvFKFZAxO+mye8/0+UGBKAjy6lkvynypnIRuvJjShxcXADHTpk6/BijT+49tiTDCPTrtAy7jXpkrTqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731009409; c=relaxed/simple;
	bh=r6PdXGXEQbVXh8CGJ5cLtZPWBezM/vaAm+aU0RN6Z5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5+xSf+yFwTbBzp/nexjQZUnI4h18hJ3c//IFOkjdtomcjfXhzrhT1moeIEzR7rDk+21wbwGS9uHZonA5OgjPg+5O4fK3L3c7vtuGm4sgEwXEocKrMVJ7MveNJ8UXeJhLCPDvza9tWHZKTxZ8LswjUryzFh6V7ZUIsgOiAPPau4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xTR30p1K; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xTR30p1K"
Date: Thu, 7 Nov 2024 14:56:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731009404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BeHvXim39+/UK0QQMVO3nhiEpp4Zp/ksXTyah/TGN5U=;
	b=xTR30p1K3YcYTkqrw6HSHYmo+ST7Po5qhrlM+J5vcqYtx2QAT2dkZ06Ncr6EHyUQI5x21T
	mc3/5U6e7992efktM7FUhKeN9ubXbvp59gvRmHL22+NWgA7vDXxMAY3cHebYjceBCJ8rC5
	go3TLN44OzIgEKzofglLtcL4LJPTeSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: add unit for counters to support different
 case
Message-ID: <kmyeeyl2gnmbbbokbdoefhai4juzaylwu3hdmeponifahpyz5n@nryukmq2pkxt>
References: <20241107123145.1003801-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107123145.1003801-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 08:31:45PM +0800, Hongbo Li wrote:
> In bcachefs, io_read and io_write counter record the amount
> of data which has been read and written. They increase in
> unit of sector, so to display correctly, they need to be
> shifted to the left by the size of a sector. Other counters
> like io_move, move_extent_{read, write, finish} also have
> this problem.
> 
> In order to support different unit, we add extra column to
> record the unit of this counter in BCH_PERSISTENT_COUNTERS().
> 
> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
> When I read one 15.7M file, the io_read sysfs interface shows:
> - Before this patch
>   - original:
>     since mount:                   0 B
>     since filesystem creation:     5.11 KiB
> 
>   - after read:
>     since mount:                   31.4 KiB
>     since filesystem creation:     36.5 KiB
> 
> - After this patch:
>   - original:
>     since mount:                   0 B
>     since filesystem creation:     18.3 MiB
> 
>   - after read:
>     since mount:                   15.7 MiB
>     since filesystem creation:     34.0 MiB
> 
> v2:
>   - Add extra column to represent the unit for counters.
> 
> v1: https://lore.kernel.org/r/all/eef1d336-65e2-4650-92ac-8f6329f89a57@huawei.com/T/

Ok, this is closer, but instead of a raw shift I was thinking an enum
that describes the actual type: some of these are event counters, and
others are bytes. We shouldn't be printing the B suffix for event
counters, and a type enum would let us fix that too

> ---
>  fs/bcachefs/sb-counters_format.h | 160 +++++++++++++++----------------
>  fs/bcachefs/sysfs.c              |   4 +-
>  2 files changed, 83 insertions(+), 81 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-counters_format.h b/fs/bcachefs/sb-counters_format.h
> index 62ea478215d0..da1f462b9f9c 100644
> --- a/fs/bcachefs/sb-counters_format.h
> +++ b/fs/bcachefs/sb-counters_format.h
> @@ -2,86 +2,86 @@
>  #ifndef _BCACHEFS_SB_COUNTERS_FORMAT_H
>  #define _BCACHEFS_SB_COUNTERS_FORMAT_H
>  
> -#define BCH_PERSISTENT_COUNTERS()				\
> -	x(io_read,					0)	\
> -	x(io_write,					1)	\
> -	x(io_move,					2)	\
> -	x(bucket_invalidate,				3)	\
> -	x(bucket_discard,				4)	\
> -	x(bucket_alloc,					5)	\
> -	x(bucket_alloc_fail,				6)	\
> -	x(btree_cache_scan,				7)	\
> -	x(btree_cache_reap,				8)	\
> -	x(btree_cache_cannibalize,			9)	\
> -	x(btree_cache_cannibalize_lock,			10)	\
> -	x(btree_cache_cannibalize_lock_fail,		11)	\
> -	x(btree_cache_cannibalize_unlock,		12)	\
> -	x(btree_node_write,				13)	\
> -	x(btree_node_read,				14)	\
> -	x(btree_node_compact,				15)	\
> -	x(btree_node_merge,				16)	\
> -	x(btree_node_split,				17)	\
> -	x(btree_node_rewrite,				18)	\
> -	x(btree_node_alloc,				19)	\
> -	x(btree_node_free,				20)	\
> -	x(btree_node_set_root,				21)	\
> -	x(btree_path_relock_fail,			22)	\
> -	x(btree_path_upgrade_fail,			23)	\
> -	x(btree_reserve_get_fail,			24)	\
> -	x(journal_entry_full,				25)	\
> -	x(journal_full,					26)	\
> -	x(journal_reclaim_finish,			27)	\
> -	x(journal_reclaim_start,			28)	\
> -	x(journal_write,				29)	\
> -	x(read_promote,					30)	\
> -	x(read_bounce,					31)	\
> -	x(read_split,					33)	\
> -	x(read_retry,					32)	\
> -	x(read_reuse_race,				34)	\
> -	x(move_extent_read,				35)	\
> -	x(move_extent_write,				36)	\
> -	x(move_extent_finish,				37)	\
> -	x(move_extent_fail,				38)	\
> -	x(move_extent_start_fail,			39)	\
> -	x(copygc,					40)	\
> -	x(copygc_wait,					41)	\
> -	x(gc_gens_end,					42)	\
> -	x(gc_gens_start,				43)	\
> -	x(trans_blocked_journal_reclaim,		44)	\
> -	x(trans_restart_btree_node_reused,		45)	\
> -	x(trans_restart_btree_node_split,		46)	\
> -	x(trans_restart_fault_inject,			47)	\
> -	x(trans_restart_iter_upgrade,			48)	\
> -	x(trans_restart_journal_preres_get,		49)	\
> -	x(trans_restart_journal_reclaim,		50)	\
> -	x(trans_restart_journal_res_get,		51)	\
> -	x(trans_restart_key_cache_key_realloced,	52)	\
> -	x(trans_restart_key_cache_raced,		53)	\
> -	x(trans_restart_mark_replicas,			54)	\
> -	x(trans_restart_mem_realloced,			55)	\
> -	x(trans_restart_memory_allocation_failure,	56)	\
> -	x(trans_restart_relock,				57)	\
> -	x(trans_restart_relock_after_fill,		58)	\
> -	x(trans_restart_relock_key_cache_fill,		59)	\
> -	x(trans_restart_relock_next_node,		60)	\
> -	x(trans_restart_relock_parent_for_fill,		61)	\
> -	x(trans_restart_relock_path,			62)	\
> -	x(trans_restart_relock_path_intent,		63)	\
> -	x(trans_restart_too_many_iters,			64)	\
> -	x(trans_restart_traverse,			65)	\
> -	x(trans_restart_upgrade,			66)	\
> -	x(trans_restart_would_deadlock,			67)	\
> -	x(trans_restart_would_deadlock_write,		68)	\
> -	x(trans_restart_injected,			69)	\
> -	x(trans_restart_key_cache_upgrade,		70)	\
> -	x(trans_traverse_all,				71)	\
> -	x(transaction_commit,				72)	\
> -	x(write_super,					73)	\
> -	x(trans_restart_would_deadlock_recursion_limit,	74)	\
> -	x(trans_restart_write_buffer_flush,		75)	\
> -	x(trans_restart_split_race,			76)	\
> -	x(write_buffer_flush_slowpath,			77)	\
> -	x(write_buffer_flush_sync,			78)
> +#define BCH_PERSISTENT_COUNTERS()					\
> +	x(io_read,					0,	512)	\
> +	x(io_write,					1,	512)	\
> +	x(io_move,					2,	512)	\
> +	x(bucket_invalidate,				3,	1)	\
> +	x(bucket_discard,				4,	1)	\
> +	x(bucket_alloc,					5,	1)	\
> +	x(bucket_alloc_fail,				6,	1)	\
> +	x(btree_cache_scan,				7,	1)	\
> +	x(btree_cache_reap,				8,	1)	\
> +	x(btree_cache_cannibalize,			9,	1)	\
> +	x(btree_cache_cannibalize_lock,			10,	1)	\
> +	x(btree_cache_cannibalize_lock_fail,		11,	1)	\
> +	x(btree_cache_cannibalize_unlock,		12,	1)	\
> +	x(btree_node_write,				13,	1)	\
> +	x(btree_node_read,				14,	1)	\
> +	x(btree_node_compact,				15,	1)	\
> +	x(btree_node_merge,				16,	1)	\
> +	x(btree_node_split,				17,	1)	\
> +	x(btree_node_rewrite,				18,	1)	\
> +	x(btree_node_alloc,				19,	1)	\
> +	x(btree_node_free,				20,	1)	\
> +	x(btree_node_set_root,				21,	1)	\
> +	x(btree_path_relock_fail,			22,	1)	\
> +	x(btree_path_upgrade_fail,			23,	1)	\
> +	x(btree_reserve_get_fail,			24,	1)	\
> +	x(journal_entry_full,				25,	1)	\
> +	x(journal_full,					26,	1)	\
> +	x(journal_reclaim_finish,			27,	1)	\
> +	x(journal_reclaim_start,			28,	1)	\
> +	x(journal_write,				29,	1)	\
> +	x(read_promote,					30,	1)	\
> +	x(read_bounce,					31,	1)	\
> +	x(read_split,					33,	1)	\
> +	x(read_retry,					32,	1)	\
> +	x(read_reuse_race,				34,	1)	\
> +	x(move_extent_read,				35,	512)	\
> +	x(move_extent_write,				36,	512)	\
> +	x(move_extent_finish,				37,	512)	\
> +	x(move_extent_fail,				38,	1)	\
> +	x(move_extent_start_fail,			39,	1)	\
> +	x(copygc,					40,	1)	\
> +	x(copygc_wait,					41,	1)	\
> +	x(gc_gens_end,					42,	1)	\
> +	x(gc_gens_start,				43,	1)	\
> +	x(trans_blocked_journal_reclaim,		44,	1)	\
> +	x(trans_restart_btree_node_reused,		45,	1)	\
> +	x(trans_restart_btree_node_split,		46,	1)	\
> +	x(trans_restart_fault_inject,			47,	1)	\
> +	x(trans_restart_iter_upgrade,			48,	1)	\
> +	x(trans_restart_journal_preres_get,		49,	1)	\
> +	x(trans_restart_journal_reclaim,		50,	1)	\
> +	x(trans_restart_journal_res_get,		51,	1)	\
> +	x(trans_restart_key_cache_key_realloced,	52,	1)	\
> +	x(trans_restart_key_cache_raced,		53,	1)	\
> +	x(trans_restart_mark_replicas,			54,	1)	\
> +	x(trans_restart_mem_realloced,			55,	1)	\
> +	x(trans_restart_memory_allocation_failure,	56,	1)	\
> +	x(trans_restart_relock,				57,	1)	\
> +	x(trans_restart_relock_after_fill,		58,	1)	\
> +	x(trans_restart_relock_key_cache_fill,		59,	1)	\
> +	x(trans_restart_relock_next_node,		60,	1)	\
> +	x(trans_restart_relock_parent_for_fill,		61,	1)	\
> +	x(trans_restart_relock_path,			62,	1)	\
> +	x(trans_restart_relock_path_intent,		63,	1)	\
> +	x(trans_restart_too_many_iters,			64,	1)	\
> +	x(trans_restart_traverse,			65,	1)	\
> +	x(trans_restart_upgrade,			66,	1)	\
> +	x(trans_restart_would_deadlock,			67,	1)	\
> +	x(trans_restart_would_deadlock_write,		68,	1)	\
> +	x(trans_restart_injected,			69,	1)	\
> +	x(trans_restart_key_cache_upgrade,		70,	1)	\
> +	x(trans_traverse_all,				71,	1)	\
> +	x(transaction_commit,				72,	1)	\
> +	x(write_super,					73,	1)	\
> +	x(trans_restart_would_deadlock_recursion_limit,	74,	1)	\
> +	x(trans_restart_write_buffer_flush,		75,	1)	\
> +	x(trans_restart_split_race,			76,	1)	\
> +	x(write_buffer_flush_slowpath,			77,	1)	\
> +	x(write_buffer_flush_sync,			78,	1)
>  
>  enum bch_persistent_counters {
>  #define x(t, n, ...) BCH_COUNTER_##t,
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index 97733c766948..8c52a7aed45d 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -509,10 +509,12 @@ SHOW(bch2_fs_counters)
>  
>  	printbuf_tabstop_push(out, 32);
>  
> -	#define x(t, ...) \
> +	#define x(t, n, u, ...) \
>  		if (attr == &sysfs_##t) {					\
>  			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
>  			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
> +			counter *= u;						\
> +			counter_since_mount *= u;				\
>  			prt_printf(out, "since mount:\t");			\
>  			prt_human_readable_u64(out, counter_since_mount);	\
>  			prt_newline(out);					\
> -- 
> 2.34.1
> 
