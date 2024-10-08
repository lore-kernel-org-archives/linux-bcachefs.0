Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D313BC2F
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408951; cv=none; b=sg1C7WNeSuB/RS+T1FmGhjssAWzcd0X3hFJQDKlhrTwyl95xnhIC9DWaUk1VAv6j1JfrHYBlmjC6RY/prNbXZtmWqbDqO5xfklxLNpnZkN7fg9smxLYbSO6mVaEMtM4dCy7JRlanAnVko+jAtcPA03u8i2XJk09hz5fkpvtSqo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408951; c=relaxed/simple;
	bh=fmx+kKRskaFuAoHNQTqdkHGm8anVUxreJg0tHUVPfQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dypso881ZYLIsY+fPE3nlstOt3Bok0bsoObhGF0NZAbWSw1/R9zgz2Yv5D4mLbtCkskNmG1yCz/fFcQ4U50TkgnTrWqSIuj2dU048wK+IQemqLZ989pTZEt9u1iuvnl970G65rolCv8TN/DAdEy+I2JBhyfTUFrXlIDuVDlq9sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K3Vb17DT; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K3Vb17DT"
Date: Tue, 8 Oct 2024 13:35:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728408946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yEQyRDxwoTXnkQmR+k2WGZTNNBfiTw39/YKIDgRlXY0=;
	b=K3Vb17DTMShwFlIneOCSEKcLxbe5oFtOVI2U4YSMLqV9HFbUCI4nxWUISiNlCHq3grDF5e
	8xGIj+Qquky75ESR/sF6L2hgVC9jkSEh60OxAGC7MUVIS9HqCV5uvFbXWu3bX/m6+ZoBtK
	IQI/hvOkz4IiQIZlSXS/SkH3+tOvh3o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix state lock involved deadlock
