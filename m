Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C523299AA1
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783004; cv=none; b=Ve69/UPZUtdZ7UFhuKjUHfJ2EGQS+MHUmsGIt7TIifPrVo5WwtBSZLnr5HAeGPc+BcboJMLANg+Mrsicb5bkZIpM66BeZ4nENytz4A/gv+UCOQoU7vjk+Z/0LGSrl4nVW/md36KpdQwqEasNI3F8BWIhoUCR/hUkcys9IEaf2Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783004; c=relaxed/simple;
	bh=58hAIIEH8vdKwKRSPiNFRmCes12SI6DNJtHwR+6x1f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9Vn/tbcgW2OqxdW8aVNQIMN7jgs1KDrbgWsJ7plFvnC3rMDaYdGoI520giDQ9dUtk2argnCxto9rzZaCEscchV1SiK8ef/7VkgndbMa+SgAwlxMp4GAiUj41takWvHZQ8EALJQUUmI74RKR6vweiJZXqYWzEWlND6XVhwkeFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GGhE1DEZ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GGhE1DEZ"
Date: Tue, 24 Jun 2025 12:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750782997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fBu1gwPvass4crFXwZYzD7wJ2DFGje+U2ElxT+bgfSE=;
	b=GGhE1DEZ4SZlK40CT/mHK4pKB/CY+/e+Zz6SfvQkxmF9XX83UehzLdTRL2IeQKFs2N3K5a
	HvOu8Ck+7+SQLPs7sIz62HOtowdGLVVmCaRkqDX+QKuJu0zGgP+H0uZqVFrpeNfdxbtTrD
	aMOm4Kixj0CpZtBgNUp1EgluTEr5hvg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+listdc301befec0a5cb43b3e@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly bcachefs report (Jun 2025)
Message-ID: <tbin6tz26snfbzztmhixz236hkyezv35honrdzzpi3rkgu4toq@kahnaeehxnul>
References: <685a562f.a00a0220.2e5631.005e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <685a562f.a00a0220.2e5631.005e.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 24, 2025 at 12:39:27AM -0700, syzbot wrote:
> Hello bcachefs maintainers/developers,
> 
> This is a 31-day syzbot report for the bcachefs subsystem.
> All related reports/information can be found at:
> https://syzkaller.appspot.com/upstream/s/bcachefs
> 
> During the period, 15 new issues were detected and 8 were fixed.
> In total, 102 issues are still open and 190 have already been fixed.
> 
> Some of the still happening issues:

Most of these are not terribly concerning, but...

> 
> Ref  Crashes Repro Title
> <1>  30829   Yes   INFO: task hung in bch2_copygc_stop
>                    https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
> <2>  7874    Yes   INFO: task hung in __closure_sync
>                    https://syzkaller.appspot.com/bug?extid=7bf808f7fe4a6549f36e
> <3>  3875    Yes   WARNING in bch2_trans_srcu_unlock
>                    https://syzkaller.appspot.com/bug?extid=1e515cab343dbe5aa38a
> <4>  1497    Yes   INFO: task hung in __bch2_fs_stop
>                    https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
> <5>  1236    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
>                    https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
> <6>  442     Yes   WARNING in bch2_trans_put


this one

>                    https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
> <7>  361     Yes   kernel panic: trans should be locked, unlocked by bch2_btree_update_start

we want these locking bugs gone.

ok this one is a bug users hit - I thought locking was fully sorted in
6.16, but apparently not.

Previously, the locking bugs (especially in 6.14) were showing up in
bch2_dev_metadata_drop(), which uses old style btree node iterators that
do a DFS btree walk.

Modern code just walks one level of the btree at a time, using
bch2_btree_iter_peek() - there's much less special purpose code and
strange corner cases this way.

So it looks like this is another instance of that - bch2_move_btree() is
using the old bch2_btree_iter_peek_node() code.

Perhaps it's time to just delete all that stuff.

bch2_move_btree() can probably be deleted and replaced with a call to
bch2_move_data_btree() - that's part of the main data move path, and it
recently gained the ability to walk keys in interior btree nodes.

