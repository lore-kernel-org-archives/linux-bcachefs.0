Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACB7280A3A
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Apr 2025 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745426740; cv=none; b=kW3IkIIDFSMpLRMPdonrRLFN+NSjck9JB3b9fZc+oghM1pn2tOEidnngrqf2sx31NaSK/7MyF6FoHFYjBLMayUn45GjDCBJ2TBYsqD3Gbs7fjdGqS2ygVNd/CJX/NxVa4SlByZZHmDSR5U6O5NY+bUFC/fSb0SGPUAumjaKPFsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745426740; c=relaxed/simple;
	bh=xqNKIkniXMZ2Bue/bRImQv3X6cquBQMuJT+ZQkIdRs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMCfiBxkkzb2Zow16dT4DYhXacrDpYRHR7mnQeYSJbWQhVINx1dgD+EwlLQmD8FgUJAhke6mxpSoRq1/P77mroqLQ6sHzYyzquo+2QK+ev0qzsnzaAswXyYloS3QxxDUFb6wgwKo6uAi4GxA7vq8F+5lpxNtnk6Xt+hVPY4+uRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CvpUDcyj; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CvpUDcyj"
Date: Wed, 23 Apr 2025 12:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745426726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwssp7L2YuKXDB1wtg97P/TTd8hGa1LcOFzKxxSHNeI=;
	b=CvpUDcyjUn7Rnm9crssuzquRN6bp2N+iYO1ZrLUqYuShSStd+B4F5EOqHutHpwBChYolBV
	1M23YssKmkRZJ804rGUTeWN5dudeSmkVY/IMEeqepGZsP4bHW+dZrwmYLKB/uw248XdpvW
	RcwJnkX7s/RWoXcN7/xDu13i34O2/qU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: I Hsin Cheng <richard120310@gmail.com>
Cc: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com, 
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	davem@davemloft.net, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Fix unit-value within btree_bounce_alloc()
Message-ID: <ur4a24w2wb3euh3ej7ybeqnvmqyhzmqp2wwsjtilh6mfetv45l@qlxs3vggfq5h>
References: <000000000000736bd406151001d7@google.com>
 <20250423163718.194316-1-richard120310@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423163718.194316-1-richard120310@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 24, 2025 at 12:37:18AM +0800, I Hsin Cheng wrote:
> Use "kvzalloc()" instead of "kvmalloc()" in btree_bounce_alloc() to
> prevent uninit-value issue.
> 
> Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
> Fixes: cb6fc943b650 ("bcachefs: kill kvpmalloc()")
> Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
> ---
> syzbot reported an uninit-value issue. [1]
> 
> Though the uninit value was detected in the context of crc32_body(), the
> memory was actually allocated in "btree_bounce_alloc()". Use
> "kvzalloc()" to allocate the memory can solve the issue, and I've tested
> against syzbot. [2]
> 
> If there're any further tests needed to be performed, please let me
> know. I'll be more than happy to assist you with that, thanks !

See Documentation/filesystems/bcachefs/SubmittingPatches.

And this isn't the correct fix - the correct fix is already in Linus's
tree.

> 
> [1]:
> BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:110 [inline]
> BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
> BUG: KMSAN: uninit-value in __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
>  crc32_body lib/crc32.c:110 [inline]
>  crc32_le_generic lib/crc32.c:179 [inline]
>  __crc32c_le_base+0x43c/0xd80 lib/crc32.c:201
>  chksum_update+0x5b/0xd0 crypto/crc32c_generic.c:88
>  crypto_shash_update+0x79/0xa0 crypto/shash.c:52
>  crc32c+0xba/0x170 lib/libcrc32c.c:47
>  bch2_checksum_update+0x106/0x1d0 fs/bcachefs/checksum.c:83
>  bch2_checksum+0x3c5/0x7c0 fs/bcachefs/checksum.c:216
>  __bch2_btree_node_write+0x528c/0x67c0 fs/bcachefs/btree_io.c:2151
>  bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
>  btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
>  __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
>  bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
>  journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
>  __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
>  bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
>  kthread+0x3e2/0x540 kernel/kthread.c:389
>  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> Uninit was stored to memory at:
>  memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
>  bkey_p_copy fs/bcachefs/bkey.h:46 [inline]
>  bch2_sort_keys+0x1b4d/0x2cb0 fs/bcachefs/bkey_sort.c:194
>  __bch2_btree_node_write+0x3acd/0x67c0 fs/bcachefs/btree_io.c:2100
>  bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
>  btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
>  __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
>  bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
>  journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
>  __bch2_journal_reclaim+0xd88/0x1610 fs/bcachefs/journal_reclaim.c:685
>  bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:727
>  kthread+0x3e2/0x540 kernel/kthread.c:389
>  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> Uninit was created at:
>  __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
>  __do_kmalloc_node mm/slub.c:4027 [inline]
>  __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
>  kmalloc_node include/linux/slab.h:648 [inline]
>  kvmalloc_node+0xc0/0x2d0 mm/util.c:634
>  kvmalloc include/linux/slab.h:766 [inline]
>  btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
>  bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
>  btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
>  bch2_btree_node_read+0x3d42/0x4b50
>  __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
>  bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
>  read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
>  bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
>  bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
>  bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
>  bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
>  legacy_get_tree+0x114/0x290 fs/fs_context.c:662
>  vfs_get_tree+0xa7/0x570 fs/super.c:1779
>  do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
>  path_mount+0x742/0x1f20 fs/namespace.c:3679
>  do_mount fs/namespace.c:3692 [inline]
>  __do_sys_mount fs/namespace.c:3898 [inline]
>  __se_sys_mount+0x725/0x810 fs/namespace.c:3875
>  __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
>  x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> [2]:
> https://lore.kernel.org/all/000000000000736bd406151001d7@google.com/T/#m748384a36239a7f66e63cfde949e3db6bf14d5c6
> 
> syzbot reply me with:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> Tested-by: syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         614da38e Merge tag 'hid-for-linus-2024051401' of git:/..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> console output: https://syzkaller.appspot.com/x/log.txt?x=10be763f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=49342144b6a907af
> dashboard link: https://syzkaller.appspot.com/bug?extid=549710bad9c798e25b15
> compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=15b99a6f980000
> 
> Note: testing is done by a robot and is best-effort only.
> 
> Best regards,
> I Hsin Cheng
> ---
>  fs/bcachefs/btree_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index debb0edc3455..dc00c5273ffe 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -115,7 +115,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_t size,
>  	BUG_ON(size > c->opts.btree_node_size);
>  
>  	*used_mempool = false;
> -	p = kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
> +	p = kvzalloc(size, __GFP_NOWARN|GFP_NOWAIT);
>  	if (!p) {
>  		*used_mempool = true;
>  		p = mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
> -- 
> 2.43.0
> 