Message-ID: <gwghnijn3raukfbkwdkcwzycmkm7tlqxug6v7gqugecjkbvwtj@psxokmixu2ig>
References: <20241008173305.1736377-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008173305.1736377-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 01:33:05AM GMT, Alan Huang wrote:
> We increased write ref, if the fs went to RO, that would lead to
> a deadlock, it actually happens:
> 
> 00171 ========= TEST   generic/279
> 00171
> 00172 bcachefs (vdb): starting version 1.12: rebalance_work_acct_fix opts=nocow
> 00172 bcachefs (vdb): recovering from clean shutdown, journal seq 35
> 00172 bcachefs (vdb): accounting_read... done
> 00172 bcachefs (vdb): alloc_read... done
> 00172 bcachefs (vdb): stripes_read... done
> 00172 bcachefs (vdb): snapshots_read... done
> 00172 bcachefs (vdb): journal_replay... done
> 00172 bcachefs (vdb): resume_logged_ops... done
> 00172 bcachefs (vdb): going read-write
> 00172 bcachefs (vdb): done starting filesystem
> 00172 FSTYP         -- bcachefs
> 00172 PLATFORM      -- Linux/aarch64 farm3-kvm 6.11.0-rc1-ktest-g3e290a0b8e34 #7030 SMP Tue Oct  8 14:15:12 UTC 2024
> 00172 MKFS_OPTIONS  -- --nocow /dev/vdc
> 00172 MOUNT_OPTIONS -- /dev/vdc /mnt/scratch
> 00172
> 00172 bcachefs (vdc): starting version 1.12: rebalance_work_acct_fix opts=nocow
> 00172 bcachefs (vdc): initializing new filesystem
> 00172 bcachefs (vdc): going read-write
> 00172 bcachefs (vdc): marking superblocks
> 00172 bcachefs (vdc): initializing freespace
> 00172 bcachefs (vdc): done initializing freespace
> 00172 bcachefs (vdc): reading snapshots table
> 00172 bcachefs (vdc): reading snapshots done
> 00172 bcachefs (vdc): done starting filesystem
> 00173 bcachefs (vdc): shutting down
> 00173 bcachefs (vdc): going read-only
> 00173 bcachefs (vdc): finished waiting for writes to stop
> 00173 bcachefs (vdc): flushing journal and stopping allocators, journal seq 4
> 00173 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 6
> 00173 bcachefs (vdc): shutdown complete, journal seq 7
> 00173 bcachefs (vdc): marking filesystem clean
> 00173 bcachefs (vdc): shutdown complete
> 00173 bcachefs (vdb): shutting down
> 00173 bcachefs (vdb): going read-only
> 00361 INFO: task umount:6180 blocked for more than 122 seconds.
> 00361 Not tainted 6.11.0-rc1-ktest-g3e290a0b8e34 #7030
> 00361 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 00361 task:umount          state:D stack:0     pid:6180  tgid:6180  ppid:6176   flags:0x00000004
> 00361 Call trace:
> 00362 __switch_to (arch/arm64/kernel/process.c:556)
> 00362 __schedule (kernel/sched/core.c:5191 kernel/sched/core.c:6529)
> 00363 schedule (include/asm-generic/bitops/generic-non-atomic.h:128 include/linux/thread_info.h:192 include/linux/sched.h:2084 kernel/sched/core.c:6608 kernel/sched/core.c:6621)
> 00365 bch2_fs_read_only (fs/bcachefs/super.c:346 (discriminator 41))
> 00367 __bch2_fs_stop (fs/bcachefs/super.c:620)
> 00368 bch2_put_super (fs/bcachefs/fs.c:1942)
> 00369 generic_shutdown_super (include/linux/list.h:373 (discriminator 2) fs/super.c:650 (discriminator 2))
> 00371 bch2_kill_sb (fs/bcachefs/fs.c:2170)
> 00372 deactivate_locked_super (fs/super.c:434 fs/super.c:475)
> 00373 deactivate_super (fs/super.c:508)
> 00374 cleanup_mnt (fs/namespace.c:250 fs/namespace.c:1374)
> 00376 __cleanup_mnt (fs/namespace.c:1381)
> 00376 task_work_run (include/linux/sched.h:2024 kernel/task_work.c:224)
> 00377 do_notify_resume (include/linux/resume_user_mode.h:50 arch/arm64/kernel/entry-common.c:151)
> 00377 el0_svc (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/entry-common.c:171 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:713)
> 00377 el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
> 00378 el0t_64_sync (arch/arm64/kernel/entry.S:598)
> 00378 INFO: task tee:6182 blocked for more than 122 seconds.
> 00378 Not tainted 6.11.0-rc1-ktest-g3e290a0b8e34 #7030
> 00378 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 00378 task:tee             state:D stack:0     pid:6182  tgid:6182  ppid:533    flags:0x00000004
> 00378 Call trace:
> 00378 __switch_to (arch/arm64/kernel/process.c:556)
> 00378 __schedule (kernel/sched/core.c:5191 kernel/sched/core.c:6529)
> 00378 schedule (include/asm-generic/bitops/generic-non-atomic.h:128 include/linux/thread_info.h:192 include/linux/sched.h:2084 kernel/sched/core.c:6608 kernel/sched/core.c:6621)
> 00378 schedule_preempt_disabled (kernel/sched/core.c:6680)
> 00379 rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073 (discriminator 1))
> 00379 down_read (kernel/locking/rwsem.c:1529)
> 00381 bch2_gc_gens (fs/bcachefs/sb-members.h:77 fs/bcachefs/sb-members.h:88 fs/bcachefs/sb-members.h:128 fs/bcachefs/btree_gc.c:1240)
> 00383 bch2_fs_store_inner (fs/bcachefs/sysfs.c:473)
> 00385 bch2_fs_internal_store (fs/bcachefs/sysfs.c:417 fs/bcachefs/sysfs.c:580 fs/bcachefs/sysfs.c:576)
> 00386 sysfs_kf_write (fs/sysfs/file.c:137)
> 00387 kernfs_fop_write_iter (fs/kernfs/file.c:334)
> 00389 vfs_write (fs/read_write.c:497 fs/read_write.c:590)
> 00390 ksys_write (fs/read_write.c:643)
> 00391 __arm64_sys_write (fs/read_write.c:652)
> 00391 invoke_syscall.constprop.0 (arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
> 00392 do_el0_svc (include/linux/thread_info.h:127 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2) arch/arm64/kernel/syscall.c:151 (discriminator 2))
> 00392 el0_svc (arch/arm64/include/asm/irqflags.h:55 arch/arm64/include/asm/irqflags.h:76 arch/arm64/kernel/entry-common.c:165 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:713)
> 00392 el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
> 00392 el0t_64_sync (arch/arm64/kernel/entry.S:598)
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_gc.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
> index b5e0692f03c6..49df621b3e99 100644
> --- a/fs/bcachefs/btree_gc.c
> +++ b/fs/bcachefs/btree_gc.c
> @@ -1225,17 +1225,20 @@ int bch2_gc_gens(struct bch_fs *c)
>  	u64 b, start_time = local_clock();
>  	int ret;
>  
> -	/*
> -	 * Ideally we would be using state_lock and not gc_gens_lock here, but that
> -	 * introduces a deadlock in the RO path - we currently take the state
> -	 * lock at the start of going RO, thus the gc thread may get stuck:
> -	 */
>  	if (!mutex_trylock(&c->gc_gens_lock))
>  		return 0;
>  
>  	trace_and_count(c, gc_gens_start, c);
>  
> -	down_read(&c->state_lock);
> +	/*
> +	 * We have to use trylock here. Otherwise, we would
> +	 * introduce a deadlock in the RO path - we take the
> +	 * state lock at the start of going RO.
> +	 */
> +	if (!down_read_trylock(&c->state_lock)) {
> +		mutex_unlock(&c->gc_gens_lock);
> +		return 0;
> +	}

Makes sense...

>  
>  	for_each_member_device(c, ca) {
>  		struct bucket_gens *gens = bucket_gens(ca);
> -- 
> 2.45.2
> 