Looking at the stace, we have
[   91.068473][ T5330] Kernel panic - not syncing: trans should be locked, unlocked by bch2_btree_update_start+0x1700/0x1dc0
[   91.074232][ T5330] CPU: 0 UID: 0 PID: 5330 Comm: syz.0.0 Not tainted 6.16.0-rc1-syzkaller-00203-g4774cfe3543a #0 PREEMPT(full) 
[   91.079637][ T5330] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
[   91.085068][ T5330] Call Trace:
[   91.086510][ T5330]  <TASK>
[   91.087883][ T5330]  dump_stack_lvl+0x99/0x250
[   91.090102][ T5330]  ? __asan_memcpy+0x40/0x70
[   91.092501][ T5330]  ? __pfx_dump_stack_lvl+0x10/0x10
[   91.095374][ T5330]  ? __pfx__printk+0x10/0x10
[   91.097423][ T5330]  panic+0x2db/0x790
[   91.099118][ T5330]  ? bch2_btree_update_start+0x1700/0x1dc0
[   91.101917][ T5330]  ? bch2_move_btree+0x44e/0xc60
[   91.104349][ T5330]  ? __pfx_panic+0x10/0x10
[   91.106602][ T5330]  ? __closure_wake_up+0xa2/0xb0
[   91.109239][ T5330]  ? bch2_btree_update_free+0x39e/0x3f0
[   91.111867][ T5330]  ? bch2_btree_update_start+0x1700/0x1dc0
[   91.114541][ T5330]  bch2_trans_unlocked_or_in_restart_error+0xb0/0x110
[   91.117731][ T5330]  bch2_path_get+0x108c/0x1540
[   91.120398][ T5330]  ? bch2_btree_node_rewrite+0x17e/0x1120
[   91.123155][ T5330]  ? __pfx_bch2_btree_update_start+0x10/0x10
[   91.125844][ T5330]  ? bch2_move_btree+0x44e/0xc60
[   91.128330][ T5330]  ? __pfx_bch2_path_get+0x10/0x10
[   91.131060][ T5330]  ? rcu_is_watching+0x15/0xb0
[   91.135248][ T5330]  ? bch2_trans_downgrade+0x228/0x360
[   91.137691][ T5330]  ? rcu_is_watching+0x15/0xb0
[   91.139975][ T5330]  ? __bch2_btree_path_downgrade+0x35a/0x5e0
[   91.143245][ T5330]  ? bch2_trans_node_iter_init+0x2d7/0x5e0
[   91.146160][ T5330]  bch2_trans_node_iter_init+0x348/0x5e0

So the real bug is that we're in a restart when we call
bch2_trans_node_iter_init(), meaning we didn't call bch2_trans_begin()
after we got a restart error.

I do not see the bug on a cursory glance, but the code is trickier that
it should be.

We're aiming to get rid of this sort of open coded restart handling and
bch2_trans_begin(0 calls; modern code generally uses lockrestart_do(),
commit_do(), or a looping macro that does the restart handling itself -
e.g. for_each_btree_key()

        for (btree = start.btree;                                                                                                                                                                                                                                                                                                 
             btree <= min_t(unsigned, end.btree, btree_id_nr_alive(c) - 1);                                                                                                                                                                                                                                                       
             btree ++) {                                                                                                                                                                                                                                                                                                          
                stats->pos = BBPOS(btree, POS_MIN);                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                  
                if (!bch2_btree_id_root(c, btree)->b)                                                                                                                                                                                                                                                                             
                        continue;                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                  
                bch2_trans_node_iter_init(trans, &iter, btree, POS_MIN, 0, 0,                                                                                                                                                                                                                                                     
                                          BTREE_ITER_prefetch);                                                                                                                                                                                                                                                                   
retry:                                                                                                                                                                                                                                                                                                                            
                ret = 0;                                                                                                                                                                                                                                                                                                          
                while (bch2_trans_begin(trans),                                                                                                                                                                                                                                                                                   
                       (b = bch2_btree_iter_peek_node(trans, &iter)) &&                                                                                                                                                                                                                                                           
                       !(ret = PTR_ERR_OR_ZERO(b))) {                                                                                                                                                                                                                                                                             
                        if (kthread && kthread_should_stop())                                                                                                                                                                                                                                                                     
                                break;                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                  
                        if ((cmp_int(btree, end.btree) ?:                                                                                                                                                                                                                                                                         
                             bpos_cmp(b->key.k.p, end.pos)) > 0)                                                                                                                                                                                                                                                                  
                                break;                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                  
                        stats->pos = BBPOS(iter.btree_id, iter.pos);                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                  
                        if (!pred(c, arg, b, &io_opts, &data_opts))                                                                                                                                                                                                                                                               
                                goto next;                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                  
                        ret = bch2_btree_node_rewrite(trans, &iter, b, 0, 0) ?: ret;                                                                                                                                                                                                                                              
                        if (bch2_err_matches(ret, BCH_ERR_transaction_restart))                                                                                                                                                                                                                                                   
                                continue;                                                                                                                                                                                                                                                                                         
                        if (ret)                                                                                                                                                                                                                                                                                                  
                                break;                                                                                                                                                                                                                                                                                            
next:                                                                                                                                                                                                                                                                                                                             
                        bch2_btree_iter_next_node(trans, &iter);                                                                                                                                                                                                                                                                  
                }                                                                                                                                                                                                                                                                                                                 
                if (bch2_err_matches(ret, BCH_ERR_transaction_restart))                                                                                                                                                                                                                                                           
                        goto retry;                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                  
                bch2_trans_iter_exit(trans, &iter);                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                  
                if (kthread && kthread_should_stop())                                                                                                                                                                                                                                                                             
                        break;                                                                                                                                                                                                                                                                                                    
        }
