Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BBBC4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 16:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjKEQ0k (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 11:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjKEQ0j (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 11:26:39 -0500
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [IPv6:2001:41d0:203:375::b6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25683D8
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 08:26:36 -0800 (PST)
Date:   Sun, 5 Nov 2023 11:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699201593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DH8J0Bs5RWRjS4D0mDE3eVLxFjDswAST8+//RpSj4XY=;
        b=JEN9wCe4Z0y0/ofdtKLUKDBEYZVXizoRvU7EnkjjzYGpO8pdAmrHc9wsjpVEkWSSJ1S7Mv
        wvhz7a6yiYSwEqpz5m8d7GkYSC1dnGSaPBQhBchLx8oNT7DzLly9jo6495cYXxLYVp827m
        8XmXAcdtQKXNWc3n10qV9W+Gmvu5pb4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mateusz Guzik <mjguzik@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <20231105162630.q25p2vz2egh7jb43@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Nov 05, 2023 at 01:38:49PM +0100, Mateusz Guzik wrote:
> Setup is a 24 core vm + 24G of ram, running debian 12 with top of
> master as of writing this e-mail, commit being:
> commit 1c41041124bd14dd6610da256a3da4e5b74ce6b1 (HEAD -> master,
> origin/master, origin/HEAD)
> Merge: b8cc56d0414e 9fd00df05e81
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Nov 4 16:25:36 2023 -1000
> 
>     Merge tag 'i3c/for-6.7' of
> git://git.kernel.org/pub/scm/linux/kernel/git/i3c/linux
> 
> I ran into it when trying to poke around at the fine-grained inode hash patch.
> 
> Reproduction instructions are here: https://people.freebsd.org/~mjg/fstree.tgz
> 
> Running it destabilizes the system after few minutes, for example
> hanging my ssh connection (interestingly running stuff over a serial
> port works fine). hung task detector reports a kernel thread and one
> of the workers, traces at the end of the e-mail.
> 
> I can create trees just fine if I limit it to one worker at a time.
> However, traversing them (again 20 workers, each with a dedicated
> tree) once more runs into trouble.
> 
> There are no issues when running this against xfs and ext4.
> 
> Side note: mkfs.bcachefs warns about xfs being on the volume, but is
> perfectly happy to format an existing bcachefs partition -- perhaps
> this should also ask if it was intended?
> 
> traces:
> INFO: task kworker/u48:0:11 blocked for more than 120 seconds.
>       Not tainted 6.6.0+ #386
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u48:0   state:D stack:0     pid:11    tgid:11    ppid:2
>    flags:0x00004000
> Workqueue: btree_update btree_interior_update_work
> Call Trace:
>  <TASK>
>  __schedule+0x3b0/0xaf0
>  ? bch2_path_get+0x5e/0x560
>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>  schedule+0x2e/0xd0
>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>  btree_interior_update_work+0x8a3/0x9e0
>  ? btree_interior_update_work+0x842/0x9e0
>  process_one_work+0x165/0x330
>  worker_thread+0x2f1/0x410
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xe1/0x110
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x2d/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
>  </TASK>
> 
> INFO: task createtree:3024 blocked for more than 120 seconds.
>       Not tainted 6.6.0+ #386
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:createtree      state:D stack:0     pid:3024  tgid:3024
> ppid:3011   flags:0x00000002
> Call Trace:
>  <TASK>
>  __schedule+0x3b0/0xaf0
>  ? __pfx_bch2_six_check_for_deadlock+0x10/0x10
>  schedule+0x2e/0xd0
>  six_lock_slowpath.constprop.0+0x10b/0x2e0
>  bch2_btree_node_get+0x33d/0x4c0
>  ? bch2_dirent_create+0x238/0x3e0
>  bch2_btree_path_traverse_one+0x212/0x8c0
>  ? bch2_btree_path_traverse_one+0xb2/0x8c0
>  ? bch2_dirent_create+0x238/0x3e0
>  bch2_btree_iter_peek_slot+0x106/0x6d0
>  ? btree_path_get_locks.constprop.0+0x3a/0x150
>  ? bch2_path_get+0x404/0x560
>  ? bch2_dirent_hash+0xd6/0x150
>  ? bch2_dirent_create+0xf6/0x3e0
>  bch2_dirent_create+0x238/0x3e0
>  ? bch2_create_trans+0x4d0/0x6c0
>  bch2_create_trans+0x518/0x6c0
>  ? chacha_block_generic+0x6f/0xb0
>  __bch2_create+0x1be/0x4e0
>  ? bch2_trans_iter_init_outlined+0x112/0x180
>  ? d_splice_alias+0x8e/0x2b0
>  ? bch2_create+0x26/0x60
>  bch2_create+0x26/0x60
>  path_openat+0xe9f/0x11d0
>  do_filp_open+0xb4/0x160
>  ? kmem_cache_alloc+0x15c/0x2b0
>  ? _raw_spin_unlock+0xa/0x30
>  do_sys_openat2+0x91/0xc0
>  __x64_sys_openat+0x6a/0xa0
>  do_syscall_64+0x32/0xf0
>  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> RIP: 0033:0x7fe7b1bdfe01
> RSP: 002b:00007ffee4ae0ea0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007fe7b1bdfe01
> RDX: 0000000000000042 RSI: 00007ffee4ae0f30 RDI: 00000000ffffff9c
> RBP: 00007ffee4ae0f30 R08: 0000000000000000 R09: 0000000000000064
> R10: 00000000000001ff R11: 0000000000000202 R12: 0000000000000263
> R13: 00000000000003e8 R14: 00007ffee4ae267c R15: 000055b2c0e97010
>  </TASK>
> 
> -- 
> Mateusz Guzik <mjguzik gmail.com>

Can you check btree_transactions in debugfs?
