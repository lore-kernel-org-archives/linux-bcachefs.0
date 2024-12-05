Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0759B227B9D;
	Thu,  5 Dec 2024 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421910; cv=none; b=Vk47BhuffsGtLs8oBiXVxdo9kkrUVmvt2ryY1B6iyLJ5FkDgdcEAmwlwoPy4YNNoyF4hLSYKRLok0pbnUtVhhQhKZPxzEtE1biJpnu5Bj1fnFr0iYJ81EzJ5PixRSenQ718ZLiI+T+uvw3H/jqlkpDVJEJi+XQJXmpLiydCN5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421910; c=relaxed/simple;
	bh=VmGgdagh43bQ9diy6vHcEw7GrkKLzDdF9+rbK43HAkg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8aYGKVTH8pXbbpxzbFKHYhG77nemWh9WU57C/v/3NsleNXKXdqm/R1LzbKtqKbn89ggC+H7oWUa93O3ajykKtC7tJky0ACKEkdh9/AMpYCZopIA8z/XuF/R8zIPiMdZKU4SkSwaa1vMijLpAD9A8dNkUMe06yysbjfSgsAxcrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DTncR6Y5; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DTncR6Y5"
Date: Thu, 5 Dec 2024 13:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733421903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C/0wAm6mwf+xx0gp44Kb3h1fQJN2+oekj+V8ngaLLkk=;
	b=DTncR6Y5mA5Y7j8JEDZCiuaVLQqxXdm6EI5UZvAiaW6dRKVGrQgzRI55HKE5UDTl/I/80w
	anM2v6U54fYUgOn9SDwik2PN/YKiTOQHOsPzHp/5gx9c3fB3sTEpm1AgfRWwegc/cOY8Ps
	fq2GrnvkH/uFuQUsJuv8IyHLYe4sIfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
X-Migadu-Flow: FLOW_OUT

On 6.13-rc1, I'm now seeing a ton of test failures due to this warning -
what gives?

00104 ========= TEST   generic/017
00104        run fstests generic/017 at 2024-12-05 11:47:43
00104 spectre-v4 mitigation disabled by command-line option
00106 bcachefs (vdc): starting version 1.13: inode_has_child_snapshots
00106 bcachefs (vdc): initializing new filesystem
00106 bcachefs (vdc): going read-write
00106 bcachefs (vdc): marking superblocks
00106 bcachefs (vdc): initializing freespace
00106 bcachefs (vdc): done initializing freespace
00106 bcachefs (vdc): reading snapshots table
00106 bcachefs (vdc): reading snapshots done
00106 bcachefs (vdc): done starting filesystem
00200 ------------[ cut here ]------------
00200 WARNING: CPU: 8 PID: 12571 at arch/arm64/kernel/stacktrace.c:223 arch_stack_walk+0x2c0/0x388
00200 Modules linked in:
00200 CPU: 8 UID: 0 PID: 12571 Comm: cat Not tainted 6.13.0-rc1-ktest-gdf1fce23d033 #10877
00200 Hardware name: linux,dummy-virt (DT)
00200 pstate: 80001005 (Nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
00200 pc : arch_stack_walk+0x2c0/0x388
00200 lr : arch_stack_walk+0x1f4/0x388
00200 sp : ffffff80ca757b00
00200 x29: ffffff80ca757b00 x28: ffffff80d6783758 x27: 000000000000036f
00200 x26: ffffff80d6783780 x25: ffffff80c19de180 x24: ffffff80c273ee40
00200 x23: ffffffc080022708 x22: ffffffc080025828 x21: ffffff80ca757be8
00200 x20: ffffffc0800c98c8 x19: ffffff80d8533d10 x18: ffffffffffffffff
00200 x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
00200 x14: 0000000000000000 x13: ffffff80d6c92000 x12: 0000000000000000
00200 x11: 0000000000000000 x10: 000000000000000a x9 : ffffffc08086beec
00200 x8 : ffffff80ca757bc0 x7 : 0000000000000000 x6 : ffffff80d8533d28
00200 x5 : ffffff80ca757b60 x4 : ffffff80d8534000 x3 : ffffff80ca757b40
00200 x2 : 0000000000000018 x1 : ffffff80d8533d10 x0 : 0000000000000000
00200 Call trace:
00200  arch_stack_walk+0x2c0/0x388 (P)
00200  arch_stack_walk+0x1f4/0x388 (L)
00200  stack_trace_save_tsk+0x90/0xd8
00200  bch2_save_backtrace+0x68/0x160
00200  bch2_prt_task_backtrace+0x30/0xb8
00200  bch2_btree_transactions_read+0xe0/0x1f0
00200  full_proxy_read+0x60/0xd0
00200  vfs_read+0x80/0x2d8
00200  ksys_read+0x5c/0xf0
00200  __arm64_sys_read+0x20/0x30
00200  invoke_syscall.constprop.0+0x54/0xe8
00200  do_el0_svc+0x44/0xc8
00200  el0_svc+0x18/0x58
00200  el0t_64_sync_handler+0x104/0x130
00200  el0t_64_sync+0x154/0x158
00200 ---[ end trace 0000000000000000 ]---
00233 hrtimer: interrupt took 49506640 ns
00493 bcachefs (vdb): shutting down
00493 bcachefs (vdb): going read-only
00493 bcachefs (vdb): finished waiting for writes to stop
00493 bcachefs (vdb): flushing journal and stopping allocators, journal seq 18
00493 bcachefs (vdb): flushing journal and stopping allocators complete, journal seq 18
00493 bcachefs (vdb): clean shutdown complete, journal seq 19
00493 bcachefs (vdb): marking filesystem clean
00493 bcachefs (vdb): shutdown complete
00493 bcachefs (vdc): shutting down
00493 bcachefs (vdc): going read-only
00493 bcachefs (vdc): finished waiting for writes to stop
00493 bcachefs (vdc): flushing journal and stopping allocators, journal seq 41457
00493 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 41459
00493 bcachefs (vdc): clean shutdown complete, journal seq 41460
00493 bcachefs (vdc): marking filesystem clean
00493 bcachefs (vdc): shutdown complete
00495 bcachefs (vdc): starting version 1.13: inode_has_child_snapshots
00495 bcachefs (vdc): recovering from clean shutdown, journal seq 41460
00495 bcachefs (vdc): accounting_read... done
00495 bcachefs (vdc): alloc_read... done
00495 bcachefs (vdc): stripes_read... done
00495 bcachefs (vdc): snapshots_read... done
00495 bcachefs (vdc): going read-write
00495 bcachefs (vdc): journal_replay... done
00495 bcachefs (vdc): resume_logged_ops... done
00495 bcachefs (vdc): delete_dead_inodes... done
00495 bcachefs (vdc): done starting filesystem
00495 bcachefs (vdc): shutting down
00495 bcachefs (vdc): going read-only
00495 bcachefs (vdc): finished waiting for writes to stop
00495 bcachefs (vdc): flushing journal and stopping allocators, journal seq 41460
00495 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 41460
00495 bcachefs (vdc): clean shutdown complete, journal seq 41461
00495 bcachefs (vdc): marking filesystem clean
00495 bcachefs (vdc): shutdown complete
00495 _check_dmesg: something found in dmesg (see /ktest-out/xfstests/generic/017.dmesg)
00496 
00496 /ktest-out/xfstests/generic/017.full:
00496 cat: /ktest-out/xfstests/generic/017.full: No such file or directory
00496 ========= FAILED generic/017 in 391s, exit status 0

