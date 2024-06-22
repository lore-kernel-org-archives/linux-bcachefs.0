Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8171E16C445
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Jun 2024 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719063832; cv=none; b=TDHWuN5HbUm01V2SAGf++c0zOL5Ycf0OQtlf8W+MLjKam3fa3pYwY/iNq2rpQqXaaj902ypgB1mNKu6EVxaRo0pKs1cVlsGnVhTEsTOkzUWYt79DXgqtLUbaiDdYETQPqnhSVeRF6AQgvyhqSjb0D7OQNiMYVPshb1z1KArntgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719063832; c=relaxed/simple;
	bh=Ss3hbPRbsgSXVijcPTiNw7QzpshL51MWDUghPWwv7Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0WOP288/4V00SXZy5CAZRdj/+SshvTIveYQW3Y/Y7rJDOWcdeyMfX8i8rf7Sspe1Zbg85LYKAN4L2y3q9PB5E7nJ2VxcbuaTAIG3ytWZzNFk47cGETAPgam9qYbehGoV3BqfVlL2JcjtQjI9ORGQlVf5quifqwjZnncbnMn4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hb8qfco1; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hb8qfco1"
X-Envelope-To: lizhi.xu@windriver.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719063826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LRZAmMqJKIn14niIRNgriXgIOVU0yHmhEJpzSzRShXs=;
	b=hb8qfco15DblCSmmQUCBBB+K8xww3gNNF5672JpQrukqK9uxgvIKru6zO6xgOZzxWGvS8S
	/DsLMB4n7KI/pmQxIMzeynF8+djDYZ7bVOJK4PW2OPcP8VchQcr+X9Ax8nin4BNveibSKu
	Y3QNbUd2z/v14eVB9U6Q+VQi7n3CsbU=
X-Envelope-To: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Sat, 22 Jun 2024 09:43:41 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com, 
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: fix deadlock in bch2_gc_mark_key
Message-ID: <zlg74w7gvxf4pyoudahzjswbxa3sadaoqhrv6ntoqngz6w5krx@egt6tjqbmwa4>
References: <000000000000c43781061b5fbdcd@google.com>
 <20240621093423.1874314-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621093423.1874314-1-lizhi.xu@windriver.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 21, 2024 at 05:34:23PM +0800, Lizhi Xu wrote:
> [Syz reported]
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&c->btree_root_lock){+.+.}-{3:3}:
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
>        __mutex_lock_common kernel/locking/mutex.c:608 [inline]
>        __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
>        bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633
>        bch2_fs_mark_clean+0x2cc/0x6d0 fs/bcachefs/sb-clean.c:376
>        bch2_fs_read_only+0x1101/0x1210 fs/bcachefs/super.c:381
>        __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:615
>        generic_shutdown_super+0x136/0x2d0 fs/super.c:642
>        bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2037
>        deactivate_locked_super+0xc4/0x130 fs/super.c:473
>        cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
>        task_work_run+0x24f/0x310 kernel/task_work.c:180
>        ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
>        ptrace_report_syscall include/linux/ptrace.h:415 [inline]
>        ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
>        syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
>        syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
>        syscall_exit_to_user_mode+0x273/0x370 kernel/entry/common.c:218
>        do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&c->sb_lock){+.+.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3134 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3253 [inline]
>        validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
>        __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
>        __mutex_lock_common kernel/locking/mutex.c:608 [inline]
>        __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
>        bch2_gc_mark_key+0xc66/0x1010 fs/bcachefs/btree_gc.c:600
>        bch2_gc_btree fs/bcachefs/btree_gc.c:648 [inline]
>        bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
>        bch2_check_allocations+0x3e06/0xcca0 fs/bcachefs/btree_gc.c:1224
>        bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
>        bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
>        bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
>        bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1035
>        bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2127
>        bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
>        legacy_get_tree+0xee/0x190 fs/fs_context.c:662
>        vfs_get_tree+0x90/0x2a0 fs/super.c:1780
>        do_new_mount+0x2be/0xb40 fs/namespace.c:3352
>        do_mount fs/namespace.c:3692 [inline]
>        __do_sys_mount fs/namespace.c:3898 [inline]
>        __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&c->btree_root_lock);
>                                lock(&c->sb_lock);
>                                lock(&c->btree_root_lock);
>   lock(&c->sb_lock);
> 
> [Analysis]
> bch2_btree_roots_to_journal_entries() does not need to hold sb_lock, so
> we can remove sb_lock to avoid deadlock.
> 
> Reported-by: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/bcachefs/sb-clean.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
> index 47f10ab57f40..7a75615ba745 100644
> --- a/fs/bcachefs/sb-clean.c
> +++ b/fs/bcachefs/sb-clean.c
> @@ -373,6 +373,7 @@ void bch2_fs_mark_clean(struct bch_fs *c)
>  
>  	entry = sb_clean->start;
>  	bch2_journal_super_entries_add_common(c, &entry, 0);
> +	mutex_unlock(&c->sb_lock);
>  	entry = bch2_btree_roots_to_journal_entries(c, entry, 0);
>  	BUG_ON((void *) entry > vstruct_end(&sb_clean->field));
>  
> @@ -383,6 +384,7 @@ void bch2_fs_mark_clean(struct bch_fs *c)
>  	 * this should be in the write path, and we should be validating every
>  	 * superblock section:
>  	 */
> +	mutex_lock(&c->sb_lock);
>  	ret = bch2_sb_clean_validate_late(c, sb_clean, WRITE);
>  	if (ret) {
>  		bch_err(c, "error writing marking filesystem clean: validate error");

that's not the right fix, you can't just arbitrarily drop and retake
locks like that
